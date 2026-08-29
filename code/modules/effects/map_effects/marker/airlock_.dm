
/// Airlock marker that, when placed above airlock components, actually sets them up to make it functional.
/// See `maps/helpers/guidelines_airlocks.dmm` for examples of good and bad airlocks.
/// This is the abstract type; see the external, docking, and shuttle subtypes.
ABSTRACT_TYPE(/obj/effect/map_effect/marker/airlock)
	name = "airlock marker"
	desc = "See comments/documentation in code."
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "marker_airlock"

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
