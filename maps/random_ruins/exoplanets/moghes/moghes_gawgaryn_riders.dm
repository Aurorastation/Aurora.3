/datum/map_template/ruin/exoplanet/moghes_gawgaryn_riders
	name = "Gawgaryn War Riders"
	id = "moghes_gawgaryn_riders"
	description = "A group of Gawgaryn war riders."

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_gawgaryn_riders.dmm"
	ban_ruins = list(/datum/map_template/ruin/exoplanet/moghes_gawgaryn_bikers)
	unit_test_groups = list(2)

/datum/ghostspawner/human/moghes_gawgaryn_rider
	name = "Gawgaryn War Rider"
	short_name = "moghes_gawgaryn_rider"
	desc = "Survive as Gawgaryn, punished and exiled in the harsh wastelands. Take what you can, to eke out another day of survival upon the pitiless sand."
	tags = list("External")
	mob_name_suffix = " Gawgaryn"
	mob_name_pick_message = "Pick an Unathi first name."
	welcome_message = "You are a raider of the clan Gawgaryn. Stripped of your honor and declared a criminal by the Izweski, there is nothing you will not do to survive in the Wasteland."

	max_count = 3
	spawnpoints = list("moghes_gawgaryn_rider")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_gawgaryn
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Gawgaryn War Rider"
	special_role = "Gawgaryn War Rider"
	respawn_flag = null
	uses_species_whitelist = FALSE

/datum/ghostspawner/human/moghes_gawgaryn_rider_leader
	name = "Gawgaryn War Rider Leader"
	short_name = "moghes_gawgaryn_rider_boss"
	desc = "Lead your group of Gawgaryn, punished and exiled in the harsh wastelands. Take what you can, to eke out another day of survival upon the pitiless sand."
	tags = list("External")
	mob_name_suffix = " Gawgaryn"
	mob_name_pick_message = "Pick an Unathi first name."
	welcome_message = "You are a raider of the clan Gawgaryn. Stripped of your honor and declared a criminal by the Izweski, there is nothing you will not do to survive in the Wasteland."

	max_count = 1
	spawnpoints = list("moghes_gawgaryn_rider_boss")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_gawgaryn/leader
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Gawgaryn War Rider Leader"
	special_role = "Gawgaryn War Rider Leader"
	respawn_flag = null
