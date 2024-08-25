/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "tiled_preview"

/turf/unsimulated/floor/elevatorshaft
	name = "elevator machinery"
	icon_state = "elevatorshaft"

/turf/unsimulated/floor/plating
	name = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_state = "plating"

/turf/unsimulated/floor/xmas
	name = "snow"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "snow0"
	footstep_sound = /singleton/sound_category/snow_footstep

/turf/unsimulated/floor/concrete
	name = "concrete"
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_state = "concrete0"

/turf/unsimulated/mask
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"

/turf/unsimulated/mask/ChangeTurf(path, tell_universe = TRUE, force_lighting_update = FALSE, ignore_override = FALSE, mapload = FALSE)
	if(!path)
		return

	new path(src)

/turf/unsimulated/chasm_mask
	name = "chasm mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "alienvault"
	initial_gas = null
	temperature = TCMB

/turf/unsimulated/chasm_mask/New()
	return

// It's a placeholder turf, don't do anything special.
// These shouldn't exist by the time SSatoms runs.
/turf/unsimulated/mask/New()
	return

/turf/unsimulated/mask/Initialize()
	SHOULD_CALL_PARENT(FALSE)

	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1

	return INITIALIZE_HINT_NORMAL

/// Arbitrary marker turf for use in external tooling or whatever.
/// Not intended to be used in game or placed by itself, but to be replaced with something else.
/turf/unsimulated/marker
	name = "Marker Turf, Gray"
	icon = 'icons/turf/areas.dmi'
	icon_state = "white"
	color = "#949494"

/turf/unsimulated/marker/red
	name = "Marker Turf, Red"
	color = "#862a2a"

/turf/unsimulated/marker/green
	name = "Marker Turf, Green"
	color = "#348d2c"

/turf/unsimulated/marker/blue
	name = "Marker Turf, Blue"
	color = "#2f519b"

/turf/unsimulated/floor/shuttle_ceiling
	icon_state = "reinforced"
