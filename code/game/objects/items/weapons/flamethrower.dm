/obj/item/flamethrower
	name = "flamethrower"
	desc = "A flamethrower created by modifying a welding tool to fit an external gas tank."
	icon = 'icons/obj/item/flamethrower.dmi'
	icon_state = "flamethrower1"
	item_state = "flamethrower_0"
	contained_sprite = TRUE

	w_class = WEIGHT_CLASS_BULKY
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 3
	throwforce = 10
	throw_speed = 1
	throw_range = 5

	light_color = LIGHT_COLOR_FIRE

	origin_tech = list(TECH_COMBAT = 1, TECH_PHORON = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500)

	var/secured = FALSE // Whether we have an igniter secured (screwdrivered) to us or not
	var/throw_amount = 100
	var/lit = FALSE //on or off
	var/operating = FALSE //cooldown
	var/obj/item/weldingtool/welding_tool = null
	var/obj/item/device/assembly/igniter/igniter = null
	var/obj/item/reagent_containers/fuel_container = null
	/// How much range the flamethrower has. Upgraded welding tools increase this.
	var/range = 4
	var/max_container = WEIGHT_CLASS_SMALL

/obj/item/flamethrower/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(is_adjacent)
		if(fuel_container)
			if(fuel_container.reagents)
				. += SPAN_NOTICE("The loaded [fuel_container.name] has about [fuel_container.reagents.total_volume] unit\s left.")
			else
				. += SPAN_NOTICE("The loaded [fuel_container.name] is empty.")
		if(igniter)
			. += SPAN_NOTICE("It has \an [igniter] installed.")
		else
			. += SPAN_WARNING("It has no igniter installed.")

	if(lit)
		. += SPAN_WARNING("\The [src] is currently lit!")

/obj/item/flamethrower/upgrade_hints(mob/user, distance, is_adjacent)
	. = ..()
	. += SPAN_INFO("Upgrading the welding tool increases the flamethrower's range.")

/obj/item/flamethrower/Initialize(mapload, var/welder)
	. = ..()
	icon_state = "flamethrower" // update to use the non-map version
	if(welder)
		welding_tool = welder
		welding_tool.forceMove(src)
		processUpgrade()
	update_icon()

/obj/item/flamethrower/Destroy()
	QDEL_NULL(welding_tool)
	QDEL_NULL(igniter)
	QDEL_NULL(fuel_container)
	return ..()

/obj/item/flamethrower/process()
	if(!lit)
		STOP_PROCESSING(SSprocessing, src)
		update_icon()
		return null
	else if (!fuel_container || !fuel_container.reagents || fuel_container.reagents.total_volume <= 0)
		lit = FALSE
		balloon_alert_to_viewers("*fffft*")
		playsound(loc, 'sound/items/welder_deactivate.ogg', 50, TRUE)
		update_icon()
		STOP_PROCESSING(SSprocessing, src)
		return null
	var/turf/location = loc
	if(ismob(location))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = M.loc
	if(isturf(location)) //start a fire if possible
		location.hotspot_expose(700, 2)

/obj/item/flamethrower/update_icon()
	ClearOverlays()
	AddOverlays("+[initial(welding_tool.icon_state)]")

	if(igniter)
		AddOverlays("+igniter[secured]")

	if(fuel_container)
		AddOverlays("+phoron_tank")

	if(lit)
		AddOverlays("+lit")
		set_light(1.4, 2)
		item_state = "flamethrower_1"
	else
		set_light(0)
		item_state = "flamethrower_0"

/obj/item/flamethrower/isFlameSource()
	return lit

/obj/item/flamethrower/proc/processUpgrade()
	if(!welding_tool)
		return
	if(istype(welding_tool, /obj/item/weldingtool/emergency))
		range = 3
	else if(istype(welding_tool, /obj/item/weldingtool/largetank) || istype(welding_tool, /obj/item/weldingtool/experimental))
		range = 5
	else if(istype(welding_tool, /obj/item/weldingtool/hugetank))
		range = 6
	else
		range = 4

