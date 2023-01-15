/datum/event/meteor_wave
	startWhen		= 86
	endWhen			= 9999//safety value, will be set during ticks
	has_skybox_image = TRUE

	var/next_meteor = 40
	var/waves = 1
	var/start_side
	var/next_meteor_lower = 10
	var/next_meteor_upper = 20

	ic_name = "a meteor storm"

/datum/event/meteor_wave/get_skybox_image()
	var/image/res = overlay_image('icons/skybox/rockbox.dmi', "rockbox", COLOR_ASTEROID_ROCK, RESET_COLOR)
	res.blend_mode = BLEND_OVERLAY
	return res

/datum/event/meteor_wave/setup()
	waves = 0
	for(var/n in 1 to severity)
		waves += rand(5,15)

	start_side = pick(cardinal)
	endWhen = worst_case_end()

/datum/event/meteor_wave/announce()
	for (var/zlevel in affecting_z)
		if(zlevel in current_map.station_levels)
			command_announcement.Announce(current_map.meteors_detected_message, "Meteor Alert", new_sound = 'sound/AI/meteors_detected_message.ogg', zlevels = affecting_z)
			break

/datum/event/meteor_wave/start()
	..()
	for (var/zlevel in affecting_z)
		if(zlevel in current_map.station_levels)
			command_announcement.Announce(current_map.meteor_contact_message, "Meteor Alert", zlevels = affecting_z)
			break

/datum/event/meteor_wave/end(var/faked)
	..()
	if(faked)
		return
	spawn(100)//We give 10 seconds before announcing, for the last wave of meteors to hit the station
		command_announcement.Announce(current_map.meteor_end_message, "Meteor Alert", zlevels = affecting_z)

/datum/event/meteor_wave/tick()

	if(waves && activeFor >= next_meteor)
		send_wave()

/datum/event/meteor_wave/proc/worst_case_end()
	return activeFor + ((30 / severity) * waves) + 30

/datum/event/meteor_wave/proc/send_wave()
	var/pick_side = prob(80) ? start_side : (prob(50) ? turn(start_side, 90) : turn(start_side, -90))
	spawn() spawn_meteors(get_wave_size(), get_meteors(), pick_side, pick(affecting_z))
	next_meteor += rand(next_meteor_lower, next_meteor_upper) / severity
	waves--
	endWhen = worst_case_end()

/datum/event/meteor_wave/proc/get_wave_size()
	return severity * rand(2,4)

/datum/event/meteor_wave/proc/get_meteors()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			return SSatlas.current_sector.meteors_major
		if(EVENT_LEVEL_MODERATE)
			return SSatlas.current_sector.meteors_moderate
		else
			return SSatlas.current_sector.meteors_minor

/datum/event/meteor_wave/downed_ship
	ic_name = "a downed vessel"
	no_fake = TRUE

/datum/event/meteor_wave/downed_ship/get_meteors()
	return SSatlas.current_sector.downed_ship_meteors

/datum/event/meteor_wave/downed_ship/announce()
	for (var/zlevel in affecting_z)
		if(zlevel in current_map.station_levels)
			command_announcement.Announce(current_map.ship_meteor_end_message, "Ship Debris Alert", new_sound = 'sound/AI/meteor_end_message.ogg', zlevels = affecting_z)
			break

/datum/event/meteor_wave/downed_ship/start()
	command_announcement.Announce(current_map.ship_meteor_contact_message, "Ship Debris Alert", new_sound = 'sound/AI/meteor_contact_message.ogg', zlevels = affecting_z)

/datum/event/meteor_wave/downed_ship/end(var/faked)
	if(faked)
		return
	spawn(100)//We give 10 seconds before announcing, for the last wave of meteors to hit the station
		command_announcement.Announce(current_map.ship_meteor_end_message, "Ship Debris Alert", new_sound = 'sound/AI/meteor_end_message.ogg', zlevels = affecting_z)

/datum/event/meteor_wave/overmap
	next_meteor_lower = 5
	next_meteor_upper = 10
	next_meteor = 0

/datum/event/meteor_wave/overmap/announce()
	return

/datum/event/meteor_wave/dust
	ic_name = "a dust belt"

/datum/event/meteor_wave/dust/announce()
	for (var/zlevel in affecting_z)
		if(zlevel in current_map.station_levels)
			command_announcement.Announce(current_map.dust_detected_message, "Dust Belt Alert", new_sound = 'sound/AI/dust_detected_message.ogg', zlevels = affecting_z)
			break

/datum/event/meteor_wave/dust/start()
	command_announcement.Announce(current_map.dust_contact_message, "Dust Belt Alert", new_sound = 'sound/AI/dust_contact_message.ogg', zlevels = affecting_z)

/datum/event/meteor_wave/dust/end(var/faked)
	if(faked)
		return
	spawn(100)//We give 10 seconds before announcing, for the last wave of meteors to hit the station
		command_announcement.Announce(current_map.dust_end_message, "Dust Belt Alert", , new_sound = 'sound/AI/dust_end_message.ogg', zlevels = affecting_z)

/datum/event/meteor_wave/dust/get_meteors()
	return SSatlas.current_sector.meteors_dust

/datum/event/meteor_wave/dust/overmap
	next_meteor_lower = 5
	next_meteor_upper = 10
	next_meteor = 0

/datum/event/meteor_wave/dust/overmap/announce()
	return
