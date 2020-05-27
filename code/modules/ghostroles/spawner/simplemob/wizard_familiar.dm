/datum/ghostspawner/simplemob/wizard_familiar
	short_name = "wizard_familiar"
	name = "Wizard Familiar"
	desc = "Be a Familiar, act cute, probably end up killing many people somehow."
	tags = list("Antagonist")

	enabled = FALSE
	spawn_mob = /mob/living/simple_animal

/datum/ghostspawner/simplemob/wizard_familiar/select_spawnpoint(var/use)
	return TRUE //We just fake it here, since the spawnpoint is selected if someone is spawned in.

//The proc to actually spawn in the user
/datum/ghostspawner/simplemob/wizard_familiar/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available wizard familiars to spawn at!"))
		return FALSE

	var/mob/living/simple_animal/spawn_wizard_familiar = pick(spawn_atoms)

	if(user && spawn_wizard_familiar)
		return spawn_wizard_familiar.spawn_into_wizard_familiar(user)
	return FALSE