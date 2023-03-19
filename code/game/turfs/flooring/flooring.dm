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

	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flags
	var/can_paint
	var/footstep_sound = /singleton/sound_category/tiles_footstep

/singleton/flooring/grass
	name = "synthetic grass"
	desc = "A patch of synthetic grass."
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "grass"
	has_base_range = 3
	damage_temperature = T0C+80
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass
	footstep_sound = /singleton/sound_category/grass_footstep

/singleton/flooring/grass/alt
	name = "grass"
	desc = "A soft patch of grass"
	icon = 'icons/turf/total_floors.dmi'
	icon_base = "grass_alt"
	flags = TURF_ACID_IMMUNE | TURF_REMOVE_SHOVEL
	build_type = /obj/item/stack/tile/grass_alt
	has_base_range = 0

/singleton/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flags = TURF_HAS_EDGES | TURF_REMOVE_SHOVEL
	build_type = null
	footstep_sound = /singleton/sound_category/asteroid_footstep

//Carpet
/singleton/flooring/carpet
	name = "carpet"
	desc = "Imported and comfy."
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_base = "carpet"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flags = TURF_HAS_EDGES | TURF_HAS_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN
	footstep_sound = /singleton/sound_category/carpet_footstep

/singleton/flooring/carpet/blue
	name = "carpet"
	icon_base = "bcarpet"
	build_type = /obj/item/stack/tile/carpet_blue

/singleton/flooring/carpet/rubber
	name = "rubber carpet"
	desc = "Durable, easy to clean and provides extra grip. Perfect for industrial settings."
	icon_base = "rub_carpet"
	build_type = /obj/item/stack/tile/carpet_rubber

/singleton/flooring/carpet/art
	icon_base = "artcarpet"
	build_type = /obj/item/stack/tile/carpet_art

/singleton/flooring/carpet/fancybrown
	icon_base = "brown"
	build_type = /obj/item/stack/tile/carpet_fancybrown

/singleton/flooring/carpet/red
	icon_base = "red"
	build_type = /obj/item/stack/tile/carpet_red

/singleton/flooring/carpet/darkblue
	icon_base = "blue1"
	build_type = /obj/item/stack/tile/carpet_darkblue

/singleton/flooring/carpet/lightblue
	icon_base = "blue2"
	build_type = /obj/item/stack/tile/carpet_lightblue

/singleton/flooring/carpet/aquablue
	icon_base = "blue3"
	build_type = /obj/item/stack/tile/carpet_aquablue

/singleton/flooring/carpet/green
	icon_base = "green"
	build_type = /obj/item/stack/tile/carpet_green

/singleton/flooring/carpet/magenta
	icon_base = "magenta"
	build_type = /obj/item/stack/tile/carpet_magenta

/singleton/flooring/carpet/purple
	icon_base = "purple"
	build_type = /obj/item/stack/tile/carpet_purple

/singleton/flooring/carpet/orange
	icon_base = "orange"
	build_type = /obj/item/stack/tile/carpet_orange

/singleton/flooring/tiling
	name = "steel tiles"
	desc = "A set of steel floor tiles."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "steel"
	has_damage_range = 4
	damage_temperature = T0C+1400
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	footstep_sound = /singleton/sound_category/tiles_footstep

/singleton/flooring/tiling/full
	name = "full steel tile"
	desc = "A full steel floor tile."
	icon_base = "steel_full"
	has_damage_range = FALSE
	build_type = /obj/item/stack/tile/floor/full

/singleton/flooring/tiling/asteroid
	name = "floor"
	icon = 'icons/turf/total_floors.dmi'
	icon_base = "asteroidfloor"
	has_damage_range = null
	build_type = null

/singleton/flooring/tiling/asteroid/plating
	icon_base = "asteroidfloor"

/singleton/flooring/linoleum
	name = "linoleum"
	desc = "It's like the 2390's all over again."
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_base = "lino"
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/lino
	can_paint = 1
	footstep_sound = /singleton/sound_category/carpet_footstep

/singleton/flooring/linoleum/grey
	icon_base = "lino_grey"
	build_type = /obj/item/stack/tile/lino_grey
	has_damage_range = 2

/singleton/flooring/tiling/red
	name = "floor"
	icon_base = "white"
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor_red

/singleton/flooring/tiling/steel
	name = "floor"
	icon = 'icons/turf/total_floors.dmi'
	icon_base = "steel_dirty"
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor_steel

/singleton/flooring/tiling/old
	name = "old floor"
	desc = "An old and scuffed floor tile, harkening back to a bygone era."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "old_steel"
	has_damage_range = 4
	flags = TURF_IS_FRAGILE | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = null

/singleton/flooring/tiling/old_dark
	name = "old dark floor"
	desc = "An old and scuffed floor tile, harkening back to a bygone era."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "old_dark"
	has_damage_range = null
	flags = TURF_IS_FRAGILE
	build_type = null

/singleton/flooring/tiling/old_white
	name = "old sterile floor"
	desc = "An old, scuffed and supposedly once sterile floor tile harkening back to a bygone era."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "old_white"
	has_damage_range = null
	flags = TURF_IS_FRAGILE
	build_type = null

/singleton/flooring/tiling/white
	name = "floor"
	desc = "How sterile."
	icon_base = "white"
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor_white

