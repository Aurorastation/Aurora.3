/obj/item/flamethrower
	name = "flamethrower"
	desc = "You are a firestarter!"
	icon = 'icons/obj/flamethrower.dmi'
	icon_state = "flamethrowerbase"
	item_state = "flamethrower_0"
	var/fire_sound = 'sound/weapons/flamethrower.ogg'
	flags = CONDUCT
	force = 3.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 1, TECH_PHORON = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 500)
	var/status = 0
	var/throw_amount = 100
	var/lit = FALSE	//on or off
	var/operating = FALSE //cooldown
	var/turf/previousturf = null
	var/obj/item/weldingtool/weldtool = null
	var/obj/item/device/assembly/igniter/igniter = null
	var/obj/item/tank/phoron/ptank = null

/obj/item/flamethrower/examine()
	..()
	if(ptank)
		to_chat(usr, SPAN_NOTICE("Release pressure is set to [throw_amount] kPa. The tank has about [round(ptank.air_contents.return_pressure(), 10)] kPa left in it."))
	else
		to_chat(usr, SPAN_WARNING("There's no phoron tank [igniter ? "" : "or igniter"] installed!"))

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
	return


/obj/item/flamethrower/update_icon()
	cut_overlays()
	if(igniter)
		add_overlay("+igniter[status]")
	if(ptank)
		add_overlay("+ptank")
	if(lit)
		add_overlay("+lit")
		item_state = "flamethrower_1"
	else
		item_state = "flamethrower_0"
	return

/obj/item/flamethrower/afterattack(atom/target, mob/user, proximity)
	if(proximity) return
	// Make sure our user is still holding us
	if(user && user.get_active_hand() == src)
		var/turf/target_turf = get_turf(target)
		if(target_turf)
			var/turflist = getline(user, target_turf)
			flame_turf(turflist)

/obj/item/flamethrower/attackby(obj/item/W as obj, mob/user as mob)
	if(user.stat || user.restrained() || user.lying)	return
	if(W.iswrench() && !status)//Taking this apart
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

	if(W.isscrewdriver() && igniter && !lit)
		status = !status
		to_chat(user, "<span class='notice'>[igniter] is now [status ? "secured" : "unsecured"]!</span>")
		update_icon()
		return

	if(isigniter(W))
		var/obj/item/device/assembly/igniter/I = W
		if(I.secured)	return
		if(igniter)		return
		user.drop_from_inventory(I,src)
		igniter = I
		update_icon()
		return

	if(istype(W,/obj/item/tank/phoron))
		if(ptank)
			to_chat(user, "<span class='notice'>There appears to already be a phoron tank loaded in [src]!</span>")
			return
		user.drop_from_inventory(W,src)
		ptank = W
		update_icon()
		return

	if(istype(W, /obj/item/device/analyzer))
		var/obj/item/device/analyzer/A = W
		A.analyze_gases(src, user)
		return
	..()
	return


/obj/item/flamethrower/attack_self(mob/user as mob)
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
			if(!ptank || !status || ptank.air_contents.gas[GAS_PHORON] < 1)
				return
			lit = !lit
			to_chat(user, SPAN_NOTICE("You [lit ? "light" : "extinguish"] \the [src]."))
			if(lit)
				START_PROCESSING(SSprocessing, src)
		if("Lower Pressure")
			change_pressure(-50, user)
		if("Raise Pressure")
			change_pressure(50, user)
		else return

	update_icon()

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
	//TODO: DEFERRED Consider checking to make sure tank pressure is high enough before doing this...
	//Transfer 5% of current tank air contents to turf
	var/datum/gas_mixture/air_transfer = ptank.air_contents.remove_ratio(0.02*(throw_amount/100))
	new/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(target,air_transfer.gas[GAS_PHORON]*15,get_dir(loc,target))
	air_transfer.gas[GAS_PHORON] = 0
	target.assume_air(air_transfer)
	target.hotspot_expose((ptank.air_contents.temperature*2) + 400, 500)
	return

/obj/item/flamethrower/full/New(var/loc)
	..()
	weldtool = new /obj/item/weldingtool(src)
	weldtool.status = 0
	igniter = new /obj/item/device/assembly/igniter(src)
	igniter.secured = 0
	status = 1
	update_icon()
	return
