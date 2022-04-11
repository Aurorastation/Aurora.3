
//---------- shield capacitor
//pulls energy out of a power net and charges an adjacent generator

/obj/machinery/shield_capacitor
	name = "shield capacitor"
	desc = "Machine that charges a shield generator."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "capacitor"
	obj_flags = OBJ_FLAG_ROTATABLE
	var/active = FALSE
	density = TRUE
	var/stored_charge = 0	//not to be confused with power cell charge, this is in Joules
	var/last_stored_charge = 0
	var/time_since_fail = 100
	var/max_charge = 8e6	//8 MJ
	var/max_charge_rate = 400000	//400 kW
	var/locked = FALSE
	use_power = FALSE //doesn't use APC power
	var/charge_rate = 100000	//100 kW
	var/obj/machinery/shield_gen/owned_gen
	req_one_access = list(access_captain, access_security, access_engine)

/obj/machinery/shield_capacitor/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/shield_capacitor/LateInitialize()
	for(var/obj/machinery/shield_gen/possible_gen in range(1, src))
		if(get_dir(src, possible_gen) == dir)
			possible_gen.owned_capacitor = src
			break

/obj/machinery/shield_capacitor/emag_act(var/remaining_charges, var/mob/user)
	if(prob(75))
		locked = !locked
		to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
		. = TRUE
		updateDialog()
	spark(src, 5, alldirs)

/obj/machinery/shield_capacitor/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/card/id))
		if(allowed(user))
			locked = !locked
			to_chat(user, "Controls are now [locked ? "locked." : "unlocked."]")
			updateDialog()
		else
			to_chat(user, SPAN_ALERT("Access denied."))
	else if(W.iswrench())
		anchored = !anchored
		visible_message(SPAN_NOTICE("\The [src] has been [anchored ? "bolted to the floor" : "unbolted from the floor"] by \the [user]."))

		if(anchored)
			for(var/obj/machinery/shield_gen/gen in range(1, src))
				if(get_dir(src, gen) == src.dir && !gen.owned_capacitor)
					owned_gen = gen
					owned_gen.owned_capacitor = src
					owned_gen.updateDialog()
		else
			if(owned_gen && owned_gen.owned_capacitor == src)
				owned_gen.owned_capacitor = null
			owned_gen = null
	else
		..()

/obj/machinery/shield_capacitor/attack_hand(mob/user)
	if(stat & (BROKEN))
		return
	interact(user)

/obj/machinery/shield_capacitor/interact(mob/user)
	if ( !in_range(src, user) || (stat & (BROKEN)) )
		if (!issilicon(user))
			user.unset_machine()
			user << browse(null, "window=shield_capacitor")
			return
	var/t = "<B>Shield Capacitor Control Console</B><br><br>"
	if(locked)
		t += "<i>Swipe your ID card to begin.</i>"
	else
		t += "This capacitor is: [active ? "<font color=green>Online</font>" : "<font color=red>Offline</font>" ] <a href='?src=\ref[src];toggle=1'>[active ? "\[Deactivate\]" : "\[Activate\]"]</a><br>"
		t += "Capacitor Status: [time_since_fail > 2 ? "<font color=green>OK.</font>" : "<font color=red>Discharging!</font>"]<br>"
		t += "Stored Energy: [round(stored_charge/1000, 0.1)] kJ ([100 * round(stored_charge/max_charge, 0.1)]%)<br>"
		t += "Charge Rate: \
		<a href='?src=\ref[src];charge_rate=-100000'>\[----\]</a> \
		<a href='?src=\ref[src];charge_rate=-10000'>\[---\]</a> \
		<a href='?src=\ref[src];charge_rate=-1000'>\[--\]</a> \
		<a href='?src=\ref[src];charge_rate=-100'>\[-\]</a>[charge_rate] W \
		<a href='?src=\ref[src];charge_rate=100'>\[+\]</a> \
		<a href='?src=\ref[src];charge_rate=1000'>\[++\]</a> \
		<a href='?src=\ref[src];charge_rate=10000'>\[+++\]</a> \
		<a href='?src=\ref[src];charge_rate=100000'>\[+++\]</a><br>"
	t += "<hr>"
	t += "<A href='?src=\ref[src]'>Refresh</A> "
	t += "<A href='?src=\ref[src];close=1'>Close</A><BR>"

	user << browse(t, "window=shield_capacitor;size=500x400")
	user.set_machine(src)

/obj/machinery/shield_capacitor/machinery_process()
	if (!anchored)
		active = FALSE

	//see if we can connect to a power net.
	var/datum/powernet/PN
	var/turf/T = loc

	if (!istype(T))
		active = FALSE
		return

	var/obj/structure/cable/C = T.get_cable_node()

	if (C)
		PN = C.powernet

	if (PN)
		var/power_draw = between(0, max_charge - stored_charge, charge_rate) //what we are trying to draw
		power_draw = PN.draw_power(power_draw) //what we actually get
		stored_charge += power_draw

	time_since_fail++
	if(stored_charge < last_stored_charge)
		time_since_fail = 0 //losing charge faster than we can draw from PN
	last_stored_charge = stored_charge

/obj/machinery/shield_capacitor/Topic(href, href_list[])
	..()
	if( href_list["close"] )
		usr << browse(null, "window=shield_capacitor")
		usr.unset_machine()
		return
	if( href_list["toggle"] )
		if(!active && !anchored)
			to_chat(usr, "<span class='warning'>The [src] needs to be firmly secured to the floor first.</span>")
			return
		active = !active
	if( href_list["charge_rate"] )
		charge_rate = between(10000, charge_rate + text2num(href_list["charge_rate"]), max_charge_rate)

	updateDialog()

/obj/machinery/shield_capacitor/power_change()
	if(stat & BROKEN)
		icon_state = "broke"
	else
		..()

/obj/machinery/shield_capacitor/multiz
	max_charge_rate = 1250000	//1250 kW
