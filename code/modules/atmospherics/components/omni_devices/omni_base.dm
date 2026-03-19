//--------------------------------------------
// Base omni device
//--------------------------------------------
/obj/machinery/atmospherics/omni
	name = "omni device"
	icon = 'icons/atmos/omni_devices.dmi'
	icon_state = "base"
	initialize_directions = 0
	level = 1
	layer = ABOVE_CATWALK_LAYER

	var/configuring = 0

	var/base_icon

	var/tag_north = ATM_NONE
	var/tag_south = ATM_NONE
	var/tag_east = ATM_NONE
	var/tag_west = ATM_NONE

	var/list/on_states = list()
	var/list/off_states = list()

	var/underlays_current[4]

	var/list/ports = new()

	pipe_class = PIPE_CLASS_OMNI
	connect_dir_type = SOUTH | NORTH | EAST | WEST

/obj/machinery/atmospherics/omni/Initialize()
	icon_state = "base"
	ports = new()
	for(var/d in GLOB.cardinals)
		var/datum/omni_port/new_port = new(src, d)
		switch(d)
			if(NORTH)
				new_port.mode = tag_north
			if(SOUTH)
				new_port.mode = tag_south
			if(EAST)
				new_port.mode = tag_east
			if(WEST)
				new_port.mode = tag_west
		if(new_port.mode > 0)
			initialize_directions |= d
		ports += new_port
	. = ..()

/obj/machinery/atmospherics/omni/update_icon()
	ClearOverlays()
	var/list/to_add = list(base_icon)
	if(stat & NOPOWER)
		to_add += off_states
	else if(error_check())
		to_add += "error"
	else if (use_power)
		to_add[1] = "[base_icon]_glow"
		to_add += on_states
	else
		to_add += off_states

	AddOverlays(to_add)

	underlays = underlays_current

/obj/machinery/atmospherics/omni/proc/error_check()
	return

/obj/machinery/atmospherics/omni/process()
	last_power_draw = 0
	last_flow_rate = 0

	if(error_check())
		update_use_power(POWER_USE_OFF)

	if((stat & (NOPOWER|BROKEN)) || !use_power)
		return 0
	return 1

/obj/machinery/atmospherics/omni/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/omni/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour != TOOL_WRENCH)
		return ..()

	var/int_pressure = 0
	for(var/datum/omni_port/P in ports)
		int_pressure += XGM_PRESSURE(P.air)
	if(!loc) return FALSE
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_pressure - XGM_PRESSURE(env_air)) > PRESSURE_EXERTED)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure."))
		add_fingerprint(user)
		return TRUE
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if(attacking_item.use_tool(src, user, 40, volume = 50))
		user.visible_message( \
			SPAN_NOTICE("\The [user] unfastens \the [src]."), \
			SPAN_NOTICE("You have unfastened \the [src]."), \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, src)
		qdel(src)
		return TRUE

/obj/machinery/atmospherics/omni/attack_hand(user as mob)
	if(..())
		return

	src.add_fingerprint(usr)
	ui_interact(user)
	return

/obj/machinery/atmospherics/omni/proc/update_port_icons()
	//on_states.Cut()
	//off_states.Cut()

	for(var/datum/omni_port/P in ports)
		var/ref_layer = 0
		switch(P.dir)
			if(NORTH)
				ref_layer = 1
			if(SOUTH)
				ref_layer = 2
			if(EAST)
				ref_layer = 3
			if(WEST)
				ref_layer = 4

		if(!ref_layer)
			continue

		var/list/port_icons = select_port_icons(P)
		if(port_icons)
			if(LAZYLEN(P.nodes))
				underlays_current[ref_layer] = port_icons["pipe_icon"]
			else
				underlays_current[ref_layer] = null
			off_states = port_icons["off_icon"]
			on_states = port_icons["on_icon"]
		else
			underlays_current[ref_layer] = null

	update_icon()

