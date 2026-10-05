/singleton/scenario/firebase_dinakk
	name = "Curios 3 - Firebase Din'akk"
	desc = "tbd."
	scenario_site_id = "firebase_dinakk"

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/firebase_dinakk

	roles = list(
		/singleton/role/generic_crew,
	)
	default_outfit = /obj/outfit/admin/generic

	base_area = /area/firebase_dinakk

	radio_frequency_name = "Din'akk"

/singleton/scenario_announcements/firebase_dinakk
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "tbd."

	offship_announcement_message = "tbd."
