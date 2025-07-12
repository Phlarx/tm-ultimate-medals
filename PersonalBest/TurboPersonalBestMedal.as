#if TURBO

class TurboPersonalBestMedal : PersonalBestMedal
{
	protected int GetScoreAsync(CGameCtnChallenge@ map) override
	{
		int score = -1;

		auto app = GetApp();
		auto network = cast<CTrackManiaNetwork>(app.Network);

		if(network.TmRaceRules !is null) {
			auto dataMgr = network.TmRaceRules.DataMgr;

			// Wait for datamanager to be ready before requesting info ourselves (the game might lock this)
			while (!dataMgr.Ready) { yield(); }

			dataMgr.RetrieveRecordsNoMedals(map.MapInfo.MapUid, dataMgr.MenuUserId);
			while (!dataMgr.Ready) { yield(); }

			for(uint i = 0; i < dataMgr.Records.Length; i++) {
				// TODO: identify game mode, and then load arcade or dual-driver best instead? only loads for campaign maps right now
				if(dataMgr.Records[i].GhostName == "Solo_BestGhost") {
					score = dataMgr.Records[i].Time;
					break;
				}
			}
		}

		return score;
	}

	int m_lastRaceState = -1;

	void UpdateAsync(CGameCtnChallenge@ map) override
	{
		int currentRaceState = -1;

		auto pg = GetApp().CurrentPlayground;
		if (pg !is null && pg.GameTerminals.Length >= 1) {
			auto player = cast<CTrackManiaPlayer>(pg.GameTerminals[0].ControlledPlayer);
			currentRaceState = int(player.RaceState);
		}

		if (m_lastRaceState != currentRaceState) {
			m_lastRaceState = currentRaceState;
			InvalidateAsync(map);
		}
	}
}

#endif
