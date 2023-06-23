/datum/event/radiation_storm
	var/const/enterBelt		= 45
	var/const/radIntervall 	= 5	// 20 ticks
	var/const/leaveBelt		= 145
	var/const/revokeAccess	= 200
	has_skybox_image = TRUE
	startWhen				= 2
	announceWhen			= 1
	endWhen					= revokeAccess
	var/postStartTicks 		= 0
	two_part = 1
	ic_name = "radiation"

/datum/event/radiation_storm/get_skybox_image()
	if(prob(75)) // Sometimes, give no skybox image, to avoid metagaming it
		var/image/res = overlay_image('icons/skybox/radbox.dmi', "beam", null, RESET_COLOR)
		res.alpha = rand(40,80)
		return res

/datum/event/radiation_storm/announce()
	command_announcement.Announce(current_map.radiation_detected_message, "Radiation Sensor Array Automated Alert", new_sound = 'sound/AI/radiation_detected_message.ogg', zlevels = affecting_z)

/datum/event/radiation_storm/start()
	..()
	make_maint_all_access()
	lights(TRUE)

/datum/event/radiation_storm/tick()
	if(activeFor == enterBelt)
		command_announcement.Announce(current_map.radiation_contact_message, "Radiation Sensor Array Automated Alert", new_sound = 'sound/AI/radiation_contact_message.ogg', zlevels = affecting_z)
		radiate()

	if(activeFor >= enterBelt && activeFor <= leaveBelt)
		postStartTicks++

	if(postStartTicks == radIntervall)
		postStartTicks = 0
		radiate()

	else if(activeFor == leaveBelt)
		command_announcement.Announce(current_map.radiation_end_message, "Radiation Sensor Array Automated Alert", new_sound = 'sound/AI/radiation_end_message.ogg', zlevels = affecting_z)
		lights()

/datum/event/radiation_storm/proc/radiate()
	var/radiation_level = rand(15, 30)
	for(var/z in affecting_z)
		SSradiation.z_radiate(locate(1, 1, z), radiation_level, 1)
		
	for(var/mob/living/C in living_mob_list)
		var/area/A = get_area(C)
		if(!A)
			continue
		if(isNotStationLevel(A.z))
			continue
		if(A.flags & RAD_SHIELDED)
			continue
		if(istype(C,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = C
			
			if(H.is_diona())
				var/damage = rand(15, 30)
				H.adjustToxLoss(-damage)
				if(prob(5))
					damage = rand(20, 60)
					H.adjustToxLoss(-damage)
				to_chat(H, SPAN_NOTICE("You can feel flow of energy which makes you regenerate."))
			
			if(prob(5 * (1 - H.get_blocked_ratio(null, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED, armor_pen = radiation_level))))
				if (prob(75))
					randmutb(H) // Applies bad mutation
					domutcheck(H,null,MUTCHK_FORCED)
				else
					randmutg(H) // Applies good mutation
					domutcheck(H,null,MUTCHK_FORCED)

/datum/event/radiation_storm/end(var/faked)
	..()
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