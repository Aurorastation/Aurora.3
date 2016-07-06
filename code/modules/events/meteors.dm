//meteor storms are much heavier
/datum/event/meteor_wave
	startWhen		= 86
	endWhen			= 102

	var/wave_delay  = 8
	var/min_waves 	= 8
	var/max_waves 	= 12
	var/min_meteors = 4
	var/max_meteors = 6


	var/waves		= 8
	var/next_wave 	= 86

/datum/event/meteor_wave/setup()
	startWhen = 0//debugging
	startWhen += rand(-15,15)//slightly randomised start time
	waves = rand(min_waves,max_waves)
	next_wave = startWhen
	endWhen = next_wave+1

/datum/event/meteor_wave/announce()
	command_announcement.Announce("Meteors have been detected on collision course with the station. Estimated three minutes until impact", "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')

/datum/event/meteor_wave/tick()
	if(activeFor >= next_wave)
		var/amount = rand(min_meteors,max_meteors)

		event_meteor_wave(amount)
		next_wave += wave_delay
		waves--
		world << "Meteor storm triggering a wave of [amount] meteors. [waves] waves left"
		if(waves <= 0)
			endWhen = activeFor + 1
		else
			endWhen = next_wave + 1

/datum/event/meteor_wave/end()
	command_announcement.Announce("The meteor storm has passed the station. Commence any needed repairs immediately.", "Meteor Alert")

//
/datum/event/meteor_shower
	startWhen		= 86
	endWhen 		= 102

	var/wave_delay  = 8
	var/min_waves 	= 3
	var/max_waves 	= 4
	var/min_meteors = 2
	var/max_meteors = 4

	var/waves		= 4
	var/next_wave 	= 86

/datum/event/meteor_shower/setup()
	startWhen = 0//debugging
	startWhen += rand(-15,15)//slightly randomised start time
	waves = rand(min_waves,max_waves)
	next_wave = startWhen
	endWhen = next_wave+1

/datum/event/meteor_shower/announce()
	command_announcement.Announce("A light meteor shower is approaching the station, estimated contact in three minutes", "Meteor Alert")

//meteor showers are lighter and more common,
/datum/event/meteor_shower/tick()
	if(activeFor >= next_wave)
		var/amount = rand(min_meteors,max_meteors)

		event_meteor_wave(amount)
		next_wave += wave_delay
		waves--
		world << "Meteor shower triggering a wave of [amount] meteors. [waves] waves left"
		if(waves <= 0)
			endWhen = activeFor + 1
		else
			endWhen = next_wave + 1

/datum/event/meteor_shower/end()
	command_announcement.Announce("The station has cleared the meteor shower", "Meteor Alert")


//An event specific version of the meteor wave proc, to bypass the delays
/proc/event_meteor_wave(var/number = meteors_in_wave)
	for(var/i = 0 to number)
		spawn(rand(10,80))
			spawn_meteor()