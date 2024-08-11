/// Standard maptext
/// Prepares a text to be used for maptext. Use this so it doesn't look hideous.
#define MAPTEXT(text) {"<span class='maptext'>[##text]</span>"}

/**
 * Pixel-perfect scaled fonts for use in the MAP element as defined in skin.dmf
 *
 * Four sizes to choose from, use the sizes as mentioned below.
 * Between the variations and a step there should be an option that fits your use case.
 * BYOND uses pt sizing, different than px used in TGUI. Using px will make it look blurry due to poor antialiasing.
 *
 * Default sizes are prefilled in the macro for ease of use and a consistent visual look.
 * To use a step other than the default in the macro, specify it in a span style.
 * For example: MAPTEXT_PIXELLARI("<span style='font-size: 24pt'>Some large maptext here</span>")
 */
/// Large size (ie: context tooltips) - Size options: 12pt 24pt.
#define MAPTEXT_PIXELLARI(text) {"<span style='font-family: \"Pixellari\"; font-size: 12pt; -dm-text-outline: 1px black'>[##text]</span>"}

/// Standard size (ie: normal runechat) - Size options: 6pt 12pt 18pt.
#define MAPTEXT_GRAND9K(text) {"<span style='font-family: \"Grand9K Pixel\"; font-size: 6pt; -dm-text-outline: 1px black'>[##text]</span>"}

/// Small size. (ie: context subtooltips, spell delays) - Size options: 12pt 24pt.
#define MAPTEXT_TINY_UNICODE(text) {"<span style='font-family: \"TinyUnicode\"; font-size: 12pt; line-height: 0.75; -dm-text-outline: 1px black'>[##text]</span>"}

/// Smallest size. (ie: whisper runechat) - Size options: 6pt 12pt 18pt.
#define MAPTEXT_SPESSFONT(text) {"<span style='font-family: \"Spess Font\"; font-size: 6pt; line-height: 1.4; -dm-text-outline: 1px black'>[##text]</span>"}

/*
	DEFINES USED FOR "generate_floating_text"
*/
///Whispers and similar
#define GENERATE_FLOATING_TEXT_SMALL BITFLAG(1)
///Normal talking
#define GENERATE_FLOATING_TEXT_MEDIUM BITFLAG(2)
///Screaming
#define GENERATE_FLOATING_TEXT_LARGE BITFLAG(3)


/// Macro from Lummox used to get height from a MeasureText proc.
/// resolves the MeasureText() return value once, then resolves the height, then sets return_var to that.
#define WXH_TO_HEIGHT(measurement, return_var) \
	do { \
		var/_measurement = measurement; \
		return_var = text2num(copytext(_measurement, findtextEx(_measurement, "x") + 1)); \
	} while(FALSE);

#define SMALL_FONTS(FONTSIZE, MSG) "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: [FONTSIZE]px;\">[MSG]</span>"

/// Max width of chat message in pixels
#define CHAT_MESSAGE_WIDTH 112

//Since we do not have GLOB (yet), this will have to do
var/regex/html_tags = regex(@"<.*?>", "g")
var/regex/angular_brackets = regex(@"[<>]", "g")
var/regex/filename_forbidden_chars = regex(@{""|[\\\n\t/?%*:|<>]|\.\."}, "g")

/// Removes characters incompatible with file names.
#define SANITIZE_FILENAME(text) (filename_forbidden_chars.Replace(text, ""))

/// Simply removes the < and > characters, and limits the length of the message.
#define STRIP_HTML_SIMPLE(text, limit) (angular_brackets.Replace(copytext(text, 1, limit), ""))

/// Removes everything enclose in < and > inclusive of the bracket, and limits the length of the message.
#define STRIP_HTML_FULL(text, limit) (html_tags.Replace(copytext(text, 1, limit), ""))
