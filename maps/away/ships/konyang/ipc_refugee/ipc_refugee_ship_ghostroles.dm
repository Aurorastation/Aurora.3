// Human Refugee
/datum/ghostspawner/human/refugee_crew
	short_name = "refugee_crew"
	name = "Human Refugee"
	desc = "You are a human from the Wildlands crewing a heavily run down freighter carrying a number of IPC refugees."
	tags = list("External")

	welcome_message = "You are a human from the Wildlands crewing a worn down freighter carrying a number of IPC refugees. The journey so far has been catastrophic at best, but you've been making the best of what you've got. Perhaps you've been angling to sell the IPCs off the entire time under the false pretense of leading them to freedom, or perhaps you're more sympathetic to their strife, truly dedicated to helping synthetics find a life of their own."

	spawnpoints = list("refugee_crew")
	max_count = 2

	outfit = /obj/outfit/admin/refugee_crew
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Freighter Crewman"
	special_role = "Human Refugee"
	respawn_flag = null

/obj/outfit/admin/refugee_crew
	name = "Human Refugee"

	uniform = /obj/item/clothing/under/tactical
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/refugee_crew_ship

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/device/radio/map_preset = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/storage/wallet = 1,
		/obj/item/clothing/accessory/badge/passport/sol = 1,
		/obj/item/spacecash/c200 = 1,
		/obj/item/spacecash/c100 = 1
	)

/obj/outfit/admin/refugee_crew/get_id_access()
	return list(ACCESS_EXTERNAL_AIRLOCKS)

// IPC Refugee
/datum/ghostspawner/human/refugee_crew/ipc
	short_name = "refugee_crew_ipc"
	name = "IPC Refugee"
	desc = "You are an IPC refugee, fleeing from the Wildlands onboard a heavily run down freighter in search of a better life."

	welcome_message = "You are an IPC refugee, fleeing from the Wildlands in search of a better life on a journey that has been nothing but perilous at every turn. A number of your synthetic brethren have already perished, but you've come too far to give up on your dreams of freedom now. Do what you must to survive, and maybe you'll reach Konyang or Orepit yet."

	spawnpoints = list("refugee_crew_ipc")
	max_count = 3

	outfit = /obj/outfit/admin/refugee_crew/ipc
	possible_species = list(SPECIES_IPC, SPECIES_IPC_SHELL, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION, SPECIES_IPC_ZENGHU, SPECIES_IPC_BISHOP)
	uses_species_whitelist = TRUE
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Freighter Passenger"
	special_role = "IPC Refugee"


/obj/outfit/admin/refugee_crew/ipc
	name = "IPC Refugee"

	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/device/radio/map_preset = 1,
		/obj/item/device/flashlight = 1,
		/obj/item/storage/wallet = 1
	)

/obj/outfit/admin/refugee_crew/ipc/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = pick(IPC_OWNERSHIP_COMPANY, IPC_OWNERSHIP_PRIVATE) //fleeing solarian wildlands so probably none would be registered as self-owned
		tag.citizenship_info = CITIZENSHIP_NONE

/obj/item/card/id/refugee_crew_ship
	name = "refugee ship id"
	access = list(ACCESS_EXTERNAL_AIRLOCKS)
