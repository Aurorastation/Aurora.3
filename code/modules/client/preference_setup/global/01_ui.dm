/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1

/datum/category_item/player_setup_item/player_global/ui/load_preferences(var/savefile/S)
	S["UI_style"]       >> pref.UI_style
	S["UI_style_color"] >> pref.UI_style_color
	S["UI_style_alpha"] >> pref.UI_style_alpha
	S["html_UI_style"]  >> pref.html_UI_style
	S["skin_theme"]  >> pref.skin_theme
	S["ooccolor"]       >> pref.ooccolor
	S["clientfps"]			>> pref.clientfps

/datum/category_item/player_setup_item/player_global/ui/save_preferences(var/savefile/S)
	S["UI_style"]       << pref.UI_style
	S["UI_style_color"] << pref.UI_style_color
	S["UI_style_alpha"] << pref.UI_style_alpha
	S["html_UI_style"]  << pref.html_UI_style
	S["skin_theme"]  << pref.skin_theme
	S["ooccolor"]       << pref.ooccolor
	S["clientfps"]			<< pref.clientfps

/datum/category_item/player_setup_item/player_global/ui/gather_load_query()
	return list(
		"ss13_player_preferences" = list(
			"vars" = list(
				"UI_style",
				"UI_style_color",
				"UI_style_alpha",
				"html_UI_style",
				"skin_theme",
				"ooccolor",
				"clientfps"
			),
			"args" = list("ckey")
		)
	)

/datum/category_item/player_setup_item/player_global/ui/gather_load_parameters()
	return list("ckey" = PREF_CLIENT_CKEY)

