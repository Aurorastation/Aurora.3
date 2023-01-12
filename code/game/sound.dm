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
#define ARENA 9 // used for thunderdome and arena.
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


#define STANDARD_STATION STONEROOM // default
#define LARGE_ENCLOSED HANGAR // used for hangars, chapel
#define SMALL_ENCLOSED BATHROOM // used for bathrooms, mostly.
#define TUNNEL_ENCLOSED CAVE // maint tunnels and crawlspaces
#define LARGE_SOFTFLOOR CARPETED_HALLWAY // used for library and theater
#define MEDIUM_SOFTFLOOR LIVINGROOM // used for larger offices, usually with wooden floors
#define SMALL_SOFTFLOOR ROOM // used for offices, dormitories and other small miscallaneous rooms
#define ASTEROID CAVE // well, the asteroid
#define SPACE UNDERWATER // space
#define PSYCHOTIC PARKING_LOT // not actually used in areas, used in drug hallucinations.

#define EQUIP_SOUND_VOLUME 30
#define PICKUP_SOUND_VOLUME 15
#define DROP_SOUND_VOLUME 20
#define THROW_SOUND_VOLUME 90

/proc/playsound(atom/source, soundin, vol, vary, extrarange, falloff, is_global, usepressure = 1, environment = -1, required_preferences = 0, required_asfx_toggles = 0, frequency = 0)
	if (isarea(source))
		crash_with("[source] is an area and is trying to make the sound: [soundin]")
		return

	var/sound/original_sound = playsound_get_sound(soundin, vol, falloff, frequency, environment)

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
	if(ispath(soundin))
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
	var/list/hearers = get_hearers_in_view(world.view, source)
	var/turf/source_turf = get_turf(source)

	for (var/mob/M in hearers)
		if (!M.sound_can_play(required_preferences, required_asfx_toggles))
			continue

		M.playsound_to(source_turf, S, use_random_freq = use_random_freq, use_pressure = use_pressure, modify_environment = modify_environment)

/mob/proc/sound_can_play(required_preferences = 0, required_asfx_toggles = 0)
	if (!client)
		return FALSE

	if (required_preferences && (client.prefs.toggles & required_preferences) != required_preferences)
		return FALSE

	if (required_asfx_toggles && (client.prefs.sfx_toggles & required_asfx_toggles) != required_asfx_toggles)
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
	else if (drowsiness)
		return DIZZY
	else if (confused)
		return DIZZY
	else if (stat == UNCONSCIOUS)
		return UNDERWATER
	else
		return ..()

/mob/living/carbon/human/playsound_get_environment(pressure_factor = 1.0)
	if(get_hearing_protection())
		return PADDED_CELL
	return ..()

/mob/proc/check_sound_equipment_volume()
	return 1

/mob/living/carbon/human/check_sound_equipment_volume()
	if(get_hearing_protection())
		return 0.6
	return 1

/mob/proc/playsound_to(turf/source_turf, sound/original_sound, use_random_freq, modify_environment = TRUE, use_pressure = TRUE, required_preferences = 0, required_asfx_toggles = 0)
	var/sound/S = copy_sound(original_sound)

	var/pressure_factor = 1.0

	if(!sound_can_play(required_preferences, required_asfx_toggles))
		return 0

	if (use_random_freq)
		S.frequency = get_rand_frequency()

	if (isturf(source_turf))
		var/turf/T = get_turf(src)

		var/distance = get_dist(T, source_turf)

		S.volume -= max(distance - world.view, 0) * 2

		if (use_pressure && istype(T))
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

	S.volume *= check_sound_equipment_volume()

	sound_to(src, S)
	return S.volume

/mob/proc/playsound_simple(source, soundin, volume, use_random_freq = FALSE, frequency = 0, falloff = 0, use_pressure = TRUE, required_preferences = 0, required_asfx_toggles = 0)
	var/sound/S = playsound_get_sound(soundin, volume, falloff, frequency)
	return playsound_to(source ? get_turf(source) : null, S, use_random_freq, use_pressure = use_pressure, required_preferences = required_preferences, required_asfx_toggles = required_asfx_toggles)

/proc/playsound_in(atom/source, soundin, vol, vary, extrarange, falloff, is_global, usepressure = 1, environment = -1, required_preferences = 0, required_asfx_toggles = 0, frequency = 0, time)
	addtimer(CALLBACK(GLOBAL_PROC, /proc/playsound, source, soundin, vol, vary, extrarange, falloff, is_global, usepressure, environment, required_preferences, required_asfx_toggles, frequency), time, TIMER_STOPPABLE | TIMER_CLIENT_TIME)

