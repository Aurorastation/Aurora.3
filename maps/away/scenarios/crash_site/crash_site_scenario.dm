/singleton/scenario/crash_site
	name = "Cryo Outpost #187-D"
	desc = "An illegal cloning outpost on a desert oasis planet, that has just been noticed by megacorporations to be stealing proprietary tech. \
			SCCV Horizon, the closest ship in this sector, was dispatched to investigate."
	scenario_site_id = "crash_site"

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/crash_site

	roles = list(
		/singleton/role/generic_crew,
	)
	default_outfit = /obj/outfit/admin/generic/crash_site_crew
	actor_accesses = list(/datum/access/crash_site_access)

	base_area = /area/crash_site

	radio_frequency_name = "#187-D Outpost"

/singleton/scenario_announcements/crash_site
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "Greetings, SCCV Horizon... (...)"

	offship_announcement_message = "..."
