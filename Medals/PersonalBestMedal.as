class PersonalBestMedal : Medal
{
	bool IsVisible() override { return showPbest; }
	protected string GetName() override { return pbestText; }
	protected int GetScoreAsync(CGameCtnChallenge@ map) override
	{
		int score = -1;

		auto app = GetApp();
		auto network = cast<CTrackManiaNetwork>(app.Network);

#if TMNEXT

		if(network.ClientManiaAppPlayground !is null) {
			auto scoreMgr = network.ClientManiaAppPlayground.ScoreMgr;
			// from: OpenplanetNext\Extract\Titles\Trackmania\Scripts\Libs\Nadeo\TMNext\TrackMania\Menu\Constants.Script.txt
			// ScopeType can be: "Season", "PersonalBest"
			// GameMode can be: "TimeAttack", "Follow", "ClashTime"
			score = scoreMgr.Map_GetRecord_v2(0x100, map.MapInfo.MapUid, "PersonalBest", "", "TimeAttack", "");
		}

#elif TURBO

		if(network.TmRaceRules !is null) {
			auto dataMgr = network.TmRaceRules.DataMgr;
			//dataMgr.RetrieveRecords(map.MapInfo, dataMgr.MenuUserId);
			dataMgr.RetrieveRecordsNoMedals(map.MapInfo.MapUid, dataMgr.MenuUserId);
			yield();
			if(dataMgr.Ready) {
				for(uint i = 0; i < dataMgr.Records.Length; i++) {
					// TODO: identify game mode, and then load arcade or dual-driver best instead? only loads for campaign maps right now
					if(dataMgr.Records[i].GhostName == "Solo_BestGhost") {
						score = dataMgr.Records[i].Time;
						break;
					}
					// this shouldn't loop more than a few times, since each entry is a different record type
				}
			}
		}

#elif MP4

		// don't use network.ClientManiaAppPlayground.ScoreMgr because that always returns -1
		if (network.TmRaceRules !is null && network.TmRaceRules.ScoreMgr !is null) {
			auto scoreMgr = network.TmRaceRules.ScoreMgr;
			// after extensive research, I have concluded that Context must be ""
			score = scoreMgr.Map_GetRecord(network.PlayerInfo.Id, map.MapInfo.MapUid, "");
		} else {
			// when playing on a server, TmRaceRules.ScoreMgr is unfortunately inaccessible
			if(app.CurrentProfile !is null && app.CurrentProfile.AccountSettings !is null) {
				// this is using *saved replays* to load the PB; if the replay has been deleted (or never saved), it won't appear
				for(uint i = 0; i < app.ReplayRecordInfos.Length; i++) {
					if(app.ReplayRecordInfos[i] !is null
						 && app.ReplayRecordInfos[i].MapUid == map.MapInfo.MapUid
						 && app.ReplayRecordInfos[i].PlayerLogin == app.CurrentProfile.AccountSettings.OnlineLogin) {
						auto record = app.ReplayRecordInfos[i];
						if(score < 0 || record.BestTime < uint(score)) {
							score = int(record.BestTime);
						}
					}
					// to prevent lag spikes when updating medals, scan at most 256 per tick
					if(i & 0xff == 0xff) {
						yield();
						// since we're yielding, it's possible for a race condition to occur, and things to get yanked out
						// from under our feet; look for this case and bail if it happens
						if(app.CurrentProfile is null || app.CurrentProfile.AccountSettings is null
								|| app.ReplayRecordInfos.Length <= i) {
							warn("Game state changed while scanning records. Retrying...");
							break;
						}
					}
				}
			}

			/* this is session-best, check this as well */
			if(app.CurrentPlayground !is null
					&& app.CurrentPlayground.GameTerminals.Length > 0
					&& cast<CTrackManiaPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer) !is null
					&& cast<CTrackManiaPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer).Score !is null) {
				int sessScore = int(cast<CTrackManiaPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer).Score.BestTime);
				if(sessScore > 0 && (score < 0 || sessScore < score)) {
					score = sessScore;
				}
			}
		}

#endif

		return score;
	}

	protected vec3 GetIconColor() override
	{
		if (m_worse !is null) {
			return m_worse.GetIconColor();
		}
		return Medal::GetIconColor();
	}

	void Draw(Medal@ better, Medal@ worse) override
	{
		UI::PushStyleColor(UI::Col::Text, vec4(0, 1, 1, 1));
		Medal::Draw(better, worse);
		UI::PopStyleColor();
	}

	void UpdateAsync(CGameCtnChallenge@ map) override { InvalidateAsync(map); }
}
