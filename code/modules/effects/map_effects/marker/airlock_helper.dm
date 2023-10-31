/obj/effect/map_effect/marker_helper
	name = "map marker helper parent abstract object"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_base"

/// Specialization helper for the airlock marker. By itself does nothing.
/// To be put above "exterior" components of the airlock, and on top of the actual airlock marker.
/// - access button
/// - air sensor
/// - door - makes the door to be the exterior door of the airlock (opens when cycling to outside)
/// - pump ()
/// - chamber air pump ???
/obj/effect/map_effect/marker_helper/airlock/exterior
	name = "airlock marker helper (exterior/outside/vacuum)"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_helper_airlock_exterior"
	layer = LIGHTING_LAYER

/// Specialization helper for the airlock marker, to be put above "interior" parts of the airlock,
/// and on top of the actual airlock marker. By itself does nothing.
/obj/effect/map_effect/marker_helper/airlock/interior
	name = "airlock marker helper (interior/inside/pressurized)"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_helper_airlock_interior"
	layer = LIGHTING_LAYER

/// Specialization helper for the airlock marker, to be put above the out pump of the airlock,
/// and on top of the actual airlock marker. By itself does nothing.
/obj/effect/map_effect/marker_helper/airlock/out
	name = "airlock marker helper (chamber, out pump)"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_helper_airlock_out"
	layer = LIGHTING_LAYER
