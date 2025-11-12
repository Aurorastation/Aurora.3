/datum/tgui_module/narrate_panel/ui_interact(var/mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NarratePanel", "Narrate Panel", 800, 400)
		ui.open()

/datum/tgui_module/narrate_panel/ui_data(mob/user)
	var/list/data = list()
	data["narrate_styles"] = list("danger", "notice", "warning", "alien", "cult")
	data["narrate_locations"] = list("View", "Range", "Z-Level", "Global")
	return data

/datum/tgui_module/narrate_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/abstract/ghost/ghost = ui.user
	if(!istype(ghost))
		return FALSE

	if(action == "narrate")
		var/narrate_text = sanitizeSafe(params["narrate_text"])
		if(!length(narrate_text))
			to_chat(ghost, SPAN_WARNING("No text was supplied!"))
			return FALSE

		var/narrate_style = params["narrate_style"]
		if(!narrate_style)
			to_chat(ghost, SPAN_WARNING("No text style was supplied!"))
			return FALSE

		var/narrate_size = text2num(params["narrate_size"])
		if(!isnum(narrate_size))
			to_chat(ghost, SPAN_WARNING("No text size was supplied!"))
			return FALSE

		var/narrate_range = text2num(params["narrate_range"])
		if(!isnum(narrate_range))
			to_chat(ghost, SPAN_WARNING("No narrate range was supplied!"))
			return FALSE

		var/narrate_location = params["narrate_location"]
		if(!narrate_location)
			to_chat(ghost, SPAN_WARNING("No narrate location was supplied!"))
			return FALSE

		var/list/mobs_to_message = list()
		switch(narrate_location)
			if("View")
				for(var/mob/M in get_hearers_in_view(narrate_range, ghost))
					mobs_to_message |= M

			if("Range")
				for(var/mob/M in get_hearers_in_range(narrate_range, ghost))
					mobs_to_message |= M

			if("Z-Level")
				for(var/mob/M in GLOB.player_list)
					if(GET_Z(M) == ghost.z)
						mobs_to_message |= M

			if("Global")
				mobs_to_message = GLOB.player_list.Copy()

		for(var/mob/actor in mobs_to_message)
			to_chat(actor, "<font size=[narrate_size]><span class='[narrate_style]'>[narrate_text]</span></font>")
