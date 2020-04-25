/datum/ghostspawner/simplemob/maintdrone
	short_name = "maintdrone"
	name = "Maintenence Drone"
	desc = "Maintain and Improve the Systems on the Aurora"
	show_on_job_select = FALSE
	tags = list("Simple Mobs")

	respawn_flag = MINISYNTH //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)
	jobban_job = "Cyborg"

	//Vars regarding the mob to use
	spawn_mob = /mob/living/simple_animal/rat //The mob that should be spawned

/datum/ghostspawner/simplemob/maintdrone/cant_see()
	if(!config.allow_drone_spawn)
		return "Spawning as drone is disabled"
	return ..()

/datum/ghostspawner/simplemob/maintdrone/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/simplemob/maintdrone/spawn_mob(mob/user)
	var/obj/machinery/drone_fabricator/fabricator
	var/list/all_fabricators = list()
	for(var/obj/machinery/drone_fabricator/DF in SSmachinery.all_machines)
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

	if(user && fabricator && !((fabricator.stat & NOPOWER) || !fabricator.produce_drones || fabricator.drone_progress < 100))
		return fabricator.create_drone(user.client)
	return FALSE