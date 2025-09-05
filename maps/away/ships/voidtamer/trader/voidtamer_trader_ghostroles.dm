/datum/ghostspawner/human/voidtamer_crew
	short_name = "voidtamer_crew"
	name = "Voidtamer Crew"
	desc = "Dionae crew of a voidtamer vessel"
	tags = list("External")

	spawnpoints = list("voidtamer_crew")
	max_count = 4

	outfit = /obj/outfit/admin/voidtamer_crew
	possible_species = list(SPECIES_DIONA, SPECIES_DIONA_COEUS)
	uses_species_whitelist = FALSE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Voidtamer Crew"
	special_role = "Voidtamer crew"
	respawn_flag = null

/obj/outfit/admin/voidtamer_crew
	name = "Voidtamer Crew"
	uniform = /obj/item/clothing/under/gearharness
	suit = /obj/item/clothing/accessory/poncho/voidtamer
	head = /obj/item/clothing/head/diona/voidtamer
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/voidtamer
	l_ear = /obj/item/device/radio/headset/ship
	backpack_contents = list(/obj/item/device/flashlight/survival = 1)

/obj/outfit/admin/voidtamer_crew/get_id_access()
	return list(ACCESS_VOIDTAMER_SHIP, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/voidtamer_crew/captain
	short_name = "voidtamer_captain"
	name = "Voidtamer Captain"
	desc = "Captain of a voidtamer vessel"
	tags = list("External")
	uses_species_whitelist = TRUE
	spawnpoints = list("voidtamer_captain")
	max_count = 1
	outfit = /obj/outfit/admin/voidtamer_crew/captain
	assigned_role = "Voidtamer Captain"
	special_role = "Voidtamer Captain"

/obj/outfit/admin/voidtamer_crew/captain
	name = "Voidtamer Captain"
	uniform = /obj/item/clothing/under/gearharness
	suit = /obj/item/clothing/accessory/poncho/voidtamer
	head = /obj/item/clothing/head/diona/voidtamer
	back = /obj/item/storage/backpack/satchel/leather
	id = /obj/item/card/id/voidtamer
	l_ear = /obj/item/device/radio/headset/ship
	backpack_contents = list(/obj/item/device/flashlight/survival = 1)

//items
/obj/item/card/id/voidtamer
	name = "voidtamer ship id"
	access = list(ACCESS_VOIDTAMER_SHIP, ACCESS_EXTERNAL_AIRLOCKS)


