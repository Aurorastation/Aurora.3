var/repository/sound_channels/sound_channels = new()
// lobby_sound_channel = sound_channels.RequestChannel("LOBBY")
// vote_sound_channel = sound_channels.RequestChannel("VOTE")
// admin_sound_channel = sound_channels.RequestChannel("ADMIN_FUN")

// ambience_channel_vents = sound_channels.RequestChannel("AMBIENCE_VENTS")
// ambience_channel_forced = sound_channels.RequestChannel("AMBIENCE_FORCED")
// ambience_channel_common = sound_channels.RequestChannel("AMBIENCE_COMMON")

/repository/sound_channels
	var/datum/stack/available_channels
	var/list/keys_by_channel           // So we know who to blame if we run out
	var/channel_ceiling	= 1024         // Initial value is the current BYOND maximum number of channels

	var/weather_channel

/repository/sound_channels/New()
	..()
	available_channels = new()
	weather_channel = RequestChannel("WEATHER")

/repository/sound_channels/proc/RequestChannel(key)
	. = RequestChannels(key, 1)
	return LAZYLEN(.) && .[1]

/repository/sound_channels/proc/RequestChannels(key, amount)
	if(!key)
		CRASH("Invalid key given.")
	. = list()

	for(var/i = 1 to amount)
		var/channel = available_channels.Pop() // Check if someone else has released their channel.
		if(!channel)
			if(channel_ceiling <= 0) // This basically means we ran out of channels
				break
			channel = channel_ceiling--
		. += channel

	if(length(.) != amount)
		ReleaseChannels(.)
		CRASH("Unable to supply the requested amount of channels: [key] - Expected [amount], was [length(.)]")

	for(var/channel in .)
		LAZYSET(keys_by_channel, "[channel]", key)
	return .

/repository/sound_channels/proc/ReleaseChannel(channel)
	ReleaseChannels(list(channel))

/repository/sound_channels/proc/ReleaseChannels(list/channels)
	for(var/channel in channels)
		LAZYREMOVE(keys_by_channel, "[channel]")
		available_channels.Push(channel)
