/datum/map_template/ruin/exoplanet/moghes_kataphract_wasteland
	name = "Kataphract Training"
	id = "moghes_kataphract_wasteland"
	description = "A group of Kataphract-Hopefuls, training for survival in the Wasteland."
	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_kataphract_wasteland.dmm"
	ban_ruins = list(/datum/map_template/ruin/exoplanet/moghes_wasteland_izweski)
	unit_test_groups = list(1)

/area/moghes/kataphract_wasteland
	name = "Kataphract Campsite"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS

/area/moghes/kataphract_wasteland/tent
	name = "Kataphract Campsite Tent"
	icon_state = "red"
	is_outside = OUTSIDE_NO
	base_turf = /turf/simulated/floor/exoplanet/desert

/datum/ghostspawner/human/moghes_kataphract_wasteland
	name = "Wasteland Kataphract-Hopeful"
	short_name = "moghes_kataphract_wasteland"
	desc = "A Zo'saa (squire) of the Kataphract Guild, undergoing survival training in the Wasteland. Stand by your brothers-in-arms, act with honor, and obey your Saa (knight)."
	spawnpoints = list("moghes_kataphract_wasteland")
	req_perms = null
	max_count = 3
	uses_species_whitelist = FALSE
	welcome_message = "You are a Kataphract-Hopeful - a squire, undergoing harsh survival training in the Wasteland. Strive to uphold the Warrior's Code, listen to your instructor, and seek to prove your worthiness to become a full Kataphract."

	mob_name_prefix = "Zosaa "
	mob_name_pick_message = "Pick an Unathi last name."

	outfit = /obj/outfit/admin/kataphract/wasteland
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Kataphract-Hopeful"
	special_role = "Kataphract-Hopeful"
	respawn_flag = null
	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)

/datum/ghostspawner/human/moghes_kataphract_wasteland/knight
	name = "Wasteland Kataphract Knight"
	short_name = "moghes_kataphract_wasteland_knight"
	max_count = 1
	uses_species_whitelist = TRUE

	mob_name_prefix = "Saa "
	mob_name_pick_message = "Pick an Unathi last name."
	welcome_message = "You are a warrior of the Kataphract Guild, assigned to train and protect a group of Hopefuls in the harshness of the Wasteland. Seek to test them on their prowess and honor, and instruct them on the meaning of being a Kataphract. Try not to get them killed, though."

	outfit = /obj/outfit/admin/kataphract/knight/wasteland
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Kataphract Knight"
	special_role = "Kataphract Knight"
	respawn_flag = null
	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)

/obj/outfit/admin/kataphract/wasteland
	glasses = /obj/item/clothing/glasses/safety/goggles/tactical/generic
	l_ear = null

/obj/outfit/admin/kataphract/knight/wasteland
	glasses = /obj/item/clothing/glasses/safety/goggles/tactical/generic
	l_ear = null
