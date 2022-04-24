/obj/item/flamethrower
	name = "flamethrower"
	desc = "A flamethrower created by modifying a welding tool to fit an external gas tank."

	icon = 'icons/obj/contained_items/weapons/flamethrower.dmi'
	icon_state = "flamethrower1"
	item_state = "flamethrower_0"
	contained_sprite = TRUE

	w_class = ITEMSIZE_LARGE
	flags = CONDUCT
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
	var/turf/previous_turf = null
	var/obj/item/weldingtool/welding_tool = null
	var/obj/item/device/assembly/igniter/igniter = null
	var/obj/item/tank/gas_tank = null

/obj/item/flamethrower/Initialize(mapload, var/welder)
	. = ..()
	icon_state = "flamethrower" // update to use the non-map version
	if(welder)
		welding_tool = welder
		welding_tool.forceMove(src)
	update_icon()

/obj/item/flamethrower/examine(mob/user)
	..()
	if(Adjacent(user))
		if(gas_tank)
			to_chat(user, SPAN_NOTICE("Release pressure is set to [throw_amount] kPa. The tank has about [round(gas_tank.air_contents.return_pressure(), 10)] kPa left in it."))
		else
			to_chat(user, SPAN_WARNING("It has no gas tank installed."))
		if(igniter)
			to_chat(user, SPAN_NOTICE("It has \an [igniter] installed."))
		else
			to_chat(user, SPAN_WARNING("It has no igniter installed."))

/obj/item/flamethrower/Destroy()
	QDEL_NULL(welding_tool)
	QDEL_NULL(igniter)
	QDEL_NULL(gas_tank)
	return ..()

/obj/item/flamethrower/process()
	if(!lit)
		STOP_PROCESSING(SSprocessing, src)
		return null
	var/turf/location = loc
	if(istype(location, /mob/))
		var/mob/M = location
		if(M.l_hand == src || M.r_hand == src)
			location = M.loc
	if(isturf(location)) //start a fire if possible
		location.hotspot_expose(700, 2)

/obj/item/flamethrower/update_icon()
	cut_overlays()
	add_overlay("+[initial(welding_tool.icon_state)]")

	if(igniter)
		add_overlay("+igniter[secured]")

	if(istype(gas_tank, /obj/item/tank/phoron))
		add_overlay("+phoron_tank")
	else if(istype(gas_tank, /obj/item/tank/hydrogen))
		add_overlay("+hydro_tank")

	if(lit)
		add_overlay("+lit")
		set_light(1.4, 2)
		item_state = "flamethrower_1"
	else
		set_light(0)
		item_state = "flamethrower_0"

/obj/item/flamethrower/isFlameSource()
	return lit

/obj/item/flamethrower/afterattack(atom/target, mob/user, proximity)
	if(proximity)
		return
	if(!gas_tank)
		return
	if(gas_tank.air_contents.get_by_flag(XGM_GAS_FUEL) < 1)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have enough fuel left to throw!"))
		return
	// Make sure our user is still holding us
	if(user && user.get_active_hand() == src)
		var/turf/target_turf = get_turf(target)
		if(target_turf)
			var/turflist = getline(user, target_turf)
			flame_turf(turflist)

/obj/item/flamethrower/attackby(obj/item/W, mob/user)
	if(use_check_and_message(user))
		return TRUE

	if(W.iswrench() && !secured)//Taking this apart
		var/turf/T = get_turf(src)
		if(welding_tool)
			welding_tool.forceMove(T)
			welding_tool = null
		if(igniter)
			igniter.forceMove(T)
			igniter = null
		if(gas_tank)
			gas_tank.forceMove(T)
			gas_tank = null
		new /obj/item/stack/rods(T)
		qdel(src)
		return TRUE

	else if(W.isscrewdriver() && igniter && !lit)
		secured = !secured
		to_chat(user, SPAN_NOTICE("[igniter] is now [secured ? "secured" : "unsecured"]!"))
		update_icon()
		return TRUE

	else if(isigniter(W))
		var/obj/item/device/assembly/igniter/I = W
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

	else if(istype(W, /obj/item/tank/phoron) || istype(W, /obj/item/tank/hydrogen))
		if(gas_tank)
			to_chat(user, SPAN_WARNING("There appears to already be a tank loaded in \the [src]!"))
			return
		user.drop_from_inventory(W, src)
		gas_tank = W
		update_icon()
		return TRUE

	else if(istype(W, /obj/item/device/analyzer))
		var/obj/item/device/analyzer/A = W
		A.analyze_gases(src, user)
		return TRUE

	else if(W.isFlameSource()) // you can light it with external input, even without an igniter
		attempt_lighting(user, TRUE)
		update_icon()
		return TRUE
	return ..()


