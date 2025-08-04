GLOBAL_DATUM(commandos, /datum/antagonist/deathsquad/mercenary)

/datum/antagonist/deathsquad/mercenary
	id = MODE_COMMANDO
	landmark_id = "Syndicate-Commando"
	role_text = "Syndicate Commando"
	role_text_plural = "Commandos"
	welcome_text = "You are in the employ of a criminal syndicate hostile to corporate interests."
	antag_sound = 'sound/effects/antag_notice/deathsquid_alert.ogg'
	id_type = /obj/item/card/id/syndicate/ert
	flags = ANTAG_NO_ROUNDSTART_SPAWN

	faction = "syndicate"

	bantype = "syndicate-commando"

/datum/antagonist/deathsquad/mercenary/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/deathsquad/mercenary/New()
	..()
	GLOB.commandos = src
