var/datum/antagonist/deathsquad/deathsquad

/datum/antagonist/deathsquad
	id = MODE_DEATHSQUAD
	role_text = "Asset Protection Specialist"
	role_text_plural = "Asset Protection Specialists"
	welcome_text = "You work in the service of corporate Asset Protection, answering directly to the Board of Directors."
	landmark_id = "Commando"

	id_type = /obj/item/card/id/asset_protection

	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_OVERRIDE_MOB | ANTAG_HAS_NUKE | ANTAG_HAS_LEADER | ANTAG_RANDOM_EXCEPTED | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE
	antaghud_indicator = "huddeathsquad"

	var/deployed = FALSE

/datum/antagonist/ert/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/deathsquad/New(var/no_reference)
	..()
	if(!no_reference)
		deathsquad = src

/datum/antagonist/deathsquad/attempt_spawn()
	if(..())
		deployed = TRUE