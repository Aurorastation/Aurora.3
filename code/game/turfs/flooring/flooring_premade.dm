/turf/simulated/floor/plating
	footstep_sound = /singleton/sound_category/plating_footstep

//Carpets
/turf/simulated/floor/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet"
	initial_flooring = /singleton/flooring/carpet
	footstep_sound = /singleton/sound_category/carpet_footstep

/turf/simulated/floor/carpet/blue
	name = "blue carpet"
	icon_state = "bcarpet"
	initial_flooring = /singleton/flooring/carpet/blue

/turf/simulated/floor/carpet/blue/airless
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/carpet/rubber
	name = "rubber carpet"
	icon_state = "rub_carpet"
	initial_flooring = /singleton/flooring/carpet/rubber

/turf/simulated/floor/carpet/art
	icon_state = "artcarpet"
	initial_flooring = /singleton/flooring/carpet/art

/turf/simulated/floor/carpet/fancybrown
	icon_state = "brown"
	initial_flooring = /singleton/flooring/carpet/fancybrown

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

//Grids
/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /singleton/flooring/reinforced/circuit

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /singleton/flooring/reinforced/circuit/green

//Wood Flooring
/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	initial_flooring = /singleton/flooring/wood
	footstep_sound = /singleton/sound_category/wood_footstep
	tile_outline = "wood"
	tile_decal_state = "woodcolour"
	tile_outline_alpha = 75

/turf/simulated/floor/wood/airless
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/wood/coloured
	icon_state = "woodcolour"
	initial_flooring = /singleton/flooring/wood/coloured

/turf/simulated/floor/wood/coloured/birch
	initial_flooring = /singleton/flooring/wood/coloured/birch

/turf/simulated/floor/wood/coloured/mahogany
	initial_flooring = /singleton/flooring/wood/coloured/mahogany

/turf/simulated/floor/wood/coloured/walnut
	initial_flooring = /singleton/flooring/wood/coloured/walnut

/turf/simulated/floor/wood/coloured/bamboo
	initial_flooring = /singleton/flooring/wood/coloured/bamboo

/turf/simulated/floor/wood/coloured/ebony
	initial_flooring = /singleton/flooring/wood/coloured/ebony

/turf/simulated/floor/wood/coloured/walnut
	initial_flooring = /singleton/flooring/wood/coloured/walnut

/turf/simulated/floor/wood/coloured/yew
	initial_flooring = /singleton/flooring/wood/coloured/yew

//Grass
/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /singleton/flooring/grass
	footstep_sound = /singleton/sound_category/grass_footstep

/turf/simulated/floor/diona
	name = "biomass flooring"
	icon = 'icons/turf/flooring/diona.dmi'
	icon_state = "diona0"
	footstep_sound = /singleton/sound_category/grass_footstep
	initial_flooring = /singleton/flooring/diona
	flags = TURF_REMOVE_SHOVEL|TURF_REMOVE_WELDER

/turf/simulated/floor/diona/airless
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

//Tiles
/turf/simulated/floor/tiled
	name = "steel tiles"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "tiled_preview"
	initial_flooring = /singleton/flooring/tiling
	tile_outline = "tiled"
	tile_decal_state = "tiled_light"
	tile_outline_alpha = 125

/turf/simulated/floor/tiled/full
	name = "full steel tile"
	icon_state = "monotile_preview"
	initial_flooring = /singleton/flooring/tiling/mono
	tile_outline = "monotile"
	tile_decal_state = "monotile_light"

/turf/simulated/floor/tiled/full/airless
	name = "airless full steel tile"
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /singleton/flooring/reinforced
	footstep_sound = /singleton/sound_category/plating_footstep
	tile_outline = "reinforced"
	tile_decal_state = "reinforced_light"

/turf/simulated/floor/reinforced/airless
	oxygen = 0
	nitrogen = 0

	roof_type = null

/turf/simulated/floor/reinforced/airmix
	oxygen = MOLES_O2ATMOS
	nitrogen = MOLES_N2ATMOS

/turf/simulated/floor/reinforced/nitrogen
	oxygen = 0
	nitrogen = ATMOSTANK_NITROGEN

// Reinforced Reactor Flooring
/turf/simulated/floor/reinforced/reactor
	name = "reinforced reactor floor"
	oxygen = 0
	nitrogen = MOLES_CELLSTANDARD // One atmosphere of nitrogen.

/turf/simulated/floor/reinforced/oxygen
	oxygen = ATMOSTANK_OXYGEN
	nitrogen = 0

/turf/simulated/floor/reinforced/phoron
	oxygen = 0
	nitrogen = 0
	phoron = ATMOSTANK_PHORON

/turf/simulated/floor/reinforced/phoron/scarce
	phoron = ATMOSTANK_PHORON_SCARCE

/turf/simulated/floor/reinforced/carbon_dioxide
	oxygen = 0
	nitrogen = 0
	carbon_dioxide = ATMOSTANK_CO2

/turf/simulated/floor/reinforced/n20
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/reinforced/n20/Initialize()
	. = ..()
	if(!air)
		make_air()
	air.adjust_gas(GAS_N2O, ATMOSTANK_NITROUSOXIDE)

/turf/simulated/floor/reinforced/hydrogen
	oxygen = 0
	nitrogen = 0
	hydrogen = ATMOSTANK_HYDROGEN

