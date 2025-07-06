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
		UI::Text(this.style + (this.time > 0 ? Time::Format(this.time) : "-:--.---"));
	}

	void DrawDelta(Record@ other) {
		if (this is other || other.time <= 0) {
			return;
		}

		int delta = other.time - this.time;
		if (delta < 0) {
			if (showPbestDeltaNegative) {
				UI::PushStyleColor(UI::Col::Text, vec4(deltaColorNegative, 1));
				UI::Text("-" + Time::Format(delta * -1));
				UI::PopStyleColor();
			}
		} else if (delta > 0) {
			UI::PushStyleColor(UI::Col::Text, vec4(deltaColorPositive, 1));
			UI::Text("+" + Time::Format(delta));
			UI::PopStyleColor();
		} else {
			UI::PushStyleColor(UI::Col::Text, vec4(deltaColorNeutral, 1));
			UI::Text("0:00.000");
			UI::PopStyleColor();
		}
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
