#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/security
	name = T_BOARD("security camera monitor")
	build_path = /obj/machinery/computer/security
	req_access = list(ACCESS_SECURITY)
	var/list/network
	var/locked = 1
	var/emagged = 0

/obj/item/circuitboard/security/Initialize()
	. = ..()
	network = SSatlas.current_map.station_networks

/obj/item/circuitboard/security/engineering
	name = T_BOARD("engineering camera monitor")
	build_path = /obj/machinery/computer/security/engineering
	req_access = list()

/obj/item/circuitboard/security/engineering/New()
	..()
	network = GLOB.engineering_networks

/obj/item/circuitboard/security/mining
	name = T_BOARD("mining camera monitor")
	build_path = /obj/machinery/computer/security/mining
	network = list("MINE")
	req_access = list()

/obj/item/circuitboard/security/construct(var/obj/machinery/computer/security/C)
	if (..(C))
		C.network = network.Copy()

/obj/item/circuitboard/security/deconstruct(var/obj/machinery/computer/security/C)
	if (..(C))
		network = C.network.Copy()

/obj/item/circuitboard/security/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		to_chat(user, "Circuit lock is already removed.")
		return
	to_chat(user, SPAN_NOTICE("You override the circuit lock and open controls."))
	emagged = 1
	locked = 0
	return 1

/obj/item/circuitboard/security/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/card/id))
		if(emagged)
			to_chat(user, SPAN_WARNING("Circuit lock does not respond."))
			return
		if(check_access(attacking_item))
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [locked ? "" : "un"]lock the circuit controls."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
	else if(attacking_item.ismultitool())
		if(locked)
			to_chat(user, SPAN_WARNING("Circuit controls are locked."))
			return
		var/existing_networks = jointext(network,",")
		var/input = sanitize( tgui_input_text(user, "Which networks would you like to connect this camera console circuit to? Seperate networks with a comma. No Spaces!\nFor example: SS13,Security,Secret ",
												"Multitool-Circuitboard interface", existing_networks) )
		if(!input)
			to_chat(usr, "No input found please hang up and try your call again.")
			return
		var/list/tempnetwork = text2list(input, ",")
		tempnetwork = difflist(tempnetwork, GLOB.restricted_camera_networks, 1)
		if(tempnetwork.len < 1)
			to_chat(usr, "No network found please hang up and try your call again.")
			return
		network = tempnetwork
	return