/client/proc/playtitlemusic()
	if(!SSticker.login_music)
		return
	if(prefs.toggles & SOUND_LOBBY)
		src << sound(SSticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS)

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(var/sound_category)
	var/decl/sound_category/SC = decls_repository.get_decl(sound_category)
	if(!istype(SC))
		CRASH("Non-decl path in get_sfx: [sound_category]")
	return SC.get_sound()

/decl/sound_category
	var/list/sounds = list()

/decl/sound_category/proc/get_sound()
	return pick(sounds)

/decl/sound_category/blank_footsteps
	sounds = list('sound/effects/footstep/blank.ogg')

/decl/sound_category/catwalk_footstep
	sounds = list(
		'sound/effects/footstep/catwalk1.ogg',
		'sound/effects/footstep/catwalk2.ogg',
		'sound/effects/footstep/catwalk3.ogg',
		'sound/effects/footstep/catwalk4.ogg',
		'sound/effects/footstep/catwalk5.ogg'
	)

/decl/sound_category/wood_footstep
	sounds = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'
	)

/decl/sound_category/tiles_footstep
	sounds = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'
	)

/decl/sound_category/plating_footstep
	sounds = list(
		'sound/effects/footstep/plating1.ogg',
		'sound/effects/footstep/plating2.ogg',
		'sound/effects/footstep/plating3.ogg',
		'sound/effects/footstep/plating4.ogg',
		'sound/effects/footstep/plating5.ogg'
	)

/decl/sound_category/carpet_footstep
	sounds = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'
	)

/decl/sound_category/asteroid_footstep
	sounds = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg',
		'sound/effects/footstep/asteroid5.ogg'
	)

/decl/sound_category/grass_footstep
	sounds = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'
	)

/decl/sound_category/water_footstep
	sounds = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'
	)

/decl/sound_category/lava_footstep
	sounds = list(
		'sound/effects/footstep/lava1.ogg',
		'sound/effects/footstep/lava2.ogg',
		'sound/effects/footstep/lava3.ogg'
	)

/decl/sound_category/snow_footstep
	sounds = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'
	)

/decl/sound_category/sand_footstep
	sounds = list(
		'sound/effects/footstep/sand1.ogg',
		'sound/effects/footstep/sand2.ogg',
		'sound/effects/footstep/sand3.ogg',
		'sound/effects/footstep/sand4.ogg'
	)

/decl/sound_category/glass_break_sound
	sounds = list(
		'sound/effects/glass_break1.ogg',
		'sound/effects/glass_break2.ogg',
		'sound/effects/glass_break3.ogg'
	)

/decl/sound_category/cardboard_break_sound
	sounds = list(
		'sound/effects/cardboard_break1.ogg',
		'sound/effects/cardboard_break2.ogg',
		'sound/effects/cardboard_break3.ogg',
	)

/decl/sound_category/wood_break_sound
	sounds = list(
		'sound/effects/wood_break1.ogg',
		'sound/effects/wood_break2.ogg',
		'sound/effects/wood_break3.ogg'
	)

/decl/sound_category/explosion_sound
	sounds = list(
		'sound/effects/Explosion1.ogg',
		'sound/effects/Explosion2.ogg'
	)

/decl/sound_category/spark_sound
	sounds = list(
		'sound/effects/sparks1.ogg',
		'sound/effects/sparks2.ogg',
		'sound/effects/sparks3.ogg',
		'sound/effects/sparks4.ogg'
	)

/decl/sound_category/rustle_sound
	sounds = list(
		'sound/items/storage/rustle1.ogg',
		'sound/items/storage/rustle2.ogg',
		'sound/items/storage/rustle3.ogg',
		'sound/items/storage/rustle4.ogg',
		'sound/items/storage/rustle5.ogg'
	)

/decl/sound_category/punch_sound
	sounds = list(
		'sound/weapons/punch1.ogg',
		'sound/weapons/punch2.ogg',
		'sound/weapons/punch3.ogg',
		'sound/weapons/punch4.ogg'
	)

