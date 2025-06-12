/singleton/scenario/crumbling_station
	name = "Commercial Installation #3-29ND"
	desc = "An old, crumbling station."
	scenario_site_id = "crumbling_station"

	possible_scenario_types = list(SCENARIO_TYPE_CANON)

	scenario_announcements = /singleton/scenario_announcements/crumbling_station

	min_player_amount = 0
	min_actor_amount = 0

	roles = list(
		/singleton/role/crumbling_station,
		/singleton/role/crumbling_station/engineer,
		/singleton/role/crumbling_station/medic,
		/singleton/role/crumbling_station/security,
		/singleton/role/crumbling_station/administrator,
		/singleton/role/crumbling_station/legal_visitor,
		/singleton/role/crumbling_station/illegal_visitor,
	)

	default_outfit = /obj/outfit/admin/generic/crumbling_station_crew
	actor_accesses = list(/datum/access/crumbling_station_command)

	base_area = /area/crumbling_station

	radio_frequency_name = "Commercial Installation #3-29ND"

/singleton/scenario_announcements/crumbling_station
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "We found this station that *really* sucks ass, make it suck less."

	offship_announcement_message = "Seriously, it's bad. You need to help too."
