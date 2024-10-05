//Corporate Offices
/datum/ghostspawner/human/konyang_zh
	short_name = "konyang_zh"
	name = "Zeng-Hu Pharmaceuticals Employee"
	desc = "Represent the interests of Zeng-Hu Pharmaceuticals and the Stellar Corporate Conglomerate on Konyang."
	tags = list("External")
	spawnpoints = list("konyang_zh")
	max_count = 2
	outfit = /obj/outfit/admin/konyang/zh
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Zeng-Hu Pharmaceuticals Corporate Personnel"
	special_role = "Zeng-Hu Pharmaceuticals Corporate Personnel"
	respawn_flag = null

/obj/outfit/admin/konyang/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_SELF
		tag.citizenship_info = CITIZENSHIP_COALITION

/obj/outfit/admin/konyang/zh
	name = "Zeng-Hu Pharmaceuticals Employee"
	uniform = /obj/item/clothing/under/rank/liaison/zeng
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/zeng_hu
	back = /obj/item/storage/backpack/satchel/zeng
	head = /obj/item/clothing/head/beret/corporate/zeng
	suit = /obj/item/clothing/suit/storage/toggle/corp/zeng
	r_pocket = /obj/item/storage/wallet/random

/obj/outfit/admin/konyang/zh/get_id_access()
	return list(ACCESS_KONYANG_CORPORATE)

/datum/ghostspawner/human/konyang_ee
	short_name = "konyang_ee"
	name = "Einstein Engines Employee"
	desc = "Represent the interests of Einstein Engines on Konyang. Cooperate with SCC personnel to solve the ongoing crisis while protecting company secrets."
	tags = list("External")
	spawnpoints = list("konyang_ee")
	max_count = 2
	outfit = /obj/outfit/admin/konyang/ee
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Einstein Engines Corporate Personnel"
	special_role = "Einstein Engines Corporate Personnel"
	respawn_flag = null

/obj/outfit/admin/konyang/ee
	name = "Einstein Engines Employee"
	uniform = /obj/item/clothing/under/rank/liaison/einstein
	shoes = /obj/item/clothing/shoes/laceup
	id = /obj/item/card/id/einstein
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/storage/wallet/random

/obj/outfit/admin/konyang/ee/get_id_access()
	return list(ACCESS_KONYANG_CORPORATE)

//Police
/datum/ghostspawner/human/konyang_cop
	short_name = "konyang_cop"
	name = "Point Verdant Patrolman"
	desc = "Keep the peace on the streets of Aoyama. Look the other way if no one gets hurt."
	tags = list("External")
	spawnpoints = list("konyang_cop")
	max_count = 2
	outfit = /obj/outfit/admin/konyang/cop
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Konyang National Police Patrolman"
	special_role = "Konyang National Police Patrolman"
	respawn_flag = null

/obj/outfit/admin/konyang/cop
	name = "Konyang Police Officer"
	uniform = /obj/item/clothing/under/rank/konyang/police
	accessory = /obj/item/clothing/accessory/holster/hip
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/konyang/police
	id = /obj/item/card/id
	l_ear = /obj/item/device/radio/headset/ship
	belt = /obj/item/storage/belt/security
	r_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel

/obj/outfit/admin/konyang/cop/get_id_access()
	return list(ACCESS_KONYANG_POLICE)

/datum/ghostspawner/human/konyang_cop/senior
	short_name = "konyang_senior_cop"
	name = "Point Verdant Senior Patrolman"
	desc = "Command the uniformed officers of Aoyama in the field. Get overruled by the superintendent anyway."
	max_count = 1
	assigned_role = "Konyang National Police Senior Patrolman"
	special_role = "Konyang National Police Senior Patrolman"

/datum/ghostspawner/human/konyang_cop/superintendent
	short_name = "konyang_superintendent"
	name = "Point Verdant Police Superintendent"
	desc = "Oversee the local precinct. Get rich off of corporate money."
	max_count = 1
	assigned_role = "Konyang National Police Superintendent"
	special_role = "Konyang National Police Superintendent"
	outfit = /obj/outfit/admin/konyang/cop/superintendent

