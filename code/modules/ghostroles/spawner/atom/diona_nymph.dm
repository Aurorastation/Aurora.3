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
/datum/ghostspawner/diona_nymph_stowaway
	short_name = "stowaway_nymph"
	name = "Stowaway Diona Nymph"
	desc = "Join as a Diona Nymph that has stowed away on the [station_name(TRUE)]."
	tags = list("Simple Mobs")
	loc_type = GS_LOC_ATOM
	atom_add_message = "A stowaway Diona Nymph has sprung up somewhere on the [station_name(TRUE)]!"
	spawn_mob = /mob/living/carbon/alien/diona/ghost_playable

/datum/ghostspawner/diona_nymph_stowaway/spawn_mob(mob/user)
	. = ..()

	//Basically, we don't want the mob AI to keep running if a player is assigned to it
	//ideally there should also be an handling to resume thinking if the player ghosts
	//but that would probably need a signal that we don't currently have, hence
	//something for another time
	var/mob/our_new_mob = . //This cast is needed, sorry
	if(istype(our_new_mob) && !QDELETED(our_new_mob))
		MOB_STOP_THINKING(our_new_mob)
