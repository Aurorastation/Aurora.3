/singleton/scenario/crumbling_station
	name = "Commercial Installation #3-29ND"
	desc = "An old, crumbling station."
	scenario_site_id = "crumbling_station"

	scenario_announcements = /singleton/scenario_announcements/crumbling_station

	min_player_amount = 0
	min_actor_amount = 0 //should be 4 todomatt

	roles = list(
		/singleton/role/crumbling_station
	)
	default_outfit = /obj/outfit/admin/generic/crumbling_station_crew

	base_area = /area/crumbling_station

	radio_frequency_name = "Commercial Installation #3-29ND"

/singleton/scenario_announcements/crumbling_station
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "We found this station that *really* sucks ass, make it suck less."

	offship_announcement_message = "Seriously, it's bad. You need to help too."
