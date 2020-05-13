
#define VUEUI_SET_CHECK(a, b, c, d) if (a != b) { a = b; c = d; }
#define VUEUI_SET_CHECK_IFNOTSET(a, b, c, d) if (a == null && a != b) { a = b; c = d; }
#define VUEUI_SET_IFNOTSET(a, b, c, d) if (a == null) { a = b; c = d; }
#define VUEUI_SET_CHECK_LIST(a, b, c, d) if (!same_entries(a,b)) { a = b; c = d; } // Do not use for lists that contain lists

#define THEME_TYPE_DARK 1
#define THEME_TYPE_LIGHT 0

#define FALLBACK_HTML_THEME "theme-nano dark-theme"

#define VUEUI_MONITOR_VARS(type, monitor_name)                    \
/datum/vueui_var_monitor/##monitor_name { subject_type = type; }; \
                                                                  \
/datum/vueui_var_monitor/##monitor_name/populate_var_holders()
