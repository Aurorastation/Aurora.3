/obj/machinery/bluespacerelay
	name = "Emergency Bluespace Relay"
	desc = "This sends messages through bluespace! Wow!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bspacerelay"

	anchored = 1
	density = 1
	use_power = 1
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

/obj/machinery/bluespacerelay/machinery_process()

	update_power()

	update_icon()

/obj/machinery/bluespacerelay/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]_off"

/obj/machinery/bluespacerelay/proc/update_power()

	if(stat & (BROKEN|NOPOWER|EMPED))
		on = 0
	else
		on = 1

/obj/machinery/bluespacerelay/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	..()
