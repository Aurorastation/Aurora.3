/datum/event/meteor_wave
	startWhen		= 86
	endWhen			= 9999//safety value, will be set during ticks

	var/wave_delay  = 13//Note, wave delay is in procs. actual time is equal to wave_delay * 2.1
	var/min_waves 	= 11
	var/max_waves 	= 16
	var/min_meteors = 1
	var/max_meteors = 2
	var/duration = 340//Total duration in seconds that the storm will last after it starts

	var/downed_ship = FALSE

	var/waves		= 8
	var/next_wave 	= 86
	ic_name = "a meteor storm"

/datum/event/meteor_wave/setup()
	startWhen += rand(-15,15)//slightly randomised start time
	waves = rand(min_waves,max_waves)
	next_wave = startWhen
	wave_delay = round(((duration - 10)/waves)/2.1, 1)

/datum/event/meteor_wave/announce()
	command_announcement.Announce(current_map.meteors_detected_message, "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')

/datum/event/meteor_wave/start()
	command_announcement.Announce(current_map.meteor_contact_message, "Meteor Alert")

/datum/event/meteor_wave/tick()
	if(activeFor >= next_wave)
		var/amount = rand(min_meteors,max_meteors)

		event_meteor_wave(amount)
		next_wave += wave_delay
		waves--
		if(waves <= 0)
			endWhen = activeFor + 1
		else
			endWhen = next_wave + wave_delay

/datum/event/meteor_wave/end(var/faked)
	if(faked)
		return
	spawn(100)//We give 10 seconds before announcing, for the last wave of meteors to hit the station
		command_announcement.Announce(current_map.meteor_contact_message, "Meteor Alert")

/datum/event/meteor_wave/shower
	wave_delay  = 6
	min_waves 	= 7
	max_waves 	= 9
	min_meteors = 0
	max_meteors = 1
	duration = 180 //Total duration in seconds that the storm will last after it starts

	waves		= 4//this is randomised
	next_wave 	= 86


/datum/event/meteor_wave/shower/end(var/faked)
	if(faked)
		return
	spawn(100)
		command_announcement.Announce(current_map.meteor_end_message, "Meteor Alert")


//An event specific version of the meteor wave proc, to bypass the delays
/datum/event/meteor_wave/proc/event_meteor_wave(var/number = meteors_in_wave)
	for(var/i = 0 to number)
		spawn(rand(10, 80))
			spawn_meteor(downed_ship)

/datum/event/meteor_wave/downed_ship
	downed_ship = TRUE
	ic_name = "a downed vessel"
	no_fake = TRUE

/datum/event/meteor_wave/downed_ship/announce()
	command_announcement.Announce(current_map.ship_meteor_end_message, "Ship Debris Alert", new_sound = 'sound/AI/unknownvesseldowned.ogg')

/datum/event/meteor_wave/downed_ship/start()
	command_announcement.Announce(current_map.ship_meteor_contact_message, "Ship Debris Alert")

/datum/event/meteor_wave/downed_ship/end(var/faked)
	if(faked)
		return
	spawn(100)//We give 10 seconds before announcing, for the last wave of meteors to hit the station
		command_announcement.Announce(current_map.ship_meteor_end_message, "Ship Debris Alert")