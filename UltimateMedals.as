PersonalBestMedal@ g_personalBest = CreatePersonalBestMedal();

array<Medal@> g_medals = {
#if TURBO
	SuperTrackmasterMedal(), SuperGoldMedal(), SuperSilverMedal(), SuperBronzeMedal(),
#endif
	AuthorMedal(), GoldMedal(), SilverMedal(), BronzeMedal(), g_personalBest,
};

#if TURBO
bool g_turboCampaignMap = false;
int g_turboCampaignMapNumber = 0;
#endif

UI::Font@ g_font = null;

uint64 g_limitMapNameLengthTime = 0;
uint64 g_limitMapNameLengthTimeEnd = 0;

void OnKeyPress(bool down, VirtualKey key)
{
	if (down && key == windowVisibleKey) {
		windowVisible = !windowVisible;
	}
}

void RenderMenu() {
	string strShortcut = "";
	if (windowVisibleKeyEnabled) {
		strShortcut = tostring(windowVisibleKey);
	}
	if(UI::MenuItem("\\$db4" + Icons::Circle + "\\$z Medals Window", strShortcut, windowVisible)) {
		windowVisible = !windowVisible;
	}
}

void RenderMapComment(const string &in comment) {
	UI::SameLine();
	UI::Text("\\$68f" + Icons::InfoCircle);
	if (UI::BeginItemTooltip()) {
		UI::PushTextWrapPos(400);
		UI::TextWrapped(comment);
		UI::PopTextWrapPos();
		UI::EndTooltip();
	}
}

void Render() {
	auto app = cast<CTrackMania>(GetApp());

#if TMNEXT || MP4
	auto map = app.RootMap;
#elif TURBO
	auto map = app.Challenge;
#endif

	if(hideWithIFace && !UI::IsGameUIVisible()) {
		return;
	}

	if(hideWithOverlay && !UI::IsOverlayShown()) {
		return;
	}

	if(windowVisible && map !is null && map.IdName != "" && app.Editor is null) {
		if(lockPosition) {
			UI::SetNextWindowPos(int(anchor.x), int(anchor.y), UI::Cond::Always);
		} else {
			UI::SetNextWindowPos(int(anchor.x), int(anchor.y), UI::Cond::FirstUseEver);
		}

		int windowFlags = UI::WindowFlags::NoTitleBar | UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize | UI::WindowFlags::NoDocking;
		if (!UI::IsOverlayShown()) {
			windowFlags |= UI::WindowFlags::NoInputs;
		}

		UI::PushFont(g_font, fontSize);

		UI::Begin("Ultimate Medals", windowFlags);

		if(!lockPosition) {
			anchor = UI::GetWindowPos();
		}

		string mapComment = map.MapInfo.Comments;
		bool hasComment = mapComment.Length > 0;

		if(showMapName) {
			string mapNameText = "";
#if TURBO
			if (g_turboCampaignMap) {
				mapNameText = "#";
			}
#endif
			mapNameText += Text::StripFormatCodes(map.MapInfo.Name);

			if (limitMapNameLength) {
				vec2 size = Draw::MeasureString(mapNameText);

				const uint64 timeOffsetStart = 1000;
				const uint64 timeOffsetEnd = 2000;
				const int scrollSpeed = 20; // Lower is faster

				if (size.x > limitMapNameLengthWidth) {
					auto dl = UI::GetWindowDrawList();
					vec2 cursorPos = UI::GetWindowPos() + UI::GetCursorPos();

					// Create a dummy for the text
					UI::Dummy(vec2(limitMapNameLengthWidth, size.y));

					// If the text is hovered, reset now
					if (UI::IsItemHovered()) {
						g_limitMapNameLengthTime = Time::Now;
						g_limitMapNameLengthTimeEnd = 0;
					}

					vec2 textPos = vec2(0, 0);

					// Move the text forwards after the start time has passed
					uint64 timeOffset = Time::Now - g_limitMapNameLengthTime;
					if (timeOffset > timeOffsetStart) {
						uint64 moveTimeOffset = timeOffset - timeOffsetStart;
						textPos.x = -(moveTimeOffset / scrollSpeed);
					}

					// Stop moving when we've reached the end
					if (textPos.x < -(size.x - limitMapNameLengthWidth)) {
						textPos.x = -(size.x - limitMapNameLengthWidth);

						// Begin waiting for the end time
						if (g_limitMapNameLengthTimeEnd == 0) {
							g_limitMapNameLengthTimeEnd = Time::Now;
						}
					}

					// Go back to the starting position after the end time has passed
					if (g_limitMapNameLengthTimeEnd > 0) {
						uint64 endTimeOffset = Time::Now - g_limitMapNameLengthTimeEnd;
						if (endTimeOffset > timeOffsetEnd) {
							g_limitMapNameLengthTime = Time::Now;
							g_limitMapNameLengthTimeEnd = 0;
						}
					}

					// Draw the map name
					vec4 rectBox = vec4(cursorPos.x, cursorPos.y, limitMapNameLengthWidth, size.y);
					dl.PushClipRect(rectBox, true);
					dl.AddText(cursorPos + textPos, vec4(1, 1, 1, 1), mapNameText);
					dl.PopClipRect();
				} else {
					// It fits, so we can render it normally
					UI::Text(mapNameText);
				}
			} else {
				// We don't care about the max length, so we render it normally
				UI::Text(mapNameText);
			}
		}

		if(showAuthorName) {
			UI::TextDisabled("by " + Text::StripFormatCodes(map.AuthorNickName));
		}

		if (hasComment && showComment) {
			RenderMapComment(mapComment);
		}

		int numCols = 2; // name and time columns are always shown
		if(showMedalIcons) numCols++;
		if(showPbestDelta) numCols++;

		if(UI::BeginTable("table", numCols, UI::TableFlags::SizingFixedFit | UI::TableFlags::NoSavedSettings)) {
			if (showMedalIcons) {
				UI::TableSetupColumn("##Icon");
			}
			UI::TableSetupColumn("Medal");
			UI::TableSetupColumn("Time", UI::TableColumnFlags::WidthFixed, timeColumnWidth);
			if (showPbestDelta) {
				UI::TableSetupColumn("Delta", UI::TableColumnFlags::WidthFixed, timeColumnWidth);
			}

			if (showHeader) {
				UI::TableNextRow();

				UI::PushStyleColor(UI::Col::Text, tableHeaderTextColor);

				if (showMedalIcons) {
					UI::TableNextColumn();
					// Medal icon has no header text
				}

				UI::TableNextColumn();
				UI::Text("Medal");

				UI::TableNextColumn();
				UI::SetCursorPosX(UI::GetCursorPos().x + UI::GetContentRegionAvail().x - Draw::MeasureString("Time").x);
				UI::Text("Time");

				if (showPbestDelta) {
					UI::TableNextColumn();
					UI::SetCursorPosX(UI::GetCursorPos().x + UI::GetContentRegionAvail().x - Draw::MeasureString("Delta").x);
					UI::Text("Delta");
				}

				UI::PopStyleColor();
			}

			for (uint i = 0; i < g_medals.Length; i++) {
				Medal@ medal = g_medals[i];
				if(!medal.IsVisible()) {
					continue;
				}

				UI::TableNextRow();

				Medal@ better, worse;
				if (i > 0) {
					@better = g_medals[i - 1];
				}
				if (i < g_medals.Length - 1) {
					@worse = g_medals[i + 1];
				}

				medal.Draw(better, worse);
			}

			UI::EndTable();
		}

		UI::End();

		UI::PopFont();
	}
}

void LoadFont() {
	if (fontFace == "") {
		@g_font = UI::Font::Default;
		return;
	}

	try {
		@g_font = UI::LoadFont(fontFace);
	} catch {
		@g_font = UI::LoadSystemFont(fontFace);
	}
}

void Main() {
	auto app = cast<CTrackMania>(GetApp());

	for (uint i = 0; i < g_medals.Length; i++) {
		g_medals[i].m_defaultOrder = i;
	}

#if TURBO
	TurboSTM::Initialize();
#endif

	LoadFont();

	string currentMapUid;

	while(true) {
		if(windowVisible && app.Editor is null) {
#if TMNEXT || MP4
			auto map = app.RootMap;
#elif TURBO
			auto map = app.Challenge;
#endif

			if(map !is null) {
				string uid = map.IdName;

				if (uid != "") {
					if(currentMapUid != uid) {
						currentMapUid = uid;

	#if TURBO
						g_turboCampaignMapNumber = Text::ParseInt(map.MapName);
						g_turboCampaignMap = g_turboCampaignMapNumber != 0 && map.AuthorLogin == "Nadeo";
	#endif

						g_limitMapNameLengthTime = Time::Now;
						g_limitMapNameLengthTimeEnd = 0;

						foreach (Medal@ medal : g_medals) {
							medal.InvalidateAsync(map);
						}
					}
				}

				foreach (Medal@ medal : g_medals) {
					medal.UpdateAsync(map);
				}
			} else {
				currentMapUid = "";
			}

			g_medals.Sort(function(const Medal@ const &in a, const Medal@ const &in b) {
				int sa = a.GetCachedScore();
				int sb = b.GetCachedScore();
				if (sa == -1 && sb != -1) {
					return false;
				} else if (sa != -1 && sb == -1) {
					return true;
				}
				if (sa == sb) {
					return a.m_defaultOrder < b.m_defaultOrder;
				}
				return sa < sb;
			});
		}

		yield();
	}
}
