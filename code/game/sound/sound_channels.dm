GLOBAL_LIST_INIT(used_sound_channels, list(
	CHANNEL_MASTER_VOLUME,
	CHANNEL_LOBBYMUSIC,
	CHANNEL_ADMIN,
	CHANNEL_VOX,
	CHANNEL_JUKEBOX,
	CHANNEL_HEARTBEAT,
	CHANNEL_AMBIENCE,
	CHANNEL_BUZZ,
	CHANNEL_SOUND_EFFECTS,
	CHANNEL_SOUND_FOOTSTEPS,
	CHANNEL_WEATHER,
	CHANNEL_MACHINERY,
	CHANNEL_INSTRUMENTS,
	CHANNEL_MOB_SOUNDS,
))

GLOBAL_LIST_INIT(proxy_sound_channels, list(
	CHANNEL_SOUND_EFFECTS,
	CHANNEL_SOUND_FOOTSTEPS,
	CHANNEL_WEATHER,
	CHANNEL_MACHINERY,
	CHANNEL_INSTRUMENTS,
	CHANNEL_MOB_SOUNDS,
))

GLOBAL_DATUM_INIT(cached_mixer_channels, /alist, alist())

/proc/guess_mixer_channel(soundin)
	var/sound_text_string
	if(istype(soundin, /sound))
		var/sound/bleh = soundin
		sound_text_string = "[bleh.file]"
	else
		sound_text_string = "[soundin]"
	if(GLOB.cached_mixer_channels[sound_text_string])
		return GLOB.cached_mixer_channels[sound_text_string]
	else if(findtext(sound_text_string, "effects/"))
		. = GLOB.cached_mixer_channels[sound_text_string] = CHANNEL_SOUND_EFFECTS
	else if(findtext(sound_text_string, "machines/"))
		. = GLOB.cached_mixer_channels[sound_text_string] = CHANNEL_MACHINERY
	else if(findtext(sound_text_string, "creatures/"))
		. = GLOB.cached_mixer_channels[sound_text_string] = CHANNEL_MOB_SOUNDS
	else if(findtext(sound_text_string, "/ai/"))
		. = GLOB.cached_mixer_channels[sound_text_string] = CHANNEL_VOX
	else if(findtext(sound_text_string, "chatter/"))
		. = GLOB.cached_mixer_channels[sound_text_string] = CHANNEL_MOB_SOUNDS
	else if(findtext(sound_text_string, "items/"))
		. = GLOB.cached_mixer_channels[sound_text_string] = CHANNEL_SOUND_EFFECTS
	else if(findtext(sound_text_string, "weapons/"))
		. = GLOB.cached_mixer_channels[sound_text_string] = CHANNEL_SOUND_EFFECTS
	else
		return FALSE

/// Calculates the "adjusted" volume for a user's volume mixer
/proc/calculate_mixed_volume(client/client, volume, mixer_channel)
	. = volume
	var/list/channels = client?.prefs?.channel_volume
	if(!channels)
		return volume
	var/static/master_volume_key = "[CHANNEL_MASTER_VOLUME]"

	if(master_volume_key in channels)
		. *= channels[master_volume_key] * 0.01
	if(mixer_channel)
		var/mixer_channel_key = "[mixer_channel]"
		if(mixer_channel_key in channels)
			. *= channels[mixer_channel_key] * 0.01

/mob/proc/stop_sound_channel(chan)
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = chan))

/mob/proc/set_sound_channel_volume(channel, volume)
	var/sound/S = sound(null, FALSE, FALSE, channel, volume)
	S.status = SOUND_UPDATE
	SEND_SOUND(src, S)
