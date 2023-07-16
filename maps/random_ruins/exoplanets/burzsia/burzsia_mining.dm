/datum/map_template/ruin/exoplanet/burzsia_mining
	name = "Hephaestus Burzsia Mining Outpost"
	id = "burzsia_mining"
	description = "A camp setup by Tajaran archeologists searching for clues of their planet's past."

	spawn_weight = 1
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_BURZSIA)
	suffixes = list("burzsia/burzsia_mining.dmm")

/area/burzsia_mining
	name = "Hephaestus Burzsia Mining Outpost"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	flags = RAD_SHIELDED

/area/burzsia_mining/mess_hall
	name = "Hephaestus Burzsia Mining Outpost Mess Hall"
	icon_state = "bridge"

/area/burzsia_mining/dormitories
	name = "Hephaestus Burzsia Mining Outpost Dormitories"
	icon_state = "crew_quarters"

/area/burzsia_mining/mining
	name = "Hephaestus Burzsia Mining Outpost Mining"
	icon_state = "mining"

/area/burzsia_mining/engineering
	name = "Hephaestus Burzsia Mining Outpost Engineering"
	icon_state = "outpost_engine"

/area/burzsia_mining/foreman
	name = "Hephaestus Burzsia Mining Outpost Foreman Office"
	icon_state = "anolab"

//ghost roles

/datum/ghostspawner/human/burzsia_miner
	short_name = "burzsia_miner"
	name = "Hephaestus Burzsia Miner"
	desc = "Extract and process minerals in Burzsia for Hephaestus Industries."
	tags = list("External")

	spawnpoints = list("burzsia_miner")
	max_count = 3

	outfit = /datum/outfit/admin/burzsia_miner
	possible_species = list(SPECIES_HUMAN,SPECIES_IPC,SPECIES_IPC_G1, SPECIES_IPC_G2)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Burzsia Miner"
	special_role = "Hephaestus Burzsia Miner"
	respawn_flag = null

/datum/outfit/admin/burzsia_miner
	name = "Hephaestus Burzsia Miner"

	id = /obj/item/card/id/mining
	shoes = /obj/item/clothing/shoes/workboots

	uniform = /obj/item/clothing/under/rank/miner/heph
	head = /obj/item/clothing/head/wool/heph
	l_ear = null
	back = /obj/item/storage/backpack/duffel/heph

	r_pocket = /obj/item/storage/wallet/random
	accessory = /obj/item/clothing/accessory/badge/passcard/burzsia

/datum/outfit/admin/burzsia_miner/get_id_access()
	return list(access_generic_away_site, access_external_airlocks)

/datum/ghostspawner/human/burzsia_miner/foreman
	short_name = "burzsia_foreman"
	name = "Hephaestus Burzsia Foreman"
	desc = "Overseer the mining operations in Burzsia for Hephaestus Industries."

	spawnpoints = list("burzsia_foreman")
	max_count = 1

	outfit = /datum/outfit/admin/burzsia_miner/foreman
	possible_species = list(SPECIES_HUMAN,SPECIES_IPC,SPECIES_IPC_G1, SPECIES_IPC_G2)

	assigned_role = "Hephaestus Burzsia Foreman"
	special_role = "Hephaestus Burzsia Foreman"

/datum/outfit/admin/burzsia_miner/foreman
	name = "Hephaestus Burzsia foreman"

	head = /obj/item/clothing/head/beret/corporate/heph

	uniform = /obj/item/clothing/under/rank/miner/heph
	suit = /obj/item/clothing/suit/storage/toggle/corp/heph

	back = /obj/item/storage/backpack/satchel/heph