/obj/item/flamethrower/attack_self(mob/user)
	if(use_check_and_message(user))
		return
	if(!gas_tank)
		to_chat(user, SPAN_WARNING("Attach a phoron tank first!"))
		return
	var/list/options = list(
		"Eject Tank" = image('icons/obj/tank.dmi', "phoron"),
		"Light" = image('icons/effects/effects.dmi', "exhaust"),
		"Lower Pressure" = image('icons/mob/screen/radial.dmi', "radial_sub"),
		"Raise Pressure" = image('icons/mob/screen/radial.dmi', "radial_add")
	)
	var/handle = show_radial_menu(user, user, options, radius = 42, tooltips=TRUE)
	if(!handle)
		return
	switch(handle)
		if("Eject Tank")
			if(!gas_tank)
				return
			user.put_in_hands(gas_tank)
			gas_tank = null
			lit = FALSE
		if("Light")
			attempt_lighting(user)
		if("Lower Pressure")
			change_pressure(-50, user)
		if("Raise Pressure")
			change_pressure(50, user)
		else
			return

	update_icon()

/obj/item/flamethrower/proc/attempt_lighting(var/mob/user, var/external)
	if(!external) // if it's external input, we can't unlight it, but we don't need to check for an igniter either
		if(lit) // you can extinguish the flamethrower without an igniter
			lit = FALSE
			to_chat(user, SPAN_NOTICE("You extinguish \the [src]."))
			return
		if(!secured) // can't light via the flamethrower unless we have an igniter secured
			if(igniter)
				to_chat(user, SPAN_WARNING("\The [igniter] isn't secured, you need to use a screwdriver on it first."))
			else
				to_chat(user, SPAN_WARNING("\The [src] doesn't have a secured igniter installed."))
			return
	if(lit)
		to_chat(user, SPAN_WARNING("\The [src] is already lit."))
		return
	if(!gas_tank)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a tank installed."))
		return
	if(gas_tank.air_contents.get_by_flag(XGM_GAS_FUEL) < 1)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have any flammable fuel to light!"))
		return
	lit = TRUE
	to_chat(user, SPAN_NOTICE("You light \the [src]."))
	if(lit)
		START_PROCESSING(SSprocessing, src)

/obj/item/flamethrower/proc/change_pressure(var/pressure, var/mob/user)
	if(!pressure)
		return
	throw_amount += pressure
	throw_amount = Clamp(50, throw_amount, 5000)
	if(ismob(user))
		to_chat(user, SPAN_NOTICE("Pressure has been adjusted to [throw_amount] kPa."))

//Called from turf.dm turf/dblclick
/obj/item/flamethrower/proc/flame_turf(turflist)
	if(!lit || operating)
		return
	operating = TRUE
	for(var/turf/T in turflist)
		if(T.density || istype(T, /turf/space))
			break
		if(!previous_turf && length(turflist)>1)
			previous_turf = get_turf(src)
			continue	//so we don't burn the tile we be standin on
		if(previous_turf && LinkBlocked(previous_turf, T))
			break
		ignite_turf(T)
		sleep(1)
	previous_turf = null
	operating = FALSE


/obj/item/flamethrower/proc/ignite_turf(turf/target)
	var/datum/gas_mixture/air_transfer = gas_tank.air_contents.remove_ratio(0.02 * (throw_amount / 100))
	new /obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(target, air_transfer.get_by_flag(XGM_GAS_FUEL) * 15, get_dir(loc, target))
	for(var/g in air_transfer.gas)
		if(gas_data.flags[g] & XGM_GAS_FUEL)
			air_transfer.gas[g] = 0
	target.assume_air(air_transfer)
	target.hotspot_expose((gas_tank.air_contents.temperature*2) + 400, 500)
	for(var/mob/living/M in target)
		M.IgniteMob(1)

/obj/item/flamethrower/full/Initialize() // slightly weird looking initialize cuz it has to do some stuff first
	welding_tool = new /obj/item/weldingtool(src)
	welding_tool.status = FALSE
	igniter = new /obj/item/device/assembly/igniter(src)
	igniter.secured = FALSE
	secured = TRUE
	gas_tank = new /obj/item/tank/phoron(src)
	return ..()
