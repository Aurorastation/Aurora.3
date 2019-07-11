var/datum/antagonist/ert/ert

/datum/antagonist/ert
	id = MODE_ERT
	bantype = "Emergency Response Team"
	role_text = "Emergency Responder"
	role_text_plural = "Emergency Responders"
	welcome_text = "As member of the Emergency Response Team, you answer only to your leader and CentComm officials."
	leader_welcome_text = "As leader of the Emergency Response Team, you answer only to CentComm, and have authority to override the Captain where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the captain where possible, however."
	landmark_id = "Response Team"

	id_type = /obj/item/weapon/card/id/ert

	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	var/list/callsign = list(
		"Ace","Angel","Ant","Apollo","Arctic","Ash","Badger","Bandit",
		"Baron","Beetle","Bishop","Black","Blaze","Blue","Bull",
		"Carp","Chrome","Cobra","Crimson","Crypt","Delta","Duke","Eagle",
		"Earl","Epsilon","Hammer","Fallen","Fang","Fido","Firefly","Flame",
		"Foggy","Fox","Galaxy","Gamma","Ghost","Grave","Jade","Jester","Judge",
		"Justice","Kaiser","Kappa","King","Knight","Lambda","Lemur","Lion",
		"Mace","Maverick","Midas","Noble","Nomad","Oath","Preacher","Prince",
		"Princess","Red","Rex","Rook","Shephard","Shield","Sigma","Smoke",
		"Star","Steel","Storm","Valor","Viper","Void","Voodoo","Wing",
		"Wolf","Zeta"
	)

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7

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

/datum/antagonist/ert/greet(var/datum/mind/player)
	if(!..())
		return
	to_chat(player.current, "The Emergency Response Team works for Asset Protection; your job is to protect [current_map.company_name]'s assets. There is a code red alert on [station_name()], you are tasked to go and fix the problem.")
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")

/datum/antagonist/ert/update_leader()
	return

/datum/antagonist/ert/equip(var/mob/living/carbon/human/player)

	var/datum/outfit/O = /datum/outfit/admin/nt/ert
	if(O)
		player.preEquipOutfit(O,FALSE)
		player.equipOutfit(O,FALSE)

	return 1
