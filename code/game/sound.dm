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

#define EQUIP_SOUND_VOLUME 30
#define PICKUP_SOUND_VOLUME 15
#define DROP_SOUND_VOLUME 20
#define THROW_SOUND_VOLUME 90

// Ambience presets.
// All you need to do to make an area play one of these is set their ambience var to one of these lists.
// You can even combine them by adding them together, since they're just lists, however you'd have to do that in initialization.

// For weird alien places like Srom.
#define AMBIENCE_OTHERWORLDLY list(\
	'sound/ambience/otherworldly/otherworldly1.ogg',\
	'sound/ambience/otherworldly/otherworldly2.ogg',\
	'sound/ambience/otherworldly/otherworldly3.ogg'\
	)

// Restricted, military, or mercenary aligned locations like the armory, the merc ship/base, BSD, etc.
#define AMBIENCE_HIGHSEC list(\
	'sound/ambience/highsec/highsec1.ogg',\
	'sound/ambience/highsec/highsec2.ogg',\
	'sound/ambience/highsec/highsec3.ogg',\
	'sound/ambience/highsec/highsec4.ogg'\
	)

// Ruined structures found on the surface or in the caves.
#define AMBIENCE_RUINS list(\
	'sound/ambience/ruins/ruins1.ogg',\
	'sound/ambience/ruins/ruins2.ogg',\
	'sound/ambience/ruins/ruins3.ogg',\
	'sound/ambience/ruins/ruins4.ogg',\
	'sound/ambience/ruins/ruins5.ogg',\
	'sound/ambience/ruins/ruins6.ogg'\
	)

// Similar to the above, but for more technology/signaling based ruins.
#define AMBIENCE_TECH_RUINS list(\
	'sound/ambience/tech_ruins/tech_ruins1.ogg',\
	'sound/ambience/tech_ruins/tech_ruins2.ogg',\
	'sound/ambience/tech_ruins/tech_ruins3.ogg'\
	)

// The actual chapel room, and maybe some other places of worship.
#define AMBIENCE_CHAPEL list(\
	'sound/ambience/chapel/chapel1.ogg',\
	'sound/ambience/chapel/chapel2.ogg',\
	'sound/ambience/chapel/chapel3.ogg',\
	'sound/ambience/chapel/chapel4.ogg'\
	)

// For peaceful, serene areas, distinct from the Chapel.
#define AMBIENCE_HOLY list(\
	'sound/ambience/holy/holy1.ogg',\
	'sound/ambience/holy/holy2.ogg'\
	)

// Generic sounds for less special rooms.
#define AMBIENCE_GENERIC list(\
	'sound/ambience/generic/generic1.ogg',\
	'sound/ambience/generic/generic2.ogg',\
	'sound/ambience/generic/generic3.ogg',\
	'sound/ambience/generic/generic4.ogg',\
	'sound/ambience/generic/generic5.ogg',\
	'sound/ambience/generic/generic6.ogg',\
	'sound/ambience/generic/generic7.ogg',\
	'sound/ambience/generic/generic8.ogg'\
	)

// Sounds of PA announcements, presumably involving shuttles?
#define AMBIENCE_ARRIVALS list(\
	'sound/ambience/arrivals/arrivals1.ogg',\
	'sound/ambience/arrivals/arrivals2.ogg',\
	'sound/ambience/arrivals/arrivals3.ogg',\
	'sound/ambience/arrivals/arrivals4.ogg',\
	'sound/ambience/arrivals/arrivals5.ogg',\
	'sound/ambience/arrivals/arrivals6.ogg',\
	'sound/ambience/arrivals/arrivals7.ogg'\
	)


// Sounds suitable for being inside dark, tight corridors in the underbelly of the station.
#define AMBIENCE_MAINTENANCE list(\
	'sound/ambience/maintenance/maintenance1.ogg',\
	'sound/ambience/maintenance/maintenance2.ogg',\
	'sound/ambience/maintenance/maintenance3.ogg',\
	'sound/ambience/maintenance/maintenance4.ogg',\
	'sound/ambience/maintenance/maintenance5.ogg',\
	'sound/ambience/maintenance/maintenance6.ogg',\
	'sound/ambience/maintenance/maintenance7.ogg',\
	'sound/ambience/maintenance/maintenance8.ogg',\
	'sound/ambience/maintenance/maintenance9.ogg',\
	'sound/ambience/maintenance/maintenance10.ogg',\
	'sound/ambience/maintenance/maintenance11.ogg',\
	'sound/ambience/maintenance/maintenance12.ogg'\
	)

