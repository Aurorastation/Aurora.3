/obj/machinery/bluespace_beacon
	name = "bluespace beacon"
	desc = "A device that draws power from bluespace and creates a permanent tracking beacon."
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_beaconf"
	level = 1		// underfloor
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

	// update the invisibility and icon
/obj/machinery/bluespace_beacon/hide(var/intact)
	invisibility = intact ? 101 : 0
	update_icon()

	// update the icon_state
/obj/machinery/bluespace_beacon/update_icon()
	var/state="floor_beacon"

	if(invisibility)
		icon_state = "[state]f"
	else
		icon_state = "[state]"
