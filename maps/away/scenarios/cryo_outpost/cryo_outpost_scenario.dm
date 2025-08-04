/singleton/scenario/cryo_outpost
	name = "Cryo Outpost #187-D"
	desc = "An illegal cloning outpost on a desert oasis planet, that has just been noticed by megacorporations to be stealing proprietary tech. \
			SCCV Horizon, the closest ship in this sector, was dispatched to investigate."
	scenario_site_id = "cryo_outpost"

	min_player_amount = 0
	min_actor_amount = 0

	scenario_announcements = /singleton/scenario_announcements/cryo_outpost

	roles = list(
		/singleton/role/cryo_outpost,
		/singleton/role/cryo_outpost/mercenary,
		/singleton/role/cryo_outpost/mercenary/medic,
		/singleton/role/cryo_outpost/mercenary/engineer,
		/singleton/role/cryo_outpost/director,
		/singleton/role/cryo_outpost/scientist,
		/singleton/role/cryo_outpost/engineer,
	)
	default_outfit = /obj/outfit/admin/generic/cryo_outpost_crew
	actor_accesses = list(/datum/access/cryo_outpost_access)

	base_area = /area/cryo_outpost

	radio_frequency_name = "#187-D Outpost"

/singleton/scenario_announcements/cryo_outpost
	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_unrestrict_landing_message = "Greetings, SCCV Horizon. There's been some proprietary Zeng-Hu tech reported missing from nearby corporate facilities, \
	recently tracked down to a planet, Juliett-Enderly, located in your current sector. You are the closest to this planet, and should investigate and \
	recover any stolen tech, if any is found. Approach with caution, but heavy resistance is not expected, as monitored ship traffic is light around here. \
	Landing sites have been registered and cleared, you may now depart to the planet."

	offship_announcement_message = "An unidentified outpost has been located nearby. The coordinates have been registered on the flight deck."

/singleton/role/cryo_outpost
	name = "Mercenary Team Lead"
	desc = "You are the leader of a mercenary detachment found in the outpost. Your team could have been an independent mercenary company contracted \
			to take this secret Zeng-Hu base, or you could've just found it yourselves. You are equipped with a Heavy Sol Marine's gear."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/mercenary/leader

/singleton/role/cryo_outpost/mercenary
	name = "Mercenary"
	desc = "You are part of a mercenary detachment that has occupied this outpost - either because you were contracted by someone, or because you simply \
			found this place. Some of these Zeng-Hu secrets could sell for a pretty penny... Your creativity's the limit! You are equipped with \
			a Mercenary Freelancer's gear."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/mercenary

/singleton/role/cryo_outpost/mercenary/medic
	name = "Mercenary Combat Medic"
	desc = "You are part of a mercenary detachment that has occupied this outpost - either because you were contracted by someone, or because you simply \
			found this place. You, unlike others, are mainly worried with keeping everyone alive. You are equipped with \
			a Mercenary Freelancer Medic's gear."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/mercenary/medic

/singleton/role/cryo_outpost/mercenary/engineer
	name = "Mercenary Combat Engineer"
	desc = "You are part of a mercenary detachment that has occupied this outpost - either because you were contracted by someone, or because you simply \
			found this place. You, unlike others, are mainly worried with keeping the power up and building fortifications. You are equipped with \
			a Mercenary Freelancer Engineer's gear."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/mercenary/engineer

/singleton/role/cryo_outpost/director
	name = "Outpost Director"
	desc = "You are the director of this outpost. You were tasked with making profit using the stolen proprietary cloning tech. Things seem to have gone bad, however, \
			and it's up to you to figure out what to do next. One thing is clear - you hold a trove of information that any corporation or mercenary would be \
			thrilled to get out of you."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/director

/singleton/role/cryo_outpost/scientist
	name = "Outpost Scientist"
	desc = "You are a scentist tasked with making profit using the stolen proprietary cloning tech. You are equipped with a Zeng-Hu scientist's gear."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/scientist

/singleton/role/cryo_outpost/engineer
	name = "Outpost Engineer"
	desc = "You are an engineer in charge of keeping the outpost functioning. Luckily, your utility to someone else might be what saves your skin \
			this time around..."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/engineer
