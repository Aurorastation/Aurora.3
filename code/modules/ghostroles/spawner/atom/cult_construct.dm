/datum/ghostspawner/construct
	short_name = "construct"
	name = "Cult Construct"
	desc = "Get ordered around by cultists, end up dying because you get bodyblocked into laser fire."
	tags = list("Antagonist")

	jobban_job = "cultist"

	observers_only = TRUE

	loc_type = GS_LOC_ATOM
	atom_add_message = "A cult construct has ghosted!"

	spawn_mob = /mob/living/simple_animal/construct