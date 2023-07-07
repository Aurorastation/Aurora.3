//For the placeholder away site itself. None of this should be used for ingame things
//If you don't want or need ghost roles for your away site, you can simply avoid copying this file entirely.
/datum/ghostspawner/human/placeholder_site_crew
	short_name = "placeholder_site_crew"
	name = "Placeholder Crewmember"
	desc = "Crew the placeholder away site."//Visible ingame through the ghost spawner functionality. Should include an apt, but brief description of what to do and expect.
	tags = list("External")

	spawnpoints = list("placeholder_site_crew")
	max_count = 5//The maximum number of slots this has. If in doubt, always ask for extra input on this number!
	assigned_role = "Placeholder Crewmember"
	special_role = "Placeholder Crewmember"
	outfit = /datum/outfit/admin/placeholder_site_crew//This outfit is automagically placed on the player once they spawn in this role. You define the outfit lower in this file!
	allow_appearance_change = APPEARANCE_PLASTICSURGERY//This is accessible only upon spawning and allows the player to set their appearance as they desire.

//	uses_species_whitelist = FALSE//Set to TRUE to restrict this to a specific species whitelist, assuming lore approves of it. Always ask staff before trying this.
//	possible_species = list(SPECIES_TAJARA, SPECIES_IPC)//A list of species you want this role to be. Same as above - ask lore for input
//	extra_languages = list(LANGUAGE_SOL_COMMON)//For any languages you want to make mandatory. Important depending on space sector

	respawn_flag = null//dont touch this if new contributor

/datum/outfit/admin/placeholder_site_crew
	name = "Placeholder Crewmember"

	id = /obj/item/card/id
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/yellow
	uniform = /obj/item/clothing/under/color/orange
	l_ear = /obj/item/device/radio/headset/ship
	belt = /obj/item/storage/belt/utility/very_full
	accessory = /obj/item/clothing/accessory/holster/hip
	r_pocket = /obj/item/storage/wallet/random

//Below are some extra outfit vars if you want to edit them quick.
//	suit = null
//	suit_accessory = null
//	suit_store = null
//	head = null
//	mask = null
//	r_ear = null
//	l_pocket = null
//	glasses = null
//	wrist = null
//	back = null
//	l_hand = null
//	r_hand = null

/datum/outfit/admin/placeholder_site_crew/get_id_access()
	return list(access_external_airlocks)

/datum/ghostspawner/human/placeholder_site_crew/captain
	short_name = "placeholder_site_captain"
	name = "Placeholder Captain"
	desc = "Command the placeholder. Maximize suffering."

	spawnpoints = list("placeholder_site_captain")
	max_count = 1

	outfit = /datum/outfit/admin/placeholder_site_crew/captain

	assigned_role = "Placeholder Captain"
	special_role = "Placeholder Captain"

/datum/outfit/admin/placeholder_site_crew/captain
	name = "Placeholder Captain"

	uniform = /obj/item/clothing/under/color/white
	head = /obj/item/clothing/head/hardhat/white
