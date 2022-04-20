/datum/ghostspawner/human/tirakqi_crewman
	short_name = "Ti'Rakqi Crewman"
	name = "Ti'Rakqi Crewman"
	desc = "Crew a Ti'Rakqi Freighter and smuggle contraband."
	tags = list("External")

	spawnpoints = list("tirakqi_crewman")
	max_count = 2

	outfit = /datum/outfit/admin/tirakqi_crewman
	possible_species = list(SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_VAURCA_WARRIOR,SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Ti'Rakqi Crewman"
	special_role = "Ti'Rakqi Crewman"
	respawn_flag = null


/datum/outfit/admin/tirakqi_crewman
	name = "Ti'Rakqi Crewman"

	uniform = /obj/item/clothing/under/syndicate/tacticool
	shoes = /obj/item/clothing/shoes/brown
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/tirakqi_ship //also may not exist

	l_ear = /obj/item/device/radio/headset/tirakqi //doesn't current exist, needs to be added.

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)

/datum/outfit/admin/tirakqi_crewman/get_id_access()
	return list(access_tirakqi_ship, access_external_airlocks) //do we need to add the ids as well?

/datum/ghostspawner/human/tirakqi_crewman/captain
	short_name = "tirakqi_captain"
	name = "Ti'Rakqi Captain"
	desc = "Pilot a Ti'Rakqi smuggling Vessel and make some credits."
	tags = list("External")

	spawnpoints = list("tirakqi_captain")
	max_count = 1

	outfit = /datum/outfit/admin/orion_express_courier/captain

	assigned_role = "Ti'Rakqi Captain"
	special_role = "Ti'Rakqi Captain"


/datum/outfit/admin/orion_express_courier/captain
	name = "Ti'Rakqi Captain"

	glasses = /obj/item/clothing/glasses/sunglasses

//items

/obj/item/card/id/orion_ship
	name = "ti'rakqi id"
	access = list(access_tirakqi_ship, access_external_airlocks)