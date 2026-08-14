/singleton/scenario/boneyard
	name = "LDSB-#1 'The Boneyard'"
	desc = "A vast conglomeration of many different objects - some natural, some resembling ships - \
		all mashed together into an incomprehensible complex of pressurised compartments."
	scenario_site_id = "the_boneyard"

	min_player_amount = 0
	min_actor_amount = 0
	possible_scenario_canonicity_types = list(/singleton/canonicity/canon_event)

	scenario_announcements = /singleton/scenario_announcements/boneyard

	base_area = /area/boneyard

	radio_frequency_name = "Boneyard"

/singleton/scenario_announcements/boneyard
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "Landing has been unrestricted; the Horizonls path \
		to the Boneyard is now clear."

	offship_announcement_message = "The Horizon is closing in on the target installation."
