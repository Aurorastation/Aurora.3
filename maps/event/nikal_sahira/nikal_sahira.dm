/datum/map/event/nikal_sahira
	name = "Nikal Sahira"
	full_name = "Nikal Sahira"
	description = "Nikal Sahira, A Port of Call district of Crevus."
	path = "event/nikal_sahira"
	traits = list(
		list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = TRUE),
		list(ZTRAIT_STATION = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)
	lobby_icons = list('icons/misc/titlescreens/aurora/tajara.dmi')
	use_overmap = TRUE
	default_sector = SECTOR_SRANDMARR
	force_spawnpoint = TRUE
	allowed_spawns = list("Living Quarters Lift")
	spawn_types = list(/datum/spawnpoint/living_quarters_lift)
	default_spawn = "Living Quarters Lift"
	station_name = "Nikal Sahira"
	station_short = "Nikal Sahira"
	dock_name = "Crevus"
	dock_short = "Crevus"
	boss_name = "Nikal Sahira Port Authority"
	company_name = "Orion Express"
	company_short = "Orion"
	station_type = "district"
	allowed_jobs = list(/datum/job/visitor)
	//overmap_visitable_type = /obj/effect/overmap/visitable/sector/nikal_sahira

	// copy-paste from /datum/map/event
	shuttle_call_restarts = TRUE
	shuttle_called_message = "OOC NOTE: The round will restart in ten minutes, unless the crew transfer is recalled."
	shuttle_recall_message = "OOC NOTE: The round will no longer restart."

/datum/map/event/nikal_sahira/build_away_sites()
	// no other candidates
	return

/datum/map_template/ruin/away_site/nikal_sahira
	name = "Nikal Sahira"
	description = "Nikal Sahira, A Port of Call district of Crevus."
	prefix = "../event/nikal_sahira/"
	suffix = "nikal_sahira.dmm"
	id = "nikal_sahira"

	sectors = list(SECTOR_SRANDMARR)
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
