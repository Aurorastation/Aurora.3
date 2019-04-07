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
	'sound/effects/rustle1.ogg',
	'sound/effects/rustle2.ogg',
	'sound/effects/rustle3.ogg',
	'sound/effects/rustle4.ogg',
	'sound/effects/rustle5.ogg'
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

var/list/swing_sound = list(
	'sound/weapons/swing_01.ogg',
	'sound/weapons/swing_02.ogg',
	'sound/weapons/swing_03.ogg'
	)

var/list/blunt_swing = list(
	'sound/weapons/blunt_swing1.ogg',
	'sound/weapons/blunt_swing2.ogg',
	'sound/weapons/blunt_swing3.ogg'
	)

var/list/footstepfx = list(
	"defaultstep",
	"concretestep",
	"grassstep",
	"dirtstep",
	"waterstep",
	"sandstep",
	"gravelstep"
	)

var/list/button_sound = list(
	'sound/machines/button1.ogg',
	'sound/machines/button2.ogg',
	'sound/machines/button3.ogg',
	'sound/machines/button4.ogg'
	)

var/list/stab_sound = list(
	'sound/weapons/stab1.ogg',
	'sound/weapons/stab2.ogg',
	'sound/weapons/stab3.ogg'
	)

var/list/slash_sound = list(
	'sound/weapons/slash1.ogg',
	'sound/weapons/slash2.ogg',
	'sound/weapons/slash3.ogg'
	)

var/list/brifle = list(
	'sound/weapons/newrifle.ogg',
	'sound/weapons/newrifle2.ogg',
	'sound/weapons/newrifle3.ogg'
	)

var/list/bullet_hit_wall = list(
	'sound/weapons/guns/misc/ric1.ogg',
	'sound/weapons/guns/misc/ric2.ogg',
	'sound/weapons/guns/misc/ric3.ogg',
	'sound/weapons/guns/misc/ric4.ogg',
	'sound/weapons/guns/misc/ric5.ogg'
	)

var/list/casing_sound = list (
	'sound/weapons/guns/misc/casingfall1.ogg',
	'sound/weapons/guns/misc/casingfall2.ogg',
	'sound/weapons/guns/misc/casingfall3.ogg'
	)

var/list/trauma_sound = list(
	'sound/effects/gore/trauma1.ogg',
	'sound/effects/gore/trauma2.ogg',
	'sound/effects/gore/trauma3.ogg'
	)

var/list/chop_sound = list(
	'sound/effects/gore/chop1.ogg',
	'sound/effects/gore/chop2.ogg',
	'sound/effects/gore/chop3.ogg',
	'sound/effects/gore/chop4.ogg',
	'sound/effects/gore/chop5.ogg',
	'sound/effects/gore/chop6.ogg',
	)

//var/list/gun_sound = list('sound/weapons/Gunshot.ogg', 'sound/weapons/Gunshot2.ogg','sound/weapons/Gunshot3.ogg','sound/weapons/Gunshot4.ogg')

/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff, is_global, usepressure = 1, environment = -1, is_ambience = FALSE, is_footstep = FALSE)
	if (istext(soundin))
		soundin = get_sfx(soundin) // same sound for everyone
	else if (isarea(source))
		error("[source] is an area and is trying to make the sound: [soundin]")
		return

	var/frequency = get_rand_frequency() // Same frequency for everybody
	var/turf/turf_source = get_turf(source)
	// cache this so we don't create a new one for everybody
	var/sound/S = sound(soundin)
 	// Looping through the player list has the added bonus of working for mobs inside containers
	for (var/P in player_list)
		var/mob/M = P
		if(!M || !M.client)
			continue

		var/distance = get_dist(M, turf_source)
		if(distance <= (world.view + extrarange) * 3)
			var/turf/T = get_turf(M)

			// These checks are split into multiple ifs for readability reasons.

			if (!T || T.z != turf_source.z)
				continue

			if (is_ambience && !(M.client.prefs.toggles & SOUND_AMBIENCE))
				continue

			if (is_footstep && !(M.client.prefs.asfx_togs & ASFX_FOOTSTEPS))
				continue

			M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, is_global, usepressure, environment, S)

/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff, is_global, usepressure = 1, environment = -1, sound/S)
	if(!client || ear_deaf > 0)
		return 0

	if (!S)
		S = sound(get_sfx(soundin))

	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.environment = environment

	if (vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	//sound volume falloff with pressure
	var/pressure_factor = 1.0

	if(isturf(turf_source))
		// 3D sounds, the technology is here!
		var/turf/T = get_turf(src)

		//sound volume falloff with distance
		var/distance = get_dist(T, turf_source)

		vol -= max(distance - world.view, 0) * 2 //multiplicative falloff to add on top of natural audio falloff.
		//Not sure if author understood what they were doing, but this is not multiplicative, its linear, and its implementation breaks longdistance sounds.
			//This extra falloff should probably be rewritten or removed, but for now ive implemented a quick fix by only setting S.volume to vol after calculations are done
			//This fix allows feeding in high volume values (>100) to make longrange sounds audible
			// -Nanako
		if (usepressure)
			//sound volume falloff with pressure. Pass usepressure = 0 to disable these calculations

			var/datum/gas_mixture/hearer_env = T.return_air()
			var/datum/gas_mixture/source_env = turf_source.return_air()

			if (hearer_env && source_env)
				var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())

				if (pressure < ONE_ATMOSPHERE)
					pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
			else //in space
				pressure_factor = 0

			if (distance <= 1)
				pressure_factor = max(pressure_factor, 0.15)	//hearing through contact

			vol *= pressure_factor

		if (vol <= 0)
			return	0//no volume means no sound

		S.volume = vol
		var/dx = turf_source.x - T.x // Hearing from the right/left
		S.x = dx
		var/dz = turf_source.y - T.y // Hearing from infront/behind
		S.z = dz
		// 3D sound, truly this is the future.
		S.y = (turf_source.z - T.z) * SOUND_Z_FACTOR
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)

	if(!is_global && environment != 0)
		if(istype(src,/mob/living/))
			var/mob/living/M = src
			if (M.hallucination)
				S.environment = PSYCHOTIC
			else if (M.druggy)
				S.environment = DRUGGED
			else if (M.drowsyness)
				S.environment = DIZZY
			else if (M.confused)
				S.environment = DIZZY
			else if (M.sleeping)
				S.environment = UNDERWATER
			else if (pressure_factor < 0.5)
				S.environment = SPACE
			else
				var/area/A = get_area(src)
				S.environment = A.sound_env

		else if (pressure_factor < 0.5)
			S.environment = SPACE
		else
			var/area/A = get_area(src)
			S.environment = A.sound_env

	sound_to(src, S)
	return S.volume

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
			if ("slash_sound") soundin = pick(slash_sound)
			if ("swing_sound") soundin = pick(swing_sound)
			if ("blunt_swing") soundin = pick(blunt_swing)
			if ("brifle") soundin = pick(brifle)
			if ("hitwall") soundin = pick(bullet_hit_wall)
			if ("casing_sound") soundin = pick(casing_sound)
			if ("trauma") soundin = pick(trauma_sound)
			if ("chop") soundin = pick(chop_sound)
	return soundin
