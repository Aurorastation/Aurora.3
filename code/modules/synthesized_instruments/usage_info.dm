/datum/instrument_ui/usage_info
	name = "Usage Info"
	var/datum/sound_player/player

/datum/instrument_ui/usage_info/New(atom/source, datum/sound_player/player)
	..()
	src.host = source
	src.player = player

//This will let you easily monitor when you're going overboard with tempo and sound duration, generally if the bars fill up it is BAD
/datum/instrument_ui/usage_info/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SongUsageInfo", "Usage Info")
		ui.open()

/datum/instrument_ui/usage_info/ui_data(mob/user)
	return list(
		"channels_left" = GLOB.sound_channels.available_channels.stack.len,
		"events_active" = src.player.event_manager.events.len,
		"max_channels" = GLOB.sound_channels.channel_ceiling,
		"max_events" = GLOB.musical_config.max_events
	)


/datum/instrument_ui/usage_info/Destroy()
	player = null
	return ..()
