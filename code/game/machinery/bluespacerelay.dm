/obj/machinery/bluespacerelay
	name = "Emergency Bluespace Relay"
	desc = "This sends messages through bluespace! Wow!"
	icon = 'icons/obj/machinery/telecomms.dmi'
	icon_state = "bspacerelay"

	anchored = 1
	density = 1
	var/on = 1

	idle_power_usage = 15000
	active_power_usage = 15000

	component_types = list(
		/obj/item/circuitboard/bluespacerelay,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/stock_parts/subspace/filter,
		/obj/item/stock_parts/subspace/crystal,
		/obj/item/stack/cable_coil
	)

/obj/machinery/bluespacerelay/process()
	update_power()

	update_icon()

/obj/machinery/bluespacerelay/update_icon()
	ClearOverlays()
	if(on)
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")

/obj/machinery/bluespacerelay/proc/update_power()

	if(stat & (BROKEN|NOPOWER|EMPED))
		on = 0
	else
		on = 1

/obj/machinery/bluespacerelay/attackby(obj/item/attacking_item, mob/user)
	if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE

	return ..()
