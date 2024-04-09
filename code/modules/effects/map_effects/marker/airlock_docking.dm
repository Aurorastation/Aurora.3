
/// Docking airlock marker that, when placed above airlock components, actually sets them up to make it functional.
/// This is a docking airlock, meaning it is connected to a shuttle landmark object.
/// When some shuttle arrives at that landmark, the actual docking may commence, with the doors of the airlock automatically opening, etc.
/// This is the station/ship side of that docking (the other being the shuttle).
/obj/effect/map_effect/marker/airlock/docking
	name = "docking airlock marker"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_airlock_docking"
	layer = LIGHTING_LAYER

	/// Radio frequency of this airlock.
	/// For docking airlocks, the frequency of docking port airlock and the shuttle airlock needs to match,
	/// otherwise they can't "talk", and the docking will never actually happen.
	/// Keep 1380 as default frequency, to maximize compatibility between various shuttles and docks.
	frequency = 1380

	/// Unique tag for this airlock. Not visible in game and to the player. Do not leave this as null.
	/// THIS MUST BE UNIQUE FOR THE AIRLOCK. Every marker in one airlock should have the same `master_tag`.
	/// Different airlocks, even on different maps, cannot share the same `master_tag`.
	/// This must be the same as the `docking_controller` tag in the shuttle landmark object.
	master_tag = null

	/// Tag of the shuttle landmark, that this docking port is supposed to be connected to.
	/// Same as `landmark_tag` var of the shuttle landmark object, and same as the key for `registered_shuttle_landmarks` in shuttle subsystem.
	var/landmark_tag = null

/obj/effect/map_effect/marker/airlock/docking/LateInitialize()
	if(!master_tag || !frequency || !landmark_tag)
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
			if(SSshuttle.registered_shuttle_landmarks[landmark_tag])
				var/obj/effect/shuttle_landmark/landmark = SSshuttle.registered_shuttle_landmarks[landmark_tag]
				landmark.docking_controller = SSshuttle.docking_registry[MARKER_AIRLOCK_TAG_MASTER]
			continue

		var/obj/effect/shuttle_landmark/landmark = thing
		if(istype(landmark))
			if(SSshuttle.docking_registry[MARKER_AIRLOCK_TAG_MASTER])
				landmark.docking_controller = SSshuttle.docking_registry[MARKER_AIRLOCK_TAG_MASTER]
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
