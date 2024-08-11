/datum/map_template/ruin/exoplanet/moghes_heph_mining
	name = "Hephaestus Mining Camp"
	id = "moghes_heph_mining"
	description = "A Hephaestus Industries mining facility in the Untouched Lands"
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_heph_mining.dmm"
	ban_ruins = list(/datum/map_template/ruin/exoplanet/moghes_guild_mining)

	unit_test_groups = list(1)

/area/moghes_heph_mining
	name = "Hephaestus Mining Camp"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/grass/moghes/dirt
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "The faint sounds of heavy machinery can be heard - the whirring of drills, the quiet noise of conveyor belts, and the electrical hum of power cables."

/datum/ghostspawner/human/moghes_heph_miner
	name = "Hephaestus Miner"
	short_name = "moghes_heph_miner"
	desc = "Work as a miner for Hephaestus Industries on Moghes."
	tags = list("External")
	welcome_message = "You are a miner working for Hephaestus Industries, in the Untouched Lands of Moghes. Break rocks, earn your paycheck."

	spawnpoints = list("moghes_heph_miner")
	max_count = 3

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_heph_miner
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/moghes_heph_miner/klax
	name = "Hephaestus K'laxan Miner"
	short_name = "moghes_klax_miner"
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
	if(!H)
		return
	if(H.wear_suit)
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
	if(!H)
		return
	if(H.wear_mask && H.species.has_organ[BP_PHORON_RESERVE])
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
	if(H.wear_suit)
		H.wear_suit.color = "#2a2b2e"
	var/obj/item/organ/B = new /obj/item/organ/internal/augment/tool/drill(H)
	var/obj/item/organ/external/affectedB = H.get_organ(B.parent_organ)
	B.replaced(H, affectedB)
	H.update_body()
