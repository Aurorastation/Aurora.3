GLOBAL_DATUM_INIT(sound_player, /singleton/sound_player, new)

/*
	A sound player/manager for looping 3D sound effects.
	Due to how the BYOND sound engine works a sound datum must be played on a specific channel for updates to work properly.
	If a channel is not assigned it will just result in a new sound effect playing, even if re-using the same datum instance.
	We also use the channel to play a null-sound on Stop(), just in case BYOND clients don't like having a large nuber, albeit stopped, looping sounds.
	As such there is a maximum limit of 1024 sound sources, with further limitations due to some channels already being potentially in use.
	However, multiple sources may share the same sound_id and there is a best-effort attempt to play the closest source where possible.
	The line above is currently a lie. Will probably just have to enforce moderately short sound ranges.
*/

/singleton/sound_player
	var/list/taken_channels // taken_channels and source_id_uses can be merged into one but would then require a meta-object to store the different values I desire.
	var/list/sound_tokens_by_sound_id

/singleton/sound_player/New()
	..()
	taken_channels = list()
	sound_tokens_by_sound_id = list()


//This can be called if either we're doing whole sound setup ourselves or it will be as part of from-file sound setup
/singleton/sound_player/proc/PlaySoundDatum(atom/source, sound_id, sound/sound, range, prefer_mute, sound_type = ASFX_AMBIENCE)
	var/token_type = isnum(sound.environment) ? /datum/sound_token : /datum/sound_token/static_environment
	return new token_type(source, sound_id, sound, range, prefer_mute, sound_type)

/singleton/sound_player/proc/PlayLoopingSound(atom/source, sound_id, sound, volume, range, falloff = 1, echo, frequency, prefer_mute, sound_type = ASFX_AMBIENCE)
	var/sound/S = istype(sound, /sound) ? sound : new(sound)
	S.environment = 0 // Ensures a 3D effect even if x/y offset happens to be 0 the first time it's played
	S.volume  = volume
	S.falloff = falloff
	S.echo = echo
	S.frequency = frequency
	S.repeat = TRUE

	return PlaySoundDatum(source, sound_id, S, range, prefer_mute, sound_type)

/singleton/sound_player/proc/PrivStopSound(datum/sound_token/sound_token)
	var/channel = sound_token.sound.channel
	var/sound_id = sound_token.sound_id

	var/sound_tokens = sound_tokens_by_sound_id[sound_id]
	if(!(sound_token in sound_tokens))
		return
	sound_tokens -= sound_token
	if(length(sound_tokens))
		return

	sound_channels.ReleaseChannel(channel)
	taken_channels -= sound_id
	sound_tokens_by_sound_id -= sound_id

/singleton/sound_player/proc/PrivGetChannel(datum/sound_token/sound_token)
	var/sound_id = sound_token.sound_id

	. = taken_channels[sound_id] // Does this sound_id already have an assigned channel?
	if(!.) // If not, request a new one.
		. = sound_channels.RequestChannel(sound_id)
		if(!.) // Oh no, still no channel. Abort
			return
		taken_channels[sound_id] = .

	var/sound_tokens = sound_tokens_by_sound_id[sound_id]
	if(!sound_tokens)
		sound_tokens = list()
		sound_tokens_by_sound_id[sound_id] = sound_tokens
	sound_tokens += sound_token

#define SOUND_STOPPED FLAG(15)

/*
	Outwardly this is a merely a toke/little helper that a user utilize to adjust sounds as desired (and possible).
	In reality this is where the heavy-lifting happens.
*/
/datum/sound_token
	var/atom/source    // Where the sound originates from
	var/list/listeners // Assoc: Atoms hearing this sound, and their sound datum
	var/range          // How many turfs away the sound will stop playing completely
	var/prefer_mute    // If sound should be muted instead of stopped when mob moves out of range. In the general case this should be avoided because listeners will remain tracked.
	var/sound/sound    // Sound datum, holds most sound relevant data
	var/sound_id       // The associated sound id, used for cleanup
	var/status = 0     // Paused, muted, running? Global for all listeners
	var/listener_status// Paused, muted, running? Specific for the given listener.
	var/sound_type // Type of sound this token is handling, it's set by default (arbitrarily) as ambience, gets set on init with the actual one if specified.


/datum/sound_token/New(atom/source, sound_id, sound/sound, range = 4, prefer_mute = FALSE, sound_type = ASFX_AMBIENCE)
	..()
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
	src.sound_type  = sound_type

	if(sound.repeat) // Non-looping sounds may not reserve a sound channel due to the risk of not hearing when someone forgets to stop the token
		var/channel = GLOB.sound_player.PrivGetChannel(src) //Attempt to find a channel
		if(!isnum(channel))
			CRASH("All available sound channels are in active use.")
		sound.channel = channel
	else
		sound.channel = 0

	listeners = list()
	listener_status = list()

	GLOB.destroyed_event.register(source, src, /datum/proc/qdel_self)

	PrivLocateListeners()
	START_PROCESSING(SSprocessing, src)

/datum/sound_token/Destroy()
	Stop()
	. = ..()

/datum/sound_token/proc/SetVolume(new_volume)
	new_volume = clamp(new_volume, 0, 100)
	if(sound.volume == new_volume)
		return
	sound.volume = new_volume
	PrivUpdateListeners()

