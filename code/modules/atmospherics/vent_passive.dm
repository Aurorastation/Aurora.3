/obj/machinery/atmospherics/pipe/vent_passive
	name = "passive vent"
	desc = ""
	icon = 'icons/atmos/vent_passive.dmi'
	icon_state = "map_vent"

	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER|CONNECT_TYPE_AUX|CONNECT_TYPE_FUEL //connects to all pipes except HE

	level = 1

	volume = 250

	dir = SOUTH
	initialize_directions = SOUTH

	var/obj/machinery/atmospherics/node
	var/welded = FALSE

/obj/machinery/atmospherics/pipe/vent_passive/Initialize()
	initialize_directions = dir
	. = ..()

/obj/machinery/atmospherics/pipe/vent_passive/hide(var/i)
	if(istype(loc, /turf/simulated))
		set_invisibility(i ? 101 : 0)
	queue_icon_update()

/obj/machinery/atmospherics/pipe/vent_passive/mechanics_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += "This passively outputs the contents of the attached pipe out into the atmosphere."

/obj/machinery/atmospherics/pipe/vent_passive/feedback_hints(mob/user, distance, is_adjacent)
	. = list()
	if(welded)
		. += "It seems welded shut."

/obj/machinery/atmospherics/pipe/vent_passive/update_icon(safety = 0)

	var/vent_icon = ""

	if(welded)
		vent_icon += "weld"
	else
		vent_icon += "vent"

	icon_state = vent_icon

	update_underlays()

/obj/machinery/atmospherics/pipe/vent_passive/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		if(!T.is_plating() && node && node.level == 1 && istype(node, /obj/machinery/atmospherics/pipe))
			return
		else
			if(node)
				add_underlay(T, node, dir, node.icon_connect_type)
			else
				add_underlay(T,, dir)
			underlays += "frame"

/obj/machinery/atmospherics/pipe/vent_passive/process(seconds_per_tick)
	if(!parent)
		..()
	else
		parent.mingle_with_turf(loc, volume)

/obj/machinery/atmospherics/pipe/vent_passive/Destroy()
	if(node)
		node.disconnect(src)

	node = null

	return ..()

/obj/machinery/atmospherics/pipe/vent_passive/pipeline_expansion()
	return list(node)

/obj/machinery/atmospherics/pipe/vent_passive/atmos_init()
	for(var/obj/machinery/atmospherics/target in get_step(src, dir))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node = target
				break

	atmos_initialised = TRUE
	SSicon_update.add_to_queue(src)

/obj/machinery/atmospherics/pipe/vent_passive/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node)
		if(istype(node, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node = null

	update_icon()

	return null

/obj/machinery/atmospherics/pipe/vent_passive/attackby(obj/item/attacking_item, mob/user)

	if(attacking_item.tool_behaviour == TOOL_WELDER)
		var/obj/item/weldingtool/WT = attacking_item
		if (!WT.welding)
			to_chat(user, SPAN_DANGER("\The [WT] must be turned on!"))
		else if (WT.use(0,user))
			to_chat(user, SPAN_NOTICE("Now welding the vent."))
			if(attacking_item.use_tool(src, user, 30, volume = 50))
				if(!src || !WT.isOn())
					return TRUE
				welded = !welded
				update_icon()
				playsound(src, 'sound/items/welder_pry.ogg', 50, 1)
				user.visible_message(SPAN_NOTICE("\The [user] [welded ? "welds \the [src] shut" : "unwelds \the [src]"]."), \
										SPAN_NOTICE("You [welded ? "weld \the [src] shut" : "unweld \the [src]"]."), \
										"You hear welding.")
			else
				to_chat(user, SPAN_NOTICE("You fail to complete the welding."))
		else
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
		return TRUE


	else if(istype(attacking_item, /obj/item/melee/arm_blade))
		if(!welded)
			to_chat(user, SPAN_WARNING("\The [attacking_item] can only be used to tear open welded air vents!"))
			return TRUE
		user.visible_message(SPAN_WARNING("\The [user] starts using \the [attacking_item] to hack open \the [src]!"), SPAN_NOTICE("You start hacking open \the [src] with \the [attacking_item]..."))
		user.do_attack_animation(src, attacking_item)
		playsound(loc, 'sound/weapons/smash.ogg', 60, TRUE)
		var/cut_amount = 3
		for(var/i = 0; i <= cut_amount; i++)
			if(!attacking_item || !do_after(user, 30, src))
				return TRUE
			user.do_attack_animation(src, attacking_item)
			user.visible_message(SPAN_WARNING("\The [user] smashes \the [attacking_item] into \the [src]!"), SPAN_NOTICE("You smash \the [attacking_item] into \the [src]."))
			playsound(loc, 'sound/weapons/smash.ogg', 60, TRUE)
			if(i == cut_amount)
				welded = FALSE
				spark(get_turf(src), 3, GLOB.alldirs)
				playsound(loc, 'sound/items/welder_pry.ogg', 50, TRUE)
				update_icon()

	else if(attacking_item.tool_behaviour == TOOL_WRENCH)
		var/turf/T = src.loc

		if(level==1 && isturf(T) && !T.is_plating())
			to_chat(user, SPAN_WARNING("You must remove the plating first."))

		else if(loc)
			var/datum/gas_mixture/int_air = return_air()
			var/datum/gas_mixture/env_air = loc.return_air()

			if((XGM_PRESSURE(int_air)-XGM_PRESSURE(env_air)) > PRESSURE_EXERTED)
				to_chat(user, SPAN_WARNING("You cannot unwrench \the [src], it is too exerted due to internal pressure."))
				add_fingerprint(user)

			else
				to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))

				if(attacking_item.use_tool(src, user, istype(attacking_item, /obj/item/pipewrench) ? 80 : 40, volume = 50))
					user.visible_message(SPAN_NOTICE("\The [user] unfastens \the [src]."), \
											SPAN_NOTICE("You have unfastened \the [src]."), \
											"You hear a ratchet.")
					new /obj/item/pipe(loc, make_from=src)
					qdel(src)

	else if(istype(attacking_item, /obj/item/analyzer) && in_range(user, src))
		var/obj/item/analyzer/A = attacking_item
		A.analyze_gases(src, user)
		return TRUE

	return ..()

/obj/machinery/atmospherics/pipe/vent_passive/is_welded()
	return welded
