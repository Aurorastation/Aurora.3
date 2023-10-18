
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

// /obj/machinery/door/airlock
// /obj/machinery/access_button
// /obj/machinery/embedded_controller/radio/airlock/docking_port
// /obj/machinery/airlock_sensor
// /obj/machinery/atmospherics/unary/vent_pump

/obj/effect/map_effect/airlock_marker/LateInitialize()
	..()
	airlock_marker_init_airlock(id_tag)
	airlock_markers[id_tag] = null

/// actually set the airlock up
/proc/airlock_marker_init_airlock(var/id_tag)
	// if airlock of this id_tag was already initialized, return
	if(!airlock_markers || !airlock_markers[id_tag] || airlock_markers[id_tag]==null)
		return

	// iterate through every marker of this airlock
	for(var/marker in airlock_markers[id_tag])
		var/is_interior = istype(marker, /obj/effect/map_effect/airlock_marker/interior)
		var/is_exterior = istype(marker, /obj/effect/map_effect/airlock_marker/exterior)



