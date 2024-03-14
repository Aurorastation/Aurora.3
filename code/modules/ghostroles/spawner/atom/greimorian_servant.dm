/datum/ghostspawner/servant
	short_name = "servant"
	name = "Greimorian Servant"
	desc = "Protect the queen with your life, and make sure she has all of the food she needs to grow the infestation. Help grow the infestation yourself."
	tags = list("Antagonist")

	observers_only = TRUE

	loc_type = GS_LOC_ATOM
	atom_add_message = "A Greimorian queen has birthed a Greimorian servant!"

	spawn_mob = /mob/living/simple_animal/hostile/giant_spider/nurse/servant

/datum/ghostspawner/servant/spawn_mob(mob/user)
	. = ..()

	//Basically, we don't want the mob AI to keep running if a player is assigned to it
	//ideally there should also be an handling to resume thinking if the player ghosts
	//but that would probably need a signal that we don't currently have, hence
	//something for another time
	var/mob/our_new_mob = . //This cast is needed, sorry
	if(istype(our_new_mob) && !QDELETED(our_new_mob))
		MOB_STOP_THINKING(our_new_mob)
