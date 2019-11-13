/obj/machinery/anti_bluespace
	name = "bluespace inhibitor"
	desc = "Scrambles any bluespace related activity and displaces it away from the beacon's area of effect."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "nopad"
	anchored = 1
	density = 1
	use_power = 1
	active_power_usage = 5000
	idle_power_usage = 1000

/obj/machinery/anti_bluespace/update_icon()
	. = ..()
	if(stat & BROKEN)
		name = "modern art"
		desc = "What used to be a useful machine that prevented intrusion into secure areas is now a modern art piece."
		icon_state = "[initial(icon_state)]-broken"
	else if(stat & NOPOWER)
		name = initial(name)
		desc = "[initial(desc)] Well, only if it was powered."
		icon_state = "[initial(icon_state)]"
	else
		name = initial(name)
		desc = initial(desc)
		icon_state = "[initial(icon_state)]-on"

/obj/machinery/anti_bluespace/emag_act()
	spark(src, 3)
	playsound(src, "sparks", 50, 1)
	emp_act(1)
	return TRUE

/obj/machinery/anti_bluespace/machinery_process()
	. = ..()
	update_icon()

/obj/machinery/anti_bluespace/dismantle()
	return 0

/obj/machinery/anti_bluespace/default_part_replacement()
	return 0

/obj/machinery/anti_bluespace/default_deconstruction_screwdriver(var/mob/user, var/obj/item/screwdriver/S)
	return 0

/obj/machinery/anti_bluespace/default_deconstruction_crowbar(var/mob/user, var/obj/item/crowbar/C)
	return 0

/obj/machinery/anti_bluespace/proc/do_break()
	if(stat & BROKEN)
		return
	playsound(src.loc, 'sound/effects/grillehit.ogg', 100, 1)
	visible_message(span("warning","\The [src] breaks!"))
	stat |= BROKEN
	anchored = 0
	update_icon()

/obj/machinery/anti_bluespace/attackby(obj/item/W as obj, mob/user as mob)
	if(user.a_intent == I_HURT)
		visible_message(span("warning","\The [user] hits \the [src] with \the [W]!"))
	else
		visible_message(span("notice","\The [user] [pick("touches","pokes","prods")] \the [src] with \the [W]."))
		if(prob(66))
			return

	do_break()

/obj/machinery/anti_bluespace/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return
	if(!Proj.damage)
		return

	do_break()

/obj/machinery/anti_bluespace/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(75))
				qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(25))
				qdel(src)

	do_break()

	return

/obj/machinery/anti_bluespace/emp_act(severity)
	//THIS WILL BE FUN.
	if(stat & BROKEN)
		return 0

	var/area/temp_area = get_area(src)
	if(temp_area)
		var/obj/machinery/power/apc/temp_apc = temp_area.get_apc()
		if(temp_apc)
			temp_apc.flicker_all()

	playsound(src.loc, 'sound/magic/lightning_chargeup.ogg', 100, 1, extrarange = 20)
	visible_message(span("danger","\The [src] goes haywire!"))
	do_break()
	addtimer(CALLBACK(src, .proc/haywire_teleport), 10 SECONDS)

/obj/machinery/anti_bluespace/proc/haywire_teleport()

	var/area/temp_area = get_area(src)
	if(temp_area)
		var/obj/machinery/power/apc/temp_apc = temp_area.get_apc()
		if(temp_apc)
			temp_apc.drain_power(0,TRUE,100000)

	for(var/atom/movable/AM in circlerange(get_turf(src),20))
		if(AM.anchored)
			continue
		var/area/A = random_station_area()
		var/turf/target = A.random_space()
		to_chat(AM,span("warning","Bluespace energy teleports you somewhere else!"))
		do_teleport(AM, target)
		AM.visible_message("\The [AM] phases in!")


