///Default override for echo
/sound
	echo = list(
		0, // Direct
		0, // DirectHF
		-10000, // Room, -10000 means no low frequency sound reverb
		-10000, // RoomHF, -10000 means no high frequency sound reverb
		0, // Obstruction
		0, // ObstructionLFRatio
		0, // Occlusion
		0.25, // OcclusionLFRatio
		1.5, // OcclusionRoomRatio
		1.0, // OcclusionDirectRatio
		0, // Exclusion
		1.0, // ExclusionLFRatio
		0, // OutsideVolumeHF
		0, // DopplerFactor
		0, // RolloffFactor
		0, // RoomRolloffFactor
		1.0, // AirAbsorptionFactor
		0, // Flags (1 = Auto Direct, 2 = Auto Room, 4 = Auto RoomHF)
	)
	environment = SOUND_ENVIRONMENT_NONE //Default to none so sounds without overrides dont get reverb

/**
 * playsound is a proc used to play a 3D sound in a specific range. This uses SOUND_RANGE + extra_range to determine that.
 *
 * * source - Origin of sound.
 * * soundin - Either a file, or a string that can be used to get an SFX.
 * * vol - The volume of the sound, excluding falloff and pressure affection.
 * * vary - bool that determines if the sound changes pitch every time it plays.
 * * extrarange - modifier for sound range. This gets added on top of SOUND_RANGE.
 * * falloff_exponent - Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * * frequency - playback speed of audio.
 * * channel - The channel the sound is played at.
 * * pressure_affected - Whether or not difference in pressure affects the sound (E.g. if you can hear in space).
 * * ignore_walls - Whether or not the sound can pass through walls.
 * * falloff_distance - Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 *
 * Aurora snowflake parameters:
 *
 * * required_preferences - What preference is required to be on on the client, for the sound to play
 * * required_asfx_toggles - What toggles are required to be on on the client, for the sound to play
 */
/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff_exponent = SOUND_FALLOFF_EXPONENT, frequency = null, channel = 0, pressure_affected = TRUE, ignore_walls = TRUE, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, use_reverb = TRUE, required_preferences, required_asfx_toggles)
	if(isarea(source))
		CRASH("playsound(): source is an area")

	var/turf/turf_source = get_turf(source)

	if (!turf_source || !soundin || !vol)
		return

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	var/sound/S = isdatum(soundin) ? soundin : sound(get_sfx(soundin))
	var/maxdistance = SOUND_RANGE + extrarange
	var/source_z = turf_source.z
	var/list/listeners = list()

	var/list/players_by_zlevel[world.maxz][1]
	var/list/dead_players_by_zlevel[world.maxz][1]

	for(var/mob/player as anything in GLOB.player_list)
		if(required_preferences && (player.client.prefs.toggles & required_preferences) != required_preferences)
			continue

		if(required_asfx_toggles && (player.client.prefs.sfx_toggles & required_asfx_toggles) != required_asfx_toggles)
			continue

		//This is because your Z is 0 if you are inside eg. a mech
		var/turf/player_turf = get_turf(player)
		if(!player_turf)
			continue

		if(player_turf.z == source_z)
			listeners += player

		if(player_turf.z)
			players_by_zlevel[player_turf.z] += player

		if(isobserver(player) && player_turf.z)
			dead_players_by_zlevel[player_turf.z] += player

	. = list()//output everything that successfully heard the sound

	var/turf/above_turf = GET_TURF_ABOVE(turf_source)
	var/turf/below_turf = GET_TURF_BELOW(turf_source)

	if(ignore_walls)

		if(above_turf && istype(above_turf, /turf/simulated/open))
			listeners += players_by_zlevel[above_turf.z]

		if(below_turf && istype(turf_source, /turf/simulated/open))
			listeners += players_by_zlevel[below_turf.z]

	else //these sounds don't carry through walls
		listeners = get_hearers_in_view(maxdistance, turf_source)

		if(above_turf && istype(above_turf, /turf/simulated/open))
			listeners += get_hearers_in_view(maxdistance, above_turf)

		if(below_turf && istype(turf_source, /turf/simulated/open))
			listeners += get_hearers_in_view(maxdistance, below_turf)

	for(var/mob/listening_mob in listeners | dead_players_by_zlevel[source_z])//observers always hear through walls
		if(get_dist(listening_mob, turf_source) <= maxdistance)
			//Aurora snowflake, if we don't ignore the walls, account for wall-like obstacles to dampen the sound
			if(ignore_walls)
				listening_mob.playsound_local(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, maxdistance, falloff_distance, 1, use_reverb)
			else
				adjust_sound_based_on_path_obstacles(listening_mob, turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, maxdistance, falloff_distance, use_reverb)

			. += listening_mob

/**
 * This proc takes into account walls, windows and similar when deciding the received sound for a mob,
 *
 * this is *NOT* meant to be called directly, use `playsound()`
 *
 * Use this to tweak what happens with the sound along the path from the emitter to the receiver of said sound
 */
