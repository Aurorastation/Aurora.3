/datum/map_template/ruin/exoplanet/burzsia_mining
	name = "Hephaestus Burzsia Mining Outpost"
	id = "burzsia_mining"
	description = "A mining outpost operated by Hephaestus Industries."

	spawn_weight = 1
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_BURZSIA)

	prefix = "burzsia/"
	suffix = "burzsia_mining.dmm"

	unit_test_groups = list(1)

/area/burzsia_mining
	name = "Hephaestus Burzsia Mining Outpost"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED
	is_outside = OUTSIDE_NO

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

// Airlock Marker
/obj/effect/map_effect/marker/airlock/burzsia_mining
	name = "Primary Airlock"
	master_tag = "airlock_burzsia_mining_primary"
	cycle_to_external_air = TRUE
	req_one_access = list(ACCESS_GENERIC_AWAY_SITE, ACCESS_EXTERNAL_AIRLOCKS)

//ghost roles

/datum/ghostspawner/human/burzsia_miner
	short_name = "burzsia_miner"
	name = "Hephaestus Burzsia Miner"
	desc = "Extract and process minerals in Burzsia for Hephaestus Industries."
	tags = list("External")

	spawnpoints = list("burzsia_miner")
	max_count = 3

	outfit = /obj/outfit/admin/burzsia_miner
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_DIONA, SPECIES_UNATHI, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_IPC, SPECIES_IPC_G1, SPECIES_IPC_G2, SPECIES_IPC_XION)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Burzsia Miner"
	special_role = "Hephaestus Burzsia Miner"
	respawn_flag = null

/obj/outfit/admin/burzsia_miner
	name = "Hephaestus Burzsia Miner"

	id = /obj/item/card/id/hephaestus
	shoes = /obj/item/clothing/shoes/workboots

	uniform = /obj/item/clothing/under/rank/miner/heph
	head = /obj/item/clothing/head/wool/heph
	l_ear = null
	back = /obj/item/storage/backpack/duffel/heph

	r_pocket = /obj/item/storage/wallet/random
	accessory = /obj/item/clothing/accessory/badge/passcard/burzsia

/obj/outfit/admin/burzsia_miner/get_id_access()
	return list(ACCESS_GENERIC_AWAY_SITE, ACCESS_EXTERNAL_AIRLOCKS)

/obj/outfit/admin/burzsia_miner/post_equip(mob/living/carbon/human/H, visualsOnly)
	var/obj/item/organ/internal/ipc_tag/tag = H.internal_organs_by_name[BP_IPCTAG]
	if(istype(tag))
		tag.serial_number = uppertext(dd_limittext(md5(H.real_name), 12))
		tag.ownership_info = pick(IPC_OWNERSHIP_COMPANY)
		tag.citizenship_info = CITIZENSHIP_NONE

/datum/ghostspawner/human/burzsia_miner/foreman
	short_name = "burzsia_foreman"
	name = "Hephaestus Burzsia Foreman"
	desc = "Overseer the mining operations in Burzsia for Hephaestus Industries."

	spawnpoints = list("burzsia_foreman")
	max_count = 1

	outfit = /obj/outfit/admin/burzsia_miner/foreman
	possible_species = list(SPECIES_HUMAN, SPECIES_HUMAN_OFFWORLD, SPECIES_TAJARA, SPECIES_TAJARA_MSAI, SPECIES_TAJARA_ZHAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_UNATHI)

	assigned_role = "Hephaestus Burzsia Foreman"
	special_role = "Hephaestus Burzsia Foreman"

/obj/outfit/admin/burzsia_miner/foreman
	name = "Hephaestus Burzsia foreman"

	head = /obj/item/clothing/head/beret/corporate/heph

	uniform = /obj/item/clothing/under/rank/miner/heph
	suit = /obj/item/clothing/suit/storage/toggle/corp/heph

	back = /obj/item/storage/backpack/satchel/heph
