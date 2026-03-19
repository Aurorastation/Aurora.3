/*
Quick overview:

Pipes combine to form pipelines
Pipelines and other atmospheric objects combine to form pipe_networks
	Note: A single pipe_network represents a completely open space

Pipes -> Pipelines
Pipelines + Other Objects -> Pipe network

*/
#define LEVEL_BELOW_PLATING 1
#define LEVEL_ABOVE_PLATING 2
/obj/machinery/atmospherics
	anchored = TRUE
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = AREA_USAGE_ENVIRON

	var/nodealert = 0
	var/power_rating //the maximum amount of power the machine can use to do work, affects how powerful the machine is, in Watts

	layer = EXPOSED_PIPE_LAYER
	var/hidden_layer = PIPE_LAYER

	var/connect_types = CONNECT_TYPE_REGULAR
	var/connect_dir_type = SOUTH // Assume your dir is SOUTH. What dirs should you connect to?
	var/icon_connect_type = "" //"-supply" or "-scrubbers"

	var/initialize_directions = 0
	var/pipe_color

	var/list/nodes_to_networks // lazylist of node -> network to which the node connection belongs if any

	var/atmos_initialised = FALSE
	var/build_icon = 'icons/obj/pipe-item.dmi'
	var/build_icon_state = "buildpipe"

	var/pipe_class = PIPE_CLASS_OTHER //If somehow something isn't set properly, handle it as something with zero connections. This will prevent runtimes.
	var/rotate_class = PIPE_ROTATE_STANDARD
	gfi_layer_rotation = GFI_ROTATION_OVERDIR
	blocks_emissive = EMISSIVE_BLOCK_GENERIC

/obj/machinery/atmospherics/Initialize(mapload)
	if(!pipe_color)
		pipe_color = color
	color = null

	if(!pipe_color_check(pipe_color))
		pipe_color = null

	set_dir(dir) // Does full dir init.
	. = ..()

/obj/machinery/atmospherics/Destroy()
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])
		node.disconnect(src)
	LAZYNULL(nodes_to_networks)
	. = ..()

/obj/machinery/atmospherics/proc/atmos_init()
	atmos_initialised = TRUE
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])
	LAZYNULL(nodes_to_networks)
	for(var/direction in GLOB.cardinals)
		if(direction & initialize_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if((target.initialize_directions & get_dir(target,src)) && check_connect_types(target, src))
					LAZYDISTINCTADD(nodes_to_networks, target)
	update_icon()

// atmos_init() and Initialize() must be separate, as atmos_init() can be called multiple times after the machine has been initialized.

/obj/machinery/atmospherics/LateInitialize()
	. = ..()
	atmos_init()

/obj/machinery/atmospherics/proc/nodes_in_dir(direction)
	. = list()
	for(var/node as anything in nodes_to_networks)
		if(get_dir(src, node) == direction)
			. += node

/obj/machinery/atmospherics/proc/network_in_dir(direction)
	if(!LAZYLEN(nodes_to_networks))
		return
	for(var/node as anything in nodes_in_dir(direction))
		if(nodes_to_networks[node])
			return nodes_to_networks[node]

/obj/machinery/atmospherics/hide(do_hide)
	if(do_hide && level == 1)
		layer = hidden_layer
	else
		reset_plane_and_layer()

/obj/machinery/atmospherics/set_dir(new_dir)
	. = ..()
	initialize_directions = get_initialize_directions()

/// returns all pipe's endpoints. You can override, but you may then need to use a custom /item/pipe constructor.
/obj/machinery/atmospherics/proc/get_initialize_directions()
	return base_pipe_initialize_directions(dir, connect_dir_type)

/proc/base_pipe_initialize_directions(dir, connect_dir_type)
	if(!dir)
		return 0
	if(!(dir in GLOB.cardinals))
		return dir // You're on your own. Used for bent pipes.
	. = 0

	if(connect_dir_type & SOUTH)
		. |= dir
	if(connect_dir_type & NORTH)
		. |= turn(dir, 180)
	if(connect_dir_type & WEST)
		. |= turn(dir, -90)
	if(connect_dir_type & EAST)
		. |= turn(dir, 90)

/// Used by constructors. Shouldn't generally be called from elsewhere.
/obj/machinery/proc/set_initial_level()
	var/turf/T = get_turf(src)
	if(T)
		level = (!T.is_plating() ? 2 : 1)

/obj/machinery/atmospherics/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paint_sprayer))
		return FALSE
	..()

