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

		if(istype(player, /mob/abstract/observer) && player_turf.z)
			dead_players_by_zlevel[player_turf.z] += player

	. = list()//output everything that successfully heard the sound

	var/turf/above_turf = GetAbove(turf_source)
	var/turf/below_turf = GetBelow(turf_source)

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
			listening_mob.playsound_local(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, maxdistance, falloff_distance, 1, use_reverb)
			. += listening_mob

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

/client/proc/playtitlemusic(vol = 85)
	set waitfor = FALSE
	UNTIL(SSticker.login_music) //wait for SSticker init to set the login music

	if(prefs.toggles & SOUND_LOBBY)
		SEND_SOUND(src, sound(SSticker.login_music, repeat = 0, wait = 0, volume = vol, channel = CHANNEL_LOBBYMUSIC)) // MAD JAMS

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

//Unlike TG, we use singletons here, so this is different, for now
/proc/get_sfx(soundin)
	if(isfile(soundin) || (istext(soundin) && !ispath(soundin)))
		return soundin

	var/singleton/sound_category/SC = GET_SINGLETON(soundin)
	if(!istype(SC))
		CRASH("Non-decl path in get_sfx: [soundin]")
	return SC.get_sound()

/singleton/sound_category
	var/list/sounds = list()

/singleton/sound_category/proc/get_sound()
	return pick(sounds)

/singleton/sound_category/blank_footsteps
	sounds = list('sound/effects/footstep/blank.ogg')

/singleton/sound_category/catwalk_footstep
	sounds = list(
		'sound/effects/footstep/catwalk1.ogg',
		'sound/effects/footstep/catwalk2.ogg',
		'sound/effects/footstep/catwalk3.ogg',
		'sound/effects/footstep/catwalk4.ogg',
		'sound/effects/footstep/catwalk5.ogg'
	)

/singleton/sound_category/wood_footstep
	sounds = list(
		'sound/effects/footstep/wood1.ogg',
		'sound/effects/footstep/wood2.ogg',
		'sound/effects/footstep/wood3.ogg',
		'sound/effects/footstep/wood4.ogg',
		'sound/effects/footstep/wood5.ogg'
	)

/singleton/sound_category/tiles_footstep
	sounds = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'
	)

/singleton/sound_category/plating_footstep
	sounds = list(
		'sound/effects/footstep/plating1.ogg',
		'sound/effects/footstep/plating2.ogg',
		'sound/effects/footstep/plating3.ogg',
		'sound/effects/footstep/plating4.ogg',
		'sound/effects/footstep/plating5.ogg'
	)

/singleton/sound_category/carpet_footstep
	sounds = list(
		'sound/effects/footstep/carpet1.ogg',
		'sound/effects/footstep/carpet2.ogg',
		'sound/effects/footstep/carpet3.ogg',
		'sound/effects/footstep/carpet4.ogg',
		'sound/effects/footstep/carpet5.ogg'
	)

/singleton/sound_category/asteroid_footstep
	sounds = list(
		'sound/effects/footstep/asteroid1.ogg',
		'sound/effects/footstep/asteroid2.ogg',
		'sound/effects/footstep/asteroid3.ogg',
		'sound/effects/footstep/asteroid4.ogg',
		'sound/effects/footstep/asteroid5.ogg'
	)

/singleton/sound_category/grass_footstep
	sounds = list(
		'sound/effects/footstep/grass1.ogg',
		'sound/effects/footstep/grass2.ogg',
		'sound/effects/footstep/grass3.ogg',
		'sound/effects/footstep/grass4.ogg'
	)

/singleton/sound_category/water_footstep
	sounds = list(
		'sound/effects/footstep/water1.ogg',
		'sound/effects/footstep/water2.ogg',
		'sound/effects/footstep/water3.ogg',
		'sound/effects/footstep/water4.ogg'
	)

/singleton/sound_category/lava_footstep
	sounds = list(
		'sound/effects/footstep/lava1.ogg',
		'sound/effects/footstep/lava2.ogg',
		'sound/effects/footstep/lava3.ogg'
	)

