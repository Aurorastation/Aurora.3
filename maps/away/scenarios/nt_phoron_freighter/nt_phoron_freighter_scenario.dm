/singleton/scenario/nt_phoron_freighter
	name = "Curios 1.5 - The Maw"
	desc = "And the engine's failed again, all limits of disguise. \
		The Horizon receives a distress call from the NTV Cloud of Light, \
		a tanker destined for Tomorrow's Gate."
	scenario_site_id = "nt_phoron_freighter"

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/nt_phoron_freighter

	roles = list(
		/singleton/role/generic_crew,
	)
	default_outfit = /obj/outfit/admin/generic

	base_area = /area/ship/nt_phoron_freighter

	radio_frequency_name = "NanoTrasen Freight Vessel"

/singleton/scenario_announcements/nt_phoron_freighter
	horizon_announcement_title = "SCC Emergency Announcement"
	horizon_unrestrict_landing_message = "SCCV Horizon. \
		The NTV Cloud of Light has reported engagement with local pirates. You are the \
		nearest combat-capable vessel to assist. Disable the pirate vessel, board and secure \
		the NTV phoron tanker, and ensure the security of stored phoron. \
		The PRAMV Liberation of the People is engaged nearby at the S'rand'marr Bluespace \
		Gate site and is unlikely to be able to assist. \
		Prepare to respond as soon as possible."

	offship_announcement_message = "A NanoTrasen freight vessel, the NTV Cloud of Light, \
		has reported engagement with local pirates. It is likely that a corporate vessel \
		has already been sent to intervene."
