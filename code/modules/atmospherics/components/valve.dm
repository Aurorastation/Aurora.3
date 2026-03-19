/obj/machinery/atmospherics/valve
	name = "manual valve"
	desc = "A pipe valve."
	icon = 'icons/atmos/valve.dmi'
	icon_state = "map_valve0"

	level = 1
	dir = SOUTH
	initialize_directions = SOUTH|NORTH

	var/open = 0
	var/openDuringInit = 0

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_FUEL|CONNECT_TYPE_AUX
	connect_dir_type = SOUTH | NORTH
	rotate_class = PIPE_ROTATE_TWODIR
	pipe_class = PIPE_CLASS_BINARY
	build_icon_state = "mvalve"
	interact_offline = TRUE

/obj/machinery/atmospherics/valve/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "It is [open ? "open" : "closed"]."

/obj/machinery/atmospherics/valve/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Click this to turn the valve."
	. += "If red, the pipes on each end are seperated. Otherwise, they are connected."

/obj/machinery/atmospherics/valve/open
	open = 1
	icon_state = "map_valve1"

/obj/machinery/atmospherics/valve/proc/do_turn_animation()
	update_icon()
	flick("valve[src.open][!src.open]",src)

/obj/machinery/atmospherics/valve/update_icon(animation)
	icon_state = "valve[open]"
	build_device_underlays(FALSE)

/obj/machinery/atmospherics/valve/hide(var/i)
	update_icon()

/obj/machinery/atmospherics/valve/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(open) //connect everything
		for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
			if(nodes_to_networks[node] != new_network)
				QDEL_NULL(nodes_to_networks[node])
				nodes_to_networks[node] = new_network
				if(node != reference)
					node.network_expand(new_network, src)
		new_network.normal_members |= src
	else
		..() // connect along each dir seperately; this is base behavior

/obj/machinery/atmospherics/valve/proc/open()
	if(open)
		return FALSE

	open = TRUE

	if(LAZYLEN(nodes_to_networks))
		var/datum/pipe_network/winner_network = nodes_to_networks[nodes_to_networks[1]]
		for(var/node in nodes_to_networks)
			if(nodes_to_networks[node] != winner_network)
				winner_network.merge(nodes_to_networks[node]) // this will reset nodes_to_networks[node] to winner_network
			winner_network.update = TRUE

	queue_icon_update()
	return TRUE

/obj/machinery/atmospherics/valve/proc/close()
	if(!open)
		return FALSE

	open = FALSE

	for(var/node in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])

	build_network()

	queue_icon_update()
	return TRUE

/obj/machinery/atmospherics/valve/attack_ai(mob/user)
	return

/obj/machinery/atmospherics/valve/attack_hand(mob/user)
	. = ..()
	user_toggle()

/obj/machinery/atmospherics/valve/proc/toggle()
	return open ? close() : open()

/obj/machinery/atmospherics/valve/proc/user_toggle()
	do_turn_animation()
	sleep(1 SECOND)
	toggle()

/obj/machinery/atmospherics/valve/process()
	..()
	return PROCESS_KILL

/obj/machinery/atmospherics/valve/atmos_init()
	..()
	if(openDuringInit)
		close()
		open()
		openDuringInit = FALSE

/obj/machinery/atmospherics/valve/return_network_air(datum/pipe_network/reference)
	return null

/obj/machinery/atmospherics/valve/digital		// can be controlled by AI
	name = "digital valve"
	desc = "A digitally controlled valve."
	icon = 'icons/atmos/digital_valve.dmi'

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection
	/// Determines if this digital valve should provide an admin message. Set to false if the valve is not relevant to admins.
	var/admin_message = TRUE

/obj/machinery/atmospherics/valve/digital/no_admin_message
	admin_message = FALSE

/obj/machinery/atmospherics/valve/digital/open
	open = 1
	icon_state = "map_valve1"

/obj/machinery/atmospherics/valve/digital/open/no_admin_message
	admin_message = FALSE

/obj/machinery/atmospherics/valve/digital/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return src.attack_hand(user)

/obj/machinery/atmospherics/valve/digital/attack_hand(mob/user as mob)
	if(!powered())
		return
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	..()

	if(admin_message)
		log_and_message_admins("has [open ? SPAN_WARNING("OPENED") : "closed"] [name].", user)

/obj/machinery/atmospherics/valve/digital/AltClick(var/mob/abstract/ghost/observer/admin)
	if (istype(admin))
		if (admin.client && admin.client.holder && ((R_MOD|R_ADMIN) & admin.client.holder.rights))
			if (open)
				close()
			else
				if (alert(admin, "The valve is currently closed. Do you want to open it?", "Open the valve?", "Yes", "No") == "No")
					return
				open()

			log_and_message_admins("has [open ? "opened" : "closed"] [name].", admin)

/obj/machinery/atmospherics/valve/digital/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		queue_icon_update()

/obj/machinery/atmospherics/valve/digital/update_icon()
	..()
	ClearOverlays()
	if(!powered())
		icon_state = "valve[open]nopower"
	else
		AddOverlays(emissive_appearance(icon, "valve-emissive"))

/obj/machinery/atmospherics/valve/digital/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = SSradio.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/valve/digital/atmos_init()
	..()
	if(frequency)
		set_frequency(frequency)

/obj/machinery/atmospherics/valve/digital/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || (signal.data["tag"] != id))
		return 0

	switch(signal.data["command"])
		if("valve_open")
			if(!open)
				open()

		if("valve_close")
			if(open)
				close()

		if("valve_toggle")
			if(open)
				close()
			else
				open()

/obj/machinery/atmospherics/valve/attackby(obj/item/attacking_item, mob/user)
	if (attacking_item.tool_behaviour != TOOL_WRENCH)
		return ..()
	if (istype(src, /obj/machinery/atmospherics/valve/digital))
		to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it's too complicated.")) //TODO: Do we still need this?
		return TRUE
	var/datum/gas_mixture/int_air = return_air()
	if (!loc) return FALSE
	var/datum/gas_mixture/env_air = loc.return_air()
	if ((XGM_PRESSURE(int_air)-XGM_PRESSURE(env_air)) > PRESSURE_EXERTED)
		to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure."))
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
