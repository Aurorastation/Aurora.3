/obj/machinery/power/crystal_agitator
	name = "crystal agitator"
	desc = "A device of incredibly niche design. This agitator disturbs the ashy turf around it, causing chemical crystals to form."
	icon = 'icons/obj/crystal_agitator.dmi'
	icon_state = "agitator"
	density = TRUE
	anchored = TRUE

	use_power = 0
	active_power_usage = 3000

	var/agitation_range = 4
	var/agitation_rate = 80
	var/last_agitation = 0
	var/active = FALSE

	component_types = list(
		/obj/item/stack/cable_coil{amount = 5},
		/obj/item/stock_parts/capacitor,
		/obj/item/stock_parts/manipulator,
		/obj/item/bluespace_crystal,
		/obj/item/circuitboard/crystal_agitator
	)

/obj/machinery/power/crystal_agitator/Initialize()
	. = ..()
	connect_to_network()

/obj/machinery/power/crystal_agitator/attack_hand(mob/user)
	toggle_active()
	visible_message(SPAN_NOTICE("\The [user] turns \the [src] [active ? "on" : "off"]."), SPAN_NOTICE("You turn \the [src] [active ? "on" : "off"]."))

/obj/machinery/power/crystal_agitator/proc/toggle_active()
	active = !active
	icon_state = "[initial(icon_state)][active ? "-active": ""]"

/obj/machinery/power/crystal_agitator/machinery_process()
	if(!active)
		return
	if(stat & (BROKEN) || !powernet)
		return
	if(last_agitation + agitation_rate > world.time)
		return
	
	var/actual_load = draw_power(active_power_usage)
	if(actual_load < active_power_usage)
		if(active)
			toggle_active()
		return

	var/list/turf/grow_turfs = list()
	for(var/turf/T in range(agitation_range, get_turf(src)))
		if(get_turf(src) == T)
			continue
		if(!istype(T, /turf/unsimulated/floor/asteroid))
			continue
		if(locate(/obj/structure/reagent_crystal/dense) in T)
			continue
		grow_turfs += T

	var/turf/selected_turf = pick(grow_turfs)
	if(!selected_turf || !istype(selected_turf))
		return
	if(locate(/obj/structure/reagent_crystal) in selected_turf)
		var/obj/structure/reagent_crystal/P = locate() in selected_turf
		P.become_dense()
		return
	new /obj/structure/reagent_crystal(selected_turf)
	last_agitation = world.time

/obj/machinery/power/crystal_agitator/RefreshParts()
	for(var/obj/item/stock_parts/SP in component_parts)
		if(ismanipulator(SP))
			agitation_rate = initial(agitation_rate) - (SP.rating * 5)
		if(iscapacitor(SP))
			active_power_usage = initial(active_power_usage) - (SP.rating * 500)

/obj/machinery/power/crystal_agitator/attackby(obj/item/I, mob/user, params)
	if(default_part_replacement(user, I))
		return
	else if(default_deconstruction_screwdriver(user, I))
		return
	else if(default_deconstruction_crowbar(user, I))
		return
	return ..()

/obj/item/circuitboard/crystal_agitator
	name = T_BOARD("Crystal Agitator")
	build_path = /obj/machinery/power/crystal_agitator
	board_type = "machine"
	origin_tech = list(
		TECH_ENGINEERING = 3,
		TECH_DATA = 2,
		TECH_MATERIAL = 4,
		TECH_POWER = 3
	)
	req_components = list(
		"/obj/item/stack/cable_coil" = 5,
		"/obj/item/stock_parts/capacitor" = 1,
		"/obj/item/stock_parts/manipulator" = 1,
		"/obj/item/bluespace_crystal" = 1
	)