/datum/ghostspawner/techno_apprentice
	short_name = "technoapprentice"
	name = "Technomancer Apprentice"
	desc = "Serve your Master. Cast Spells."
	tags = list("Antagonist")

	loc_type = GS_LOC_ATOM
	atom_add_message = "A technomancer master has requested an apprentice!"

	spawn_mob = /mob/living/carbon/human

/datum/ghostspawner/techno_golem
	short_name = "technogolem"
	name = "Technomancer Golem"
	desc = "Serve your Master. Cast Spells."
	tags = list("Antagonist")

	loc_type = GS_LOC_ATOM
	atom_add_message = "A technomancer master has requested a loyal golem!"

	spawn_mob = /mob/living/carbon/human/technomancer_golem