/singleton/sound_category/snow_footstep
	sounds = list(
		'sound/effects/footstep/snow1.ogg',
		'sound/effects/footstep/snow2.ogg',
		'sound/effects/footstep/snow3.ogg',
		'sound/effects/footstep/snow4.ogg',
		'sound/effects/footstep/snow5.ogg'
	)

/singleton/sound_category/sand_footstep
	sounds = list(
		'sound/effects/footstep/sand1.ogg',
		'sound/effects/footstep/sand2.ogg',
		'sound/effects/footstep/sand3.ogg',
		'sound/effects/footstep/sand4.ogg'
	)

/singleton/sound_category/glass_break_sound
	sounds = list(
		'sound/effects/glass_break1.ogg',
		'sound/effects/glass_break2.ogg',
		'sound/effects/glass_break3.ogg'
	)

/singleton/sound_category/cardboard_break_sound
	sounds = list(
		'sound/effects/cardboard_break1.ogg',
		'sound/effects/cardboard_break2.ogg',
		'sound/effects/cardboard_break3.ogg',
	)

/singleton/sound_category/wood_break_sound
	sounds = list(
		'sound/effects/wood_break1.ogg',
		'sound/effects/wood_break2.ogg',
		'sound/effects/wood_break3.ogg'
	)

/singleton/sound_category/explosion_sound
	sounds = list(
		'sound/effects/Explosion1.ogg',
		'sound/effects/Explosion2.ogg'
	)

/singleton/sound_category/spark_sound
	sounds = list(
		'sound/effects/sparks1.ogg',
		'sound/effects/sparks2.ogg',
		'sound/effects/sparks3.ogg',
		'sound/effects/sparks4.ogg'
	)

/singleton/sound_category/rustle_sound
	sounds = list(
		'sound/items/storage/rustle1.ogg',
		'sound/items/storage/rustle2.ogg',
		'sound/items/storage/rustle3.ogg',
		'sound/items/storage/rustle4.ogg',
		'sound/items/storage/rustle5.ogg'
	)

/singleton/sound_category/punch_sound
	sounds = list(
		'sound/weapons/punch1.ogg',
		'sound/weapons/punch2.ogg',
		'sound/weapons/punch3.ogg',
		'sound/weapons/punch4.ogg'
	)

/singleton/sound_category/punch_bassy_sound
	sounds = list(
		'sound/weapons/punch1_bass.ogg',
		'sound/weapons/punch2_bass.ogg',
		'sound/weapons/punch3_bass.ogg',
		'sound/weapons/punch4_bass.ogg'
	)

/singleton/sound_category/punchmiss_sound
	sounds = list(
		'sound/weapons/punchmiss1.ogg',
		'sound/weapons/punchmiss2.ogg'
	)

/singleton/sound_category/swing_hit_sound
	sounds = list(
		'sound/weapons/genhit1.ogg',
		'sound/weapons/genhit2.ogg',
		'sound/weapons/genhit3.ogg'
	)

/singleton/sound_category/hiss_sound
	sounds = list(
		'sound/voice/hiss1.ogg',
		'sound/voice/hiss2.ogg',
		'sound/voice/hiss3.ogg',
		'sound/voice/hiss4.ogg'
	)

/singleton/sound_category/page_sound
	sounds = list(
		'sound/effects/pageturn1.ogg',
		'sound/effects/pageturn2.ogg',
		'sound/effects/pageturn3.ogg'
	)

/singleton/sound_category/fracture_sound
	sounds = list(
		'sound/effects/bonebreak1.ogg',
		'sound/effects/bonebreak2.ogg',
		'sound/effects/bonebreak3.ogg',
		'sound/effects/bonebreak4.ogg'
	)

/singleton/sound_category/button_sound
	sounds = list(
		'sound/machines/button1.ogg',
		'sound/machines/button2.ogg',
		'sound/machines/button3.ogg',
		'sound/machines/button4.ogg'
	)

/singleton/sound_category/computerbeep_sound
	sounds = list(
		'sound/machines/compbeep1.ogg',
		'sound/machines/compbeep2.ogg',
		'sound/machines/compbeep3.ogg',
		'sound/machines/compbeep4.ogg',
		'sound/machines/compbeep5.ogg'
	)