/obj/outfit/admin/konyang/cop/superintendent
	name = "Konyang Police Superintendent"
	uniform = /obj/item/clothing/under/rank/konyang/police/lieutenant
	head = /obj/item/clothing/head/konyang/police/lieutenant
	back = /obj/item/storage/backpack/satchel/leather

//5-Cheung
/datum/ghostspawner/human/konyang_goon
	short_name = "konyang_goon"
	name = "5-Cheung Thug"
	desc = "Guard the hideout. Sell illicit goods and ingratiate yourself with the local community. Try not to get caught doing anything illegal."
	tags = list("External")
	spawnpoints = list("konyang_goon")
	max_count = 3
	outfit = /obj/outfit/admin/konyang/goon
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "5-Cheung Thug"
	special_role = "5-Cheung Thug"
	respawn_flag = null

/obj/outfit/admin/konyang/goon
	name = "5-Cheung Thug"
	uniform = /obj/item/clothing/pants/tan
	shoes = /obj/item/clothing/shoes/sneakers/black
	id = null
	l_pocket = /obj/item/storage/wallet/random
	r_pocket = /obj/item/material/knife/butterfly/switchblade
	back = /obj/item/storage/backpack/satchel

/datum/ghostspawner/human/konyang_goon/boss
	name = "5-Cheung Boss"
	short_name = "konyang_goon_boss"
	desc = "Manage the local operations of 5-Cheung. Establish an understanding with the Superintendent. Make yourself a force in the community."
	max_count = 1
	spawnpoints = list("konyang_goon_boss")
	outfit = /obj/outfit/admin/konyang/mob_boss
	assigned_role = "5-Cheung Boss"
	special_role = "5-Cheung Boss"
	respawn_flag = null

/obj/outfit/admin/konyang/mob_boss
	name = "5-Cheung Boss"
	uniform = /obj/item/clothing/under/suit_jacket/white
	shoes = /obj/item/clothing/shoes/laceup
	wrist = /obj/item/clothing/wrists/watch/gold
	l_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel/leather
	id = null

//Civilian
/datum/ghostspawner/human/konyang_vendor
	short_name = "konyang_vendor"
	name = "Point Verdant Vendor"
	desc = "Man the stores around Point Verdant. Sell goods to the visiting crewmembers. Try not to get shaken down by the local 5-Cheung thugs."
	max_count = 6
	tags = list("External")
	spawnpoints = list("konyang_vendor")
	outfit = /obj/outfit/admin/konyang/vendor
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Point Verdant Vendor"
	special_role = "Point Verdant Vendor"
	respawn_flag = null

/obj/outfit/admin/konyang/vendor
	name = "Konyang Vendor"
	uniform = /obj/item/clothing/pants/jeans
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/suit/storage/toggle/konyang/akira
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/storage/wallet/random
	id = /obj/item/card/id

/obj/outfit/admin/konyang/vendor/get_id_access()
	return list(ACCESS_KONYANG_VENDORS)

/datum/ghostspawner/human/konyang_clinic
	short_name = "konyang_clinic"
	name = "Konyang Robotics Company Doctor"
	desc = "Man the KRC clinic. Offer repairs and assistance to any IPC that requires it. Call an actual doctor when the shell turns out to be a human"
	max_count = 2
	tags = list("External")
	spawnpoints = list("konyang_clinic")
	outfit = /obj/outfit/admin/konyang/clinic
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Konyang Robotics Company Doctor"
	special_role = "Konyang Robotics Company Doctor"
	respawn_flag = null

/obj/outfit/admin/konyang/clinic
	name = "KRC Doctor"
	uniform = /obj/item/clothing/under/rank/konyang/krc
	shoes = /obj/item/clothing/shoes/laceup/brown
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/storage/wallet/random

/obj/outfit/admin/konyang/clinic/get_id_access()
	return list(ACCESS_KONYANG_VENDORS)