/decl/sound_category/punch_bassy_sound
	sounds = list(
		'sound/weapons/punch1_bass.ogg',
		'sound/weapons/punch2_bass.ogg',
		'sound/weapons/punch3_bass.ogg',
		'sound/weapons/punch4_bass.ogg'
	)

/decl/sound_category/punchmiss_sound
	sounds = list(
		'sound/weapons/punchmiss1.ogg',
		'sound/weapons/punchmiss2.ogg'
	)

/decl/sound_category/swing_hit_sound
	sounds = list(
		'sound/weapons/genhit1.ogg',
		'sound/weapons/genhit2.ogg',
		'sound/weapons/genhit3.ogg'
	)

/decl/sound_category/hiss_sound
	sounds = list(
		'sound/voice/hiss1.ogg',
		'sound/voice/hiss2.ogg',
		'sound/voice/hiss3.ogg',
		'sound/voice/hiss4.ogg'
	)

/decl/sound_category/page_sound
	sounds = list(
		'sound/effects/pageturn1.ogg',
		'sound/effects/pageturn2.ogg',
		'sound/effects/pageturn3.ogg'
	)

/decl/sound_category/fracture_sound
	sounds = list(
		'sound/effects/bonebreak1.ogg',
		'sound/effects/bonebreak2.ogg',
		'sound/effects/bonebreak3.ogg',
		'sound/effects/bonebreak4.ogg'
	)

/decl/sound_category/button_sound
	sounds = list(
		'sound/machines/button1.ogg',
		'sound/machines/button2.ogg',
		'sound/machines/button3.ogg',
		'sound/machines/button4.ogg'
	)

/decl/sound_category/computerbeep_sound
	sounds = list(
		'sound/machines/compbeep1.ogg',
		'sound/machines/compbeep2.ogg',
		'sound/machines/compbeep3.ogg',
		'sound/machines/compbeep4.ogg',
		'sound/machines/compbeep5.ogg'
	)

/decl/sound_category/switch_sound
	sounds = list(
		'sound/machines/switch1.ogg',
		'sound/machines/switch2.ogg',
		'sound/machines/switch3.ogg',
		'sound/machines/switch4.ogg'
	)

/decl/sound_category/keyboard_sound
	sounds = list(
		'sound/machines/keyboard/keyboard1.ogg',
		'sound/machines/keyboard/keyboard2.ogg',
		'sound/machines/keyboard/keyboard3.ogg',
		'sound/machines/keyboard/keyboard4.ogg',
		'sound/machines/keyboard/keyboard5.ogg'
	)

/decl/sound_category/pickaxe_sound
	sounds = list(
		'sound/weapons/mine/pickaxe1.ogg',
		'sound/weapons/mine/pickaxe2.ogg',
		'sound/weapons/mine/pickaxe3.ogg',
		'sound/weapons/mine/pickaxe4.ogg'
	)

/decl/sound_category/glasscrack_sound
	sounds = list(
		'sound/effects/glass_crack1.ogg',
		'sound/effects/glass_crack2.ogg',
		'sound/effects/glass_crack3.ogg',
		'sound/effects/glass_crack4.ogg'
	)

/decl/sound_category/bodyfall_sound
	sounds = list(
		'sound/effects/bodyfall1.ogg',
		'sound/effects/bodyfall2.ogg',
		'sound/effects/bodyfall3.ogg',
		'sound/effects/bodyfall4.ogg'
	)

/decl/sound_category/bodyfall_skrell_sound
	sounds = list(
		'sound/effects/bodyfall_skrell1.ogg',
		'sound/effects/bodyfall_skrell2.ogg',
		'sound/effects/bodyfall_skrell3.ogg',
		'sound/effects/bodyfall_skrell4.ogg'
	)

/decl/sound_category/bodyfall_machine_sound
	sounds = list(
		'sound/effects/bodyfall_machine1.ogg',
		'sound/effects/bodyfall_machine2.ogg'
	)
/decl/sound_category/bulletflyby_sound
		sounds = list(
		'sound/effects/bulletflyby1.ogg',
		'sound/effects/bulletflyby2.ogg',
		'sound/effects/bulletflyby3.ogg'
	)

/decl/sound_category/crowbar_sound
	sounds = list(
		'sound/items/crowbar1.ogg',
		'sound/items/crowbar2.ogg',
		'sound/items/crowbar3.ogg',
		'sound/items/crowbar4.ogg'
	)

