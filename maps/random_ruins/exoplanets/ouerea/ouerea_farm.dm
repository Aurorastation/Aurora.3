/datum/map_template/ruin/exoplanet/ouerea_farm
	name = "Ouerea Aquacultural Center"
	id = "ouerea_farm"
	description = "An enormous industrial farm and aquacultural center, operated by Hephaestus Industries."
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffix = "ouerea_farm.dmm"
	unit_test_groups = list(3)

/area/ouerea_farm
	name = "Ouerea Farm"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/barren
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "The sound of enormous water pipes and the low electrical hum of vast machines can be heard here. Catwalks strech over vast expanses of water. The banners of Hephaestus Industries can be seen, displayed proudly for all to see."

/datum/ghostspawner/human/ouerea_fisher
	name = "Hephaestus Aquaponicist"
	short_name = "ouerea_fisher"
	desc = "Operate an enormous aquacultural farm on Ouerea."
	tags = list("External")
	welcome_message = "You are a guildsman of Hephaestus Industries, working in an aquacultural farm on Ouerea. Raise fish, and work to feed the Hegemony."

	max_count = 4
	spawnpoints = list("ouerea_fisher")
	extra_languages = list(LANGUAGE_UNATHI)
	outfit = /obj/outfit/admin/unathi_fisher
	possible_species = list(SPECIES_UNATHI, SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_SKRELL_AXIORI, SPECIES_VAURCA_WORKER)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Hephaestus Aquacultural Guildsman"
	special_role = "Hephaestus Aquacultural Guildsman"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/unathi_fisher
	uniform = list(
		/obj/item/clothing/under/unathi,
		/obj/item/clothing/under/unathi/huytai,
		/obj/item/clothing/under/unathi/himation,
		/obj/item/clothing/under/unathi/zozo
	)

	shoes = /obj/item/clothing/shoes/workboots
	suit = /obj/item/clothing/accessory/poncho/unathimantle/hephaestus
	back = /obj/item/storage/backpack/satchel/leather

	l_ear = null

	id = /obj/item/card/id
	backpack_contents = list(/obj/item/storage/wallet/random = 1)
	species_shoes = list(
		SPECIES_UNATHI = /obj/item/clothing/shoes/sandals/caligae,
		SPECIES_VAURCA_WORKER = /obj/item/clothing/shoes/vaurca
	)

/obj/outfit/admin/unathi_fisher/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/uniform_color = "[pick("#c4ae04", "#695948", "#dbd9d7")]"
	if(H?.w_uniform)
		H.w_uniform.color = uniform_color
	if(H?.wear_suit)
		H.wear_suit.color = "#2a2b2e"
	if(H?.shoes)
		H.shoes.color = "#423509"
	if(isvaurca(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/vaurca/filter(H), slot_wear_mask)
		var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
		H.internal = preserve
		H.internals.icon_state = "internal1"
		H.equip_or_collect(new /obj/item/reagent_containers/food/snacks/koisbar, slot_in_backpack)
		H.update_body()
