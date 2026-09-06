/datum/category_item/player_setup_item/player_global/ui
	name = "UI"
	sort_order = 1

/datum/category_item/player_setup_item/player_global/ui/load_preferences(var/savefile/S)
	S["UI_style"]				>> pref.UI_style
	S["UI_style_color"]			>> pref.UI_style_color
	S["UI_style_alpha"]			>> pref.UI_style_alpha
	S["tgui_lock"]				>> pref.tgui_lock
	S["ooccolor"]				>> pref.ooccolor
	S["clientfps"]				>> pref.clientfps
	S["tooltip_style"]			>> pref.tooltip_style
	S["tgui_inputs"]			>> pref.tgui_inputs
	S["tgui_buttons_large"]		>> pref.tgui_buttons_large
	S["tgui_inputs_swapped"]	>> pref.tgui_inputs_swapped
	S["tgui_say_light_mode"]	>> pref.tgui_say_light_mode
	S["ui_scale"]				>> pref.ui_scale

/datum/category_item/player_setup_item/player_global/ui/save_preferences(var/savefile/S)
	S["UI_style"]				<< pref.UI_style
	S["UI_style_color"]			<< pref.UI_style_color
	S["UI_style_alpha"]			<< pref.UI_style_alpha
	S["tgui_lock"]				<< pref.tgui_lock
	S["ooccolor"]				<< pref.ooccolor
	S["clientfps"]				<< pref.clientfps
	S["tooltip_style"]			<< pref.tooltip_style
	S["tgui_inputs"]			<< pref.tgui_inputs
	S["tgui_buttons_large"]		<< pref.tgui_buttons_large
	S["tgui_inputs_swapped"]	<< pref.tgui_inputs_swapped
	S["tgui_say_light_mode"]	<< pref.tgui_say_light_mode
	S["ui_scale"]				<< pref.ui_scale

/datum/category_item/player_setup_item/player_global/ui/gather_load_query()
	return list(
		"ss13_player_preferences" = list(
			"vars" = list(
				"UI_style",
				"UI_style_color",
				"UI_style_alpha",
				"tgui_lock",
				"ooccolor",
				"clientfps",
				"tooltip_style",
				"tgui_inputs",
				"tgui_buttons_large",
				"tgui_inputs_swapped",
				"tgui_say_light_mode",
				"ui_scale",
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
			"tgui_lock",
			"ooccolor",
			"clientfps",
			"tooltip_style",
			"tgui_inputs",
			"tgui_buttons_large",
			"tgui_inputs_swapped",
			"tgui_say_light_mode",
			"ui_scale",
			"ckey" = 1
		)
	)

/datum/category_item/player_setup_item/player_global/ui/gather_save_parameters()
	return list(
		"ckey" = PREF_CLIENT_CKEY,
		"UI_style_alpha" = pref.UI_style_alpha,
		"UI_style_color" = pref.UI_style_color,
		"UI_style" = pref.UI_style,
		"tgui_lock" = pref.tgui_lock,
		"ooccolor" = pref.ooccolor,
		"clientfps" = pref.clientfps,
		"tooltip_style" = pref.tooltip_style,
		"tgui_inputs" = pref.tgui_inputs,
		"tgui_buttons_large" = pref.tgui_buttons_large,
		"tgui_inputs_swapped" = pref.tgui_inputs_swapped,
		"tgui_say_light_mode" = pref.tgui_say_light_mode,
		"ui_scale" = pref.ui_scale
	)

/datum/category_item/player_setup_item/player_global/ui/sanitize_preferences()
	pref.UI_style = sanitize_inlist(pref.UI_style, GLOB.all_ui_styles, initial(pref.UI_style))
	pref.UI_style_color = sanitize_hexcolor(pref.UI_style_color, initial(pref.UI_style_color))
	pref.UI_style_alpha = sanitize_integer(text2num(pref.UI_style_alpha), 0, 255, initial(pref.UI_style_alpha))
	pref.clientfps = sanitize_integer(text2num(pref.clientfps), 0, 1000, initial(pref.clientfps))
	pref.tgui_lock = sanitize_bool(pref.tgui_lock, FALSE)
	pref.tgui_inputs = sanitize_bool(pref.tgui_inputs, TRUE)
	pref.tgui_buttons_large = sanitize_bool(pref.tgui_buttons_large, FALSE)
	pref.tgui_inputs_swapped = sanitize_bool(pref.tgui_inputs_swapped, FALSE)
	pref.tgui_say_light_mode = sanitize_bool(pref.tgui_say_light_mode, FALSE)
	pref.ooccolor = sanitize_hexcolor(pref.ooccolor, initial(pref.ooccolor))

/datum/category_item/player_setup_item/player_global/ui/ui_data(mob/user)
	var/list/fields = list(
		list("label" = "UI Style", "value" = pref.UI_style, "action" = "select_style"),
		list("label" = "Custom UI Color", "value" = pref.UI_style_color, "color" = pref.UI_style_color, "action" = "select_color", "actions" = list(list("label" = "Reset", "action" = "reset", "value" = "ui", "icon" = "rotate"))),
		list("label" = "Alpha (Transparency)", "value" = pref.UI_style_alpha, "action" = "select_alpha", "actions" = list(list("label" = "Reset", "action" = "reset", "value" = "alpha", "icon" = "rotate"))),
		list("label" = "Tooltip Style", "value" = pref.tooltip_style, "action" = "select_tooltip_style"),
		list("label" = "TGUI Lock", "value" = pref.tgui_lock ? "On" : "Off", "action" = "select_tguil"),
		list("label" = "TGUI Inputs", "value" = pref.tgui_inputs ? "On" : "Off", "action" = "tgui_inputs"),
		list("label" = "Large Input Buttons", "value" = pref.tgui_buttons_large ? "On" : "Off", "action" = "tgui_inputs_large"),
		list("label" = "Swapped Input Buttons", "value" = pref.tgui_inputs_swapped ? "On" : "Off", "action" = "tgui_inputs_swapped"),
		list("label" = "TGUI Say Light Mode", "value" = pref.tgui_say_light_mode ? "On" : "Off", "action" = "tgui_say_light_mode"),
		list("label" = "UI Scaling", "value" = pref.ui_scale ? "On" : "Off", "action" = "ui_scale"),
		list("label" = "FPS", "value" = pref.clientfps, "action" = "select_fps", "actions" = list(list("label" = "Reset", "action" = "reset", "value" = "fps", "icon" = "rotate")))
	)
	if(can_select_ooc_color(user))
		fields += list(list(
			"label" = "OOC Color",
			"value" = pref.ooccolor == initial(pref.ooccolor) ? "Using Default" : pref.ooccolor,
			"color" = pref.ooccolor,
			"action" = "select_ooc_color",
			"actions" = list(list("label" = "Reset", "action" = "reset", "value" = "ooc", "icon" = "rotate"))
		))
	return list(
		"kind" = "form",
		"name" = name,
		"ref" = REF(src),
		"sections" = list(list("title" = "UI Settings", "description" = "Custom colors are recommended for the White UI style.", "fields" = fields))
	)

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

	else if(href_list["tgui_say_light_mode"])
		pref.tgui_say_light_mode = !pref.tgui_say_light_mode
		user.client.tgui_say?.load()
		return TOPIC_REFRESH

	else if(href_list["ui_scale"])
		pref.ui_scale = !pref.ui_scale
		user.client.tgui_say?.load()
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
