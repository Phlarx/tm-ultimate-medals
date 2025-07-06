[Setting category="Medals" name="Show Header"]
bool showHeader = true;

[Setting category="Medals" name="Show Personal Best"]
bool showPbest = true;

#if TMNEXT||MP4
[Setting category="Medals" name="Show Author"]
bool showAuthor = true;

#elif TURBO
[Setting category="Medals" name="Show Super Trackmaster" description="Super medals will automatically be hidden on non-campaign tracks."]
bool showStmaster = true;

[Setting category="Medals" name="Show Super Gold"]
bool showSgold = false;

[Setting category="Medals" name="Show Super Silver"]
bool showSsilver = false;

[Setting category="Medals" name="Show Super Bronze"]
bool showSbronze = false;

[Setting category="Medals" name="Show Trackmaster"]
bool showTmaster = true;
#endif

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

[Setting category="Display Settings" name="Font face" description="You must reload the plugin for the font change to be applied."]
string fontFace = "";

[Setting category="Display Settings" name="Font size" min=8 max=48]
int fontSize = 16;

/* Custom names */
#if TMNEXT||MP4
[Setting category="Display Text" name="Author Text"]
string authorText = "Author";

#elif TURBO
[Setting category="Display Text" name="Super Trackmaster Text"]
string stmasterText = "S. Trackmaster";

[Setting category="Display Text" name="Super Gold Text"]
string sgoldText = "S. Gold";

[Setting category="Display Text" name="Super Silver Text"]
string ssilverText = "S. Silver";

[Setting category="Display Text" name="Super Bronze Text"]
string sbronzeText = "S. Bronze";

[Setting category="Display Text" name="Trackmaster Text"]
string tmasterText = "Trackmaster";
#endif

[Setting category="Display Text" name="Gold Text"]
string goldText = "Gold";

[Setting category="Display Text" name="Silver Text"]
string silverText = "Silver";

[Setting category="Display Text" name="Bronze Text"]
string bronzeText = "Bronze";

[Setting category="Display Text" name="Personal Best Text" description="Override names to be shown in the window."]
string pbestText = "Pers. Best";

[Setting category="Colors" name="Positive Color"]
vec3 positiveColor = vec3(255,119,119);

[Setting category="Colors" name="Negative Color"]
vec3 negativeColor = vec3(119,119,255);

[Setting category="Colors" name="Neutral Color"]
vec3 neutralColor = vec3(170,170,170);
