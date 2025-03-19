/datum/map_template/ruin/exoplanet/moghes_wasteland_village
	name = "Moghes Abandoned Village"
	id = "wasteland_village"
	description = "The ruins of an Unathi settlement, lost to the Wasteland."
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_wasteland_village.dmm"
	unit_test_groups = list(2)

/area/moghes_wasteland_village
	name = "Abandoned Village"
	icon_state = "blue2"
	requires_power = FALSE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/desert
	area_flags = AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "The wind whistles hollowly through the ruins of this long-forgotten settlement."

/area/moghes_wasteland_village
	name = "Abandoned Shrine"
	icon_state = "red"
	requires_power = FALSE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/desert
	is_outside = OUTSIDE_NO
	area_blurb = "Dust and sand chokes the inside of this old village shrine. A faint scent of must and old blood permeates the air."
