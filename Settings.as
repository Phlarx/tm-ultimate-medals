// Medals
[Setting category="Medals" name="Personal Best"]
bool showPbest = true;

#if TMNEXT || MP4
[Setting category="Medals" name="Author medal"]
bool showAuthor = true;

#elif TURBO
[Setting category="Medals" name="Super Trackmaster" description="Super medals will automatically be hidden on non-campaign tracks."]
bool showStmaster = true;

[Setting category="Medals" name="Super Gold medal"]
bool showSgold = false;

[Setting category="Medals" name="Super Silver medal"]
bool showSsilver = false;

[Setting category="Medals" name="Super Bronze medal"]
bool showSbronze = false;

[Setting category="Medals" name="Trackmaster"]
bool showTmaster = true;
#endif

[Setting category="Medals" name="Gold medal"]
bool showGold = true;

[Setting category="Medals" name="Silver medal"]
bool showSilver = true;

[Setting category="Medals" name="Bronze medal"]
bool showBronze = true;



// Medal Names
#if TMNEXT||MP4
[Setting category="Medal Names" name="Author Text"]
string authorText = "Author";

#elif TURBO
[Setting category="Medal Names" name="Super Trackmaster Text"]
string stmasterText = "S. Trackmaster";

[Setting category="Medal Names" name="Super Gold Text"]
string sgoldText = "S. Gold";

[Setting category="Medal Names" name="Super Silver Text"]
string ssilverText = "S. Silver";

[Setting category="Medal Names" name="Super Bronze Text"]
string sbronzeText = "S. Bronze";

[Setting category="Medal Names" name="Trackmaster Text"]
string tmasterText = "Trackmaster";
#endif

[Setting category="Medal Names" name="Gold Text"]
string goldText = "Gold";

[Setting category="Medal Names" name="Silver Text"]
string silverText = "Silver";

[Setting category="Medal Names" name="Bronze Text"]
string bronzeText = "Bronze";

[Setting category="Medal Names" name="Personal Best Text" description="Override names to be shown in the window."]
string pbestText = "Pers. Best";



// Appearance
[Setting category="Appearance" name="Show table header"]
bool showHeader = true;

[Setting category="Appearance" name="Show map name"]
bool showMapName = false;

[Setting category="Appearance" if="showMapName" name="Limit map name length" description="If the map name is too long, it will automatically scroll to still make it readable."]
bool limitMapNameLength = true;

[Setting category="Appearance" if="showMapName" name="Limit map name length width" description="Width in pixels to limit the map name length by. This requires \"Limit Map Name length\" to be enabled." min="100" max="400"]
int limitMapNameLengthWidth = 275;

[Setting category="Appearance" if="showMapName" name="Show map author name"]
bool showAuthorName = false;

[Setting category="Appearance" name="Show map comment on hover" description="An 'i' icon will appear next to the map name or author name, if a comment is available."]
bool showComment = false;

[Setting category="Appearance" name="Show medal icons"]
bool showMedalIcons = true;

[Setting category="Appearance" name="Show Personal Best delta times"]
bool showPbestDelta = false;

[Setting category="Appearance" name="Show Personal Best negative delta times"]
bool showPbestDeltaNegative = true;

[Setting category="Appearance" name="Positive Color" color if="showPbestDelta"]
vec3 deltaColorPositive = vec3(1.0f, 0.47f, 0.47f);

[Setting category="Appearance" name="Negative Color" color if="showPbestDelta"]
vec3 deltaColorNegative = vec3(0.47f, 0.47f, 1.0f);

[Setting category="Appearance" name="Neutral Color" color if="showPbestDelta"]
vec3 deltaColorNeutral = vec3(0.66f, 0.66f, 0.66f);

[Setting category="Appearance" name="Font face" description="You must reload the plugin for the font change to be applied."]
string fontFace = "";

[Setting category="Appearance" name="Font size" min=8 max=48]
int fontSize = 16;



// Behavior
[Setting category="Behavior" name="Window visible" description="To adjust the position of the window, click and drag while the Openplanet overlay is visible."]
bool windowVisible = true;

[Setting category="Behavior" name="Window visibility hotkey enabled"]
bool windowVisibleKeyEnabled = false;

[Setting category="Behavior" name="Window visibility hotkey" if="windowVisibleKeyEnabled"]
VirtualKey windowVisibleKey = VirtualKey::F5;

[Setting category="Behavior" name="Hide when the game interface is hidden"]
bool hideWithIFace = false;

[Setting category="Behavior" name="Hide when the Openplanet overlay is hidden"]
bool hideWithOverlay = false;

[Setting category="Behavior" name="Window position"]
vec2 anchor = vec2(0, 170);

[Setting category="Behavior" name="Lock window position" description="Prevents the window moving when click and drag or when the game window changes size."]
bool lockPosition = false;
