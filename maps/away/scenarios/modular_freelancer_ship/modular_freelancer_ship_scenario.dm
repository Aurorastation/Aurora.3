/singleton/scenario/modular_freelancer_ship
	name = "Freelancer Ship"
	desc = "A freelancer ship drifting in space, with no apparent destination."
	scenario_site_id = "modular_freelancer_ship"

	possible_scenario_types = list(SCENARIO_TYPE_NONCANON, SCENARIO_TYPE_CANON)

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/modular_freelancer_ship

	roles = list(
		/singleton/role/generic_crew,
		/singleton/role/generic_engineer,
		/singleton/role/generic_medical,
		/singleton/role/generic_security,
		/singleton/role/generic_miner,
		/singleton/role/generic_business,
		/singleton/role/generic_mercenary,
	)
	default_outfit = /obj/outfit/admin/generic
	actor_accesses = list(
		/datum/access/modular_freelancer_ship_access,
	)
	radio_frequency_name = "Freelancer Ship"

	base_area = /area/modular_freelancer_ship

/singleton/scenario_announcements/modular_freelancer_ship
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "\
		Greetings, SCCV Horizon. We have observed an unidentified ship drifting in your current sector. \
		You are to investigate and report back of your findings.\
	"
	offship_announcement_message = "\
		An unidentified ship has been located nearby. The coordinates have been registered on the flight deck.\
	"
