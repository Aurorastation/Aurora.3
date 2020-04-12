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
	name = "jetpack (empty)"
	desc = "A tank of compressed gas for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	item_state = "jetpack"
	gauge_icon = null
	w_class = 4.0
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	var/datum/effect_system/ion_trail/ion_trail
	var/on = 0.0
	var/stabilization_on = 0
	var/warned = 0
	var/volume_rate = 500              //Needed for borg jetpack transfer
	action_button_name = "Toggle Jetpack"

/obj/item/tank/jetpack/Initialize()
	. = ..()
	ion_trail = new(src)

/obj/item/tank/jetpack/Destroy()
	QDEL_NULL(ion_trail)
	return ..()

/obj/item/tank/jetpack/examine(mob/user)
	. = ..()
	if(air_contents.total_moles < 5)
		to_chat(user, "<span class='danger'>The meter on \the [src] indicates you are almost out of gas!</span>")

/obj/item/tank/jetpack/verb/toggle_rockets()
	set name = "Toggle Jetpack Stabilization"
	set category = "Object"
	src.stabilization_on = !( src.stabilization_on )
	to_chat(usr, "You toggle the stabilization [stabilization_on? "on":"off"].")

/obj/item/tank/jetpack/verb/toggle()
	set name = "Toggle Jetpack"
	set category = "Object"

	on = !on
	stabilization_on = !stabilization_on
	if(on)
		icon_state = "[icon_state]-on"
		ion_trail.start()
	else
		icon_state = initial(icon_state)
		ion_trail.stop()

	if (ismob(usr))
		var/mob/M = usr
		M.update_inv_back()
		M.update_action_buttons()

	to_chat(usr, span("notice", "You toggle the thrusters [on? "on":"off"]."))
	to_chat(usr, span("notice", "You toggle the stabilization [stabilization_on? "on":"off"]."))

/obj/item/tank/jetpack/proc/allow_thrust(num, mob/living/user as mob)
	if(!(src.on))
		return 0

	if (stabilization_on)
		num *= 2//gas usage is doubled when stabilising. one burst to start moving, and one to stop

	if((num < 0.005 || src.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	if (src.air_contents.total_moles < 3 && !warned)
		warned = 1
		playsound(user, 'sound/effects/alert.ogg', 50, 1)
		to_chat(user, "<span class='danger'>The meter on \the [src] indicates you are almost out of gas and beeps loudly!</span>")
		addtimer(CALLBACK(src, .proc/reset_warning), 600)

	var/datum/gas_mixture/G = src.air_contents.remove(num)

	var/allgases = G.gas["carbon_dioxide"] + G.gas["nitrogen"] + G.gas["oxygen"] + G.gas["phoron"]
	if(allgases >= 0.005)
		return 1

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

/obj/item/tank/jetpack/void/Initialize()
	. = ..()
	air_contents.adjust_gas("oxygen", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/jetpack/oxygen
	name = "jetpack (oxygen)"
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	item_state = "jetpack"

/obj/item/tank/jetpack/oxygen/Initialize()
	. = ..()
	air_contents.adjust_gas("oxygen", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/jetpack/carbondioxide
	name = "jetpack (carbon dioxide)"
	desc = "A tank of compressed carbon dioxide for use as propulsion in zero-gravity areas. Painted black to indicate that it should not be used as a source for internals."
	distribute_pressure = 0
	icon_state = "jetpack-black"
	item_state =  "jetpack-black"

/obj/item/tank/jetpack/carbondioxide/Initialize()
	. = ..()
	air_contents.adjust_gas("carbon_dioxide", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/tank/jetpack/carbondioxide/synthetic
	name = "Synthetic Jetpack"
	desc = "A chassis-mounted tank of compressed carbon dioxide for use as propulsion in zero-gravity areas."

/obj/item/tank/jetpack/carbondioxide/synthetic/verb/toggle_synthetic_jetpack()
	set name = "Toggle Jetpack"
	set category = "Robot Commands"

	on = !on
	if(on)
		icon_state = "[icon_state]-on"
		ion_trail.start()
	else
		icon_state = initial(icon_state)
		ion_trail.stop()

	if (ismob(usr))
		var/mob/M = usr
		M.update_inv_back()

	to_chat(usr, "You toggle the thrusters [on? "on":"off"].")

/obj/item/tank/jetpack/carbondioxide/synthetic/verb/toggle_stabilizer()
	set name = "Toggle Jetpack Stabilization"
	set category = "Robot Commands"
	src.stabilization_on = !( src.stabilization_on )
	to_chat(usr, "You toggle the stabilization [stabilization_on? "on":"off"].")

/obj/item/tank/jetpack/rig
	name = "jetpack"
	var/obj/item/rig/holder

/obj/item/tank/jetpack/rig/examine()
	to_chat(usr, "It's a jetpack. If you can see this, report it on the bug tracker.")
	return 0

/obj/item/tank/jetpack/rig/allow_thrust(num, mob/living/user as mob)

	if(!(src.on))
		return 0

	if(!istype(holder) || !holder.air_supply)
		return 0

	var/obj/item/tank/pressure_vessel = holder.air_supply

	if((num < 0.005 || pressure_vessel.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = pressure_vessel.air_contents.remove(num)

	var/allgases = G.gas["carbon_dioxide"] + G.gas["nitrogen"] + G.gas["oxygen"] + G.gas["phoron"]
	if(allgases >= 0.005)
		return 1
	qdel(G)
	return
