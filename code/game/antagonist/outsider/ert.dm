var/datum/antagonist/ert/ert

/datum/antagonist/ert
	id = MODE_ERT
	bantype = "Emergency Response Team"
	role_text = "Emergency Responder"
	role_text_plural = "Emergency Responders"
	welcome_text = "As a member of your Emergency Response Team, you answer to your leader."
	antag_sound = 'sound/effects/antag_notice/general_goodie_alert.ogg'
	landmark_id = "Response Team"

	id_type = /obj/item/card/id/ert

	flags = ANTAG_OVERRIDE_JOB | ANTAG_RANDOM_EXCEPTED | ANTAG_NO_FLAVORTEXT | ANTAG_NO_ROUNDSTART_SPAWN
	antaghud_indicator = "hudloyalist"

/datum/antagonist/ert/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/ert/New()
	..()
	ert = src
