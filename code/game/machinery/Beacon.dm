/obj/machinery/bluespace_beacon
	name = "bluespace beacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	/// Underfloor
	level = 1
	layer = 2.5
	anchored = TRUE
	idle_power_usage = 0
	var/obj/item/device/radio/beacon/beacon

/obj/machinery/bluespace_beacon/Initialize(mapload, d, populate_components, is_internal)
	. = ..()
	var/turf/T = loc
	beacon = new /obj/item/device/radio/beacon/fixed(T)
	hide(!T.is_plating())

/obj/machinery/bluespace_beacon/Destroy()
	QDEL_NULL(beacon)
	return ..()

/**
 * Update the invisibility and icon
 */
/obj/machinery/bluespace_beacon/hide(var/intact)
	set_invisibility(intact ? 101 : 0)
	update_icon()

/obj/machinery/bluespace_beacon/update_icon()
	var/state="floor_beacon"

	if(invisibility)
		icon_state = "[state]f"
	else
		icon_state = "[state]"
