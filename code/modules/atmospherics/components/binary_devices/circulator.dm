//node1, air1, network1 correspond to input
//node2, air2, network2 correspond to output

/obj/machinery/atmospherics/binary/circulator
	name = "circulator"
	desc = "A gas circulator turbine and heat exchanger."
	desc_info = "This generates electricity depending on the difference in temperature between each side of the machine.  The meter in \
	the center of the machine gives an indicator of how much elecrtricity is being generated.\n\n \
	You can increase the maximum volume, thermal efficiency and temperature rating by installing better matterbins and/or manipiulators."
	icon = 'icons/obj/power.dmi'
	icon_state = "circ-unassembled"
	anchored = FALSE
	obj_flags = OBJ_FLAG_ROTATABLE

	component_types = list(
		/obj/item/circuitboard/circulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stack/cable_coil = 5
	)

	var/kinetic_efficiency = 0.04 //combined kinetic and kinetic-to-electric efficiency
	var/volume_ratio = 0.2
	var/max_temperature = 7500 // Kelvin

	var/recent_moles_transferred = 0
	var/last_heat_capacity = 0
	var/last_temperature = 0
	var/last_pressure_delta = 0
	var/last_worldtime_transfer = 0
	var/last_stored_energy_transferred = 0
	var/volume_capacity_used = 0
	var/stored_energy = 0
	var/temperature_overlay

	var/busy = FALSE

	density = TRUE

/obj/machinery/atmospherics/binary/circulator/Initialize()
	. = ..()
	desc = initial(desc) + " Its outlet port is to the [dir2text(dir)]. Turbine chamber rated to withstand " + SPAN_BOLD("[max_temperature] Kelvin -") + SPAN_WARNING(" do not exceed!")
	air1.volume = 400

/obj/machinery/atmospherics/binary/circulator/proc/return_transfer_air()
	var/datum/gas_mixture/removed
	if(anchored && !(stat&BROKEN) && network1)
		var/input_starting_pressure = air1.return_pressure()
		var/output_starting_pressure = air2.return_pressure()
		last_pressure_delta = max(input_starting_pressure - output_starting_pressure - 5, 0)

		//only circulate air if there is a pressure difference (plus 5kPa kinetic, 10kPa static friction)
		if(air1.temperature > 0 && last_pressure_delta > 5)
			//Calculate necessary moles to transfer using PV = nRT
			recent_moles_transferred = (last_pressure_delta*network1.volume/(air1.temperature * R_IDEAL_GAS_EQUATION))/3 //uses the volume of the whole network, not just itself
			volume_capacity_used = min( (last_pressure_delta*network1.volume/3)/(input_starting_pressure*air1.volume) , 1) //how much of the gas in the input air volume is consumed

			//Calculate energy generated from kinetic turbine
			stored_energy += 1/ADIABATIC_EXPONENT * min(last_pressure_delta * network1.volume , input_starting_pressure*air1.volume) * (1 - volume_ratio**ADIABATIC_EXPONENT) * kinetic_efficiency

			//Actually transfer the gas
			removed = air1.remove(recent_moles_transferred)
			if(removed)
				last_heat_capacity = removed.heat_capacity()
				last_temperature = removed.temperature

				//Update the gas networks.
				network1.update = 1

				last_worldtime_transfer = world.time
		else
			recent_moles_transferred = 0

		update_icon()
		return removed

/obj/machinery/atmospherics/binary/circulator/proc/return_stored_energy()
	last_stored_energy_transferred = stored_energy
	stored_energy = 0
	return last_stored_energy_transferred

/obj/machinery/atmospherics/binary/circulator/process()
	..()

	if(anchored && !(stat&BROKEN))
		if ((last_pressure_delta > (5*ONE_ATMOSPHERE)) && (recent_moles_transferred > 0))
			busy = TRUE
		else
			busy = FALSE

	if(last_worldtime_transfer < world.time - 50)
		recent_moles_transferred = 0
		update_icon()

	//If the gas exceeds temperature rating, the circulator leaks the gas and explodes.
	if(air1.temperature > max_temperature)
		visible_message(SPAN_HIGHDANGER("\The [src]'s turbine rattles loudly... it looks like it's about to fly off!"))
		if(prob(5))
			var/turf/T = get_turf(src)
			if(istype(T))
				var/datum/gas_mixture/circulator_leak
				circulator_leak = air1.remove(recent_moles_transferred)
				if(circulator_leak)
					circulator_leak.temperature = air1.temperature
					circulator_leak.update_values()
					T.assume_air(circulator_leak)
					T.hotspot_expose(circulator_leak.temperature)
					circulator_leak = null
			message_admins("TEG Circulator exceeded temperature rating and exploded ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
			log_game("Thermoelectric generator circulator exceeded max temperature ([last_temperature]K/[max_temperature]K) and exploded at ([x],[y],[z]).")
			explosion(get_turf(src), 0, 0, 1, 4, 1)
			qdel(src)

/obj/machinery/atmospherics/binary/circulator/update_icon()
	icon_state = anchored ? "circ-assembled" : "circ-unassembled"
	cut_overlays()
	if (stat & (BROKEN|NOPOWER) || !anchored)
		return TRUE
	if (last_pressure_delta > 0 && recent_moles_transferred > 0)
		if (temperature_overlay)
			add_overlay(temperature_overlay)
		if (last_pressure_delta > 5*ONE_ATMOSPHERE)
			add_overlay("circ-run")
		else
			add_overlay("circ-slow")
	else
		add_overlay("circ-off")

	return TRUE

/obj/machinery/atmospherics/binary/circulator/attackby(obj/item/attacking_item, mob/user)
	if(busy)
		to_chat(user, SPAN_WARNING("\The [src]'s turbine is spinning too fast to modify \the [src] right now! Cut off or limit the gas flow to slow the turbine."))
		return TRUE

	if(attacking_item.iswrench())
		attacking_item.play_tool_sound(get_turf(src), 50)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet.")

		if(anchored)
			temperature_overlay = null
			if(dir & (NORTH|SOUTH))
				initialize_directions = NORTH|SOUTH
			else if(dir & (EAST|WEST))
				initialize_directions = EAST|WEST

			atmos_init()
			build_network()
			if (node1)
				node1.atmos_init()
				node1.build_network()
			if (node2)
				node2.atmos_init()
				node2.build_network()
		else
			if(node1)
				node1.disconnect(src)
				qdel(network1)
			if(node2)
				node2.disconnect(src)
				qdel(network2)

			node1 = null
			node2 = null
		update_icon()
		return TRUE

	if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE

	return ..()

/obj/machinery/atmospherics/binary/circulator/RefreshParts()
	..()
	var/bin_rating = 0
	var/manipulator_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(ismatterbin(P))
			bin_rating += P.rating
		if(ismanipulator(P))
			manipulator_rating += P.rating

	volume_ratio = 0.1 + (bin_rating/10)
	kinetic_efficiency = max(0.03+(manipulator_rating/100))

	switch(bin_rating)
		if(1)
			max_temperature = 7000 // The temperature a supermatter chamber reaches mid-delamination.
		if(2)
			max_temperature = 15000
		if(3)
			max_temperature = 50000

	desc = initial(desc) + " Its outlet port is to the [dir2text(dir)]. Turbine chamber rated to withstand " + SPAN_BOLD("[max_temperature] Kelvin -") + SPAN_WARNING(" do not exceed!")
