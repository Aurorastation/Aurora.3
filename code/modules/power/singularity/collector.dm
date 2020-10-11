//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33
var/global/list/rad_collectors = list()

/obj/machinery/power/rad_collector
	name = "Radiation Collector Array"
	desc = "A device which uses Hawking Radiation and phoron to produce power."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "ca"
	anchored = 0
	density = 1
	req_access = list(access_engine_equip)
//	use_power = 0
	var/obj/item/tank/phoron/P = null
	var/last_power = 0
	var/last_power_new = 0
	var/active = 0
	var/locked = 0
	var/drainratio = 1

/obj/machinery/power/rad_collector/Initialize()
	. = ..()
	rad_collectors += src

/obj/machinery/power/rad_collector/Destroy()
	rad_collectors -= src
	return ..()

/obj/machinery/power/rad_collector/machinery_process()
	//so that we don't zero out the meter if the SM is processed first.
	last_power = last_power_new
	last_power_new = 0


	if(P)
		if(P.air_contents.gas[GAS_PHORON] == 0)
			investigate_log("<span class='warning'>out of fuel</span>.","singulo")
			eject()
		else
			P.air_contents.adjust_gas(GAS_PHORON, -0.001*drainratio)
	return


/obj/machinery/power/rad_collector/attack_hand(mob/user as mob)
	if(anchored)
		if(!src.locked)
			toggle_power()
			user.visible_message("[user.name] turns the [src.name] [active? "on":"off"].", \
			"You turn the [src.name] [active? "on":"off"].")
			investigate_log("turned [active?"<font color='green'>on</font>":"<span class='warning'>off</span>"] by [user.key]. [P?"Fuel: [round(P.air_contents.gas[GAS_PHORON]/0.29)]%":"<span class='warning'>It is empty</span>"].","singulo")
			return
		else
			to_chat(user, "<span class='warning'>The controls are locked!</span>")
			return
	..()


/obj/machinery/power/rad_collector/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/tank/phoron))
		if(!src.anchored)
			to_chat(user, "<span class='warning'>The [src] needs to be secured to the floor first.</span>")
			return 1
		if(src.P)
			to_chat(user, "<span class='warning'>There's already a phoron tank loaded.</span>")
			return 1
		user.drop_from_inventory(W,src)
		src.P = W
		update_icon()
		return 1
	else if(W.iscrowbar())
		if(P && !src.locked)
			eject()
			return 1
	else if(W.iswrench())
		if(P)
			to_chat(user, "<span class='notice'>Remove the phoron tank first.</span>")
			return 1
		playsound(src.loc, W.usesound, 75, 1)
		src.anchored = !src.anchored
		user.visible_message("[user.name] [anchored? "secures":"unsecures"] the [src.name].", \
			"You [anchored? "secure":"undo"] the external bolts.", \
			"You hear a ratchet")
		if(anchored)
			connect_to_network()
		else
			disconnect_from_network()
		return 1
	else if(W.GetID())
		if (src.allowed(user))
			if(active)
				src.locked = !src.locked
				to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
			else
				src.locked = 0 //just in case it somehow gets locked
				to_chat(user, "<span class='warning'>The controls can only be locked when the [src] is active.</span>")
		else
			to_chat(user, "<span class='warning'>Access denied!</span>")
		return 1
	return ..()

/obj/machinery/power/rad_collector/examine(mob/user)
	if (..(user, 3))
		to_chat(user, "The meter indicates that \the [src] is collecting [last_power] W.")
		return 1

/obj/machinery/power/rad_collector/ex_act(severity)
	switch(severity)
		if(2, 3)
			eject()
	return ..()


/obj/machinery/power/rad_collector/proc/eject()
	locked = 0
	var/obj/item/tank/phoron/Z = src.P
	if (!Z)
		return
	Z.forceMove(get_turf(src))
	Z.layer = initial(Z.layer)
	src.P = null
	if(active)
		toggle_power()
	else
		update_icon()

/obj/machinery/power/rad_collector/proc/receive_pulse(var/pulse_strength)
	if(P && active)
		var/power_produced = 0
		power_produced = P.air_contents.gas[GAS_PHORON]*pulse_strength*20
		add_avail(power_produced)
		last_power_new = power_produced
		return
	return


/obj/machinery/power/rad_collector/update_icon()
	cut_overlays()
	if(P)
		add_overlay("ptank")
	if(stat & (NOPOWER|BROKEN))
		return
	if(active)
		add_overlay("on")


/obj/machinery/power/rad_collector/proc/toggle_power()
	active = !active
	if(active)
		icon_state = "ca_on"
		flick("ca_active", src)
	else
		icon_state = "ca"
		flick("ca_deactive", src)
	update_icon()
	return

