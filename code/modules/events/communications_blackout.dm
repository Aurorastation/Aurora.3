/datum/event/communications_blackout
	no_fake = 1
	var/damage_machinery = 0

/datum/event/communications_blackout/damage_machinery
	damage_machinery = 1

/datum/event/communications_blackout/announce()
	var/alert = pick(	"Network attack detected. Temporary telecommunication failure imminent. Please contact you*%fj00)`5vc-BZZT", \
						"Network attack detected. Temporary telecommunication failu*3mga;b4;'1v-BZZZT", \
						"Network attack detected. Temporary telec#MCi46:5.;@63-BZZZZT")
	var/found_ai = FALSE
	for(var/mob/living/silicon/ai/A in GLOB.player_list)	//AIs are always aware of communication blackouts.
		found_ai = TRUE
		if(A.z in affecting_z)
			to_chat(A, "<br>")
			to_chat(A, SPAN_WARNING("<b>[alert]</b>"))
			to_chat(A, "<br>")

	// If there's no AI, just make the announcement.
	if(!found_ai)
		command_announcement.Announce(alert, zlevels = affecting_z)
	// If there is an AI, then give them a chance to announce or not announce the blackout.
	else if(prob(30))
		command_announcement.Announce(alert, zlevels = affecting_z)
	return 1

/datum/event/communications_blackout/start()
	..()

	for(var/obj/machinery/telecomms/processor/T in SSmachinery.all_telecomms)
		if(T.z in affecting_z)
			T.ion_storm()
		// 10% chance for a given machine to take damage: slight delays in transmission time or slight message garbling until repaired.
		if(damage_machinery && prob(10))
			T.ion_storm_damage()
