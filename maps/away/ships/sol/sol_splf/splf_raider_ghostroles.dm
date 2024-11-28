/datum/ghostspawner/human/splf_crewman
	name = "SPLF Crewman"
	short_name = "splf_crewman"
	desc = "Ra-ra, fight the machine."
	tags = list("External")

	spawnpoints = list("splf_crewman")
	max_count = 4

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
	id = /obj/item/card/id/white
	accessory = /obj/item/clothing/accessory/holster/hip
	l_ear = /obj/item/device/radio/headset/ship
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/melee/energy/sword/knife/sol = 1)

/obj/outfit/admin/splf_crewman/get_id_access()
	return list(ACCESS_SPLF, ACCESS_EXTERNAL_AIRLOCKS)

// ------------ IPC
/datum/ghostspawner/human/splf_ipc
	short_name = "splf_ipc"
	name = "SPLF Auxiliary Synthetic"
	desc = ""
	tags = list("External")

	spawnpoints = list("splf_ipc")
	max_count = 1

	outfit = /obj/outfit/admin/splf_ipc
	possible_species = list(SPECIES_IPC, SPECIES_IPC_SHELL, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION)
	uses_species_whitelist = TRUE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "SPLF Auxiliary Synthetic"
	special_role = "SPLF Auxiliary Synthetic"
	respawn_flag = null

/obj/outfit/admin/splf_ipc
	name = "SPLF Auxiliary Synthetic"

	uniform = /obj/item/clothing/under/rank/sol/ipc
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel/eng
	belt = /obj/item/storage/belt/utility/full
	id = /obj/item/card/id/white
	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/obj/outfit/admin/splf_ipc/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = IPC_OWNERSHIP_PRIVATE
		tag.citizenship_info = CITIZENSHIP_NONE

/obj/outfit/admin/splf_ipc/get_id_access()
	return list(ACCESS_SPLF, ACCESS_EXTERNAL_AIRLOCKS)
// ------------
