/**
 * Returns a jetpack if the param is a human mob and said human mob is wearing
 * a jetpack on their back, or has a RIG on their back with the jetpack module
 * installed.
 *
 * @param	H Either a human or a robot mob. Is type and sanity checked.
 *
 * @return	A jetpack instance if one is found. Null otherwise.
 */
/proc/GetJetpack(var/mob/living/carbon/human/H)
	// Search the human for a jetpack. Either on back or on a RIG that's on
	// on their back.
	if(istype(H))
		// Skip sanity check for H.back, as istype can safely handle a null.
		if (istype(H.back, /obj/item/tank/jetpack))
			return H.back
		else if (istype(H.back, /obj/item/rig))
			var/obj/item/rig/rig = H.back
			for (var/obj/item/rig_module/maneuvering_jets/module in rig.installed_modules)
				return module.jets
	// See if we have a robot instead, and look for their jetpack.
	else if (istype(H, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = H
		if (R.module)
			for (var/obj/item/tank/jetpack/J in R.module.modules)
				return J
		// Synthetic jetpacks don't install into modules. They go into contents.
		for (var/obj/item/tank/jetpack/J in R.contents)
			return J

	return null

/obj/item/tank/jetpack
	name = "jetpack"
	desc = "A tank of compressed gas for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	item_state = "jetpack"
	gauge_icon = null
	w_class = ITEMSIZE_LARGE
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	var/ion_trail_type = /obj/effect/effect/ion_trails
	var/on = 0.0
	var/stabilization_on = 0
	var/warned = 0
	var/volume_rate = 500              //Needed for borg jetpack transfer
	action_button_name = "Toggle Jetpack"

/obj/item/tank/jetpack/examine(mob/user)
	. = ..()
	if(air_contents.total_moles < 5)
		to_chat(user, "<span class='danger'>The meter on \the [src] indicates you are almost out of gas!</span>")

/obj/item/tank/jetpack/verb/toggle_rockets()
	set name = "Toggle Jetpack Stabilization"
	set category = "Object"

	toggle_rockets_stabilization(usr)

/obj/item/tank/jetpack/proc/toggle_rockets_stabilization(mob/user, var/list/message_mobs)
	stabilization_on = !stabilization_on
	to_chat(user, SPAN_NOTICE("You toggle \the [src]'s stabilization [stabilization_on ? "on" : "off"]."))
	for(var/M in message_mobs)
		to_chat(M, SPAN_NOTICE("[user] toggles \the [src]'s stabilization [stabilization_on ? "on" : "off"]."))

/obj/item/tank/jetpack/verb/toggle()
	set name = "Toggle Jetpack"
	set category = "Object"

	toggle_jetpack(usr)

/obj/item/tank/jetpack/proc/toggle_jetpack(mob/user, var/list/message_mobs)
	on = !on
	toggle_rockets_stabilization(user, message_mobs)
	if(on)
		icon_state = "[icon_state]-on"
	else
		icon_state = initial(icon_state)

	user.update_inv_back()
	user.update_action_buttons()

	to_chat(user, SPAN_NOTICE("You toggle \the [src]'s thrusters [on ? "on" : "off"]."))
	for(var/M in message_mobs)
		to_chat(M, SPAN_NOTICE("[user] toggles \the [src]'s thrusters [on ? "on" : "off"]."))

/obj/item/tank/jetpack/proc/allow_thrust(num, mob/living/user as mob)
	if(!(src.on))
		return FALSE

	if (stabilization_on)
		num *= 2//gas usage is doubled when stabilising. one burst to start moving, and one to stop

	if((num < 0.005 || src.air_contents.total_moles < num))
		return FALSE

	if (src.air_contents.total_moles < 3 && !warned)
		warned = TRUE
		playsound(user, 'sound/effects/alert.ogg', 50, 1)
		to_chat(user, "<span class='danger'>The meter on \the [src] indicates you are almost out of gas and beeps loudly!</span>")
		addtimer(CALLBACK(src, .proc/reset_warning), 600)

	var/datum/gas_mixture/G = src.air_contents.remove(num)

	var/allgases = G.gas[GAS_CO2] + G.gas[GAS_NITROGEN] + G.gas[GAS_OXYGEN] + G.gas[GAS_PHORON] + G.gas[GAS_HYDROGEN]
	if(allgases >= 0.005)
		var/obj/effect/effect/ion_trails/ion_trail = new(user.loc)
		flick("ion_fade", ion_trail)
		ion_trail.icon_state = "blank"
		animate(ion_trail, alpha = 0, time = 18, easing = SINE_EASING | EASE_IN)
		QDEL_IN(ion_trail, 20)
		return TRUE

	qdel(G)

/obj/item/tank/jetpack/proc/reset_warning()
	warned = 0

/obj/item/tank/jetpack/ui_action_click()
	toggle()


/obj/item/tank/jetpack/void
	name = "void jetpack (oxygen)"
	desc = "It works well in a void."
	icon_state = "jetpack-void"
	item_state =  "jetpack-void"

/obj/item/tank/jetpack/void/adjust_initial_gas()
	air_contents.adjust_gas(GAS_OXYGEN, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/jetpack/oxygen
	name = "jetpack (oxygen)"
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	item_state = "jetpack"

/obj/item/tank/jetpack/oxygen/adjust_initial_gas()
	air_contents.adjust_gas(GAS_OXYGEN, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/jetpack/carbondioxide
	name = "jetpack (carbon dioxide)"
	desc = "A tank of compressed carbon dioxide for use as propulsion in zero-gravity areas. Painted black to indicate that it should not be used as a source for internals."
	distribute_pressure = 0
	icon_state = "jetpack-black"
	item_state = "jetpack-black"

/obj/item/tank/jetpack/carbondioxide/adjust_initial_gas()
	air_contents.adjust_gas(GAS_CO2, (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/jetpack/carbondioxide/synthetic
	name = "Synthetic Jetpack"
	desc = "A chassis-mounted tank of compressed carbon dioxide for use as propulsion in zero-gravity areas."

/obj/item/tank/jetpack/carbondioxide/synthetic/adjust_initial_gas()
	air_contents.adjust_gas(GAS_CO2, (15*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/jetpack/carbondioxide/synthetic/verb/toggle_synthetic_jetpack()
	set name = "Toggle Jetpack"
	set category = "Robot Commands"

	on = !on
	if(on)
		icon_state = "[icon_state]-on"
	else
		icon_state = initial(icon_state)

	to_chat(usr, SPAN_NOTICE("You toggle the thrusters [on ? "on" : "off"]."))
	stabilization_on = !stabilization_on
	to_chat(usr, SPAN_NOTICE("You toggle the stabilization [stabilization_on ? "on" : "off"]."))

/obj/item/tank/jetpack/carbondioxide/synthetic/verb/toggle_stabilizer()
	set name = "Toggle Jetpack Stabilization"
	set category = "Robot Commands"

	stabilization_on = !stabilization_on
	to_chat(usr, SPAN_NOTICE("You toggle the stabilization [stabilization_on ? "on" : "off"]."))

/obj/item/tank/jetpack/rig
	name = "hardsuit jetpack"
	var/obj/item/rig/holder

/obj/item/tank/jetpack/rig/examine()
	to_chat(usr, "It's a jetpack. If you can see this, report it on the bug tracker.")
	return 0

/obj/item/tank/jetpack/rig/allow_thrust(num, mob/living/user as mob)

	if(!(src.on))
		return FALSE

	if(!istype(holder) || !holder.air_supply)
		return FALSE

	var/obj/item/tank/pressure_vessel = holder.air_supply

	if((num < 0.005 || pressure_vessel.air_contents.total_moles < num))
		return FALSE

	var/datum/gas_mixture/G = pressure_vessel.air_contents.remove(num)

	var/allgases = G.gas[GAS_CO2] + G.gas[GAS_NITROGEN] + G.gas[GAS_OXYGEN] + G.gas[GAS_PHORON] + G.gas[GAS_HYDROGEN]
	if(allgases >= 0.005)
		var/obj/effect/effect/ion_trails/ion_trail = new(user.loc)
		flick("ion_fade", ion_trail)
		ion_trail.icon_state = "blank"
		animate(ion_trail, alpha = 0, time = 18, easing = SINE_EASING | EASE_IN)
		QDEL_IN(ion_trail, 20)
		return TRUE

	qdel(G)
