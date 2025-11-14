/turf/simulated/floor/exoplanet/tiled
	name = "steel tiles"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "tiled_preview"
	initial_flooring = /singleton/flooring/tiling
	tile_outline = "tiled"
	tile_decal_state = "tiled_light"
	tile_outline_alpha = 125
	broken_overlay = "tiled"
	burned_overlay = "tiled"
	has_resources = FALSE

/turf/simulated/floor/exoplanet/tiled/dark
	name = "plasteel tiles"
	icon_state = "dark_preview"
	initial_flooring = /singleton/flooring/tiling/dark
	tile_decal_state = "dark_light"

/turf/simulated/floor/exoplanet/tiled/dark/full
	name = "full plasteel tile"
	icon_state = "monotile_dark_preview"
	initial_flooring = /singleton/flooring/tiling/dark/full
	tile_outline = "monotile"
	tile_decal_state = "monotile_dark_light"
	broken_overlay = null
	burned_overlay = null

/turf/simulated/floor/exoplanet/tiled/full
	name = "full steel tile"
	icon_state = "monotile_preview"
	initial_flooring = /singleton/flooring/tiling/mono
	tile_outline = "monotile"
	tile_decal_state = "monotile_light"
	broken_overlay = null
	burned_overlay = null

/turf/simulated/floor/exoplanet/tiled/white
	name = "white floor"
	icon_state = "white_preview"
	tile_outline_alpha = 75
	tile_decal_state = "white"
	initial_flooring = /singleton/flooring/tiling/white
	broken_overlay = null
	burned_overlay = null

/turf/simulated/floor/exoplanet/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	tile_decal_state = "freezer_white"
	initial_flooring = /singleton/flooring/tiling/freezer
	color = null

/turf/simulated/floor/exoplanet/silver
	name = "silver floor"
	icon = 'icons/turf/flooring/material.dmi'
	icon_state = "silver"
	initial_flooring = /singleton/flooring/silver
	has_resources = FALSE

/turf/simulated/floor/exoplanet/gold
	name = "golden floor"
	icon = 'icons/turf/flooring/material.dmi'
	icon_state = "gold"
	initial_flooring = /singleton/flooring/gold
	has_resources = FALSE