/singleton/sound_category/switch_sound
	sounds = list(
		'sound/machines/switch1.ogg',
		'sound/machines/switch2.ogg',
		'sound/machines/switch3.ogg',
		'sound/machines/switch4.ogg'
	)

/singleton/sound_category/keyboard_sound
	sounds = list(
		'sound/machines/keyboard/keyboard1.ogg',
		'sound/machines/keyboard/keyboard2.ogg',
		'sound/machines/keyboard/keyboard3.ogg',
		'sound/machines/keyboard/keyboard4.ogg',
		'sound/machines/keyboard/keyboard5.ogg'
	)

/singleton/sound_category/pickaxe_sound
	sounds = list(
		'sound/weapons/mine/pickaxe1.ogg',
		'sound/weapons/mine/pickaxe2.ogg',
		'sound/weapons/mine/pickaxe3.ogg',
		'sound/weapons/mine/pickaxe4.ogg'
	)

/singleton/sound_category/glasscrack_sound
	sounds = list(
		'sound/effects/glass_crack1.ogg',
		'sound/effects/glass_crack2.ogg',
		'sound/effects/glass_crack3.ogg',
		'sound/effects/glass_crack4.ogg'
	)

/singleton/sound_category/bodyfall_sound
	sounds = list(
		'sound/effects/bodyfall1.ogg',
		'sound/effects/bodyfall2.ogg',
		'sound/effects/bodyfall3.ogg',
		'sound/effects/bodyfall4.ogg'
	)

/singleton/sound_category/bodyfall_skrell_sound
	sounds = list(
		'sound/effects/bodyfall_skrell1.ogg',
		'sound/effects/bodyfall_skrell2.ogg',
		'sound/effects/bodyfall_skrell3.ogg',
		'sound/effects/bodyfall_skrell4.ogg'
	)

/singleton/sound_category/bodyfall_machine_sound
	sounds = list(
		'sound/effects/bodyfall_machine1.ogg',
		'sound/effects/bodyfall_machine2.ogg'
	)
/singleton/sound_category/bulletflyby_sound
		sounds = list(
		'sound/effects/bulletflyby1.ogg',
		'sound/effects/bulletflyby2.ogg',
		'sound/effects/bulletflyby3.ogg'
	)

/singleton/sound_category/crowbar_sound
	sounds = list(
		'sound/items/crowbar1.ogg',
		'sound/items/crowbar2.ogg',
		'sound/items/crowbar3.ogg',
		'sound/items/crowbar4.ogg'
	)

/singleton/sound_category/casing_drop_sound
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

/singleton/sound_category/casing_drop_sound_shotgun
	sounds = list(
		'sound/items/drop/casing_shotgun1.ogg',
		'sound/items/drop/casing_shotgun2.ogg',
		'sound/items/drop/casing_shotgun3.ogg',
		'sound/items/drop/casing_shotgun4.ogg',
		'sound/items/drop/casing_shotgun5.ogg'
	)

/singleton/sound_category/out_of_ammo
	sounds = list(
		'sound/weapons/empty/empty2.ogg',
		'sound/weapons/empty/empty3.ogg',
		'sound/weapons/empty/empty4.ogg',
		'sound/weapons/empty/empty5.ogg',
		'sound/weapons/empty/empty6.ogg'
	)

/singleton/sound_category/out_of_ammo_revolver
	sounds = list(
		'sound/weapons/empty/empty_revolver.ogg',
		'sound/weapons/empty/empty_revolver3.ogg'
	)

/singleton/sound_category/out_of_ammo_rifle
	sounds = list(
		'sound/weapons/empty/empty_rifle1.ogg',
		'sound/weapons/empty/empty_rifle2.ogg'
	)

/singleton/sound_category/out_of_ammo_shotgun
	sounds = list(
		'sound/weapons/empty/empty_shotgun1.ogg'
	)

