/datum/looping_sound/showering
	start_sound = 'sound/machines/shower/shower_start.ogg'
	start_length = 2
	mid_sounds = list('sound/machines/shower/shower_mid1.ogg' = 1,'sound/machines/shower/shower_mid2.ogg' = 1,'sound/machines/shower/shower_mid3.ogg' = 1)
	mid_length = 10
	end_sound = 'sound/machines/shower/shower_end.ogg'
	volume = 20
	extra_range = SHORT_RANGE_SOUND_EXTRARANGE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/supermatter
	mid_sounds = list('sound/machines/sm/loops/calm.ogg' = 1)
	mid_length = 60
	volume = 40
	ignore_walls = FALSE
	falloff_distance = 4
	vary = TRUE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/generator
	start_sound = 'sound/machines/generator/generator_start.ogg'
	start_length = 4
	mid_sounds = list('sound/machines/generator/generator_mid1.ogg' = 1, 'sound/machines/generator/generator_mid2.ogg' = 1, 'sound/machines/generator/generator_mid3.ogg' = 1)
	mid_length = 4
	end_sound = 'sound/machines/generator/generator_end.ogg'
	volume = 20

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/grill
	mid_sounds = list('sound/machines/grill/grillsizzle.ogg' = 1)
	mid_length = 18
	volume = 50
	extra_range = SHORT_RANGE_SOUND_EXTRARANGE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/oven
	start_sound = 'sound/machines/oven/oven_loop_start.ogg' //my immersions
	start_length = 12
	mid_sounds = list('sound/machines/oven/oven_loop_mid.ogg' = 1)
	mid_length = 13
	end_sound = 'sound/machines/oven/oven_loop_end.ogg'
	volume = 100
	falloff_distance = 4
	extra_range = SHORT_RANGE_SOUND_EXTRARANGE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/microwave
	start_sound = 'sound/machines/microwave/microwave-start.ogg'
	start_length = 10
	mid_sounds = list('sound/machines/microwave/microwave-mid1.ogg'= 1, 'sound/machines/microwave/microwave-mid2.ogg'= 1)
	mid_length = 10
	end_sound = 'sound/machines/microwave/microwave-end.ogg'
	volume = 30
	extra_range = SHORT_RANGE_SOUND_EXTRARANGE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/server
	mid_sounds = list(
		'sound/machines/tcomms/tcomms_mid1.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid2.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid3.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid4.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid5.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid6.ogg' = 1,
		'sound/machines/tcomms/tcomms_mid7.ogg' = 1
	)
	mid_length = 1.8 SECONDS
	extra_range = SHORT_RANGE_SOUND_EXTRARANGE
	ignore_walls = FALSE
	volume = 10

//	mid_length = 1.8 SECONDS
//	extra_range = -11
//	falloff_distance = 1
//	falloff_exponent = 5 (falloff system from /tg/)(not smart enough to port it)
//	volume = 50
//	ignore_walls = FALSE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/looping_sound/computer
	start_sound = 'sound/machines/computer/computer_start.ogg'
	start_length = 7.2 SECONDS
	start_volume = 10
	mid_sounds = list('sound/machines/computer/computer_mid1.ogg' = 1, 'sound/machines/computer/computer_mid2.ogg' = 1)
	mid_length = 1.8 SECONDS
	end_sound = 'sound/machines/computer/computer_end.ogg'
	end_volume = 10
	volume = 1
	extra_range = SILENCED_SOUND_EXTRARANGE
	ignore_walls = FALSE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/gravgen
	mid_sounds = list('sound/machines/gravgen/gravgen_mid1.ogg' = 1, 'sound/machines/gravgen/gravgen_mid2.ogg' = 1, 'sound/machines/gravgen/gravgen_mid3.ogg' = 1, 'sound/machines/gravgen/gravgen_mid4.ogg' = 1)
	mid_length = 1.8 SECONDS
	extra_range = 10
	volume = 70
	ignore_walls = FALSE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/looping_sound/firealarm
	mid_sounds = list('sound/machines/firealarm/FireAlarm1.ogg' = 1,'sound/machines/firealarm/FireAlarm2.ogg' = 1,'sound/machines/firealarm/FireAlarm3.ogg' = 1,'sound/machines/firealarm/FireAlarm4.ogg' = 1)
	mid_length = 2.4 SECONDS
	volume = 75
	ignore_walls = FALSE

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
