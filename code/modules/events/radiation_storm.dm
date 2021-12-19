/datum/event/radiation_storm
	var/const/enterBelt		= 45
	var/const/radIntervall 	= 5	// 20 ticks
	var/const/leaveBelt		= 145
	var/const/revokeAccess	= 200
	startWhen				= 2
	announceWhen			= 1
	endWhen					= revokeAccess
	var/postStartTicks 		= 0
	two_part = 1
	ic_name = "radiation"

/datum/event/radiation_storm/announce()
	command_announcement.Announce(current_map.radiation_detected_message, "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg')

/datum/event/radiation_storm/start()
	make_maint_all_access()
	lights(TRUE)

/datum/event/radiation_storm/tick()
	if(activeFor == enterBelt)
		command_announcement.Announce(current_map.radiation_contact_message, "Anomaly Alert")
		radiate()

	if(activeFor >= enterBelt && activeFor <= leaveBelt)
		postStartTicks++

	if(postStartTicks == radIntervall)
		postStartTicks = 0
		radiate()

	else if(activeFor == leaveBelt)
		command_announcement.Announce(current_map.radiation_end_message, "Anomaly Alert")
		lights()

/datum/event/radiation_storm/proc/radiate()
	for(var/mob/living/C in living_mob_list)
		C.apply_radiation_effects()


/datum/event/radiation_storm/end(var/faked)
	if(faked)
		return
	lights()
	revoke_maint_all_access()

/datum/event/radiation_storm/syndicate/radiate()
	return

/datum/event/radiation_storm/proc/lights(var/turnOn = FALSE)
	for(var/area/A in all_areas)
		if(A.flags & RAD_SHIELDED)
			continue
		if(turnOn)
			A.radiation_active = TRUE
		else
			A.radiation_active = null
		A.update_icon()