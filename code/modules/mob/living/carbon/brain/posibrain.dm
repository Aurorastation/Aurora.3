/obj/item/device/mmi/digital/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)
	req_access = list(access_robotics)
	locked = FALSE
	can_be_ipc = TRUE
	var/searching = FALSE

/obj/item/device/mmi/digital/posibrain/Initialize()
	. = ..()
	var/datum/language/L = all_languages[LANGUAGE_EAL]
	brainmob.name = L.get_random_name()
	brainmob.real_name = brainmob.name

/obj/item/device/mmi/digital/posibrain/attack_self(mob/user)
	if(brainmob.ckey)
		to_chat(user, SPAN_WARNING("\The [src] already has an active occupant!"))
		return
	if(brainmob && !brainmob.key)
		if(!searching)
			to_chat(user, SPAN_NOTICE("You carefully locate the manual activation switch and start \the [src]'s boot process."))
			icon_state = "posibrain-searching"
			searching = TRUE
			SSghostroles.add_spawn_atom("posibrain", src)
		else
			to_chat(user, SPAN_NOTICE("You carefully locate the manual activation switch and disable \the [src]'s boot process."))
			icon_state = initial(icon_state)
			searching = FALSE
			SSghostroles.remove_spawn_atom("posibrain", src)

/obj/item/device/mmi/digital/posibrain/assign_player(var/mob/user)
	if(brainmob.ckey)
		return
	brainmob.ckey = user.ckey
	name = "positronic brain ([brainmob.name])"
	icon_state = "posibrain-occupied"
	searching = FALSE

	to_chat(brainmob, "<b>You are a positronic brain, brought into existence on [station_name()].</b>")
	to_chat(brainmob, "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>")
	to_chat(brainmob, "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>")
	visible_message(SPAN_NOTICE("\The [src] chimes quietly."))

	return src

/obj/item/device/mmi/digital/posibrain/examine(mob/user)
	if(!..(user))
		return

	var/msg = "<span class='info'>*---------*</span>\nThis is [icon2html(src, user)] \a <EM>[src]</EM>!\n[desc]\n"
	msg += "<span class='warning'>"

	if(brainmob?.key)
		switch(brainmob.stat)
			if(CONSCIOUS)
				if(!src.brainmob.client)
					msg += "It appears to be in stand-by mode.\n" //afk
			if(UNCONSCIOUS)
				msg += "<span class='warning'>It doesn't seem to be responsive.</span>\n"
			if(DEAD)
				msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	else
		msg += "<span class='deadsay'>It appears to be completely inactive.</span>\n"
	msg += "</span><span class='info'>*---------*</span>"
	to_chat(user, msg)
	return

/obj/item/device/mmi/digital/posibrain/emp_act(severity)
	if(!brainmob)
		return
	else
		switch(severity)
			if(1)
				brainmob.emp_damage += rand(20,30)
			if(2)
				brainmob.emp_damage += rand(10,20)
			if(3)
				brainmob.emp_damage += rand(0,10)
	..()