/datum/sound_token/proc/Mute()
	PrivUpdateStatus(status|SOUND_MUTE)

/datum/sound_token/proc/Unmute()
	PrivUpdateStatus(status & ~SOUND_MUTE)

/datum/sound_token/proc/Pause()
	PrivUpdateStatus(status|SOUND_PAUSED)

// Normally called Resume but I don't want to give people false hope about being unable to un-stop a sound
/datum/sound_token/proc/Unpause()
	PrivUpdateStatus(status & ~SOUND_PAUSED)

/datum/sound_token/proc/Stop()
	if(status & SOUND_STOPPED)
		return
	status |= SOUND_STOPPED

	var/sound/null_sound = new(channel = sound.channel)
	for(var/listener in listeners)
		PrivRemoveListener(listener, null_sound)
	listeners = null
	listener_status = null

	GLOB.destroyed_event.unregister(source, src, /datum/proc/qdel_self)
	source = null

	GLOB.sound_player.PrivStopSound(src)
	STOP_PROCESSING(SSprocessing, src)

/datum/sound_token/process()
	PrivLocateListeners()

/datum/sound_token/proc/PrivLocateListeners()
	if(status & SOUND_STOPPED)
		return

	var/current_listeners = SSspatial_grid.orthogonal_range_search(source, SPATIAL_GRID_CONTENTS_TYPE_HEARING, range)
	var/new_listeners = current_listeners - listeners

	if(!prefer_mute)
		var/former_listeners = listeners - current_listeners
		for(var/listener in former_listeners)
			PrivRemoveListener(listener)

	for(var/mob/listener in new_listeners)
		if((listener.client?.prefs.sfx_toggles & sound_type) && (!isdeaf(listener))) //Only give the sound token if the listener has the preference for the type of token active, and is not deaf
			PrivAddListener(listener)

	for(var/mob/listener in current_listeners)
		PrivUpdateListenerLoc(listener)

/datum/sound_token/proc/PrivUpdateStatus(new_status)
	// Once stopped, always stopped. Go ask the player to play the sound again.
	if(status & SOUND_STOPPED)
		return
	if(new_status == status)
		return
	status = new_status
	PrivUpdateListeners()

/datum/sound_token/proc/PrivAddListener(atom/listener)
	if(listener in listeners)
		return

	listeners += listener

	GLOB.moved_event.register(listener, src, PROC_REF(PrivUpdateListenerLoc))
	GLOB.destroyed_event.register(listener, src, PROC_REF(PrivRemoveListener))

	PrivUpdateListenerLoc(listener, FALSE)

/datum/sound_token/proc/PrivRemoveListener(atom/listener, sound/null_sound)
	null_sound = null_sound || new(channel = sound.channel)
	sound_to(listener, null_sound)
	GLOB.moved_event.unregister(listener, src, PROC_REF(PrivUpdateListenerLoc))
	GLOB.destroyed_event.unregister(listener, src, PROC_REF(PrivRemoveListener))
	listeners -= listener

/datum/sound_token/proc/PrivUpdateListenerLoc(atom/listener, update_sound = TRUE)
	var/turf/source_turf = get_turf(source)
	var/turf/listener_turf = get_turf(listener)

	if (!source_turf || !listener_turf)
		return

	var/distance = get_dist(source_turf, listener_turf)
	if(!listener_turf || (distance > range))
		if(prefer_mute)
			listener_status[listener] |= SOUND_MUTE
		else
			PrivRemoveListener(listener)
			return
	else if(prefer_mute)
		listener_status[listener] &= ~SOUND_MUTE

	sound.x = source_turf.x - listener_turf.x
	sound.z = source_turf.y - listener_turf.y
	sound.y = 1
	// Far as I can tell from testing, sound priority just doesn't work.
	// Sounds happily steal channels from each other no matter what.
	sound.priority = clamp(255 - distance, 0, 255)
	PrivUpdateListener(listener, update_sound)

/datum/sound_token/proc/PrivUpdateListeners()
	for(var/listener in listeners)
		PrivUpdateListener(listener)

/datum/sound_token/proc/PrivUpdateListener(mob/listener, update_sound = TRUE)
	sound.environment = PrivGetEnvironment(listener)
	sound.status = status|listener_status[listener]
	if(update_sound)
		sound.status |= SOUND_UPDATE
	if((listener.client?.prefs.sfx_toggles & sound_type) && (!isdeaf(listener))) //Send the sound only if the preference for the type of sound is set and is not deaf, otherwise remove the listener.
		sound_to(listener, sound)
	else
		PrivRemoveListener(listener)

/datum/sound_token/proc/PrivGetEnvironment(listener)
	var/area/A = get_area(listener)
	return A && PrivIsValidEnvironment(A.sound_environment) ? A.sound_environment : sound.environment

/datum/sound_token/proc/PrivIsValidEnvironment(environment)
	if(islist(environment) && length(environment) != 23)
		return FALSE
	if(!isnum(environment) || environment < 0 || environment > 25)
		return FALSE
	return TRUE

/datum/sound_token/static_environment/PrivGetEnvironment()
	return sound.environment
