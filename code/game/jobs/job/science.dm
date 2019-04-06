/datum/job/rd
	title = "Research Director"
	flag = RD
	head_position = 1
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffddff"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	economic_modifier = 15
	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue, access_eva, access_external_airlocks,
			            access_tox_storage, access_teleporter, access_sec_doors, access_medical, access_engine, access_construction,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network, access_maint_tunnels)
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue, access_eva, access_external_airlocks,
			            access_tox_storage, access_teleporter, access_sec_doors, access_medical, access_engine, access_construction,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network, access_maint_tunnels)
	minimal_player_age = 14
	ideal_character_age = 50

	bag_type = /obj/item/weapon/storage/backpack/toxins
	satchel_type = /obj/item/weapon/storage/backpack/satchel_tox
	duffel_type = /obj/item/weapon/storage/backpack/duffel/tox
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/tox

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/rd(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/research_director(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/rd(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/weapon/clipboard(H), slot_l_hand)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
		return TRUE



/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#ffeeff"
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)
	alt_titles = list("Xenoarcheologist", "Anomalist", "Phoron Researcher")

	minimal_player_age = 14

	bag_type = /obj/item/weapon/storage/backpack/toxins
	satchel_type = /obj/item/weapon/storage/backpack/satchel_tox
	duffel_type = /obj/item/weapon/storage/backpack/duffel/tox
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/tox

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/science(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/science(H), slot_wear_suit)
		return TRUE

/datum/job/xenobiologist
	title = "Xenobiologist"
	flag = XENOBIOLOGIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the research director"
	selection_color = "#ffeeff"
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_hydroponics)
	minimal_access = list(access_research, access_xenobiology, access_hydroponics, access_tox_storage)
	alt_titles = list("Xenobotanist")

	minimal_player_age = 14

	bag_type = /obj/item/weapon/storage/backpack/toxins
	satchel_type = /obj/item/weapon/storage/backpack/satchel_tox
	duffel_type = /obj/item/weapon/storage/backpack/duffel/tox
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/tox

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/scientist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/white(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/science(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat/science(H), slot_wear_suit)

		return TRUE

/datum/job/roboticist
	title = "Roboticist"
	flag = ROBOTICIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "research director"
	selection_color = "#ffeeff"
	economic_modifier = 5
	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	alt_titles = list("Biomechanical Engineer","Mechatronic Engineer")

	minimal_player_age = 7

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sci(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/roboticist(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/roboticist(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/labcoat(H), slot_wear_suit)
		return TRUE