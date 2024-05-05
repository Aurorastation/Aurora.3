/datum/ghostspawner/human/sfa_navy_crewman
	short_name = "sfa_navy_crewman"
	name = "SFA Remnant"
	desc = "Crew the Southern Fleet Administration remnant corvette. Try to stay one step ahead of everyone out to get you."
	tags = list("External")

	spawnpoints = list("sfa_navy_crewman")
	max_count = 4

	outfit = /obj/outfit/admin/sfa_navy_crewman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer"
	special_role = "SFA Remnant"
	respawn_flag = null

	culture_restriction = list(/singleton/origin_item/culture/solarian)


/obj/outfit/admin/sfa_navy_crewman
	name = "SFA Remnant"

	uniform = /obj/item/clothing/under/rank/sol/
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/utility/full
	head = /obj/item/clothing/head/sol
	accessory = /obj/item/clothing/accessory/storage/brown_vest

	id = /obj/item/card/id/sfa_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/sfa_navy_crewman/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/sfa_navy_officer
	short_name = "sfa_navy_officer"
	name = "SFA Remnant Officer"
	desc = "Pilot and command the Southern Fleet Administration remnant corvette. Be sure to take your cyanide capsule before anyone captures you."
	tags = list("External")

	spawnpoints = list("sfa_navy_officer")
	max_count = 1

	outfit = /obj/outfit/admin/sfa_navy_officer
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer Captain"
	special_role = "SFA Remnant Officer"
	respawn_flag = null

	culture_restriction = list(/singleton/origin_item/culture/solarian)


/obj/outfit/admin/sfa_navy_officer
	name = "SFA Remnant Officer"

	uniform = /obj/item/clothing/under/rank/sol/dress/subofficer
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/sol/dress
	accessory = /obj/item/clothing/accessory/holster/thigh

	id = /obj/item/card/id/sfa_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/sfa_navy_officer/get_id_access()
	return list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)

//items

/obj/item/card/id/sfa_ship
	name = "sfa patrol ship id"
	access = list(ACCESS_SOL_SHIPS, ACCESS_EXTERNAL_AIRLOCKS)
