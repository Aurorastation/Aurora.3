/datum/ghostspawner/human/shopkeeper
	short_name = "shopkeeper"
	name = "Station Shopkeeper"
	desc = "Run your store aboard the civilian station. Remember to stock your empty shelves with things from the warehouse!"
	tags = list("External")

	spawnpoints = list("shopkeeper")
	max_count = 2

	outfit = /datum/outfit/admin/shopkeeper
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Station Shopkeeper"
	special_role = "Station Shopkeeper"
	respawn_flag = null


/datum/outfit/admin/shopkeeper
	name = "Station Shopkeeper"

	uniform = /obj/item/clothing/under/sl_suit
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel/norm

	id = /obj/item/card/id/civilian_station

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/shopkeeper/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/shopkeeper/get_id_access()
	return list(access_external_airlocks, access_civilian_station)

/datum/ghostspawner/human/shopkeeper/administrator
	short_name = "station_administrator"
	name = "Station Administrator"
	desc = "Run the civilian station, overseeing all operations aboard. Command your security guards."

	spawnpoints = list("civilian_station_administrator")
	max_count = 1

	outfit = /datum/outfit/admin/shopkeeper/administrator
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Station Administrator"
	special_role = "Station Administrator"


/datum/outfit/admin/shopkeeper/administrator
	name = "Station Administrator"

	uniform = /obj/item/clothing/under/suit_jacket/charcoal

/datum/ghostspawner/human/shopkeeper/foodcourt
	short_name = "foodcourt_worker"
	name = "Station Foodcourt Worker"
	desc = "Run the civilian station's foodcourt."

	spawnpoints = list("civilian_station_foodcourt")
	max_count = 1

	outfit = /datum/outfit/admin/shopkeeper/foodcourt
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Foodcourt Worker"
	special_role = "Foodcourt Worker"


/datum/outfit/admin/shopkeeper/foodcourt
	name = "Foodcourt Worker"

	uniform = /obj/item/clothing/under/waiter

/datum/ghostspawner/human/shopkeeper/security
	short_name = "station_security"
	name = "Station Security Guard"
	desc = "Guard the civilian station. Listen to the administrator."

	spawnpoints = list("civilian_station_security")
	max_count = 2

	outfit = /datum/outfit/admin/shopkeeper/security
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Station Security Guard"
	special_role = "Station Security Guard"

/datum/outfit/admin/shopkeeper/security
	name = "Station Security Guard"

	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/jackboots

/datum/ghostspawner/human/station_visitor
	short_name = "station_visitor"
	name = "Station Visitor"
	desc = "Enjoy the civilian station."
	tags = list("External")

	spawnpoints = list("civilian_station_visitor")
	max_count = 5

	outfit = /datum/outfit/admin/random/space_bar_patron
	species_outfits = list(SPECIES_VAURCA_WORKER = /datum/outfit/admin/random/space_bar_patron/vaurca,
					SPECIES_VAURCA_WARRIOR = /datum/outfit/admin/random/space_bar_patron/vaurca,
					SPECIES_HUMAN_OFFWORLD = /datum/outfit/admin/random/space_bar_patron/offworlder)
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP, SPECIES_IPC_SHELL, SPECIES_DIONA, SPECIES_DIONA_COEUS)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

/datum/ghostspawner/human/shopkeeper/custodian
	short_name = "station_custodian"
	name = "Station Custodian"
	desc = "Maintain and clean the civilian station."
	tags = list("External")

	spawnpoints = list("civilian_station_custodian")
	max_count = 1

	outfit = /datum/outfit/admin/shopkeeper/custodian
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

/datum/outfit/admin/shopkeeper/custodian
	name = "Station Custodian"

	uniform = /obj/item/clothing/under/rank/janitor
	shoes = /obj/item/clothing/shoes/galoshes

/obj/item/card/id/civilian_station
	name = "civilian station id"
	access = list(access_external_airlocks, access_civilian_station)

