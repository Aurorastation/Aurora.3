/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1

/datum/category_item/player_setup_item/player_global/ui/load_preferences(var/savefile/S)
	S["UI_style"]				>> pref.UI_style
	S["UI_style_color"]			>> pref.UI_style_color
	S["UI_style_alpha"]			>> pref.UI_style_alpha
	S["tgui_fancy"]				>> pref.tgui_fancy
	S["tgui_lock"]				>> pref.tgui_lock
	S["ooccolor"]				>> pref.ooccolor
	S["clientfps"]				>> pref.clientfps
	S["tooltip_style"]			>> pref.tooltip_style
	S["tgui_inputs"]			>> pref.tgui_inputs
	S["tgui_buttons_large"]		>> pref.tgui_buttons_large
	S["tgui_inputs_swapped"]	>> pref.tgui_inputs_swapped

/datum/category_item/player_setup_item/player_global/ui/save_preferences(var/savefile/S)
	S["UI_style"]				<< pref.UI_style
	S["UI_style_color"]			<< pref.UI_style_color
	S["UI_style_alpha"]			<< pref.UI_style_alpha
	S["tgui_fancy"]				<< pref.tgui_fancy
	S["tgui_lock"]				<< pref.tgui_lock
	S["ooccolor"]				<< pref.ooccolor
	S["clientfps"]				<< pref.clientfps
	S["tooltip_style"]			<< pref.tooltip_style
	S["tgui_inputs"]			<< pref.tgui_inputs
	S["tgui_buttons_large"]		<< pref.tgui_buttons_large
	S["tgui_inputs_swapped"]	<< pref.tgui_inputs_swapped