/datum/ghostspawner/human/konyang_pharm
	short_name = "konyang_pharm"
	name = "Point Verdant Pharmacist"
	desc = "Sell medicine out of the pharmacy. Forget to check for prescriptions. Negotiate with Zeng-Hu for your latest batch of supplies."
	max_count = 1
	tags = list("External")
	spawnpoints = list("konyang_pharm")
	outfit = /obj/outfit/admin/konyang/pharm
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Pharmacist"
	special_role = "Pharmacist"
	respawn_flag = null

/obj/outfit/admin/konyang/pharm
	name = "Konyang Pharmacist"
	uniform = /obj/item/clothing/under/color/white
	shoes = /obj/item/clothing/shoes/sneakers/medsci
	back = /obj/item/storage/backpack/satchel/pharm
	l_pocket = /obj/item/storage/wallet/random
	id = /obj/item/card/id

/obj/outfit/admin/konyang/pharm/get_id_access()
	return list(ACCESS_KONYANG_VENDORS)

/datum/ghostspawner/human/konyang_bar
	short_name = "konyang_bar"
	name = "Point Verdant Bartender"
	desc = "Sell alcohol to anyone willing to pay. Talk to policemen and 5-Cheung thugs alike. Try to keep the fighting out of the bar."
	max_count = 1
	tags = list("External")
	spawnpoints = list("konyang_bar")
	outfit = /obj/outfit/admin/konyang/bar
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Bartender"
	special_role = "Bartender"
	respawn_flag = null

/obj/outfit/admin/konyang/bar
	name = "Konyang Bartender"
	uniform = /obj/item/clothing/under/rank/bartender
	shoes = /obj/item/clothing/shoes/sneakers/brown
	l_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id

/obj/outfit/admin/konyang/bar/get_id_access()
	return list(ACCESS_KONYANG_VENDORS)

/datum/ghostspawner/human/konyang_utility
	short_name = "konyang_utility"
	name = "Point Verdant Utility Worker"
	desc = "Maintain the infrastructure of Aoyama. Try to forget what exactly 5-Cheung was dumping in the sewers."
	max_count = 2
	tags = list("External")
	spawnpoints = list("konyang_utility")
	outfit = /obj/outfit/admin/konyang/utility
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Point Verdant Utility Worker"
	special_role = "Point Verdant Utility Worker"
	respawn_flag = null

/obj/outfit/admin/konyang/utility
	name = "Point Verdant Utility Worker"
	uniform = /obj/item/clothing/under/color/blue
	shoes = /obj/item/clothing/shoes/workboots/dark
	head = /obj/item/clothing/head/hardhat
	id = /obj/item/card/id
	l_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel/eng
	belt = /obj/item/storage/belt/utility/full
	r_pocket = /obj/item/device/radio

/datum/ghostspawner/human/konyang_gwok
	short_name = "konyang_gwok"
	name = "UP! Burger Employee"
	desc = "Sell fast food and other Gwok-brand merchandise! Explain why the soft-serve machine is broken again."
	max_count = 2
	tags = list("External")
	spawnpoints = list("konyang_gwok")
	outfit = /obj/outfit/admin/konyang/gwok
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "UP! Burger Employee"
	special_role = "UP! Burger Employee"
	respawn_flag = null

/obj/outfit/admin/konyang/gwok
	name = "UP! Burger Employee"
	uniform = /obj/item/clothing/under/rank/konyang/burger
	shoes = /obj/item/clothing/shoes/workboots/dark
	suit = /obj/item/clothing/accessory/apron/chef
	head = /obj/item/clothing/head/konyang/burger
	id = /obj/item/card/id
	l_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel

/obj/outfit/admin/konyang/gwok/get_id_access()
	return list(ACCESS_KONYANG_VENDORS)

