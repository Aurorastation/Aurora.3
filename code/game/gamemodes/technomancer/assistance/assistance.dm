/datum/technomancer/assistance
	var/one_use_only = 0

/datum/technomancer/assistance/apprentice
	name = "Friendly Apprentice"
	desc = "A one-time use teleporter that sends a less powerful manipulator of space to you, who will do their best to protect \
	and serve you.  They get their own catalog and can buy spells for themselves, however they have a smaller pool to buy with.  \
	If you are unable to receive an apprentice, the teleporter can be refunded like most equipment by sliding it into the \
	catalog.  Note that apprentices cannot purchase more apprentices."
	cost = 300
	obj_path = /obj/item/antag_spawner/technomancer_apprentice
	has_additional_info = TRUE

/datum/technomancer/assistance/apprentice/additional_info()
	var/technomancer_count = 0
	var/ghost_count = 0
	for(var/mob/abstract/observer/O in player_list)
		if(O.client && (O.client.inactivity < 5 MINUTES))
			if("technomancer" in O.client.prefs.be_special_role)
				technomancer_count++
			ghost_count++
	return "There [technomancer_count > 1 ? "are" : "is"] <b>[technomancer_count]</b> out of <b>[ghost_count]</b> active observer\s with the technomancer role enabled."