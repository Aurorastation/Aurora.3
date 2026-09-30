/datum/map_template/ruin/away_site/nt_phoron_freighter
	name = "NanoTrasen Freight Vessel"
	description = "A NanoTrasen freight vessel, loaded with valuable phoron."

	prefix = "scenarios/nt_phoron_freighter/"
	suffix = "nt_phoron_freighter.dmm"

	sectors = list(ALL_POSSIBLE_SECTORS)
	spawn_weight = 1

	ship_cost = 1
	id = "nt_phoron_freighter"

	unit_test_groups = list(3)

/singleton/submap_archetype/nt_phoron_freighter
	map = "NanoTrasen Freight Vessel"
	descriptor = "A NanoTrasen freight vessel, loaded with valuable phoron."

/obj/effect/overmap/visitable/ship/nt_phoron_freighter
	name = "NanoTrasen Freight Vessel"
	class = "NTV"
	desc = "This is a standard NanoTrasen freighter. Given its small size and apparent ease of maneuverability, \
		it is likely to be carrying a valuable cargo - not improbably, solid or gaseous phoron."
	icon_state = "freighter_large"
	moving_state = "freighter_large_moving"
	colors = list("#8b94df", "#7fa5db")
	max_speed = 1/(2 SECONDS)
	burn_delay = 1 SECONDS
	vessel_mass = 5000
	fore_dir = SOUTH
	vessel_size = SHIP_SIZE_SMALL
	designer = "NanoTrasen"
	volume = "76 meters length, 19 meters beam/width, 17 meters vertical height"
	drive = "Low Power Bluespace Drive"
	sizeclass = "Ulysses-class Hauler"
	shiptype = "Intra-system high-value freight"

	initial_generic_waypoints = list(
		"nt_phoron_freighter_nav1",
		"nt_phoron_freighter_nav2",
		"nt_phoron_freighter_nav3",
		"nt_phoron_freighter_nav4",
		"nt_phoron_freighter_dock1",
		"nt_phoron_freighter_dock2",
		"nt_phoron_freighter_dock3",
		"nt_phoron_freighter_dock4",
		"nt_phoron_freighter_dock5",
		"nt_phoron_freighter_dock6",
	)

	invisible_until_ghostrole_spawn = FALSE

/obj/effect/overmap/visitable/ship/nt_phoron_freighter/New()
	designation = "Cloud of Light"
	..()
