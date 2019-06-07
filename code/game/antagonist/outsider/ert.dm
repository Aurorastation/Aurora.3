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

	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	var/list/callsign = list(
		"Ace","Angel","Ant","Apollo","Arctic","Ash","Badger","Bandit",
		"Baron","Beetle","Beta","Bishop","Black","Blaze","Blue","Bull",
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
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

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

/datum/antagonist/ert/set_antag_name(var/mob/living/carbon/human/player)

	var/rank = null

	if(!leader)
		rank = input(player,"Select your character's rank","Rank selection") as null|anything in list("Leading Trooper (L/Tpr)","Specialist Trooper (S/Tpr)","Trooper (Tpr)")
	else
		rank = input(player,"Select your character's rank","Rank selection") as null|anything in list("Specialist Trooper (S/Tpr)","Trooper (Tpr)")

	switch(rank)
		if("Leading Trooper (L/Tpr)")
			if(!leader)
				player.mind.special_role = "L/Tpr"
				leader = player.mind
			else
				rank = input(player,"Option unavailable, Reselect your character's rank","Rank selection") as null|anything in list("Specialist Trooper (S/Tpr)","Trooper (Tpr)")
				switch(rank)
					if("Specialist Trooper (S/Tpr)")
						player.mind.special_role = "S/Tpr"
					if("Trooper (Tpr)")
						player.mind.special_role = "Tpr"
		if("Specialist Trooper (S/Tpr)")
			player.mind.special_role = "S/Tpr."
		if("Trooper (Tpr)")
			player.mind.special_role = "Tpr"
	if(!rank)
		player.mind.special_role = "Tpr"

	var/newname = sanitize(input(player, "You are a member of ERT Phoenix with the rank of [rank]. Would you like to set a surname or callsign?", "Name change") as null|text, MAX_NAME_LEN)

	if(findtext(newname," "))
		newname = null
	if(!newname && (callsign.len>= 1))
		newname = "[pick(callsign)]"
		callsign -= newname
	else if(!newname)
		newname = "[capitalize(pick(last_names))]"

	newname = "[player.mind.special_role] [newname]"
	player.real_name = newname
	player.name = player.real_name
	player.dna.real_name = newname
	if(player.mind) player.mind.name = player.name

	create_id(role_text, player)
	update_access(player)

/datum/antagonist/ert/equip(var/mob/living/carbon/human/player)

	//Special radio setup
	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/ert(src), slot_l_ear)
	player.equip_to_slot_or_del(new /obj/item/clothing/under/ert(src), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat/ert(src), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(src), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(src), slot_glasses)

	create_id(role_text, player)
	return 1
