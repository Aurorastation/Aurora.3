/obj/structure/machinery/ntnet_relay
	name = "NTNet Quantum Relay"
	desc = "A very complex core router and transmitter capable of connecting electronic devices together. Looks fragile."
	use_power = POWER_USE_ACTIVE
	active_power_usage = 20000 //20kW, appropriate for machine that keeps massive cross-Zlevel wireless network operational.
	idle_power_usage = 100
	icon_state = "relay"
	icon = 'icons/obj/machinery/telecomms.dmi'
	anchored = TRUE
	density = TRUE
	/// This is mostly for backwards reference and to allow varedit modifications from ingame.
	var/datum/ntnet/NTNet
	/// Set to FALSE if the relay was turned off
	var/enabled = FALSE
	/// Set to TRUE if the relay failed due to (D)DoS attack
	var/dos_failure = FALSE
	/// Backwards reference for qdel() stuff
	var/list/dos_sources = list()
	/// Core relays are the NTNet source of truth. Field relays only extend a live core.
	var/core_service = FALSE
	/// Overmap tile range from this relay's sector to an operable core.
	var/backhaul_range = 0

	// Denial of Service attack variables
	/// Amount of DoS "packets" in this relay's buffer
	var/dos_overload = 0
	/// Amount of DoS "packets" in buffer required to crash the relay
	var/dos_capacity = 500
	/// Amount of DoS "packets" dissipated over time.
	var/dos_dissipate = 1

	component_types = list(
		/obj/item/stack/cable_coil{amount = 15},
		/obj/item/circuitboard/ntnet_relay/core
	)

/obj/structure/machinery/ntnet_relay/core
	enabled = TRUE
	core_service = TRUE

/obj/structure/machinery/ntnet_relay/operable()
	if(!..(EMPED))
		return FALSE
	if(dos_failure)
		return FALSE
	if(!enabled)
		return FALSE
	return TRUE

/obj/structure/machinery/ntnet_relay/proc/provides_core_service()
	return core_service && operable() && is_valid_core_location()

/obj/structure/machinery/ntnet_relay/proc/resolve_linked()
	if(!SSatlas.current_map.use_overmap)
		return linked
	if(!istype(linked))
		sync_linked()
	return linked

/obj/structure/machinery/ntnet_relay/proc/is_valid_core_location()
	if(!SSatlas.current_map.use_overmap)
		return TRUE
	resolve_linked()
	if(istype(linked))
		return linked.base
	return is_station_level(z)

/obj/structure/machinery/ntnet_relay/proc/can_route_to_core()
	if(!operable())
		return FALSE
	if(core_service)
		return provides_core_service()
	if(!GLOB.ntnet_global || !GLOB.ntnet_global.has_operable_core())
		return FALSE
	for(var/obj/structure/machinery/ntnet_relay/R in GLOB.ntnet_global.relays)
		if(R == src || !R.provides_core_service())
			continue
		if(can_backhaul_to(R))
			return TRUE
	return FALSE

/obj/structure/machinery/ntnet_relay/proc/can_backhaul_to(var/obj/structure/machinery/ntnet_relay/core)
	if(!istype(core) || !core.provides_core_service())
		return FALSE
	resolve_linked()
	core.resolve_linked()
	if(SSatlas.current_map.use_overmap && istype(linked) && istype(core.linked))
		return get_dist(linked, core.linked) <= backhaul_range
	return AreConnectedZLevels(z, core.z)

/obj/structure/machinery/ntnet_relay/proc/get_covered_z_levels()
	resolve_linked()
	if(SSatlas.current_map.use_overmap && istype(linked))
		return linked.map_z.Copy()
	return GetConnectedZlevels(z)

/obj/structure/machinery/ntnet_relay/proc/covers_z(var/z_level)
	if(!z_level || !can_route_to_core())
		return FALSE
	return z_level in get_covered_z_levels()

/obj/structure/machinery/ntnet_relay/proc/get_signal(var/obj/item/computer_hardware/network_card/card)
	if(!istype(card) || !card.parent_computer)
		return 0
	var/turf/T = get_turf(card.parent_computer)
	if(!istype(T) || !covers_z(T.z))
		return 0
	if(card.ethernet)
		return 3
	if(card.long_range)
		return 2
	return 1

