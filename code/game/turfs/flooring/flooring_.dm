// State values:
// [icon_base]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [icon_base][has_base_range]
// [icon_base]_broken: damaged overlay.
// if has_damage_range is set, append 0-damage_range for state ie.
//   [icon_base]_broken[has_damage_range]
// [icon_base]_edges: directional overlays for edges.
// [icon_base]_corners: directional overlays for non-edge corners.

/singleton/flooring
	var/name
	var/desc
	var/icon
	var/icon_base
	var/color

	var/has_base_range // basically if you want your turf to have variants, e.g. snow and grass. this number sets upper bound, starts at 0.
	var/has_damage_range = 7
	var/has_damage_state // if you've got unique damage sprites, hard-baked, not overlays. if you use overlays use the range system.
	var/has_burn_range = 4
	var/has_burn_state // same as damage state for burn.
	var/damage_uses_color = FALSE // see wood.
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	///The type of floor that can make this, if it's not set (`null`), this flooring is unbuildable
	var/obj/item/stack/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flags
	var/can_paint = FALSE
	var/footstep_sound = /singleton/sound_category/tiles_footstep

	//How we smooth with other flooring
	var/decal_layer = DECAL_LAYER
	var/floor_smooth = SMOOTH_ALL
	var/list/flooring_whitelist = list() //Smooth with nothing except the contents of this list
	var/list/flooring_blacklist = list() //Smooth with everything except the contents of this list

	//How we smooth with walls
	var/wall_smooth = SMOOTH_ALL
	//There are no lists for walls at this time

	//How we smooth with space and openspace tiles
	var/space_smooth = SMOOTH_ALL
	//There are no lists for spaces

/singleton/flooring/proc/on_remove()
	return

/singleton/flooring/grass
	name = "grass"
	desc = "Do they smoke grass out in space, Bowie? Or do they smoke AstroTurf?"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "grass"
	has_base_range = 3
	has_damage_range = 0
	has_damage_state = TRUE
	damage_temperature = T0C+80
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_SHOVEL | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/grass
	footstep_sound = /singleton/sound_category/grass_footstep
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_ALL
	space_smooth = SMOOTH_NONE

/singleton/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null
	footstep_sound = /singleton/sound_category/asteroid_footstep

/singleton/flooring/snow
	name = "snow"
	desc = "Free snowmen, some assembly required."
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "snow"
	has_base_range = 2
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	footstep_sound = /singleton/sound_category/snow_footstep

//Carpet
/singleton/flooring/carpet
	name = "carpet"
	desc = "Imported and comfy."
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_base = "carpet"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	footstep_sound = /singleton/sound_category/carpet_footstep
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE
	has_damage_range = 2

/singleton/flooring/carpet/cyan
	name = "carpet"
	icon_base = "carpet_cyan"
	build_type = /obj/item/stack/tile/carpet/cyan

/singleton/flooring/carpet/rubber
	name = "rubber carpet"
	desc = "Durable, easy to clean and provides extra grip. Perfect for industrial settings."
	icon_base = "rub_carpet"
	build_type = /obj/item/stack/tile/carpet/rubber

/singleton/flooring/carpet/art
	icon_base = "artcarpet"
	build_type = /obj/item/stack/tile/carpet/art

/singleton/flooring/carpet/black
	icon_base = "carpet_black"
	build_type = /obj/item/stack/tile/carpet/black

/singleton/flooring/carpet/brown
	icon_base = "brown"
	build_type = /obj/item/stack/tile/carpet/brown

/singleton/flooring/carpet/red
	icon_base = "red"
	build_type = /obj/item/stack/tile/carpet/red

/singleton/flooring/carpet/darkblue
	icon_base = "blue1"
	build_type = /obj/item/stack/tile/carpet/darkblue

/singleton/flooring/carpet/lightblue
	icon_base = "blue2"
	build_type = /obj/item/stack/tile/carpet/lightblue

/singleton/flooring/carpet/aquablue
	icon_base = "blue3"
	build_type = /obj/item/stack/tile/carpet/aquablue

/singleton/flooring/carpet/green
	icon_base = "green"
	build_type = /obj/item/stack/tile/carpet/green

/singleton/flooring/carpet/magenta
	icon_base = "magenta"
	build_type = /obj/item/stack/tile/carpet/magenta

/singleton/flooring/carpet/purple
	icon_base = "purple"
	build_type = /obj/item/stack/tile/carpet/purple

/singleton/flooring/carpet/orange
	icon_base = "orange"
	build_type = /obj/item/stack/tile/carpet/orange

/singleton/flooring/tiling
	name = "floor"
	desc = "A solid, heavy set of flooring plates."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "tiled"
	color = COLOR_TILED
	damage_temperature = T0C+1400
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = TRUE
	footstep_sound = /singleton/sound_category/tiles_footstep
	has_damage_range = 4
	has_burn_range = 1

/singleton/flooring/tiling/mono
	icon_base = "monotile"
	build_type = /obj/item/stack/tile/mono

