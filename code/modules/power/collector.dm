/// A global list of all radiation collectors.
GLOBAL_LIST_INIT_TYPED(rad_collectors, /obj/machinery/power/rad_collector, list())

/obj/machinery/power/rad_collector
	name = "radiation collector array"
	desc = "A device which uses radiation and phoron to produce power."
	icon = 'icons/obj/machinery/rad_collector.dmi'
	icon_state = "ca"
	anchored = FALSE
	density = TRUE
	req_access = list(ACCESS_ENGINE_EQUIP)
	/// The tank of phoron currently attached to the radiation collector
	var/obj/item/tank/phoron/loaded_tank = null

	/// Current health of the collector. TODO: replace with global health
	var/health = 100
	/// The maximum safe temperature that the radiation collector can handle
	var/max_safe_temp = 1000 + T0C
	/// A boolean determining whether the collector has melted or not.
	var/melted = FALSE

	/// Internal variable storing last power generation amount
	var/last_power = 0
	/// Internal variable storing last power generation amount. Duplicate variable to account for the SM being processed first
	var/last_power_new = 0
	/// Whether the radiation collector is active or not.
	var/active = FALSE
	/// Whether the radiation collector's controls are locked or not.
	var/locked = FALSE
	/// Determines the ratio of default draining of phoron while radiation collector is active
	var/drainratio = 1

	/// Internal variable storing last radiation amount measured
	var/last_rads
	/// Radiation collector will reach max power output at this value, and break at twice this value
	var/max_rads = 250
	/// Maximum power output for this radiation collector.
	var/max_power = 5e5
	/// Pulse coefficient, for multiplying power output by radiation input
	var/pulse_coeff = 20
	/// Internal variable storing last time an alert message was outputted
	var/end_time = 0
	/// How long to wait between alert messages, if radiation input exceeds safe levels
	var/alert_delay = 10 SECONDS

/obj/machinery/power/rad_collector/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if (..(user, 3))
		var/last_power_kw = round(last_power / 1000, 0.1)
		. += "The meter indicates that \the [src] is collecting [last_power_kw] kW."

/obj/machinery/power/rad_collector/Initialize()
	. = ..()
	GLOB.rad_collectors += src

/obj/machinery/power/rad_collector/Destroy()
	GLOB.rad_collectors -= src
	return ..()

/obj/machinery/power/rad_collector/process(seconds_per_tick)
	if((stat && BROKEN) || melted)
		return
	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/our_turfs_air = T.return_air()
		if(our_turfs_air.temperature > max_safe_temp)
			health -= ((our_turfs_air.temperature - max_safe_temp) / 10) * seconds_per_tick
			if(health <= 0)
				collector_break()

	//so that we don't zero out the meter if the SM is processed first.
	last_power = last_power_new
	last_power_new = 0
	last_rads = SSradiation.get_rads_at_turf(get_turf(src))
	if(loaded_tank && active)
		if(last_rads > max_rads*2)
			collector_break()
		if(last_rads)
			if(last_rads > max_rads)
				if(world.time > end_time)
					end_time = world.time + alert_delay
					visible_message("[icon2html(src, viewers(get_turf(src)))] \the [src] beeps loudly as the radiation reaches dangerous levels, indicating imminent damage.")
					playsound(src, 'sound/effects/screech.ogg', 100, 1, 1)
			receive_pulse(12.5*(last_rads/max_rads)/(0.3+(last_rads/max_rads)) * seconds_per_tick)

	if(loaded_tank)
		if(loaded_tank.air_contents.gas[GAS_PHORON] == 0)
			investigate_log("[SPAN_COLOR("red", "out of fuel")].","singulo")
			eject()
		else
			loaded_tank.air_contents.adjust_gas(GAS_PHORON, (-0.01*drainratio*min(last_rads,max_rads)/max_rads) * seconds_per_tick) //fuel cost increases linearly with incoming radiation


/obj/machinery/power/rad_collector/CanUseTopic(mob/user)
	if(!anchored)
		return STATUS_CLOSE
	return ..()


/obj/machinery/power/rad_collector/attack_hand(mob/user)
	if(!CanInteract(user, GLOB.physical_state))
		return FALSE
	. = TRUE
	if((stat & BROKEN) || melted)
		USE_FEEDBACK_FAILURE("The [src] is completely destroyed!")
	if(!src.locked)
		toggle_power()
		user.visible_message("[user.name] turns the [src.name] [active? "on":"off"].", \
		"You turn the [src.name] [active? "on":"off"].")
		investigate_log("turned [active ? SPAN_COLOR("green", "on") : SPAN_COLOR("red", "off")] by [user.key]. [loaded_tank ? "Fuel: [round(loaded_tank.air_contents.gas[GAS_PHORON]/0.29)]%" : SPAN_COLOR("red", "It is empty")].","singulo")
	else
		USE_FEEDBACK_FAILURE("The controls are locked!")
	..()

