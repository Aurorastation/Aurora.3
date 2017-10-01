/obj/screen/movement_intent
	name = "mov_intent"
	screen_loc = ui_movi
	layer = 20

//This updates the run/walk button on the hud
/obj/screen/movement_intent/proc/update_move_icon(var/mob/living/user)
	if (!user.client)
		return

	if (user.max_stamina == -1 || user.stamina == user.max_stamina)
		if (user.stamina_bar)
			QDEL_NULL(user.stamina_bar)
		return

	if (!user.stamina_bar)
		user.stamina_bar = new(user, user.max_stamina, src)

	user.stamina_bar.update(user.stamina)
	if (user.m_intent == "run")
		icon_state = "running"
	else
		icon_state = "walking"

/obj/screen/movement_intent/Click(location, control, params)
	if(!usr)
		return 1
	var/list/modifiers = params2list(params)

	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if (modifiers["alt"])
			C.set_walk_speed()
			return

		if(C.legcuffed)
			C << "<span class='notice'>You are legcuffed! You cannot run until you get [C.legcuffed] removed!</span>"
			C.m_intent = "walk"	//Just incase
			C.hud_used.move_intent.icon_state = "walking"
			return 1
		switch(usr.m_intent)
			if("run")
				usr.m_intent = "walk"
			if("walk")
				usr.m_intent = "run"

		update_move_icon(usr)
