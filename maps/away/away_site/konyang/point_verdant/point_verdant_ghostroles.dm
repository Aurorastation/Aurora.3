//Corporate Offices
/datum/ghostspawner/human/konyang_zh
	short_name = "konyang_zh"
	name = "Zeng-Hu Pharmaceuticals Employee"
	desc = "Represent the interests of Zeng-Hu Pharmaceuticals and the Stellar Corporate Conglomerate on Konyang."
	tags = list("External")
	spawnpoints = list("konyang_zh")
	max_count = 2
	outfit = /datum/outfit/admin/konyang_zh
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Zeng-Hu Pharmaceuticals Corporate Personnel"
	special_role = "Zeng-Hu Pharmaceuticals Corporate Personnel"

/datum/outfit/admin/konyang_zh
	name = "Zeng-Hu Pharmaceuticals Employee"
	uniform = /obj/item/clothing/under/rank/scientist/zeng
	shoes = /obj/item/clothing/shoes/sneakers
	id = /obj/item/card/id/zeng_hu
	back = /obj/item/storage/backpack/satchel/zeng
	head = /obj/item/clothing/head/beret/corporate/zeng
	suit = /obj/item/clothing/suit/storage/toggle/corp/zeng
	r_pocket = /obj/item/storage/wallet/random

/datum/ghostspawner/human/konyang_ee
	short_name = "konyang_ee"
	name = "Einstein Engines Employee"
	desc = "Represent the interests of Einstein Engines on Konyang. Cooperate with SCC personnel to solve the ongoing crisis while protecting company secrets."
	tags = list("External")
	spawnpoints = list("konyang_ee")
	max_count = 2
	outfit = /datum/outfit/admin/konyang_ee
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Einstein Engines Corporate Personnel"
	special_role = "Einstein Engines Corporate Personnel"

/datum/outfit/admin/konyang_ee
	name = "Einstein Engines Employee"
	uniform = /obj/item/clothing/under/rank/einstein
	shoes = /obj/item/clothing/shoes/sneakers/black
	id = /obj/item/card/id/einstein
	back = /obj/item/storage/backpack/satchel
	r_pocket = /obj/item/storage/wallet/random

//Police
/datum/ghostspawner/human/konyang_cop
	short_name = "konyang_cop"
	name = "Point Verdant Patrolman"
	desc = "Keep the peace on the streets of Aoyama. Look the other way if no one gets hurt."
	tags = list("External")
	spawnpoints = list("konyang_cop")
	max_count = 2
	outfit = /datum/outfit/admin/konyang_cop
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Konyang National Police Patrolman"
	special_role = "Konyang National Police Patrolman"

/datum/outfit/admin/konyang_cop
	name = "Konyang Police Officer"
	uniform = /obj/item/clothing/under/rank/konyang/police
	accessory = /obj/item/clothing/accessory/holster/hip
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/konyang/police
	id = /obj/item/card/id
	belt = /obj/item/storage/belt/security
	l_pocket = /obj/item/device/radio
	r_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel

/datum/outfit/admin/konyang_cop/get_id_access()
	return list(access_konyang_police)

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
	outfit = /datum/outfit/admin/konyang_cop/superintendent

/datum/outfit/admin/konyang_cop/superintendent
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
	max_count = 2
	outfit = /datum/outfit/admin/konyang_goon
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "5-Cheung Thug"
	special_role = "5-Cheung Thug"

/datum/outfit/admin/konyang_goon
	name = "5-Cheung Thug"
	uniform = /obj/item/clothing/under/pants/tan
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
	outfit = /datum/outfit/admin/konyang_mob_boss
	assigned_role = "5-Cheung Boss"
	special_role = "5-Cheung Boss"

/datum/outfit/admin/konyang_mob_boss
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
	max_count = 4
	tags = list("External")
	spawnpoints = list("konyang_vendor")
	outfit = /datum/outfit/admin/konyang_vendor
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Point Verdant Vendor"
	special_role = "Point Verdant Vendor"

