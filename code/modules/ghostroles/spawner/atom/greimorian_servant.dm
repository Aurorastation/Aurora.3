/datum/ghostspawner/servant
	short_name = "servant"
	name = "Greimorian Servant"
	desc = "Infest crew, reproduce, repeat."
	tags = list("Antagonist")

	observers_only = TRUE

	loc_type = GS_LOC_ATOM
	atom_add_message = "A servant has been birthed!"

	spawn_mob = /mob/living/simple_animal/hostile/giant_spider/nurse/servant
