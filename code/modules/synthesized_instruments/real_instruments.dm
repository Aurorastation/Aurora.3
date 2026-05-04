//This is the combination of logic pertaining music
//An atom should use the logic and call it as it wants
/datum/real_instrument
	var/datum/instrument/instruments
	var/datum/sound_player/player
	var/datum/instrument_ui/song_editor/song_editor
	var/datum/instrument_ui/usage_info/usage_info
	var/maximum_lines
	var/maximum_line_length
	var/obj/owner
	var/datum/instrument_ui/env_editor/env_editor
	var/datum/instrument_ui/echo_editor/echo_editor

/datum/real_instrument/New(obj/who, datum/sound_player/how, datum/instrument/what)
	player = how
	owner = who
	maximum_lines = GLOB.musical_config.max_lines
	maximum_line_length = GLOB.musical_config.max_line_length
	instruments = what //This can be a list, or it can also not be one

/// Builds the data list consumed by the Synthesizer TGUI. Called from each instrument atom's ui_data().
/datum/real_instrument/proc/build_ui_data()
	return list(
		"playback" = list(
			"playing" = src.player.song.playing,
			"autorepeat" = src.player.song.autorepeat,
			"wait" = src.player.wait != null
		),
		"basic_options" = list(
			"cur_instrument" = src.player.song.instrument_data.name,
			"volume" = src.player.volume,
			"bpm" = round(600 / src.player.song.tempo),
			"transposition" = src.player.song.transposition,
			"octave_range" = list(
				"min" = src.player.song.octave_range_min,
				"max" = src.player.song.octave_range_max
			)
		),
		"advanced_options" = list(
			"all_environments" = GLOB.musical_config.all_environments,
			"selected_environment" = GLOB.musical_config.id_to_environment(src.player.virtual_environment_selected),
			"apply_echo" = src.player.apply_echo
		),
		"sustain" = list(
			"linear_decay_active" = src.player.song.linear_decay,
			"sustain_timer" = src.player.song.sustain_timer,
			"soft_coeff" = src.player.song.soft_coeff
		),
		"show" = list(
			"playback" = src.player.song.lines.len > 0,
			"custom_env_options" = GLOB.musical_config.is_custom_env(src.player.virtual_environment_selected),
			"env_settings" = GLOB.musical_config.env_settings_available
		),
		"status" = list(
			"channels" = src.player.song.available_channels,
			"events" = src.player.event_manager.events.len,
			"max_channels" = GLOB.musical_config.channels_per_instrument,
			"max_events" = GLOB.musical_config.max_events
		)
	)