/datum/outfit/admin/konyang_vendor
	name = "Konyang Vendor"
	uniform = /obj/item/clothing/under/pants/jeans
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/suit/storage/toggle/konyang/akira
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/storage/wallet/random

/datum/outfit/admin/konyang_vendor/get_id_access()
	return list(access_konyang_vendors)

/datum/ghostspawner/human/konyang_clinic
	short_name = "konyang_clinic"
	name = "Konyang Robotics Company Doctor"
	desc = "Man the KRC clinic. Offer repairs and assistance to any IPC that requires it. Call an actual doctor when the shell turns out to be a human"
	max_count = 2
	tags = list("External")
	spawnpoints = list("konyang_clinic")
	outfit = /datum/outfit/admin/konyang_clinic
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Konyang Robotics Company Doctor"
	special_role = "Konyang Robotics Company Doctor"

/datum/outfit/admin/konyang_clinic
	name = "KRC Doctor"
	uniform = /obj/item/clothing/under/rank/konyang/krc
	shoes = /obj/item/clothing/shoes/laceup/brown
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/storage/wallet/random

/datum/outfit/admin/konyang_clinic/get_id_access()
	return list(access_konyang_vendors)

/datum/ghostspawner/human/konyang_pharm
	short_name = "konyang_pharm"
	name = "Point Verdant Pharmacist"
	desc = "Sell medicine out of the pharmacy. Forget to check for prescriptions. Negotiate with Zeng-Hu for your latest batch of supplies."
	max_count = 1
	tags = list("External")
	spawnpoints = list("konyang_pharm")
	outfit = /datum/outfit/admin/konyang_pharm
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Pharmacist"
	special_role = "Pharmacist"

/datum/outfit/admin/konyang_pharm
	name = "Konyang Pharmacist"
	uniform = /obj/item/clothing/under/color/white
	shoes = /obj/item/clothing/shoes/sneakers/medsci
	back = /obj/item/storage/backpack/satchel/pharm
	l_pocket = /obj/item/storage/wallet/random

/datum/outfit/admin/konyang_pharm/get_id_access()
	return list(access_konyang_vendors)

/datum/ghostspawner/human/konyang_bar
	short_name = "konyang_bar"
	name = "Point Verdant Bartender"
	desc = "Sell alcohol to anyone willing to pay. Talk to policemen and 5-Cheung thugs alike. Try to keep the fighting out of the bar."
	max_count = 1
	tags = list("External")
	spawnpoints = list("konyang_bar")
	outfit = /datum/outfit/admin/konyang_bar
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Bartender"
	special_role = "Bartender"

/datum/outfit/admin/konyang_bar
	name = "Konyang Bartender"
	uniform = /obj/item/clothing/under/rank/bartender
	shoes = /obj/item/clothing/shoes/sneakers/brown
	l_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel

/datum/ghostspawner/human/konyang_utility
	short_name = "konyang_utility"
	name = "Point Verdant Utility Worker"
	desc = "Maintain the infrastructure of Aoyama. Try to forget what exactly 5-Cheung was dumping in the sewers."
	max_count = 2
	tags = list("External")
	spawnpoints = list("konyang_utility")
	outfit = /datum/outfit/admin/konyang_utility
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Point Verdant Utility Worker"
	special_role = "Point Verdant Utility Worker"

/datum/outfit/admin/konyang_utility
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
	name = "Gwok Group Employee"
	desc = "Sell fast food and other Gwok-brand merchandise! Explain why the soft-serve machine is broken again."
	max_count = 1
	tags = list("External")
	spawnpoints = list("konyang_gwok")
	outfit = /datum/outfit/admin/konyang_gwok
	possible_species = list(SPECIES_HUMAN, SPECIES_IPC, SPECIES_IPC_BISHOP, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_SHELL, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Gwok Group Employee"
	special_role = "Gwok Group Employee"

/datum/outfit/admin/konyang_gwok
	name = "Gwok Group Employee"
	uniform = /obj/item/clothing/under/pants/jeans
	suit = /obj/item/clothing/accessory/apron/chef
	l_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel
