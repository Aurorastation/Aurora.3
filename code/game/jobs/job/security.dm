/datum/job/hos
	title = "Head of Security"
	flag = HOS
	departments = list(DEPARTMENT_SECURITY = JOBROLE_SUPERVISOR, DEPARTMENT_COMMAND)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	intro_prefix = "the"
	supervisors = "the captain"
	selection_color = "#991818"
	economic_modifier = 10

	minimum_character_age = list(
		SPECIES_HUMAN = 30,
		SPECIES_SKRELL = 80,
		SPECIES_SKRELL_AXIORI = 80
	)

	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
					access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
					access_research, access_engine, access_ship_weapons, access_mining, access_medical, access_construction, access_mailsorting,
					access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks,
					access_weapons, access_intrepid, access_teleporter)

	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
							access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
							access_research, access_engine, access_ship_weapons, access_mining, access_medical, access_construction, access_mailsorting,
							access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks,
							access_weapons, access_intrepid, access_teleporter)

	minimal_player_age = 14
	outfit = /datum/outfit/job/hos

	blacklisted_species = list(SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA_ZHAN, SPECIES_DIONA, SPECIES_DIONA_COEUS, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/hos
	name = "Head of Security"
	jobtype = /datum/job/hos

	uniform = /obj/item/clothing/under/rank/head_of_security
	head = /obj/item/clothing/head/hos
	id = /obj/item/card/id/navy
	shoes = null
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/head

	headset = /obj/item/device/radio/headset/heads/hos
	bowman = /obj/item/device/radio/headset/heads/hos/alt
	double_headset = /obj/item/device/radio/headset/alt/double/hos
	wrist_radio = /obj/item/device/radio/headset/wrist/hos

	tab_pda = /obj/item/modular_computer/handheld/pda/security/hos
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/security/hos
	tablet = /obj/item/modular_computer/handheld/preset/security/hos

	implants = list(
		/obj/item/implant/mindshield
	)

	backpack = /obj/item/storage/backpack/hos
	satchel = /obj/item/storage/backpack/satchel/hos
	dufflebag = /obj/item/storage/backpack/duffel/hos
	messengerbag = /obj/item/storage/backpack/messenger/hos

/datum/outfit/job/hos/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/toeless(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/toeless(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather/unathi(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather(H), slot_gloves)

/datum/job/warden
	title = "Warden"
	flag = WARDEN
	departments = SIMPLEDEPT(DEPARTMENT_SECURITY)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#991818"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue, access_external_airlocks, access_weapons)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_external_airlocks, access_weapons)
	minimal_player_age = 7
	outfit = /datum/outfit/job/warden

	blacklisted_species = list(SPECIES_IPC_ZENGHU, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_XION_REMOTE, SPECIES_VAURCA_BULWARK, SPECIES_DIONA_COEUS, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/warden
	name = "Warden"
	jobtype = /datum/job/warden

	uniform = /obj/item/clothing/under/rank/warden
	suit = /obj/item/clothing/suit/storage/toggle/warden
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/aviator
	shoes = null

	headset = /obj/item/device/radio/headset/headset_warden
	bowman = /obj/item/device/radio/headset/headset_warden/alt
	double_headset = /obj/item/device/radio/headset/alt/double/sec/warden
	wrist_radio = /obj/item/device/radio/headset/wrist/sec/warden

	tab_pda = /obj/item/modular_computer/handheld/pda/security
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/security
	tablet = /obj/item/modular_computer/handheld/preset/security

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	dufflebag = /obj/item/storage/backpack/duffel/sec
	messengerbag = /obj/item/storage/backpack/messenger/sec

/datum/outfit/job/warden/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/toeless(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/toeless(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather/unathi(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather(H), slot_gloves)

/datum/job/investigator
	title = "Investigator"
	flag = FORENSICS
	departments = SIMPLEDEPT(DEPARTMENT_SECURITY)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of security"
	selection_color = "#991818"
	economic_modifier = 5

	minimum_character_age = list(
		SPECIES_HUMAN = 25,
		SPECIES_SKRELL = 60,
		SPECIES_SKRELL_AXIORI = 60
	)

	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_weapons)
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_weapons)
	minimal_player_age = 3
	outfit = /datum/outfit/job/forensics
	blacklisted_species = list(SPECIES_IPC_ZENGHU, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_XION_REMOTE, SPECIES_VAURCA_BULWARK, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/forensics
	name = "Investigator"
	jobtype = /datum/job/investigator

	uniform = /obj/item/clothing/under/det
	shoes = /obj/item/clothing/shoes/laceup

	headset = /obj/item/device/radio/headset/headset_sec
	bowman = /obj/item/device/radio/headset/headset_sec/alt
	double_headset = /obj/item/device/radio/headset/alt/double/sec
	wrist_radio = /obj/item/device/radio/headset/wrist/sec

	tab_pda = /obj/item/modular_computer/handheld/pda/security/detective
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/security/detective
	tablet = /obj/item/modular_computer/handheld/preset/security/detective

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	dufflebag = /obj/item/storage/backpack/duffel/sec
	messengerbag = /obj/item/storage/backpack/messenger/sec

	backpack_contents = list(
		/obj/item/storage/box/evidence = 1
	)

/datum/outfit/job/forensics/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.equip_or_collect(new /obj/item/clothing/gloves/black/forensic(H), slot_gloves)

/datum/job/officer
	title = "Security Officer"
	flag = OFFICER
	departments = SIMPLEDEPT(DEPARTMENT_SECURITY)
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the head of security"
	selection_color = "#991818"
	economic_modifier = 4

	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks, access_weapons)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_external_airlocks, access_weapons)
	minimal_player_age = 7
	outfit = /datum/outfit/job/officer

	blacklisted_species = list(SPECIES_IPC_ZENGHU, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_XION_REMOTE, SPECIES_VAURCA_BULWARK, SPECIES_DIONA_COEUS, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/officer
	name = "Security Officer"
	jobtype = /datum/job/officer

	uniform = /obj/item/clothing/under/rank/security
	shoes = null

	headset = /obj/item/device/radio/headset/headset_sec
	bowman = /obj/item/device/radio/headset/headset_sec/alt
	double_headset = /obj/item/device/radio/headset/alt/double/sec
	wrist_radio = /obj/item/device/radio/headset/wrist/sec

	tab_pda = /obj/item/modular_computer/handheld/pda/security
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/security
	tablet = /obj/item/modular_computer/handheld/preset/security

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	dufflebag = /obj/item/storage/backpack/duffel/sec
	messengerbag = /obj/item/storage/backpack/messenger/sec

/datum/outfit/job/officer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/toeless(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/toeless(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather/unathi(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather(H), slot_gloves)

/datum/job/intern_sec
	title = "Security Cadet"
	flag = INTERN_SEC
	departments = SIMPLEDEPT(DEPARTMENT_SECURITY)
	department_flag = ENGSEC
	faction = "Station"
	alt_titles = list("Investigator Intern", "Warden Cadet")
	alt_outfits = list("Investigator Intern" = /datum/outfit/job/intern_sec/forensics)
	alt_ages = list("Investigator Intern" = list(
		SPECIES_HUMAN = 24,
		SPECIES_SKRELL = 58,
		SPECIES_SKRELL_AXIORI = 58
	),
	"Warden Cadet" = list(
		SPECIES_HUMAN = 24,
		SPECIES_SKRELL = 58,
		SPECIES_SKRELL_AXIORI = 58
	))
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Head of Security"
	selection_color = "#991818"
	access = list(access_security, access_sec_doors, access_maint_tunnels)
	minimal_access = list(access_security, access_sec_doors)
	outfit = /datum/outfit/job/intern_sec
	minimum_character_age = list(
		SPECIES_HUMAN = 18,
		SPECIES_SKRELL = 50,
		SPECIES_SKRELL_AXIORI = 50
	)

	blacklisted_species = list(SPECIES_IPC_ZENGHU, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_XION_REMOTE, SPECIES_VAURCA_BULWARK, SPECIES_DIONA_COEUS, SPECIES_VAURCA_BREEDER)

/datum/outfit/job/intern_sec
	name = "Security Cadet"
	jobtype = /datum/job/intern_sec

	uniform = /obj/item/clothing/under/rank/cadet
	suit = /obj/item/clothing/suit/storage/hazardvest/security
	head = /obj/item/clothing/head/beret/security
	shoes = null

	headset = /obj/item/device/radio/headset/headset_sec
	bowman = /obj/item/device/radio/headset/headset_sec/alt
	double_headset = /obj/item/device/radio/headset/alt/double/sec
	wrist_radio = /obj/item/device/radio/headset/wrist/sec

	backpack = /obj/item/storage/backpack/security
	satchel = /obj/item/storage/backpack/satchel/sec
	dufflebag = /obj/item/storage/backpack/duffel/sec
	messengerbag = /obj/item/storage/backpack/messenger/sec

	tab_pda = /obj/item/modular_computer/handheld/pda/security
	wristbound = /obj/item/modular_computer/handheld/wristbound/preset/pda/security
	tablet = /obj/item/modular_computer/handheld/preset/security

/datum/outfit/job/intern_sec/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/toeless(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots/toeless(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather/unathi(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), slot_shoes)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black_leather(H), slot_gloves)

/datum/outfit/job/intern_sec/forensics
	name = "Investigator Intern"
	jobtype = /datum/job/intern_sec

	shoes = /obj/item/clothing/shoes/laceup

/datum/outfit/job/intern_sec/forensics/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	H.equip_or_collect(new /obj/item/clothing/gloves/black/forensic(H), slot_gloves)

