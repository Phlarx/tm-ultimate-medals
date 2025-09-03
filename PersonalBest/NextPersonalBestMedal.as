#if TMNEXT

class NextPersonalBestMedal : PersonalBestMedal
{
	protected int GetScoreAsync(CGameCtnChallenge@ map) override
	{
		int score = -1;

		auto app = GetApp();
		auto network = cast<CTrackManiaNetwork>(app.Network);

		if(network.ClientManiaAppPlayground !is null) {
			auto scoreMgr = network.ClientManiaAppPlayground.ScoreMgr;
			// from: OpenplanetNext\Extract\Titles\Trackmania\Scripts\Libs\Nadeo\TMNext\TrackMania\Menu\Constants.Script.txt
			// ScopeType can be: "Season", "PersonalBest"
			score = scoreMgr.Map_GetRecord_v2(0x100, map.MapInfo.MapUid, "PersonalBest", "", tostring(g_gameMode), "");
		}

		return score;
	}

	void UpdateAsync(CGameCtnChallenge@ map) override
	{
		InvalidateAsync(map);
	}
}

#endif
