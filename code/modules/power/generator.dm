/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	desc_info = "You can improve the power rating and efficiency of a thermoelectric generator by installing better capacitors and/or manipulators."
	icon_state = "teg-unassembled"
	density = TRUE
	anchored = FALSE
	obj_flags = OBJ_FLAG_ROTATABLE

	use_power = POWER_USE_OFF
	idle_power_usage = 100 //Watts, I hope.  Just enough to do the computer and display things.

	component_types = list(
		/obj/item/circuitboard/generator,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/console_screen,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/capacitor,
		/obj/item/stack/cable_coil = 15
	)

	var/max_power = 4000000
	var/thermal_efficiency = 0.65

	var/obj/machinery/atmospherics/binary/circulator/circ1
	var/obj/machinery/atmospherics/binary/circulator/circ2

	var/last_circ1_gen = 0
	var/last_circ2_gen = 0
	var/last_thermal_gen = 0
	var/stored_energy = 0
	var/lastgen1 = 0
	var/lastgen2 = 0
	var/effective_gen = 0
	var/lastgenlev = 0

	var/busy = FALSE

	var/datum/effect_system/sparks/spark_system

/obj/machinery/power/generator/Initialize()
	. = ..()
	desc = initial(desc) + " Rated for " + SPAN_BOLD("[round(max_power/1000)]kW -") + SPAN_WARNING(" do not exceed!")

	var/dirs
	if (dir == NORTH || dir == SOUTH)
		dirs = list(EAST,WEST)
	else
		dirs = list(NORTH,SOUTH)

	spark_system = bind_spark(src, 3, dirs)
	reconnect()

/obj/machinery/power/generator/Destroy()
	QDEL_NULL(spark_system)
	circ1 = null
	circ2 = null
	return ..()

//generators connect in dir and reverse_dir(dir) directions
//mnemonic to determine circulator/generator directions: the cirulators orbit clockwise around the generator
//so a circulator to the NORTH of the generator connects first to the EAST, then to the WEST
//and a circulator to the WEST of the generator connects first to the NORTH, then to the SOUTH
//note that the circulator's outlet dir is it's always facing dir, and it's inlet is always the reverse
/obj/machinery/power/generator/proc/reconnect()
	if(circ1)
		circ1.temperature_overlay = null
	if(circ2)
		circ2.temperature_overlay = null
	circ1 = null
	circ2 = null
	if(src.loc && anchored)
		if(src.dir & (EAST|WEST))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,WEST)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,EAST)

			if(circ1 && circ2)
				if(circ1.dir != NORTH || circ2.dir != SOUTH)
					circ1 = null
					circ2 = null

		else if(src.dir & (NORTH|SOUTH))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,NORTH)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src,SOUTH)

			if(circ1 && circ2 && (circ1.dir != EAST || circ2.dir != WEST))
				circ1 = null
				circ2 = null
	update_icon()

/obj/machinery/power/generator/update_icon()
	icon_state = anchored ? "teg-assembled" : "teg-unassembled"
	cut_overlays()
	if (circ1)
		circ1.temperature_overlay = null
	if (circ2)
		circ2.temperature_overlay = null
	if (stat & (NOPOWER|BROKEN))
		return TRUE
	else
		if (lastgenlev != 0)
			add_overlay("teg-op[lastgenlev]")
			if (circ1 && circ2)
				var/extreme = (lastgenlev > 9) ? "ex" : ""
				if (circ1.last_temperature < circ2.last_temperature)
					circ1.temperature_overlay = "circ-[extreme]cold"
					circ2.temperature_overlay = "circ-[extreme]hot"
				else
					circ1.temperature_overlay = "circ-[extreme]hot"
					circ2.temperature_overlay = "circ-[extreme]cold"
		return TRUE