/// Dispatches a TGUI action sent from the Synthesizer interface. Returns TRUE if handled.
/datum/real_instrument/proc/handle_ui_act(action, list/params, mob/user)
	var/value = text2num(params["value"])
	switch(action)
		if("tempo")
			src.player.song.tempo = src.player.song.sanitize_tempo(src.player.song.tempo + value * world.tick_lag)
			return TRUE
		if("play")
			src.player.song.playing = value
			if(src.player.song.playing)
				GLOB.instrument_synchronizer.raise_event(player.actual_instrument)
				src.player.song.play_song(user)
			return TRUE
		if("wait")
			if(value)
				src.player.wait = WEAKREF(user)
			else
				src.player.wait = null
			return TRUE
		if("newsong")
			src.player.song.lines.Cut()
			src.player.song.tempo = src.player.song.sanitize_tempo(5) // default 120 BPM
			return TRUE
		if("import")
			var/t = ""
			do
				t = html_encode(input(user, "Please paste the entire song, formatted:", "[owner.name]", t) as message)
				if(!CanInteractWith(user, owner, GLOB.physical_state))
					return TRUE
				if(length(t) >= 2 * src.maximum_lines * src.maximum_line_length)
					var/cont = input(user, "Your message is too long! Would you like to continue editing it?", "", "yes") in list("yes", "no")
					if(!CanInteractWith(user, owner, GLOB.physical_state))
						return TRUE
					if(cont == "no")
						break
			while(length(t) > 2 * src.maximum_lines * src.maximum_line_length)
			if(length(t))
				src.player.song.lines = splittext(t, "\n")
				if(copytext(src.player.song.lines[1], 1, 6) == "BPM: ")
					if(text2num(copytext(src.player.song.lines[1], 6)) != 0)
						src.player.song.tempo = src.player.song.sanitize_tempo(600 / text2num(copytext(src.player.song.lines[1], 6)))
						src.player.song.lines.Cut(1, 2)
					else
						src.player.song.tempo = src.player.song.sanitize_tempo(5)
				else
					src.player.song.tempo = src.player.song.sanitize_tempo(5) // default 120 BPM
				if(src.player.song.lines.len > maximum_lines)
					to_chat(user, "Too many lines!")
					src.player.song.lines.Cut(maximum_lines + 1)
				var/linenum = 1
				for(var/l in src.player.song.lines)
					if(length(l) > maximum_line_length)
						to_chat(user, "Line [linenum] too long!")
						src.player.song.lines.Remove(l)
					else
						linenum++
			return TRUE
		if("show_song_editor")
			if(!src.song_editor)
				src.song_editor = new(host = src.owner, song = src.player.song)
			src.song_editor.ui_interact(user)
			return TRUE
		if("show_usage")
			if(!src.usage_info)
				src.usage_info = new(owner, src.player)
			src.usage_info.ui_interact(user)
			return TRUE
		if("volume")
			src.player.volume = min(max(min(player.volume + value, 100), 0), player.max_volume)
			return TRUE
		if("transposition")
			src.player.song.transposition = max(min(player.song.transposition + value, GLOB.musical_config.highest_transposition), GLOB.musical_config.lowest_transposition)
			return TRUE
		if("min_octave")
			src.player.song.octave_range_min = max(min(player.song.octave_range_min + value, GLOB.musical_config.highest_octave), GLOB.musical_config.lowest_octave)
			src.player.song.octave_range_max = max(player.song.octave_range_max, player.song.octave_range_min)
			return TRUE
		if("max_octave")
			src.player.song.octave_range_max = max(min(player.song.octave_range_max + value, GLOB.musical_config.highest_octave), GLOB.musical_config.lowest_octave)
			src.player.song.octave_range_min = min(player.song.octave_range_max, player.song.octave_range_min)
			return TRUE
		if("sustain_timer")
			src.player.song.sustain_timer = max(min(player.song.sustain_timer + value, GLOB.musical_config.longest_sustain_timer), 1)
			return TRUE
		if("soft_coeff")
			var/new_coeff = input(user, "from [GLOB.musical_config.gentlest_drop] to [GLOB.musical_config.steepest_drop]") as num
			if(!CanInteractWith(user, owner, GLOB.physical_state))
				return TRUE
			new_coeff = round(min(max(new_coeff, GLOB.musical_config.gentlest_drop), GLOB.musical_config.steepest_drop), 0.001)
			src.player.song.soft_coeff = new_coeff
			return TRUE
		if("instrument")
			if(!islist(instruments))
				return TRUE
			var/list/as_list = instruments
			var/list/categories = list()
			for(var/key in as_list)
				var/datum/instrument/instrument = as_list[key]
				categories |= instrument.category
			var/category = input(user, "Choose a category") as null|anything in categories
			if(!CanInteractWith(user, owner, GLOB.physical_state))
				return TRUE
			var/list/instruments_available = list()
			for(var/key in as_list)
				var/datum/instrument/instrument = as_list[key]
				if(instrument.category == category)
					instruments_available += key
			var/new_instrument = input(user, "Choose an instrument") as null|anything in instruments_available
			if(!CanInteractWith(user, owner, GLOB.physical_state))
				return TRUE
			if(new_instrument)
				src.player.song.instrument_data = as_list[new_instrument]
			return TRUE
		if("autorepeat")
			src.player.song.autorepeat = value
			return TRUE
		if("decay")
			src.player.song.linear_decay = value
			return TRUE
		if("echo")
			src.player.apply_echo = value
			return TRUE
		if("show_env_editor")
			if(GLOB.musical_config.env_settings_available)
				if(!src.env_editor)
					src.env_editor = new(src.player)
				src.env_editor.ui_interact(user)
			else
				to_chat(user, "Virtual environment is disabled")
			return TRUE
		if("show_echo_editor")
			if(!src.echo_editor)
				src.echo_editor = new(src.player)
			src.echo_editor.ui_interact(user)
			return TRUE
		if("select_env")
			if(value in -1 to 26)
				src.player.virtual_environment_selected = round(value)
			return TRUE
	return FALSE

