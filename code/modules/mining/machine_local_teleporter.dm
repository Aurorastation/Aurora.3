/obj/machinery/mineral/local_teleporter
	name = "local teleporter"
	desc = "A floor-mounted local area teleporter. Due to the small configuration, it can only teleport anything that crosses a short distance."
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

/obj/machinery/mineral/local_teleporter/power_change()
	..()
	cut_overlay(connected_overlay)
	if(linked_teleporter && !(stat & NOPOWER) && !(stat & NOPOWER))
		add_overlay(connected_overlay)

/obj/machinery/mineral/local_teleporter/Crossed(atom/movable/O)
	if((stat & NOPOWER) || (stat & NOPOWER))
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