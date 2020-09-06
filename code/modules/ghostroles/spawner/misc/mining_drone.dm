/datum/ghostspawner/mining_drone
	short_name = "mining_drone"
	name = "Mining Drone"
	desc = "Join in as a Mining Drone, assist the miners, get lost on the asteroid and cry synthetic tears."
	tags = list("Stationbound")

	respawn_flag = MINISYNTH //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)
	jobban_job = "Cyborg"

	enabled = FALSE
	spawn_mob = /mob/living/silicon/robot/drone/mining

/datum/ghostspawner/mining_drone/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/mining_drone/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available mining drones to spawn at!"))
		return FALSE

	var/mob/living/silicon/robot/drone/mining/spawn_mining_drone = pick(spawn_atoms)

	if(user && spawn_mining_drone)
		return spawn_mining_drone.spawn_into_mining_drone(user)
	return FALSE