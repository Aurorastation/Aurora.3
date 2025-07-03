/datum/map_template/ruin/away_site/burzsia_station
	name = "HICS Etna"
	id = "burzsia_station"
	description = "A landing zone designated by local authorities within an SCC-affiliated spaceport. Accommodations have been made to ensure full visitation of any open facilities present."
	sectors = list(ALL_POSSIBLE_SECTORS)

	traits = list(
		// Civilian docks
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		// Working deck
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE)
	)

	prefix = "away_site/burzsia/hics_etna/"
	suffix = "hics_etna.dmm"

	spawn_weight = 1
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED //change this

	unit_test_groups = list(2)
	shuttles_to_initialise = list(/datum/shuttle/autodock/multi/lift/burzsia_station)

/singleton/submap_archetype/burzsia_station
	map = "burzsia_station"
	descriptor = "A landing zone within Point Verdant city limits."

/obj/effect/overmap/visitable/sector/burzsia_station
	name = "Burzsia - Station Spaceport"
	desc = "placeholder"
	icon_state = null
	scanimage = null
	place_near_main = list(0,0)
	landing_site = TRUE
	alignment = "Coalition of Colonies"
	requires_contact = FALSE
	instant_contact = TRUE

	comms_support = TRUE
	comms_name = "Asset Protection"
	freq_name = "HICS Etna Personnel"
