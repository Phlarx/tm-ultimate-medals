abstract class Medal
{
	private int m_cachedScore;

	protected Medal@ m_better;
	protected Medal@ m_worse;

	uint m_defaultOrder;

	bool IsVisible() { return true; }
	int GetCachedScore() const { return m_cachedScore; }

	protected string GetName() { return "Unknown"; }
	protected int GetScoreAsync(CGameCtnChallenge@ map) { return -1; }
	protected vec3 GetIconColor() { return vec3(0.5f); }

	// Called whenever the medal should update (such as on map change)
	void InvalidateAsync(CGameCtnChallenge@ map, bool clearScore = false)
	{
		if (clearScore) {
			m_cachedScore = -1;
		}
		m_cachedScore = GetScoreAsync(map);
	}

	// Called every frame
	void UpdateAsync(CGameCtnChallenge@ map) {}

	void Draw(Medal@ better, Medal@ worse)
	{
		@m_better = better;
		@m_worse = worse;

		if(showMedalIcons) {
			UI::TableNextColumn();
			DrawIcon();
		}

		UI::TableNextColumn();
		DrawName();

		UI::TableNextColumn();
		DrawScore();

		if (showPbestDelta) {
			UI::TableNextColumn();
			DrawDelta(g_personalBest);
		}

		@m_better = @m_worse = null;
	}

	void DrawIcon()
	{
		UI::PushStyleColor(UI::Col::Text, vec4(GetIconColor(), 1));
		UI::Text(Icons::Circle);
		UI::PopStyleColor();
	}

	void DrawName()
	{
		UI::Text(GetName());
	}

	void DrawScore()
	{
		string str;
		switch (g_scoreUnit) {
		case ScoreUnit::Time:
			str = m_cachedScore > 0 ? Time::Format(m_cachedScore) : "-:--.---";
			break;

		case ScoreUnit::Points:
		case ScoreUnit::Respawns:
			str = m_cachedScore > 0 ? tostring(m_cachedScore) : "-";
			break;
		}
		UI::SetCursorPosX(UI::GetCursorPos().x + UI::GetContentRegionAvail().x - Draw::MeasureString(str).x);
		UI::Text(str);
	}

	void DrawDelta(Medal@ other)
	{
		if (other is this || other.m_cachedScore <= 0) {
			return;
		}

		int delta = other.m_cachedScore - m_cachedScore;

		if (delta < 0 && !showPbestDeltaNegative) {
			return;
		}

		string str;
		vec3 color;

		switch (g_scoreUnit) {
			case ScoreUnit::Time:
				if (delta < 0) {
					str = "-" + Time::Format(delta * -1);
					color = deltaColorNegative;
				} else if (delta > 0) {
					str = "+" + Time::Format(delta);
					color = deltaColorPositive;
				} else {
					str = "-:--.---";
					color = deltaColorNeutral;
				}
				break;

			case ScoreUnit::Points:
				if (delta < 0) {
					str = "+" + delta * -1;
					color = deltaColorPositive;
				} else if (delta > 0) {
					str = "-" + delta;
					color = deltaColorNegative;
				} else {
					str = "-";
					color = deltaColorNeutral;
				}
				break;

			case ScoreUnit::Respawns:
				if (delta < 0) {
					str = tostring(delta);
					color = deltaColorNegative;
				} else if (delta > 0) {
					str = "+" + delta;
					color = deltaColorPositive;
				} else {
					str = "-";
					color = deltaColorNeutral;
				}
				break;
		}

		UI::PushStyleColor(UI::Col::Text, vec4(color, 1));
		UI::SetCursorPosX(UI::GetCursorPos().x + UI::GetContentRegionAvail().x - Draw::MeasureString(str).x);
		UI::Text(str);
		UI::PopStyleColor();
	}
}
