var/datum/controller/subsystem/theming/SStheming

/datum/controller/subsystem/theming
	name = "Theming"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_FIRST

	var/list/available_html_themes = list(
		"Nano" = list(
			"name" = "Nano Dark",
			"class" = "theme-nano",
			"type" = THEME_TYPE_DARK
		),
		"Nano Light" = list(
			"name" = "Nano Light",
			"class" = "theme-nano-light",
			"type" = THEME_TYPE_LIGHT
		),
		"Basic" = list(
			"name" = "Basic Light",
			"class" = "theme-basic",
			"type" = THEME_TYPE_LIGHT
		),
		"Basic Dark" = list(
			"name" = "Basic Dark",
			"class" = "theme-basic-dark",
			"type" = THEME_TYPE_DARK
		)
	)

/datum/controller/subsystem/theming/New()
	NEW_SS_GLOBAL(SStheming)

/datum/controller/subsystem/theming/proc/get_html_theme(var/mob/user)
	var/client/cl = null
	if(istype(user))
		cl = user.client
	else
		if(istype(user, /client))
			cl = user
	if(!cl)
		return
	var/style = cl.prefs.html_UI_style
	if(!(style in available_html_themes))
		style = "Nano"
	return available_html_themes[style]

/datum/controller/subsystem/theming/proc/get_html_theme_class(var/mob/user)
	var/list/theme = get_html_theme(user)
	if(!theme)
		return FALLBACK_HTML_THEME
	var/class = ""
	class += "[theme["class"]]"
	if(theme["type"] == THEME_TYPE_DARK)
		class += " dark-theme"
	return class

/proc/send_theme_resources(var/user)
#ifdef UIDEBUG
	user << browse_rsc(file("vueui/dist/app.js"), "vueui.js")
	user << browse_rsc(file("vueui/dist/app.css"), "vueui.css")
	user << browse_rsc(file("vueui/dist/app.js.map"), "app.js.map")
#else
	simple_asset_ensure_is_sent(user, /datum/asset/simple/vueui)
#endif

/proc/get_html_theme_header(var/themeclass, var/extra_header = "")
	return {"<html><head><meta charset="UTF-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><link rel="stylesheet" type="text/css" href="vueui.css">[extra_header]</head><body class="[themeclass]">"}

/proc/get_html_theme_footer()
	return {"</body></html>"}

/proc/enable_ui_theme(var/user, var/contents, var/extra_header = "")
	var/theme_class = FALLBACK_HTML_THEME
	if(SStheming)
		theme_class = SStheming.get_html_theme_class(user)
	return get_html_theme_header(theme_class, extra_header) + contents + get_html_theme_footer()
