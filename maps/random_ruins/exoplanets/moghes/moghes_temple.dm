/datum/map_template/ruin/exoplanet/moghes_temple
	name = "Abandoned Temple"
	id = "moghes_temple"
	description = "A seemingly abandoned temple within the Untouched Lands"

	spawn_weight = 1
	spawn_cost = 0.5
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffixes = list("moghes_temple.dmm")


/area/moghes_temple
	name = "Moghes - Abandoned Temple"
	icon_state = "bluenew"
	requires_power = FALSE
	dynamic_lighting = TRUE
	no_light_control = FALSE
	base_turf = /turf/simulated/floor/exoplanet/grass/moghes/dirt
	area_flags = AREA_FLAG_RAD_SHIELDED|AREA_FLAG_INDESTRUCTIBLE_TURFS
	area_blurb = "A seemingly abandoned sandstone structure takes hold here, growth overtaking, wittling away at it. Depictions upon the walls and carvings have been lost to time."

/obj/effect/landmark/corpse/moghes_priest_unknown
	name = "Unknown Priest"
	corpseuniform = /obj/item/clothing/under/unathi/mogazali/blue
	corpseshoes = /obj/item/clothing/shoes/sandals/caligae
	corpsehelmet = /obj/item/clothing/head/unathi/ancienthood
	corpseid = FALSE
	species = SPECIES_UNATHI
