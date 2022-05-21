/datum/ghostspawner/simplemob/maintdrone
	short_name = "maintdrone"
	name = "Maintenance Drone"
	desc = "Maintain and improve systems"
	show_on_job_select = FALSE
	tags = list("Simple Mobs")

	respawn_flag = MINISYNTH //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)
	jobban_job = "Cyborg"

	//Vars regarding the mob to use
	spawn_mob = /mob/living/silicon/robot/drone //The mob that should be spawned

/datum/ghostspawner/simplemob/maintdrone/New()
	. = ..()
	if(current_map.station_name)
		desc = "[desc] on the [current_map.station_name]."
	else
		desc = "[desc]."

// we fake it here to ensure it pops up and gets added to SSghostroles.spawners, handling of the fabricators is done below
/datum/ghostspawner/simplemob/maintdrone/select_spawnlocation()
	return TRUE

/datum/ghostspawner/simplemob/maintdrone/cant_spawn()
	if(!config.allow_drone_spawn)
		return "Spawning as drone is disabled"
	if(count_drones() >= config.max_maint_drones)
		return "The maximum number of active drones has been reached"
	var/has_active_fabricator = FALSE
	for(var/obj/machinery/drone_fabricator/DF in SSmachinery.machinery)
		if((DF.stat & NOPOWER) || !DF.produce_drones || DF.drone_progress < 100)
			continue
		has_active_fabricator = TRUE
	if(!has_active_fabricator)
		return "There are no active fabricators to spawn at"
	return ..()

//The proc to actually spawn in the user
/datum/ghostspawner/simplemob/maintdrone/spawn_mob(mob/user)
	var/obj/machinery/drone_fabricator/fabricator
	var/list/all_fabricators = list()
	for(var/obj/machinery/drone_fabricator/DF in SSmachinery.machinery)
		if((DF.stat & NOPOWER) || !DF.produce_drones || DF.drone_progress < 100)
			continue
		all_fabricators[DF.fabricator_tag] = DF

	if(!all_fabricators.len)
		to_chat(user, "<span class='danger'>There are no available drone spawn points, sorry.</span>")
		return FALSE

	var/choice = input(user, "Which fabricator do you wish to use?") as null|anything in all_fabricators
	if(!choice || !all_fabricators[choice])
		return FALSE
	fabricator = all_fabricators[choice]

	if(!fabricator_check(fabricator, user))
		return FALSE

	var/drone_tag = sanitizeSafe(input(user, "Select a tag for your maintenance drone, for example, 'MT' would appear as 'maintenance drone (MT-[rand(100,999)])'. (Max length: 3 Characters)", "Name Tag Selection"), 4)
	if(!drone_tag)
		drone_tag = "MT"
	drone_tag = uppertext(drone_tag)

	if(!fabricator_check(fabricator, user))
		return FALSE

	return fabricator.create_drone(user.client, drone_tag)

/datum/ghostspawner/simplemob/maintdrone/proc/fabricator_check(var/obj/machinery/drone_fabricator/fabricator, var/mob/user)
	if(!fabricator)
		to_chat(user, SPAN_WARNING("Something has gone wrong and the fabricator couldn't be found! Make a github issue about this."))
		return FALSE

	if(!fabricator.produce_drones)
		to_chat(user, SPAN_WARNING("The fabricator's drone production has been disabled, try again."))
		return FALSE

	if(fabricator.stat & NOPOWER)
		to_chat(user, SPAN_WARNING("The fabricator has lost power, try again."))
		return FALSE

	if(fabricator.drone_progress < 100)
		to_chat(user, SPAN_WARNING("The fabricator isn't ready to produce another drone, try again."))
		return FALSE

	return TRUE
