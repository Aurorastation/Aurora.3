// SPLF Crewmen - a loose militia drawn from the system defence forces and volunteers of the Hinterlands, equipped with whatever is available.
/datum/ghostspawner/human/splf_crewman
	name = "SPLF Auxiliary Crewman"
	short_name = "splf_crewman"
	desc = "You are an auxiliary volunteer of the Solarian People's Liberation Fleet, sent abroad from the Hinterlands on a raid to liberate supplies from corporate ownership. Prior to your volunteering you may have been a civilian of any stripe, but your assignment now is singular: take what you need from the corporate oppressors, defer to your liaison officer, and get back home alive. Remember, the corporations are the enemy, not any independents you encounter."
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
// ------------

// Liaison Officer - a petty officer picked from the rogue navy elements from the 35th to command the vessel and its militia.
/datum/ghostspawner/human/splf_crewman/chief
	name = "SPLF Auxiliary Liaison Officer"
	short_name = "splf_chief"
	desc = "You are a petty officer of the Solarian People's Liberation Fleet, and a former member of the 35th Fleet before it entered the Hinterlands, now assigned as a Liasion Officer to command a gaggle of rowdy volunteers in a supply raid into Biesellite territory. Stop the miltia from doing anything stupid, ensure the success of the operation, and get everyone back to their homes intact. Remember, no heroics."

	max_count = 1
	spawnpoints = list("splf_chief")
	outfit = /obj/outfit/admin/splf_crewman/chief
	assigned_role = "SPLF Auxiliary Liaison Officer"
	special_role = "SPLF Auxiliary Liaison Officer"

/obj/outfit/admin/splf_crewman/chief
	name = "SPLF Chief"
	uniform = /obj/item/clothing/under/rank/sol/dress/pettyofficer
	back = /obj/item/storage/backpack/satchel/leather
	head = /obj/item/clothing/head/sol/dress
// ------------

// The IPC is an entirely seperate type to make things easier. Originally civilian synthetics, hastily repurposed.
/datum/ghostspawner/human/splf_ipc
	short_name = "splf_ipc"
	name = "SPLF Auxiliary Synthetic"
	desc = "Plucked from prior civilian ownership in the Hinterlands, you are a synthetic that has been appropriated and hastily repurposed by the Solarian People's Liberation Fleet for its ends. You serve as non-combatant equipment, ensuring the functionality of the ship and the survival of its crew. Whatever you were in your civilian life, you now exist to forward the cause of national liberation - not that it probably means that much to you."
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
	accessory = /obj/item/clothing/accessory/storage/pouches/brown
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
