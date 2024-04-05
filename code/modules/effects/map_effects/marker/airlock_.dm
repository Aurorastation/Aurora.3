
/// Airlock marker that, when placed above airlock components, actually sets them up to make it functional.
/// This is a simple exterior access airlock, not used for docking.
/// See `maps/helpers/guidelines_airlocks.dmm` for examples of good and bad airlocks.
/obj/effect/map_effect/marker/airlock
	name = "airlock marker"
	desc = "See comments/documentation in code."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_airlock"
	layer = LIGHTING_LAYER

	/// Radio frequency of this airlock.
	/// For simple external/service access airlocks it does not affect anything.
	var/frequency = 2137

	/// Unique tag for this airlock. Not visible in game and to the player. Do not leave this as null.
	/// THIS MUST BE UNIQUE FOR THE AIRLOCK. Every marker in one airlock should have the same `master_tag`.
	/// Different airlocks, even on different maps, cannot share the same `master_tag`.
	var/master_tag = null

	/// If true, the airlock will be set up to fill with air from the outside when cycling to exterior,
	/// and will empty air to outside before filling with interior air. This makes it so exterior and interior atmospheres do not mix.
	/// Should be used for airlocks that may be used on planets with atmosphere and air (as opposed to ships or space stations that stay in vacuum).
	var/cycle_to_external_air = FALSE

	/// Doors/buttons/etc will be set to this access requirement. If null, they will not have any access requirements.
	req_access = null

	/// Doors/buttons/etc will be set to this access requirement. If null, they will not have any access requirements.
	req_one_access = list(ACCESS_EXTERNAL_AIRLOCKS)

/obj/effect/map_effect/marker/airlock/Initialize(mapload, ...)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/airlock/LateInitialize()
	if(!master_tag || !frequency)
		return

	var/is_interior = locate(/obj/effect/map_effect/marker_helper/airlock/interior) in loc
	var/is_exterior = locate(/obj/effect/map_effect/marker_helper/airlock/exterior) in loc
	var/is_out = locate(/obj/effect/map_effect/marker_helper/airlock/out) in loc

	// iterate over airlock components under this marker
	// and actually set them up
	for(var/thing in loc)
		// set up the controller
		var/obj/machinery/embedded_controller/radio/airlock/airlock_controller/controller = thing
		if(istype(controller))
			// common controller vars
			controller.set_frequency(frequency)
			controller.id_tag = MARKER_AIRLOCK_TAG_MASTER
			controller.tag_airpump = MARKER_AIRLOCK_TAG_AIRPUMP_CHAMBER
			controller.tag_chamber_sensor = MARKER_AIRLOCK_TAG_SENSOR_CHAMBER
			controller.tag_exterior_sensor = MARKER_AIRLOCK_TAG_SENSOR_EXTERIOR
			controller.tag_exterior_door = MARKER_AIRLOCK_TAG_DOOR_EXTERIOR
			controller.tag_interior_door = MARKER_AIRLOCK_TAG_DOOR_INTERIOR
			controller.cycle_to_external_air = cycle_to_external_air
			controller.req_access = req_access
			controller.req_one_access = req_one_access
			// controller subtype specific vars
			controller.program = new /datum/computer/file/embedded_program/airlock(controller)
			continue

		// and all the other airlock components

		var/obj/machinery/door/airlock/door = thing
		if(istype(door))
			door.set_frequency(frequency)
			door.req_access = req_access
			door.req_one_access = req_one_access
			door.lock()
			if(is_interior)
				door.id_tag = MARKER_AIRLOCK_TAG_DOOR_INTERIOR
			else if(is_exterior)
				door.id_tag = MARKER_AIRLOCK_TAG_DOOR_EXTERIOR
			continue

		var/obj/machinery/airlock_sensor/sensor = thing
		if(istype(sensor))
			sensor.set_frequency(frequency)
			sensor.master_tag = MARKER_AIRLOCK_TAG_MASTER
			if(is_interior)
				sensor.id_tag = MARKER_AIRLOCK_TAG_SENSOR_INTERIOR
			else if(is_exterior)
				sensor.id_tag = MARKER_AIRLOCK_TAG_SENSOR_EXTERIOR
			else
				sensor.id_tag = MARKER_AIRLOCK_TAG_SENSOR_CHAMBER
			continue

		var/obj/machinery/atmospherics/unary/vent_pump/pump = thing
		if(istype(pump))
			pump.frequency = frequency
			unregister_radio(pump, frequency)
			pump.setup_radio()
			if(is_exterior)
				pump.id_tag = MARKER_AIRLOCK_TAG_AIRPUMP_OUT_EXTERNAL
			else if(is_out)
				pump.id_tag = MARKER_AIRLOCK_TAG_AIRPUMP_OUT_INTERNAL
			else
				pump.id_tag = MARKER_AIRLOCK_TAG_AIRPUMP_CHAMBER
			continue

		var/obj/machinery/access_button/button = thing
		if(istype(button))
			button.set_frequency(frequency)
			button.master_tag = MARKER_AIRLOCK_TAG_MASTER
			button.req_access = req_access
			button.req_one_access = req_one_access
			if(is_interior)
				button.command = "cycle_interior"
			else if(is_exterior)
				button.command = "cycle_exterior"
			continue
