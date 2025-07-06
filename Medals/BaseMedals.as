class AuthorMedal : Medal
{
	bool IsVisible() override
	{
#if TURBO
		return showTmaster;
#else
		return showAuthor;
#endif
	}

	protected string GetName() override
	{
#if TURBO
		return tmasterText;
#else
		return authorText;
#endif
	}

	protected int GetScoreAsync(CGameCtnChallenge@ map) override { return map.TMObjective_AuthorTime; }

	protected vec3 GetIconColor() override
	{
#if TURBO
		return vec3(0, 1, 0x11/255.0f);
#else
		return vec3(0, 0x77/255.0f, 0x11/255.0f);
#endif
	}
}

class GoldMedal : Medal
{
	bool IsVisible() override { return showGold; }
	protected string GetName() override { return goldText; }
	protected int GetScoreAsync(CGameCtnChallenge@ map) override { return map.TMObjective_GoldTime; }
	protected vec3 GetIconColor() override { return vec3(0xDD/255.0f, 0xBB/255.0f, 0x44/255.0f); }
}

class SilverMedal : Medal
{
	bool IsVisible() override { return showSilver; }
	protected string GetName() override { return silverText; }
	protected int GetScoreAsync(CGameCtnChallenge@ map) override { return map.TMObjective_SilverTime; }
	protected vec3 GetIconColor() override { return vec3(0x88/255.0f, 0x99/255.0f, 0x99/255.0f); }
}

class BronzeMedal : Medal
{
	bool IsVisible() override { return showBronze; }
	protected string GetName() override { return bronzeText; }
	protected int GetScoreAsync(CGameCtnChallenge@ map) override { return map.TMObjective_BronzeTime; }
	protected vec3 GetIconColor() override { return vec3(0x99/255.0f, 0x66/255.0f, 0x44/255.0f); }
}
