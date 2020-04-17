/datum/ghostspawner/simplemob/borer
	short_name = "borer"
	name = "Cortical Borer"
	desc = "Infest crew, reproduce, repeat."
	tags = list("Antagonist")

	spawn_mob = /mob/living/simple_animal/borer

/datum/ghostspawner/simplemob/borer/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/simplemob/borer/spawn_mob(mob/user)
	var/mob/living/simple_animal/borer/spawn_borer
	var/list/borer_list = list()

	for(var/mob/living/simple_animal/borer/eligible_borers in SSghostroles.get_spawn_atom("Borers"))
		borer_list += eligible_borers

	if(!length(borer_list))
		to_chat(user, SPAN_DANGER("There are no available borers to spawn at!"))
		return FALSE

	spawn_borer = pick(borer_list)

	if(user && spawn_borer)
		return spawn_borer.spawn_into_borer(user)
	return FALSE