// Life support machinery at work, keeping everyone breathing.
#define AMBIENCE_ENGINEERING list(\
	'sound/ambience/engineering/engineering1.ogg',\
	'sound/ambience/engineering/engineering2.ogg',\
	'sound/ambience/engineering/engineering3.ogg'\
	)

#define AMBIENCE_SINGULARITY list(\
	'sound/ambience/singularity/singularity1.ogg',\
	'sound/ambience/singularity/singularity2.ogg',\
	'sound/ambience/singularity/singularity3.ogg',\
	'sound/ambience/singularity/singularity4.ogg'\
	)

//CHOMP Edit Sounds for atmos
#define AMBIENCE_ATMOS list(\
	'sound/ambience/atmospherics/atmospherics1.ogg',\
	'sound/ambience/atmospherics/atmospherics2.ogg'\
	)

// Creepy AI/borg stuff.
#define AMBIENCE_AI list(\
	'sound/ambience/ai/ai1.ogg',\
	'sound/ambience/ai/ai2.ogg',\
	'sound/ambience/ai/ai3.ogg'\
	)

// Peaceful sounds when floating in the void.
#define AMBIENCE_SPACE list(\
	'sound/ambience/space/space_serithi.ogg',\
	'sound/ambience/space/space1.ogg'\
	)

// Vaguely spooky sounds when around dead things.
#define AMBIENCE_GHOSTLY list(\
	'sound/ambience/ghostly/ghostly1.ogg',\
	'sound/ambience/ghostly/ghostly2.ogg'\
	)

// Concerning sounds, for when one discovers something horrible happened in a PoI.
#define AMBIENCE_FOREBODING list(\
	'sound/ambience/foreboding/foreboding1.ogg',\
	'sound/ambience/foreboding/foreboding2.ogg'\
	)

// If we ever add geothermal PoIs or other places that are really hot, this will do.
#define AMBIENCE_LAVA list(\
	'sound/ambience/lava/lava1.ogg'\
	)

// Cult-y ambience, for some PoIs, and maybe when the cultists darken the world with the ritual.
#define AMBIENCE_UNHOLY list(\
	'sound/ambience/unholy/unholy1.ogg'\
	)

#define AMBIENCE_ELEVATOR list(\
	'sound/ambience/elevator.ogg'\
	)

//CHOMPedit: Exploration outpost ambience.
#define AMBIENCE_EXPOUTPOST list(\
	'sound/ambience/expoutpost/expoutpost1.ogg',\
	'sound/ambience/expoutpost/expoutpost2.ogg',\
	'sound/ambience/expoutpost/expoutpost3.ogg',\
	'sound/ambience/expoutpost/expoutpost4.ogg'\
	)

//CHOMP Edit Sounds for Substation rooms. Just electrical sounds, really.
#define AMBIENCE_SUBSTATION list(\
	'sound/ambience/substation/substation1.ogg',\
	'sound/ambience/substation/substation2.ogg',\
	'sound/ambience/substation/substation3.ogg',\
	'sound/ambience/substation/substation4.ogg',\
	'sound/ambience/substation/substation5.ogg',\
	'sound/ambience/substation/substation6.ogg',\
	'sound/ambience/substation/substation7.ogg',\
	'sound/ambience/substation/substation8.ogg'\
	)

//CHOMP Edit Sounds for hangars
#define AMBIENCE_HANGAR list(\
	'sound/ambience/hangar/hangar1.ogg',\
	'sound/ambience/hangar/hangar2.ogg',\
	'sound/ambience/hangar/hangar3.ogg',\
	'sound/ambience/hangar/hangar4.ogg',\
	'sound/ambience/hangar/hangar5.ogg',\
	'sound/ambience/hangar/hangar6.ogg'\
	)

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
var/list/footstepfx = list(
	"blank",
	"catwalk",
	"wood",
	"tiles",
	"plating",
	"carpet",
	"asteroid",
	"grass",
	"water",
	"lava",
	"snow",
	"sand"
	)

