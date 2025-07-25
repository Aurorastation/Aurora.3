/obj/item/device/mmi/digital/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)
	req_access = list(ACCESS_ROBOTICS)
	can_be_ipc = TRUE
	var/searching = FALSE

/obj/item/device/mmi/digital/posibrain/Initialize()
	. = ..()
	var/datum/language/L = GLOB.all_languages[LANGUAGE_EAL]
	brainmob.name = L.get_random_name()
	brainmob.real_name = brainmob.name

/obj/item/device/mmi/digital/posibrain/update_icon()
	if(brainmob.ckey)
		icon_state = "[initial(icon_state)]-occupied"
	else if(searching)
		icon_state = "[initial(icon_state)]-searching"
	else
		icon_state = initial(icon_state)

/obj/item/device/mmi/digital/posibrain/attackby(obj/item/attacking_item, mob/user)
	return

/obj/item/device/mmi/digital/posibrain/attack_self(mob/user)
	if(brainmob.ckey)
		to_chat(user, SPAN_WARNING("\The [src] already has an active occupant!"))
		return
	if(brainmob && !brainmob.key)
		if(!searching)
			to_chat(user, SPAN_NOTICE("You carefully locate the manual activation switch and start \the [src]'s boot process."))
			searching = TRUE
			SSghostroles.add_spawn_atom("posibrain", src)
		else
			to_chat(user, SPAN_NOTICE("You carefully locate the manual activation switch and disable \the [src]'s boot process."))
			searching = FALSE
			SSghostroles.remove_spawn_atom("posibrain", src)
		update_icon()

/obj/item/device/mmi/digital/posibrain/assign_player(var/mob/user)
	if(brainmob.ckey)
		return

	brainmob.ckey = user.ckey
	searching = FALSE
	update_icon()

	INVOKE_ASYNC(src, PROC_REF(update_name))

	to_chat(brainmob, "<b>You are a positronic brain, brought into existence on [station_name()].</b>")
	to_chat(brainmob, "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>")
	to_chat(brainmob, "<b>Remember, the purpose of your existence is to serve the crew and the [station_name(TRUE)]. Above all else, do no harm.</b>")

	brainmob.client.init_verbs()

	return src

/obj/item/device/mmi/digital/posibrain/update_name()
	var/new_name = tgui_input_text(brainmob, "Choose your name.", "Name Selection", brainmob.real_name, MAX_NAME_LEN)
	if(new_name)
		brainmob.real_name = new_name
		brainmob.name = new_name
		brainmob.voice_name = new_name
	visible_message(SPAN_NOTICE("\The [src] chimes quietly."))
	return ..()

/obj/item/device/mmi/digital/posibrain/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()

	. += "This is [icon2html(src, user)] \a <EM>[src]</EM>!\n[desc]\n"

	if(brainmob?.key)
		switch(brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)
					. += "It appears to be in stand-by mode.\n" //afk
			if(UNCONSCIOUS)
				. += SPAN_WARNING("It doesn't seem to be responsive.\n")
			if(DEAD)
				. += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	else
		. += "<span class='deadsay'>It appears to be completely inactive.</span>\n"

/obj/item/device/mmi/digital/posibrain/ready_for_use(var/mob/user)
	if(!brainmob)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a personality loaded on it yet!"))
		return
	if(brainmob.stat == DEAD)
		to_chat(user, SPAN_WARNING("The personality inside \the [src] is dead!"))
		return FALSE
	return TRUE

/obj/item/device/mmi/digital/posibrain/set_cradle_state(var/new_state)
	return

/obj/item/device/mmi/digital/posibrain/emp_act(severity)
	. = ..()

	if(!brainmob)
		return

	switch(severity)
		if(EMP_HEAVY)
			brainmob.emp_damage += rand(20,30)
		if(EMP_LIGHT)
			brainmob.emp_damage += rand(10,20)
