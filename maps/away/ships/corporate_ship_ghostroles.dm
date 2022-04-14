//orion express ship

/datum/ghostspawner/human/orion_express_courier
	short_name = "orion_express_courier"
	name = "Orion Express Courier"
	desc = "Crew a Orion Express Ship and deliver parcels."
	tags = list("External")

	spawnpoints = list("orion_express_courier")
	max_count = 2

	outfit = /datum/outfit/admin/orion_express_courier
	possible_species = list(SPECIES_HUMAN,SPECIES_HUMAN_OFFWORLD,SPECIES_SKRELL, SPECIES_SKRELL_AXIORI,SPECIES_TAJARA,SPECIES_TAJARA_MSAI,SPECIES_TAJARA_ZHAN,SPECIES_UNATHI,SPECIES_VAURCA_WARRIOR,SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Orion Express Courier"
	special_role = "Orion Express Courier"
	respawn_flag = null


/datum/outfit/admin/orion_express_courier
	name = "Orion Express Courier"

	uniform = /obj/item/clothing/under/rank/hangar_technician/orion/ship
	shoes = /obj/item/clothing/shoes/brown
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/orion_ship

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)

/datum/outfit/admin/orion_express_courier/get_id_access()
	return list(access_orion_express_ship, access_external_airlocks)

/datum/ghostspawner/human/orion_express_courier/captain
	short_name = "orion_express_captain"
	name = "Orion Express Captain"
	desc = "Pilot and command an Orion Express Ship."
	tags = list("External")

	spawnpoints = list("orion_express_captain")
	max_count = 1

	outfit = /datum/outfit/admin/orion_express_courier/captain

	assigned_role = "Orion Express Captain"
	special_role = "Orion Express Captain"


/datum/outfit/admin/orion_express_courier/captain
	name = "Orion Express Captain"

	uniform = /obj/item/clothing/under/rank/operations_manager/orion_ship
	glasses = /obj/item/clothing/glasses/sunglasses

//items

/obj/item/clothing/under/rank/hangar_technician/orion/ship
	name = "orion express courier uniform"

/obj/item/clothing/under/rank/operations_manager/orion_ship
	name = "orion express captain uniform"

/obj/item/card/id/orion_ship
	name = "orion express ship id"
	access = list(access_orion_express_ship, access_external_airlocks)

