/datum/job/hos
	title = "Head of Security"
	flag = HOS
	head_position = 1
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ffdddd"
	req_admin_notify = 1
	economic_modifier = 10
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks,
				    access_detective, access_weapons)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
			            access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
			            access_research, access_engine, access_mining, access_medical, access_construction, access_mailsorting,
			            access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks,
				    access_detective, access_weapons)
	minimal_player_age = 14
	outfit = /datum/outfit/job/hos
	exclusivity = 20

/datum/outfit/job/hos
	name = "Head of Security"
	jobtype = /datum/job/hos

	uniform = /obj/item/clothing/under/rank/head_of_security
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = /obj/item/device/radio/headset/heads/hos
	pda = /obj/item/device/pda/heads/hos
	id = /obj/item/weapon/card/id/silver
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/head

	backpack_contents = list(
		/obj/item/weapon/storage/box/ids = 1
	)

	implants = list(
		/obj/item/weapon/implant/loyalty
	)

	backpack = /obj/item/weapon/storage/backpack/security
	satchel = /obj/item/weapon/storage/backpack/satchel_sec
	dufflebag = /obj/item/weapon/storage/backpack/duffel/sec
	messengerbag = /obj/item/weapon/storage/backpack/messenger/sec

/datum/outfit/job/hos/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/unathi(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)


/datum/job/warden
	title = "Warden"
	flag = WARDEN
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	economic_modifier = 5
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue, access_external_airlocks, access_weapons)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_external_airlocks, access_weapons)
	minimal_player_age = 7
	outfit = /datum/outfit/job/warden
	exclusivity = 80

/datum/outfit/job/warden
	name = "Warden"
	jobtype = /datum/job/warden

	uniform = /obj/item/clothing/under/rank/warden
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = /obj/item/device/radio/headset/headset_sec
	pda = /obj/item/device/pda/warden
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/head
	l_pocket = /obj/item/device/flash

	backpack = /obj/item/weapon/storage/backpack/security
	satchel = /obj/item/weapon/storage/backpack/satchel_sec
	dufflebag = /obj/item/weapon/storage/backpack/duffel/sec
	messengerbag = /obj/item/weapon/storage/backpack/messenger/sec

	backpack_contents = list(
		/obj/item/weapon/storage/box/ids = 1
	)

/datum/outfit/job/warden/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/unathi(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)


/datum/job/detective
	title = "Detective"
	flag = DETECTIVE
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	economic_modifier = 5
	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_detective, access_weapons)
	minimal_access = list(access_security, access_sec_doors, access_morgue, access_maint_tunnels, access_detective, access_weapons)
	minimal_player_age = 7
	outfit = /datum/outfit/job/detective

/datum/outfit/job/detective
	name = "Detective"
	jobtype = /datum/job/detective

	uniform = /obj/item/clothing/under/det
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/device/radio/headset/headset_sec
	pda = /obj/item/device/pda/detective

	backpack_contents = list(
		/obj/item/weapon/storage/box/evidence = 1
	)

/datum/outfit/job/detective/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/unathi(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)


/datum/job/forensics
	title = "Forensic Technician"
	flag = FORENSICS
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#ffeeee"
	economic_modifier = 5
	access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_weapons)
	minimal_access = list(access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_weapons)
	alt_titles = list("Crime Scene Investigator")
	minimal_player_age = 3
	outfit = /datum/outfit/job/forensics
	alt_outfits = list("Crime Scene Investigator"=/datum/outfit/job/forensics/csi)
	exclusivity = 80

/datum/outfit/job/forensics
	name = "Forensic Technician"
	jobtype = /datum/job/forensics

	uniform = /obj/item/clothing/under/det/slob
	suit = /obj/item/clothing/suit/storage/vest/csi
	shoes = /obj/item/clothing/shoes/laceup
	l_ear = /obj/item/device/radio/headset/headset_sec
	pda = /obj/item/device/pda/detective

	backpack_contents = list(
		/obj/item/weapon/storage/box/evidence = 1
	)

/datum/outfit/job/forensics/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/unathi(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)


/datum/outfit/job/forensics/csi
	name = "Crime Scene Investigator"
	jobtype = /datum/job/forensics

	suit = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/job/officer
	title = "Security Officer"
	flag = OFFICER
	department = "Security"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the head of security"
	selection_color = "#ffeeee"
//	alt_titles = list("Junior Officer") //aurora already has security cadets
	economic_modifier = 4
	access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks, access_weapons)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks, access_weapons)
	minimal_player_age = 7
	outfit = /datum/outfit/job/officer
	exclusivity = 90

/datum/outfit/job/officer
	name = "Security Officer"
	jobtype = /datum/job/officer

	uniform = /obj/item/clothing/under/rank/security
	shoes = /obj/item/clothing/shoes/jackboots
	l_ear = /obj/item/device/radio/headset/headset_sec
	pda = /obj/item/device/pda/security
	l_pocket = /obj/item/device/flash

	backpack = /obj/item/weapon/storage/backpack/security
	satchel = /obj/item/weapon/storage/backpack/satchel_sec
	dufflebag = /obj/item/weapon/storage/backpack/duffel/sec
	messengerbag = /obj/item/weapon/storage/backpack/messenger/sec

	backpack_contents = list(
		/obj/item/weapon/handcuffs = 1
	)

/datum/outfit/job/officer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(istajara(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/tajara(H), slot_gloves)
	else if(isunathi(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black/unathi(H), slot_gloves)
	else
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(H), slot_gloves)