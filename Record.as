class Record {
	string name;
	uint medal;
	int time;
	string style;
	bool hidden;

	Record(string &in name = "Unknown", uint medal = 0, int time = -1, string &in style = "\\$fff") {
		this.name = name;
		this.medal = medal;
		this.time = time;
		this.style = style;
		this.hidden = false;
	}

	void DrawIcon() {
#if TURBO
		if(5 <= this.medal && this.medal <= 7) {
			UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(0, -fontSize * UI::GetScale()));
			UI::Text(medals[this.medal]);
			UI::Text("\\$0f1" + Icons::CircleO);
			UI::PopStyleVar();
		} else {
			UI::Text(medals[this.medal]);
		}
#else
		UI::Text(medals[this.medal]);
#endif
	}

	void DrawName() {
		UI::Text(this.style + this.name);
	}

	void DrawTime() {
		string strTime = this.style + (this.time > 0 ? Time::Format(this.time) : "-:--.---");
		UI::SetCursorPosX(UI::GetCursorPos().x + UI::GetContentRegionAvail().x - Draw::MeasureString(strTime).x);
		UI::Text(strTime);
	}

	void DrawDelta(Record@ other) {
		if (this is other || other.time <= 0) {
			return;
		}

		string str;
		vec3 color;

		int delta = other.time - this.time;
		if (delta < 0) {
			if (showPbestDeltaNegative) {
				str = "-" + Time::Format(delta * -1);
				color = deltaColorNegative;
			}
		} else if (delta > 0) {
			str = "+" + Time::Format(delta);
			color = deltaColorPositive;
		} else {
			str = "0:00.000";
			color = deltaColorNeutral;
		}

		UI::PushStyleColor(UI::Col::Text, vec4(color, 1));
		UI::SetCursorPosX(UI::GetCursorPos().x + UI::GetContentRegionAvail().x - Draw::MeasureString(str).x);
		UI::Text(str);
		UI::PopStyleColor();
	}

	int opCmp(Record@ other) {
		// like normal, except consider negatives to be larger than positives
		if((this.time >= 0) == (other.time >= 0)) {
			// sign(this.time - other.time), but overflow safe
			int64 diff = int64(this.time) - int64(other.time);
			return diff == 0 ? 0 : diff > 0 ? 1 : -1;
		} else {
			// sign(other.time - this.time), but overflow safe
			int64 diff = int64(other.time) - int64(this.time);
			return diff == 0 ? 0 : diff > 0 ? 1 : -1;
		}
	}
}
