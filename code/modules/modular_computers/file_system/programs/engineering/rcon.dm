/datum/computer_file/program/rcon_console
	filename = "rcon"
	filedesc = "RCON Remote Control"
	program_icon_state = "power_monitor"
	program_key_icon_state = "yellow_key"
	extended_desc = "This program allows remote control of power distribution systems around the station. This program can not be run on tablet computers."
	required_access_run = access_engine
	required_access_download = access_ce
	requires_ntnet = TRUE
	network_destination = "RCON remote control system"
	requires_ntnet_feature = NTNET_SYSTEMCONTROL
	usage_flags = PROGRAM_CONSOLE | PROGRAM_STATIONBOUND
	size = 19
	color = LIGHT_COLOR_YELLOW
	tgui_id = "RCON"
	tgui_theme = "hephaestus"
	ui_auto_update = FALSE

/datum/computer_file/program/rcon_console/ui_data(mob/user)
	var/list/data = initial_data()

	var/list/smeslist = list()
	for(var/obj/machinery/power/smes/buildable/SMES in SSmachinery.rcon_smes_units)
		smeslist.Add(list(list(
		"charge" = round(SMES.Percentage()),
		"input_set" = SMES.input_attempt,
		"input_val" = round(SMES.input_level),
		"output_set" = SMES.output_attempt,
		"output_val" = round(SMES.output_level),
		"input_level_max" = SMES.input_level_max,
		"output_level_max" = SMES.output_level_max,
		"output_load" = round(SMES.output_used),
		"RCON_tag" = SMES.RCon_tag
		)))

	data["smes_info"] = smeslist
	// BREAKER DATA (simplified view)
	var/list/breakerlist = list()
	for(var/obj/machinery/power/breakerbox/BR in SSmachinery.rcon_breaker_units)
		breakerlist.Add(list(list(
		"RCON_tag" = BR.RCon_tag,
		"enabled" = BR.on,
		"update_locked" = BR.update_locked,
		)))
	data["breaker_info"] = breakerlist

	return data

/datum/computer_file/program/rcon_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return

	switch(action)
		if("smes_in_toggle")
			var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(params["smes_in_toggle"])
			if(SMES)
				SMES.toggle_input()
				computer.update_static_data_for_all_viewers()
				. = TRUE

		if("smes_out_toggle")
			var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(params["smes_out_toggle"])
			if(SMES)
				SMES.toggle_output()
				computer.update_static_data_for_all_viewers()
				. = TRUE

		if("smes_in_set")
			var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(params["smes_in_set"])
			if(SMES)
				SMES.set_input(params["value"])
				computer.update_static_data_for_all_viewers()
				. = TRUE

		if("smes_out_set")
			var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(params["smes_out_set"])
			if(SMES)
				SMES.set_output(params["value"])
				computer.update_static_data_for_all_viewers()
				. = TRUE

		if("smes_in_max")
			var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(params["smes_in_max"])
			if(SMES)
				SMES.set_input(SMES.input_level_max)
				computer.update_static_data_for_all_viewers()
				. = TRUE

		if("smes_out_max")
			var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(params["smes_out_max"])
			if(SMES)
				SMES.set_output(SMES.output_level_max)
				computer.update_static_data_for_all_viewers()
				. = TRUE

		if("toggle_breaker")
			var/obj/machinery/power/breakerbox/toggle = SSmachinery.rcon_breaker_units_by_tag[params["toggle_breaker"]]
			if(toggle)
				if(toggle.update_locked)
					to_chat(usr, SPAN_WARNING("The breaker box was recently toggled. Please wait before toggling it again."))
				else
					toggle.auto_toggle()
					computer.update_static_data_for_all_viewers()
					. = TRUE

/datum/computer_file/program/rcon_console/proc/GetSMESByTag(var/tag)
	if(!tag)
		return

	return SSmachinery.rcon_smes_units_by_tag[tag]
