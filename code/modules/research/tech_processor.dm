/obj/machinery/r_n_d/tech_processor
	name = "\improper R&D tech processor"
	desc = "A highly advanced analytical computation engine, when connected to an R&D server with a multitool, it will start processing known technology and add research points to it."
	icon_state = "RD-server"

	component_types = list(
		/obj/item/circuitboard/rdtechprocessor,
		/obj/item/stock_parts/scanning_module = 2,
		/obj/item/stack/cable_coil = 2
	)

	idle_power_usage = 800

	var/tech_rate = 0
	var/obj/machinery/r_n_d/server/linked_server

	var/processing_stage = 0

	var/heat_delay = 10

	parts_power_mgmt = FALSE

/obj/machinery/r_n_d/tech_processor/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>scanning modules</b> will increase speed at which research calculations are made and reduce active power usage."

/obj/machinery/r_n_d/tech_processor/Destroy()
	set_server(null)
	return ..()

/obj/machinery/r_n_d/tech_processor/RefreshParts()
	..()
	tech_rate = 0
	for(var/obj/item/stock_parts/scanning_module/SM in component_parts)
		tech_rate += SM.rating / 2
	change_power_consumption(initial(idle_power_usage) * tech_rate, POWER_USE_IDLE)
	update_icon()

/obj/machinery/r_n_d/tech_processor/process()
	heat_delay--
	if(!heat_delay)
		produce_heat()
		heat_delay = initial(heat_delay)

/obj/machinery/r_n_d/tech_processor/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.ismultitool())
		var/obj/item/device/multitool/MT = attacking_item
		MT.set_buffer(src)
		to_chat(user, SPAN_NOTICE("You attach \the [src]'s linking node to \the [MT]'s machinery buffer."))
		return
	if(default_deconstruction_screwdriver(user, attacking_item))
		return
	if(default_deconstruction_crowbar(user, attacking_item))
		return
	if(default_part_replacement(user, attacking_item))
		return
	return ..()

/obj/machinery/r_n_d/tech_processor/proc/set_server(var/obj/machinery/r_n_d/server/S)
	if(linked_server)
		LAZYREMOVE(linked_server.linked_processors, src)
	linked_server = S
	if(linked_server)
		LAZYADD(linked_server.linked_processors, src)
	update_icon()

/obj/machinery/r_n_d/tech_processor/proc/produce_heat()
	if(!(stat & (NOPOWER|BROKEN)))
		var/turf/simulated/L = loc
		if(istype(L))
			var/datum/gas_mixture/env = L.return_air()
			var/transfer_moles = 0.25 * env.total_moles
			var/datum/gas_mixture/removed = env.remove(transfer_moles)
			if(removed)
				var/heat_produced = idle_power_usage	//obviously can't produce more heat than the machine draws from it's power source
				removed.add_thermal_energy(heat_produced)
			env.merge(removed)

/obj/machinery/r_n_d/tech_processor/power_change()
	. = ..()
	update_icon()

/obj/machinery/r_n_d/tech_processor/update_icon()
	ClearOverlays()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "[initial(icon_state)]-off"
	else if(!linked_server)
		icon_state = "[initial(icon_state)]-halt"
	else
		icon_state = "[initial(icon_state)]-on"
	if(panel_open)
		AddOverlays("[initial(icon_state)]_open")
