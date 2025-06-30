/singleton/scenario/swamptown
	name = "Marshland Village"
	desc = "A marshland village."
	scenario_site_id = "swamptown"

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/swamptown

	roles = list(
		/singleton/role/swamptown_crew/villager,
	)
	radio_frequency_name = "Arctic Valley"

	base_area = /area/swamptown

/singleton/scenario_announcements/swamptown
	horizon_announcement_title = "SCC Vessel Sensor Relay Network"
	horizon_unrestrict_landing_message = "Greetings, SCCV Horizon. A small village in a marshy valley on a nearby humid exoplanet has been detected in your sector. Attempts to contact them have failed and you are encouraged to try and make contact and see if they require any humanitarian help."

	offship_announcement_message = "A small village in a marshy valley on a nearby humid exoplanet has been detected in your sector. The coordinates have been registered on the flight deck."

/singleton/role/swamptown_crew/villager
	name = "Villager"
	desc = "WHAT ARE YOU DOING IN MY SWAMP"
