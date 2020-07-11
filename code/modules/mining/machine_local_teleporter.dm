/obj/machinery/mineral/local_teleporter
	name = "local teleporter"
	desc = "A floor-mounted local area teleporter. Due to its small size, it can only teleport objects across a short distance."
	icon = 'icons/obj/mining.dmi'
	icon_state = "local_teleporter"
	density = FALSE
	anchored = TRUE
	use_power = FALSE
	active_power_usage = 500
	var/obj/machinery/mineral/local_teleporter/linked_teleporter
	var/connected_overlay

/obj/machinery/mineral/local_teleporter/Initialize(mapload)
	..()
	connected_overlay = icon(icon, "[initial(icon_state)]-connected")
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/mineral/local_teleporter/LateInitialize()
	var/turf/T = get_step(src, dir)
	linked_teleporter = locate() in get_step(T, dir)
	if(linked_teleporter)
		add_overlay(connected_overlay)

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