/singleton/flooring/tiling/yellow
	name = "floor"
	icon_base = "white"
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor_yellow

/singleton/flooring/tiling/dark
	name = "plasteel tiles"
	desc = "A set of plasteel floor tiles."
	icon_base = "dark"
	has_damage_range = FALSE
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor_dark

/singleton/flooring/tiling/dark/full
	name = "full plasteel tile"
	desc = "A full plasteel floor tile."
	icon_base = "dark_full"
	build_type = /obj/item/stack/tile/floor_dark/full

/singleton/flooring/tiling/freezer
	name = "floor"
	desc = "Don't slip."
	icon_base = "freezer"
	has_damage_range = null
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/floor_freezer

//Wood
/singleton/flooring/wood
	name = "wooden floor"
	desc = "Polished redwood planks."
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	flags = TURF_CAN_BREAK | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER | TURF_CAN_BURN
	footstep_sound = /singleton/sound_category/wood_footstep

/singleton/flooring/wood/coloured
	icon_base = "woodcolour"
	desc = "Polished wooden planks."
	build_type = /obj/item/stack/tile/wood/coloured
	var/color

/singleton/flooring/wood/coloured/birch
	color = WOOD_COLOR_BIRCH 
	build_type = /obj/item/stack/tile/wood/coloured/birch

/singleton/flooring/wood/coloured/mahogany
	color = WOOD_COLOR_RICH
	build_type = /obj/item/stack/tile/wood/coloured/mahogany

/singleton/flooring/wood/coloured/maple
	color = WOOD_COLOR_PALE
	build_type = /obj/item/stack/tile/wood/coloured/maple

/singleton/flooring/wood/coloured/bamboo
	color = WOOD_COLOR_PALE2
	build_type = /obj/item/stack/tile/wood/coloured/bamboo

/singleton/flooring/wood/coloured/ebony
	color = WOOD_COLOR_BLACK
	build_type = /obj/item/stack/tile/wood/coloured/ebony

/singleton/flooring/wood/coloured/walnut
	color = WOOD_COLOR_CHOCOLATE
	build_type = /obj/item/stack/tile/wood/coloured/walnut

/singleton/flooring/wood/coloured/yew
	color = WOOD_COLOR_YELLOW
	build_type = /obj/item/stack/tile/wood/coloured/yew

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
	can_paint = 1
	footstep_sound = /singleton/sound_category/plating_footstep

/singleton/flooring/reinforced/circuit
	name = "processing strata"
	desc = "A durable surface covered in various circuity and wiring."
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_base = "bcircuit"
	build_type = null
	build_cost = 1
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_REMOVE_CROWBAR
	can_paint = 1
	build_type = /obj/item/stack/tile/circuit_blue

/singleton/flooring/reinforced/circuit/green
	name = "processing strata"
	icon_base = "gcircuit"
	build_type = /obj/item/stack/tile/circuit_green

/singleton/flooring/reinforced/circuit/red
	icon_base = "rcircuit"
	flags = TURF_ACID_IMMUNE
	can_paint = 0
	build_type = null

/singleton/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_base = "cult"
	build_type = null
	has_damage_range = 6
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = null

/singleton/flooring/reinforced/ramp
	name = "foot ramp"
	desc = "An archaic means of locomotion along the Z axis."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "ramptop"
	build_type = null
	has_damage_range = 2
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK
	can_paint = 1

/singleton/flooring/reinforced/ramp/bottom
	icon_base = "rampbot"

/singleton/flooring/diona
	name = "biomass"
	desc = "A mass of small intertwined aliens forming a floor... Creepy."
	icon = 'icons/turf/floors.dmi'
	icon_base = "diona"
	flags = TURF_ACID_IMMUNE | TURF_REMOVE_SHOVEL | TURF_REMOVE_WELDER
	footstep_sound = /singleton/sound_category/grass_footstep

//material turfs

/singleton/flooring/silver
	name = "silver floor"
	desc = "A fancy floor with silver plating."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "silver"
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/silver

/singleton/flooring/gold
	name = "golden floor"
	desc = "A fancy floor with golden plating."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "gold"
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/gold

/singleton/flooring/uranium
	name = "uranium floor"
	desc = "An unsafe floor with uranium plating."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "uranium"
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/uranium

/singleton/flooring/phoron
	name = "phoron floor"
	desc = "A flammable floor with phoron plating."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "plasma"
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/phoron

/singleton/flooring/diamond
	name = "diamond floor"
	desc = "An expensive floor with diamond plating."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "diamond"
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK
	build_type = /obj/item/stack/tile/diamond

/singleton/flooring/marble
	name = "light marble floor"
	desc = "A robust floor made from marble."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "lightmarble"
	flags = TURF_REMOVE_CROWBAR
	build_type = /obj/item/stack/tile/marble

/singleton/flooring/marble/dark
	name = "dark marble floor"
	icon_base = "darkmarble"
	build_type = /obj/item/stack/tile/marble/dark

//Shuttle turfs

/singleton/flooring/shuttle
	name = "shuttle floor"
	desc = "Typical shuttle flooring."
	icon = 'icons/turf/shuttle.dmi'
	icon_base = "floor"
	flags = TURF_ACID_IMMUNE
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = 1

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
