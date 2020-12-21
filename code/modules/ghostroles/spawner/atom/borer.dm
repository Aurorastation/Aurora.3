/datum/ghostspawner/borer
	short_name = "borer"
	name = "Cortical Borer"
	desc = "Infest crew, reproduce, repeat."
	tags = list("Antagonist")

	antagonist = TRUE

	loc_type = GS_LOC_ATOM
	atom_add_message = "A borer has been birthed!"

	spawn_mob = /mob/living/simple_animal/borer