/datum/category_item/player_setup_item/player_global/ui/gather_save_query()
	return list(
		"ss13_player_preferences" = list(
			"UI_style",
			"UI_style_color",
			"UI_style_alpha",
			"html_UI_style",
			"skin_theme",
			"ooccolor",
			"clientfps",
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/player_global/ui/gather_save_parameters()
	return list(
		"ckey" = PREF_CLIENT_CKEY,
		"UI_style_alpha" = pref.UI_style_alpha,
		"UI_style_color" = pref.UI_style_color,
		"UI_style" = pref.UI_style,
		"html_UI_style" = pref.html_UI_style,
		"skin_theme" = pref.skin_theme,
		"ooccolor" = pref.ooccolor,
		"clientfps" = pref.clientfps
	)

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.UI_style       = sanitize_inlist(pref.UI_style, all_ui_styles, initial(pref.UI_style))
	pref.UI_style_color = sanitize_hexcolor(pref.UI_style_color, initial(pref.UI_style_color))
	pref.UI_style_alpha = sanitize_integer(text2num(pref.UI_style_alpha), 0, 255, initial(pref.UI_style_alpha))
	pref.clientfps = sanitize_integer(text2num(pref.clientfps), 0, 1000, initial(pref.clientfps))
	pref.html_UI_style       = sanitize_inlist(pref.html_UI_style, SStheming.available_html_themes, initial(pref.html_UI_style))
	pref.skin_theme       = sanitize_inlist(pref.skin_theme, SStheming.skin_themes, initial(pref.skin_theme))
	pref.ooccolor       = sanitize_hexcolor(pref.ooccolor, initial(pref.ooccolor))

/datum/category_item/player_setup_item/player_global/ui/content(mob/user)
	var/list/dat = list()
	dat += "<b>UI Settings</b><br>"
	dat += "<b>UI Style:</b> <a href='?src=\ref[src];select_style=1'><b>[pref.UI_style]</b></a><br>"
	dat += "<b>Custom UI</b> (recommended for White UI):<br>"
	dat += "-Color: <a href='?src=\ref[src];select_color=1'><b>[pref.UI_style_color]</b></a> [HTML_RECT(pref.UI_style_color)] - <a href='?src=\ref[src];reset=ui'>reset</a><br>"
	dat += "-Alpha(transparency): <a href='?src=\ref[src];select_alpha=1'><b>[pref.UI_style_alpha]</b></a> - <a href='?src=\ref[src];reset=alpha'>reset</a><br>"
	dat += "<b>HTML UI Style:</b> <a href='?src=\ref[src];select_html=1'><b>[pref.html_UI_style]</b></a><br>"
	dat += "<b>Main UI Style:</b> <a href='?src=\ref[src];select_skin_theme=1'><b>[pref.skin_theme]</b></a><br>"
	dat += "-FPS: <a href='?src=\ref[src];select_fps=1'><b>[pref.clientfps]</b></a> - <a href='?src=\ref[src];reset=fps'>reset</a><br>"
	if(can_select_ooc_color(user))
		dat += "<b>OOC Color:</b> "
		if(pref.ooccolor == initial(pref.ooccolor))
			dat += "<a href='?src=\ref[src];select_ooc_color=1'><b>Using Default</b></a><br>"
		else
			dat += "<a href='?src=\ref[src];select_ooc_color=1'><b>[pref.ooccolor]</b></a> [HTML_RECT(pref.ooccolor)] - <a href='?src=\ref[src];reset=ooc'>reset</a><br>"

	. = dat.Join()

/datum/category_item/player_setup_item/player_global/ui/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["select_style"])
		var/UI_style_new = input(user, "Choose UI style.", "Character Preference", pref.UI_style) as null|anything in all_ui_styles
		if(!UI_style_new || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style = UI_style_new
		return TOPIC_REFRESH

	else if(href_list["select_color"])
		var/UI_style_color_new = input(user, "Choose UI color, dark colors are not recommended!", "Global Preference", pref.UI_style_color) as color|null
		if(isnull(UI_style_color_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_color = UI_style_color_new
		return TOPIC_REFRESH

	else if(href_list["select_alpha"])
		var/UI_style_alpha_new = input(user, "Select UI alpha (transparency) level, between 50 and 255.", "Global Preference", pref.UI_style_alpha) as num|null
		if(isnull(UI_style_alpha_new) || (UI_style_alpha_new < 50 || UI_style_alpha_new > 255) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.UI_style_alpha = UI_style_alpha_new
		return TOPIC_REFRESH

	else if(href_list["select_html"])
		var/html_style_new = input(user, "Choose HTML UI style.", "Global Preference", pref.html_UI_style) as null|anything in SStheming.available_html_themes
		if(isnull(html_style_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.html_UI_style = html_style_new
		return TOPIC_REFRESH

	else if(href_list["select_skin_theme"])
		var/skin_theme_new = input(user, "Choose HTML UI style.", "Global Preference", pref.skin_theme) as null|anything in SStheming.skin_themes
		if(isnull(skin_theme_new) || !CanUseTopic(user)) return TOPIC_NOACTION
		pref.skin_theme = skin_theme_new
		if(SStheming)
			SStheming.apply_theme_from_perfs(user)
		return TOPIC_REFRESH

	else if(href_list["select_ooc_color"])
		var/new_ooccolor = input(user, "Choose OOC color:", "Global Preference") as color|null
		if(new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			pref.ooccolor = new_ooccolor
			return TOPIC_REFRESH

	else if ("select_fps")
		#if DM_VERSION >= 511
		var/desiredfps = input(user, "Choose your desired fps.\n(0 = synced with server tick rate (currently:[world.fps]))", "Character Preference")  as null|num
		pref.clientfps = sanitize_integer(desiredfps, 0, 1000, initial(pref.clientfps))
		user.client.fps = pref.clientfps
		#else
		to_user_chat("\nThis server does not currently support client side fps. You can set now for when it does.")
		#endif // DM_VERSION >= 511



	else if(href_list["reset"])
		switch(href_list["reset"])
			if("ui")
				pref.UI_style_color = initial(pref.UI_style_color)
			if("alpha")
				pref.UI_style_alpha = initial(pref.UI_style_alpha)
			if("ooc")
				pref.ooccolor = initial(pref.ooccolor)
			if("fps")
				pref.clientfps = 0
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/player_global/ui/proc/can_select_ooc_color(var/mob/user)
	return config.allow_admin_ooccolor && check_rights(R_ADMIN, 0, user)
