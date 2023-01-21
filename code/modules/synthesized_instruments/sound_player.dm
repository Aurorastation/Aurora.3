
/datum/sound_player

	var/range = 15
	var/volume = 30
	var/max_volume = 50
	var/falloff = 2
	var/apply_echo = 0
	var/virtual_environment_selected = 0
	var/env[23]
	var/echo[18]

	var/datum/weakref/wait = null

	var/datum/synthesized_song/song
	var/datum/instrument/instrument
	var/obj/actual_instrument

	var/datum/musical_event_manager/event_manager = new

	var/list/datum/sound_token/instrument/tokens = list()

/datum/sound_player/New(datum/real_instrument/where, datum/instrument/what)
	src.song = new (src, what)
	src.actual_instrument = where
	src.echo = musical_config.echo_default.Copy()
	src.env = musical_config.env_default.Copy()
	instrument_synchronizer.register_global(src, .proc/check_wait)

/datum/sound_player/Destroy()
	src.song.playing = 0
	src.actual_instrument = null
	src.instrument = null
	QDEL_NULL(song)
	QDEL_NULL(event_manager)
	tokens.Cut()
	instrument_synchronizer.unregister_global(src, .proc/check_wait)
	wait = null
	. = ..()

/datum/sound_player/proc/check_wait(obj/other)
	if(wait && (other != actual_instrument))
		var/mob/M = wait.resolve()
		if(istype(M) && !shouldStopPlaying(M))
			if(get_dist(get_turf(actual_instrument), get_turf(other)) <= 5 && !song.playing)
				song.playing = TRUE
				song.play_song(M)
	wait = null //Either way clean it up

/datum/sound_player/proc/subscribe(datum/sound_token/instrument/newtoken)
	if(!istype(newtoken))
		CRASH("Non token type passed to subscribe function.")
	tokens += newtoken

	//Tell it of what we saw prior to it spawning
	newtoken.PrivLocateListeners()


/datum/sound_player/proc/unsubscribe(datum/sound_token/instrument/oldtoken)
	if(!istype(oldtoken))
		CRASH("Non token type passed to unsubscribe function.")
	tokens -= oldtoken


/datum/sound_player/proc/apply_modifications(sound/what, note_num, which_line, which_note) // You don't need to override this
	what.volume = volume
	what.falloff = falloff
	if (musical_config.env_settings_available)
		what.environment = musical_config.is_custom_env(src.virtual_environment_selected) ? src.env : src.virtual_environment_selected
	if (src.apply_echo)
		what.echo = src.echo
	return

/datum/sound_player/proc/shouldStopPlaying(mob/user)
	var/obj/structure/synthesized_instrument/S = actual_instrument
	var/obj/item/device/synthesized_instrument/D = actual_instrument
	if(istype(S))
		return S.shouldStopPlaying(user)
	if(istype(D))
		return D.shouldStopPlaying(user)

	return 1 //Well if you got this far you did something very wrong