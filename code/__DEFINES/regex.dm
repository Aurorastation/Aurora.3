// Global REGEX datums for regular use without recompiling

// The lazy URL finder. Lazy in that it matches the bare minimum
// Replicates BYOND's own URL parser in functionality.
GLOBAL_DATUM_INIT(url_find_lazy, /regex, new("((https?|byond):\\/\\/\[^\\s\]*)", "g"))

// REGEX datums used for process_chat_markup.
GLOBAL_DATUM_INIT(markup_bold, /regex, new("((\\W|^)\\*)(\[^\\*\]*)(\\*(\\W|$))", "g"))
GLOBAL_DATUM_INIT(markup_italics, /regex, new("((\\W|^)\\/)(\[^\\/\]*)(\\/(\\W|$))", "g"))
GLOBAL_DATUM_INIT(markup_strike, /regex, new("((\\W|^)\\~)(\[^\\~\]*)(\\~(\\W|$))", "g"))
GLOBAL_DATUM_INIT(markup_underline, /regex, new("((\\W|^)\\_)(\[^\\_\]*)(\\_(\\W|$))", "g"))

// Global list for mark-up REGEX datums.
// Initialized in the hook, to avoid passing by null value.
// GLOBAL_LIST_EMPTY(markup_regex)
GLOBAL_LIST_INIT(markup_regex, list("/" = GLOB.markup_italics,
						"*" = GLOB.markup_bold,
						"~" = GLOB.markup_strike,
						"_" = GLOB.markup_underline))

// Global list for mark-up REGEX tag collection.
GLOBAL_LIST_INIT(markup_tags, list("/" = list("<i>", "</i>"),
						"*" = list("<b>", "</b>"),
						"~" = list("<strike>", "</strike>"),
						"_" = list("<u>", "</u>")))
