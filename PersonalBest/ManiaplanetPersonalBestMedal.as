#if MP4

class ManiaplanetPersonalBestMedal : PersonalBestMedal
{
	protected int GetScoreAsync(CGameCtnChallenge@ map) override
	{
		int score = -1;

		auto app = GetApp();
		auto network = cast<CTrackManiaNetwork>(app.Network);

		CGameScoreAndLeaderBoardManagerScript@ scoreMgr;

		if (network.TmRaceRules !is null && network.TmRaceRules.ScoreMgr !is null) {
			@scoreMgr = network.TmRaceRules.ScoreMgr;
		} else if (network.ClientManiaAppPlayground !is null) {
			@scoreMgr = network.ClientManiaAppPlayground.ScoreMgr;
		}

		if (scoreMgr !is null) {
			score = scoreMgr.Map_GetRecord(network.PlayerInfo.Id, map.MapInfo.MapUid, "");
		}

		// this is session-best, check this as well
		if(app.CurrentPlayground !is null
				&& app.CurrentPlayground.GameTerminals.Length > 0
				&& cast<CTrackManiaPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer) !is null
				&& cast<CTrackManiaPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer).Score !is null) {
			int sessScore = int(cast<CTrackManiaPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer).Score.BestTime);
			if(sessScore > 0 && (score < 0 || sessScore < score)) {
				score = sessScore;
			}
		}

		/*
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
		*/

		return score;
	}

	void UpdateAsync(CGameCtnChallenge@ map) override
	{
		InvalidateAsync(map);
	}
}

#endif