//Konyang Army Personnel - basically a pseudo-ert for if shit's going down on Point Verdant
/datum/ghostspawner/human/konyang_army
	short_name = "konyang_army"
	name = "Konyang Army Soldier"
	desc = "You are a soldier of the Konyang army, deployed to deal with a crisis in Point Verdant."
	max_count = 3
	tags = list("External")
	spawnpoints = list("konyang_army")
	outfit = /obj/outfit/admin/konyang/army_response
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Konyang Army Soldier"
	special_role = "Konyang Army Soldier"
	mob_name_prefix = "Pfc. "
	respawn_flag = null
	enabled = FALSE

/obj/outfit/admin/konyang/army_response
	name = "Konyang Army Responder"
	uniform = /obj/item/clothing/under/rank/konyang
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/konyang/army
	l_pocket = /obj/item/storage/wallet/random
	l_ear = /obj/item/device/radio/headset/distress
	belt = /obj/item/storage/belt/military
	back = /obj/item/storage/backpack/rucksack/tan
	id = /obj/item/card/id
	gloves = /obj/item/clothing/gloves/swat/ert
	accessory = /obj/item/clothing/accessory/holster/hip
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/handcuffs/ziptie = 2,
		/obj/item/melee/energy/sword/knife/sol = 1
	)


/obj/outfit/admin/konyang/army_response/get_id_access()
	return list(ACCESS_DISTRESS, ACCESS_KONYANG_POLICE, ACCESS_KONYANG_CORPORATE, ACCESS_KONYANG_POLICE, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/konyang_army/medic
	name = "Konyang Army Medic"
	short_name = "konyang_army_medic"
	desc = "You are a medical specialist of the Konyang army, deployed to deal with a crisis in Point Verdant."
	max_count = 1
	outfit = /obj/outfit/admin/konyang/army_response/medic
	mob_name_prefix = "Spc. "
	assigned_role = "Konyang Army Medic"
	special_role = "Konyang Army Medic"

/obj/outfit/admin/konyang/army_response/medic
	back = /obj/item/storage/backpack/satchel/med
	gloves = /obj/item/clothing/gloves/latex/nitrile
	glasses = /obj/item/clothing/glasses/hud/health
	belt = /obj/item/storage/belt/medical/paramedic/combat/full
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/handcuffs/ziptie = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1,
		/obj/item/stack/nanopaste = 1,
	)

/datum/ghostspawner/human/konyang_army/mechpilot
	name = "Konyang Army Exosuit Pilot"
	short_name = "konyang_army_mechpilot"
	desc = "You are an exosuit specialist of the Konyang army's Mechatronic Corps, deployed to deal with a crisis in Point Verdant."
	max_count = 1
	outfit = /obj/outfit/admin/konyang/army_response/mechpilot
	mob_name_prefix = "Spc. "
	assigned_role = "Konyang Army Exosuit Pilot"
	special_role = "Konyang Army Exosuit Pilot"

/obj/outfit/admin/konyang/army_response/mechpilot
	uniform = /obj/item/clothing/under/rank/konyang/mech_pilot
	head = /obj/item/clothing/head/helmet/konyang/pilot
	gloves = /obj/item/clothing/gloves/yellow
	belt = /obj/item/storage/belt/utility/very_full
	glasses = /obj/item/clothing/glasses/welding/superior

/datum/ghostspawner/human/konyang_army/commander
	name = "Konyang Army Officer"
	short_name = "konyang_army_lead"
	spawnpoints = list("konyang_army_lead")
	desc = "You are an officer in command of a Konyang army unit deployed to deal with a crisis in Point Verdant."
	max_count = 1
	outfit = /obj/outfit/admin/konyang/army_response/officer
	mob_name_prefix = "Lt. "
	assigned_role = "Konyang Army Officer"
	special_role = "Konyang Army Officer"

/obj/outfit/admin/konyang/army_response/officer
	uniform = /obj/item/clothing/under/rank/konyang/officer
	head = /obj/item/clothing/head/konyang/army/officer

