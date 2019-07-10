var/datum/antagonist/legion/legion

/datum/antagonist/legion
	id = MODE_LEGION
	bantype = "Tau Ceti Foreign Legion"
	role_text = "Tau Ceti Foreign Legion Volunteer"
	role_text_plural = "Tau Ceti Foreign Legion Volunteers"
	welcome_text = "As member of the Tau Ceti Foreign Legion, you answer to your leader and NanoTrasen officials."
	leader_welcome_text = "As leader of the Tau Ceti Foreign Legion Team, you answer only to the Tau Ceti goverment and NanoTrasen officials. It is recommended that you attempt to cooperate with the captain and the crew when possible."
	landmark_id = "Tau Ceti Legion"

	id_type = /obj/item/weapon/card/id/legion

	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	var/list/callsign = list(
		"Ace","Angel","Ant","Apollo","Arctic","Ash","Badger","Bandit",
		"Baron","Beetle","Beta","Bishop","Black","Blaze","Blue","Bull",
		"Carp","Chrome","Cobra","Crimson","Crypt","Delta","Duke","Eagle",
		"Earl","Epsilon","Hammer","Fallen","Fang","Fido","Firefly","Flame",
		"Foggy","Fox","Galaxy","Gamma","Grave","Jade","Jester","Judge",
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

/datum/antagonist/legion/create_default(var/mob/source)
	var/rank = null
	if(!leader)
		rank = input(source,"Select your character's rank","Rank selection") as null|anything in list("Prefect (Pfct.)","Legionnaire (Lgn.)","Volunteer (Vol.)")
	else
		rank = input(source,"Select your character's rank","Rank selection") as null|anything in list("Legionnaire (Lgn.)","Volunteer (Vol.)")

	switch(rank)
		if("Prefect (Pfct.)")
			if(!leader)
				source.mind.special_role = "Pfct."
				leader = source.mind
			else
				rank = input(source,"Option unavailable, Reselect your character's rank","Rank selection") as null|anything in list("Legionnaire (Lgn.)","Volunteer (Vol.)")
				switch(rank)
					if("Legionnaire (Lgn.)")
						source.mind.special_role = "Lgn."
					if("Volunteer (Vol.)")
						source.mind.special_role = "Vol."
		if("Legionnaire (Lgn.)")
			source.mind.special_role = "Lgn."
		if("Volunteer (Vol.)")
			source.mind.special_role = "Vol."
	if(!rank)
		source.mind.special_role = "Vol."

	var/newname = sanitize(input(source, "You are a member of the TCFL - Taskforce XIII with the rank of [rank]. Would you like to set a surname or callsign?", "Name change") as null|text, MAX_NAME_LEN)

	if(findtext(newname," "))
		newname = null
	if(!newname && (callsign.len>= 1))
		newname = "[pick(callsign)]"
		callsign -= newname
	else if(!newname)
		newname = "[capitalize(pick(last_names))]"

	newname = "[source.mind.special_role] [newname]"
	source.real_name = newname
	source.name = source.real_name
	source.mind.name = source.name
	var/special_r = source.mind.special_role

	var/mob/living/carbon/human/M = ..()
	if(istype(M))
		M.age = rand(25,45)
		M.dna.real_name = newname
		M.mind.special_role = special_r
	if(M.mind.special_role == "Pfct.")
		var/obj/item/weapon/card/id/legion/I = M.wear_id
		I.access += (access_cent_specops)

/datum/antagonist/legion/New()
	..()
	legion = src

/datum/antagonist/legion/greet(var/datum/mind/player)
	if(!..())
		return
	to_chat(player.current,  "The Tau Ceti Foreign Legion works for the Republic of Biesel; your job is to protect [current_map.company_name]. There is a code red alert on [station_name()], you are tasked to go and fix the problem.")
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")

/datum/antagonist/legion/update_leader()
	return

/datum/antagonist/legion/equip(var/mob/living/carbon/human/player)

	var/datum/outfit/O = /datum/outfit/admin/tcfl
	if(O)
		player.preEquipOutfit(O,FALSE)
		player.equipOutfit(O,FALSE)


//	player.equip_to_slot_or_del(new /obj/item/device/radio/headset/legion(src), slot_l_ear)
//	player.equip_to_slot_or_del(new /obj/item/clothing/under/legion(src), slot_w_uniform)
//	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(src), slot_shoes)
//	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/swat/tactical(src), slot_gloves)
//	player.equip_to_slot_or_del(new /obj/item/clothing/head/legion_beret/field(src), slot_head)
//	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/aviator(src), slot_glasses)
//	player.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/legion(src), slot_back)
//	player.equip_to_slot_or_del(new /obj/item/weapon/storage/box/engineer(player.back), slot_in_backpack)

	return 1
