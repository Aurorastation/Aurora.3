/datum/ghostspawner/simplemob/phoron_worm
	short_name = "phoron_worm"
	name = "Black Trident Phoron Worm"
	desc = "Search for phoron to eat, reproduce, and keep any pesky outsiders away from your precious food source."
	tags = list("Antagonist")
	spawnpoints = list("phoron_worm")

	observers_only = TRUE

	loc_type = GS_LOC_ATOM
	atom_add_message = "A phoron worm has spawned!"

	spawn_mob = /mob/living/simple_animal/hostile/phoron_worm/playable

/datum/ghostspawner/simplemob/phoron_worm/spawn_mob(mob/user)
	. = ..()

	//Basically, we don't want the mob AI to keep running if a player is assigned to it
	//ideally there should also be an handling to resume thinking if the player ghosts
	//but that would probably need a signal that we don't currently have, hence
	//something for another time
	var/mob/our_new_mob = . //This cast is needed, sorry
	if(istype(our_new_mob) && !QDELETED(our_new_mob))
		MOB_STOP_THINKING(our_new_mob)

/datum/ghostspawner/simplemob/phoron_worm/small
	short_name = "phoron_worm_small"
	name = "Juvenile Black Trident Phoron Worm"
	desc = "Search for phoron to eat, stay close to your mother, and keep any pesky outsiders away from your precious food source."
	tags = list("Antagonist")
	spawnpoints = list("phoron_worm_small")

	observers_only = TRUE

	loc_type = GS_LOC_ATOM
	atom_add_message = "A juvenile phoron worm has been born!"

	spawn_mob = /mob/living/simple_animal/hostile/phoron_worm/small/playable

/datum/ghostspawner/simplemob/phoron_worm/small/spawn_mob(mob/user)
	. = ..()

	//Basically, we don't want the mob AI to keep running if a player is assigned to it
	//ideally there should also be an handling to resume thinking if the player ghosts
	//but that would probably need a signal that we don't currently have, hence
	//something for another time
	var/mob/our_new_mob = . //This cast is needed, sorry
	if(istype(our_new_mob) && !QDELETED(our_new_mob))
		MOB_STOP_THINKING(our_new_mob)
