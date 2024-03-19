/turf/simulated/floor/plating
	footstep_sound = /singleton/sound_category/plating_footstep

// ------------------------------- grids

/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /singleton/flooring/reinforced/circuit

/turf/simulated/floor/bluegrid/cooled
	name = "cooled mainframe floor"
	temperature = 278

/turf/simulated/floor/bluegrid/server
	name = "cooled mainframe floor"
	temperature = 80
	initial_gas = list("nitrogen" = MOLES_CELLSTANDARD) //one atmosphere of nitrogen

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /singleton/flooring/reinforced/circuit/green

/turf/simulated/floor/redgrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "rcircuit"
	initial_flooring = /singleton/flooring/reinforced/circuit/red

/turf/simulated/floor/bluegrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/greengrid/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/greengrid/nitrogen
	initial_gas = list("nitrogen" = MOLES_N2STANDARD)

// ------------------------------- tiled

/turf/simulated/floor/tiled
	name = "steel tiles"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "tiled"
	initial_flooring = /singleton/flooring/tiling
	tile_outline = "tiled"
	tile_decal_state = "tiled_light"
	tile_outline_alpha = 125
	broken_overlay = "tiled"
	burned_overlay = "tiled"
	color = COLOR_TILED

/turf/simulated/floor/tiled/cooled
	name = "cooled steel tiles"
	temperature = 278

/turf/simulated/floor/tiled/full
	name = "full steel tile"
	icon_state = "monotile"
	initial_flooring = /singleton/flooring/tiling/mono
	tile_outline = "monotile"
	tile_decal_state = "monotile_light"
	broken_overlay = null
	burned_overlay = null

/turf/simulated/floor/tiled/full/airless
	name = "airless full steel tile"
	initial_gas = null

/turf/simulated/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /singleton/flooring/reinforced/cult
	appearance_flags = NO_CLIENT_COLOR

/turf/simulated/floor/cult/cultify()
	return

/turf/simulated/floor/tiled/red
	name = "red floor"
	color = COLOR_RED_GRAY
	initial_flooring = /singleton/flooring/tiling/red

/turf/simulated/floor/tiled/rust
	name = "rusted steel floor"
	initial_flooring = /singleton/flooring/tiling/steel

/turf/simulated/floor/tiled/steel/airless
	initial_gas = null

/turf/simulated/floor/tiled/rust/update_icon()
	. = ..()
	var/image/rust = image('icons/turf/decals/damage.dmi', "rust")
	rust.appearance_flags = RESET_COLOR
	add_overlay(rust)

/turf/simulated/floor/tiled/rust/airless
	initial_gas = null
	roof_type = null

/turf/simulated/floor/tiled/asteroid
	icon_state = "asteroidfloor"
	initial_flooring = /singleton/flooring/tiling/asteroid
	broken_overlay = null
	burned_overlay = null

/turf/simulated/floor/tiled/asteroid/airless
	initial_gas = null
	roof_type = null

/turf/simulated/floor/plating/cooled
	name = "cooled plating"
	temperature = 278

/turf/simulated/floor/plating/asteroid
	icon_state = "asteroidplating"

/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "white"
	tile_outline_alpha = 75
	tile_decal_state = "white"
	initial_flooring = /singleton/flooring/tiling/white
	broken_overlay = null
	burned_overlay = null
	color = COLOR_STERILE

/turf/simulated/floor/tiled/yellow
	name = "yellow floor"
	color = COLOR_BROWN
	initial_flooring = /singleton/flooring/tiling/yellow

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	tile_decal_state = "freezer_white"
	initial_flooring = /singleton/flooring/tiling/freezer
	color = null

/turf/simulated/floor/tiled/ramp
	name = "foot ramp"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "ramptop"
	initial_flooring = /singleton/flooring/reinforced/ramp

/turf/simulated/floor/tiled/ramp/bottom
	name = "foot ramp"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "rampbot"
	initial_flooring = /singleton/flooring/reinforced/ramp/bottom

/turf/simulated/floor/lino
	name = "linoleum"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino_preview"
	initial_flooring = /singleton/flooring/linoleum
	tile_outline = "linoleum"

/turf/simulated/floor/lino/diamond
	icon_state = "lino_diamond_preview"
	initial_flooring = /singleton/flooring/linoleum/diamond
	tile_outline = "tiled"
	broken_overlay = "tiled"
	burned_overlay = "tiled"

//ATMOS PREMADES

/turf/simulated/floor/airless
	name = "airless plating"
	initial_gas = null
	temperature = TCMB
	footstep_sound = /singleton/sound_category/plating_footstep
	roof_type = null

/turf/simulated/floor/tiled/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/tiled/white/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

/turf/simulated/floor/airless/ceiling
	icon_state = "asteroidplating"
	baseturf = /turf/space

// ------------------------------- tiled/dark

