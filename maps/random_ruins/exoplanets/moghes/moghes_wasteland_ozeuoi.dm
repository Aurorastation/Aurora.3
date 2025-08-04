/datum/map_template/ruin/exoplanet/moghes_wasteland_ozeuoi
	name = "Ozeuoi Clan Outpost"
	id = "moghes_wasteland_ozeuoi"
	description = "An outpost of the Clan Ozeuoi"

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_wasteland_ozeuoi.dmm"
	unit_test_groups = list(1)

/area/moghes_ozeuoi
	name = "Clan Ozeuoi Outpost"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "A ramshackle fortress, built from scrap and hope. Automated turrets line the walls, swivelling in search of targets."

/datum/ghostspawner/human/moghes_ozeuoi
	name = "Ozeuoi Clan Outpost Survivor"
	short_name = "moghes_ozeuoi"
	desc = "Survive the Wasteland as a member of the Clan Ozeuoi, known as the Architects due to their affinity for salvage and construction."
	tags = list("External")
	mob_name_suffix = " Ozeuoi"
	mob_name_pick_message = "Pick an Unathi first name."
	welcome_message = "You are an Unathi of the Clan Ozeuoi, one of the Oasis Clans of the Wasteland. Work beside your clanmates, in the hopes of surviving another day."

	max_count = 3
	spawnpoints = list("moghes_ozeuoi")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_ozeuoi
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Ozeuoi Clan Member"
	special_role = "Ozeuoi Clan Member"
	respawn_flag = null
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/moghes_ozeuoi/leader
	name = "Ozeuoi Clan Outpost Leader"
	short_name = "moghes_ozeuoi_leader"
	desc = "Lead your outpost in the Wasteland as an influential member of the Clan Ozeuoi, known as the Architects due to their affinity for salvage and construction."

	max_count = 1
	spawnpoints = list("moghes_ozeuoi")

	assigned_role = "Ozeuoi Outpost Leader"
	special_role = "Ozeuoi Outpost Leader"
	uses_species_whitelist = TRUE

/obj/outfit/admin/moghes_ozeuoi
	uniform = /obj/item/clothing/under/color/lightbrown
	accessory = /obj/item/clothing/accessory/storage/brown_vest
	shoes = /obj/item/clothing/shoes/sandals/caligae
	back = /obj/item/storage/backpack/industrial
	l_ear = null
	id = /obj/item/card/id
	glasses = /obj/item/clothing/glasses/safety/goggles/wasteland

/obj/outfit/admin/moghes_ozeuoi/get_id_access()
	return list(ACCESS_OZEUOI)
