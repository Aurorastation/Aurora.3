/datum/game_mode/outbreak
	name = "Outbreak"
	config_tag = "outbreak"
	required_players = 0
	required_enemies = 0
	round_description = "There goes your vacation. Again."
	extended_round_description = "Complete. Global. Saturation."
	antag_tags = list(MODE_OUTBREAK)
	votable = 0

/datum/game_mode/outbreak/ui_state(mob/user)
	return GLOB.admin_state

/datum/game_mode/outbreak/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/game_mode/outbreak/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Outbreak", "Outbreak Controller", 330, 720)
		ui.open()

/datum/game_mode/outbreak/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/mob/user = usr
	switch(action)
		if("group_spawn")
			for(var/i = 1 to rand(5, 9))
				var/turf/T = get_random_turf_in_range(user, 7, 0, TRUE, FALSE)
				new /mob/living/carbon/human/zombie(T)

		if("group_spawn_special")
			var/list/speczamt = params["group_spawn_special"]
			var/amt = speczamt["SpecZombieAmt"]
			for(var/i = 1 to amt)
				var/turf/T = get_random_turf_in_range(user, 7, 0, TRUE, FALSE)
				var/special = pick("rhino", "bull", "hunter")
				switch(special)
					if("rhino")
						new /mob/living/carbon/human/rhino(T)
					if("bull")
						new /mob/living/carbon/human/bull(T)
					if("hunter")
						new /mob/living/carbon/human/hunter(T)

		if("spawn_special")
			var/special = pick("rhino", "bull", "hunter")
			var/turf/T = get_turf(usr)
			switch(special)
				if("rhino")
					new /mob/living/carbon/human/rhino(T)
				if("bull")
					new /mob/living/carbon/human/bull(T)
				if("hunter")
					new /mob/living/carbon/human/hunter(T)

/obj/effect/landmark/outbreak_zombie
	name = "Simple Zombie Marker"

/obj/effect/landmark/outbreak_zombie/ipc
	name = "IPC Zombie Landmark"