/singleton/flooring/tiling/asteroid
	name = "floor"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroidfloor"
	build_type = null

/singleton/flooring/tiling/asteroid/plating
	icon_base = "asteroidfloor"

/singleton/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2390's all over again."
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_base = "lino"
	color = COLOR_LINOLEUM
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/lino
	can_paint = TRUE
	footstep_sound = /singleton/sound_category/carpet_footstep

/singleton/flooring/linoleum/diamond
	icon_base = "lino_diamond"
	build_type = /obj/item/stack/tile/lino/diamond

/singleton/flooring/tiling/red
	name = "floor"
	icon_base = "white"
	build_type = /obj/item/stack/tile/floor_red

/singleton/flooring/tiling/steel
	name = "floor"
	desc = "You wonder how something rusts in an oxygenless enviroment."
	build_type = /obj/item/stack/tile/floor/rust

/singleton/flooring/tiling/white
	desc = "How sterile."
	icon_base = "white"
	color = COLOR_STERILE
	build_type = /obj/item/stack/tile/floor_white

/singleton/flooring/tiling/yellow
	name = "floor"
	icon_base = "tiled_light"
	build_type = /obj/item/stack/tile/floor_yellow

/singleton/flooring/tiling/dark
	desc = "How ominous."
	icon_base = "dark"
	color = COLOR_DARK_GUNMETAL
	build_type = /obj/item/stack/tile/floor_dark

/singleton/flooring/tiling/dark/full
	icon_base = "monotile_dark"
	build_type = /obj/item/stack/tile/floor_dark/full

/singleton/flooring/tiling/light
	icon_base = "tiled"
	color = COLOR_GRAY70
	build_type = null

/singleton/flooring/tiling/light/full
	icon_base = "monotile"

/singleton/flooring/tiling/gunmetal
	icon_base = "tiled"
	color = COLOR_GUNMETAL
	build_type = null

/singleton/flooring/tiling/gunmetal/full
	icon_base = "monotile"

/singleton/flooring/tiling/slate
	icon_base = "tiled"
	color = COLOR_SLATE
	build_type = null

/singleton/flooring/tiling/slate/full
	icon_base = "monotile"

/singleton/flooring/tiling/cargo
	icon_base = "cargo"
	color = COLOR_ALUMINIUM
	build_type = null

/singleton/flooring/tiling/cargo/full
	icon_base = "cargo_monotile"

/singleton/flooring/tiling/cargo/brass
	icon_base = "cargo"
	color = COLOR_BRASS
	build_type = null

/singleton/flooring/tiling/cargo/brass/full
	icon_base = "cargo_monotile"

/singleton/flooring/tiling/bitile
	icon_base = "bitile"
	color = COLOR_TILED
	build_type = null

/singleton/flooring/tiling/gridded
	icon_base = "grid"
	color = COLOR_GRAY40
	build_type = null

/singleton/flooring/tiling/ridged
	icon_base = "ridged"
	color = COLOR_GUNMETAL
	build_type = null

/singleton/flooring/tiling/techmaint
	icon_base = "techmaint"
	color = COLOR_GRAY30
	build_type = null

/singleton/flooring/tiling/techfloor
	icon_base = "techfloor"
	color = COLOR_GRAY40
	build_type = null

/singleton/flooring/tiling/freezer
	name = "floor"
	desc = "Don't slip."
	icon_base = "freezer"
	color = null
	build_type = /obj/item/stack/tile/floor_freezer

//Wood
/singleton/flooring/wood
	name = "wooden floor"
	desc = "Polished wooden planks."
	color = WOOD_COLOR_GENCONTRAST
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "wood"
	has_damage_range = 7
	damage_uses_color = TRUE
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER | TURF_CAN_BURN
	footstep_sound = /singleton/sound_category/wood_footstep
	can_paint = TRUE

/singleton/flooring/wood/birch
	color = WOOD_COLOR_BIRCH
	build_type = /obj/item/stack/tile/wood/birch

/singleton/flooring/wood/mahogany
	color = WOOD_COLOR_RICH
	build_type = /obj/item/stack/tile/wood/mahogany

/singleton/flooring/wood/maple
	color = WOOD_COLOR_PALE
	build_type = /obj/item/stack/tile/wood/maple

/singleton/flooring/wood/bamboo
	color = WOOD_COLOR_PALE2
	build_type = /obj/item/stack/tile/wood/bamboo

/singleton/flooring/wood/ebony
	color = WOOD_COLOR_BLACK
	build_type = /obj/item/stack/tile/wood/ebony

/singleton/flooring/wood/walnut
	color = WOOD_COLOR_CHOCOLATE
	build_type = /obj/item/stack/tile/wood/walnut

/singleton/flooring/wood/yew
	color = WOOD_COLOR_YELLOW
	build_type = /obj/item/stack/tile/wood/yew

/singleton/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel rods."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "reinforced"
	flags = TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE
	build_type = /obj/item/stack/rods
	build_cost = 2
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = TRUE
	footstep_sound = /singleton/sound_category/plating_footstep

