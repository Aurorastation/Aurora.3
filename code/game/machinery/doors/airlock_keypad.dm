//
//	Keypad Airlock
//
/obj/machinery/door/airlock/keypad // HERE
	name = "Keypad Entry Airlock"
	desc = "A door with a keypad lock."
	assembly_type = /obj/structure/door_assembly/door_assembly_mai
	var/code = ""
	var/l_code = null
	var/l_set = 0
	var/l_setshort = 0
	var/l_hacking = 0
	var/open = 0

/obj/machinery/door/airlock/keypad/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()) || (get_dist(src, usr) > 1))
		return
	if(href_list["type"])
		if(href_list["type"] == "E")
			if((src.l_set == 0) && (length(src.code) == 5) && (!src.l_setshort) && (src.code != "ERROR"))
				src.l_code = src.code
				src.l_set = 1
			else if((src.code == src.l_code) && (src.emagged == 0) && (src.l_set == 1))
				src.locked = 0
				playsound(src,bolts_rising, 30, 0, 3)
				update_icon()
				src.overlays = null
				src.code = null
			else
				src.code = "ERROR"
		else
			if((href_list["type"] == "R") && (src.emagged == 0) && (!src.l_setshort))
				src.locked = 1
				playsound(src,bolts_dropping, 30, 0, 3)
				src.overlays = null
				update_icon()
				src.code = null
				src.close(usr)
			else
				src.code += text("[]", href_list["type"])
				if(length(src.code) > 5)
					src.code = "ERROR"
		src.add_fingerprint(usr)
		for(var/mob/M in viewers(1, src.loc))
			if((M.client && M.machine == src))
				src.attack_hand(M)
			return
	return

/obj/machinery/door/airlock/keypad/attack_hand(mob/user as mob)
	if(!istype(user, /mob/living/silicon))
		if(src.isElectrified())
			if(src.shock(user, 100))
				return

	if(!istype(user, /mob/living/silicon))
		user.set_machine(src)
		var/dat = text("<TT><B>[]</B><BR>\n\nLock Status: []",src, (src.locked ? "LOCKED" : "UNLOCKED"))
		var/message = "Code"
		if((src.l_set == 0) && (!src.emagged) && (!src.l_setshort))
			dat += text("<p>\n<b>5-DIGIT PASSCODE NOT SET.<br>ENTER NEW DOOR PASSCODE.</b>")
		if(src.emagged)
			dat += text("<p>\n<font color=red><b>LOCKING SYSTE	M ERROR - 1701</b></font>")
		if(src.l_setshort)
			dat += text("<p>\n<font color=red><b>ALERT: MEMORY SYSTEM ERROR - 6040 201</b></font>")
		message = text("[]", src.code)
		if(!src.locked)
			message = "*****"
		dat += text("<HR>\n>[]<BR>\n<A href='?src=\ref[];type=1'>1</A>-<A href='?src=\ref[];type=2'>2</A>-<A href='?src=\ref[];type=3'>3</A><BR>\n<A href='?src=\ref[];type=4'>4</A>-<A href='?src=\ref[];type=5'>5</A>-<A href='?src=\ref[];type=6'>6</A><BR>\n<A href='?src=\ref[];type=7'>7</A>-<A href='?src=\ref[];type=8'>8</A>-<A href='?src=\ref[];type=9'>9</A><BR>\n<A href='?src=\ref[];type=R'>R</A>-<A href='?src=\ref[];type=0'>0</A>-<A href='?src=\ref[];type=E'>E</A><BR>\n</TT>", message, src, src, src, src, src, src, src, src, src, src, src, src)
		show_browser(user, dat, "window=caselock;size=300x280")

	if(src.p_open)
		wires.Interact(user)
	else
		..(user)
	return