/singleton/sound_category/metal_slide_reload
	sounds = list(
		'sound/weapons/reloads/pistol_metal_slide1.ogg',
		'sound/weapons/reloads/pistol_metal_slide2.ogg',
		'sound/weapons/reloads/pistol_metal_slide3.ogg',
		'sound/weapons/reloads/pistol_metal_slide4.ogg',
		'sound/weapons/reloads/pistol_metal_slide5.ogg',
		'sound/weapons/reloads/pistol_metal_slide6.ogg'
	)

/singleton/sound_category/polymer_slide_reload
	sounds = list(
		'sound/weapons/reloads/pistol_polymer_slide1.ogg',
		'sound/weapons/reloads/pistol_polymer_slide2.ogg',
		'sound/weapons/reloads/pistol_polymer_slide3.ogg'
	)

/singleton/sound_category/rifle_slide_reload
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

/singleton/sound_category/revolver_reload
	sounds = list(
		'sound/weapons/reloads/revolver_reload.ogg'
	)
/singleton/sound_category/shotgun_pump
	sounds = list(
		'sound/weapons/reloads/shotgun_pump2.ogg',
		'sound/weapons/reloads/shotgun_pump3.ogg',
		'sound/weapons/reloads/shotgun_pump4.ogg',
		'sound/weapons/reloads/shotgun_pump5.ogg',
		'sound/weapons/reloads/shotgun_pump6.ogg'
	)

/singleton/sound_category/shotgun_reload
	sounds = list(
		'sound/weapons/reloads/reload_shell.ogg',
		'sound/weapons/reloads/reload_shell2.ogg',
		'sound/weapons/reloads/reload_shell3.ogg',
		'sound/weapons/reloads/reload_shell4.ogg'
	)

/singleton/sound_category/heavy_machine_gun_reload
	sounds = list(
		'sound/weapons/reloads/hmg_reload1.ogg',
		'sound/weapons/reloads/hmg_reload2.ogg',
		'sound/weapons/reloads/hmg_reload3.ogg'
	)
/singleton/sound_category/drillhit_sound
	sounds = list(
		'sound/weapons/saw/drillhit1.ogg',
		'sound/weapons/saw/drillhit2.ogg'
	)

/singleton/sound_category/generic_drop_sound
	sounds = list(
		'sound/items/drop/generic1.ogg',
		'sound/items/drop/generic2.ogg'
	)
/singleton/sound_category/generic_pickup_sound
	sounds = list(
		'sound/items/pickup/generic1.ogg',
		'sound/items/pickup/generic2.ogg',
		'sound/items/pickup/generic3.ogg'
	)
/singleton/sound_category/generic_wield_sound
	sounds = list(
		'sound/items/wield/generic1.ogg',
		'sound/items/wield/generic2.ogg',
		'sound/items/wield/generic3.ogg'
	)

/singleton/sound_category/generic_pour_sound
	sounds = list(
		'sound/effects/pour1.ogg',
		'sound/effects/pour2.ogg'
	)

/singleton/sound_category/wield_generic_sound
	sounds = list(
		'sound/items/wield/generic1.ogg',
		'sound/items/wield/generic2.ogg',
		'sound/items/wield/generic3.ogg'
	)

/singleton/sound_category/sword_pickup_sound
	sounds = list(
		'sound/items/pickup/sword1.ogg',
		'sound/items/pickup/sword2.ogg',
		'sound/items/pickup/sword3.ogg'
	)

/singleton/sound_category/sword_equip_sound
	sounds = list(
		'sound/items/equip/sword1.ogg',
		'sound/items/equip/sword2.ogg'
	)

/singleton/sound_category/gauss_fire_sound
	sounds = list(
		'sound/weapons/gaussrifle1.ogg',
		'sound/weapons/gaussrifle2.ogg'
	)

/singleton/sound_category/bottle_hit_intact_sound
	sounds = list(
		'sound/weapons/bottlehit_intact1.ogg',
		'sound/weapons/bottlehit_intact2.ogg',
		'sound/weapons/bottlehit_intact3.ogg'
	)
/singleton/sound_category/bottle_hit_broken
	sounds = list(
		'sound/weapons/bottlehit_broken1.ogg',
		'sound/weapons/bottlehit_broken2.ogg',
		'sound/weapons/bottlehit_broken3.ogg'
	)
