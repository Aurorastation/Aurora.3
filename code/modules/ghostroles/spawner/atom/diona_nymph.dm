/datum/ghostspawner/diona_nymph/New()
	..()
	short_name = "diona_nymph"
	name = "Diona Nymph"
	desc = "Join in as a Diona Nymph. Suck blood, act cuter than you really are."
	tags = list("Simple Mobs")

	loc_type = GS_LOC_ATOM
	atom_add_message = "A Diona Nymph has sprung up somewhere on the [station_name(TRUE)]!"

	spawn_mob = /mob/living/carbon/alien/diona
