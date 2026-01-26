/obj/item/circuitboard/security
	name = T_BOARD("security camera monitor")
	build_path = /obj/machinery/computer/security
	req_access = list(ACCESS_SECURITY)
	var/list/console_networks
	var/locked = 1
	var/emagged = 0

/obj/item/circuitboard/security/Initialize()
	. = ..()
	console_networks = SSatlas.current_map.station_networks

/obj/item/circuitboard/security/engineering
	name = T_BOARD("engineering camera monitor")
	build_path = /obj/machinery/computer/security/engineering
	req_access = list()

/obj/item/circuitboard/security/engineering/New()
	..()
	console_networks = GLOB.engineering_networks

/obj/item/circuitboard/security/mining
	name = T_BOARD("mining camera monitor")
	build_path = /obj/machinery/computer/security/mining
	console_networks = list("MINE")
	req_access = list()

/obj/item/circuitboard/security/construct(var/obj/machinery/computer/security/C)
	if (..(C))
		C.console_networks = console_networks.Copy()

/obj/item/circuitboard/security/deconstruct(var/obj/machinery/computer/security/C)
	if (..(C))
		console_networks = C.console_networks.Copy()

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
		var/existing_networks = jointext(console_networks,",")
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
		console_networks = tempnetwork
	return