/obj/machinery/power/generator/process()
	if(!circ1 || !circ2 || !anchored || stat & (BROKEN|NOPOWER))
		stored_energy = 0
		busy = FALSE
		return

	updateDialog()

	var/datum/gas_mixture/air1 = circ1.return_transfer_air()
	var/datum/gas_mixture/air2 = circ2.return_transfer_air()

	lastgen2 = lastgen1
	lastgen1 = 0
	last_thermal_gen = 0
	last_circ1_gen = 0
	last_circ2_gen = 0

	if(air1 && air2)
		var/air1_heat_capacity = air1.heat_capacity()
		var/air2_heat_capacity = air2.heat_capacity()
		var/delta_temperature = abs(air2.temperature - air1.temperature)

		if(delta_temperature > 0 && air1_heat_capacity > 0 && air2_heat_capacity > 0)
			var/energy_transfer = delta_temperature*air2_heat_capacity*air1_heat_capacity/(air2_heat_capacity+air1_heat_capacity)
			var/heat = energy_transfer*(1-thermal_efficiency)
			last_thermal_gen = energy_transfer*thermal_efficiency

			if(air2.temperature > air1.temperature)
				air2.temperature = air2.temperature - energy_transfer/air2_heat_capacity
				air1.temperature = air1.temperature + heat/air1_heat_capacity
			else
				air2.temperature = air2.temperature + heat/air2_heat_capacity
				air1.temperature = air1.temperature - energy_transfer/air1_heat_capacity
			playsound(get_turf(src), 'sound/effects/beam.ogg', 25, FALSE, 10, , required_preferences = ASFX_AMBIENCE, channel = CHANNEL_AMBIENCE)

	//Transfer the air
	if (air1)
		circ1.air2.merge(air1)
	if (air2)
		circ2.air2.merge(air2)

	//Update the gas networks
	if(circ1.network2)
		circ1.network2.update = 1
	if(circ2.network2)
		circ2.network2.update = 1

	//Power
	last_circ1_gen = circ1.return_stored_energy()
	last_circ2_gen = circ2.return_stored_energy()
	stored_energy += last_thermal_gen + last_circ1_gen + last_circ2_gen
	lastgen1 = stored_energy*0.4 //smoothened power generation to prevent slingshotting as pressure is equalized, then restored by pumps
	stored_energy -= lastgen1
	effective_gen = (lastgen1 + lastgen2) / 2

	//can't modify if producing over 500kw
	if(effective_gen > 500)
		busy = TRUE
	else
		busy = FALSE

	//Exceeding maximum power leads to some power loss and a chance to explode
	if(effective_gen > max_power)
		if(prob(50))
			spark_system.queue()
			stored_energy *= 0.5
		if(prob(10))
			visible_message(SPAN_HIGHDANGER("\The [src] releases a plume of foul-smelling smoke. It smells like burning cable insulation!"))
			var/datum/effect/effect/system/smoke_spread/bad/smoke = new /datum/effect/effect/system/smoke_spread/bad
			smoke.attach(src)
			smoke.set_up(5, 0, get_turf(src), 25)
			smoke.start()
			if(prob(10))
				visible_message(SPAN_HIGHDANGER("\The [src] is engulfed in a ball of flames before it explodes!"))
				message_admins("Thermoelectric generator greatly exceeded power rating and exploded at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
				log_game("Thermoelectric generator greatly exceed power rating ([effective_gen]w/[max_power]w) and exploded at ([x],[y],[z]).")
				explosion(get_turf(src), 0, 0, 3, 7, 1)
				qdel(src)
				return

	// update icon overlays and power usage only when necessary
	var/genlev = max(0, min( round(11*effective_gen / max_power), 11))
	if(effective_gen > 100 && genlev == 0)
		genlev = 1
	if(genlev != lastgenlev)
		lastgenlev = genlev
		update_icon()
	add_avail(effective_gen)

/obj/machinery/power/generator/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	attack_hand(user)

/obj/machinery/power/generator/attackby(obj/item/attacking_item, mob/user)
	if(busy)
		to_chat(user, SPAN_WARNING("You cannot modify \the [src] while it is live! Cut off the gas flow to both circulators or minimise the temperature difference to halt power production first."))
		return TRUE

	if(attacking_item.iswrench())
		attacking_item.play_tool_sound(get_turf(src), 75)
		anchored = !anchored
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet")
		update_use_power(anchored ? POWER_USE_IDLE : POWER_USE_OFF)
		if(anchored) // Powernet connection stuff.
			connect_to_network()
		else
			disconnect_from_network()
		reconnect()
		return TRUE

	if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE
	return ..()

/obj/machinery/power/generator/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER) || !anchored) return
	if(!circ1 || !circ2) //Just incase the middle part of the TEG was not wrenched last.
		reconnect()
	ui_interact(user)

/obj/machinery/power/generator/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	// this is the data which will be sent to the ui
	var/vertical = 0
	if (dir == NORTH || dir == SOUTH)
		vertical = 1

	var/data[0]
	data["totalOutput"] = effective_gen/1000
	data["maxTotalOutput"] = max_power/1000
	data["thermalOutput"] = last_thermal_gen/1000
	data["circConnected"] = 0

	if(circ1)
		//The one on the left (or top)
		data["primaryDir"] = vertical ? "top" : "left"
		data["primaryOutput"] = last_circ1_gen/1000
		data["primaryFlowCapacity"] = circ1.volume_capacity_used*100
		data["primaryInletPressure"] = circ1.air1.return_pressure()
		data["primaryInletTemperature"] = circ1.air1.temperature
		data["primaryOutletPressure"] = circ1.air2.return_pressure()
		data["primaryOutletTemperature"] = circ1.air2.temperature

	if(circ2)
		//Now for the one on the right (or bottom)
		data["secondaryDir"] = vertical ? "bottom" : "right"
		data["secondaryOutput"] = last_circ2_gen/1000
		data["secondaryFlowCapacity"] = circ2.volume_capacity_used*100
		data["secondaryInletPressure"] = circ2.air1.return_pressure()
		data["secondaryInletTemperature"] = circ2.air1.temperature
		data["secondaryOutletPressure"] = circ2.air2.return_pressure()
		data["secondaryOutletTemperature"] = circ2.air2.temperature

	if(circ1 && circ2)
		data["circConnected"] = 1
	else
		data["circConnected"] = 0


	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "generator.tmpl", "Thermoelectric Generator", 450, 500)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/power/generator/power_change()
	..()
	update_icon()

/obj/machinery/power/generator/RefreshParts()
	..()
	var/capacitor_rating = 0
	var/manipulator_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(iscapacitor(P))
			capacitor_rating += P.rating
		if(ismanipulator(P))
			manipulator_rating += P.rating

	switch(capacitor_rating)
		if(1)
			max_power = 4000000 // roughly the amount of power a mid-delamination SM produces
		if(2)
			max_power = 8000000
		if(3)
			max_power = 15000000

	thermal_efficiency = max(0.55+(manipulator_rating/10)) // 0.65 to 0.85 thermal efficiency

	desc = initial(desc) + " Rated for " + SPAN_BOLD("[round(max_power/1000)]kW -") + SPAN_WARNING(" do not exceed!")