//Corporate 'Solutions Department' - basically another pseudo-ert for admins to spawn in the event of silliness on PV
/datum/ghostspawner/human/corporate_solutions
	name = "Zeng-Hu Corporate Solutions Agent"
	short_name = "pv_corporate_solutions_zeng"
	spawnpoints = list("pv_corporate_solutions")
	desc = "You are a corporate security agent working for Zeng-Hu Pharmaceuticals, responding to a crisis in Point Verdant in cooperation with Einstein Engines personnel."
	max_count = 2
	outfit = /obj/outfit/admin/corporate_solutions
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Solutions Agent (Zeng)"
	special_role = "Solutions Agent (Zeng)"
	respawn_flag = null
	enabled = FALSE

/obj/outfit/admin/corporate_solutions
	uniform = /obj/item/clothing/under/rank/security/zeng
	shoes = /obj/item/clothing/shoes/combat
	belt = /obj/item/storage/belt/military
	gloves = /obj/item/clothing/gloves/swat/ert
	glasses = /obj/item/clothing/glasses
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/card/id/zeng_hu
	belt_contents = list(
		/obj/item/handcuffs = 2,
		/obj/item/shield/riot/tact = 1
	)
	back = null

/obj/outfit/admin/corporate_solutions/get_id_access()
	return list(ACCESS_CENT_SPECOPS, ACCESS_KONYANG_CORPORATE, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/corporate_solutions/einstein
	name = "Einstein Corporate Solutions Agent"
	desc = "You are a corporate security agent working for Einstein, responding to a crisis in Point Verdant in cooperation with Zeng-Hu Pharmaceuticals personnel."
	outfit = /obj/outfit/admin/corporate_solutions/einstein
	assigned_role = "Solutions Agent (Einstein)"
	special_role = "Solutions Agent (Einstein)"

/obj/outfit/admin/corporate_solutions/einstein
	uniform = /obj/item/clothing/under/rank/security/einstein
	id = /obj/item/card/id/einstein

/datum/ghostspawner/human/corporate_solutions/medic
	name = "Zeng-Hu Corporate Solutions Medic"
	short_name = "pv_corporate_solutions_med"
	desc = "You are a corporate medical agent working for Zeng-Hu Pharmaceuticals, responding to a crisis in Point Verdant in cooperation with Einstein Engines personnel."
	max_count = 1
	outfit = /obj/outfit/admin/corporate_solutions/medic

/obj/outfit/admin/corporate_solutions/medic
	uniform = /obj/item/clothing/under/rank/medical/paramedic/zeng
	gloves = /obj/item/clothing/gloves/latex/nitrile
	glasses = /obj/item/clothing/glasses/hud/health
	belt = /obj/item/storage/belt/medical/paramedic/combat
	backpack = /obj/item/storage/backpack/satchel/zeng
	belt_contents = list(
		/obj/item/reagent_containers/hypospray/cmo = 1,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/antitoxin = 1,
		/obj/item/reagent_containers/glass/bottle/dexalin_plus = 1,
		/obj/item/reagent_containers/glass/bottle/bicaridine = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/reagent_containers/glass/bottle/dermaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1
	)

	backpack_contents = list(
		/obj/item/storage/firstaid/combat = 1,
		/obj/item/storage/firstaid/adv = 1,
		/obj/item/handcuffs = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/advanced/bruise_pack = 1,
		/obj/item/stack/medical/advanced/ointment = 1
	)

/datum/ghostspawner/human/corporate_solutions/engineer
	name = "Einstein Corporate Solutions Engineer"
	short_name = "pv_corporate_solutions_eng"
	desc = "You are a corporate engineering agent working for Einstein Engines, responding to a crisis in Point Verdant in cooperation with Zeng-Hu Pharmaceuticals personnel."
	max_count = 1
	outfit = /obj/outfit/admin/corporate_solutions/einstein/engineer

/obj/outfit/admin/corporate_solutions/einstein/engineer
	uniform = /obj/item/clothing/under/rank/engineer/einstein
	gloves = /obj/item/clothing/gloves/yellow
	belt = /obj/item/storage/belt/utility/very_full
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	back = /obj/item/storage/backpack/industrial
	belt_contents = null
	accessory_contents = list(
		/obj/item/handcuffs = 2,
		/obj/item/clothing/glasses/welding/superior = 1
	)