/obj/machinery/power/rad_collector/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/tank/phoron))
		if(!anchored)
			USE_FEEDBACK_FAILURE("The [src] needs to be secured to the floor first.")
			return TRUE
		if(loaded_tank)
			USE_FEEDBACK_FAILURE("There's already a phoron tank loaded.")
			return TRUE
		if(!user.unEquip(attacking_item, src))
			return TRUE
		loaded_tank = attacking_item
		attacking_item.forceMove(src)
		to_chat(user, SPAN_NOTICE("You slot [attacking_item] into [src] and tighten the connecting valve."))
		update_icon()
		return TRUE

	if(attacking_item.iscrowbar())
		if(loaded_tank && !locked)
			to_chat(user, SPAN_NOTICE("You detach and remove \the [loaded_tank.name]."))
			eject(user)
			return TRUE

	if(attacking_item.iswrench())
		if(loaded_tank)
			USE_FEEDBACK_FAILURE("Remove the phoron tank first.")
			return TRUE
		for(var/obj/machinery/power/rad_collector/R in get_turf(src))
			if(R != src)
				USE_FEEDBACK_FAILURE("You cannot install more than one collector on the same spot.")
				return TRUE
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		src.anchored = !src.anchored
		user.visible_message("[user.name] [anchored? "secures":"unsecures"] the [src.name].", \
			"You [anchored? "secure":"undo"] the external bolts.", \
			"You hear a ratchet")
		if(anchored && !(stat & BROKEN))
			connect_to_network()
		else
			disconnect_from_network()
		return TRUE

	if(istype(attacking_item, /obj/item/card/id)||istype(attacking_item, /obj/item/modular_computer))
		if (allowed(user))
			if(active)
				locked = !locked
				to_chat(user, "The controls are now [locked ? "locked." : "unlocked."]")
			else
				locked = FALSE //just in case it somehow gets locked while the collector is active
				USE_FEEDBACK_FAILURE("The controls can only be locked when the [src] is active.")
		else
			to_chat(user, SPAN_ALERT("Access denied!"))
		return TRUE

	return ..()

/// Handles dealing with a breaking radiation collector
/obj/machinery/power/rad_collector/proc/collector_break()
	if(loaded_tank && loaded_tank.air_contents)
		var/turf/T = get_turf(src)
		if(T)
			T.assume_air(loaded_tank.air_contents)
			audible_message(SPAN_DANGER("\The [loaded_tank.name] detonates, sending shrapnel flying!"))
			explosion(T, -1, -1, 0)
			QDEL_NULL(loaded_tank)
	disconnect_from_network()
	stat |= BROKEN
	melted = TRUE
	anchored = FALSE
	active = FALSE
	desc += " This one is destroyed beyond repair."
	update_icon()

/obj/machinery/power/rad_collector/return_air()
	if(loaded_tank)
		return loaded_tank.return_air()

/obj/machinery/power/rad_collector/ex_act(severity)
	switch(severity)
		if(2, 3)
			eject()
	return ..()

/**
 *  Ejects the stored phoron tank. If user is not defined or user is an invalid target, will eject onto the collector's position.
 *
 * Arguments:
 * - user: Optional. If defined, will eject the tank into the user's hands, if possible.
 */
/obj/machinery/power/rad_collector/proc/eject(mob/user)
	locked = 0
	var/obj/item/tank/phoron/tank = src.loaded_tank
	if(!tank)
		return
	if(user)
		user.put_in_hands(tank, TRUE)
	else
		tank.dropInto(loc)
		tank.reset_plane_and_layer()
	src.loaded_tank = null
	if(active)
		toggle_power()
	else
		update_icon()

/**
 * Handles the generation of power for the radiation collector
 *
 * Arguments:
 * - pulse_strength: The strength of the pulse to calculate into power output
 */
/obj/machinery/power/rad_collector/proc/receive_pulse(pulse_strength)
	if(loaded_tank && active)
		var/power_produced = 0
		power_produced = min(100*loaded_tank.air_contents.gas[GAS_PHORON]*pulse_strength*pulse_coeff,max_power)
		add_avail(power_produced)
		last_power_new = power_produced
		return
	return


/obj/machinery/power/rad_collector/update_icon()
	if(melted)
		icon_state = "ca_melt"
	else if(active)
		icon_state = "ca_on"
	else
		icon_state = "ca"

	ClearOverlays()
	underlays.Cut()

	if(loaded_tank)
		AddOverlays(image(icon, "ptank"))
		AddOverlays(emissive_appearance(icon, "ca_filling"))
		underlays += image(icon, "ca_filling")
	underlays += image(icon, "ca_inside")
	if(!operable())
		return
	if(active)
		var/rad_power = round(min(100 * last_rads / max_rads, 100), 20)
		AddOverlays(emissive_appearance(icon, "rads_[rad_power]"))
		AddOverlays(image(icon, "rads_[rad_power]"))
		AddOverlays(emissive_appearance(icon, "on"))
		AddOverlays(image(icon, "on"))


/obj/machinery/power/rad_collector/toggle_power()
	active = !active
	if(active)
		flick("ca_active", src)
	else
		flick("ca_deactive", src)
	update_icon()
