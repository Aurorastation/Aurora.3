
// ------------------------------- carpets

/turf/simulated/floor/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet"
	tile_outline = "carpet"
	broken_overlay = "carpet"
	initial_flooring = /singleton/flooring/carpet
	footstep_sound = /singleton/sound_category/carpet_footstep

/turf/simulated/floor/carpet/cyan
	name = "cyan carpet"
	icon_state = "carpet_cyan"
	initial_flooring = /singleton/flooring/carpet/cyan

/turf/simulated/floor/carpet/cyan/airless
	initial_gas = null

/turf/simulated/floor/carpet/rubber
	name = "rubber carpet"
	icon_state = "rub_carpet"
	initial_flooring = /singleton/flooring/carpet/rubber

/turf/simulated/floor/carpet/art
	icon_state = "artcarpet"
	initial_flooring = /singleton/flooring/carpet/art

/turf/simulated/floor/carpet/brown
	icon_state = "brown"
	initial_flooring = /singleton/flooring/carpet/brown

/turf/simulated/floor/carpet/red
	icon_state = "red"
	initial_flooring = /singleton/flooring/carpet/red

/turf/simulated/floor/carpet/darkblue
	icon_state = "blue1"
	initial_flooring = /singleton/flooring/carpet/darkblue

/turf/simulated/floor/carpet/lightblue
	icon_state = "blue2"
	initial_flooring = /singleton/flooring/carpet/lightblue

/turf/simulated/floor/carpet/aquablue
	icon_state = "blue3"
	initial_flooring = /singleton/flooring/carpet/aquablue

/turf/simulated/floor/carpet/green
	icon_state = "green"
	initial_flooring = /singleton/flooring/carpet/green

/turf/simulated/floor/carpet/magenta
	icon_state = "magenta"
	initial_flooring = /singleton/flooring/carpet/magenta

/turf/simulated/floor/carpet/purple
	icon_state = "purple"
	initial_flooring = /singleton/flooring/carpet/purple

/turf/simulated/floor/carpet/orange
	icon_state = "orange"
	initial_flooring = /singleton/flooring/carpet/orange

// ------------------------------- wood

/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "wood"
	initial_flooring = /singleton/flooring/wood
	footstep_sound = /singleton/sound_category/wood_footstep
	tile_outline = "wood"
	tile_decal_state = "wood"
	broken_overlay = "wood"
	tile_outline_alpha = 75
	color = WOOD_COLOR_GENERIC

/turf/simulated/floor/wood/airless
	initial_gas = null

/turf/simulated/floor/wood/birch
	initial_flooring = /singleton/flooring/wood/birch
	color = WOOD_COLOR_GENERIC

/turf/simulated/floor/wood/mahogany
	initial_flooring = /singleton/flooring/wood/mahogany
	color = WOOD_COLOR_RICH

/turf/simulated/floor/wood/maple
	initial_flooring = /singleton/flooring/wood/maple
	color = WOOD_COLOR_PALE

/turf/simulated/floor/wood/bamboo
	initial_flooring = /singleton/flooring/wood/bamboo
	color = WOOD_COLOR_PALE2

/turf/simulated/floor/wood/ebony
	initial_flooring = /singleton/flooring/wood/ebony
	color = WOOD_COLOR_BLACK

/turf/simulated/floor/wood/walnut
	initial_flooring = /singleton/flooring/wood/walnut
	color = WOOD_COLOR_CHOCOLATE

/turf/simulated/floor/wood/yew
	initial_flooring = /singleton/flooring/wood/yew
	color = WOOD_COLOR_YELLOW

// ------------------------------- marble

/turf/simulated/floor/marble
	name = "marble floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "textured"
	initial_flooring = /singleton/flooring/marble
	color = COLOR_GRAY80

/turf/simulated/floor/marble/dark
	initial_flooring = /singleton/flooring/marble/dark
	color = COLOR_DARK_GRAY
