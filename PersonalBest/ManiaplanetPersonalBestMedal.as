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
		if(app.CurrentPlayground !is null && app.CurrentPlayground.GameTerminals.Length > 0) {
			auto player = cast<CTrackManiaPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer);
			if (player !is null && player.Score !is null) {
				int sessScore = int(player.Score.BestTime);
				if(sessScore > 0 && (score < 0 || sessScore < score)) {
					score = sessScore;
				}
			}
		}

		// Optionally, we may want to find the record through AutoSaves (this is pretty slow)
		if(searchAutoSaves && app.CurrentProfile !is null && app.CurrentProfile.AccountSettings !is null) {
			// this is using *saved replays* to load the PB; if the replay has been deleted (or never saved), it won't appear
			for(uint i = 0; i < app.ReplayRecordInfos.Length; i++) {
				auto record = app.ReplayRecordInfos[i];
				if(record !is null && record.MapUid == map.IdName && record.PlayerLogin == app.CurrentProfile.AccountSettings.OnlineLogin) {
					if(score < 0 || record.BestTime < uint(score)) {
						score = int(record.BestTime);
					}
				}
				// to prevent lag spikes when updating medals, scan at most 256 per tick
				if(i & 0xff == 0xff) {
					yield();
					// since we're yielding, it's possible for a race condition to occur, and things to get yanked out
					// from under our feet; look for this case and bail if it happens
					if(app.CurrentProfile is null || app.CurrentProfile.AccountSettings is null || app.ReplayRecordInfos.Length <= i) {
						warn("Game state changed while scanning records. Retrying...");
						break;
					}
				}
			}
		}

		return score;
	}

	void UpdateAsync(CGameCtnChallenge@ map) override
	{
		InvalidateAsync(map);
	}
}

#endif
