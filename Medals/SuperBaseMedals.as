#if TURBO

abstract class SuperMedal : Medal
{
	protected int GetScoreAsync(CGameCtnChallenge@ map) override
	{
		if (!g_turboCampaignMap) {
			return -1;
		}

		auto stm = TurboSTM::GetSuperTime(g_turboCampaignMapNumber);
		if (stm is null) {
			return -1;
		}

		return int(stm.m_time);
	}
}

class SuperTrackmasterMedal : SuperMedal
{
	bool IsVisible() override { return showStmaster && g_turboCampaignMap; }
	protected string GetName() override { return stmasterText; }
	protected vec3 GetIconColor() override { return vec3(0, 1, 1); }
}

abstract class SuperBaseMedal : SuperMedal
{
	void DrawIcon() override
	{
		vec2 startPos = UI::GetCursorPos();
		SuperMedal::DrawIcon();
		UI::SetCursorPos(startPos);
		UI::Text("\\$0f1" + Icons::CircleO);
	}
}

class SuperGoldMedal : SuperBaseMedal
{
	bool IsVisible() override { return showSgold && g_turboCampaignMap; }
	protected string GetName() override { return sgoldText; }
	protected int GetScoreAsync(CGameCtnChallenge@ map) override
	{
		int stm = SuperMedal::GetScoreAsync(map);
		int delta = map.TMObjective_AuthorTime - stm;
		return Math::Round(stm + (delta / 8.0f));
	}
	protected vec3 GetIconColor() override { return vec3(0xDD/255.0f, 0xBB/255.0f, 0x44/255.0f); }
}

class SuperSilverMedal : SuperBaseMedal
{
	bool IsVisible() override { return showSsilver && g_turboCampaignMap; }
	protected string GetName() override { return ssilverText; }
	protected int GetScoreAsync(CGameCtnChallenge@ map) override
	{
		int stm = SuperMedal::GetScoreAsync(map);
		int delta = map.TMObjective_AuthorTime - stm;
		return Math::Round(stm + (delta / 4.0f));
	}
	protected vec3 GetIconColor() override { return vec3(0x88/255.0f, 0x99/255.0f, 0x99/255.0f); }
}

class SuperBronzeMedal : SuperBaseMedal
{
	bool IsVisible() override { return showSbronze && g_turboCampaignMap; }
	protected string GetName() override { return sbronzeText; }
	protected int GetScoreAsync(CGameCtnChallenge@ map) override
	{
		int stm = SuperMedal::GetScoreAsync(map);
		int delta = map.TMObjective_AuthorTime - stm;
		return Math::Round(stm + (delta / 2.0f));
	}
	protected vec3 GetIconColor() override { return vec3(0x99/255.0f, 0x66/255.0f, 0x44/255.0f); }
}

#endif
