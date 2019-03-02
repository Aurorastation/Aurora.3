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
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20
	exclusivity = 10

	ideal_character_age = 70 // Old geezer captains ftw

	outfit = /datum/outfit/job/captain

/datum/outfit/job/captain
	name = "Captain"
	jobtype = /datum/job/captain

	uniform = /obj/item/clothing/under/rank/captain
	shoes = /obj/item/clothing/shoes/brown
	head = /obj/item/clothing/head/caphat
	l_ear = /obj/item/device/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/weapon/card/id/gold
	pda = /obj/item/device/pda/captain
	backpack_contents = list(
		/obj/item/weapon/storage/box/ids = 1
	)

	implants = list(
		/obj/item/weapon/implant/loyalty
	)

	backpack = /obj/item/weapon/storage/backpack/captain
	satchel = /obj/item/weapon/storage/backpack/satchel_cap
	dufflebag = /obj/item/weapon/storage/backpack/duffel/cap
	messengerbag = /obj/item/weapon/storage/backpack/messenger/com

/datum/outfit/job/captain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(H && H.w_uniform)
		var/obj/item/clothing/under/U = H.w_uniform
		var/obj/item/clothing/accessory/medal/gold/captain/medal = new()
		U.attach_accessory(null, medal)

	return TRUE

/datum/job/captain/get_access()
		return get_all_station_access()

/datum/job/captain/announce(mob/living/carbon/human/H)
	. = ..()
	captain_announcement.Announce("All hands, Captain [H.real_name] on deck!")
	callHook("captain_spawned", list(H))

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
	req_admin_notify = 1
	minimal_player_age = 10
	economic_modifier = 10
	ideal_character_age = 50
	exclusivity = 20

	outfit = /datum/outfit/job/hop

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

/datum/outfit/job/hop
	name = "Head of Personnel"
	jobtype = /datum/job/hop

	uniform = /obj/item/clothing/under/rank/head_of_personnel
	shoes = /obj/item/clothing/shoes/brown
	l_ear = /obj/item/device/radio/headset/heads/hop
	id = /obj/item/weapon/card/id/silver
	pda = /obj/item/device/pda/heads/hop
	backpack_contents = list(
		/obj/item/weapon/storage/box/ids = 1
	)

	messengerbag = /obj/item/weapon/storage/backpack/messenger/com