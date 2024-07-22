/datum/map_template/ruin/exoplanet/ouerea_freewater
	name = "Ouerea Freewater Camp"
	id = "ouerea_freewater"
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffix = "ouerea_freewater.dmm"
	unit_test_groups = list(2)

/area/ouerea_freewater
	name = "Freewater Camp"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "A fortified encampment, with the signs of training equipment everywhere. A green banner displaying a red-and-gold eye flies above the central building."

/datum/ghostspawner/human/ouerea_freewater
	name = "Dagamuir Freewater Contractor"
	short_name = "ouerea_freewater"
	desc = "Train in the wilderness and look for mercenary work on the planet Ouerea."
	tags = list("External")
	welcome_message = "You are a mercenary of the Dagamuir Freewater Private Forces, at a camp on Ouerea. Listen to your commander, look for paying work and keep yourself alive."

	extra_languages = list(LANGUAGE_UNATHI)
	max_count = 4

	spawnpoints = list("ouerea_freewater")
	possible_species = list(SPECIES_UNATHI, SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_VAURCA_WARRIOR)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	outfit = /obj/outfit/admin/freewater

	assigned_role = "Dagamuir Freewater Contractor"
	special_role = "Dagamuir Freewater Contractor"
	respawn_flag = null
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/ouerea_freewater/boss
	name = "Dagamuir Freewater Commander"
	short_name = "ouerea_freewater_boss"
	desc = "Oversee a Dagamuir Freewater outpost on the planet Ouerea"

	max_count = 1
	spawnpoints = list("ouerea_freewater_boss")
	possible_species = list(SPECIES_UNATHI)
	assigned_role = "Dagamuir Freewater Commander"
	special_role = "Dagamuir Freewater Commander"
	uses_species_whitelist = TRUE

/obj/outfit/admin/freewater
	name = "Dagamuir Freewater Contractor"
	uniform = /obj/item/clothing/under/rank/security/pmc/dagamuir_freewater
	shoes = /obj/item/clothing/shoes/sandals/caligae
	id = /obj/item/card/id/pmc
	back = /obj/item/storage/backpack/rucksack
	l_pocket = /obj/item/storage/wallet/random
	l_ear = null
	species_shoes = list(
		SPECIES_VAURCA_WARRIOR = /obj/item/clothing/shoes/vaurca
	)

/obj/outfit/admin/freewater/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		H.update_body()

