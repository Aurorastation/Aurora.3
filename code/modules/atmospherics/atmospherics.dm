/*
Quick overview:

Pipes combine to form pipelines
Pipelines and other atmospheric objects combine to form pipe_networks
	Note: A single pipe_network represents a completely open space

Pipes -> Pipelines
Pipelines + Other Objects -> Pipe network

*/
/obj/structure/machinery/atmospherics
	anchored = 1
	idle_power_usage = 0
	active_power_usage = 0
	power_channel = AREA_USAGE_ENVIRON
	var/nodealert = 0
	var/power_rating //the maximum amount of power the machine can use to do work, affects how powerful the machine is, in Watts

	plane = FLOOR_PLANE
	layer = ATMOS_PIPE_LAYER

	var/connect_types = CONNECT_TYPE_REGULAR
	var/icon_connect_type = "" //"-supply" or "-scrubbers"

	var/initialize_directions = 0
	var/pipe_color

	var/global/datum/pipe_icon_manager/icon_manager
	var/obj/structure/machinery/atmospherics/node1
	var/obj/structure/machinery/atmospherics/node2
	var/atmos_initialised = FALSE
	gfi_layer_rotation = GFI_ROTATION_OVERDIR

/obj/structure/machinery/atmospherics/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)
	RegisterSignal(src, COMSIG_UNDERTILE_UPDATED, PROC_REF(on_undertile_updated))
	update_underfloor_from_turf()

	if(!icon_manager)
		icon_manager = new()

	if(!pipe_color)
		pipe_color = color
	color = null

	if(!pipe_color_check(pipe_color))
		pipe_color = null

	if (mapload)
		return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/atmospherics/proc/atmos_init()
	atmos_initialised = TRUE

// atmos_init() and Initialize() must be separate, as atmos_init() can be called multiple times after the machine has been initialized.

/obj/structure/machinery/atmospherics/LateInitialize()
	. = ..()
	atmos_init()

/obj/structure/machinery/atmospherics/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paint_sprayer))
		return FALSE
	..()

/obj/structure/machinery/atmospherics/proc/add_underlay(var/turf/T, var/obj/structure/machinery/atmospherics/node, var/direction, var/icon_connect_type)
	if(node)
		if(T.underfloor_accessibility < UNDERFLOOR_INTERACTABLE && node.uses_undertile() && istype(node, /obj/structure/machinery/atmospherics/pipe))
			//underlays += icon_manager.get_atmos_icon("underlay_down", direction, color_cache_name(node))
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "down" + icon_connect_type)
		else
			//underlays += icon_manager.get_atmos_icon("underlay_intact", direction, color_cache_name(node))
			underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "intact" + icon_connect_type)
	else
		//underlays += icon_manager.get_atmos_icon("underlay_exposed", direction, pipe_color)
		underlays += icon_manager.get_atmos_icon("underlay", direction, color_cache_name(node), "exposed" + icon_connect_type)

/obj/structure/machinery/atmospherics/proc/update_underlays()
	if(check_icon_cache())
		return 1
	else
		return 0

/obj/structure/machinery/atmospherics/uses_undertile()
	return FALSE

/obj/structure/machinery/atmospherics/undertile_restored_plane()
	return FLOOR_PLANE

/obj/structure/machinery/atmospherics/undertile_restored_layer()
	return density ? ABOVE_CATWALK_LAYER : HIGH_TURF_LAYER

/obj/structure/machinery/atmospherics/undertile_layer()
	return undertile_restored_layer()

/obj/structure/machinery/atmospherics/proc/on_undertile_updated()
	SHOULD_NOT_SLEEP(TRUE)
	SIGNAL_HANDLER
	update_underlays()
	queue_icon_update()

/obj/structure/machinery/atmospherics/proc/check_connect_types(obj/structure/machinery/atmospherics/atmos1, obj/structure/machinery/atmospherics/atmos2)
	return (atmos1.connect_types & atmos2.connect_types)

/obj/structure/machinery/atmospherics/proc/check_connect_types_construction(obj/structure/machinery/atmospherics/atmos1, obj/item/pipe/pipe2)
	return (atmos1.connect_types & pipe2.connect_types)

/obj/structure/machinery/atmospherics/proc/check_icon_cache(var/safety = 0)
	if(!istype(icon_manager))
		if(!safety) //to prevent infinite loops
			icon_manager = new()
			check_icon_cache(1)
		return 0

	return 1

/obj/structure/machinery/atmospherics/proc/color_cache_name(var/obj/structure/machinery/atmospherics/node)
	//Don't use this for standard pipes
	if(!istype(node))
		return null

	return node.pipe_color

/obj/structure/machinery/atmospherics/process(seconds_per_tick)
	last_flow_rate = 0
	last_power_draw = 0
	last_mole_transfer = 0

	build_network()

/obj/structure/machinery/atmospherics/proc/network_expand(datum/pipe_network/new_network, obj/structure/machinery/atmospherics/pipe/reference)
	// Check to see if should be added to network. Add self if so and adjust variables appropriately.
	// Note don't forget to have neighbors look as well!

	return null

/obj/structure/machinery/atmospherics/proc/build_network()
	// Called to build a network from this node

	return null

/obj/structure/machinery/atmospherics/proc/return_network(obj/structure/machinery/atmospherics/reference)
	// Returns pipe_network associated with connection to reference
	// Notes: should create network if necessary
	// Should never return null

	return null

/obj/structure/machinery/atmospherics/proc/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	// Used when two pipe_networks are combining

/obj/structure/machinery/atmospherics/proc/remove_network(datum/pipe_network/network)
	reassign_network(network, null)

/obj/structure/machinery/atmospherics/proc/return_network_air(datum/pipe_network/reference)
	// Return a list of gas_mixture(s) in the object
	//		associated with reference pipe_network for use in rebuilding the networks gases list
	// Is permitted to return null

/obj/structure/machinery/atmospherics/proc/disconnect(obj/structure/machinery/atmospherics/reference)

/obj/structure/machinery/atmospherics/update_icon()
	return null
