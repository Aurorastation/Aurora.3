/datum/ghostspawner/human/miners_guild
	short_name = "miners_guild"
	name = "Unathi Guild Miner"
	desc = "Crew a Miners' Guild outpost in the sector. Break rocks, earn your paycheck."
	tags = list("External")

	spawnpoints = list("miners_guild")
	max_count = 3

	outfit = /datum/outfit/admin/miners_guild
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Guild Miner"
	special_role = "Guild Miner"
	respawn_flag = null

	uses_species_whitelist = FALSE

/datum/ghostspawner/human/miners_guild/foreman
	short_name = "miners_guild_boss"
	name = "Unathi Guild Foreman"
	desc = "Command a Miners' Guild outpost in the sector. Break rocks, manage your crew, earn your paycheck."
	max_count = 1
	uses_species_whitelist = TRUE
	assigned_role = "Guild Foreman"
	special_role = "Guild Foreman"

/datum/outfit/admin/miners_guild
	uniform = list(/obj/item/clothing/under/unathi, /obj/item/clothing/under/unathi/himation)
	shoes = /obj/item/clothing/shoes/caligae
	suit = /obj/item/clothing/accessory/poncho/unathimantle/miner
	back = /obj/item/storage/backpack/satchel/eng
	l_ear = /obj/item/device/radio/headset/ship
	id = /obj/item/card/id
	backpack_contents = list(/obj/item/storage/box/survival = 1, /obj/item/storage/wallet/random = 1)

/datum/outfit/admin/miners_guild/get_id_access()
	return list(access_generic_away_site, access_external_airlocks)

/datum/outfit/admin/miners_guild/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.w_uniform)
		H.w_uniform.color = pick("#b07810", "#4f3911")
	if(H?.wear_suit)
		H.wear_suit.color = pick("#4f3911", "#292826")