// Assumes on_states and off_states have been cut if required.
/obj/machinery/atmospherics/omni/proc/select_port_icons(datum/omni_port/P)
	if(!istype(P))
		return

	if(P.mode > 0)
		var/ic_dir = dir_name(P.dir)
		var/ic_on = ic_dir
		var/ic_off = ic_dir
		switch(P.mode)
			if(ATM_INPUT)
				ic_on += "_in_glow"
				ic_off += "_in"
			if(ATM_OUTPUT)
				ic_on += "_out_glow"
				ic_off += "_out"
			if(ATM_O2 to ATM_H2O)
				ic_on += "_filter"
				ic_off += "_out"

		var/pipe_state_key
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		var/obj/machinery/atmospherics/node = LAZYACCESS(P.nodes, 1)
		if(!T.is_plating() && istype(node, /obj/machinery/atmospherics/pipe) && node.level == LEVEL_BELOW_PLATING)
			pipe_state_key = "down"
		else
			pipe_state_key = "intact"
		var/image/pipe_state = image('icons/atmos/pipe_underlays.dmi', pipe_state_key, dir = P.dir)
		pipe_state.color = color_cache_name(node)

		return list("on_icon" = ic_on, "off_icon" = ic_off, "pipe_icon" = pipe_state)

/obj/machinery/atmospherics/omni/proc/update_underlays()
	for(var/datum/omni_port/P in ports)
		P.update = 1
	update_ports()

/obj/machinery/atmospherics/omni/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/omni/proc/update_ports()
	sort_ports()
	update_port_icons()
	for(var/datum/omni_port/P in ports)
		P.update = FALSE

/obj/machinery/atmospherics/omni/proc/sort_ports()
	return


// Housekeeping and pipe network stuff below

/obj/machinery/atmospherics/omni/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	for(var/datum/omni_port/P in ports)
		if((reference in P.nodes) && (new_network != P.network))
			qdel(P.network)
			P.network = new_network
			for(var/obj/machinery/atmospherics/node as anything in P.nodes)
				if(node != reference)
					node.network_expand(new_network, src)

	new_network.normal_members |= src

/obj/machinery/atmospherics/omni/Destroy()
	QDEL_LIST(ports)
	. = ..()

/obj/machinery/atmospherics/omni/atmos_init()
	atmos_initialised = TRUE
	nodes_to_networks = null
	for(var/datum/omni_port/P in ports)
		P.nodes = null
		QDEL_NULL(P.network)
		if(P.mode == 0)
			continue

		for(var/obj/machinery/atmospherics/target in get_step(src, P.dir))
			if(target.initialize_directions & get_dir(target,src))
				if (check_connect_types(target,src))
					LAZYDISTINCTADD(P.nodes, target)
					LAZYDISTINCTADD(nodes_to_networks, target) // we don't fully track networks here, but we do keep a list of nodes in order to share code

	for(var/datum/omni_port/P in ports)
		P.update = TRUE

	update_ports()

/obj/machinery/atmospherics/omni/build_network()
	for(var/datum/omni_port/P in ports)
		if(!P.network && LAZYLEN(P.nodes))
			P.network = new /datum/pipe_network()
			P.network.normal_members += src
			P.network.build_network(P.nodes[1], src)

/obj/machinery/atmospherics/omni/return_network(obj/machinery/atmospherics/reference)
	build_network()

	for(var/datum/omni_port/P in ports)
		if(reference in P.nodes)
			return P.network

	return null

/obj/machinery/atmospherics/omni/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	for(var/datum/omni_port/P in ports)
		if(P.network == old_network)
			P.network = new_network

	return 1

/obj/machinery/atmospherics/omni/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	for(var/datum/omni_port/P in ports)
		if(P.network == reference)
			results += P.air

	return results

/obj/machinery/atmospherics/omni/disconnect(obj/machinery/atmospherics/reference)
	for(var/datum/omni_port/P in ports)
		if(reference in P.nodes)
			QDEL_NULL(P.network)
			LAZYREMOVE(P.nodes, reference)
			P.update = 1

	LAZYREMOVE(nodes_to_networks, reference)
	update_ports()

/obj/machinery/atmospherics/omni/AltClick(var/mob/user)
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	Topic(src, list("power" = "1"))
