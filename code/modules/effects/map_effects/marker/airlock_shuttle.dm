
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
	/// --
	/// For docking airlocks, the frequency of docking port airlock and the shuttle airlock needs to match,
	/// otherwise they can't "talk", and the docking will never actually happen (meaning the automatic opening/closing of doors).
	/// Keep 1380 as default frequency, to maximize compatibility between various shuttles and docks.
	frequency = 1380

	/// Unique tag for this airlock. Not visible in game and to the player. Do not leave this as null.
	/// THIS MUST BE UNIQUE FOR THE AIRLOCK. Every marker in one airlock should have the same `master_tag`.
	/// Different airlocks, even on different maps, cannot share the same `master_tag`.
	/// --
	/// This must be the same as the `docking_controller` tag in the shuttle landmark.
	/// So that the landmark is aware of this dock.
	master_tag = null

	///
	// var/shuttle_tag = null