/singleton/sound_category/tray_hit_sound
	sounds = list(
		'sound/items/trayhit1.ogg',
		'sound/items/trayhit2.ogg'
	)

/singleton/sound_category/grab_sound
	sounds = list(
	'sound/weapons/grab/grab1.ogg',
	'sound/weapons/grab/grab2.ogg',
	'sound/weapons/grab/grab3.ogg',
	'sound/weapons/grab/grab4.ogg',
	'sound/weapons/grab/grab5.ogg'
)

/singleton/sound_category/gunshots
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

/singleton/sound_category/gunshots/ballistic
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

/singleton/sound_category/gunshots/energy
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

/singleton/sound_category/shaker_shaking
	sounds = list(
		'sound/items/shaking1.ogg',
		'sound/items/shaking2.ogg',
		'sound/items/shaking3.ogg',
		'sound/items/shaking4.ogg',
		'sound/items/shaking5.ogg',
		'sound/items/shaking6.ogg'
	)

/singleton/sound_category/shaker_lid_off
	sounds = list(
		'sound/items/shaker_lid_off1.ogg',
		'sound/items/shaker_lid_off2.ogg'
	)

/singleton/sound_category/boops
	sounds = list(
		'sound/machines/boop1.ogg',
		'sound/machines/boop2.ogg'
	)

/singleton/sound_category/quick_arcade // quick punchy arcade sounds
	sounds = list(
		'sound/arcade/get_fuel.ogg',
		'sound/arcade/heal.ogg',
		'sound/arcade/hit.ogg',
		'sound/arcade/kill_crew.ogg',
		'sound/arcade/lose_fuel.ogg',
		'sound/arcade/mana.ogg',
		'sound/arcade/steal.ogg'
	)

/singleton/sound_category/footstep_skrell_sound
	sounds = list(
		'sound/effects/footstep_skrell1.ogg',
		'sound/effects/footstep_skrell2.ogg',
		'sound/effects/footstep_skrell3.ogg',
		'sound/effects/footstep_skrell4.ogg',
		'sound/effects/footstep_skrell5.ogg',
		'sound/effects/footstep_skrell6.ogg'
	)

/singleton/sound_category/hammer_sound
	sounds = list(
		'sound/items/tools/hammer1.ogg',
		'sound/items/tools/hammer2.ogg',
		'sound/items/tools/hammer3.ogg',
		'sound/items/tools/hammer4.ogg'
	)

/singleton/sound_category/shovel_sound
	sounds = list(
		'sound/items/tools/shovel1.ogg',
		'sound/items/tools/shovel2.ogg',
		'sound/items/tools/shovel3.ogg'
	)

/singleton/sound_category/supermatter_calm
	sounds = list(
					'sound/machines/sm/accent/normal/1.ogg',
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

/singleton/sound_category/supermatter_delam
	sounds = list(
					'sound/machines/sm/accent/delam/1.ogg',
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

/singleton/sound_category/rip_sound
	sounds = list(
		'sound/items/rip1.ogg',
		'sound/items/rip2.ogg',
		'sound/items/rip3.ogg',
		'sound/items/rip4.ogg'
	)

/singleton/sound_category/ointment_sound
	sounds = list(
		'sound/items/ointment1.ogg',
		'sound/items/ointment2.ogg',
		'sound/items/ointment3.ogg'
	)

/singleton/sound_category/clown_sound
	sounds = list(
		'sound/effects/clownstep1.ogg',
		'sound/effects/clownstep2.ogg'
	)

/singleton/sound_category/hivebot_melee
	sounds = list(
		'sound/effects/creatures/hivebot/hivebot-attack.ogg',
		'sound/effects/creatures/hivebot/hivebot-attack-001.ogg'
	)

/singleton/sound_category/hivebot_wail
	sounds = list(
		'sound/effects/creatures/hivebot/hivebot-bark-001.ogg',
		'sound/effects/creatures/hivebot/hivebot-bark-003.ogg',
		'sound/effects/creatures/hivebot/hivebot-bark-005.ogg',
	)

/singleton/sound_category/print_sound
	sounds = list(
		'sound/items/polaroid1.ogg',
		'sound/items/polaroid2.ogg'
	)
