/datum/map_template/ruin/exoplanet/moghes_skakh
	name = "Sk'akh Chapel"
	id = "moghes_skakh"
	description = "A Sk'akh chapel in the Untouched Lands"

	spawn_weight = 1
	spawn_cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_skakh.dmm"

	unit_test_groups = list(3)

/area/moghes_skakh
	name = "Moghes - Sk'akh Chapel"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/grass/moghes/dirt
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "The light of Uueoa-Esa shines dimly through stained-glass windows. The walls are decorated with iconography of a three-headed Unathi, and engraved with Sinta'Unathi scripture."

/datum/ghostspawner/human/moghes_skakh
	name = "Sk'akh Acolyte"
	short_name = "moghes_skakh"
	desc = "Tend to your chapel and assist the priest in administering to the faithful as an acolyte of Sk'akh."
	tags = list("External")
	welcome_message = "You are an acolyte in a chapel of the Sk'akh faith. Assist the priest in administering to the faithful, and try to uphold the tenets of your faith."

	max_count = 2
	spawnpoints = list("moghes_skakh")

	extra_languages = list(LANGUAGE_UNATHI, LANGUAGE_AZAZIBA)
	outfit = /obj/outfit/admin/moghes_skakh
	possible_species = list(SPECIES_UNATHI)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY
	uses_species_whitelist = FALSE

	assigned_role = "Sk'akh Acolyte"
	special_role = "Sk'akh Acolyte"
	respawn_flag = null

/datum/ghostspawner/human/moghes_skakh/priest
	name = "Sk'akh Priest"
	short_name = "moghes_skakh_priest"
	desc = "Tend to your chapel, preach to the faithful, and guide your acolytes in understanding the tenets of Sk'akh."
	welcome_message = "You are a priest of Sk'akh, tending to a small chapel in the Untouched Lands. Guide those who visit your chapel towards understanding of the Great Spirit."

	max_count = 1
	spawnpoints = list("moghes_skakh_priest")
	outfit = /obj/outfit/admin/moghes_skakh
	uses_species_whitelist = TRUE

	assigned_role = "Sk'akh Priest"
	special_role = "Sk'akh Priest"
	respawn_flag = null

/datum/ghostspawner/human/moghes_skakh_worshipper
	name = "Sk'akh Faithful"
	short_name = "moghes_skakh_faithful"
	desc = "Visit a chapel of Sk'akh as a worshipper."
	tags = list("External")
	welcome_message = "You are a faithful Unathi follower of the Sk'akh faith, visiting a nearby temple to hear the priest's words."

	max_count = 3
	possible_species = list(SPECIES_UNATHI)
	spawnpoints = list("moghes_skakh_faithful")
	outfit = /obj/outfit/admin/moghes_bar_patron
	uses_species_whitelist = FALSE

	assigned_role = "Sk'akh Faithful"
	special_role = "Sk'akh Faithful"
	respawn_flag = null

/obj/outfit/admin/moghes_skakh
	name = "Sk'akh Acolyte"
	uniform = /obj/item/clothing/under/unathi/skakh
	shoes = /obj/item/clothing/shoes/sandal
	id = null
	l_ear = null
	back = /obj/item/storage/backpack/satchel/leather
	r_pocket = /obj/item/storage/wallet/random