/decl/sound_category/casing_drop_sound
	sounds = list(
		'sound/items/drop/casing1.ogg',
		'sound/items/drop/casing2.ogg',
		'sound/items/drop/casing3.ogg',
		'sound/items/drop/casing4.ogg',
		'sound/items/drop/casing5.ogg',
		'sound/items/drop/casing6.ogg',
		'sound/items/drop/casing7.ogg',
		'sound/items/drop/casing8.ogg',
		'sound/items/drop/casing9.ogg',
		'sound/items/drop/casing10.ogg',
		'sound/items/drop/casing11.ogg',
		'sound/items/drop/casing12.ogg',
		'sound/items/drop/casing13.ogg',
		'sound/items/drop/casing15.ogg',
		'sound/items/drop/casing16.ogg',
		'sound/items/drop/casing17.ogg',
		'sound/items/drop/casing18.ogg',
		'sound/items/drop/casing19.ogg',
		'sound/items/drop/casing20.ogg',
		'sound/items/drop/casing21.ogg',
		'sound/items/drop/casing22.ogg',
		'sound/items/drop/casing23.ogg',
		'sound/items/drop/casing24.ogg',
		'sound/items/drop/casing25.ogg'
	)

/decl/sound_category/casing_drop_sound_shotgun
	sounds = list(
		'sound/items/drop/casing_shotgun1.ogg',
		'sound/items/drop/casing_shotgun2.ogg',
		'sound/items/drop/casing_shotgun3.ogg',
		'sound/items/drop/casing_shotgun4.ogg',
		'sound/items/drop/casing_shotgun5.ogg'
	)

/decl/sound_category/out_of_ammo
	sounds = list(
		'sound/weapons/empty/empty2.ogg',
		'sound/weapons/empty/empty3.ogg',
		'sound/weapons/empty/empty4.ogg',
		'sound/weapons/empty/empty5.ogg',
		'sound/weapons/empty/empty6.ogg'
	)

/decl/sound_category/out_of_ammo_revolver
	sounds = list(
		'sound/weapons/empty/empty_revolver.ogg',
		'sound/weapons/empty/empty_revolver3.ogg'
	)

/decl/sound_category/out_of_ammo_rifle
	sounds = list(
		'sound/weapons/empty/empty_rifle1.ogg',
		'sound/weapons/empty/empty_rifle2.ogg'
	)

/decl/sound_category/out_of_ammo_shotgun
	sounds = list(
		'sound/weapons/empty/empty_shotgun1.ogg'
	)

/decl/sound_category/metal_slide_reload
	sounds = list(
		'sound/weapons/reloads/pistol_metal_slide1.ogg',
		'sound/weapons/reloads/pistol_metal_slide2.ogg',
		'sound/weapons/reloads/pistol_metal_slide3.ogg',
		'sound/weapons/reloads/pistol_metal_slide4.ogg',
		'sound/weapons/reloads/pistol_metal_slide5.ogg',
		'sound/weapons/reloads/pistol_metal_slide6.ogg'
	)

/decl/sound_category/polymer_slide_reload
	sounds = list(
		'sound/weapons/reloads/pistol_polymer_slide1.ogg',
		'sound/weapons/reloads/pistol_polymer_slide2.ogg',
		'sound/weapons/reloads/pistol_polymer_slide3.ogg'
	)

/decl/sound_category/rifle_slide_reload
	sounds = list(
		'sound/weapons/reloads/rifle_slide.ogg',
		'sound/weapons/reloads/rifle_slide2.ogg',
		'sound/weapons/reloads/rifle_slide3.ogg',
		'sound/weapons/reloads/rifle_slide4.ogg',
		'sound/weapons/reloads/rifle_slide5.ogg',
		'sound/weapons/reloads/rifle_slide6.ogg',
		'sound/weapons/reloads/rifle_slide7.ogg',
		'sound/weapons/reloads/rifle_slide8.ogg',
		'sound/weapons/reloads/rifle_slide9.ogg'
	)

/decl/sound_category/revolver_reload
	sounds = list(
		'sound/weapons/reloads/revolver_reload.ogg'
	)
/decl/sound_category/shotgun_pump
	sounds = list(
		'sound/weapons/reloads/shotgun_pump2.ogg',
		'sound/weapons/reloads/shotgun_pump3.ogg',
		'sound/weapons/reloads/shotgun_pump4.ogg',
		'sound/weapons/reloads/shotgun_pump5.ogg',
		'sound/weapons/reloads/shotgun_pump6.ogg'
	)