/proc/adjust_sound_based_on_path_obstacles(mob/listening_mob, turf/turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, maxdistance, falloff_distance, use_reverb)
	var/turf/inbetween_turf = get_turf(listening_mob)

	for(var/step_counter in 1 to get_dist(listening_mob, turf_source))
		inbetween_turf = get_step_towards(inbetween_turf, turf_source)

		if(istype(inbetween_turf, /turf/simulated/wall))
			vol *= 0.6

		if(locate(/obj/machinery/door) in inbetween_turf)
			vol *= 0.7

		if(locate(/obj/structure/window) in inbetween_turf)
			vol *= 0.75

		//If we're at or below zero, no point continuing, no sound
		if(vol <= 0)
			return

	listening_mob.playsound_local(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, maxdistance, falloff_distance, 1, use_reverb)


/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff_exponent = SOUND_FALLOFF_EXPONENT, channel = 0, pressure_affected = TRUE, sound/sound_to_use, max_distance, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, distance_multiplier = 1, use_reverb = TRUE)
	if(!client || !can_hear())
		return

	if(!sound_to_use)
		sound_to_use = sound(get_sfx(soundin))

	sound_to_use.wait = 0 //No queue
	sound_to_use.channel = channel || SSsounds.random_available_channel()
	sound_to_use.volume = vol

	if(vary)
		if(frequency)
			sound_to_use.frequency = frequency
		else
			sound_to_use.frequency = get_rand_frequency()

	if(isturf(turf_source))
		var/turf/turf_loc = get_turf(src)

		//sound volume falloff with distance
		var/distance = get_dist(turf_loc, turf_source) * distance_multiplier

		if(max_distance) //If theres no max_distance we're not a 3D sound, so no falloff.
			sound_to_use.volume -= (max(distance - falloff_distance, 0) ** (1 / falloff_exponent)) / ((max(max_distance, distance) - falloff_distance) ** (1 / falloff_exponent)) * sound_to_use.volume
			//https://www.desmos.com/calculator/sqdfl8ipgf

		if(pressure_affected)
			//Atmosphere affects sound
			var/pressure_factor = 1
			var/datum/gas_mixture/hearer_env = turf_loc.return_air()
			var/datum/gas_mixture/source_env = turf_source.return_air()

			if(hearer_env && source_env)
				var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
				if(pressure < ONE_ATMOSPHERE)
					pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
			else //space
				pressure_factor = 0

			if(distance <= 1)
				pressure_factor = max(pressure_factor, 0.15) //touching the source of the sound

			sound_to_use.volume *= pressure_factor
			//End Atmosphere affecting sound

		if(sound_to_use.volume <= 0)
			return //No sound

		var/dx = turf_source.x - turf_loc.x // Hearing from the right/left
		sound_to_use.x = dx * distance_multiplier
		var/dz = turf_source.y - turf_loc.y // Hearing from infront/behind
		sound_to_use.z = dz * distance_multiplier
		var/dy = (turf_source.z - turf_loc.z) * 5 * distance_multiplier // Hearing from  above / below, multiplied by 5 because we assume height is further along coords.
		sound_to_use.y = dy

		sound_to_use.falloff = max_distance || 1 //use max_distance, else just use 1 as we are a direct sound so falloff isnt relevant.

		// Sounds can't have their own environment. A sound's environment will be:
		// 1. the mob's
		// 2. the area's (defaults to SOUND_ENVRIONMENT_NONE)
		if(sound_environment_override != SOUND_ENVIRONMENT_NONE)
			sound_to_use.environment = sound_environment_override
		else
			var/area/A = get_area(src)
			sound_to_use.environment = A.sound_environment

		if(use_reverb && sound_to_use.environment != SOUND_ENVIRONMENT_NONE) //We have reverb, reset our echo setting
			sound_to_use.echo[3] = 0 //Room setting, 0 means normal reverb
			sound_to_use.echo[4] = 0 //RoomHF setting, 0 means normal reverb.

	SEND_SOUND(src, sound_to_use)

/proc/sound_to_playing_players(soundin, volume = 100, vary = FALSE, frequency = 0, channel = 0, pressure_affected = FALSE, sound/S)
	if(!S)
		S = sound(get_sfx(soundin))
	for(var/m in GLOB.player_list)
		if(ismob(m) && !isnewplayer(m))
			var/mob/M = m
			M.playsound_local(M, null, volume, vary, frequency, null, channel, pressure_affected, S)

/mob/proc/stop_sound_channel(chan)
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = chan))

/mob/proc/set_sound_channel_volume(channel, volume)
	var/sound/S = sound(null, FALSE, FALSE, channel, volume)
	S.status = SOUND_UPDATE
	SEND_SOUND(src, S)

/client/proc/playtitlemusic()
	set waitfor = FALSE
	UNTIL(SSticker.login_music) //wait for SSticker init to set the login music
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, volume = prefs.lobby_music_vol, channel = CHANNEL_LOBBYMUSIC))

	if(prefs.lobby_music_vol)
		for(var/lobby_music in SSticker.login_music)
			SEND_SOUND(src, sound(lobby_music, repeat = 0, wait = TRUE, volume = prefs.lobby_music_vol, channel = CHANNEL_LOBBYMUSIC)) // MAD JAMS

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

//Unlike TG, we use singletons here, so this is different, for now
/proc/get_sfx(soundin)
	if(!istext(soundin))
		return soundin
	var/datum/sound_effect/sfx = SSsounds.sfx_datum_by_key[soundin]
	return sfx?.return_sfx() || soundin

