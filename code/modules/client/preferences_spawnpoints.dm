/datum/spawnpoint
	/// Message to display on the arrivals computer.
	var/msg

	/// List of atoms to spawn on.
	var/list/spawn_locations

	/// Name used in preference setup.
	var/display_name

	/// Only allows people with a job in this list to spawn at this spawnpoint
	var/list/restrict_job = null

	/// Prevents people with a job in this list to spawn at this spawnpoint
	var/list/disallow_job = null

	/// Whether this spawnpoint should be loaded regardless of whether the map has it set as a selectable spawnpoint
	var/always_load = FALSE

	/// Whether people can select this spawnpoint in their character preferences
	var/add_to_preferences = TRUE

/// Handles spawning the mob onto its spawn location, will effectively always just be a forceMove
/datum/spawnpoint/proc/handle_spawn(var/mob/spawning_mob)
	spawning_mob.forceMove(get_turf(pick(spawn_locations)))

/// Checks whether the player's job is within the restricted or disallowed list, returning TRUE if everything's valid
/datum/spawnpoint/proc/check_job_spawning(job)
	if(restrict_job && !(job in restrict_job))
		return FALSE

	if(disallow_job && (job in disallow_job))
		return FALSE

	return TRUE

/// Called after the mob is spawned in
/datum/spawnpoint/proc/after_join(mob/victim)
	return

/datum/spawnpoint/arrivals
	display_name = "Arrivals Shuttle"
	msg = "is inbound from the NTCC Odin"
	disallow_job = list("Merchant")

/datum/spawnpoint/arrivals/New()
	..()
	msg = "is inbound from the [SSatlas.current_map.dock_name]"
	spawn_locations = GLOB.latejoin

/datum/spawnpoint/cryo
	display_name = "Cryogenic Storage"
	msg = "has completed cryogenic revival"
	disallow_job = list("Cyborg", "Merchant")

/datum/spawnpoint/cryo/New()
	..()
	spawn_locations = GLOB.latejoin_cryo

/datum/spawnpoint/cryo/after_join(mob/victim)
	if(!istype(victim))
		return
	var/area/A = get_area(victim)
	for(var/obj/machinery/cryopod/C in A)
		if(!C.occupant)
			C.set_occupant(victim, 1)
			victim.Sleeping(3)
			to_chat(victim, SPAN_NOTICE("You are slowly waking up from the cryostasis aboard [SSatlas.current_map.full_name]. It might take a few seconds."))
			return

/datum/spawnpoint/cyborg
	display_name = "Cyborg Storage"
	msg = "has been activated from storage"
	restrict_job = list("Cyborg")

/datum/spawnpoint/cyborg/New()
	..()
	spawn_locations = GLOB.latejoin_cyborg

/datum/spawnpoint/living_quarters_lift
	display_name = "Living Quarters Lift"
	msg = "is inbound from the living quarters"
	disallow_job = list("Cyborg", "Merchant")

/datum/spawnpoint/living_quarters_lift/New()
	..()
	spawn_locations = GLOB.latejoin_living_quarters_lift

/datum/spawnpoint/living_quarters_lift/after_join(mob/victim)
	if(!istype(victim))
		return
	var/area/A = get_area(victim)
	for(var/obj/machinery/cryopod/living_quarters/C in A)
		if(!C.occupant)
			C.set_occupant(victim, 1)
			to_chat(victim, SPAN_NOTICE("You have arrived from the living quarters aboard the [SSatlas.current_map.full_name]."))
			return

/datum/spawnpoint/intrepid_cryo
	display_name = "Intrepid"
	msg = "has completed cryogenic revival aboard the Intrepid"
	disallow_job = list("Cyborg", "Merchant")
	always_load = TRUE
	add_to_preferences = FALSE

/datum/spawnpoint/intrepid_cryo/New()
	..()
	spawn_locations = GLOB.latejoin_intrepid

/datum/spawnpoint/intrepid_cryo/after_join(mob/victim)
	if(!istype(victim))
		return
	var/area/spawn_area = get_area(victim)
	for(var/obj/machinery/cryopod/C in spawn_area)
		if(!C.occupant)
			C.set_occupant(victim, 1)
			victim.Sleeping(3)
			to_chat(victim, SPAN_NOTICE("You are slowly waking up from the cryostasis aboard the Intrepid. It might take a few seconds."))
			return