/decl/sound_category/shotgun_reload
	sounds = list(
		'sound/weapons/reloads/reload_shell.ogg',
		'sound/weapons/reloads/reload_shell2.ogg',
		'sound/weapons/reloads/reload_shell3.ogg',
		'sound/weapons/reloads/reload_shell4.ogg'
	)

/decl/sound_category/heavy_machine_gun_reload
	sounds = list(
		'sound/weapons/reloads/hmg_reload1.ogg',
		'sound/weapons/reloads/hmg_reload2.ogg',
		'sound/weapons/reloads/hmg_reload3.ogg'
	)
/decl/sound_category/drillhit_sound
	sounds = list(
		'sound/weapons/saw/drillhit1.ogg',
		'sound/weapons/saw/drillhit2.ogg'
	)

/decl/sound_category/generic_drop_sound
	sounds = list(
		'sound/items/drop/generic1.ogg',
		'sound/items/drop/generic2.ogg'
	)
/decl/sound_category/generic_pickup_sound
	sounds = list(
		'sound/items/pickup/generic1.ogg',
		'sound/items/pickup/generic2.ogg',
		'sound/items/pickup/generic3.ogg'
	)
/decl/sound_category/generic_wield_sound
	sounds = list(
		'sound/items/wield/generic1.ogg',
		'sound/items/wield/generic2.ogg',
		'sound/items/wield/generic3.ogg'
	)

/decl/sound_category/generic_pour_sound
	sounds = list(
		'sound/effects/pour1.ogg',
		'sound/effects/pour2.ogg'
	)

/decl/sound_category/wield_generic_sound
	sounds = list(
		'sound/items/wield/generic1.ogg',
		'sound/items/wield/generic2.ogg',
		'sound/items/wield/generic3.ogg'
	)

/decl/sound_category/sword_pickup_sound
	sounds = list(
		'sound/items/pickup/sword1.ogg',
		'sound/items/pickup/sword2.ogg',
		'sound/items/pickup/sword3.ogg'
	)

/decl/sound_category/sword_equip_sound
	sounds = list(
		'sound/items/equip/sword1.ogg',
		'sound/items/equip/sword2.ogg'
	)

/decl/sound_category/gauss_fire_sound
	sounds = list(
		'sound/weapons/gaussrifle1.ogg',
		'sound/weapons/gaussrifle2.ogg'
	)

/decl/sound_category/bottle_hit_intact_sound
	sounds = list(
		'sound/weapons/bottlehit_intact1.ogg',
		'sound/weapons/bottlehit_intact2.ogg',
		'sound/weapons/bottlehit_intact3.ogg'
	)
/decl/sound_category/bottle_hit_broken
	sounds = list(
		'sound/weapons/bottlehit_broken1.ogg',
		'sound/weapons/bottlehit_broken2.ogg',
		'sound/weapons/bottlehit_broken3.ogg'
	)
/decl/sound_category/tray_hit_sound
	sounds = list(
		'sound/items/trayhit1.ogg',
		'sound/items/trayhit2.ogg'
	)

/decl/sound_category/grab_sound
	sounds = list(
	'sound/weapons/grab/grab1.ogg',
	'sound/weapons/grab/grab2.ogg',
	'sound/weapons/grab/grab3.ogg',
	'sound/weapons/grab/grab4.ogg',
	'sound/weapons/grab/grab5.ogg'
)

/decl/sound_category/gunshots
	sounds = list(
	'sound/weapons/gunshot/bolter.ogg',
	'sound/weapons/laser1.ogg',
	'sound/weapons/Laser2.ogg',
	'sound/weapons/laser3.ogg',
	'sound/weapons/lasercannonfire.ogg',
	'sound/weapons/marauder.ogg',
	'sound/weapons/laserdeep.ogg',
	'sound/weapons/laserstrong.ogg',
	'sound/weapons/gunshot/gunshot_dmr.ogg',
	'sound/weapons/gunshot/gunshot_light.ogg',
	'sound/weapons/gunshot/gunshot_mateba.ogg',
	'sound/weapons/gunshot/gunshot_pistol.ogg',
	'sound/weapons/gunshot/gunshot_revolver.ogg',
	'sound/weapons/gunshot/gunshot_rifle.ogg',
	'sound/weapons/gunshot/gunshot_saw.ogg',
	'sound/weapons/gunshot/gunshot_shotgun.ogg',
	'sound/weapons/gunshot/gunshot_shotgun2.ogg',
	'sound/weapons/gunshot/gunshot_smg.ogg',
	'sound/weapons/gunshot/gunshot_strong.ogg',
	'sound/weapons/gunshot/gunshot_suppressed.ogg',
	'sound/weapons/gunshot/gunshot_svd.ogg',
	'sound/weapons/gunshot/gunshot_tommygun.ogg',
	'sound/weapons/gunshot/gunshot1.ogg',
	'sound/weapons/gunshot/gunshot2.ogg',
	'sound/weapons/gunshot/gunshot3.ogg',
	'sound/weapons/gunshot/musket.ogg',
	'sound/weapons/gunshot/slammer.ogg'
)

