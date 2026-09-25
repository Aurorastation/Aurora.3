/datum/instrument_ui/env_editor
	name = "Environment Editor"
	var/datum/sound_player/player


/datum/instrument_ui/env_editor/New(datum/sound_player/player)
	..()
	src.host = player.actual_instrument
	src.player = player


/datum/instrument_ui/env_editor/ui_interact(mob/user, datum/tgui/ui)
	if(!GLOB.musical_config.env_settings_available)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EnvEditor", "Environment Editor")
		ui.open()

/datum/instrument_ui/env_editor/ui_data(mob/user)
	var/list/env_params = list()
	for(var/i = 1 to 23)
		var/list/bounds = GLOB.musical_config.env_params_bounds[i]
		env_params += list(list(
			"index"   = i,
			"name"    = GLOB.musical_config.env_param_names[i],
			"value"   = src.player.env[i],
			"min"     = bounds[1],
			"max"     = bounds[2],
			"real"    = bounds[3],
			"default" = GLOB.musical_config.env_default[i]
		))
	return list("env_params" = env_params)

/datum/instrument_ui/env_editor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	if(!GLOB.musical_config.env_settings_available)
		return

	if(action == "reset_all")
		src.player.env = GLOB.musical_config.env_default.Copy()
		return TRUE

	var/index = text2num(params["index"])
	if(!isnum(index) || !(index in 1 to 23))
		return

	var/param_name = GLOB.musical_config.env_param_names[index]
	var/param_desc = GLOB.musical_config.env_param_desc[index]
	var/param_default = GLOB.musical_config.env_default[index]
	var/list/bounds = GLOB.musical_config.env_params_bounds[index]
	var/bound_min = bounds[1]
	var/bound_max = bounds[2]
	var/reals_allowed = bounds[3]

	switch(action)
		if("set")
			var/new_value = tgui_input_number(usr, "[param_name]: [bound_min] - [bound_max]", "Environment Parameter", src.player.env[index], bound_max, bound_min)
			if(isnull(new_value))
				return TRUE
			new_value = reals_allowed ? new_value : round(new_value)
			src.player.env[index] = clamp(new_value, bound_min, bound_max)
			return TRUE
		if("reset")
			src.player.env[index] = param_default
			return TRUE
		if("desc")
			to_chat(usr, "[param_name]: from [bound_min] to [bound_max] (default: [param_default])<br>[param_desc]")
			return TRUE
