//This is similar to normal sound tokens
//Mostly it allows non repeating sounds to keep channel ownership

/datum/sound_token/instrument
	var/use_env = 0
	var/datum/sound_player/player

//Slight duplication, but there's key differences
/datum/sound_token/instrument/New(atom/source, sound_id, sound/sound, range = 4, prefer_mute = FALSE, use_env, datum/sound_player/player)
	if(!istype(source))
		CRASH("Invalid sound source: [log_info_line(source)]")
	if(!istype(sound))
		CRASH("Invalid sound: [log_info_line(sound)]")
	if(sound.repeat && !sound_id)
		CRASH("No sound id given")
	if(!PrivIsValidEnvironment(sound.environment))
		CRASH("Invalid sound environment: [log_info_line(sound.environment)]")

	src.prefer_mute = prefer_mute
	src.range       = range
	src.source      = source
	src.sound       = sound
	src.sound_id    = sound_id
	src.use_env = use_env
	src.player = player
	src.sound_type = ASFX_INSTRUMENT

	var/channel = GLOB.sound_player.PrivGetChannel(src) //Attempt to find a channel
	if(!isnum(channel))
		CRASH("All available sound channels are in active use.")
	sound.channel = channel

	listeners = list()
	listener_status = list()

	GLOB.destroyed_event.register(source, src, /datum/proc/qdel_self)

	player.subscribe(src)


/datum/sound_token/instrument/PrivGetEnvironment(listener)
	//Allow override (in case your instrument has to sound funky or muted)
	if(use_env)
		return sound.environment
	else
		var/area/A = get_area(listener)
		return A && PrivIsValidEnvironment(A.sound_environment) ? A.sound_environment : sound.environment

/datum/sound_token/instrument/Stop()
	player.unsubscribe(src)
	. = ..()

/datum/sound_token/instrument/Destroy()
	. = ..()
	GLOB.destroyed_event.unregister(source, src, /datum/proc/qdel_self)
	player.unsubscribe(src)
	player = null