/obj/item/flamethrower/afterattack(atom/target, mob/user, proximity)
	var/turf/target_turf = get_turf(target)
	if(target_turf)
		var/turflist = get_line(user, target_turf)
		flame_turf(turflist)

/obj/item/flamethrower/attackby(obj/item/attacking_item, mob/user)
	if(use_check_and_message(user))
		return TRUE

	if(attacking_item.tool_behaviour == TOOL_WRENCH && !secured)//Taking this apart
		var/turf/T = get_turf(src)
		if(welding_tool)
			welding_tool.forceMove(T)
			welding_tool = null
		if(igniter)
			igniter.forceMove(T)
			igniter = null
		if(fuel_container)
			fuel_container.forceMove(T)
			fuel_container = null
		new /obj/item/stack/rods(T)
		qdel(src)
		return TRUE

	else if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER && igniter && !lit)
		secured = !secured
		to_chat(user, SPAN_NOTICE("[igniter] is now [secured ? "secured" : "unsecured"]!"))
		update_icon()
		return TRUE

	else if(isigniter(attacking_item))
		var/obj/item/device/assembly/igniter/I = attacking_item
		if(I.secured)
			to_chat(user, SPAN_WARNING("\The [I] is not ready to attach yet! Use a screwdriver on it first."))
			return TRUE
		if(igniter)
			to_chat(user, SPAN_WARNING("\The [src] already has an igniter installed."))
			return TRUE
		user.drop_from_inventory(I, src)
		igniter = I
		update_icon()
		return TRUE

	else if(istype(attacking_item, /obj/item/reagent_containers) && attacking_item.is_open_container() && (attacking_item.w_class <= max_container))
		if(user.unEquip(attacking_item, target = src))
			if(fuel_container)
				user.put_in_hands(fuel_container)
				to_chat(user, SPAN_NOTICE("You swap out the [fuel_container] from \the [src]!"))
			else
				to_chat(user, SPAN_NOTICE("You load the [attacking_item] into \the [src]!"))
			fuel_container = attacking_item
			update_icon()
			return TRUE

	else if(attacking_item.isFlameSource()) // you can light it with external input, even without an igniter
		attempt_lighting(user, TRUE)
		update_icon()
		return TRUE
	return ..()


/obj/item/flamethrower/attack_self(mob/user)
	if(use_check_and_message(user))
		return
	var/list/options = list(
		"Eject Tank" = image('icons/obj/item/reagent_containers/glass.dmi', "beaker"),
		"Light" = image('icons/effects/effects.dmi', "exhaust")
	)
	var/handle = show_radial_menu(user, user, options, radius = 42, tooltips=TRUE)
	if(!handle)
		return
	switch(handle)
		if("Eject Tank")
			if(!fuel_container)
				return
			user.put_in_hands(fuel_container)
			fuel_container = null
			lit = FALSE
		if("Light")
			attempt_lighting(user)
		else
			return

	update_icon()

/obj/item/flamethrower/proc/attempt_lighting(var/mob/user, var/external)
	if(!external) // if it's external input, we can't unlight it, but we don't need to check for an igniter either
		if(lit) // you can extinguish the flamethrower without an igniter
			lit = FALSE
			balloon_alert_to_viewers("*fffft*")
			STOP_PROCESSING(SSprocessing, src)
			if(!external)
				playsound(loc, 'sound/items/welder_deactivate.ogg', 50, TRUE)
			update_icon()
			return
		if(!secured) // can't light via the flamethrower unless we have an igniter secured
			if(igniter)
				to_chat(user, SPAN_WARNING("\The [igniter] isn't secured, you need to use a screwdriver on it first."))
			else
				to_chat(user, SPAN_WARNING("\The [src] doesn't have a secured igniter installed."))
			return
	if(lit)
		balloon_alert(user, "already lit!")
		return
	if(!fuel_container)
		balloon_alert(user, "no fuel container loaded!")
		return
	if(!fuel_container.reagents || fuel_container.reagents.total_volume <= 0)
		balloon_alert(user, "fuel container is empty!")
		return
	lit = TRUE
	balloon_alert_to_viewers("*whoosh*")
	update_icon()
	START_PROCESSING(SSprocessing, src)
	if(!external)
		playsound(loc, 'sound/items/welder_activate.ogg', 50, TRUE)

