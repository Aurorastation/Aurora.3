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


#define STANDARD_STATION STONEROOM
#define LARGE_ENCLOSED HANGAR
#define SMALL_ENCLOSED BATHROOM
#define TUNNEL_ENCLOSED CAVE
#define LARGE_SOFTFLOOR CARPETED_HALLWAY
#define MEDIUM_SOFTFLOOR LIVINGROOM
#define SMALL_SOFTFLOOR ROOM
#define ASTEROID CAVE
#define SPACE UNDERWATER
#define PSYCHOTIC PARKING_LOT

//footsteps
var/list/blank_footstep = list('sound/effects/footstep/blank.ogg')

var/list/catwalk_footstep = list(
		'sound/effects/footstep/catwalk1.ogg',
		'sound/effects/footstep/catwalk2.ogg',
		'sound/effects/footstep/catwalk3.ogg',
		'sound/effects/footstep/catwalk4.ogg',
		'sound/effects/footstep/catwalk5.ogg'
)
var/list/wood_footstep = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg')

var/list/tiles_footstep = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'
)
var/list/plating_footstep = list(
		'sound/effects/footstep/plating1.ogg',
		'sound/effects/footstep/plating2.ogg',
		'sound/effects/footstep/plating3.ogg',
		'sound/effects/footstep/plating4.ogg',
		'sound/effects/footstep/plating5.ogg'
)
var/list/carpet_footstep = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'
)
var/list/asteroid_footstep = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg',
		'sound/effects/footstep/asteroid5.ogg'
)
var/list/grass_footstep = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'
)
var/list/water_footstep = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'
)
var/list/lava_footstep = list(
		'sound/effects/footstep/lava1.ogg',
		'sound/effects/footstep/lava2.ogg',
		'sound/effects/footstep/lava3.ogg'
)
var/list/snow_footstep = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'
)
var/list/sand_footstep = list(
		'sound/effects/footstep/sand1.ogg',
		'sound/effects/footstep/sand2.ogg',
		'sound/effects/footstep/sand3.ogg',
		'sound/effects/footstep/sand4.ogg'
)
var/list/footstepfx = list("blank", "catwalk", "wood", "tiles", "plating", "carpet", "asteroid", "grass", "water", "lava", "snow", "sand")

var/list/shatter_sound = list(
	'sound/effects/glass_break1.ogg',
	'sound/effects/glass_break2.ogg',
	'sound/effects/glass_break3.ogg'
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
var/list/button_sound = list(
	'sound/machines/button1.ogg',
	'sound/machines/button2.ogg',
	'sound/machines/button3.ogg',
	'sound/machines/button4.ogg'
)
var/list/computerbeep_sound = list(
	'sound/machines/compbeep1.ogg',
	'sound/machines/compbeep2.ogg',
	'sound/machines/compbeep3.ogg',
	'sound/machines/compbeep4.ogg',
	'sound/machines/compbeep5.ogg'
)
var/list/switch_sound = list(
	'sound/machines/switch1.ogg',
	'sound/machines/switch2.ogg',
	'sound/machines/switch3.ogg',
	'sound/machines/switch4.ogg'
)
var/list/keyboard_sound = list(
	'sound/machines/keyboard/keypress1.ogg',
	'sound/machines/keyboard/keypress2.ogg',
	'sound/machines/keyboard/keypress3.ogg',
	'sound/machines/keyboard/keypress4.ogg',
	'sound/machines/keyboard/keystroke1.ogg',
	'sound/machines/keyboard/keystroke2.ogg',
	'sound/machines/keyboard/keystroke3.ogg',
	'sound/machines/keyboard/keystroke4.ogg'
)
var/list/pickaxe_sound = list(
	'sound/weapons/mine/pickaxe1.ogg',
	'sound/weapons/mine/pickaxe2.ogg',
	'sound/weapons/mine/pickaxe3.ogg',
	'sound/weapons/mine/pickaxe4.ogg'
	)
var/list/glasscrack_sound = list(
	'sound/effects/glass_crack1.ogg',
	'sound/effects/glass_crack2.ogg',
	'sound/effects/glass_crack3.ogg',
	'sound/effects/glass_crack4.ogg'
	)
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
	S.volume = volume

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
	else if (stat == UNCONSCIOUS)
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
			//footsteps
			if ("blank") soundin = pick(blank_footstep)
			if ("catwalk") soundin = pick(catwalk_footstep)
			if ("wood") soundin = pick(wood_footstep)
			if ("tiles") soundin = pick(tiles_footstep)
			if ("plating") soundin = pick(plating_footstep)
			if ("carpet") soundin = pick(carpet_footstep)
			if ("asteroid") soundin = pick(asteroid_footstep)
			if ("grass") soundin = pick(grass_footstep)
			if ("water") soundin = pick(water_footstep)
			if ("lava") soundin = pick(lava_footstep)
			if ("snow") soundin = pick(snow_footstep)
			if ("sand") soundin = pick(sand_footstep)
			//misc
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
			if ("button") soundin = pick(button_sound)
			if ("glasscrack") soundin = pick(glasscrack_sound)
			if ("switch") soundin = pick(switch_sound)
			if ("keyboard") soundin = pick(keyboard_sound)
			if ("pickaxe") soundin = pick(pickaxe_sound)
	return soundin
