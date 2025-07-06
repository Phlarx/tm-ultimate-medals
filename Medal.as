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

	// Called on map change
	void InvalidateAsync(CGameCtnChallenge@ map) { m_cachedScore = GetScoreAsync(map); }

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
		string str = m_cachedScore > 0 ? Time::Format(m_cachedScore) : "-:--.---";
		UI::SetCursorPosX(UI::GetCursorPos().x + UI::GetContentRegionAvail().x - Draw::MeasureString(str).x);
		UI::Text(str);
	}

	void DrawDelta(Medal@ other)
	{
		if (other is this || other.m_cachedScore <= 0) {
			return;
		}

		string str;
		vec3 color;

		int delta = other.m_cachedScore - m_cachedScore;
		if (delta < 0) {
			if (!showPbestDeltaNegative) {
				return;
			}
			str = "-" + Time::Format(delta * -1);
			color = deltaColorNegative;
		} else if (delta > 0) {
			str = "+" + Time::Format(delta);
			color = deltaColorPositive;
		} else {
			str = "-:--.---";
			color = deltaColorNeutral;
		}

		UI::PushStyleColor(UI::Col::Text, vec4(color, 1));
		UI::SetCursorPosX(UI::GetCursorPos().x + UI::GetContentRegionAvail().x - Draw::MeasureString(str).x);
		UI::Text(str);
		UI::PopStyleColor();
	}
}

//todo: DrawIcon for Turbo Super Bronze/Silver/Gold
/*
UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(0, -fontSize * UI::GetScale()));
UI::Text(medals[this.medal]);
UI::Text("\\$0f1" + Icons::CircleO);
UI::PopStyleVar();
*/

//todo: Turbo visibility
/*
// If no super times, never show them
stmaster.hidden = !showStmaster || stmaster.time < 0;
sgold.hidden = !showSgold || stmaster.time < 0;
ssilver.hidden = !showSsilver || stmaster.time < 0;
sbronze.hidden = !showSbronze || stmaster.time < 0;
*/

//todo: turbo super gold/silver/bronze
/*
stmaster.time = int(super.m_time);
auto delta = tmaster.time - stmaster.time;
sgold.time = stmaster.time + (delta+4)/8;
ssilver.time = stmaster.time + (delta+2)/4;
sbronze.time = stmaster.time + (delta+1)/2;
*/
