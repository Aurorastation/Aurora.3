//Sound environment defines. Reverb preset for sounds played in an area, see sound datum reference for more.
#define GENERIC 0
#define PADDED_CELL 1
#define ROOM 2
#define BATHROOM 3
#define LIVINGROOM 4
#define STONEROOM 5
#define AUDITORIUM 6
#define CONCERT_HALL 7
#define CAVE 8
#define ARENA 9
#define HANGAR 10
#define CARPETED_HALLWAY 11
#define HALLWAY 12
#define STONE_CORRIDOR 13
#define ALLEY 14
#define FOREST 15
#define CITY 16
#define MOUNTAINS 17
#define QUARRY 18
#define PLAIN 19
#define PARKING_LOT 20
#define SEWER_PIPE 21
#define UNDERWATER 22
#define DRUGGED 23
#define DIZZY 24
#define PSYCHOTIC 25

#define STANDARD_STATION STONEROOM
#define LARGE_ENCLOSED HANGAR
#define SMALL_ENCLOSED BATHROOM
#define TUNNEL_ENCLOSED CAVE
#define LARGE_SOFTFLOOR CARPETED_HALLWAY
#define MEDIUM_SOFTFLOOR LIVINGROOM
#define SMALL_SOFTFLOOR ROOM
#define ASTEROID CAVE
#define SPACE UNDERWATER

var/list/shatter_sound = list(
	'sound/effects/Glassbr1.ogg',
	'sound/effects/Glassbr2.ogg',
	'sound/effects/Glassbr3.ogg'
)
var/list/explosion_sound = list(
	'sound/effects/Explosion1.ogg',
	'sound/effects/Explosion2.ogg'
)
var/list/spark_sound = list(
	'sound/effects/sparks1.ogg',
	'sound/effects/sparks2.ogg',
	'sound/effects/sparks3.ogg',
	'sound/effects/sparks4.ogg'
)
var/list/rustle_sound = list(
	'sound/items/storage/rustle1.ogg',
	'sound/items/storage/rustle2.ogg',
	'sound/items/storage/rustle3.ogg',
	'sound/items/storage/rustle4.ogg',
	'sound/items/storage/rustle5.ogg'
)
var/list/punch_sound = list(
	'sound/weapons/punch1.ogg',
	'sound/weapons/punch2.ogg',
	'sound/weapons/punch3.ogg',
	'sound/weapons/punch4.ogg'
)
var/list/clown_sound = list(
	'sound/effects/clownstep1.ogg',
	'sound/effects/clownstep2.ogg'
)
var/list/swing_hit_sound = list(
	'sound/weapons/genhit1.ogg',
	'sound/weapons/genhit2.ogg',
	'sound/weapons/genhit3.ogg'
)
var/list/hiss_sound = list(
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg'
)
var/list/page_sound = list(
	'sound/effects/pageturn1.ogg',
	'sound/effects/pageturn2.ogg',
	'sound/effects/pageturn3.ogg'
)
var/list/fracture_sound = list(
	'sound/effects/bonebreak1.ogg',
	'sound/effects/bonebreak2.ogg',
	'sound/effects/bonebreak3.ogg',
	'sound/effects/bonebreak4.ogg'
)

//FOOTSTEPS
var/list/defaultfootsteps = list(
	'sound/effects/footsteps/tile1.wav',
	'sound/effects/footsteps/tile2.wav',
	'sound/effects/footsteps/tile3.wav',
	'sound/effects/footsteps/tile4.wav'
)
var/list/concretefootsteps = list(
	'sound/effects/footsteps/concrete1.wav',
	'sound/effects/footsteps/concrete2.wav',
	'sound/effects/footsteps/concrete3.wav',
	'sound/effects/footsteps/concrete4.wav'
)
var/list/grassfootsteps = list(
	'sound/effects/footsteps/grass1.wav',
	'sound/effects/footsteps/grass2.wav',
	'sound/effects/footsteps/grass3.wav',
	'sound/effects/footsteps/grass4.wav'
)
var/list/dirtfootsteps = list(
	'sound/effects/footsteps/dirt1.wav',
	'sound/effects/footsteps/dirt2.wav',
	'sound/effects/footsteps/dirt3.wav',
	'sound/effects/footsteps/dirt4.wav'
)
var/list/waterfootsteps = list(
	'sound/effects/footsteps/slosh1.wav',
	'sound/effects/footsteps/slosh2.wav',
	'sound/effects/footsteps/slosh3.wav',
	'sound/effects/footsteps/slosh4.wav'
)
var/list/sandfootsteps = list(
	'sound/effects/footsteps/sand1.wav',
	'sound/effects/footsteps/sand2.wav',
	'sound/effects/footsteps/sand3.wav',
	'sound/effects/footsteps/sand4.wav'
)
var/list/gravelfootsteps = list(
	'sound/effects/footsteps/gravel1.wav',
	'sound/effects/footsteps/gravel2.wav',
	'sound/effects/footsteps/gravel3.wav',
	'sound/effects/footsteps/gravel4.wav'
)
var/list/computerbeeps = list(
	'sound/machines/compbeep1.ogg',
	'sound/machines/compbeep2.ogg',
	'sound/machines/compbeep3.ogg',
	'sound/machines/compbeep4.ogg',
	'sound/machines/compbeep5.ogg'
)
var/list/switchsounds = list(
	'sound/machines/switch1.ogg',
	'sound/machines/switch2.ogg',
	'sound/machines/switch3.ogg',
	'sound/machines/switch4.ogg'
)
var/list/keyboardsounds = list(
	'sound/machines/keyboard/keypress1.ogg',
	'sound/machines/keyboard/keypress2.ogg',
	'sound/machines/keyboard/keypress3.ogg',
	'sound/machines/keyboard/keypress4.ogg',
	'sound/machines/keyboard/keystroke1.ogg',
	'sound/machines/keyboard/keystroke2.ogg',
	'sound/machines/keyboard/keystroke3.ogg',
	'sound/machines/keyboard/keystroke4.ogg'
	)
