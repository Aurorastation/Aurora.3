/singleton/scenario/bastion_station
	name = "Bastion Station"
	desc = "\
		An old solarian defense station with a design dating back to the Interstellar War has been detected online. \
		SCCV Horizon, the closest ship in this sector, was sent by CC to investigate. \
		"
	scenario_site_id = "bastion_station"

	min_player_amount = 15
	min_actor_amount = 6

	scenario_announcements = /singleton/scenario_announcements/bastion_station
// FIX THE ADD THIS'S BUTTERROBBER202!!!
	roles = list(
		/singleton/role/bastion_station
		/singleton/role/bastion_station/sec
		/singleton/role/bastion_station/engi
		/singleton/role/bastion_station/med
		/singleton/role/bastion_station/officer
		/singleton/role/bastion_station/pilot
		/singleton/role/bastion_station/captain
	)
	default_outfit = /obj/outfit/admin/generic/bastion_station_crew

	base_area = /area/bastion_station

	radio_frequency_name = "Bastion Station"

/singleton/scenario_announcements/bastion_station
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "\
		Greetings, SCCV Horizon. A nearby military station has come to our attention. \
		The disposition of the station is unknown, approach with caution. \
		You are to investigate, and learn who is in control of the station. \
		"

	offship_announcement_message = "A nearby military station has launched a warning beacon. The coordinates have been registered on the flight deck."
