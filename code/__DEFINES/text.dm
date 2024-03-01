/// Standard maptext
/// Prepares a text to be used for maptext. Use this so it doesn't look hideous.
#define MAPTEXT(text) {"<span class='maptext'>[##text]</span>"}


/// Macro from Lummox used to get height from a MeasureText proc.
/// resolves the MeasureText() return value once, then resolves the height, then sets return_var to that.
#define WXH_TO_HEIGHT(measurement, return_var) \
	do { \
		var/_measurement = measurement; \
		return_var = text2num(copytext(_measurement, findtextEx(_measurement, "x") + 1)); \
	} while(FALSE);

#define SMALL_FONTS(FONTSIZE, MSG) "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: [FONTSIZE]px;\">[MSG]</span>"


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
