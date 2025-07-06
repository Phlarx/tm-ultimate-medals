#if TURBO

class SuperTrackmasterMedal : Medal
{
	bool IsVisible() override { return showStmaster && g_turboCampaignMap; }
	protected string GetName() override { return stmasterText; }
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
	protected vec3 GetIconColor() override { return vec3(0, 1, 1); }
}

class SuperGoldMedal : Medal
{
	bool IsVisible() override { return showGold && g_turboCampaignMap; }
	protected string GetName() override { return goldText; }
	protected int GetScoreAsync(CGameCtnChallenge@ map) override { return -1; /*todo*/ }
	protected vec3 GetIconColor() override { return vec3(0xDD/255.0f, 0xBB/255.0f, 0x44/255.0f); }
}

class SuperSilverMedal : Medal
{
	bool IsVisible() override { return showSilver && g_turboCampaignMap; }
	protected string GetName() override { return silverText; }
	protected int GetScoreAsync(CGameCtnChallenge@ map) override { return -1; /*todo*/ }
	protected vec3 GetIconColor() override { return vec3(0x88/255.0f, 0x99/255.0f, 0x99/255.0f); }
}

class SuperBronzeMedal : Medal
{
	bool IsVisible() override { return showBronze && g_turboCampaignMap; }
	protected string GetName() override { return bronzeText; }
	protected int GetScoreAsync(CGameCtnChallenge@ map) override { return -1; /*todo*/ }
	protected vec3 GetIconColor() override { return vec3(0x99/255.0f, 0x66/255.0f, 0x44/255.0f); }
}

#endif
