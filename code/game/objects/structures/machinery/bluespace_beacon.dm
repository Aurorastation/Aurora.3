/obj/structure/machinery/bluespace_beacon
	name = "bluespace beacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	/// Underfloor
	level = 1
	plane = FLOOR_PLANE
	layer = WIRE_TERMINAL_LAYER
	anchored = TRUE
	idle_power_usage = 0
	var/obj/item/radio/beacon/beacon

/obj/structure/machinery/bluespace_beacon/Initialize(mapload, d, populate_components, is_internal)
	. = ..()
	var/turf/T = loc
	beacon = new /obj/item/radio/beacon/fixed(T)
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE)
	RegisterSignal(src, COMSIG_UNDERTILE_UPDATED, PROC_REF(on_undertile_updated))
	update_underfloor_from_turf()

/obj/structure/machinery/bluespace_beacon/Destroy()
	QDEL_NULL(beacon)
	return ..()

/obj/structure/machinery/bluespace_beacon/uses_undertile()
	return TRUE

/obj/structure/machinery/bluespace_beacon/proc/on_undertile_updated()
	SIGNAL_HANDLER
	update_icon()

/obj/structure/machinery/bluespace_beacon/update_icon()
	var/state="floor_beacon"

	if(invisibility)
		icon_state = "[state]f"
	else
		icon_state = "[state]"
