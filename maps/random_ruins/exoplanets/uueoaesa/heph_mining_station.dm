/datum/map_template/ruin/exoplanet/heph_mining_station
	name = "Hephaestus Mining Station"
	id = "heph_mining_station"
	description = "A Hephaestus Industries mining station on one of Uueoa-Esa's minor celestial bodies."
	sectors = list(SECTOR_UUEOAESA)
	prefix = "uueoaesa/"
	suffixes = list("heph_mining_station.dmm")
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	spawn_cost = 2
	ban_ruins = list(/datum/map_template/ruin/exoplanet/miners_guild_outpost)

/area/heph_mining_station
	name = "Hephaestus Mining Station"
	icon_state = "bluenew"
	requires_power = TRUE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	ambience = AMBIENCE_EXPOUTPOST

/area/heph_mining_station/mining
	name = "Hephaestus Mining Station - Processing"
	icon_state = "mining"

/area/heph_mining_station/mess
	name = "Hephaestus Mining Station - Mess Hall"
	icon_state = "cafeteria"

/area/heph_mining_station/medbay
	name = "Hephaestus Mining Station - Medical"
	icon_state = "medbay"

/area/heph_mining_station/entry
	name = "Hephaestus Mining Station - Entry"
	icon_state = "exit"

/area/heph_mining_station/engineer
	name = "Hephaestus Mining Station - Engineering"
	icon_state = "outpost_engine"

/area/heph_mining_station/quarters
	name = "Hephaestus Mining Station - Crew Quarters"
	icon_state = "crew_quarters"

/area/heph_mining_station/equipmentstorage
	name = "Hephaestus Mining Station - Equipment Storage"
	icon_state = "security"

/area/heph_mining_station/eva
	name = "Hephaestus Mining Station - EVA Storage"
	icon_state = "eva"

/area/heph_mining_station/storage
	name = "Hephaestus Mining Station - General Storage"
	icon_state = "machinist_workshop"

/datum/ghostspawner/human/heph_space_miner
	name = "Hephaestus Miner"
	short_name = "heph_space_miner"
	desc = "Work as a miner for Hephaestus Industries on a planetary station."
	tags = list("External")
	welcome_message = "You are a Hephaestus Industries miner, working on an outpost on one of Uueoa-Esa's smaller celestial bodies. Mine the planet or asteroid you find yourself on."

	spawnpoints = list("heph_space_miner")
	max_count = 3

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_heph_miner
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/heph_space_miner/klax
	name = "Hephaestus K'laxan Miner"
	short_name = "heph_klax_space_miner"
	max_count = 1

	extra_languages = list(LANGUAGE_VAURCA)
	possible_species = list(SPECIES_VAURCA_WORKER, SPECIES_VAURCA_BULWARK)
	outfit = /obj/outfit/admin/moghes_heph_miner/klax
	uses_species_whitelist = TRUE

/obj/outfit/admin/moghes_heph_miner
	name = "Moghes Hephaestus Miner"

	uniform = /obj/item/clothing/under/rank/miner/heph
	shoes = /obj/item/clothing/shoes/workboots/toeless
	back = /obj/item/storage/backpack/satchel/heph
	head = /obj/item/clothing/head/hardhat/green
	suit = /obj/item/clothing/accessory/poncho/unathimantle/hephaestus

	id = /obj/item/card/id/hephaestus

	backpack_contents = list(/obj/item/storage/wallet/random = 1)

/obj/outfit/admin/moghes_heph_miner/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_suit)
		H.wear_suit.color = "#2a2b2e"

/obj/outfit/admin/moghes_heph_miner/get_id_access()
	return list(ACCESS_EXTERNAL_AIRLOCKS, ACCESS_HEPHAESTUS)

/obj/outfit/admin/moghes_heph_miner/klax
	name = "Moghes Hephaestus Miner - K'lax"

	shoes = /obj/item/clothing/shoes/vaurca
	head = null
	mask = /obj/item/clothing/mask/gas/vaurca/filter
	back = /obj/item/storage/backpack/cloak/cargo
	backpack_contents = list(/obj/item/storage/wallet/random = 1, /obj/item/reagent_containers/food/snacks/koisbar_clean = 3)

/obj/outfit/admin/moghes_heph_miner/klax/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(H?.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
	if(H?.wear_suit)
		H.wear_suit.color = "#2a2b2e"
	var/obj/item/organ/A = new /obj/item/organ/internal/augment/language/klax(H)
	var/obj/item/organ/external/affected = H.get_organ(A.parent_organ)
	A.replaced(H, affected)
	var/obj/item/organ/B = new /obj/item/organ/internal/augment/tool/drill(H)
	var/obj/item/organ/external/affectedB = H.get_organ(B.parent_organ)
	B.replaced(H, affectedB)
	H.update_body()
