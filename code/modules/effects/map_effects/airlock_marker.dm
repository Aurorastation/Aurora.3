
/obj/effect/map_effect/marker
	name = "map marker parent abstract object"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "map_marker"

/obj/effect/map_effect/marker_helper
	name = "map marker parent abstract object"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "map_marker"

/// map of airlock marker `id_tag` to a list of map_effect/airlock_markers
var/global/list/airlock_markers = list()

/// Airlock marker that, when placed above airlock components (doors, pumps, sensors, etc),
/// actually sets the airlock up to make it functional.
/obj/effect/map_effect/marker/airlock
	name = "airlock marker (inside the airlock)"
	desc = "MASTER_TAG VAR MUST BE UNIQUE FOR THE AIRLOCK! Place this on top of airlock components (doors, pumps, sensors, etc)."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "airlock_marker"
	layer = LIGHTING_LAYER
	/// Radio frequency of this airlock.
	var/frequency = 2137
	/// Unique tag for this airlock. Not visible in game and to the player. Do not leave this as null.
	/// THIS MUST BE UNIQUE FOR THE AIRLOCK. Every marker in one airlock should have the same `master_tag`.
	/// But different airlocks, even on different maps, cannot share the same `master_tag`.
	var/master_tag = null
	/// Doors/buttons/etc will be set to this access requirement. If null, they will not have any access requirements.
	var/required_access = list(access_external_airlocks)

/// Specialization helper for the airlock marker, to be put above "exterior" parts of the airlock,
/// and on top of the actual airlock marker. By itself does nothing.
/obj/effect/map_effect/marker_helper/airlock/exterior
	name = "airlock marker (exterior/outside/vacuum)"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "airlock_marker_exterior"
	layer = LIGHTING_LAYER

/// Specialization helper for the airlock marker, to be put above "interior" parts of the airlock,
/// and on top of the actual airlock marker. By itself does nothing.
/obj/effect/map_effect/marker_helper/airlock/interior
	name = "airlock marker (interior/inside/pressurized)"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "airlock_marker_interior"
	layer = LIGHTING_LAYER

/// add the airlock market to `airlock_markers`
/obj/effect/map_effect/marker/airlock/Initialize(mapload, ...)
	..()
	if(master_tag && frequency)
		if(!airlock_markers[master_tag])
			airlock_markers[master_tag] = list()
		airlock_markers[master_tag] += src
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/airlock/LateInitialize()
	..()
	if(master_tag && frequency)
		airlock_marker_init_airlock(master_tag)
		airlock_markers[master_tag] = null // init only once

#define MASTER_TAG		"[master_tag]_controller"
#define AIRPUMP_TAG		"[master_tag]_pump"
#define SENSOR_TAG		"[master_tag]_sensor"
#define EXTERIOR_DOOR_TAG	"[master_tag]_outer"
#define INTERIOR_DOOR_TAG	"[master_tag]_inner"

/// actually set the airlock up
/proc/airlock_marker_init_airlock(var/master_tag)
	// if airlock of this master_tag was already initialized, return
	if(!airlock_markers || !airlock_markers[master_tag] || airlock_markers[master_tag]==null)
		return

	// iterate through every marker of this airlock and set up the component parts
	for(var/obj/effect/map_effect/marker/airlock/marker in airlock_markers[master_tag])
		var/is_interior = locate(/obj/effect/map_effect/marker_helper/airlock/interior) in marker.loc
		var/is_exterior = locate(/obj/effect/map_effect/marker_helper/airlock/exterior) in marker.loc

		var/frequency = marker.frequency
		var/required_access = marker.required_access

		if(frequency==null || master_tag==null)
			return

		for(var/thing in marker.loc)
			var/obj/machinery/embedded_controller/radio/airlock/airlock_controller/airlock_controller = thing
			if(istype(airlock_controller))
				airlock_controller.set_frequency(frequency)
				airlock_controller.id_tag = MASTER_TAG
				airlock_controller.tag_airpump = AIRPUMP_TAG
				airlock_controller.tag_chamber_sensor = SENSOR_TAG
				airlock_controller.tag_exterior_door = EXTERIOR_DOOR_TAG
				airlock_controller.tag_interior_door = INTERIOR_DOOR_TAG
				airlock_controller.program = new /datum/computer/file/embedded_program/airlock(airlock_controller)
				airlock_controller.req_access = required_access

			var/obj/machinery/door/airlock/door = thing
			if(istype(door))
				door.set_frequency(frequency)
				door.req_access = required_access
				door.lock()
				if(is_interior)
					door.id_tag = INTERIOR_DOOR_TAG
				if(is_exterior)
					door.id_tag = EXTERIOR_DOOR_TAG

			var/obj/machinery/airlock_sensor/sensor = thing
			if(istype(sensor))
				sensor.set_frequency(frequency)
				sensor.id_tag = SENSOR_TAG
				sensor.master_tag = MASTER_TAG

			var/obj/machinery/atmospherics/unary/vent_pump/pump = thing
			if(istype(pump))
				pump.frequency = frequency
				unregister_radio(pump, frequency)
				pump.setup_radio()
				pump.id_tag = AIRPUMP_TAG

			var/obj/machinery/access_button/button = thing
			if(istype(button))
				button.set_frequency(frequency)
				button.master_tag = MASTER_TAG
				button.req_access = required_access
				if(is_interior)
					button.command = "cycle_interior"
				if(is_exterior)
					button.command = "cycle_exterior"

#undef MASTER_TAG
#undef AIRPUMP_TAG
#undef SENSOR_TAG
#undef EXTERIOR_DOOR_TAG
#undef INTERIOR_DOOR_TAG

