var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	department = "Command"
	head_position = 1
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#ccccff"
	idtype = /obj/item/weapon/card/id/gold
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20

	ideal_character_age = 70 // Old geezer captains ftw

	bag_type = /obj/item/weapon/storage/backpack/captain
	satchel_type = /obj/item/weapon/storage/backpack/satchel_cap
	alt_satchel_type = /obj/item/weapon/storage/backpack/satchel
	duffel_type = /obj/item/weapon/storage/backpack/duffel/cap
	messenger_bag_type = /obj/item/weapon/storage/backpack/messenger/com

	equip(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/captain(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/captain(H), slot_w_uniform)
		if(H.age>49)
			// Since we can have something other than the default uniform at this
			// point, check if we can actually attach the medal
			var/obj/item/clothing/uniform = H.w_uniform
			var/obj/item/clothing/accessory/medal/gold/captain/medal = new()
			if(uniform && uniform.can_attach_accessory(medal))
				uniform.attach_accessory(null, medal)
			else
				qdel(medal)
		H.equip_to_slot_or_del(new /obj/item/device/pda/captain(H), slot_belt)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/caphat(H), slot_head)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(H), slot_glasses)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H), slot_l_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H.back), slot_in_backpack)


		H.implant_loyalty(H)

		return TRUE

	get_access()
		return get_all_station_access()

/datum/job/hop
	title = "Head of Personnel"
	flag = HOP
	department = "Civilian"
	head_position = 1
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ddddff"
	idtype = /obj/item/weapon/card/id/silver
	req_admin_notify = 1
	minimal_player_age = 10
	economic_modifier = 10
	ideal_character_age = 50

	access = list(access_sec_doors, access_medical, access_engine, access_change_ids, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics,
			            access_chapel_office, access_library, access_research, access_mining, access_mining_station, access_janitor,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway, access_weapons, access_journalist)
	minimal_access = list(access_sec_doors, access_medical, access_engine, access_change_ids, access_eva, access_heads,
			            access_all_personal_lockers, access_maint_tunnels, access_bar, access_janitor, access_construction,
			            access_crematorium, access_kitchen, access_cargo, access_cargo_bot, access_mailsorting, access_qm, access_hydroponics,
			            access_chapel_office, access_library, access_research, access_mining, access_mining_station, access_janitor,
			            access_hop, access_RC_announce, access_keycard_auth, access_gateway, access_weapons, access_journalist)


	equip(var/mob/living/carbon/human/H)
		if(!H)
			return FALSE
		H.equip_to_slot_or_del(new /obj/item/device/radio/headset/heads/hop(H), slot_l_ear)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/head_of_personnel(H), slot_w_uniform)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/device/pda/heads/hop(H), slot_belt)
		if(H.backbag == 1)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H), slot_l_hand)
		else
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/ids(H.back), slot_in_backpack)
		return TRUE
