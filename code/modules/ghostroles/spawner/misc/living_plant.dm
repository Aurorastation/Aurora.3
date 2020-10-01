/datum/ghostspawner/living_plant
	short_name = "living_plant"
	name = "Living Plant"
	desc = "Inhabit a sentient plant! How quaint."
	tags = list("Simple Mob")

	enabled = FALSE
	show_on_job_select = FALSE

	spawn_mob = /mob/living

/datum/ghostspawner/living_plant/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/living_plant/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available friends to spawn at!"))
		return FALSE

	var/mob/living/spawn_living_plant = pick(spawn_atoms)

	if(user && spawn_living_plant)
		return spawn_living_plant.spawn_into_living(user, short_name)
	return FALSE