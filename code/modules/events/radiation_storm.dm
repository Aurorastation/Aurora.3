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
	command_announcement.Announce("High levels of radiation detected near the station. Please evacuate into one of the shielded maintenance tunnels.", "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg')

/datum/event/radiation_storm/start()
	make_maint_all_access()

/datum/event/radiation_storm/tick()
	if(activeFor == enterBelt)
		command_announcement.Announce("The station has entered the radiation belt. Please remain in a sheltered area until we have passed the radiation belt.", "Anomaly Alert")
		radiate()

	if(activeFor >= enterBelt && activeFor <= leaveBelt)
		postStartTicks++

	if(postStartTicks == radIntervall)
		postStartTicks = 0
		radiate()

	else if(activeFor == leaveBelt)
		command_announcement.Announce("The station has passed the radiation belt. Please report to medbay if you experience any unusual symptoms. Maintenance will lose all access again shortly.", "Anomaly Alert")

/datum/event/radiation_storm/proc/radiate()
	for(var/mob/living/carbon/C in living_mob_list)
		var/area/A = get_area(C)
		if(!A)
			continue
		if(!(A.z in current_map.station_levels))
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
				to_chat(H, "<span class='notice'>You can feel flow of energy which makes you regenerate.</span>")

			H.apply_effect((rand(15,30)),IRRADIATE,blocked = H.getarmor(null, "rad"))
			if(prob(4))
				H.apply_effect((rand(20,60)),IRRADIATE,blocked = H.getarmor(null, "rad"))
				if (prob(75))
					randmutb(H) // Applies bad mutation
					domutcheck(H,null,MUTCHK_FORCED)
				else
					randmutg(H) // Applies good mutation
					domutcheck(H,null,MUTCHK_FORCED)

/datum/event/radiation_storm/end()
	revoke_maint_all_access()

/datum/event/radiation_storm/syndicate/radiate()
	return
