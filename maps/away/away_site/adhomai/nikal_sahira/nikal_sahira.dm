/datum/map_template/ruin/away_site/nikal_sahira
	name = "Nikal Sahira"
	description = "placeholder"

	prefix = "away_site/adhomai/nikal_sahira/"
	suffix = "nikal_sahira.dmm"
	id = "nikal_sahira"

	sectors = list(SECTOR_SRANDMARR)
	template_flags = TEMPLATE_FLAG_PORT_SPAWN
	//template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	spawn_weight = 1
	spawn_cost = 1

	exoplanet_atmospheres = list(/datum/gas_mixture/earth_chill)
	exoplanet_lightlevel = list(1, 2, 5, 7)
	exoplanet_lightcolor = list("#8499c8")

	unit_test_groups = list(3)
	traits = list(
		//Z1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = TRUE),
		//Z3
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)
	shuttles_to_initialise = list(
		/datum/shuttle/autodock/multi/lift/crevus_general_store
	)

/singleton/submap_archetype/nikal_sahira
	map = "Nikal Sahira"
	descriptor = "placeholder"

/obj/effect/overmap/visitable/sector/nikal_sahira
	name = "Adhomai - Crevus, Nikal Sahira"
	desc = "placeholder"

	place_near_main = 1 // one tile near the main map
	landing_site = TRUE
	icon_state = "globe2"
	color = "#D6D9DD"
	scanimage = "adhomai.png"
	alignment = "Democratic People's Republic of Adhomai"
	requires_contact = FALSE
	instant_contact = TRUE
	landing_site = TRUE
