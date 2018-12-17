var/datum/antagonist/proy/proy

/datum/antagonist/proy
	id = MODE_PROY
	bantype = "Proy Warrior"
	role_text = "Proy"
	role_text_plural = "Procyoni"
	welcome_text = "As Procyoni, you answer to Taug only"
	landmark_id = "Procyoni Tribal"
	


	flags = ANTAG_OVERRIDE_JOB | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED

	hard_cap = 4
	hard_cap_round = 5
	initial_spawn_req = 5
	initial_spawn_target = 7

/datum/antagonist/proy/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/proy/New(var/mob/living/carbon/human/user)
	..()
	proy = src


/datum/antagonist/proy/equip(var/mob/living/carbon/human/player)
	player.set_species("Praydau")