/obj/structure/machinery/ntnet_relay/update_icon()
	ClearOverlays()
	if(operable())
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")
	if(dos_failure)
		AddOverlays(emissive_appearance(icon, "[icon_state]_failure"))
		AddOverlays("[icon_state]_failure")
	if(!enabled)
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_failure"))
		AddOverlays("[icon_state]_lights_failure")
	if(panel_open)
		AddOverlays("[icon_state]_panel")

/obj/structure/machinery/ntnet_relay/process()
	if(operable())
		update_use_power(POWER_USE_ACTIVE)
	else
		update_use_power(POWER_USE_IDLE)

	if(dos_overload)
		dos_overload = max(0, dos_overload - dos_dissipate)

	// If DoS traffic exceeded capacity, crash.
	if((dos_overload > dos_capacity) && !dos_failure)
		dos_failure = TRUE
		update_icon()
		GLOB.ntnet_global.add_log("Quantum relay switched from normal operation mode to overload recovery mode.")
	// If the DoS buffer reaches 0 again, restart.
	if((dos_overload == 0) && dos_failure)
		dos_failure = FALSE
		update_icon()
		GLOB.ntnet_global.add_log("Quantum relay switched from overload recovery mode to normal operation mode.")
	..()

/obj/structure/machinery/ntnet_relay/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NTNetRelay")
		ui.open()

/obj/structure/machinery/ntnet_relay/ui_data(mob/user)
	var/list/data = list()
	data["enabled"] = enabled
	data["dos_capacity"] = dos_capacity
	data["dos_overload"] = dos_overload
	data["dos_crashed"] = dos_failure
	data["relay_class"] = core_service ? "Core" : "Field"
	data["linked_sector"] = linked ? linked.name : "Unlinked"
	data["backhaul_range"] = backhaul_range
	data["backhaul_online"] = can_route_to_core()

	return data

/obj/structure/machinery/ntnet_relay/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(action=="restart")
		dos_overload = FALSE
		dos_failure = FALSE
		update_icon()
		GLOB.ntnet_global.add_log("Quantum relay manually restarted from overload recovery mode to normal operation mode.")
		. = TRUE
	if(action=="toggle")
		enabled = !enabled
		GLOB.ntnet_global.add_log("Quantum relay manually [enabled ? "enabled" : "disabled"].")
		update_icon()
		. = TRUE

/obj/structure/machinery/ntnet_relay/attack_hand(var/mob/living/user)
	ui_interact(user)

/obj/structure/machinery/ntnet_relay/Initialize()
	. = ..()
	uid = gl_uid
	gl_uid++

	resolve_linked()
	update_icon()

	if(GLOB.ntnet_global)
		GLOB.ntnet_global.relays.Add(src)
		NTNet = GLOB.ntnet_global
		GLOB.ntnet_global.add_log("New quantum relay activated. Current amount of linked relays: [NTNet.relays.len]")

/obj/structure/machinery/ntnet_relay/LateInitialize()
	. = ..()
	sync_linked()

/obj/structure/machinery/ntnet_relay/Destroy()
	if(GLOB.ntnet_global)
		GLOB.ntnet_global.relays.Remove(src)
		GLOB.ntnet_global.add_log("Quantum relay connection severed. Current amount of linked relays: [NTNet.relays.len]")
	return ..()

/obj/structure/machinery/ntnet_relay/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER)
		attacking_item.play_tool_sound(get_turf(src), 50)
		panel_open = !panel_open
		to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance hatch."))
		return
	if(attacking_item.tool_behaviour == TOOL_CROWBAR)
		if(!panel_open)
			to_chat(user, SPAN_WARNING("Open the maintenance panel first."))
			return
		attacking_item.play_tool_sound(get_turf(src), 50)
		to_chat(user, SPAN_NOTICE("You disassemble \the [src]!"))

		for(var/atom/movable/A in component_parts)
			A.forceMove(get_turf(src))
		new /obj/structure/machinery/constructable_frame/machine_frame(get_turf(src))
		qdel(src)
		return
	..()

/obj/structure/machinery/ntnet_relay/field
	name = "NTNet Field Relay"
	desc = "A deployable NTNet relay that extends local network coverage while it has short-range backhaul to an operational core relay."
	active_power_usage = 5000
	core_service = FALSE
	backhaul_range = 1
	component_types = list(
		/obj/item/stack/cable_coil{amount = 15},
		/obj/item/circuitboard/ntnet_relay
	)