/decl/sound_category/gunshots/ballistic
	sounds = list(
	'sound/weapons/gunshot/gunshot_dmr.ogg',
	'sound/weapons/gunshot/gunshot_light.ogg',
	'sound/weapons/gunshot/gunshot_mateba.ogg',
	'sound/weapons/gunshot/gunshot_pistol.ogg',
	'sound/weapons/gunshot/gunshot_revolver.ogg',
	'sound/weapons/gunshot/gunshot_rifle.ogg',
	'sound/weapons/gunshot/gunshot_saw.ogg',
	'sound/weapons/gunshot/gunshot_shotgun.ogg',
	'sound/weapons/gunshot/gunshot_shotgun2.ogg',
	'sound/weapons/gunshot/gunshot_smg.ogg',
	'sound/weapons/gunshot/gunshot_strong.ogg',
	'sound/weapons/gunshot/gunshot_suppressed.ogg',
	'sound/weapons/gunshot/gunshot_svd.ogg',
	'sound/weapons/gunshot/gunshot_tommygun.ogg',
	'sound/weapons/gunshot/gunshot1.ogg',
	'sound/weapons/gunshot/gunshot2.ogg',
	'sound/weapons/gunshot/gunshot3.ogg',
	'sound/weapons/gunshot/musket.ogg',
	'sound/weapons/gunshot/slammer.ogg'
)

/decl/sound_category/gunshots/energy
	sounds = list(
	'sound/weapons/gunshot/bolter.ogg',
	'sound/weapons/laser1.ogg',
	'sound/weapons/Laser2.ogg',
	'sound/weapons/laser3.ogg',
	'sound/weapons/lasercannonfire.ogg',
	'sound/weapons/marauder.ogg',
	'sound/weapons/laserdeep.ogg',
	'sound/weapons/laserstrong.ogg'
)

/decl/sound_category/shaker_shaking
	sounds = list(
		'sound/items/shaking1.ogg',
		'sound/items/shaking2.ogg',
		'sound/items/shaking3.ogg',
		'sound/items/shaking4.ogg',
		'sound/items/shaking5.ogg',
		'sound/items/shaking6.ogg'
	)

/decl/sound_category/shaker_lid_off
	sounds = list(
		'sound/items/shaker_lid_off1.ogg',
		'sound/items/shaker_lid_off2.ogg'
	)

/decl/sound_category/quick_arcade // quick punchy arcade sounds
	sounds = list(
		'sound/arcade/get_fuel.ogg',
		'sound/arcade/heal.ogg',
		'sound/arcade/hit.ogg',
		'sound/arcade/kill_crew.ogg',
		'sound/arcade/lose_fuel.ogg',
		'sound/arcade/mana.ogg',
		'sound/arcade/steal.ogg'
	)

/decl/sound_category/footstep_skrell_sound
	sounds = list(
		'sound/effects/footstep_skrell1.ogg',
		'sound/effects/footstep_skrell2.ogg',
		'sound/effects/footstep_skrell3.ogg',
		'sound/effects/footstep_skrell4.ogg',
		'sound/effects/footstep_skrell5.ogg',
		'sound/effects/footstep_skrell6.ogg'
	)

/decl/sound_category/hammer_sound
	sounds = list(
		'sound/items/tools/hammer1.ogg',
		'sound/items/tools/hammer2.ogg',
		'sound/items/tools/hammer3.ogg',
		'sound/items/tools/hammer4.ogg'
	)

/decl/sound_category/shovel_sound
	sounds = list(
		'sound/items/tools/shovel1.ogg',
		'sound/items/tools/shovel2.ogg',
		'sound/items/tools/shovel3.ogg'
	)

