/datum/ship_engine/maneuvering
	name = "maneuvering thruster"
	var/obj/machinery/maneuvering_engine/thruster

/datum/ship_engine/maneuvering/New(obj/machinery/_holder)
	..()
	thruster = _holder

/datum/ship_engine/maneuvering/Destroy()
	thruster = null
	. = ..()

/datum/ship_engine/maneuvering/get_status()
	return thruster.get_status()

/datum/ship_engine/maneuvering/get_thrust()
	return thruster.get_thrust()

/datum/ship_engine/maneuvering/burn(var/power_modifier = 1)
	return thruster.burn(power_modifier)

/datum/ship_engine/maneuvering/set_thrust_limit(new_limit)
	thruster.thrust_limit = new_limit

/datum/ship_engine/maneuvering/get_thrust_limit()
	return thruster.thrust_limit

/datum/ship_engine/maneuvering/is_on()
	return thruster.on

/datum/ship_engine/maneuvering/toggle()
	thruster.on = !thruster.on

/datum/ship_engine/maneuvering/can_burn()
	return thruster.on

/obj/machinery/maneuvering_engine
	name = "pulse-maneuvering device"
	desc = "This engine is outfitted with an internal reservoir of pressurized gas. It's primarily intended to slowly move the vessel into dock, but can be used as very low level thrusters in a pinch."
	icon = 'icons/obj/ship_engine.dmi'
	icon_state = "nozzle"
	anchored = TRUE

	var/datum/ship_engine/maneuvering/controller
	var/thrust_limit = 1
	var/on = TRUE
	var/generated_thrust = 2

/obj/machinery/maneuvering_engine/Initialize()
	. = ..()
	controller = new(src)

/obj/machinery/maneuvering_engine/Destroy()
	QDEL_NULL(controller)
	return ..()

/obj/machinery/maneuvering_engine/proc/get_status()
	. = list()
	.+= "Location: [get_area(src)]."
	. = jointext(.,"<br>")

/obj/machinery/maneuvering_engine/proc/burn(var/power_modifier = 1)
	. = thrust_limit * generated_thrust * power_modifier

/obj/machinery/maneuvering_engine/proc/get_thrust()
	return thrust_limit * generated_thrust * on

/obj/item/circuitboard/engine/maneuvering
	name = T_BOARD("pulse-maneuvering device")
	board_type = "machine"
	icon_state = "mcontroller"
	build_path = /obj/machinery/maneuvering_engine
	origin_tech = list(TECH_POWER = 4, TECH_ENGINEERING = 3)
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/matter_bin = 1,
		/obj/item/stock_parts/capacitor = 2
	)
