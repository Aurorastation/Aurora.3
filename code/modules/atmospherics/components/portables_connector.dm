/obj/machinery/atmospherics/portables_connector
	icon = 'icons/atmos/connector.dmi'
	icon_state = "map_connector"

	name = "Connector Port"
	desc = "For connecting portables devices related to atmospherics control."

	dir = SOUTH
	initialize_directions = SOUTH

	var/obj/machinery/portable_atmospherics/connected_device

	var/obj/machinery/atmospherics/node

	var/datum/pipe_network/network

	use_power = POWER_USE_OFF
	level = 1

/obj/machinery/atmospherics/portables_connector/fuel
	icon_state = "map_connector-fuel"
	icon_connect_type = "-fuel"
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/portables_connector/aux
	icon_state = "map_connector-aux"
	icon_connect_type = "-aux"
	connect_types = CONNECT_TYPE_AUX

/obj/machinery/atmospherics/portables_connector/supply
	icon_state = "map_connector-supply"
	icon_connect_type = "-supply"
	connect_types = CONNECT_TYPE_SUPPLY

/obj/machinery/atmospherics/portables_connector/scrubber
	icon_state = "map_connector-scrubber"
	icon_connect_type = "-scrubber"
	connect_types = CONNECT_TYPE_SCRUBBER


/obj/machinery/atmospherics/portables_connector/Initialize()
	initialize_directions = dir
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/atmospherics/portables_connector/LateInitialize()
	toggle_process()

/obj/machinery/atmospherics/portables_connector/update_icon()
	icon_state = "connector" + icon_connect_type

/obj/machinery/atmospherics/portables_connector/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		add_underlay(T, node, dir, node?.icon_connect_type)

/obj/machinery/atmospherics/portables_connector/hide(var/i)
	update_underlays()

/obj/machinery/atmospherics/portables_connector/proc/toggle_process()
	if(connected_device)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	else
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/atmospherics/portables_connector/process()
	if(network)
		network.update = 1

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/portables_connector/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node)
		network = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members += src

	return null

/obj/machinery/atmospherics/portables_connector/Destroy()
	loc = null

	if(connected_device)
		connected_device.disconnect()

	if(node)
		node.disconnect(src)
		qdel(network)

	node = null

	return ..()

/obj/machinery/atmospherics/portables_connector/atmos_init()
	if(node) return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src,node_connect))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node = target
				break

	update_icon()
	update_underlays()

/obj/machinery/atmospherics/portables_connector/build_network()
	if(!network && node)
		network = new /datum/pipe_network()
		network.normal_members += src
		network.build_network(node, src)


/obj/machinery/atmospherics/portables_connector/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference==node)
		return network

	if(reference==connected_device)
		return network

	return null

/obj/machinery/atmospherics/portables_connector/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network == old_network)
		network = new_network

	return 1

/obj/machinery/atmospherics/portables_connector/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(connected_device)
		results += connected_device.air_contents

	return results

/obj/machinery/atmospherics/portables_connector/disconnect(obj/machinery/atmospherics/reference)
	if(reference==node)
		qdel(network)
		node = null

	update_underlays()

	return null


/obj/machinery/atmospherics/portables_connector/attackby(obj/item/attacking_item, mob/user)
	if (!attacking_item.iswrench())
		return ..()
	if (connected_device)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], dettach \the [connected_device] first."))
		return TRUE
	if (locate(/obj/machinery/portable_atmospherics, src.loc))
		return TRUE
	var/datum/gas_mixture/int_air = return_air()
	if(!loc) return FALSE
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((int_air.return_pressure()-env_air.return_pressure()) > PRESSURE_EXERTED)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it too exerted due to internal pressure."))
		add_fingerprint(user)
		return TRUE
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if(attacking_item.use_tool(src, user, istype(attacking_item, /obj/item/pipewrench) ? 80 : 40, volume = 50))
		user.visible_message( \
			SPAN_NOTICE("\The [user] unfastens \the [src]."), \
			SPAN_NOTICE("You have unfastened \the [src]."), \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		qdel(src)
		return TRUE
