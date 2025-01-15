/singleton/scenario/enviro_testing_facility
	name = "Environmental Testing Facility Zoya"
	desc = "A environmental testing facility on a barren planet, in a otherwise uninteresting sector. \
			SCCV Horizon, the closest ship in this sector, was dispatched to investigate."
	scenario_site_id = "enviro_testing_facility"

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/enviro_testing_facility

	roles = list(
		// /singleton/role/enviro_testing_facility,
		// /singleton/role/enviro_testing_facility/mercenary,
		// /singleton/role/enviro_testing_facility/mercenary/medic,
		// /singleton/role/enviro_testing_facility/mercenary/engineer,
		// /singleton/role/enviro_testing_facility/director,
		// /singleton/role/enviro_testing_facility/scientist,
		// /singleton/role/enviro_testing_facility/engineer,
	)
	default_outfit = /obj/outfit/admin/generic/enviro_testing_facility_crew

	base_area = /area/enviro_testing_facility

	radio_frequency_name = "Env-Test Facility Zoya"

/singleton/scenario_announcements/enviro_testing_facility
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "\
		Greetings, SCCV Horizon. \
		You are to investigate and report back of your findings.\
		"
	offship_announcement_message = "\
		An unidentified outpost has been located nearby. The coordinates have been registered on the flight deck.\
		"
/*
/singleton/role/enviro_testing_facility
	name = "Mercenary Team Lead"
	desc = "You are the leader of a mercenary detachment found in the outpost. Your team could have been an independent mercenary company contracted \
			to take this secret Zeng-Hu base, or you could've just found it yourselves. You are equipped with a Heavy Sol Marine's gear."
	outfit = /obj/outfit/admin/generic/enviro_testing_facility_crew/mercenary/leader

/singleton/role/enviro_testing_facility/mercenary
	name = "Mercenary"
	desc = "You are part of a mercenary detachment that has occupied this outpost - either because you were contracted by someone, or because you simply \
			found this place. Some of these Zeng-Hu secrets could sell for a pretty penny... Your creativity's the limit! You are equipped with \
			a Mercenary Freelancer's gear."
	outfit = /obj/outfit/admin/generic/enviro_testing_facility_crew/mercenary

/singleton/role/enviro_testing_facility/mercenary/medic
	name = "Mercenary Combat Medic"
	desc = "You are part of a mercenary detachment that has occupied this outpost - either because you were contracted by someone, or because you simply \
			found this place. You, unlike others, are mainly worried with keeping everyone alive. You are equipped with \
			a Mercenary Freelancer Medic's gear."
	outfit = /obj/outfit/admin/generic/enviro_testing_facility_crew/mercenary/medic

/singleton/role/enviro_testing_facility/mercenary/engineer
	name = "Mercenary Combat Engineer"
	desc = "You are part of a mercenary detachment that has occupied this outpost - either because you were contracted by someone, or because you simply \
			found this place. You, unlike others, are mainly worried with keeping the power up and building fortifications. You are equipped with \
			a Mercenary Freelancer Engineer's gear."
	outfit = /obj/outfit/admin/generic/enviro_testing_facility_crew/mercenary/engineer

/singleton/role/enviro_testing_facility/director
	name = "Outpost Director"
	desc = "You are the director of this outpost. You were tasked with making profit using the stolen proprietary cloning tech. Things seem to have gone bad, however, \
			and it's up to you to figure out what to do next. One thing is clear - you hold a trove of information that any corporation or mercenary would be \
			thrilled to get out of you."
	outfit = /obj/outfit/admin/generic/enviro_testing_facility_crew/director

/singleton/role/enviro_testing_facility/scientist
	name = "Outpost Scientist"
	desc = "You are a scentist tasked with making profit using the stolen proprietary cloning tech. You are equipped with a Zeng-Hu scientist's gear."
	outfit = /obj/outfit/admin/generic/enviro_testing_facility_crew/scientist

/singleton/role/enviro_testing_facility/engineer
	name = "Outpost Engineer"
	desc = "You are an engineer in charge of keeping the outpost functioning. Luckily, your utility to someone else might be what saves your skin \
			this time around..."
	outfit = /obj/outfit/admin/generic/enviro_testing_facility_crew/engineer
*/
