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
		/singleton/role/cryo_outpost/scientist
	)

/singleton/role/cryo_outpost
	name = "Cryo Outpost Mercenary Team Lead"
	desc = "You are the leader of a mercenary detachment found in the cloning outpost. Your team could have been an independent mercenary company contracted \
			to take this secret Zeng-Hu base, or you could've just found it yourselves. You are equipped with a Heavy Sol Marine's gear."
	outfit = /obj/outfit/admin/event/sol_marine/heavy

/singleton/role/cryo_outpost/mercenary
	name = "Cryo Outpost Mercenary"
	desc = "You are part of a mercenary detachment that has occupied this cloning outpost - either because you were contracted by someone, or because you simply \
			found this place. Some of these Zeng-Hu secrets could sell for a pretty penny... Your creativity's the limit! You are equipped with \
			a Sol Marine's gear."
	outfit = /obj/outfit/admin/event/sol_marine

/singleton/role/cryo_outpost/scientist
	name = "Cryo Outpost Zeng-Hu Scientist"
	desc = "You are a Zeng-Hu scentist that once worked on unspeakable clone technologies in this outpost. Zeng-Hu wants you to carry some of these cloning \
			secrets to the grave, but your wishes don't need to align with them, if your safety was at risk... You are equipped with a Zeng-Hu scientist's gear."
	outfit = /obj/outfit/job/scientist/zeng_hu

