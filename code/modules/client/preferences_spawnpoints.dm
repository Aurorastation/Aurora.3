/datum/spawnpoint
	var/msg          //Message to display on the arrivals computer.
	var/list/turfs   //List of turfs to spawn on.
	var/display_name //Name used in preference setup.
	var/list/restrict_job = null
	var/list/disallow_job = null

/datum/spawnpoint/proc/check_job_spawning(job)
	if(restrict_job && !(job in restrict_job))
		return FALSE

	if(disallow_job && (job in disallow_job))
		return FALSE

	return TRUE

/datum/spawnpoint/proc/after_join(mob/victim)
	return

/datum/spawnpoint/arrivals
	display_name = "Arrivals Shuttle"
	msg = "is inbound from the NTCC Odin"
	disallow_job = list("Merchant")

/datum/spawnpoint/arrivals/New()
	..()
	msg = "is inbound from the [current_map.dock_name]"
	turfs = latejoin

/datum/spawnpoint/cryo
	display_name = "Cryogenic Storage"
	msg = "has completed cryogenic revival"
	disallow_job = list("Cyborg", "Merchant")

/datum/spawnpoint/cryo/New()
	..()
	turfs = latejoin_cryo

/datum/spawnpoint/cryo/after_join(mob/victim)
	if(!istype(victim))
		return
	var/area/A = get_area(victim)
	for(var/obj/machinery/cryopod/C in A)
		if(!C.occupant)
			C.set_occupant(victim, 1)
			victim.Sleeping(3)
			to_chat(victim,SPAN_NOTICE("You are slowly waking up from the cryostasis aboard [current_map.full_name]. It might take a few seconds."))
			return

/datum/spawnpoint/cyborg
	display_name = "Cyborg Storage"
	msg = "has been activated from storage"
	restrict_job = list("Cyborg")

/datum/spawnpoint/cyborg/New()
	..()
	turfs = latejoin_cyborg