/datum/category_item/player_setup_item/player_global/ui/gather_load_query()
	return list(
		"ss13_player_preferences" = list(
			"vars" = list(
				"UI_style",
				"UI_style_color",
				"UI_style_alpha",
				"tgui_fancy",
				"tgui_lock",
				"ooccolor",
				"clientfps",
				"tooltip_style",
				"tgui_inputs",
				"tgui_buttons_large",
				"tgui_inputs_swapped"
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
			"tgui_fancy",
			"tgui_lock",
			"ooccolor",
			"clientfps",
			"tooltip_style",
			"tgui_inputs",
			"tgui_buttons_large",
			"tgui_inputs_swapped",
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/player_global/ui/gather_save_parameters()
	return list(
		"ckey" = PREF_CLIENT_CKEY,
		"UI_style_alpha" = pref.UI_style_alpha,
		"UI_style_color" = pref.UI_style_color,
		"UI_style" = pref.UI_style,
		"tgui_fancy" = pref.tgui_fancy,
		"tgui_lock" = pref.tgui_lock,
		"ooccolor" = pref.ooccolor,
		"clientfps" = pref.clientfps,
		"tooltip_style" = pref.tooltip_style,
		"tgui_inputs" = pref.tgui_inputs,
		"tgui_buttons_large" = pref.tgui_buttons_large,
		"tgui_inputs_swapped" = pref.tgui_inputs_swapped
	)

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.UI_style = sanitize_inlist(pref.UI_style, GLOB.all_ui_styles, initial(pref.UI_style))
	pref.UI_style_color = sanitize_hexcolor(pref.UI_style_color, initial(pref.UI_style_color))
	pref.UI_style_alpha = sanitize_integer(text2num(pref.UI_style_alpha), 0, 255, initial(pref.UI_style_alpha))
	pref.clientfps = sanitize_integer(text2num(pref.clientfps), 0, 1000, initial(pref.clientfps))
	pref.tgui_fancy = sanitize_bool(pref.tgui_fancy, TRUE)
	pref.tgui_lock = sanitize_bool(pref.tgui_lock, FALSE)
	pref.tgui_inputs = sanitize_bool(pref.tgui_inputs, TRUE)
	pref.tgui_buttons_large = sanitize_bool(pref.tgui_buttons_large, FALSE)
	pref.tgui_inputs_swapped = sanitize_bool(pref.tgui_inputs_swapped, FALSE)
	pref.ooccolor = sanitize_hexcolor(pref.ooccolor, initial(pref.ooccolor))

/datum/category_item/player_setup_item/player_global/ui/content(mob/user)
	var/list/dat = list()
	dat += "<b>UI Settings</b><br>"
	dat += "<b>UI Style:</b> <a href='byond://?src=[REF(src)];select_style=1'><b>[pref.UI_style]</b></a><br>"
	dat += "<b>Custom UI</b> (recommended for White UI):<br>"
	dat += "-Color: <a href='byond://?src=[REF(src)];select_color=1'><b>[pref.UI_style_color]</b></a> [HTML_RECT(pref.UI_style_color)] - <a href='byond://?src=[REF(src)];reset=ui'>reset</a><br>"
	dat += "-Alpha(transparency): <a href='byond://?src=[REF(src)];select_alpha=1'><b>[pref.UI_style_alpha]</b></a> - <a href='byond://?src=[REF(src)];reset=alpha'>reset</a><br>"
	dat += "<b>Tooltip Style:</b> <a href='byond://?src=[REF(src)];select_tooltip_style=1'><b>[pref.tooltip_style]</b></a><br>"
	dat += "<b>TGUI Fancy:</b> <a href='byond://?src=[REF(src)];select_tguif=1'><b>[pref.tgui_fancy ? "ON" : "OFF"]</b></a><br>"
	dat += "<b>TGUI Lock:</b> <a href='byond://?src=[REF(src)];select_tguil=1'><b>[pref.tgui_lock ? "ON" : "OFF"]</b></a><br>"
	dat += "<b>TGUI Inputs:</b> <a href='byond://?src=[REF(src)];tgui_inputs=1'><b>[pref.tgui_inputs ? "ON" : "OFF"]</b></a><br>"
	dat += "<b>TGUI Input Large Buttons:</b> <a href='byond://?src=[REF(src)];tgui_inputs_large=1'><b>[pref.tgui_buttons_large ? "ON" : "OFF"]</b></a><br>"
	dat += "<b>TGUI Input Swapped Buttons:</b> <a href='byond://?src=[REF(src)];tgui_inputs_swapped=1'><b>[pref.tgui_inputs_swapped ? "ON" : "OFF"]</b></a><br>"
	dat += "<b>FPS:</b> <a href='byond://?src=[REF(src)];select_fps=1'><b>[pref.clientfps]</b></a> - <a href='byond://?src=[REF(src)];reset=fps'>reset</a><br>"
	if(can_select_ooc_color(user))
		dat += "<b>OOC Color:</b> "
		if(pref.ooccolor == initial(pref.ooccolor))
			dat += "<a href='byond://?src=[REF(src)];select_ooc_color=1'><b>Using Default</b></a><br>"
		else
			dat += "<a href='byond://?src=[REF(src)];select_ooc_color=1'><b>[pref.ooccolor]</b></a> [HTML_RECT(pref.ooccolor)] - <a href='byond://?src=[REF(src)];reset=ooc'>reset</a><br>"

	. = dat.Join()

/datum/category_item/player_setup_item/player_global/ui/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["select_style"])
		var/UI_style_new = input(user, "Choose UI style.", "Character Preference", pref.UI_style) as null|anything in GLOB.all_ui_styles
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

	else if(href_list["select_tguif"])
		pref.tgui_fancy = !pref.tgui_fancy
		return TOPIC_REFRESH

	else if(href_list["select_tguil"])
		pref.tgui_lock = !pref.tgui_lock
		return TOPIC_REFRESH

	else if(href_list["tgui_inputs"])
		pref.tgui_inputs = !pref.tgui_inputs
		return TOPIC_REFRESH

	else if(href_list["tgui_inputs_large"])
		pref.tgui_buttons_large = !pref.tgui_buttons_large
		return TOPIC_REFRESH

	else if(href_list["tgui_inputs_swapped"])
		pref.tgui_inputs_swapped = !pref.tgui_inputs_swapped
		return TOPIC_REFRESH

	else if(href_list["select_ooc_color"])
		var/new_ooccolor = input(user, "Choose OOC color:", "Global Preference") as color|null
		if(new_ooccolor && can_select_ooc_color(user) && CanUseTopic(user))
			pref.ooccolor = new_ooccolor
			return TOPIC_REFRESH

	else if(href_list["select_fps"])
		var/version_message
		if (user.client && user.client.byond_version < 511)
			version_message = "\nYou need to be using byond version 511 or later to take advantage of this feature, your version of [user.client.byond_version] is too low"
		if (world.byond_version < 511)
			version_message += "\nThis server does not currently support client side fps. You can set now for when it does."
		var/new_fps = input(user, "Choose your desired fps.[version_message]\n(0 = synced with server tick rate (currently:[world.fps]))", "Global Preference") as num|null
		if (isnum(new_fps) && CanUseTopic(user))
			pref.clientfps = clamp(new_fps, 0, 1000)

			var/mob/target_mob = preference_mob()
			if(target_mob && target_mob.client)
				target_mob.client.apply_fps(pref.clientfps)
			return TOPIC_REFRESH

	else if(href_list["select_tooltip_style"])
		var/tooltip_style_new = input(user, "Choose a new tooltip style.", "Global Preference", pref.tooltip_style) as null|anything in GLOB.all_tooltip_styles
		if(!tooltip_style_new || !CanUseTopic(user))
			return TOPIC_NOACTION
		pref.tooltip_style = tooltip_style_new
		return TOPIC_REFRESH

	else if(href_list["reset"])
		switch(href_list["reset"])
			if("ui")
				pref.UI_style_color = initial(pref.UI_style_color)
			if("alpha")
				pref.UI_style_alpha = initial(pref.UI_style_alpha)
			if("ooc")
				pref.ooccolor = initial(pref.ooccolor)
			if("fps")
				pref.clientfps = initial(pref.clientfps)
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/player_global/ui/proc/can_select_ooc_color(var/mob/user)
	return GLOB.config.allow_admin_ooccolor && check_rights(R_ADMIN, 0, user)
