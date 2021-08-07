/obj/machinery/computer/drone_control
	name = "Maintenance Drone Control"
	desc = "Used to monitor the station's drone population and the assembler that services them."
	light_color = LIGHT_COLOR_ORANGE

	icon_screen = "power"
	req_access = list(access_engine_equip)
	circuit = /obj/item/circuitboard/drone_control

	//Used when pinging drones.
	var/drone_call_area = "Engineering"
	//Used to enable or disable drone fabrication.
	var/obj/machinery/drone_fabricator/dronefab

	var/static/list/call_area_names

/obj/machinery/computer/drone_control/attack_ai(var/mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/computer/drone_control/attack_hand(var/mob/user as mob)
	if(..())
		return

	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	user.set_machine(src)
	var/dat
	dat += "<B>Maintenance Units</B><BR>"

	for(var/mob/living/silicon/robot/drone/D in silicon_mob_list)
		if(isStationLevel(src.z) && isNotStationLevel(D.z)) //If the console is on a station level, then list all drones on the station levels
			continue
		else if (isNotStationLevel(src.z) && src.z != D.z) //If the console is not on the station, only list drones on the current level
			continue
		dat += "<BR>[D.real_name] ([D.stat == 2 ? "<span class='warning'>INACTIVE</span>" : "<font color='green'>ACTIVE</FONT>"])"
		dat += "<font dize = 9><BR>Cell charge: [D.cell.charge]/[D.cell.maxcharge]."
		dat += "<BR>Currently located in: [get_area(D)]."
		dat += "<BR><A href='?src=\ref[src];resync=\ref[D]'>Resync</A> | <A href='?src=\ref[src];shutdown=\ref[D]'>Shutdown</A></font>"

	dat += "<BR><BR><B>Request drone presence in area:</B> <A href='?src=\ref[src];setarea=1'>[drone_call_area]</A> (<A href='?src=\ref[src];ping=1'>Send ping</A>)"

	dat += "<BR><BR><B>Drone fabricator</B>: "
	dat += "[dronefab ? "<A href='?src=\ref[src];toggle_fab=1'>[(dronefab.produce_drones && !(dronefab.stat & NOPOWER)) ? "ACTIVE" : "INACTIVE"]</A>" : "<font color='red'><b>FABRICATOR NOT DETECTED.</b></font> (<A href='?src=\ref[src];search_fab=1'>search</a>)"]"

	var/datum/browser/drone_win = new(user, "computer", capitalize_first_letters(name), 400, 500)
	drone_win.set_content(dat)
	drone_win.open()

/obj/machinery/computer/drone_control/Topic(href, href_list)
	if(..())
		return

	if(!allowed(usr))
		to_chat(usr, SPAN_WARNING("Access denied."))
		return

	if((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

	if(href_list["setarea"])
		if(!call_area_names)
			call_area_names = list()
			for(var/area/A as anything in all_areas)
				if(A.station_area)
					call_area_names += A.name
		//Probably should consider using another list, but this one will do.
		var/t_area = input(usr, "Select the area to ping.", "Set Target Area") as null|anything in call_area_names

		if(!t_area)
			return

		drone_call_area = t_area
		to_chat(usr, SPAN_NOTICE("You set the area selector to [drone_call_area]."))

	else if(href_list["ping"])
		to_chat(usr, SPAN_NOTICE("You issue a maintenance request for all active drones, highlighting [drone_call_area]."))
		for(var/mob/living/silicon/robot/drone/D in silicon_mob_list)
			if(D.client && D.stat == CONSCIOUS)
				to_chat(D, "-- Maintenance drone presence requested in: [drone_call_area].")

	else if(href_list["resync"])
		var/mob/living/silicon/robot/drone/D = locate(href_list["resync"])
		if(D.stat != DEAD)
			to_chat(usr, SPAN_NOTICE("You issue a law synchronization directive for the drone."))
			D.law_resync()
		else
			to_chat(usr, SPAN_WARNING("The drone has been shut down already."))

	else if (href_list["shutdown"])
		var/mob/living/silicon/robot/drone/D = locate(href_list["shutdown"])
		if(D.stat != DEAD)
			to_chat(usr, SPAN_NOTICE("You issue a kill command for the unfortunate drone."))
			message_admins("[key_name_admin(usr)] issued kill order for drone [key_name_admin(D)] from control console.")
			log_game("[key_name(usr)] issued kill order for [key_name(src)] from control console.",ckey=key_name(usr),ckey_target=key_name(src))
			D.shut_down()
		else
			to_chat(usr, SPAN_WARNING("The drone has been shut down already."))

	else if (href_list["search_fab"])
		if(dronefab)
			return
		for(var/obj/machinery/drone_fabricator/fab in oview(3,src))
			if(fab.stat & NOPOWER)
				continue
			dronefab = fab
			to_chat(usr, SPAN_NOTICE("Drone fabricator located."))
			return
		to_chat(usr, SPAN_WARNING("Unable to locate drone fabricator."))

	else if (href_list["toggle_fab"])
		if(!dronefab)
			return
		if(get_dist(src,dronefab) > 3)
			dronefab = null
			to_chat(usr, SPAN_WARNING("Unable to locate drone fabricator."))
			return

		dronefab.produce_drones = !dronefab.produce_drones
		to_chat(usr, SPAN_NOTICE("You [dronefab.produce_drones ? "enable" : "disable"] drone production in the nearby fabricator."))

	src.updateUsrDialog()
