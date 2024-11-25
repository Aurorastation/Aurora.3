/datum/ghostspawner/human/splf_crewman
	name = "SPLF Crewman"
	short_name = "splf_crewman"
	desc = "Ra-ra, fight the machine."
	tags = list("External")

	spawnpoints = list("splf_crewman")
	max_count = 2

	outfit = /obj/outfit/admin/splf_crewman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SPLF Auxiliary Crew"
	special_role = "SPLF Auxiliary Crew"
	respawn_flag = null

/obj/outfit/admin/splf_crewman
	name = "SPLF Crewman"
	uniform = /obj/item/clothing/under/rank/sol/
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/industrial
	head = /obj/item/clothing/head/sol
	id = /obj/item/card/id/navy
	accessory = /obj/item/clothing/accessory/holster/hip
	l_ear = /obj/item/device/radio/headset/ship
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/splf_crewman/get_id_access()
	return list(ACCESS_SPLF)
