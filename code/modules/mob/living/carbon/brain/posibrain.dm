/obj/item/device/mmi/digital/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "posibrain"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)
	var/searching = FALSE
	req_access = list(access_robotics)
	locked = FALSE

/obj/item/device/mmi/digital/posibrain/Initialize()
	. = ..()
	brainmob.name = "[pick(list("PBU","HIU","SINA","ARMA","OSI"))]-[rand(100, 999)]"
	brainmob.real_name = brainmob.name

/obj/item/device/mmi/digital/posibrain/attack_self(mob/user)
	if(brainmob.ckey)
		to_chat(user, SPAN_WARNING("\The [src] already has an active occupant!"))
		return
	var/area/A = get_area(src)
	if(brainmob && !brainmob.key)
		if(!searching)
			to_chat(user, SPAN_NOTICE("You carefully locate the manual activation switch and start \the [src]'s boot process."))
			icon_state = "posibrain-searching"
			searching = TRUE
			SSghostroles.add_spawn_atom("posibrain", src)
			if(A)
				say_dead_direct("A posibrain has started its boot process in [A.name]! Spawn in as it by using the ghost spawner menu in the ghost tab.")
		else
			to_chat(user, SPAN_NOTICE("You carefully locate the manual activation switch and disable \the [src]'s boot process."))
			icon_state = initial(icon_state)
			searching = FALSE
			SSghostroles.remove_spawn_atom("posibrain", src)
			if(A)
				say_dead_direct("A posibrain is no longer booting up in [A.name]. Seems someone disabled it.")

/obj/item/device/mmi/digital/posibrain/proc/spawn_into_posibrain(var/mob/user)
	if(brainmob.ckey)
		return
	brainmob.ckey = user.ckey
	name = "positronic brain ([brainmob.name])"
	icon_state = "posibrain-occupied"
	searching = FALSE
	SSghostroles.remove_spawn_atom("posibrain", src)

	to_chat(brainmob, "<b>You are a positronic brain, brought into existence on [station_name()].</b>")
	to_chat(brainmob, "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>")
	to_chat(brainmob, "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>")
	visible_message(SPAN_NOTICE("\The [src] chimes quietly."))

/obj/item/device/mmi/digital/posibrain/examine(mob/user)
	if(!..(user))
		return

	var/msg = "<span class='info'>*---------*</span>\nThis is \icon[src] \a <EM>[src]</EM>!\n[desc]\n"
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
