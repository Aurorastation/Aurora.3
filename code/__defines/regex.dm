// Global REGEX datums for regular use without recompiling

// The lazy URL finder. Lazy in that it matches the bare minimum
// Replicates BYOND's own URL parser in functionality.
var/global/regex/url_find_lazy

// REGEX datums used for process_chat_markup.
var/global/regex/markup_bold
var/global/regex/markup_italics
var/global/regex/markup_strike
var/global/regex/markup_underline

// Global list for mark-up REGEX datums.
var/global/list/markup_regex = list("/" = markup_italics,
									"*" = markup_bold,
									"~" = markup_strike,
									"_" = markup_underline)

// Global list for mark-up REGEX tag collection.
var/global/list/markup_tags = list("/" = list("<i>", "</i>"),
						"*" = list("<b>", "</b>"),
						"~" = list("<strike>", "</strike>"),
						"_" = list("<u>", "</u>"))

/hook/startup/proc/initialize_global_regex()
	url_find_lazy = new("(https?:\\/\\/\[^\\s\]*)", "g")

	markup_bold = 		new("(\\*)(\[^\\*\]*)(\\*)", "g")
	markup_italics = 	new("(\\/)(\[^\\/\]*)(\\/)", "g")
	markup_strike = 	new("(\\~)(\[^\\~\]*)(\\~)", "g")
	markup_underline = 	new("(\\_)(\[^\\_\]*)(\\_)", "g")