/decl/sound_category/supermatter_calm
	sounds = list('sound/machines/sm/accent/normal/1.ogg',
				  'sound/machines/sm/accent/normal/2.ogg',
				  'sound/machines/sm/accent/normal/3.ogg',
				  'sound/machines/sm/accent/normal/4.ogg',
				  'sound/machines/sm/accent/normal/5.ogg',
				  'sound/machines/sm/accent/normal/6.ogg',
				  'sound/machines/sm/accent/normal/7.ogg',
				  'sound/machines/sm/accent/normal/8.ogg',
				  'sound/machines/sm/accent/normal/9.ogg',
				  'sound/machines/sm/accent/normal/10.ogg',
				  'sound/machines/sm/accent/normal/11.ogg',
				  'sound/machines/sm/accent/normal/12.ogg',
				  'sound/machines/sm/accent/normal/13.ogg',
				  'sound/machines/sm/accent/normal/14.ogg',
				  'sound/machines/sm/accent/normal/15.ogg',
				  'sound/machines/sm/accent/normal/16.ogg',
				  'sound/machines/sm/accent/normal/17.ogg',
				  'sound/machines/sm/accent/normal/18.ogg',
				  'sound/machines/sm/accent/normal/19.ogg',
				  'sound/machines/sm/accent/normal/20.ogg',
				  'sound/machines/sm/accent/normal/21.ogg',
				  'sound/machines/sm/accent/normal/22.ogg',
				  'sound/machines/sm/accent/normal/23.ogg',
				  'sound/machines/sm/accent/normal/24.ogg',
				  'sound/machines/sm/accent/normal/25.ogg',
				  'sound/machines/sm/accent/normal/26.ogg',
				  'sound/machines/sm/accent/normal/27.ogg',
				  'sound/machines/sm/accent/normal/28.ogg',
				  'sound/machines/sm/accent/normal/29.ogg',
				  'sound/machines/sm/accent/normal/30.ogg',
				  'sound/machines/sm/accent/normal/31.ogg',
				  'sound/machines/sm/accent/normal/32.ogg',
				  'sound/machines/sm/accent/normal/33.ogg'
				  )

/decl/sound_category/supermatter_delam
	sounds = list('sound/machines/sm/accent/delam/1.ogg',
				  'sound/machines/sm/accent/delam/2.ogg',
				  'sound/machines/sm/accent/delam/3.ogg',
				  'sound/machines/sm/accent/delam/4.ogg',
				  'sound/machines/sm/accent/delam/5.ogg',
				  'sound/machines/sm/accent/delam/6.ogg',
				  'sound/machines/sm/accent/delam/7.ogg',
				  'sound/machines/sm/accent/delam/8.ogg',
				  'sound/machines/sm/accent/delam/9.ogg',
				  'sound/machines/sm/accent/delam/10.ogg',
				  'sound/machines/sm/accent/delam/11.ogg',
				  'sound/machines/sm/accent/delam/12.ogg',
				  'sound/machines/sm/accent/delam/13.ogg',
				  'sound/machines/sm/accent/delam/14.ogg',
				  'sound/machines/sm/accent/delam/15.ogg',
				  'sound/machines/sm/accent/delam/16.ogg',
				  'sound/machines/sm/accent/delam/17.ogg',
				  'sound/machines/sm/accent/delam/18.ogg',
				  'sound/machines/sm/accent/delam/19.ogg',
				  'sound/machines/sm/accent/delam/20.ogg',
				  'sound/machines/sm/accent/delam/21.ogg',
				  'sound/machines/sm/accent/delam/22.ogg',
				  'sound/machines/sm/accent/delam/23.ogg',
				  'sound/machines/sm/accent/delam/24.ogg',
				  'sound/machines/sm/accent/delam/25.ogg',
				  'sound/machines/sm/accent/delam/26.ogg',
				  'sound/machines/sm/accent/delam/27.ogg',
				  'sound/machines/sm/accent/delam/28.ogg',
				  'sound/machines/sm/accent/delam/29.ogg',
				  'sound/machines/sm/accent/delam/30.ogg',
				  'sound/machines/sm/accent/delam/31.ogg',
				  'sound/machines/sm/accent/delam/32.ogg',
				  'sound/machines/sm/accent/delam/33.ogg'
				  )
