/obj/machinery/atmospherics/portables_connector
	icon = 'icons/atmos/connector.dmi'
	icon_state = "map_connector"

	name = "connector port"
	desc = "A connector port with a flexible tube that can be attached to portable atmospherics devices using a wrench."

	dir = SOUTH
	initialize_directions = SOUTH
	interact_offline = TRUE

	build_icon_state = "connector"

	var/obj/machinery/portable_atmospherics/connected_device

	var/datum/pipe_network/network

	use_power = POWER_USE_OFF
	level = 1

	pipe_class = PIPE_CLASS_UNARY

/obj/machinery/atmospherics/portables_connector/update_icon()
	icon_state = "connector"
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/portables_connector/fuel
	icon_state = "map_connector-fuel"
	icon_connect_type = "-fuel"
	connect_types = CONNECT_TYPE_FUEL

/obj/machinery/atmospherics/portables_connector/fuel/update_icon()
	icon_state = "connector-fuel"
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/portables_connector/aux
	icon_state = "map_connector-aux"
	icon_connect_type = "-aux"
	connect_types = CONNECT_TYPE_AUX

/obj/machinery/atmospherics/portables_connector/aux/update_icon()
	icon_state = "connector-aux"
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/portables_connector/supply
	icon_state = "map_connector-supply"
	icon_connect_type = "-supply"
	connect_types = CONNECT_TYPE_SUPPLY

/obj/machinery/atmospherics/portables_connector/supply/update_icon()
	icon_state = "connector-supply"
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/portables_connector/scrubber
	icon_state = "map_connector-scrubber"
	icon_connect_type = "-scrubber"
	connect_types = CONNECT_TYPE_SCRUBBER

/obj/machinery/atmospherics/portables_connector/scrubber/update_icon()
	icon_state = "connector-scrubber"
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/portables_connector/Initialize()
	initialize_directions = dir
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/atmospherics/portables_connector/LateInitialize()
	. = ..()
	toggle_process()

/obj/machinery/atmospherics/portables_connector/hide(var/i)
	queue_icon_update()

/obj/machinery/atmospherics/portables_connector/proc/toggle_process()
	if(connected_device)
		START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	else
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/atmospherics/portables_connector/process()
	if(!connected_device)
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
	update_networks()
	return TRUE

/obj/machinery/atmospherics/portables_connector/Destroy()
	if(connected_device)
		connected_device.disconnect()
	. = ..()

/obj/machinery/atmospherics/portables_connector/return_network(obj/machinery/atmospherics/reference)
	. = ..()

	if(reference == connected_device)
		if(LAZYLEN(nodes_to_networks))
			return nodes_to_networks[nodes_to_networks[1]]

/obj/machinery/atmospherics/portables_connector/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(connected_device)
		results += connected_device.air_contents

	return results


/obj/machinery/atmospherics/portables_connector/attackby(obj/item/attacking_item, mob/user)
	if (attacking_item.tool_behaviour != TOOL_WRENCH)
		return ..()
	if (connected_device)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], dettach \the [connected_device] first."))
		return TRUE
	if (locate(/obj/machinery/portable_atmospherics, src.loc))
		return TRUE
	var/datum/gas_mixture/int_air = return_air()
	if(!loc) return FALSE
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((XGM_PRESSURE(int_air)-XGM_PRESSURE(env_air)) > PRESSURE_EXERTED)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it too exerted due to internal pressure."))
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
