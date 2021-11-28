/datum/ghostspawner/shade
	short_name = "shade"
	name = "Cult Shade"
	desc = "Get released to attack crewmembers, get stomped. Get turned into a construct, get stomped, but it'll take longer."
	tags = list("Antagonist")

	jobban_job = "cultist"

	observers_only = TRUE

	loc_type = GS_LOC_ATOM
	atom_add_message = "A cult shade has ghosted!"

	spawn_mob = /mob/living/simple_animal/shade