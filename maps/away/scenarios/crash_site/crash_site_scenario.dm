/singleton/scenario/crash_site
	name = "Curios 1 - Behind The Curtains"
	desc = "Deep in the snow, twisted metal abound. \
			Peeking through the wreck, knowing what's nearby. \
			The clues start to click, one piece at a time. \
			The Horizon sets off to investigation the wreck of the SCCV Jaunter in the borderlands of Southern Harr'masir."
	scenario_site_id = "crash_site"

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/crash_site

	roles = list(
		/singleton/role/generic_crew,
	)
	default_outfit = /obj/outfit/admin/generic

	base_area = /area/crash_site

	radio_frequency_name = "Din'akk"

/singleton/scenario_announcements/crash_site
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "Greetings, SCCV Horizon..."

	offship_announcement_message = "..."
