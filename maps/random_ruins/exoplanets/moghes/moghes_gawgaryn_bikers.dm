/datum/map_template/ruin/exoplanet/moghes_gawgaryn_bikers
	name = "Gawgaryn Raiders"
	id = "moghes_gawgaryn_bikers"
	description = "A group of Gawgaryn raiders on sandbikes."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffixes = list("moghes_gawgaryn_bikers.dmm")
	ban_ruins = list(/datum/map_template/ruin/exoplanet/moghes_gawgaryn_riders)
	unit_test_groups = list(1)

/area/moghes_gawgaryn_bikers
	name = "Gawgaryn Raider Camp"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "The smell of blood, cooking meat, and fuel lingers in the air here."

/datum/ghostspawner/human/moghes_gawgaryn_biker
	name = "Gawgaryn Raider"
	short_name = "moghes_gawgaryn_biker"
	desc = "Survive as Gawgaryn, punished and exiled in the harsh wastelands. Take what you can, to eke out another day of survival upon the pitiless sand."
	tags = list("External")
	mob_name_suffix = " Gawgaryn"
	mob_name_pick_message = "Pick an Unathi first name."
	welcome_message = "You are a raider of the clan Gawgaryn. Stripped of your honor and declared a criminal by the Izweski, there is nothing you will not do to survive in the Wasteland."

	max_count = 3
	spawnpoints = list("moghes_gawgaryn_biker")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_gawgaryn
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Gawgaryn Raider"
	special_role = "Gawgaryn Raider"
	respawn_flag = null
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/moghes_gawgaryn_biker_leader
	name = "Gawgaryn Raid Leader"
	short_name = "moghes_gawgaryn_biker_boss"
	desc = "Lead your group of Gawgaryn, punished and exiled in the harsh wastelands. Take what you can, to eke out another day of survival upon the pitiless sand."
	tags = list("External")
	mob_name_suffix = " Gawgaryn"
	mob_name_pick_message = "Pick an Unathi first name."
	welcome_message = "You are a raider of the clan Gawgaryn. Stripped of your honor and declared a criminal by the Izweski, there is nothing you will not do to survive in the Wasteland."

	max_count = 1
	spawnpoints = list("moghes_gawgaryn_biker_boss")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_gawgaryn/leader
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Gawgaryn Raid Leader"
	special_role = "Gawgaryn Raid Leader"
	respawn_flag = null
	uses_species_whitelist = FALSE

/obj/outfit/admin/moghes_gawgaryn
	name = "Gawgaryn Raider"

	uniform = /obj/item/clothing/under/unathi
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/random/civgun = 1)
	suit = list(/obj/item/clothing/suit/unathi/robe, /obj/item/clothing/suit/unathi/robe/kilt)
	back = /obj/item/storage/backpack/satchel/leather
	shoes = /obj/item/clothing/shoes/sandals/caligae
	glasses = /obj/item/clothing/glasses/safety/goggles/wasteland
	id = null
	l_ear = null

/obj/outfit/admin/moghes_gawgaryn/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H.w_uniform)
		H.w_uniform.color = pick("#42330f", "#DBC684")
	if(H.wear_suit)
		H.wear_suit.color = pick("#42330f", "#DBC684")

/obj/outfit/admin/moghes_gawgaryn/leader
	name = "Gawgaryn Raid Leader"

	uniform = /obj/item/clothing/under/unathi/zazali
	accessory = /obj/item/clothing/accessory/holster/hip
	accessory_contents = list(/obj/item/gun/projectile/pistol/spitter = 1)
	suit = /obj/item/clothing/suit/armor/unathi
	backpack_contents = list(/obj/item/ammo_magazine/spitterpistol = 1, /obj/item/melee/hammer/powered = 1)
	head = /obj/item/clothing/head/helmet/unathi
	suit_accessory = /obj/item/clothing/accessory/poncho
	belt = /obj/item/material/knife/tacknife

/obj/outfit/admin/moghes_gawgaryn/leader/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!H)
		return
	if(H.w_uniform)
		H.w_uniform.color = pick("#42330f", "#DBC684")
