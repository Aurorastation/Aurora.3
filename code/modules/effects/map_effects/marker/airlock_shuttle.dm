
/// Docking airlock marker that, when placed above airlock components, actually sets them up to make it functional.
/// This is a docking airlock specialized for shuttles, and is connected to a shuttle datum.
/// When that shuttle arrives at some landmark, the actual docking may commence, with the doors of the airlock automatically opening, etc.
/// This is the shuttle side of that docking (the other being the station/ship).
/obj/effect/map_effect/marker/airlock/shuttle
	name = "shuttle docking airlock marker"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_airlock_shuttle"
	layer = LIGHTING_LAYER

	/// Radio frequency of this airlock.
	/// For docking airlocks, the frequency of docking port airlock and the shuttle airlock needs to match,
	/// otherwise they can't "talk", and the docking will never actually happen (meaning the automatic opening/closing of doors).
	/// Keep 1380 as default frequency, to maximize compatibility between various shuttles and docks.
	frequency = 1380

	/// Unique tag for this airlock. Not visible in game and to the player. Do not leave this as null.
	/// THIS MUST BE UNIQUE FOR THE AIRLOCK. Every marker in one airlock should have the same `master_tag`.
	/// Different airlocks, even on different maps, cannot share the same `master_tag`.
	/// This must be the same as the `dock_target` tag in the shuttle datum.
	master_tag = null

	/// Tag of the shuttle, that this docking port is supposed to be connected to.
	/// Same as `name` var of the shuttle datum, and same as the key for `shuttles` in shuttle subsystem.
	var/shuttle_tag = null

/obj/effect/map_effect/marker/airlock/shuttle/LateInitialize()
	if(!master_tag || !frequency || !shuttle_tag)
		return

	var/is_interior = locate(/obj/effect/map_effect/marker_helper/airlock/interior) in loc
	var/is_exterior = locate(/obj/effect/map_effect/marker_helper/airlock/exterior) in loc
	var/is_out = locate(/obj/effect/map_effect/marker_helper/airlock/out) in loc

	// iterate over airlock components under this marker
	// and actually set them up
	for(var/thing in loc)
		// set up the controller
		var/obj/machinery/embedded_controller/radio/airlock/docking_port/controller = thing
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
			controller.airlock_program = new /datum/computer/file/embedded_program/airlock/docking(controller)
			controller.docking_program = new /datum/computer/file/embedded_program/docking/airlock(controller, controller.airlock_program)
			controller.program = controller.docking_program
			if(SSshuttle.shuttles[shuttle_tag])
				var/datum/shuttle/autodock/shuttle = SSshuttle.shuttles[shuttle_tag]
				shuttle.dock_target = MARKER_AIRLOCK_TAG_MASTER
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
