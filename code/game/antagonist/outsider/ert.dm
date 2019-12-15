var/datum/antagonist/ert/ert

/datum/antagonist/ert
	id = MODE_ERT
	bantype = "Emergency Response Team"
	role_text = "Emergency Responder"
	role_text_plural = "Emergency Responders"
	welcome_text = "As a member of your Emergency Response Team, you answer to your leader."
	landmark_id = "Response Team"

	id_type = /obj/item/card/id/ert

	flags = ANTAG_OVERRIDE_JOB | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

/datum/antagonist/ert/create_default(var/mob/source)
	var/rank = null
	if(!leader)
		rank = input(source,"Select your character's rank","Rank selection") as null|anything in list("Leading Trooper (L/Tpr.)","Specialist Trooper (S/Tpr.)","Trooper (Tpr.)")
	else
		rank = input(source,"Select your character's rank","Rank selection") as null|anything in list("Specialist Trooper (S/Tpr.)","Trooper (Tpr.)")

	switch(rank)
		if("Leading Trooper (L/Tpr.)")
			if(!leader)
				rank = "L/Tpr."
				leader = source.mind
			else
				rank = input(source,"Option unavailable, Reselect your character's rank","Rank selection") as null|anything in list("Specialist Trooper (S/Tpr.)","Trooper (Tpr.)")
				switch(rank)
					if("Specialist Trooper (S/Tpr.)")
						rank = "S/Tpr."
					if("Trooper (Tpr.)")
						rank = "Tpr."
		if("Specialist Trooper (S/Tpr.)")
			rank = "S/Tpr."
		if("Trooper (Tpr.)")
			rank = "Tpr."
	if(!rank)
		rank = "Tpr."

	var/newname = sanitize(input(source, "You are a member of ERT Phoenix. Would you like to set a surname or callsign?", "Name change") as null|text, MAX_NAME_LEN)

	if(findtext(newname," "))
		newname = null
		to_chat(source,"<span class='warning'>Invalid name due to included space, picking a random callsign.</span>")
	if(!newname && (callsign.len>= 1))
		newname = "[pick(callsign)]"
		callsign -= newname
	else if(!newname)
		newname = "[capitalize(pick(last_names))]"

	newname = "[rank] [newname]"
	source.real_name = newname
	source.name = source.real_name
	source.mind.name = source.name

	var/mob/living/carbon/human/M = ..()
	if(istype(M))
		M.age = rand(25,45)
		M.dna.real_name = newname

/datum/antagonist/ert/New()
	..()
	ert = src
