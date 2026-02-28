/obj/machinery/power/generator
	name = "\improper Stirling engine"
	desc = "It's a high efficiency Stirling engine. This model produces electricity from the temperature and differential between two gas loops."
	icon_state = "teg-unassembled"
	density = TRUE
	anchored = FALSE
	obj_flags = OBJ_FLAG_ROTATABLE

	use_power = POWER_USE_OFF
	idle_power_usage = 1000

	var/max_power = 2500000
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

	var/datum/effect_system/sparks/spark_system

/obj/machinery/power/generator/Initialize()
	. = ..()
	desc = initial(desc) + " Rated for [round(max_power/1000)] kW."
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

/**
 * Circulators connect in dir and reverse_dir(dir) directions
 * A mnemonic to determine circulator/generator directions: the cirulators orbit clockwise around the generator.
 * So a circulator to the NORTH of the generator connects first to the EAST, then to the WEST,
 * and a circulator to the WEST of the generator connects first to the NORTH, then to the SOUTH.
 * Note that the circulator's outlet dir is it's always facing dir, and it's inlet is always the reverse
 */
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
	ClearOverlays()
	if(circ1)
		circ1.temperature_overlay = null
	if(circ2)
		circ2.temperature_overlay = null
	if(stat & (NOPOWER|BROKEN))
		return TRUE
	else
		if (lastgenlev != 0)
			AddOverlays("teg-op[lastgenlev]")
			if (circ1 && circ2)
				var/extreme = (lastgenlev > 9) ? "ex" : ""
				if (circ1.last_temperature < circ2.last_temperature)
					circ1.temperature_overlay = "circ-[extreme]cold"
					circ1.is_hot_loop = FALSE
					circ2.temperature_overlay = "circ-[extreme]hot"
					circ2.is_hot_loop = TRUE
				else
					circ1.temperature_overlay = "circ-[extreme]hot"
					circ1.is_hot_loop = TRUE
					circ2.temperature_overlay = "circ-[extreme]cold"
					circ2.is_hot_loop = FALSE
		return TRUE

/obj/machinery/power/generator/process()
	if(!circ1 || !circ2 || !anchored || stat & (BROKEN|NOPOWER))
		stored_energy = 0
		return

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
	circ1?.update_networks()
	circ2?.update_networks()

	//Exceeding maximum power leads to some power loss
	if(effective_gen > max_power && prob(5))
		spark_system.queue()
		stored_energy *= 0.67

	//Power
	last_circ1_gen = circ1.return_stored_energy()
	last_circ2_gen = circ2.return_stored_energy()
	stored_energy += last_thermal_gen + last_circ1_gen + last_circ2_gen
	lastgen1 = stored_energy*0.4 //smoothened power generation to prevent slingshotting as pressure is equalized, then restored by pumps
	stored_energy -= lastgen1
	effective_gen = (lastgen1 + lastgen2) / 2

	// update icon overlays and power usage only when necessary
	var/genlev = max(0, min( round(11*effective_gen / max_power), 11))
	if(effective_gen > 100 && genlev == 0)
		genlev = 1
	if(genlev != lastgenlev)
		lastgenlev = genlev
		update_icon()
	ADD_TO_POWERNET(src, effective_gen)

/obj/machinery/power/generator/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	attack_hand(user)

/obj/machinery/power/generator/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.tool_behaviour == TOOL_WRENCH)
		attacking_item.play_tool_sound(get_turf(src), 75)
		anchored = !anchored
		balloon_alert(user, "[anchored ? "secure" : "unsecure"]")
		user.visible_message("[user.name] [anchored ? "secures" : "unsecures"] the bolts holding [src.name] to the floor.", \
					"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
					"You hear a ratchet")
		update_use_power(anchored ? POWER_USE_IDLE : POWER_USE_OFF)
		if(anchored) // Powernet connection stuff.
			connect_to_network()
		else
			disconnect_from_network()
		reconnect()
	else
		..()

/obj/machinery/power/generator/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER) || !anchored) return
	if(!circ1 || !circ2) //Just incase the middle part of the TEG was not wrenched last.
		reconnect()
	ui_interact(user)

/obj/machinery/power/generator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		// Interface ID should match your tgui route registration/name.
		ui = new(user, src, "StirlingEngine", "Stirling Engine")
		ui.open()

/obj/machinery/power/generator/ui_data(mob/user)
	var/list/data = list()

	var/vertical = FALSE
	if(dir == NORTH || dir == SOUTH)
		vertical = TRUE

	data["totalOutput"] = effective_gen / 1000
	data["maxTotalOutput"] = max_power / 1000
	data["thermalOutput"] = last_thermal_gen / 1000
	data["circConnected"] = FALSE

	if(circ1)
		// The one on the left (or top)
		data["primaryDir"] = vertical ? "top" : "left"
		data["primaryOutput"] = last_circ1_gen/1000
		data["primaryFlowCapacity"] = circ1.volume_capacity_used*100
		data["primaryInletPressure"] = XGM_PRESSURE(circ1.air1)
		data["primaryInletTemperature"] = circ1.air1.temperature
		data["primaryOutletPressure"] = XGM_PRESSURE(circ1.air2)
		data["primaryOutletTemperature"] = circ1.air2.temperature
		data["primaryIsHot"] = circ1.is_hot_loop

	if(circ2)
		// The one on the right (or bottom)
		data["secondaryDir"] = vertical ? "bottom" : "right"
		data["secondaryOutput"] = last_circ2_gen/1000
		data["secondaryFlowCapacity"] = circ2.volume_capacity_used*100
		data["secondaryInletPressure"] = XGM_PRESSURE(circ2.air1)
		data["secondaryInletTemperature"] = circ2.air1.temperature
		data["secondaryOutletPressure"] = XGM_PRESSURE(circ2.air2)
		data["secondaryOutletTemperature"] = circ2.air2.temperature
		data["secondaryIsHot"] = circ2.is_hot_loop

	data["circConnected"] = (circ1 && circ2) ? TRUE : FALSE

	return data

/obj/machinery/power/generator/power_change()
	..()
	update_icon()
