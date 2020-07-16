//PACMAN variant that can run on the small plasma tanks.
/obj/machinery/power/port_gen/pacman2
	name = "Pacman II"
	desc = "P.A.C.M.A.N. type II portable generator. Uses liquid phoron as a fuel source."
	power_gen = 4500
	var/obj/item/tank/phoron/P = null
	var/board_path = "/obj/item/circuitboard/pacman2"
	var/emagged = FALSE
	var/heat = 0

/obj/machinery/power/port_gen/pacman2/HasFuel()
	if(P.air_contents.phoron >= 0.1)
		return TRUE

/obj/machinery/power/port_gen/pacman2/UseFuel()
	P.air_contents.phoron -= 0.01

/obj/machinery/power/port_gen/pacman2/setup_components()
	. = list(
		new /obj/item/stock_parts/matter_bin(src),
		new /obj/item/stock_parts/micro_laser(src),
		new /obj/item/stack/cable_coil(src),
		new /obj/item/stack/cable_coil(src),
		new /obj/item/stock_parts/capacitor(src),
		new board_path(src)
	)

/obj/machinery/power/port_gen/pacman2/proc/RefreshParts()
	var/temp_rating = 0
	for(var/obj/item/stock_parts/SP in component_parts)
		if(istype(SP, /obj/item/stock_parts/micro_laser) || istype(SP, /obj/item/stock_parts/capacitor))
			temp_rating += SP.rating
	power_gen = round(initial(power_gen) * (max(2, temp_rating) / 2))

/obj/machinery/power/port_gen/pacman2/examine(mob/user)
	..(user)
	to_chat(user, SPAN_NOTICE("The generator has [P.air_contents.phoron] units of fuel left, producing [power_gen] per cycle."))

/obj/machinery/power/port_gen/pacman2/handleInactive()
	heat = max(heat-2, 0)
	if (heat)
		for(var/viewer in viewers(1, src))
			var/mob/M = viewer
			if (M.client && M.machine == src)
				updateUsrDialog()

/obj/machinery/power/port_gen/pacman2/proc/overheat()
	explosion(get_turf(src), 2, 5, 2, -1)

/obj/machinery/power/port_gen/pacman2/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/tank/phoron))
		if(P)
			to_chat(user, SPAN_WARNING("The generator already has a phoron tank loaded!"))
			return
		P = O
		user.drop_from_inventory(O, src)
		to_chat(user, SPAN_NOTICE("You add the phoron tank to the generator."))
	else if(!active)
		if(O.iswrench())
			anchored = !anchored
			playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
			if(anchored)
				to_chat(user, SPAN_NOTICE("You secure the generator to the floor."))
			else
				to_chat(user, SPAN_NOTICE("You unsecure the generator from the floor."))
			SSmachinery.powernet_update_queued = TRUE
		else if(O.isscrewdriver())
			open = !open
			playsound(loc, O.usesound, 50, 1)
			if(open)
				to_chat(user, SPAN_NOTICE("You open the access panel."))
			else
				to_chat(user, SPAN_NOTICE("You close the access panel."))
		else if(!open && O.iscrowbar())
			var/obj/machinery/constructable_frame/machine_frame/new_frame = new /obj/machinery/constructable_frame/machine_frame(src.loc)
			for(var/obj/item/I in component_parts)
				I.forceMove(loc)
			new_frame.state = 2
			new_frame.icon_state = "box_1"
			qdel(src)

/obj/machinery/power/port_gen/pacman2/attack_hand(mob/user)
	..()
	if (!anchored)
		return

	interact(user)

/obj/machinery/power/port_gen/pacman2/attack_ai(mob/user)
	interact(user)

/obj/machinery/power/port_gen/pacman2/attack_paw(mob/user)
	interact(user)

/obj/machinery/power/port_gen/pacman2/proc/interact(mob/user)
	if (get_dist(src, user) > 1 )
		if (!istype(user, /mob/living/silicon/ai))
			user.machine = null
			user << browse(null, "window=port_gen")
			return

	user.machine = src

	var/dat = text("<b>[name]</b><br>")
	if (active)
		dat += text("Generator: <A href='?src=\ref[src];action=disable'>On</A><br>")
	else
		dat += text("Generator: <A href='?src=\ref[src];action=enable'>Off</A><br>")
	if(P)
		dat += text("Currently loaded phoron tank: [P.air_contents.phoron]<br>")
	else
		dat += text("No phoron tank currently loaded.<br>")
	dat += text("Power output: <A href='?src=\ref[src];action=lower_power'>-</A> [power_gen * power_output] <A href='?src=\ref[src];action=higher_power'>+</A><br>")
	dat += text("Heat: [heat]<br>")
	dat += "<br><A href='?src=\ref[src];action=close'>Close</A>"
	user << browse("[dat]", "window=port_gen")

/obj/machinery/power/port_gen/pacman2/Topic(href, href_list)
	if(..())
		return

	add_fingerprint(usr)
	if(href_list["action"])
		if(href_list["action"] == "enable")
			if(!active && HasFuel())
				active = TRUE
				icon_state = "portgen1"
				updateUsrDialog()
		if(href_list["action"] == "disable")
			if (active)
				active = FALSE
				icon_state = "portgen0"
				updateUsrDialog()
		if(href_list["action"] == "lower_power")
			if (power_output > 1)
				power_output--
				updateUsrDialog()
		if (href_list["action"] == "higher_power")
			if (power_output < 4 || emagged)
				power_output++
				updateUsrDialog()
		if (href_list["action"] == "close")
			usr << browse(null, "window=port_gen")
			usr.machine = null

/obj/machinery/power/port_gen/pacman2/emag_act(var/remaining_uses, var/mob/user)
	emagged = TRUE
	emp_act(1)
	return TRUE
