/datum/map_template/ruin/away_site/nikal_sahira
	name = "Nikal Sahira"
	description = "Nikal Sahira, A Port of Call district of Crevus."
	prefix = "away_site/adhomai/nikal_sahira/"
	suffix = "nikal_sahira.dmm"
	id = "nikal_sahira"

	sectors = list(SECTOR_SRANDMARR)
	template_flags = TEMPLATE_FLAG_PORT_SPAWN
	spawn_weight = 1
	spawn_cost = 1

	exoplanet_atmospheres = list(/datum/gas_mixture/earth_slightly_cold)
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
	descriptor = "Nikal Sahira, A Port of Call district of Crevus."

/obj/effect/overmap/visitable/sector/nikal_sahira
	name = "Adhomai - Crevus, Nikal Sahira"
	desc = "\
		Nikal Sahira is a neutral satellite spaceport. Originally constructed by NanoTrasen Corporation for midtown freight and passenger shuttles, \
		the site transferred ownership to Orion Express after its formation. The local region has no official affiliation, although multiple organizations \
		do operate in the district. A few high-class businesses are present to cater to passengers and pilots, alongside a station for the Crevus Suspended Tram Railway. \
		<br><br>The present weather is -8C and 70 cm of snow cover."

	place_near_main = 1 // one tile near the main map
	landing_site = TRUE
	icon_state = "globe2"
	color = "#D6D9DD"
	scanimage = "adhomai.png"
	alignment = "Democratic People's Republic of Adhomai"
	requires_contact = FALSE
	instant_contact = TRUE
	landing_site = TRUE
	comms_support = TRUE

/obj/effect/overmap/visitable/sector/nikal_sahira/create_comms_groups()
	return list(
		"the_lock_attendants" = new /datum/comms_group("casual", "The Lock Attendants"),
		"rhan_cresh_patrol" = new /datum/comms_group("Rhan-Cresh Patrol", "Rhan-Cresh Patrolmen"),
		"azaula_enforcer" = new /datum/comms_group("Azaula Entertainment", "Azaula Entertainment Enforcers"),
		"gang_violet_knuckles" = new /datum/comms_group("shoddy", "Violet Knuckles"),
		"gang_shamtyrs" = new /datum/comms_group("shoddy", "Sham'tyrs")
	)