/obj/machinery/atmospherics/proc/add_underlay(turf/T, obj/machinery/atmospherics/node, direction, icon_connect_type, default_state = "exposed", icon = 'icons/atmos/pipe_underlays.dmi')
	var/state = default_state
	if(node)
		if(!T.is_plating() && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			state = "down"
		else
			state = "intact"

	var/image/underlay = image(icon, "[state][icon_connect_type]", dir = direction)
	underlay.color = color_cache_name(node)
	var/mutable_appearance/underlay_blocker = emissive_blocker(icon, "[state][icon_connect_type]")
	underlay_blocker.dir = direction
	underlay.AddOverlays(underlay_blocker)
	underlays += underlay

// Code sharing for non-pipe devices
/obj/machinery/atmospherics/proc/build_device_underlays(hide_hidden_pipes = TRUE)
	underlays.Cut()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	var/disconnected_directions = initialize_directions
	var/visible_directions = 0
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		var/node_dir = get_dir(src, node)
		disconnected_directions &= ~node_dir
		if(hide_hidden_pipes && !T.is_plating() && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			continue
		else
			add_underlay(T, node, node_dir, node.icon_connect_type)
			visible_directions |= node_dir
	for(var/direction in GLOB.cardinals)
		if(disconnected_directions & direction)
			add_underlay(T, null, direction) // adds a disconnected underlay there
			visible_directions |= direction

	return visible_directions // returns flag with all directions in which a visible underlay was added

/obj/machinery/atmospherics/proc/check_connect_types(obj/machinery/atmospherics/atmos1, obj/machinery/atmospherics/atmos2)
	return (atmos1.connect_types & atmos2.connect_types)

/obj/machinery/atmospherics/proc/check_connect_types_construction(obj/machinery/atmospherics/atmos1, obj/item/pipe/pipe2)
	return (atmos1.connect_types & pipe2.connect_types)

/obj/machinery/atmospherics/proc/color_cache_name(obj/machinery/atmospherics/node)
	//Don't use this for standard pipes
	if(!istype(node))
		return null

	return node.pipe_color

/obj/machinery/atmospherics/process(seconds_per_tick)
	last_flow_rate = 0
	last_power_draw = 0

	build_network()

/// Check to see if should be added to network. Add self if so and adjust variables appropriately.
/// Note don't forget to have neighbors look as well!
/obj/machinery/atmospherics/proc/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	// Default behavior is: one network for all nodes in a given dir
	for(var/obj/machinery/atmospherics/node as anything in nodes_in_dir(get_dir(src, reference)))
		if(nodes_to_networks[node] != new_network)
			qdel(nodes_to_networks[node])
			nodes_to_networks[node] = new_network
			if(node != reference)
				node.network_expand(new_network, src)

	new_network.normal_members |= src

// Called to update a network from this node. A null direction will update all directions.
/obj/machinery/atmospherics/proc/update_networks(direction)
	for(var/node as anything in nodes_to_networks)
		if(direction && !(get_dir(src, node) & direction))
			continue
		var/datum/pipe_network/net = nodes_to_networks[node]
		net.update = TRUE

/// Called to build a network from this node
/obj/machinery/atmospherics/proc/build_network()
	for(var/node in nodes_to_networks)
		if(!nodes_to_networks[node])
			var/datum/pipe_network/net = new
			nodes_to_networks[node] = net
			net.normal_members += src
			net.build_network(node, src)

/// Returns pipe_network associated with connection to reference
/// Notes: should create network if necessary
/// Should never return null
/obj/machinery/atmospherics/proc/return_network(obj/machinery/atmospherics/reference)
	build_network()
	return LAZYACCESS(nodes_to_networks, reference)

/// Used when two pipe_networks are combining
/obj/machinery/atmospherics/proc/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	for(var/node in nodes_to_networks)
		if(nodes_to_networks[node] == old_network)
			nodes_to_networks[node] = new_network

/// Return a list of gas_mixture(s) in the object
/// associated with reference pipe_network for use in rebuilding the networks gases list
/// Is permitted to return null
/obj/machinery/atmospherics/proc/return_network_air(datum/pipe_network/reference)
	var/directions = 0
	for(var/node in nodes_to_networks)
		if(nodes_to_networks[node] == reference)
			directions |= get_dir(src, node)
	for(var/direction in GLOB.cardinals)
		if(!(direction & directions))
			continue
		var/air = air_in_dir(direction)
		if(air)
			LAZYDISTINCTADD(., air)

/// Disconnects the object from the reference pipe_network
/obj/machinery/atmospherics/proc/disconnect(obj/machinery/atmospherics/reference)
	if(reference in nodes_to_networks)
		qdel(nodes_to_networks[reference])
		LAZYREMOVE(nodes_to_networks, reference)
		update_icon()

/obj/machinery/atmospherics/update_icon()
	return null

// called after being built by hand, before the pipe item or circuit is deleted
/obj/machinery/atmospherics/proc/build(obj/item/builder)
	atmos_init()
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		node.atmos_init()
	build_network()
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		node.build_network()

// implement internally
/obj/machinery/atmospherics/proc/air_in_dir(direction)
