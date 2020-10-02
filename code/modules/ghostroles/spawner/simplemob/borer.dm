/datum/ghostspawner/simplemob/borer
	short_name = "borer"
	name = "Cortical Borer"
	desc = "Infest crew, reproduce, repeat."
	tags = list("Antagonist")

	loc_type = GS_LOC_ATOM

	spawn_mob = /mob/living/simple_animal/borer


//The proc to actually spawn in the user
/datum/ghostspawner/simplemob/borer/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available borers to spawn at!"))
		return FALSE

	var/mob/living/simple_animal/borer/spawn_borer = select_spawnatom()

	if(user && spawn_borer)
		return spawn_borer.spawn_into_borer(user)
	return FALSE
