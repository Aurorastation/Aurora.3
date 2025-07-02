/datum/ghostspawner/diona_nymph/New()
	..()
	short_name = "diona_nymph"
	name = "Diona Nymph"
	desc = "Join in as a Diona Nymph. Suck blood, act cuter than you really are."
	tags = list("Simple Mobs")

	loc_type = GS_LOC_ATOM
	atom_add_message = "A Diona Nymph has sprung up somewhere on the [station_name(TRUE)]!"

	spawn_mob = /mob/living/carbon/alien/diona

//version for the infestation event.
/datum/ghostspawner/diona_nymph_stowaway/New()
	short_name = "stowaway_nymph"
	name = "Stowaway Diona Nymph"
	desc = "Join as a Diona Nymph that has stowed away on the [station_name(TRUE)]."
	tags = list("Simple Mobs")
	loc_type = GS_LOC_ATOM
	atom_add_message = "A stowaway Diona Nymph has sprung up somewhere on the [station_name(TRUE)]!"
	spawn_mob = pick(/mob/living/carbon/alien/diona, /mob/living/carbon/alien/diona/flowery)

/obj/effect/ghostspawpoint/stowaway_nymph
	identifier = "stowaway_nymph"

/obj/effect/ghostspawpoint/stowaway_nymph/Initialize(mapload)
	. = ..()
		SSghostroles.add_spawn_atom("stowaway_nymph", src)