var/list/glass_break_sound = list(
	'sound/effects/glass_break1.ogg',
	'sound/effects/glass_break2.ogg',
	'sound/effects/glass_break3.ogg'
)
var/list/cardboard_break_sound = list(
	'sound/effects/cardboard_break1.ogg',
	'sound/effects/cardboard_break2.ogg',
	'sound/effects/cardboard_break3.ogg',
)
var/list/wood_break_sound = list(
	'sound/effects/wood_break1.ogg',
	'sound/effects/wood_break2.ogg',
	'sound/effects/wood_break3.ogg',
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
var/list/punchmiss_sound = list(
	'sound/weapons/punchmiss1.ogg',
	'sound/weapons/punchmiss2.ogg'
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
	'sound/machines/keyboard/keyboard1.ogg',
	'sound/machines/keyboard/keyboard2.ogg',
	'sound/machines/keyboard/keyboard3.ogg',
	'sound/machines/keyboard/keyboard4.ogg',
	'sound/machines/keyboard/keyboard5.ogg'
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
var/list/bodyfall_sound = list(
	'sound/effects/bodyfall1.ogg',
	'sound/effects/bodyfall2.ogg',
	'sound/effects/bodyfall3.ogg',
	'sound/effects/bodyfall4.ogg'
)
var/list/bodyfall_machine_sound = list(
	'sound/effects/bodyfall_machine1.ogg',
	'sound/effects/bodyfall_machine2.ogg'
)
var/list/bulletflyby_sound = list(
	'sound/effects/bulletflyby1.ogg',
	'sound/effects/bulletflyby2.ogg',
	'sound/effects/bulletflyby3.ogg'
)
var/list/crowbar_sound = list(
	'sound/items/crowbar1.ogg',
	'sound/items/crowbar2.ogg',
	'sound/items/crowbar3.ogg',
	'sound/items/crowbar4.ogg'
)
var/list/casing_drop_sound = list(
	'sound/items/drop/casing1.ogg',
	'sound/items/drop/casing2.ogg',
	'sound/items/drop/casing3.ogg',
	'sound/items/drop/casing4.ogg',
	'sound/items/drop/casing5.ogg'
)
var/list/drillhit_sound = list(
	'sound/weapons/saw/drillhit1.ogg',
	'sound/weapons/saw/drillhit2.ogg'
)
// drop/equip/pickup sounds if there are multiple.
var/list/wield_generic_sound = list(
	'sound/items/wield/wield_generic1.ogg',
	'sound/items/wield/wield_generic2.ogg',
	'sound/items/wield/wield_generic3.ogg'
)
var/list/sword_pickup_sound = list(
	'sound/items/pickup/sword1.ogg',
	'sound/items/pickup/sword2.ogg',
	'sound/items/pickup/sword3.ogg'
)
var/list/sword_equip_sound = list(
	'sound/items/equip/sword1.ogg',
	'sound/items/equip/sword2.ogg'
)
// gunshots, if multiple.
var/list/gauss_fire_sound = list(
	'sound/weapons/gaussrifle1.ogg',
	'sound/weapons/gaussrifle2.ogg'
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

/mob/proc/playsound_simple(source, soundin, volume, use_random_freq = FALSE, frequency = 0, falloff = 0, use_pressure = TRUE, required_preferences = 0, required_asfx_toggles = 0)
	var/sound/S = playsound_get_sound(soundin, volume, falloff, frequency)

	playsound_to(source ? get_turf(source) : null, S, use_random_freq, use_pressure = use_pressure, required_preferences = required_preferences, required_asfx_toggles = required_asfx_toggles)

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
			// shatter sfx. mainly for materials
			if ("glass_break") soundin = pick(glass_break_sound)
			if ("cardboard_break") soundin = pick(cardboard_break_sound)
			if ("wood_break") soundin = pick(wood_break_sound)
			//misc
			if ("explosion") soundin = pick(explosion_sound)
			if ("sparks") soundin = pick(spark_sound)
			if ("rustle") soundin = pick(rustle_sound)
			if ("punch") soundin = pick(punch_sound)
			if ("punchmiss") soundin = pick(punchmiss_sound)
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
			if ("bodyfall") soundin = pick(bodyfall_sound)
			if ("bodyfall_machine") soundin = pick(bodyfall_machine_sound)
			if ("bulletflyby") soundin = pick(bulletflyby_sound)
			if ("crowbar") soundin = pick(crowbar_sound)
			if ("casing_drop") soundin = pick(casing_drop_sound)
			if ("drillhit") soundin = pick(drillhit_sound)
			if ("wield_generic") soundin = pick(wield_generic_sound)
			if ("equip_sword") soundin = pick(sword_equip_sound)
			if ("pickup_sword") soundin = pick(sword_pickup_sound)
			if ("gauss_fire") soundin = pick(gauss_fire_sound)
	return soundin
