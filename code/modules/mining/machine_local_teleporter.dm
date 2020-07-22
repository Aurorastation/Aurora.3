/obj/machinery/mineral/local_teleporter
	name = "local teleporter"
	desc = "A floor-mounted local area teleporter. Due to its small size, it can only teleport objects across a short distance."
	desc_info = "An upgraded capacitor will extends the possible teleport range. Click on it to refresh its linked partner."
	icon = 'icons/obj/mining.dmi'
	icon_state = "local_teleporter"
	density = FALSE
	anchored = TRUE
	use_power = FALSE
	active_power_usage = 500
	
	component_types = list(
		/obj/item/circuitboard/local_teleporter,
		/obj/item/bluespace_crystal/artificial,
		/obj/item/stock_parts/capacitor,
		/obj/item/stack/cable_coil{amount = 1}
	)

	var/obj/machinery/mineral/local_teleporter/linked_teleporter
	var/connected_overlay
	var/teleport_range = 2

/obj/machinery/mineral/local_teleporter/Initialize(mapload)
	..()
	connected_overlay = icon(icon, "[initial(icon_state)]-connected")
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/mineral/local_teleporter/LateInitialize()
	look_for_partner()

/obj/machinery/mineral/local_teleporter/proc/look_for_partner()
	linked_teleporter = null
	var/turf/T = get_turf(src)
	for(var/i = 1 to teleport_range)
		T = get_step(T, dir)
		linked_teleporter = locate() in T
		if(linked_teleporter)
			check_connected_overlay()
			break

/obj/machinery/mineral/local_teleporter/attack_hand(mob/user)
	to_chat(user, SPAN_NOTICE("You press the \"Refresh\" button on \the [src]."))
	look_for_partner()

/obj/machinery/mineral/local_teleporter/attackby(obj/item/W, mob/user)
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

/obj/machinery/mineral/local_teleporter/RefreshParts()
	..()
	teleport_range = 2

	var/obj/item/stock_parts/capacitor/C = locate() in component_parts
	if(C)
		teleport_range *= C.rating
	look_for_partner()

/obj/machinery/mineral/local_teleporter/proc/check_connected_overlay()
	cut_overlay(connected_overlay)
	if(linked_teleporter && !(stat & BROKEN) && !(stat & NOPOWER))
		add_overlay(connected_overlay)

/obj/machinery/mineral/local_teleporter/power_change()
	..()
	check_connected_overlay()

/obj/machinery/mineral/local_teleporter/Crossed(atom/movable/O)
	if((stat & BROKEN) || (stat & NOPOWER))
		return
	if(ismob(O))
		to_chat(O, SPAN_NOTICE("You step into \the [src] and get teleported to its linked teleporter."))
	use_power(active_power_usage)
	O.forceMove(get_turf(linked_teleporter))
	if(!ismob(O)) // to get anything that lands on us off the teleporter
		var/list/step_dirs = cardinal
		step_dirs -= reverse_dir[dir]
		step(O, pick(step_dirs), 1)
	spark(O, 3, alldirs)

/obj/machinery/mineral/local_teleporter/Destroy()
	if(linked_teleporter)
		linked_teleporter.linked_teleporter = null
		linked_teleporter.check_connected_overlay()
		linked_teleporter = null
	return ..()

/obj/item/circuitboard/local_teleporter
	name = T_BOARD("local teleporter")
	build_path = /obj/machinery/mineral/local_teleporter
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_MATERIAL = 3, TECH_BLUESPACE = 4)
	req_components = list(
		"/obj/item/bluespace_crystal" = 1,
		"/obj/item/stock_parts/capacitor" = 1,
		"/obj/item/stack/cable_coil" = 1
	)