var/list/pickaxesounds = list(
	'sound/weapons/mine/pickaxe1.ogg',
	'sound/weapons/mine/pickaxe2.ogg',
	'sound/weapons/mine/pickaxe3.ogg',
	'sound/weapons/mine/pickaxe4.ogg'
	)

var/list/footstepfx = list("defaultstep","concretestep","grassstep","dirtstep","waterstep","sandstep", "gravelstep")

//var/list/gun_sound = list('sound/weapons/gunshot/gunshot1.ogg', 'sound/weapons/gunshot/gunshot2.ogg','sound/weapons/gunshot/gunshot3.ogg','sound/weapons/gunshot/gunshot4.ogg')

/proc/playsound(atom/source, soundin, vol, vary, extrarange, falloff, is_global, usepressure = 1, environment = -1, required_preferences = 0, required_asfx_toggles = 0)
	if (isarea(source))
		crash_with("[source] is an area and is trying to make the sound: [soundin]")
		return

	var/sound/original_sound = playsound_get_sound(soundin, vol, falloff, 0, environment)

	if (!original_sound)
		crash_with("Could not construct original sound.")
		return

	if (is_global)
		playsound_allinrange(source, original_sound,
			extra_range = extrarange,
			is_global = is_global,
			use_random_freq = !!vary,
			use_pressure = usepressure,
			modify_environment = (environment != 0),
			required_preferences = required_preferences,
			required_asfx_toggles = required_asfx_toggles
		)
	else
		playsound_lineofsight(source, original_sound,
			use_pressure = usepressure,
			use_random_freq = !!vary,
			modify_environment = (environment != 0),
			required_preferences = required_preferences,
			required_asfx_toggles = required_asfx_toggles
		)

/proc/playsound_get_sound(soundin, volume, fall_off, frequency = 0, environment = -1)
	if (istext(soundin))
		soundin = get_sfx(soundin)

	var/sound/S = sound(soundin)

	S.wait = 0
	S.channel = 0
	S.frequency = frequency
	S.falloff = fall_off || FALLOFF_SOUNDS
	S.environment = environment

	return S

/proc/copy_sound(sound/original)
	var/sound/S = sound(original.file, original.repeat, 0, 0, original.volume)

	S.wait = original.wait
	S.channel = original.channel
	S.frequency = original.frequency
	S.falloff = original.falloff
	S.environment = original.environment

	return S

/proc/playsound_allinrange(atom/source, sound/S, extra_range = 0, is_global = FALSE, use_random_freq = FALSE, use_pressure = TRUE,  modify_environment = TRUE, required_preferences = 0, required_asfx_toggles = 0)
	var/turf/source_turf = get_turf(source)

	for (var/MM in player_list)
		var/mob/M = MM

		if (!M?.client)
			continue

		var/dist = get_dist(M, source_turf)

		if (dist <= (world.view + extra_range) * 3)
			var/turf/T = get_turf(M)

			if (!T || T.z != source_turf.z)
				continue
			else if (!M.sound_can_play(required_preferences, required_asfx_toggles))
				continue

			M.playsound_to(source_turf, S, use_random_freq = use_random_freq, use_pressure = use_pressure, modify_environment = modify_environment)

