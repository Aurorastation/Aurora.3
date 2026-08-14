
// map_template and archetype

/datum/map_template/ruin/away_site/crevus
	name = "Crevus"
	description = "Crevus"

	prefix = "away_site/adhomai/crevus/"
	suffix = "crevus.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	spawn_weight = 1
	spawn_cost = 1
	id = "crevus"

	exoplanet_atmospheres = list(/datum/gas_mixture/earth_standard)
	exoplanet_lightlevel = list(1, 2, 5, 7)
	exoplanet_lightcolor = list("#a6d8fa")

	unit_test_groups = list(1)
	traits = list(
		//Z1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = TRUE),
		//Z3
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)



/singleton/submap_archetype/crevus
	map = "Crevus"
	descriptor = "Crevus"

// overmap visitable

/obj/effect/overmap/visitable/sector/crevus
	name = "Crevus"
	desc = "Crevus"

	place_near_main = list(0,0)
	landing_site = TRUE
	icon_state = "poi"
	color = "#D6D9DD"