/turf/simulated/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /singleton/flooring/reinforced/cult
	appearance_flags = NO_CLIENT_COLOR

/turf/simulated/floor/cult/cultify()
	return

/turf/simulated/floor/tiled/dark
	name = "plasteel tiles"
	icon_state = "dark"
	initial_flooring = /singleton/flooring/tiling/dark
	tile_decal_state = "dark_light"

/turf/simulated/floor/tiled/dark/airless
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/tiled/dark/full
	name = "full plasteel tile"
	icon_state = "monotile_dark"
	initial_flooring = /singleton/flooring/tiling/dark/full
	tile_outline = "monotile"
	tile_decal_state = "monotile_dark_light"

/turf/simulated/floor/tiled/dark/full/airless
	name = "airless full plasteel tile"
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/tiled/red
	name = "red floor"
	color = COLOR_RED_GRAY
	initial_flooring = /singleton/flooring/tiling/red

/turf/simulated/floor/tiled/rust
	name = "rusted steel floor"
	initial_flooring = /singleton/flooring/tiling/steel

/turf/simulated/floor/tiled/rust/update_icon()
	. = ..()
	var/image/rust = image('icons/turf/flooring/damage.dmi', "rust")
	rust.appearance_flags = RESET_COLOR
	add_overlay(rust)

/turf/simulated/floor/tiled/rust/airless
	oxygen = 0
	nitrogen = 0
	roof_type = null

/turf/simulated/floor/tiled/asteroid
	icon_state = "asteroidfloor"
	initial_flooring = /singleton/flooring/tiling/asteroid

/turf/simulated/floor/tiled/asteroid/airless
	oxygen = 0
	nitrogen = 0
	roof_type = null

/turf/simulated/floor/plating/asteroid
	icon_state = "asteroidplating"

/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "white"
	tile_outline_alpha = 75
	tile_decal_state = "white"
	initial_flooring = /singleton/flooring/tiling/white

/turf/simulated/floor/tiled/yellow
	name = "yellow floor"
	color = COLOR_BROWN
	initial_flooring = /singleton/flooring/tiling/yellow

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	tile_decal_state = "freezer_white"
	initial_flooring = /singleton/flooring/tiling/freezer

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
	icon_state = "lino"
	initial_flooring = /singleton/flooring/linoleum
	tile_outline = "linoleum"

/turf/simulated/floor/lino/grey
	icon_state = "lino_diamond"
	initial_flooring = /singleton/flooring/linoleum/diamond
	tile_outline = "tiled"

//ATMOS PREMADES
/turf/simulated/floor/reinforced/airless
	name = "vacuum floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB
	roof_type = null

/turf/simulated/floor/airless
	name = "airless plating"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB
	footstep_sound = /singleton/sound_category/plating_footstep

	roof_type = null

/turf/simulated/floor/tiled/airless
	name = "airless floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/bluegrid/airless
	name = "airless floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/greengrid/airless
	name = "airless floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/greengrid/nitrogen
	oxygen = 0

/turf/simulated/floor/tiled/white/airless
	name = "airless floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

// Terrain

/turf/simulated/floor/airless/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"

/turf/simulated/floor/ice
	name = "ice"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "ice"

/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "snow0"
	does_footprint = TRUE
	footprint_color = COLOR_SNOW
	track_distance = 4

/turf/simulated/floor/plating/snow
	icon = 'icons/turf/flooring/snow.dmi'
	icon_state = "snowplating"
	footstep_sound = /singleton/sound_category/snow_footstep

/turf/simulated/floor/airless/ceiling
	icon_state = "asteroidplating"
	baseturf = /turf/space

// Material

/turf/simulated/floor/silver
	name = "silver floor"
	icon = 'icons/turf/flooring/material.dmi'
	icon_state = "silver"
	initial_flooring = /singleton/flooring/silver

/turf/simulated/floor/gold
	name = "golden floor"
	icon = 'icons/turf/flooring/material.dmi'
	icon_state = "gold"
	initial_flooring = /singleton/flooring/gold

/turf/simulated/floor/uranium
	name = "uranium floor"
	icon = 'icons/turf/flooring/material.dmi'
	icon_state = "uranium"
	initial_flooring =/singleton/flooring/uranium

/turf/simulated/floor/phoron
	name = "phoron floor"
	icon = 'icons/turf/flooring/material.dmi'
	icon_state = "plasma"
	initial_flooring = /singleton/flooring/phoron

/turf/simulated/floor/diamond
	name = "diamond floor"
	icon = 'icons/turf/flooring/material.dmi'
	icon_state = "diamond"
	initial_flooring = /singleton/flooring/diamond

//chessboard

/turf/simulated/floor/marble
	name = "light marble floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "lightmarble"
	initial_flooring = /singleton/flooring/marble

/turf/simulated/floor/marble/dark
	name = "dark marble floor"
	icon_state = "darkmarble"
	initial_flooring = /singleton/flooring/marble/dark

// other

/turf/simulated/floor/vaurca
	name = "alien floor"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "vaurca"

/turf/simulated/floor/foamedmetal
	name = "foamed metal"
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"

/turf/simulated/floor/foamedmetal/attack_hand(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(ishuman(user))
		ChangeTurf(/turf/space)
		to_chat(user, SPAN_NOTICE("You clear away the metal foam."))
