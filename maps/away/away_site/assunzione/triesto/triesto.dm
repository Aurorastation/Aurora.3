/datum/map_template/ruin/away_site/triesto
	name = "Triesto, ZH District - Multipurpose Zoning Area"
	id = "triesto"
	description = "A landing zone designated by local authorities within a ZH-affiliated spaceport. Accommodations have been made to ensure full visitation of any open facilities present."
	sectors = list(SECTOR_ASSUNZIONE)

	traits = list(
		//Z1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	prefix = "away_site/assunzione/triesto/"
	suffix = "triesto.dmm"

	spawn_weight = 1
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_PORT_SPAWN

	unit_test_groups = list(2)

/singleton/submap_archetype/triesto
	map = "triesto"
	descriptor = "A landing zone within one of the Triesto biodomes."

/obj/effect/overmap/visitable/sector/triesto
	name = "Triesto - ZH District Spaceport"
	desc = "A landing zone designated by local authorities within a ZH-affiliated spaceport. Accommodations have been made to ensure full visitation of any open facilities present."
	icon_state = "poi"
	scanimage = "konyang_point_verdant.png"
	place_near_main = list(0,0)
	landing_site = TRUE
	alignment = "Coalition of Colonies"
	requires_contact = FALSE
	instant_contact = TRUE

	comms_support = TRUE
	comms_name = "Zeng-Hu Corporate Security" //these comms should only be used by Konyang Police ghostroles
	freq_name = "ZH Treisto-7-Epsilon Patrol"

	initial_generic_waypoints = list(
		"nav_triesto_altdock_01",
		"nav_triesto_altdock_02",
		"nav_triesto_altdock_03",
		"nav_triesto_altdock_04",
		"nav_triesto_altdock_05",
		"nav_triesto_altdock_06",
	)
	initial_restricted_waypoints = list(
		"Intrepid" = list("nav_triesto_spaceport_intrepid"),
		"Quark" = list("nav_triesto_spaceport_quark"),
		"Spark" = list("nav_triesto_spaceport_spark"),
		"Canary" = list("nav_triesto_spaceport_canary", "nav_triesto_corporate_canary"),
	)