/turf/simulated/floor/tiled/dark
	name = "plasteel tiles"
	icon_state = "dark"
	initial_flooring = /singleton/flooring/tiling/dark
	tile_decal_state = "dark_light"
	color = COLOR_DARK_GUNMETAL

/turf/simulated/floor/tiled/dark/cooled
	name = "cooled plasteel tiles"
	temperature = 278

/turf/simulated/floor/tiled/dark/airless
	initial_gas = null

/turf/simulated/floor/tiled/dark/full
	name = "full plasteel tile"
	icon_state = "monotile_dark"
	initial_flooring = /singleton/flooring/tiling/dark/full
	tile_outline = "monotile"
	tile_decal_state = "monotile_dark_light"
	broken_overlay = null
	burned_overlay = null

/turf/simulated/floor/tiled/dark/full/airless
	name = "airless full plasteel tile"
	initial_gas = null

// ------------------------------- tiled/light

/turf/simulated/floor/tiled/light
	name = "tiles"
	icon_state = "tiled"
	initial_flooring = /singleton/flooring/tiling/light
	tile_decal_state = "tiled_light"
	color = COLOR_GRAY70

/turf/simulated/floor/tiled/light/full
	name = "full tile"
	icon_state = "monotile"
	initial_flooring = /singleton/flooring/tiling/light/full
	tile_outline = "monotile"
	tile_decal_state = "monotile_light"
	broken_overlay = null
	burned_overlay = null

// ------------------------------- tiled/gunmetal

/turf/simulated/floor/tiled/gunmetal
	name = "tiles"
	icon_state = "tiled"
	initial_flooring = /singleton/flooring/tiling/gunmetal
	tile_decal_state = "tiled_light"
	color = COLOR_GUNMETAL

/turf/simulated/floor/tiled/gunmetal/full
	name = "full tile"
	icon_state = "monotile"
	initial_flooring = /singleton/flooring/tiling/gunmetal/full
	tile_outline = "monotile"
	tile_decal_state = "monotile_light"
	broken_overlay = null
	burned_overlay = null

// ------------------------------- tiled/slate

/turf/simulated/floor/tiled/slate
	name = "tiles"
	icon_state = "tiled"
	initial_flooring = /singleton/flooring/tiling/slate
	tile_decal_state = "tiled_light"
	color = COLOR_SLATE

/turf/simulated/floor/tiled/slate/full
	name = "full tile"
	icon_state = "monotile"
	initial_flooring = /singleton/flooring/tiling/slate/full
	tile_outline = "monotile"
	tile_decal_state = "monotile_light"
	broken_overlay = null
	burned_overlay = null

// ------------------------------- cargo

/turf/simulated/floor/tiled/cargo
	name = "cargo tiles"
	icon_state = "cargo"
	initial_flooring = /singleton/flooring/tiling/cargo
	tile_decal_state = "tiled_light"
	color = COLOR_ALUMINIUM

/turf/simulated/floor/tiled/cargo/full
	name = "cargo tile"
	icon_state = "cargo_monotile"
	initial_flooring = /singleton/flooring/tiling/cargo/full
	tile_decal_state = "monotile_light"

// ------------------------------- cargo/brass

/turf/simulated/floor/tiled/cargo/brass
	name = "cargo tiles"
	icon_state = "cargo"
	initial_flooring = /singleton/flooring/tiling/cargo/brass
	tile_decal_state = "tiled_light"
	color = COLOR_BRASS

/turf/simulated/floor/tiled/cargo/brass/full
	name = "cargo tile"
	icon_state = "cargo_monotile"
	initial_flooring = /singleton/flooring/tiling/cargo/brass/full
	tile_decal_state = "monotile_light"

// ------------------------------- bitile

/turf/simulated/floor/tiled/bitile
	name = "bitile"
	icon_state = "bitile"
	initial_flooring = /singleton/flooring/tiling/bitile
	tile_decal_state = "bitile_light"
	color = COLOR_TILED

// ------------------------------- gridded/ridged

/turf/simulated/floor/tiled/gridded
	name = "gridded tiles"
	icon_state = "grid"
	initial_flooring = /singleton/flooring/tiling/gridded
	tile_decal_state = "grid_light"
	color = COLOR_GRAY40

/turf/simulated/floor/tiled/ridged
	name = "ridged tiles"
	icon_state = "ridged"
	initial_flooring = /singleton/flooring/tiling/ridged
	tile_decal_state = "ridged_light"
	color = COLOR_GUNMETAL

// ------------------------------- tech

/turf/simulated/floor/tiled/techmaint
	name = "techmaint tiles"
	icon_state = "techmaint"
	initial_flooring = /singleton/flooring/tiling/techmaint
	tile_decal_state = "techmaint_light"
	color = COLOR_GRAY30

/turf/simulated/floor/tiled/techfloor
	name = "techfloor tiles"
	icon_state = "techfloor"
	initial_flooring = /singleton/flooring/tiling/techfloor
	tile_decal_state = "techfloor_light"
	color = COLOR_GRAY40

// -------------------------------
