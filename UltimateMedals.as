const array<string> medals = {
	"\\$444" + Icons::Circle, // no medal
	"\\$964" + Icons::Circle, // bronze medal
	"\\$899" + Icons::Circle, // silver medal
	"\\$db4" + Icons::Circle, // gold medal
#if TMNEXT||MP4
	"\\$071" + Icons::Circle, // author medal
#elif TURBO
	"\\$0f1" + Icons::Circle, // trackmaster medal
	"\\$964" + Icons::Circle, // super bronze medal
	"\\$899" + Icons::Circle, // super silver medal
	"\\$db4" + Icons::Circle, // super gold medal
	"\\$0ff" + Icons::Circle, // super trackmaster medal
#endif
};

#if TMNEXT||MP4
Record@ author = Record(authorText, 4, -5);
#elif TURBO
Record@ stmaster = Record(stmasterText, 8, -9);
Record@ sgold = Record(sgoldText, 7, -8);
Record@ ssilver = Record(ssilverText, 6, -7);
Record@ sbronze = Record(sbronzeText, 5, -6);
Record@ tmaster = Record(tmasterText, 4, -5);
#endif
Record@ gold = Record(goldText, 3, -4);
Record@ silver = Record(silverText, 2, -3);
Record@ bronze = Record(bronzeText, 1, -2);
Record@ pbest = Record(pbestText, 0, -1, "\\$0ff");

#if TMNEXT||MP4
array<Record@> times = {author, gold, silver, bronze, pbest};
#elif TURBO
array<Record@> times = {stmaster, sgold, ssilver, sbronze, tmaster, gold, silver, bronze, pbest};

bool campaignMap = false;
#endif

int timeWidth = 53;
int deltaWidth = 60;

UI::Font@ font = null;

uint64 limitMapNameLengthTime = 0;
uint64 limitMapNameLengthTimeEnd = 0;


