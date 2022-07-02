//freighter_crew ship

/datum/ghostspawner/human/shopkeeper
	short_name = "shopkeeper"
	name = "Civilian Station Shopkeeper"
	desc = "Run your store aboard the civilian station. Remember to stock your empty shelves with things from the warehouse!"
	tags = list("External")

	spawnpoints = list("shopkeeper")
	max_count = 2

	outfit = /datum/outfit/admin/shopkeeper
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Civilian Station Shopkeeper"
	special_role = "Civilian Station Shopkeeper"
	respawn_flag = null


/datum/outfit/admin/shopkeeper
	name = "Civilian Station Shopkeeper"

	uniform = /obj/item/clothing/under/sl_suit
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel_norm

	id = /obj/item/card/id/civilian_station

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/shopkeeper/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(isoffworlder(H))
		H.equip_or_collect(new /obj/item/storage/pill_bottle/rmt, slot_in_backpack)

/datum/outfit/admin/shopkeeper/get_id_access()
	return list(access_external_airlocks)

/datum/ghostspawner/human/shopkeeper/administrator
	short_name = "civilian_station_administrator"
	name = "Civilian Station Administrator"
	desc = "Run the civilian station, overseeing all operations aboard. Command your security guards."

	spawnpoints = list("civilian_station_administrator")
	max_count = 1

	outfit = /datum/outfit/admin/freighter_crew/captain
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Civilian Station Administrator"
	special_role = "Civilian Station Administrator"


/datum/outfit/admin/shopkeeper/administrator
	name = "Civilian Station Administrator"

	uniform = /obj/item/clothing/under/tactical


/obj/item/card/id/civilian_station
	name = "civilian station id"
	access = list(access_external_airlocks)
