var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	departments = list(DEPARTMENT_COMMAND = JOBROLE_SUPERVISOR)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	intro_prefix = "the"
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#114dc1"
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20

	minimum_character_age = list(
		SPECIES_HUMAN = 35,
		SPECIES_SKRELL = 100,
		SPECIES_SKRELL_AXIORI = 100
	)

	outfit = /obj/outfit/job/captain

	blacklisted_species = list(SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER, SPECIES_DIONA, SPECIES_DIONA_COEUS)

/obj/outfit/job/captain
	name = "Captain"
	jobtype = /datum/job/captain

	uniform = /obj/item/clothing/under/scc_captain
	shoes = /obj/item/clothing/shoes/laceup/brown
	head = /obj/item/clothing/head/caphat/scc
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/card/id/gold

	headset = /obj/item/device/radio/headset/heads/captain
	bowman = /obj/item/device/radio/headset/heads/captain/alt
	double_headset = /obj/item/device/radio/headset/alt/double/captain
	wrist_radio = /obj/item/device/radio/headset/wrist/captain

	tab_pda = /obj/item/modular_computer/handheld/pda/command/captain
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/command/captain
	tablet = /obj/item/modular_computer/handheld/preset/command/captain

	backpack_contents = list(
		/obj/item/storage/box/ids = 1
	)

	implants = list(
		/obj/item/implant/mindshield
	)

	backpack = /obj/item/storage/backpack/captain
	satchel = /obj/item/storage/backpack/satchel/cap
	dufflebag = /obj/item/storage/backpack/duffel/cap
	messengerbag = /obj/item/storage/backpack/messenger/com

/obj/outfit/job/captain/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
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

/datum/job/xo
	title = "Executive Officer"
	flag = XO
	departments = list(DEPARTMENT_SERVICE = JOBROLE_SUPERVISOR, DEPARTMENT_COMMAND)
	department_flag = SERVICE
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	intro_prefix = "the"
	supervisors = "the captain"
	selection_color = "#1e59c9"
	minimal_player_age = 10
	economic_modifier = 10

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 80,
		SPECIES_SKRELL_AXIORI = 80
	)

	outfit = /obj/outfit/job/xo

	access = list(ACCESS_SEC_DOORS, ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_SHIP_WEAPONS, ACCESS_CHANGE_IDS, ACCESS_EVA, ACCESS_HEADS,
					ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION,
					ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_HYDROPONICS,ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_MAILSORTING,
					ACCESS_JANITOR, ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_WEAPONS, ACCESS_JOURNALIST, ACCESS_BRIDGE_CREW, ACCESS_INTREPID, ACCESS_TELEPORTER)

	minimal_access = list(ACCESS_SEC_DOORS, ACCESS_MEDICAL, ACCESS_SHIP_WEAPONS, ACCESS_ENGINE, ACCESS_CHANGE_IDS, ACCESS_EVA, ACCESS_HEADS,
							ACCESS_ALL_PERSONAL_LOCKERS, ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION,
							ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_HYDROPONICS, ACCESS_CHAPEL_OFFICE, ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_MINING, ACCESS_MAILSORTING,
							ACCESS_JANITOR,   ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_WEAPONS, ACCESS_JOURNALIST, ACCESS_BRIDGE_CREW, ACCESS_INTREPID, ACCESS_TELEPORTER)

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/xo
	name = "Executive Officer"
	jobtype = /datum/job/xo

	head = /obj/item/clothing/head/caphat/xo
	uniform = /obj/item/clothing/under/rank/xo
	shoes = /obj/item/clothing/shoes/laceup/brown
	id = /obj/item/card/id/navy

	headset = /obj/item/device/radio/headset/heads/xo
	bowman = /obj/item/device/radio/headset/heads/xo/alt
	double_headset = /obj/item/device/radio/headset/alt/double/xo
	wrist_radio = /obj/item/device/radio/headset/wrist/xo

	tab_pda = /obj/item/modular_computer/handheld/pda/command/xo
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/command/xo
	tablet = /obj/item/modular_computer/handheld/preset/command/xo

	backpack_contents = list(
		/obj/item/storage/box/ids = 1
	)

	messengerbag = /obj/item/storage/backpack/messenger/com

/datum/job/bridge_crew
	title = "Bridge Crew"
	flag = BRIDGE_CREW
	departments = SIMPLEDEPT(DEPARTMENT_COMMAND_SUPPORT)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	intro_prefix = "the"
	supervisors = "the executive officer and the captain"
	selection_color = "#2b5bb5"
	minimal_player_age = 20
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 55,
		SPECIES_SKRELL_AXIORI = 55
	)

	outfit = /obj/outfit/job/bridge_crew

	access = list(ACCESS_EVA, ACCESS_HEADS, ACCESS_MAINT_TUNNELS, ACCESS_WEAPONS, ACCESS_BRIDGE_CREW, ACCESS_INTREPID, ACCESS_TELEPORTER, ACCESS_EXTERNAL_AIRLOCKS)
	minimal_access = list(ACCESS_HEADS, ACCESS_EVA, ACCESS_GATEWAY, ACCESS_WEAPONS, ACCESS_BRIDGE_CREW, ACCESS_INTREPID, ACCESS_TELEPORTER, ACCESS_EXTERNAL_AIRLOCKS)

	blacklisted_species = list(SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/obj/outfit/job/bridge_crew
	name = "Bridge Crew"
	jobtype = /datum/job/bridge_crew

	head = /obj/item/clothing/head/caphat/bridge_crew
	uniform = /obj/item/clothing/under/rank/bridge_crew
	shoes = /obj/item/clothing/shoes/laceup

	headset = /obj/item/device/radio/headset/headset_com
	bowman = /obj/item/device/radio/headset/headset_com/alt
	double_headset = /obj/item/device/radio/headset/alt/double/command
	wrist_radio = /obj/item/device/radio/headset/wrist/command
	messengerbag = /obj/item/storage/backpack/messenger/com
