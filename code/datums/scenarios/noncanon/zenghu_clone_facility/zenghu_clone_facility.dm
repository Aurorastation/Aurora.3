/singleton/scenario/cryo_outpost
	name = "Zeng-Hu Facility #187-D"
	desc = "A Zeng-Hu Facility has gone dark as of one week ago. The megacorporation has dispatched the Horizon, the closest ship, \
			to investigate, find out the reason, and secure it once again if needed."
	scenario_site_id = "cryo_outpost"

	horizon_announcement_title = "SCC Central Command Outpost"
	horizon_announcement_message = "Greetings, SCCV Horizon. There's been some proprietary zeng-hu tech reported missing from nearby corporate facilities, \
	ecently tracked down to a planet, Juliett-Enderly, located in your current sector. You are the closest to this planet, and should investigate and \
	recover any stolen tech, if any is found. Approach with caution, but heavy resistance is not expected, as monitored ship traffic is light around here."

	min_player_amount = 0
	min_actor_amount = 0 //should be 4 todomatt

	roles = list(
		/singleton/role/cryo_outpost,
		/singleton/role/cryo_outpost/mercenary,
		/singleton/role/cryo_outpost/mercenary/medic,
		/singleton/role/cryo_outpost/mercenary/engineer,
		/singleton/role/cryo_outpost/director,
		/singleton/role/cryo_outpost/scientist,
		/singleton/role/cryo_outpost/engineer
	)
	default_outfit = /obj/outfit/admin/generic/cryo_outpost_crew

	base_area = /area/cryo_outpost

/singleton/role/cryo_outpost
	name = "Mercenary Team Lead"
	desc = "You are the leader of a mercenary detachment found in the cloning outpost. Your team could have been an independent mercenary company contracted \
			to take this secret Zeng-Hu base, or you could've just found it yourselves. You are equipped with a Heavy Sol Marine's gear."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/mercenary/leader

/singleton/role/cryo_outpost/mercenary
	name = "Mercenary"
	desc = "You are part of a mercenary detachment that has occupied this cloning outpost - either because you were contracted by someone, or because you simply \
			found this place. Some of these Zeng-Hu secrets could sell for a pretty penny... Your creativity's the limit! You are equipped with \
			a Mercenary Freelancer's gear."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/mercenary

/singleton/role/cryo_outpost/mercenary/medic
	name = "Mercenary Combat Medic"
	desc = "You are part of a mercenary detachment that has occupied this cloning outpost - either because you were contracted by someone, or because you simply \
			found this place. You, unlike others, are mainly worried with keeping everyone alive. You are equipped with \
			a Mercenary Freelancer Medic's gear."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/mercenary/medic

/singleton/role/cryo_outpost/mercenary/engineer
	name = "Mercenary Combat Engineer"
	desc = "You are part of a mercenary detachment that has occupied this cloning outpost - either because you were contracted by someone, or because you simply \
			found this place. You, unlike others, are mainly worried with keeping the power up and building fortifications. You are equipped with \
			a Mercenary Freelancer Engineer's gear."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/mercenary/engineer

/singleton/role/cryo_outpost/director
	name = "Outpost Director"
	desc = "You are the director of this outpost. You were tasked with leading experimental top-secret research on cloning. Things seem to have gone bad, however, \
			and it's up to you to figure out what to do next. One thing is clear - you hold a trove of information that any corporation or mercenary would be \
			thrilled to get out of you. Will you stay loyal to Zeng-Hu, or will you sell your information out for safety?"
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/clone_facility_director

/singleton/role/cryo_outpost/scientist
	name = "Zeng-Hu Facility Scientist"
	desc = "You are a Zeng-Hu scentist that once worked on top-secret cloning technologies in this outpost. Zeng-Hu wants you to carry some of these cloning \
			secrets to the grave, but your wishes don't need to align with them, if your safety was at risk... You are equipped with a Zeng-Hu scientist's gear."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/scientist

/singleton/role/cryo_outpost/engineer
	name = "Facility Engineer"
	desc = "You are an engineer in charge of keeping the outpost functioning. Luckily, your utility to someone else might be what saves your skin \
			this time around..."
	outfit = /obj/outfit/admin/generic/cryo_outpost_crew/engineer