/datum/real_instrument/Destroy()
	if(islist(instruments))
		var/list/aslist = instruments
		QDEL_LIST_ASSOC_VAL(aslist)
	else
		QDEL_NULL(instruments)
	QDEL_NULL(player)
	QDEL_NULL(song_editor)
	QDEL_NULL(usage_info)
	owner = null
	QDEL_NULL(env_editor)
	QDEL_NULL(echo_editor)
	return ..()

/obj/structure/synthesized_instrument
	var/datum/real_instrument/real_instrument
	icon = 'icons/obj/musician.dmi'
	//Initialization data
	var/list/datum/instrument/instruments = list()
	var/path = /datum/instrument
	var/sound_player = /datum/sound_player

/obj/structure/synthesized_instrument/Initialize()
	. = ..()
	for(var/type in typesof(path))
		var/datum/instrument/new_instrument = new type
		if(!new_instrument.id) continue
		new_instrument.create_full_sample_deviation_map()
		src.instruments[new_instrument.name] = new_instrument
	src.real_instrument = new /datum/real_instrument(src, new sound_player(src, instruments[pick(instruments)]), instruments)

/obj/structure/synthesized_instrument/Destroy()
	QDEL_NULL(real_instrument)
	QDEL_LIST(instruments)
	return ..()

/obj/structure/synthesized_instrument/attack_hand(mob/user)
	src.interact(user)

/obj/structure/synthesized_instrument/interact(mob/user) // CONDITIONS ..(user) that shit in subclasses
	src.ui_interact(user)

/obj/structure/synthesized_instrument/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Synthesizer", name)
		ui.open()

/obj/structure/synthesized_instrument/ui_data(mob/user)
	return real_instrument.build_ui_data()

/obj/structure/synthesized_instrument/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	return real_instrument.handle_ui_act(action, params, usr)

/obj/structure/synthesized_instrument/proc/shouldStopPlaying(mob/user)
	return 0


////////////////////////
//DEVICE VERSION
////////////////////////


/obj/item/synthesized_instrument
	var/datum/real_instrument/real_instrument
	icon = 'icons/obj/musician.dmi'
	var/list/datum/instrument/instruments = list()
	var/path = /datum/instrument
	var/sound_player = /datum/sound_player

/obj/item/synthesized_instrument/Initialize()
	. = ..()
	for(var/type in typesof(path))
		var/datum/instrument/new_instrument = new type
		if(!new_instrument.id) continue
		new_instrument.create_full_sample_deviation_map()
		src.instruments[new_instrument.name] = new_instrument
	src.real_instrument = new /datum/real_instrument(src, new sound_player(src, instruments[pick(instruments)]), instruments)

/obj/item/synthesized_instrument/Destroy()
	QDEL_NULL(src.real_instrument)
	if(islist(instruments))
		var/list/as_list = instruments
		for(var/key in as_list)
			qdel(as_list[key])
	instruments = null
	. = ..()

/obj/item/synthesized_instrument/attack_self(mob/user)
	src.interact(user)

/obj/item/synthesized_instrument/interact(mob/user) // CONDITIONS ..(user) that shit in subclasses
	src.ui_interact(user)

/obj/item/synthesized_instrument/ui_interact(mob/user, datum/tgui/ui)
	if(!real_instrument)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Synthesizer", name)
		ui.open()

/obj/item/synthesized_instrument/ui_data(mob/user)
	return real_instrument.build_ui_data()

/obj/item/synthesized_instrument/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!real_instrument)
		return
	return real_instrument.handle_ui_act(action, params, usr)

/obj/item/synthesized_instrument/proc/shouldStopPlaying(mob/user)
	return !(src && in_range(src, user))
