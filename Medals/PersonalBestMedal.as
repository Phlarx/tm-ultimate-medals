abstract class PersonalBestMedal : Medal
{
	bool IsVisible() override { return showPbest; }
	protected string GetName() override { return pbestText; }

	protected vec3 GetIconColor() override
	{
		if (m_better !is null && m_cachedScore == m_better.GetCachedScore()) {
			return m_better.GetIconColor();
		}
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
}

PersonalBestMedal@ CreatePersonalBestMedal()
{
#if TMNEXT
	return NextPersonalBestMedal();
#elif TURBO
	return TurboPersonalBestMedal();
#elif MP4
	return ManiaplanetPersonalBestMedal();
#else
	return null;
#endif
}