/singleton/flooring/reinforced/large
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "reinforced_large"
	build_type = null

/singleton/flooring/reinforced/circuit
	name = "processing strata"
	desc = "A durable surface covered in various circuity and wiring."
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_base = "bcircuit"
	build_cost = 1
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	can_paint = TRUE
	build_type = /obj/item/stack/tile/circuit_blue

/singleton/flooring/reinforced/circuit/green
	name = "processing strata"
	icon_base = "gcircuit"
	build_type = /obj/item/stack/tile/circuit_green

/singleton/flooring/reinforced/circuit/red
	name = "processing strata"
	icon_base = "rcircuit"
	build_type = /obj/item/stack/tile/circuit_red

/singleton/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_base = "cult"
	build_type = null
	has_damage_range = 6
	has_damage_state = TRUE
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = FALSE

/singleton/flooring/reinforced/ramp
	name = "foot ramp"
	desc = "An archaic means of locomotion along the Z axis."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "ramptop"
	build_type = null
	has_damage_state = TRUE
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = TRUE

/singleton/flooring/reinforced/ramp/bottom
	icon_base = "rampbot"

/singleton/flooring/diona
	name = "biomass"
	desc = "A mass of small intertwined aliens forming a floor... Creepy."
	icon = 'icons/turf/flooring/diona.dmi'
	icon_base = "diona"
	has_base_range = 4
	flags = TURF_ACID_IMMUNE | TURF_REMOVE_SHOVEL | TURF_REMOVE_WELDER
	footstep_sound = /singleton/sound_category/grass_footstep

//material turfs

/singleton/flooring/silver
	name = "silver floor"
	desc = "A fancy floor with silver plating."
	icon = 'icons/turf/flooring/material.dmi'
	icon_base = "silver"
	has_base_range = 0
	has_damage_state = TRUE
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/silver

/singleton/flooring/gold
	name = "golden floor"
	desc = "A fancy floor with golden plating."
	icon = 'icons/turf/flooring/material.dmi'
	icon_base = "gold"
	has_base_range = 0
	has_damage_state = TRUE
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/gold

/singleton/flooring/uranium
	name = "uranium floor"
	desc = "An unsafe floor with uranium plating."
	icon = 'icons/turf/flooring/material.dmi'
	icon_base = "uranium"
	has_base_range = 0
	has_damage_state = TRUE
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/uranium

/singleton/flooring/phoron
	name = "phoron floor"
	desc = "A flammable floor with phoron plating."
	icon = 'icons/turf/flooring/material.dmi'
	icon_base = "plasma"
	has_base_range = 0
	has_damage_state = TRUE
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/phoron

/singleton/flooring/diamond
	name = "diamond floor"
	desc = "An expensive floor with diamond plating."
	icon = 'icons/turf/flooring/material.dmi'
	icon_base = "diamond"
	has_base_range = 0
	has_damage_state = TRUE
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/diamond

/singleton/flooring/marble
	name = "marble floor"
	desc = "A robust floor made from marble."
	color = COLOR_GRAY80
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "textured"
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/marble

/singleton/flooring/marble/dark
	color = COLOR_DARK_GRAY
	build_type = /obj/item/stack/tile/marble/dark

/singleton/flooring/concrete
	name = "concrete"
	desc = "Stone-like artificial material. Brutalist and utilitarian."
	icon = 'icons/turf/flooring/concrete.dmi'
	icon_base = "concrete"
	has_base_range = 2

/singleton/flooring/concrete/square
	has_base_range = 0

//Shuttle turfs

/singleton/flooring/shuttle
	name = "shuttle floor"
	desc = "Typical shuttle flooring."
	icon = 'icons/turf/shuttle.dmi'
	icon_base = "floor"
	flags = TURF_ACID_IMMUNE
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = TRUE

/singleton/flooring/shuttle/yellow
	icon_base = "floor2"

/singleton/flooring/shuttle/white
	icon_base = "floor3"

/singleton/flooring/shuttle/red
	icon_base = "floor4"

/singleton/flooring/shuttle/dark_red
	icon_base = "floor6"

/singleton/flooring/shuttle/black
	icon_base = "floor7"

/singleton/flooring/shuttle/tan
	icon_base = "floor8"

/singleton/flooring/shuttle/dark_blue
	icon_base = "floor9"

/singleton/flooring/shuttle/advanced
	icon_base = "advanced_plating"

/singleton/flooring/shuttle/advanced/alt
	icon_base = "advanced_plating_alt"

/singleton/flooring/shuttle/skrell
	desc = "Typical flooring of skrell vessels, soft and springy to the touch."
	icon_base = "skrell_purple"

/singleton/flooring/shuttle/skrell/blue
	icon_base = "skrell_blue"

/singleton/flooring/shuttle/skrell/ramp
	name = "footramp"
	icon_base = "skrellramp-bottom"

/singleton/flooring/shuttle/skrell/ramp/top
	icon_base = "skrellramp-top"
