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
	horizon_unrestrict_landing_message = "Somebody once told me the world is gonna roll me"

	offship_announcement_message = "I ain't the sharpest tool in the shed"

/singleton/role/swamptown_crew/villager
	name = "Villager"
	desc = "WHAT ARE YOU DOING IN MY SWAMP"
