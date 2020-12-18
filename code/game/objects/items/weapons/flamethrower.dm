/obj/item/flamethrower
	name = "flamethrower"
	desc = "A flamethrower created by modifying a welding tool to fit an external gas tank."
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	item_state = "flamethrower_0"
	var/fire_sound = 'sound/weapons/flamethrower.ogg'
	flags = CONDUCT
	force = 3.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_LARGE
	origin_tech = list(TECH_COMBAT = 1, TECH_PHORON = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	var/secured = FALSE // Whether we have an igniter secured (screwdrivered) to us or not
	var/throw_amount = 100
	var/lit = FALSE //on or off
	var/operating = FALSE //cooldown
	var/turf/previousturf = null
	var/obj/item/weldingtool/weldtool = null
	var/obj/item/device/assembly/igniter/igniter = null
	var/obj/item/tank/phoron/ptank = null

/obj/item/flamethrower/examine(mob/user)
	..()
	if(Adjacent(user))
		if(ptank)
			to_chat(user, SPAN_NOTICE("Release pressure is set to [throw_amount] kPa. The tank has about [round(ptank.air_contents.return_pressure(), 10)] kPa left in it."))
		else
			to_chat(user, SPAN_WARNING("It has no gas tank installed."))
		if(igniter)
			to_chat(user, SPAN_NOTICE("It has \an [igniter] installed."))
		else
			to_chat(user, SPAN_WARNING("It has no igniter installed."))

/obj/item/flamethrower/Destroy()
	if(weldtool)
		qdel(weldtool)
	if(igniter)
		qdel(igniter)
	if(ptank)
		qdel(ptank)

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
	if(igniter)
		add_overlay("+igniter[secured]")
	if(ptank)
		add_overlay("+ptank")
	if(lit)
		add_overlay("+lit")
		item_state = "flamethrower_1"
	else
		item_state = "flamethrower_0"

/obj/item/flamethrower/isFlameSource()
	return lit

/obj/item/flamethrower/afterattack(atom/target, mob/user, proximity)
	if(proximity)
		return
	if(!ptank)
		return
	if(ptank.air_contents.get_by_flag(XGM_GAS_FUEL) < 1)
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
		return

	if(W.iswrench() && !secured)//Taking this apart
		var/turf/T = get_turf(src)
		if(weldtool)
			weldtool.forceMove(T)
			weldtool = null
		if(igniter)
			igniter.forceMove(T)
			igniter = null
		if(ptank)
			ptank.forceMove(T)
			ptank = null
		new /obj/item/stack/rods(T)
		qdel(src)
		return

	else if(W.isscrewdriver() && igniter && !lit)
		secured = !secured
		to_chat(user, SPAN_NOTICE("[igniter] is now [secured ? "secured" : "unsecured"]!"))
		update_icon()
		return

	else if(isigniter(W))
		var/obj/item/device/assembly/igniter/I = W
		if(I.secured)
			to_chat(user, SPAN_WARNING("\The [I] is not ready to attach yet! Use a screwdriver on it first."))
			return
		if(igniter)
			to_chat(user, SPAN_WARNING("\The [src] already has an igniter installed."))
			return
		user.drop_from_inventory(I, src)
		igniter = I
		update_icon()
		return

	else if(istype(W, /obj/item/tank/phoron))
		if(ptank)
			to_chat(user, SPAN_WARNING("There appears to already be a tank loaded in \the [src]!"))
			return
		user.drop_from_inventory(W, src)
		ptank = W
		update_icon()
		return

	else if(istype(W, /obj/item/device/analyzer))
		var/obj/item/device/analyzer/A = W
		A.analyze_gases(src, user)
		return

	else if(W.isFlameSource()) // you can light it with external input, even without an igniter
		attempt_lighting(user, TRUE)
		update_icon()
		return
	..()


/obj/item/flamethrower/attack_self(mob/user)
	if(use_check_and_message(user))
		return
	if(!ptank)
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
			if(!ptank)
				return
			user.put_in_hands(ptank)
			ptank = null
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
	if(!ptank)
		to_chat(user, SPAN_WARNING("\The [src] doesn't have a tank installed."))
		return
	if(ptank.air_contents.get_by_flag(XGM_GAS_FUEL) < 1)
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
	if(!lit || operating)	return
	operating = TRUE
	playsound(src, fire_sound, 70, 1)
	for(var/turf/T in turflist)
		if(T.density || istype(T, /turf/space))
			break
		if(!previousturf && length(turflist)>1)
			previousturf = get_turf(src)
			continue	//so we don't burn the tile we be standin on
		if(previousturf && LinkBlocked(previousturf, T))
			break
		ignite_turf(T)
		sleep(1)
	previousturf = null
	operating = FALSE


/obj/item/flamethrower/proc/ignite_turf(turf/target)
	var/datum/gas_mixture/air_transfer = ptank.air_contents.remove_ratio(0.02 * (throw_amount / 100))
	new /obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(target, air_transfer.get_by_flag(XGM_GAS_FUEL) * 15, get_dir(loc, target))
	for(var/g in air_transfer.gas)
		if(gas_data.flags[g] & XGM_GAS_FUEL)
			air_transfer.gas[g] = 0
	target.assume_air(air_transfer)
	target.hotspot_expose((ptank.air_contents.temperature*2) + 400, 500)

/obj/item/flamethrower/full/Initialize()
	. = ..()
	weldtool = new /obj/item/weldingtool(src)
	weldtool.status = FALSE
	igniter = new /obj/item/device/assembly/igniter(src)
	igniter.secured = FALSE
	secured = TRUE
	update_icon()