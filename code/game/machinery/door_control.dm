/obj/machinery/button/remote
	name = "remote object control"
	desc = "It controls objects, remotely."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorctrl0"
	power_channel = ENVIRON
	var/desiredstate = 0
	var/exposedwires = 0
	var/wires = 3
	/*
	Bitflag,	1=checkID
				2=Network Access
	*/

	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/button/remote/attack_ai(mob/user as mob)
	if(wires & 2)
		return src.attack_hand(user)
	else
		to_chat(user, "Error, no route to host.")

/obj/machinery/button/remote/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/forensics))
		return
	return src.attack_hand(user)

/obj/machinery/button/remote/emag_act(var/remaining_charges, var/mob/user)
	if(req_access.len || req_one_access.len)
		req_access = list()
		req_one_access = list()
		playsound(src.loc, "sparks", 100, 1)
		return 1

/obj/machinery/button/remote/attack_hand(mob/user as mob)
	if(..())
		return

	src.add_fingerprint(user)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!allowed(user) && (wires & 1))
		to_chat(user, "<span class='warning'>Access Denied</span>")
		flick("doorctrl-denied",src)
		return

	use_power(5)
	icon_state = "doorctrl1"
	desiredstate = !desiredstate
	trigger(user)

	addtimer(CALLBACK(src, /obj/machinery/button/remote/update_icon), 15)

/obj/machinery/button/remote/proc/trigger()
	return

/obj/machinery/button/remote/power_change()
	..()
	update_icon()

/obj/machinery/button/remote/update_icon()
	if(stat & NOPOWER)
		icon_state = "doorctrl-p"
	else
		icon_state = "doorctrl0"

/*
	Airlock remote control
*/

// Bitmasks for door switches.
#define OPEN   0x1
#define IDSCAN 0x2
#define BOLTS  0x4
#define SHOCK  0x8
#define SAFE   0x10

/obj/machinery/button/remote/airlock
	name = "remote door-control"
	desc = "It controls doors, remotely."

	var/specialfunctions = 1
	/*
	Bitflag, 	1= open
				2= idscan,
				4= bolts
				8= shock
				16= door safties
	*/

/obj/machinery/button/remote/airlock/trigger()
	for (var/i in get_listeners_by_type("machinebtn_[id]", /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/D = i
		if(specialfunctions & OPEN)
			if (D.density)
				INVOKE_ASYNC(D, /obj/machinery/door/airlock/.proc/open)
			else
				INVOKE_ASYNC(D, /obj/machinery/door/airlock/.proc/close)

		if(desiredstate == 1)
			if(specialfunctions & IDSCAN)
				D.set_idscan(0)
			if(specialfunctions & BOLTS)
				D.lock()
			if(specialfunctions & SHOCK)
				D.electrify(-1)
			if(specialfunctions & SAFE)
				D.set_safeties(0)
		else
			if(specialfunctions & IDSCAN)
				D.set_idscan(1)
			if(specialfunctions & BOLTS)
				D.unlock()
			if(specialfunctions & SHOCK)
				D.electrify(0)
			if(specialfunctions & SAFE)
				D.set_safeties(1)

#undef OPEN
#undef IDSCAN
#undef BOLTS
#undef SHOCK
#undef SAFE

/*
	Blast door remote control
*/
/obj/machinery/button/remote/blast_door
	name = "remote blast door-control"
	desc = "It controls blast doors, remotely."

/obj/machinery/button/remote/blast_door/trigger()
	for (var/i in get_listeners_by_type("machinebtn_[id]", /obj/machinery/door/blast))
		var/obj/machinery/door/blast/M = i
		if(M.density)
			INVOKE_ASYNC(M, /obj/machinery/door/blast/.proc/open)
		else
			INVOKE_ASYNC(M, /obj/machinery/door/blast/.proc/close)

/obj/machinery/button/remote/blast_door/open_only/trigger()
	for (var/i in get_listeners_by_type("machinebtn_[id]", /obj/machinery/door/blast))
		var/obj/machinery/door/blast/M = i
		if(M.density)
			INVOKE_ASYNC(M, /obj/machinery/door/blast/.proc/open)

/*
	Emitter remote control
*/
/obj/machinery/button/remote/emitter
	name = "remote emitter control"
	desc = "It controls emitters, remotely."

/obj/machinery/button/remote/emitter/trigger(mob/user as mob)
	for (var/i in get_listeners_by_type("machinebtn_[id]", /obj/machinery/power/emitter))
		var/obj/machinery/power/emitter/E = i

		E.activate(user)

/*
	Mass driver remote control
*/
/obj/machinery/button/remote/driver
	name = "mass driver button"
	desc = "A remote control switch for a mass driver."
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"

/obj/machinery/button/remote/driver/trigger(mob/user as mob)
	active = 1
	update_icon()

	for (var/i in get_listeners_by_type("machinebtn_[id]", /obj/machinery/door/blast))
		var/obj/machinery/door/blast/M = i
		INVOKE_ASYNC(M, /obj/machinery/door/blast/.proc/open)

	sleep(20)

	for (var/i in get_listeners_by_type("machinebtn_[id]", /obj/machinery/mass_driver))
		var/obj/machinery/mass_driver/M = i
		INVOKE_ASYNC(M, /obj/machinery/mass_driver/proc/drive)

	sleep(50)

	for (var/i in get_listeners_by_type("machinebtn_[id]", /obj/machinery/door/blast))
		var/obj/machinery/door/blast/M = i
		INVOKE_ASYNC(M, /obj/machinery/door/blast/.proc/close)

	icon_state = "launcherbtt"
	active = 0
	update_icon()

	return

/obj/machinery/button/remote/driver/update_icon()
	if(!active || (stat & NOPOWER))
		icon_state = "launcherbtt"
	else
		icon_state = "launcheract"