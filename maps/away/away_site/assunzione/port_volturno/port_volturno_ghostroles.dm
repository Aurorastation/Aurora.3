//Police
/datum/ghostspawner/human/assunzione_cop
	short_name = "assunzione_cop"
	name = "Zeng-Hu Volturno Security Officer"
	desc = "Maintain overall security and adherence to corporate regulations under the dome of Port Volturno. Look the other way if no one gets hurt."
	tags = list("External")
	spawnpoints = list("assunzione_cop")
	max_count = 3
	outfit = /obj/outfit/admin/assunzione/cop
	possible_species = list(SPECIES_HUMAN,
							SPECIES_IPC,
							SPECIES_IPC_XION,
							SPECIES_IPC_ZENGHU,
							SPECIES_IPC_BISHOP,
							SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Zeng-Hu Security Officer"
	special_role = "Zeng-Hu Security Officer"
	respawn_flag = null

/obj/outfit/admin/assunzione/cop
	name = "Zeng-Hu Volturno Security Officer"
	uniform = /obj/item/clothing/under/rank/security/zeng
	accessory = /obj/item/clothing/accessory/holster/hip
	shoes = /obj/item/clothing/shoes/jackboots
	head = /obj/item/clothing/head/beret/corporate/zeng
	id = /obj/item/card/id
	l_ear = /obj/item/radio/headset/ship
	belt = /obj/item/storage/belt/security/full
	r_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel

/obj/outfit/admin/assunzione/cop/get_id_access()
	return list(ACCESS_PORTOFCALL_POLICE)

/datum/ghostspawner/human/assunzione_cop/overseer
	short_name = "assunzione_cop_overseer"
	name = "Zeng-Hu Volturno Security Overseer"
	desc = "The Keiretsu are depending on you- at least that's what they tell you. The Keiretsu actually have no idea you exist. Try and keep the peace anyway."
	spawnpoints = list("assunzione_cop_overseer")
	max_count = 1
	outfit = /obj/outfit/admin/assunzione/cop/superintendent
	assigned_role = "Zeng-Hu Security Overseer"
	special_role = "Zeng-Hu Security Overseer"

/obj/outfit/admin/assunzione/cop/superintendent
	name = "Zeng-Hu Volturno Security Overseer"
	uniform = /obj/item/clothing/under/rank/security/zeng
	head = /obj/item/clothing/head/peaked_cap/zenghu
	back = /obj/item/storage/backpack/satchel/leather

//Civilian
/datum/ghostspawner/human/assunzione_vendor
	short_name = "assunzione_vendor"
	name = "Point Volturno Vendor"
	desc = "Man the stores around Port Volturno. Sell goods to the visiting crewmembers. Don't think too hard about what's probably going to happen to them in the Sea."
	max_count = 6
	tags = list("External")
	spawnpoints = list("assunzione_vendor")
	outfit = /obj/outfit/admin/assunzione/vendor
	possible_species = list(SPECIES_HUMAN,
							SPECIES_IPC,
							SPECIES_IPC_XION,
							SPECIES_IPC_ZENGHU,
							SPECIES_IPC_BISHOP,
							SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Point Volturno Vendor"
	special_role = "Point Volturno Vendor"
	respawn_flag = null

/obj/outfit/admin/assunzione/vendor
	name = "Assunzione Vendor"
	uniform = /obj/item/clothing/pants/jeans
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/under/dressshirt
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/storage/wallet/random
	id = /obj/item/card/id

/obj/outfit/admin/assunzione/vendor/get_id_access()
	return list(ACCESS_PORTOFCALL_VENDORS)

/datum/ghostspawner/human/assunzione_electromechanic
	short_name = "assunzione_electromechanic"
	name = "Sybdari Electromechanics Employee"
	desc = "Man the local branch. Offer repairs and assistance with hardware to anyone that require it. If an IPC needs repairs... Do your best."
	max_count = 2
	tags = list("External")
	spawnpoints = list("assunzione_electromechanic")
	outfit = /obj/outfit/admin/assunzione/mechanic
	possible_species = list(SPECIES_HUMAN,
							SPECIES_IPC,
							SPECIES_IPC_XION,
							SPECIES_IPC_ZENGHU,
							SPECIES_IPC_BISHOP,
							SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Sybdari Electromechanics Employee"
	special_role = "Sybdari Electromechanics Employee"
	respawn_flag = null

/obj/outfit/admin/assunzione/mechanic
	name = "Sybdari Electromechanics Employee"
	uniform = /obj/item/clothing/under/color/lightblue
	shoes = /obj/item/clothing/shoes/laceup/brown
	id = /obj/item/card/id
	back = /obj/item/storage/backpack/satchel
	l_pocket = /obj/item/storage/wallet/random

/obj/outfit/admin/assunzione/mechanic/get_id_access()
	return list(ACCESS_PORTOFCALL_VENDORS)

/datum/ghostspawner/human/assunzione_clinic
	short_name = "assunzione_clinic"
	name = "Zeng-Hu Clinician"
	desc = "Provide medical care to those in need. Argue relentlessly for proof of insurance."
	max_count = 1
	tags = list("External")
	spawnpoints = list("assunzione_clinic")
	outfit = /obj/outfit/admin/assunzione/clinic
	possible_species = list(SPECIES_HUMAN,
							SPECIES_IPC,
							SPECIES_IPC_XION,
							SPECIES_IPC_ZENGHU,
							SPECIES_IPC_BISHOP,
							SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Zeng-Hu Clinician"
	special_role = "Zeng-Hu Clinician"
	respawn_flag = null

/datum/ghostspawner/human/assunzione_clinic/pharmacist
	short_name = "assunzione_pharm"
	name = "Zeng-Hu Pharmacist"
	desc = "Sell medicine out of the pharmacy. Forget to check for prescriptions. Negotiate with Zeng-Hu for your latest batch of supplies."
	spawnpoints = list("assunzione_pharm")
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Zeng-Hu Pharmacist"
	special_role = "Zeng-Hu Pharmacist"

/obj/outfit/admin/assunzione/clinic
	name = "Zeng-Hu Clinician"
	uniform = /obj/item/clothing/under/color/white
	shoes = /obj/item/clothing/shoes/sneakers/medsci
	back = /obj/item/storage/backpack/satchel/pharm
	l_pocket = /obj/item/storage/wallet/random
	id = /obj/item/card/id

/obj/outfit/admin/assunzione/clinic/get_id_access()
	return list(ACCESS_PORTOFCALL_VENDORS)

/datum/ghostspawner/human/assunzione_utility
	short_name = "assunzione_utility"
	name = "Port Volturno Utility Worker"
	desc = "Maintain the infrastructure of Port Volturno. Replace approximately 400 light bulbs a day."
	max_count = 2
	tags = list("External")
	spawnpoints = list("assunzione_utility")
	outfit = /obj/outfit/admin/assunzione/utility
	possible_species = list(SPECIES_HUMAN,
							SPECIES_IPC,
							SPECIES_IPC_XION,
							SPECIES_IPC_ZENGHU,
							SPECIES_IPC_BISHOP,
							SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Port Volturno Utility Worker"
	special_role = "Port Volturno Utility Worker"
	respawn_flag = null

/obj/outfit/admin/assunzione/utility
	name = "Port Volturno Utility Worker"
	uniform = /obj/item/clothing/under/color/purple
	shoes = /obj/item/clothing/shoes/workboots/dark
	head = /obj/item/clothing/head/hardhat
	id = /obj/item/card/id
	l_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel/eng
	belt = /obj/item/storage/belt/utility/full
	r_pocket = /obj/item/radio

/datum/ghostspawner/human/assunzione_stafylia
	short_name = "assunzione_stafylia"
	name = "Stafylia Employee"
	desc = "Sell gyros! If anyone asks for burgers, scream at them to get the hell out. Bloody tourists, this is gyro territory!"
	max_count = 2
	tags = list("External")
	spawnpoints = list("assunzione_stafylia")
	outfit = /obj/outfit/admin/assunzione/stafylia
	possible_species = list(SPECIES_HUMAN,
							SPECIES_IPC,
							SPECIES_IPC_XION,
							SPECIES_IPC_ZENGHU,
							SPECIES_IPC_BISHOP,
							SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Stafylia Employee"
	special_role = "Stafylia Employee"
	respawn_flag = null

/obj/outfit/admin/assunzione/stafylia
	name = "Stafylia Employee"
	uniform = /obj/item/clothing/under/rank/assunzione/stafylia
	shoes = /obj/item/clothing/shoes/workboots/dark
	suit = /obj/item/clothing/accessory/apron/chef
	id = /obj/item/card/id
	l_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel

/obj/outfit/admin/assunzione/stafylia/get_id_access()
	return list(ACCESS_PORTOFCALL_VENDORS)

/datum/ghostspawner/human/assunzione_keeper
	short_name = "assunzione_keeper"
	name = "Luceist Keeper"
	desc = "Preach the Light of Ennoia! Give out warding spheres for free to Assunzionii, and to any non-believers as well (after they fork over some donation money). Show non-believers where the ATM is!"
	max_count = 1
	tags = list("External")
	spawnpoints = list("assunzione_keeper")
	outfit = /obj/outfit/admin/assunzione/keeper
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	assigned_role = "Luceist Keeper"
	special_role = "Luceist Keeper"
	respawn_flag = null

/obj/outfit/admin/assunzione/keeper
	name = "Luceist Keeper"
	uniform = /obj/item/clothing/under/assunzione/priest
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/storage/hooded/wintercoat/assunzione_robe
	id = /obj/item/card/id
	l_pocket = /obj/item/storage/wallet/random
	back = /obj/item/storage/backpack/satchel

/obj/outfit/admin/assunzione/keeper/get_id_access()
	return list(ACCESS_PORTOFCALL_VENDORS)
