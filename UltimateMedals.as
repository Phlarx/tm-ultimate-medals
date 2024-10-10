[Setting category="Medals" name="Show Header"]
bool showHeader = true;

[Setting category="Medals" name="Show Personal Best"]
bool showPbest = true;

[Setting category="Medals" name="Show Champion"]
bool showChampion = false;

[Setting category="Medals" name="Show Warrior"]
bool showWarrior = true;

[Setting category="Medals" name="Show Author"]
bool showAuthor = true;

[Setting category="Medals" name="Show Gold"]
bool showGold = true;

[Setting category="Medals" name="Show Silver"]
bool showSilver = true;

[Setting category="Medals" name="Show Bronze"]
bool showBronze = true;

[Setting category="Additional Info" name="Show Map Name"]
bool showMapName = false;

[Setting category="Additional Info" name="Show Author Name"]
bool showAuthorName = false;

[Setting category="Additional Info" name="Limit Map Name length" description="If the map name is too long, it will automatically scroll to still make it readable."]
bool limitMapNameLength = true;

[Setting category="Additional Info" name="Limit Map Name length width" description="Width in pixels to limit the map name length by. This requires \"Limit Map Name length\" to be enabled." min="100" max="400"]
int limitMapNameLengthWidth = 275;

/*Icons::InfoCircle*/
[Setting category="Additional Info" name="Show Map Comment on Hover" description="An 'i' icon will appear next to the map name or author name, if a comment is available."]
bool showComment = false;

[Setting category="Additional Info" name="Show Medal Icons"]
bool showMedalIcons = true;

[Setting category="Additional Info" name="Show Personal Best Delta Time"]
bool showPbestDelta = false;

[Setting category="Additional Info" name="Show Personal Best Negative Delta Time"]
bool showPbestDeltaNegative = true;

[Setting category="Display Settings" name="Window visible" description="To adjust the position of the window, click and drag while the Openplanet overlay is visible."]
bool windowVisible = true;

[Setting category="Display Settings" name="Window visiblility hotkey"]
VirtualKey windowVisibleKey = VirtualKey(0);

[Setting category="Display Settings" name="Hide when the game interface is hidden"]
bool hideWithIFace = false;

[Setting category="Display Settings" name="Hide when the Openplanet overlay is hidden"]
bool hideWithOverlay = false;

[Setting category="Display Settings" name="Window position"]
vec2 anchor = vec2(0, 170);

[Setting category="Display Settings" name="Lock window position" description="Prevents the window moving when click and drag or when the game window changes size."]
bool lockPosition = false;

[Setting category="Display Settings" name="Font face" description="To avoid a memory issue with loading a large number of fonts, you must reload the plugin for font changes to be applied."]
string fontFace = "";

[Setting category="Display Settings" name="Font size" min=8 max=48 description="To avoid a memory issue with loading a large number of fonts, you must reload the plugin for font changes to be applied."]
int fontSize = 16;

/* Custom names */
[Setting category="Display Text" name="Show Champion Text"]
string championText = "Champion";

[Setting category="Display Text" name="Warrior Text"]
string warriorText = "Warrior";

[Setting category="Display Text" name="Author Text"]
string authorText = "Author";

[Setting category="Display Text" name="Gold Text"]
string goldText = "Gold";

[Setting category="Display Text" name="Silver Text"]
string silverText = "Silver";

[Setting category="Display Text" name="Bronze Text"]
string bronzeText = "Bronze";

[Setting category="Display Text" name="Personal Best Text" description="Override names to be shown in the window."]
string pbestText = "Pers. Best";

/* Custom Colors */
[Setting category="Colors" name="Positive Color"]
string positiveColor = "f77";

[Setting category="Colors" name="Negative Color"]
string negativeColor = "77f";

[Setting category="Colors" name="Neutral Color"]
string neutralColor = "aaa";

// UI::Texture@ warriorMedalTexture = UI::LoadTexture("warrior_32.png");
// UI::Texture@ championMedalTexture = UI::LoadTexture("champion_medal_32.png");

// [Setting category="Colors" name="PB Color (Doesn't work yet)"]
// string pbColor = "7ff";

const array<string> medals = {
	"\\$444" + Icons::Circle, // no medal
	"\\$964" + Icons::Circle, // bronze medal
	"\\$899" + Icons::Circle, // silver medal
	"\\$db4" + Icons::Circle, // gold medal
	"\\$071" + Icons::Circle, // author medal
	"\\$16a" + Icons::Circle, // warrior medal
	"\\$c13" + Icons::Circle  // champion medal
};

// class MedalIcon {
//     bool isTexture;
//     string iconText;
//     UI::Texture@ iconTexture;

//     MedalIcon(const string &in iconText) {
//         this.isTexture = false;
//         this.iconText = iconText;
//     }

//     MedalIcon(UI::Texture@ iconTexture) {
//         this.isTexture = true;
//         @this.iconTexture = iconTexture;
//     }

//     void DrawIcon() {
//         if (isTexture) {
// 			// UI::Dummy(vec2(1, 0));
//             UI::Image(iconTexture, vec2(16, 16));
//         } else {
//             UI::Text(iconText);
//         }
//     }
// }


// class MedalTime {
//     MedalIcon@ icon;

//     MedalTime(MedalIcon@ icon) {
//         @this.icon = icon;
//     }

//     void DrawIcon() {
//         icon.DrawIcon();
//     }
// }

// const array<MedalTime@> medals = {
// 	MedalTime("\\$444" + Icons::Circle), // no medal
// 	MedalTime("\\$964" + Icons::Circle), // bronze medal
// 	MedalTime("\\$899" + Icons::Circle), // silver medal
// 	MedalTime("\\$db4" + Icons::Circle), // gold medal
// 	MedalTime("\\$071" + Icons::Circle), // author medal
// 	MedalTime(warriorMedalTexture), // warrior medal
// 	MedalTime(championMedalTexture)  // champion medal
// };

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
		UI::Text(medals[this.medal]);
	}

	// void DrawIcon() {
    //     if (medal < medals.Length) {
    //         medals[medal].DrawIcon();
    //     } else {
    //         UI::Text("\\$f00" + Icons::Circle); // Fallback icon
    //     }
    // }

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
		if (delta < 0 && showPbestDeltaNegative) {
			UI::Text("\\$" + negativeColor + "-" + Time::Format(delta * -1));
		} else if (delta > 0) {
			UI::Text("\\$" + positiveColor + "+" + Time::Format(delta));
		} else {
			UI::Text("\\$  " + neutralColor + "0:00.000");
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

Record@ champion = Record(championText, 6, -7);
Record@ warrior = Record(warriorText, 5, -6);
Record@ author = Record(authorText, 4, -5);
Record@ gold = Record(goldText, 3, -4);
Record@ silver = Record(silverText, 2, -3);
Record@ bronze = Record(bronzeText, 1, -2);
Record@ pbest = Record(pbestText, 0, -1, "\\$0ff");

array<Record@> times = {champion, warrior, author, gold, silver, bronze, pbest};

bool campaignMap = false;

int timeWidth = 53;
int deltaWidth = 60;

string loadedFontFace = "";
int loadedFontSize = 0;
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
	if(UI::MenuItem("\\$00f" + Icons::Circle + "\\$7f7 Custom Medals Window", "", windowVisible)) {
		windowVisible = !windowVisible;
	}
}

void Render() {
	auto app = cast<CTrackMania>(GetApp());
	
auto map = app.RootMap;
	
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
		
		UI::PushFont(font);
		
		UI::Begin("Advanced Medals", windowFlags);
		
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
				mapNameText += StripFormatCodes(map.MapInfo.Name);
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
				string authorNameText = "\\$888by " + StripFormatCodes(map.MapInfo.AuthorNickName);
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
	UI::Dummy(vec2(width, 0));
	UI::PopStyleVar();
}

void LoadFont() {
	string fontFaceToLoad = fontFace.Length == 0 ? "DroidSans.ttf" : fontFace;
	if(fontFaceToLoad != loadedFontFace || fontSize != loadedFontSize) {
		@font = UI::LoadFont(fontFaceToLoad, fontSize, -1, -1, true, true, true);
		if(font !is null) {
			loadedFontFace = fontFaceToLoad;
			loadedFontSize = fontSize;
		}
	}
}

void UpdateHidden() {
	champion.hidden = !showChampion;
	warrior.hidden = !showWarrior;
	author.hidden = !showAuthor;
	gold.hidden = !showGold;
	silver.hidden = !showSilver;
	bronze.hidden = !showBronze;
	pbest.hidden = !showPbest;
}

void UpdateText() {
	champion.name = championText;
	warrior.name = warriorText;
	author.name = authorText;
	gold.name = goldText;
	silver.name = silverText;
	bronze.name = bronzeText;
	pbest.name = pbestText;
}

void OnSettingsChanged() {
	//LoadFont(); // Disabled dynamic font changes due to memory leak. See issue https://github.com/Phlarx/tm-ultimate-medals/issues/17
	UpdateHidden();
	UpdateText();
}

void Main() {
	NadeoServices::AddAudience("NadeoLiveServices");

	while (!NadeoServices::IsAuthenticated("NadeoLiveServices")) {
    	yield();
    }

	auto app = cast<CTrackMania>(GetApp());
	auto network = cast<CTrackManiaNetwork>(app.Network);

	
	LoadFont();
	UpdateHidden();
	UpdateText();
	
	string currentMapUid = "";
	
	while(true) {
		auto map = app.RootMap;
		
		if(windowVisible && map !is null && map.MapInfo.MapUid != "" && app.Editor is null) {
			if(currentMapUid != map.MapInfo.MapUid) {
				sleep(1000);
				
				// champion.time = -1;
				// warrior.time = -1;
				author.time = map.TMObjective_AuthorTime;
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

#if DEPENDENCY_CHAMPIONMEDALS
    uint cm_time = ChampionMedals::GetCMTime();

    if (cm_time == 0) {
        champion.hidden = true;
	} else {
		champion.time = cm_time;
	}
#else
	champion.hidden = true;
#endif 

#if DEPENDENCY_WARRIORMEDALS
    uint wm_time = WarriorMedals::GetWMTime();
    if (wm_time == 0) {
        warrior.hidden = true;
    } else {
        warrior.time = wm_time;
    }
#else
    warrior.hidden = true;
#endif

			}
			
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
				pbest.medal = CalcMedal();
			}
			else {
				pbest.time = -1;
				pbest.medal = 0;
			}
			
		} else if(map is null || map.MapInfo.MapUid == "") {
			champion.time = -7;
			warrior.time = -6;
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

uint CalcMedal() {
	if(pbest <= champion && champion.time > 0) return 6;
	else if(pbest <= warrior && warrior.time > 0) return 5;
	else if(pbest <= author) return 4;
	else if(pbest <= gold) return 3;
	else if(pbest <= silver) return 2;
	else if(pbest <= bronze) return 1;
	else return 0;
}
