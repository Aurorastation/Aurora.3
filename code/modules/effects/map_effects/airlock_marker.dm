
/// map of airlock marker `id_tag` to a list of map_effect/airlock_markers
var/global/list/airlock_markers = list()

///
/obj/effect/map_effect/airlock_marker
	name = "airlock marker (inside the airlock)"
	desc = "..."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "airlock_marker"
	layer = LIGHTING_LAYER
	///
	var/frequency = null
	///
	var/id_tag = null

///
/obj/effect/map_effect/airlock_marker/exterior
	name = "airlock marker (exterior/outside/vacuum)"
	icon_state = "airlock_marker_exterior"

///
/obj/effect/map_effect/airlock_marker/interior
	name = "airlock marker (interior/inside/pressurized)"
	icon_state = "airlock_marker_interior"

/// add the airlock market to `airlock_markers`
/obj/effect/map_effect/airlock_marker/Initialize(mapload, ...)
	..()
	if(!airlock_markers[id_tag])
		airlock_markers[id_tag] = list()
	airlock_markers[id_tag] += src
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/airlock_marker/LateInitialize()
	..()
	airlock_marker_init_airlock(id_tag, frequency)
	airlock_markers[id_tag] = null

#define MASTER_TAG		"[id_tag]_controller"
#define AIRPUMP_TAG		"[id_tag]_pump"
#define SENSOR_TAG		"[id_tag]_sensor"
#define EXTERIOR_DOOR_TAG	"[id_tag]_outer"
#define INTERIOR_DOOR_TAG	"[id_tag]_inner"

/// actually set the airlock up
/proc/airlock_marker_init_airlock(var/id_tag, var/frequency)
	// if airlock of this id_tag was already initialized, return
	if(!airlock_markers || !airlock_markers[id_tag] || airlock_markers[id_tag]==null)
		return

	// component parts of this airlock
	// var/list/obj/machinery/door/airlock/doors_interior = list()
	// var/list/obj/machinery/door/airlock/doors_exterior = list()
	// var/list/obj/machinery/access_button/button_interior = list()
	// var/list/obj/machinery/access_button/button_exterior = list()
	// var/list/obj/machinery/embedded_controller/radio/airlock/airlock_controller/airlock_controller = list()
	// var/list/obj/machinery/airlock_sensor/sensor = list()
	// var/list/obj/machinery/atmospherics/unary/vent_pump/pump = list()

	// iterate through every marker of this airlock and gather the component parts
	for(var/obj/effect/map_effect/airlock_marker/marker in airlock_markers[id_tag])
		var/is_interior = istype(marker, /obj/effect/map_effect/airlock_marker/interior)
		var/is_exterior = istype(marker, /obj/effect/map_effect/airlock_marker/exterior)

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

			var/obj/machinery/door/airlock/door = thing
			if(istype(door) && is_interior)
				door.set_frequency(frequency)
				door.id_tag = INTERIOR_DOOR_TAG
			if(istype(door) && is_exterior)
				door.set_frequency(frequency)
				door.id_tag = EXTERIOR_DOOR_TAG

			var/obj/machinery/airlock_sensor/sensor = thing
			if(istype(sensor))
				sensor.set_frequency(frequency)
				sensor.id_tag = SENSOR_TAG
				sensor.master_tag = MASTER_TAG

			var/obj/machinery/atmospherics/unary/vent_pump/pump = thing
			if(istype(pump))
				//pump.set_frequency(frequency)
				// created_pump.frequency = radio_frequency
				// unregister_radio(created_pump, radio_frequency)
				// created_pump.setup_radio()
				pump.frequency = frequency
				unregister_radio(pump, frequency)
				pump.setup_radio()
				pump.id_tag = AIRPUMP_TAG

			var/obj/machinery/access_button/button = thing
			if(istype(button) && is_interior)
				button.set_frequency(frequency)
				button.master_tag = MASTER_TAG
				button.command = "cycle_interior"
			if(istype(button) && is_exterior)
				button.set_frequency(frequency)
				button.master_tag = MASTER_TAG
				button.command = "cycle_exterior"

#undef MASTER_TAG
#undef AIRPUMP_TAG
#undef SENSOR_TAG
#undef EXTERIOR_DOOR_TAG
#undef INTERIOR_DOOR_TAG

