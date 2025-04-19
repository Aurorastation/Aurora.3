/singleton/scenario/ruined_propellant_depot
	name = "Propellant Depot"
	desc = "\
		An independent propellant depot near some asteroid field, that has launched a distress beacon, requesting help. \
		SCCV Horizon, the closest ship in this sector, was sent by CC to investigate. \
		"

	possible_scenario_types = list(SCENARIO_TYPE_NONCANON, SCENARIO_TYPE_CANON)

	scenario_site_id = "ruined_propellant_depot"

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/ruined_propellant_depot

	roles = list(
		/singleton/role/generic_crew,
		/singleton/role/generic_engineer,
		/singleton/role/generic_research,
		/singleton/role/generic_medical,
		/singleton/role/generic_security,
		/singleton/role/generic_miner,
		/singleton/role/generic_business,
	)
	default_outfit = /obj/outfit/admin/generic
	actor_accesses = list(/datum/access/ruined_propellant_depot_access)
	radio_frequency_name = "Propellant Depot AG5"

	base_area = /area/ruined_propellant_depot

/singleton/scenario_announcements/ruined_propellant_depot
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "\
		Greetings, SCCV Horizon. A nearby propellant depot has launched a distress beacon, requesting help. \
		That depot is independent, but friendly, often serving fuel to corporate ships at a discount. \
		You are to investigate, and provide aid if needed. \
		Docking codes have been provided, you may now dock at will. \
		"

	offship_announcement_message = "A nearby propellant depot has launched a distress beacon. The coordinates have been registered on the flight deck."
