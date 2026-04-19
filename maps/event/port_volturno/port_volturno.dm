/datum/map/event/port_volturno
	name = "Assunzione - Port Volturno"
	path = "event/port_volturno"
	lobby_transitions = 0

	allowed_jobs = list(/datum/job/visitor, /datum/job/passenger)

	traits = list(
		//Z1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_PORTOFCALL = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_PORTOFCALL = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	admin_levels = list()
	contact_levels = list(1,2)
	player_levels = list(1,2)
	accessible_z_levels = list(1,2)
	restricted_levels = list()

	station_name = "Port Volturno"
	station_short = "Port Volturno"
	dock_name = "Port Volturno"
	dock_short = "Port Volturno"
	boss_name = "Stellar Corporate Conglomerate"
	boss_short = "SCC"
	company_name = "Stellar Corporate Conglomerate"
	company_short = "SCC"

	use_overmap = FALSE
	force_spawnpoint = TRUE

	map_shuttles = list()

/datum/map_template/ruin/away_site/port_volturno
	name = "Assunzione - Port Volturno"
	id = "port_volturno"
	description = "A landing zone designated by local authorities within a Zeng-Hu-affiliated spaceport in the planetary capital of Triesto. Accommodations have been made to ensure full visitation of any open facilities present."
	sectors = list(SECTOR_AL_MAQDISI)

	traits = list(
		//Z1
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_PORTOFCALL = TRUE, ZTRAIT_UP = TRUE, ZTRAIT_DOWN = FALSE),
		//Z2
		list(ZTRAIT_AWAY = TRUE, ZTRAIT_PORTOFCALL = TRUE, ZTRAIT_UP = FALSE, ZTRAIT_DOWN = TRUE),
	)

	prefix = "away_site/assunzione/port_volturno/"
	suffix = "port_volturno.dmm"

	spawn_weight = 1
	spawn_cost = 1
	template_flags = TEMPLATE_FLAG_PORT_SPAWN

	unit_test_groups = list(2)

/singleton/submap_archetype/port_volturno
	map = "port_volturno"
	descriptor = "A landing zone within one of the Triesto biodomes."

/obj/effect/overmap/visitable/sector/port_volturno
	name = "Assunzione - Port Volturno"
	desc = "A landing zone designated by local authorities within a Zeng-Hu-affiliated spaceport in the planetary capital of Triesto. Accommodations have been made to ensure full visitation of any open facilities present."
	icon_state = "poi"
	scanimage = "assunzione.png"
	place_near_main = list(0,0)
	landing_site = TRUE
	alignment = "Coalition of Colonies"
	requires_contact = FALSE
	instant_contact = TRUE

	comms_support = TRUE
	comms_name = "Zeng-Hu Corporate Security" //these comms should only be used by ZH Security ghostroles
	freq_name = "ZH Volturno-13-Kappa Patrol"

	initial_generic_waypoints = list()
	initial_restricted_waypoints = list(
		"Intrepid" = list("nav_port_volturno_spaceport_intrepid"),
		"Quark" = list("nav_port_volturno_spaceport_quark"),
		"Spark" = list("nav_port_volturno_spaceport_spark")
	)
