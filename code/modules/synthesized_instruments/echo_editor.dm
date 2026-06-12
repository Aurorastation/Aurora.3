/datum/instrument_ui/echo_editor
	name = "Echo Editor"
	var/datum/sound_player/player


/datum/instrument_ui/echo_editor/New(datum/sound_player/player)
	..()
	src.host = player.actual_instrument
	src.player = player


/datum/instrument_ui/echo_editor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EchoEditor", "Echo Editor")
		ui.open()

/datum/instrument_ui/echo_editor/ui_data(mob/user)
	var/list/echo_params = list()
	for(var/i = 1 to 18)
		echo_params += list(list(
			"index" = i,
			"name"  = GLOB.musical_config.echo_param_names[i],
			"value" = src.player.echo[i],
			"real"  = GLOB.musical_config.echo_params_bounds[i][3]
		))
	return list("echo_params" = echo_params)

/datum/instrument_ui/echo_editor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/index = text2num(params["index"])
	if(!isnum(index) || !(index in 1 to 18))
		return

	var/param_name = GLOB.musical_config.echo_param_names[index]
	var/param_desc = GLOB.musical_config.echo_param_desc[index]
	var/param_default = GLOB.musical_config.echo_default[index]
	var/list/bounds = GLOB.musical_config.echo_params_bounds[index]
	var/bound_min = bounds[1]
	var/bound_max = bounds[2]
	var/reals_allowed = bounds[3]

	switch(action)
		if("set")
			var/new_value = tgui_input_number(usr, "[param_name]: [bound_min] - [bound_max]", "Echo Parameter", src.player.echo[index], bound_max, bound_min)
			if(isnull(new_value))
				return TRUE
			new_value = reals_allowed ? new_value : round(new_value)
			src.player.echo[index] = clamp(new_value, bound_min, bound_max)
			return TRUE
		if("reset")
			src.player.echo[index] = param_default
			return TRUE
		if("reset_all")
			src.player.echo = GLOB.musical_config.echo_default.Copy()
			return TRUE
		if("desc")
			to_chat(usr, "[param_name]: from [bound_min] to [bound_max] (default: [param_default])<br>[param_desc]")
			return TRUE
