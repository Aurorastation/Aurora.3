/datum/ghostspawner/hivebotdestroyer
	short_name = "hivebotdestroyer"
	name = "Hivebot Destroyer"
	desc = "Protect your fellow hivebots from any potential threats."
	tags = list("Antagonist")

	observers_only = TRUE

	loc_type = GS_LOC_ATOM
	atom_add_message = "A hivebot destroyer has spawned!"

	spawn_mob = /mob/living/simple_animal/hostile/hivebot/playable/

/datum/ghostspawner/hivebotdestroyer/spawn_mob(mob/user)
	. = ..()

	//Basically, we don't want the mob AI to keep running if a player is assigned to it
	//ideally there should also be an handling to resume thinking if the player ghosts
	//but that would probably need a signal that we don't currently have, hence
	//something for another time
	var/mob/our_new_mob = . //This cast is needed, sorry
	if(istype(our_new_mob) && !QDELETED(our_new_mob))
		MOB_STOP_THINKING(our_new_mob)

/datum/ghostspawner/hivebotmarksman
	short_name = "hivebotmarksman"
	name = "Hivebot Marksman"
	desc = "Protect your fellow hivebots from any potential threats."
	tags = list("Antagonist")

	observers_only = TRUE

	loc_type = GS_LOC_ATOM
	atom_add_message = "A hivebot marksman has spawned!"

	spawn_mob = /mob/living/simple_animal/hostile/hivebot/playable/ranged

/datum/ghostspawner/hivebotmarksman/spawn_mob(mob/user)
	. = ..()

	//Basically, we don't want the mob AI to keep running if a player is assigned to it
	//ideally there should also be an handling to resume thinking if the player ghosts
	//but that would probably need a signal that we don't currently have, hence
	//something for another time
	var/mob/our_new_mob = . //This cast is needed, sorry
	if(istype(our_new_mob) && !QDELETED(our_new_mob))
		MOB_STOP_THINKING(our_new_mob)

/datum/ghostspawner/hivebotoverseer
	short_name = "hivebotoverseer"
	name = "Hivebot Overseer"
	desc = "Protect your fellow hivebots from any potential threats. Assemble new hivebots as necessary."
	tags = list("Antagonist")

	observers_only = TRUE

	loc_type = GS_LOC_ATOM
	atom_add_message = "A hivebot overseer has spawned!"

	spawn_mob = /mob/living/simple_animal/hostile/hivebot/playable/overseer

/datum/ghostspawner/hivebotoverseer/spawn_mob(mob/user)
	. = ..()

	//Basically, we don't want the mob AI to keep running if a player is assigned to it
	//ideally there should also be an handling to resume thinking if the player ghosts
	//but that would probably need a signal that we don't currently have, hence
	//something for another time
	var/mob/our_new_mob = . //This cast is needed, sorry
	if(istype(our_new_mob) && !QDELETED(our_new_mob))
		MOB_STOP_THINKING(our_new_mob)
