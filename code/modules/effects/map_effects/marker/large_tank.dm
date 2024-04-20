
/// Large tank marker, used to set up "large tanks", that being multi-tile tanks of gas,
/// with its own control console, sensor, pump, and injector.
/obj/effect/map_effect/marker/large_tank
	name = "large tank marker"
	desc = "See comments/documentation in code."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_large_tank"
	layer = LIGHTING_LAYER

	/// Radio frequency of this large tank.
	var/frequency = 2199

	/// Unique tag for this large tank. Not visible in game and to the player. Do not leave this as null.
	/// THIS MUST BE UNIQUE FOR THE LARGE TANK. Every marker in one large tank should have the same `master_tag`.
	/// Different large tanks, even on different maps, cannot share the same `master_tag`.
	var/master_tag = null

/obj/effect/map_effect/marker/large_tank/Initialize(mapload, ...)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/marker/large_tank/LateInitialize()
	if(!master_tag || !frequency)
		return

	// iterate over components under this marker
	// and actually set them up
	for(var/thing in loc)
		// set up the control console
		var/obj/machinery/computer/general_air_control/large_tank_control/control = thing
		if(istype(control))
			control.set_frequency(frequency)
			control.input_tag = MARKER_LARGE_TANK_TAG_INJECTOR
			control.output_tag = MARKER_LARGE_TANK_TAG_PUMP
			control.sensors = list(MARKER_LARGE_TANK_TAG_SENSOR="Tank")
			continue

		// and all the other components

		var/obj/machinery/air_sensor/sensor = thing
		if(istype(sensor))
			sensor.set_frequency(frequency)
			sensor.id_tag = MARKER_LARGE_TANK_TAG_SENSOR
			continue

		var/obj/machinery/atmospherics/unary/outlet_injector/injector = thing
		if(istype(injector))
			injector.set_frequency(frequency)
			injector.id = MARKER_LARGE_TANK_TAG_INJECTOR
			continue

		var/obj/machinery/atmospherics/unary/vent_pump/pump = thing
		if(istype(pump))
			pump.frequency = frequency
			pump.id_tag = MARKER_LARGE_TANK_TAG_PUMP
			pump.setup_radio()
			continue
