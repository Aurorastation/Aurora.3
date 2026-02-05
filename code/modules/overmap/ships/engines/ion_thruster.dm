//electric engine, should be very rare
/datum/ship_engine/ion
	name = "ion thruster"
	var/obj/machinery/ion_engine/thruster

/datum/ship_engine/ion/New(obj/machinery/_holder)
	..()
	thruster = _holder

/datum/ship_engine/ion/Destroy()
	thruster = null
	. = ..()

/datum/ship_engine/ion/get_status()
	return thruster.get_status()

/datum/ship_engine/ion/get_thrust()
	return thruster.get_thrust()

/datum/ship_engine/ion/burn(var/power_modifier = 1)
	return thruster.burn(power_modifier)

/datum/ship_engine/ion/set_thrust_limit(new_limit)
	thruster.thrust_limit = new_limit

/datum/ship_engine/ion/get_thrust_limit()
	return thruster.thrust_limit

/datum/ship_engine/ion/is_on()
	return thruster.on && thruster.powered()

/datum/ship_engine/ion/toggle()
	thruster.on = !thruster.on

/datum/ship_engine/ion/can_burn()
	return thruster.on && thruster.powered()

/obj/machinery/ion_engine
	name = "ion propulsion device"
	desc = "An advanced ion propulsion device, using energy and a minute amount of gas to generate thrust."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	power_channel = AREA_USAGE_ENVIRON
	idle_power_usage = 19600
	anchored = TRUE
	component_types = list(
		/obj/item/circuitboard/engine/ion,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/capacitor = 2
	)

	var/datum/ship_engine/ion/controller
	var/thrust_limit = 1
	var/on = 1
	var/burn_cost = 36000
	var/generated_thrust = 2.5

/obj/machinery/ion_engine/Initialize()
	. = ..()
	controller = new(src)

/obj/machinery/ion_engine/Destroy()
	QDEL_NULL(controller)
	. = ..()

/obj/machinery/ion_engine/proc/get_status()
	. = list()
	.+= "Location: [get_area(src)]."
	if(!powered())
		.+= "Insufficient power to operate."

	. = jointext(.,"<br>")

/obj/machinery/ion_engine/proc/burn(var/power_modifier = 1)
	if(!on && !powered())
		return 0
	use_power_oneoff(thrust_limit * burn_cost * power_modifier)
	. = thrust_limit * generated_thrust * power_modifier

/obj/machinery/ion_engine/proc/get_thrust()
	return thrust_limit * generated_thrust * on

/obj/machinery/ion_engine/attackby(obj/item/attacking_item, mob/user)
	. = ..()
	if(default_deconstruction_screwdriver(user, attacking_item))
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE
