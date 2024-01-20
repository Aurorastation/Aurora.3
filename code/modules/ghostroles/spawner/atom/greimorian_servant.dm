/datum/ghostspawner/servant
	short_name = "servant"
	name = "Greimorian Servant"
	desc = "Protect the queen with your life, and make sure she has all of the food she needs to grow the infestation. Help grow the infestation yourself."
	tags = list("Antagonist")

	observers_only = TRUE

	loc_type = GS_LOC_ATOM
	atom_add_message = "A Greimorian queen has birthed a Greimorian servant!"

	spawn_mob = /mob/living/simple_animal/hostile/giant_spider/nurse/servant
