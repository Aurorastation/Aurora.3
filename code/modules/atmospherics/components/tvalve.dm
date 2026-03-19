/obj/machinery/atmospherics/tvalve
	name = "manual switching valve"
	desc = "A pipe valve."
	icon = 'icons/atmos/tvalve.dmi'
	icon_state = "map_tvalve0"

	level = 1
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|WEST

	var/state = 0 // 0 = go straight, 1 = go to side

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_AUX
	connect_dir_type = SOUTH | WEST | NORTH
	pipe_class = PIPE_CLASS_TRINARY

	build_icon = 'icons/atmos/tvalve.dmi'
	build_icon_state = "map_tvalve0"

/obj/machinery/atmospherics/tvalve/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Click this to toggle the mode. The direction with the green light is where the gas will flow."

/obj/machinery/atmospherics/tvalve/bypass
	icon_state = "map_tvalve1"
	state = 1

/obj/machinery/atmospherics/tvalve/proc/do_turn_animation()
	queue_icon_update()
	flick("tvalve[src.state][!src.state]",src)

/obj/machinery/atmospherics/tvalve/update_icon()
	icon_state = "tvalve[state]"
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/tvalve/hide(do_hide)
	update_icon()

/obj/machinery/atmospherics/tvalve/proc/paired_dirs() // these two dirs are connected
	if(state) // "go to side"
		return list(turn(dir, 180), turn(dir, -90))
	else      // "go straight"
		return list(turn(dir, 180), dir)

// feed in node; recover all the other nodes that this one should be connected to, depending on state
/obj/machinery/atmospherics/tvalve/proc/get_nodes_connected_to(obj/machinery/atmospherics/node)
	var/node_dir = get_dir(src, node)
	. = nodes_in_dir(node_dir) // other nodes in the same dir
	var/other_dir // but maybe we need to also be connecting to all nodes in one other dir

	var/paired_dirs = paired_dirs()
	if(node_dir in paired_dirs) // fish out the other one
		paired_dirs -= node_dir
		other_dir = paired_dirs[1]

	if(other_dir)
		. |= nodes_in_dir(other_dir)

/obj/machinery/atmospherics/tvalve/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	for(var/obj/machinery/atmospherics/node as anything in get_nodes_connected_to(reference))
		if(nodes_to_networks[node] != new_network)
			QDEL_NULL(nodes_to_networks[node])
			nodes_to_networks[node] = new_network
			if(node != reference)
				node.network_expand(new_network, src)
	new_network.normal_members |= src

/obj/machinery/atmospherics/tvalve/proc/go_to_side()
	if(state)
		return 0

	state = 1

	// we are just going to rebuild networks, as we can't split them anyway.

	for(var/node in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])
	build_network()

	queue_icon_update()

	return 1

/obj/machinery/atmospherics/tvalve/proc/go_straight()
	if(!state)
		return 0

	state = 0

	// we are just going to rebuild networks, as we can't split them anyway.

	for(var/node in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])
	build_network()

	queue_icon_update()

	return 1

/obj/machinery/atmospherics/tvalve/proc/toggle()
	return state ? go_straight() : go_to_side()

/obj/machinery/atmospherics/tvalve/attack_ai(mob/user as mob)
	return

/obj/machinery/atmospherics/tvalve/attack_hand(mob/user as mob)
	. = ..()
	user_toggle()

/obj/machinery/atmospherics/tvalve/proc/user_toggle()
	do_turn_animation()
	sleep(1 SECOND)
	toggle()

/obj/machinery/atmospherics/tvalve/process()
	..()
	. = PROCESS_KILL

/obj/machinery/atmospherics/tvalve/return_network_air(datum/pipe_network/reference)
	return null

/obj/machinery/atmospherics/tvalve/digital		// can be controlled by AI
	name = "digital switching valve"
	desc = "A digitally controlled valve."
	icon = 'icons/atmos/digital_tvalve.dmi'

	use_power = POWER_USE_IDLE
	idle_power_usage = 10 // A few LEDs

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/tvalve/digital/bypass
	icon_state = "map_tvalve1"
	state = 1

/obj/machinery/atmospherics/tvalve/digital/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/tvalve/digital/update_icon()
	..()
	ClearOverlays()
	if(!powered())
		icon_state = "tvalvenopower"
	else
		AddOverlays(emissive_appearance(icon, "tvalve-emissive"))

/obj/machinery/atmospherics/tvalve/digital/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/atmospherics/tvalve/digital/attack_hand(mob/user as mob)
	if(!powered())
		return
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	..()

//Radio remote control

/obj/machinery/atmospherics/tvalve/digital/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)



/obj/machinery/atmospherics/tvalve/digital/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/tvalve/digital/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id))
		return 0

	switch(signal.data["command"])
		if("valve_open")
			if(!state)
				go_to_side()

		if("valve_close")
			if(state)
				go_straight()

		if("valve_toggle")
			if(state)
				go_straight()
			else
				go_to_side()

/obj/machinery/atmospherics/tvalve/attackby(obj/item/attacking_item, mob/user)
	if (attacking_item.tool_behaviour != TOOL_WRENCH)
		return ..()
	if (istype(src, /obj/machinery/atmospherics/tvalve/digital))
		to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it's too complicated."))
		return TRUE
	var/datum/gas_mixture/int_air = return_air()
	if(!loc) return FALSE
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((XGM_PRESSURE(int_air)-XGM_PRESSURE(env_air)) > PRESSURE_EXERTED)
		to_chat(user, "<span class='warnng'>You cannot unwrench \the [src], it too exerted due to internal pressure.</span>")
		add_fingerprint(user)
		return TRUE
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if(attacking_item.use_tool(src, user, istype(attacking_item, /obj/item/pipewrench) ? 80 : 40, volume = 50))
		user.visible_message( \
			SPAN_NOTICE("\The [user] unfastens \the [src]."), \
			SPAN_NOTICE("You have unfastened \the [src]."), \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, src)
		qdel(src)
		return TRUE

/obj/machinery/atmospherics/tvalve/mirrored
	icon_state = "map_tvalvem0"

/obj/machinery/atmospherics/tvalve/mirrored/bypass
	icon_state = "map_tvalvem1"
	state = 1

/obj/machinery/atmospherics/tvalve/mirrored/paired_dirs()
	if(state) // "go to side" but other side
		return list(turn(dir, 180), turn(dir, 90))
	else
		return list(turn(dir, 180), dir)

/obj/machinery/atmospherics/tvalve/mirrored/digital		// can be controlled by AI
	name = "digital switching valve"
	desc = "A digitally controlled valve."
	icon = 'icons/atmos/digital_tvalve.dmi'

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/tvalve/mirrored/digital/bypass
	icon_state = "map_tvalvem1"
	state = 1

/obj/machinery/atmospherics/tvalve/mirrored/digital/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/tvalve/mirrored/digital/update_icon()
	..()
	if(!powered())
		icon_state = "tvalvemnopower"

/obj/machinery/atmospherics/tvalve/mirrored/digital/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/atmospherics/tvalve/mirrored/digital/attack_hand(mob/user as mob)
	if(!powered())
		return
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	..()

//Radio remote control -eh?

/obj/machinery/atmospherics/tvalve/mirrored/digital/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/tvalve/mirrored/digital/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/tvalve/mirrored/digital/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id))
		return 0

	switch(signal.data["command"])
		if("valve_open")
			if(!state)
				go_to_side()

		if("valve_close")
			if(state)
				go_straight()

		if("valve_toggle")
			if(state)
				go_straight()
			else
				go_to_side()
