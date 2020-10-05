/datum/ghostspawner/simplemob/wizard_familiar
	short_name = "wizard_familiar"
	name = "Wizard Familiar"
	desc = "Be a Familiar, act cute, probably end up killing many people somehow."
	tags = list("Antagonist")

	loc_type = GS_LOC_ATOM
	atom_add_message = "A wizard familiar has been summoned"

	spawn_mob = /mob/living/simple_animal


//The proc to actually spawn in the user
/datum/ghostspawner/simplemob/wizard_familiar/spawn_mob(mob/user)
	if(!length(spawn_atoms))
		to_chat(user, SPAN_DANGER("There are no available wizard familiars to spawn at!"))
		return FALSE

	var/mob/living/simple_animal/spawn_wizard_familiar = select_spawnatom()

	if(spawn_wizard_familiar)
		return spawn_wizard_familiar.spawn_into_wizard_familiar(user)
	return FALSE
