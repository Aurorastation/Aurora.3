/datum/map_template/ruin/exoplanet/moghes_village
	name = "Moghes Village"
	id = "moghes_village"
	description = "A rural Unathi village, somewhere in the Untouched Lands."
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_untouched_village.dmm"
	ban_ruins = list("ouerea_village") //literally 90% the same

	unit_test_groups = list(1)


/area/moghes_village
	name = "Moghes Village"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/grass/moghes/dirt
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "A cozy Unathi village. Lights can be seen through the windows of the buildings here, and the smell of cooking fish drifts on the wind."

/area/moghes_village/indoors
	name = "Moghes Village Indoors"
	icon_state = "red"
	is_outside = OUTSIDE_NO
	area_blurb = "The interior of these little houses are comfortable and tightly-packed, built for an entire extended family."

/area/moghes_village/shrine
	name = "Moghes Village Shrine"
	icon_state = "blue2"
	is_outside = OUTSIDE_NO
	area_blurb = "The air inside this shrine is still, every step on the tile feeling louder than it should. The floors and altars are polished to a shine."

/datum/ghostspawner/human/moghes_villager
	name = "Moghresian Villager"
	short_name = "moghes_villager"
	desc = "Live your life in a rural village on Moghes."
	tags = list("External")
	welcome_message = "You are an Unathi peasant in the Untouched Lands of Moghes. Live your life and tend to your fish and fields."

	spawnpoints = list("moghes_villager")
	max_count = 4

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/unathi_village
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Moghresian Villager"
	special_role = "Moghresian Villager"
	respawn_flag = null

	uses_species_whitelist = FALSE

/obj/outfit/admin/unathi_village
	name = "Unathi Villager"

	uniform = list(
		/obj/item/clothing/under/unathi,
		/obj/item/clothing/under/unathi/huytai,
		/obj/item/clothing/under/unathi/himation
	)

	shoes = list(
		/obj/item/clothing/shoes/sandals,
		/obj/item/clothing/shoes/sandals/caligae,
		/obj/item/clothing/shoes/footwraps
	)
	back = /obj/item/storage/backpack/satchel/leather

	l_ear = null

	id = null
	backpack_contents = list(/obj/item/storage/wallet/random = 1)

/obj/outfit/admin/unathi_village/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H.shoes)
		H.shoes.color = "#423509"