#define REQUIRED_POWER_TO_FIRE_FLAMETHROWER 10
#define FLAMETHROWER_POWER_MULTIPLIER 1.5
#define FLAMETHROWER_RELEASE_AMOUNT 5

//Called from turf.dm turf/dblclick
/obj/item/flamethrower/proc/flame_turf(list/turflist)
	if(!fuel_container)
		return
	if(!lit || operating)
		return

	var/turf/operator_turf = get_turf(src)

	turflist -= operator_turf //Don't flame the turf you're standing on

	var/size = length(turflist)
	if(!size)
		return
	LIST_RESIZE(turflist, min(size, range))

	var/power = 0
	var/datum/reagents/fuel_reagents = fuel_container.reagents
	var/datum/reagents/my_fraction = new(fuel_reagents.maximum_volume, src)
	fuel_reagents.trans_to_holder(my_fraction, FLAMETHROWER_RELEASE_AMOUNT * length(turflist))
	var/fire_color = null
	var/highest_amount = 0
	for(var/reagent in my_fraction.reagent_volumes)
		var/singleton/reagent/fuel = GET_SINGLETON(reagent)
		power += fuel.accelerant_quality * FLAMETHROWER_POWER_MULTIPLIER * (my_fraction.reagent_volumes[reagent] / length(turflist)) //Flamethrowers inflate flammability compared to a pool of fuel
		if(my_fraction.reagent_volumes[reagent] > highest_amount && fuel.accelerant_quality > 0)
			highest_amount = my_fraction.reagent_volumes[reagent]
			fire_color = fuel.fire_color

	if(power < REQUIRED_POWER_TO_FIRE_FLAMETHROWER)
		audible_message(SPAN_DANGER("\The [src] sputters."))
		balloon_alert_to_viewers("*pshhhh*")
		playsound(src, 'sound/weapons/flamethrower/flamethrower_empty.ogg', 50, TRUE, -3)
		my_fraction.remove_any(FLAMETHROWER_RELEASE_AMOUNT) //Wastes some fuel
		return_fuel(fuel_reagents, my_fraction)
		return

	playsound(src, pick('sound/weapons/flamethrower/flamethrower1.ogg','sound/weapons/flamethrower/flamethrower2.ogg','sound/weapons/flamethrower/flamethrower3.ogg' ), 50, TRUE, -3)

	operating = TRUE

	for(var/turf/T in (turflist))
		if(T.density || istype(T, /turf/space))
			continue

		if(LinkBlocked(operator_turf, T))
			continue

		//Consume part of our fuel to create a fire spot
		T.IgniteTurf(power, fire_color)
		T.hotspot_expose(power * 3 + 380)
		my_fraction.remove_any(FLAMETHROWER_RELEASE_AMOUNT)
		sleep(0.1 SECONDS)

	return_fuel(fuel_reagents, my_fraction)

	operating = FALSE

#undef REQUIRED_POWER_TO_FIRE_FLAMETHROWER
#undef FLAMETHROWER_POWER_MULTIPLIER
#undef FLAMETHROWER_RELEASE_AMOUNT

/obj/item/flamethrower/proc/return_fuel(datum/reagents/_return, datum/reagents/_fraction)
	if(fuel_container) //In the event we earlied out that means some fuel goes back into tank
		if(_fraction.total_volume > 0)
			_fraction.trans_to_holder(_return, _fraction.total_volume)
	QDEL_NULL(_fraction)

/obj/item/flamethrower/full/Initialize() // slightly weird looking initialize cuz it has to do some stuff first
	welding_tool = new /obj/item/weldingtool(src)
	welding_tool.status = FALSE
	igniter = new /obj/item/device/assembly/igniter(src)
	igniter.secured = FALSE
	secured = TRUE
	fuel_container = new /obj/item/reagent_containers/glass/beaker/large(src)
	fuel_container.reagents.add_reagent(/singleton/reagent/fuel, 120)
	processUpgrade()
	return ..()