/proc/playsound_lineofsight(atom/source, sound/S, use_random_freq = FALSE, use_pressure = TRUE, modify_environment = TRUE, required_preferences = 0, required_asfx_toggles = 0)
	var/list/mobs = get_mobs_or_objects_in_view(world.view, source, include_objects = FALSE)

	var/turf/source_turf = get_turf(source)

	for (var/MM in mobs)
		var/mob/M = MM
		if (!M.sound_can_play(required_preferences, required_asfx_toggles))
			continue

		M.playsound_to(source_turf, S, use_random_freq = use_random_freq, use_pressure = use_pressure, modify_environment = modify_environment)

/mob/proc/sound_can_play(required_preferences = 0, required_asfx_toggles = 0)
	if (!client)
		return FALSE

	if (required_preferences && (client.prefs.toggles & required_preferences) != required_preferences)
		return FALSE

	if (required_asfx_toggles && (client.prefs.asfx_togs & required_asfx_toggles) != required_asfx_toggles)
		return FALSE

	return TRUE

/mob/proc/playsound_get_environment(pressure_factor = 1.0)
	if (pressure_factor < 0.5)
		return SPACE
	else
		var/area/A = get_area(src)
		return A.sound_env

/mob/living/playsound_get_environment(pressure_factor = 1.0)
	if (hallucination)
		return PSYCHOTIC
	else if (druggy)
		return DRUGGED
	else if (drowsyness)
		return DIZZY
	else if (confused)
		return DIZZY
	else if (sleeping)
		return UNDERWATER
	else
		return ..()

/mob/proc/playsound_to(turf/source_turf, sound/original_sound, use_random_freq, modify_environment = TRUE, use_pressure = TRUE)
	var/sound/S = copy_sound(original_sound)

	var/pressure_factor = 1.0

	if (use_random_freq)
		S.frequency = get_rand_frequency()

	if (isturf(source_turf))
		var/turf/T = get_turf(src)

		var/distance = get_dist(T, source_turf)

		S.volume -= max(distance - world.view, 0) * 2

		if (use_pressure)
			var/datum/gas_mixture/hearer_env = T.return_air()
			var/datum/gas_mixture/source_env = source_turf.return_air()

			if (hearer_env && source_env)
				var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())

				if (pressure < ONE_ATMOSPHERE)
					pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
			else //in space
				pressure_factor = 0

			if (distance <= 1)
				pressure_factor = max(pressure_factor, 0.15)	//hearing through contact

			S.volume *= pressure_factor

		if (S.volume <= 0)
			return 0

		S.x = source_turf.x - T.x // left/right
		S.z = source_turf.y - T.y // front/back
		S.y = (source_turf.z - T.z) * SOUND_Z_FACTOR // above/below-ish

	if (modify_environment)
		S.environment = playsound_get_environment(pressure_factor)

	sound_to(src, S)

	return S.volume

/mob/proc/playsound_simple(source, soundin, volume, use_random_freq = FALSE, frequency = 0, falloff = 0, use_pressure = TRUE)
	var/sound/S = playsound_get_sound(soundin, volume, falloff, frequency)

	playsound_to(source ? get_turf(source) : null, S, use_random_freq, use_pressure = use_pressure)

/client/proc/playtitlemusic()
	if(!SSticker.login_music)	return
	if(prefs.toggles & SOUND_LOBBY)
		src << sound(SSticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS)

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick(shatter_sound)
			if ("explosion") soundin = pick(explosion_sound)
			if ("sparks") soundin = pick(spark_sound)
			if ("rustle") soundin = pick(rustle_sound)
			if ("punch") soundin = pick(punch_sound)
			if ("clownstep") soundin = pick(clown_sound)
			if ("swing_hit") soundin = pick(swing_hit_sound)
			if ("hiss") soundin = pick(hiss_sound)
			if ("pageturn") soundin = pick(page_sound)
			if ("fracture") soundin = pick(fracture_sound)
			//if ("gunshot") soundin = pick(gun_sound)
			if ("defaultstep") soundin = pick(defaultfootsteps)
			if ("concretestep") soundin = pick(concretefootsteps)
			if ("grassstep") soundin = pick(grassfootsteps)
			if ("dirtstep") soundin = pick(dirtfootsteps)
			if ("waterstep") soundin = pick(waterfootsteps)
			if ("sandstep") soundin = pick(sandfootsteps)
			if ("gravelstep") soundin = pick(gravelfootsteps)
			if ("computerbeep") soundin = pick(computerbeeps)
			if ("switch") soundin = pick(switchsounds)
			if ("keyboard") soundin = pick(keyboardsounds)
			if ("pickaxe") soundin = pick(pickaxesounds)
	return soundin
