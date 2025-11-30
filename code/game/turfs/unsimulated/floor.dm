/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "tiled_preview"

/turf/unsimulated/floor/monotile
	icon_state = "monotile_preview"

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

/turf/unsimulated/floor/carpet
	name = "carpet"
	icon_state = "carpet"

/turf/unsimulated/floor/rubber_carpet
	name = "rubber carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "rub_carpet"

/turf/unsimulated/floor/dark
	color = "#4c535b"
	icon_state = "dark"

/turf/unsimulated/floor/dark_monotile
	color = "#4c535b"
	icon_state = "monotile_dark"

/turf/unsimulated/floor/linoleum
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino_diamond_preview"

/turf/unsimulated/floor/grass
	name = "grass"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"

/turf/unsimulated/floor/wood
	name = "wooden floor"
	color = "#8f5847"
	icon_state = "wood"

/turf/unsimulated/floor/freezer
	icon_state = "freezer"

/turf/unsimulated/floor/marble
	icon_state = "textured"

/turf/unsimulated/floor/stairs
	icon_state = "ramptop"

/turf/unsimulated/floor/blue_circuit
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"

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

/turf/unsimulated/marker/yellow
	name = "Marker Turf, Yellow"
	color = "#ffda0b"

/turf/unsimulated/marker/purple
	name = "Marker Turf, Purple"
	color = "#7e34f7"

/turf/unsimulated/marker/teal
	name = "Marker Turf, Teal"
	color = "#008080"

/turf/unsimulated/marker/khaki
	name = "Marker Turf, Khaki"
	color = "#b8a771"

/turf/unsimulated/marker/gray
	name = "Marker Turf, Gray"
	color = "#4e4e4e"

/turf/unsimulated/marker/black
	name = "Marker Turf, Black"
	color = "#181818"

/turf/unsimulated/floor/shuttle_ceiling
	icon_state = "reinforced"