bool held = false;
void OnKeyPress(bool down, VirtualKey key)
{
	if(key == windowVisibleKey && !held)
	{
		windowVisible = !windowVisible;
	}
	held = down;
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

void Render() {
	auto app = cast<CTrackMania>(GetApp());

#if TMNEXT||MP4
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

	if(windowVisible && map !is null && map.MapInfo.MapUid != "" && app.Editor is null) {
		if(lockPosition) {
			UI::SetNextWindowPos(int(anchor.x), int(anchor.y), UI::Cond::Always);
		} else {
			UI::SetNextWindowPos(int(anchor.x), int(anchor.y), UI::Cond::FirstUseEver);
		}

		int windowFlags = UI::WindowFlags::NoTitleBar | UI::WindowFlags::NoCollapse | UI::WindowFlags::AlwaysAutoResize | UI::WindowFlags::NoDocking;
		if (!UI::IsOverlayShown()) {
			windowFlags |= UI::WindowFlags::NoInputs;
		}

		UI::PushFont(font, fontSize);

		UI::Begin("Ultimate Medals", windowFlags);

		if(!lockPosition) {
			anchor = UI::GetWindowPos();
		}

		bool hasComment = string(map.MapInfo.Comments).Length > 0;

		UI::BeginGroup();
		if((showMapName || showAuthorName) && UI::BeginTable("header", 1, UI::TableFlags::SizingFixedFit)) {
			if(showMapName) {
				UI::TableNextRow();
				UI::TableNextColumn();
				string mapNameText = "";
#if TURBO
				if (campaignMap) {
					mapNameText = "#";
				}
#endif
				mapNameText += Text::StripFormatCodes(map.MapInfo.Name);
				if (hasComment && !showAuthorName) {
					mapNameText += " \\$68f" + Icons::InfoCircle;
				}
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
							limitMapNameLengthTime = Time::Now;
							limitMapNameLengthTimeEnd = 0;
						}

						vec2 textPos = vec2(0, 0);

						// Move the text forwards after the start time has passed
						uint64 timeOffset = Time::Now - limitMapNameLengthTime;
						if (timeOffset > timeOffsetStart) {
							uint64 moveTimeOffset = timeOffset - timeOffsetStart;
							textPos.x = -(moveTimeOffset / scrollSpeed);
						}

						// Stop moving when we've reached the end
						if (textPos.x < -(size.x - limitMapNameLengthWidth)) {
							textPos.x = -(size.x - limitMapNameLengthWidth);

							// Begin waiting for the end time
							if (limitMapNameLengthTimeEnd == 0) {
								limitMapNameLengthTimeEnd = Time::Now;
							}
						}

						// Go back to the starting position after the end time has passed
						if (limitMapNameLengthTimeEnd > 0) {
							uint64 endTimeOffset = Time::Now - limitMapNameLengthTimeEnd;
							if (endTimeOffset > timeOffsetEnd) {
								limitMapNameLengthTime = Time::Now;
								limitMapNameLengthTimeEnd = 0;
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
				UI::TableNextRow();
				UI::TableNextColumn();
				string authorNameText = "\\$888by " + Text::StripFormatCodes(map.MapInfo.AuthorNickName);
				if (hasComment) {
					authorNameText += " \\$68f" + Icons::InfoCircle;
				}
				UI::Text(authorNameText);
			}
			UI::EndTable();
		}

		int numCols = 2; // name and time columns are always shown
		if(showMedalIcons) numCols++;
		if(showPbestDelta) numCols++;

		if(UI::BeginTable("table", numCols, UI::TableFlags::SizingFixedFit)) {
			if(showHeader) {
				UI::TableNextRow();

				if (showMedalIcons) {
					UI::TableNextColumn();
					// Medal icon has no header text
				}

				UI::TableNextColumn();
				setMinWidth(0);
				UI::Text("Medal");

				UI::TableNextColumn();
				setMinWidth(timeWidth);
				UI::Text("Time");

				if (showPbestDelta) {
					UI::TableNextColumn();
					setMinWidth(deltaWidth);
					UI::Text("Delta");
				}
			}

			for(uint i = 0; i < times.Length; i++) {
				if(times[i].hidden) {
					continue;
				}
				UI::TableNextRow();

				if(showMedalIcons) {
					UI::TableNextColumn();
					times[i].DrawIcon();
				}

				UI::TableNextColumn();
				times[i].DrawName();

				UI::TableNextColumn();
				times[i].DrawTime();

				if (showPbestDelta) {
					UI::TableNextColumn();
					times[i].DrawDelta(pbest);
				}
			}

			UI::EndTable();
		}
		UI::EndGroup();

		if(hasComment && showComment && UI::IsItemHovered()) {
			UI::BeginTooltip();
			UI::PushTextWrapPos(200);
			UI::TextWrapped(map.MapInfo.Comments);
			UI::PopTextWrapPos();
			UI::EndTooltip();
		}

		UI::End();

		UI::PopFont();
	}
}

void setMinWidth(int width) {
	UI::PushStyleVar(UI::StyleVar::ItemSpacing, vec2(0, 0));
	UI::Dummy(vec2(width * UI::GetScale(), 0));
	UI::PopStyleVar();
}

void LoadFont() {
	if (fontFace == "") {
		@font = UI::Font::Default;
		return;
	}

	try {
		@font = UI::LoadFont(fontFace);
	} catch {
		@font = UI::LoadSystemFont(fontFace);
	}
}

void UpdateHidden() {
#if TMNEXT||MP4
	author.hidden = !showAuthor;
#elif TURBO
	// If no super times, never show them
	stmaster.hidden = !showStmaster || stmaster.time < 0;
	sgold.hidden = !showSgold || stmaster.time < 0;
	ssilver.hidden = !showSsilver || stmaster.time < 0;
	sbronze.hidden = !showSbronze || stmaster.time < 0;
	tmaster.hidden = !showTmaster;
#endif
	gold.hidden = !showGold;
	silver.hidden = !showSilver;
	bronze.hidden = !showBronze;
	pbest.hidden = !showPbest;
}

void UpdateText() {
#if TMNEXT||MP4
	author.name = authorText;
#elif TURBO
	stmaster.name = stmasterText;
	sgold.name = sgoldText;
	ssilver.name = ssilverText;
	sbronze.name = sbronzeText;
	tmaster.name = tmasterText;
#endif
	gold.name = goldText;
	silver.name = silverText;
	bronze.name = bronzeText;
	pbest.name = pbestText;
}

void OnSettingsChanged() {
	UpdateHidden();
	UpdateText();
}

void Main() {
	auto app = cast<CTrackMania>(GetApp());
	auto network = cast<CTrackManiaNetwork>(app.Network);

#if TURBO
	TurboSTM::Initialize();
#endif

	LoadFont();
	UpdateHidden();
	UpdateText();

	string currentMapUid = "";

	while(true) {
#if TMNEXT||MP4
		auto map = app.RootMap;
#elif TURBO
		auto map = app.Challenge;
#endif

		if(windowVisible && map !is null && map.MapInfo.MapUid != "" && app.Editor is null) {
			if(currentMapUid != map.MapInfo.MapUid) {
#if TMNEXT||MP4
				author.time = map.TMObjective_AuthorTime;
#elif TURBO
				int mapNumber = Text::ParseInt(map.MapName);
				campaignMap = mapNumber != 0 && map.MapInfo.AuthorLogin == "Nadeo";

				auto super = TurboSTM::GetSuperTime(mapNumber);
				tmaster.time = map.TMObjective_AuthorTime;
				if(super !is null && campaignMap) {
					// we check campaignMap so that a successful parse on a different map doesn't give a false positive
					stmaster.time = int(super.m_time);
					auto delta = tmaster.time - stmaster.time;
					sgold.time = stmaster.time + (delta+4)/8;
					ssilver.time = stmaster.time + (delta+2)/4;
					sbronze.time = stmaster.time + (delta+1)/2;
				} else {
					stmaster.time = -9;
					sgold.time = -8;
					ssilver.time = -7;
					sbronze.time = -6;
				}
#endif
				gold.time = map.TMObjective_GoldTime;
				silver.time = map.TMObjective_SilverTime;
				bronze.time = map.TMObjective_BronzeTime;

				// prevent 'leaking' a stale PB between maps
				pbest.time = -1;
				pbest.medal = 0;

				currentMapUid = map.MapInfo.MapUid;

				limitMapNameLengthTime = Time::Now;
				limitMapNameLengthTimeEnd = 0;

				UpdateHidden();
			}

#if TMNEXT
			if(network.ClientManiaAppPlayground !is null) {
				auto userMgr = network.ClientManiaAppPlayground.UserMgr;
				MwId userId;
				if (userMgr.Users.Length > 0) {
					userId = userMgr.Users[0].Id;
				} else {
					userId.Value = uint(-1);
				}

				auto scoreMgr = network.ClientManiaAppPlayground.ScoreMgr;
				// from: OpenplanetNext\Extract\Titles\Trackmania\Scripts\Libs\Nadeo\TMNext\TrackMania\Menu\Constants.Script.txt
				// ScopeType can be: "Season", "PersonalBest"
				// GameMode can be: "TimeAttack", "Follow", "ClashTime"
				pbest.time = scoreMgr.Map_GetRecord_v2(userId, map.MapInfo.MapUid, "PersonalBest", "", "TimeAttack", "");
				pbest.medal = scoreMgr.Map_GetMedal(userId, map.MapInfo.MapUid, "PersonalBest", "", "TimeAttack", "");
			}
#elif TURBO
			if(network.TmRaceRules !is null) {
				auto dataMgr = network.TmRaceRules.DataMgr;
				//dataMgr.RetrieveRecords(map.MapInfo, dataMgr.MenuUserId);
				dataMgr.RetrieveRecordsNoMedals(map.MapInfo.MapUid, dataMgr.MenuUserId);
				yield();
				if(dataMgr.Ready) {
					for(uint i = 0; i < dataMgr.Records.Length; i++) {
						// TODO: identify game mode, and then load arcade or dual-driver best instead? only loads for campaign maps right now
						if(dataMgr.Records[i].GhostName == "Solo_BestGhost") {
							pbest.time = dataMgr.Records[i].Time;
							pbest.medal = CalcMedal();
							break;
						}
						// this shouldn't loop more than a few times, since each entry is a different record type
					}
				}
			}
#elif MP4
			// don't use network.ClientManiaAppPlayground.ScoreMgr because that always returns -1
			if(network.TmRaceRules !is null && network.TmRaceRules.ScoreMgr !is null) {
				auto scoreMgr = network.TmRaceRules.ScoreMgr;
				// after extensive research, I have concluded that Context must be ""
				pbest.time = scoreMgr.Map_GetRecord(network.PlayerInfo.Id, map.MapInfo.MapUid, "");
				pbest.medal = CalcMedal();
			} else if(true) { // yes, this overrides the `else` below
				int score = -1;

				// when playing on a server, TmRaceRules.ScoreMgr is unfortunately inaccessible
				if(app.CurrentProfile !is null && app.CurrentProfile.AccountSettings !is null) {
					// this is using *saved replays* to load the PB; if the replay has been deleted (or never saved), it won't appear
					for(uint i = 0; i < app.ReplayRecordInfos.Length; i++) {
						if(app.ReplayRecordInfos[i] !is null
							 && app.ReplayRecordInfos[i].MapUid == map.MapInfo.MapUid
							 && app.ReplayRecordInfos[i].PlayerLogin == app.CurrentProfile.AccountSettings.OnlineLogin) {
							auto record = app.ReplayRecordInfos[i];
							if(score < 0 || record.BestTime < uint(score)) {
								score = int(record.BestTime);
							}
						}
						// to prevent lag spikes when updating medals, scan at most 256 per tick
						if(i & 0xff == 0xff) {
							yield();
							// since we're yielding, it's possible for a race condition to occur, and things to get yanked out
							// from under our feet; look for this case and bail if it happens
							if(app.CurrentProfile is null || app.CurrentProfile.AccountSettings is null
									|| app.ReplayRecordInfos.Length <= i) {
								warn("Game state changed while scanning records. Retrying in 500ms...");
								break;
							}
						}
					}
				}

				/* this is session-best, check this as well */
				if(app.CurrentPlayground !is null
						&& app.CurrentPlayground.GameTerminals.Length > 0
						&& cast<CTrackManiaPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer) !is null
						&& cast<CTrackManiaPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer).Score !is null) {
					int sessScore = int(cast<CTrackManiaPlayer>(app.CurrentPlayground.GameTerminals[0].GUIPlayer).Score.BestTime);
					if(sessScore > 0 && (score < 0 || sessScore < score)) {
						score = sessScore;
					}
				}

				pbest.time = score;
				pbest.medal = CalcMedal();
			}
#endif
			else {
				pbest.time = -1;
				pbest.medal = 0;
			}

		} else if(map is null || map.MapInfo.MapUid == "") {
#if TMNEXT||MP4
			author.time = -5;
#elif TURBO
			stmaster.time = -9;
			sgold.time = -8;
			ssilver.time = -7;
			sbronze.time = -6;
			tmaster.time = -5;
#endif
			gold.time = -4;
			silver.time = -3;
			bronze.time = -2;
			pbest.time = -1;
			pbest.medal = 0;

			currentMapUid = "";
		}

		times.SortAsc();

		sleep(500);
	}
}

#if TURBO||MP4
uint CalcMedal() {
#if TURBO
	if(pbest <= stmaster) return 8;
	else if(pbest <= sgold) return 7;
	else if(pbest <= ssilver) return 6;
	else if(pbest <= sbronze) return 5;
	else if(pbest <= tmaster) return 4;
#elif MP4
	if(pbest <= author) return 4;
#endif
	else if(pbest <= gold) return 3;
	else if(pbest <= silver) return 2;
	else if(pbest <= bronze) return 1;
	else return 0;
}
#endif
