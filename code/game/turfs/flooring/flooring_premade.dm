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
	initial_gas = null

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

//Wood Flooring
/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	initial_flooring = /singleton/flooring/wood
	footstep_sound = /singleton/sound_category/wood_footstep

/turf/simulated/floor/wood/airless
	initial_gas = null

/turf/simulated/floor/wood/coloured
	icon_state = "woodcolour"
	initial_flooring = /singleton/flooring/wood/coloured

/turf/simulated/floor/wood/coloured/birch
	color = WOOD_COLOR_BIRCH

/turf/simulated/floor/wood/coloured/mahogany
	color = WOOD_COLOR_RICH

/turf/simulated/floor/wood/coloured/walnut
	color = WOOD_COLOR_PALE

/turf/simulated/floor/wood/coloured/bamboo
	color = WOOD_COLOR_PALE2

/turf/simulated/floor/wood/coloured/ebony
	color = WOOD_COLOR_BLACK

/turf/simulated/floor/wood/coloured/walnut
	color = WOOD_COLOR_CHOCOLATE

/turf/simulated/floor/wood/coloured/yew
	color = WOOD_COLOR_YELLOW

//Grass
/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /singleton/flooring/grass
	footstep_sound = /singleton/sound_category/grass_footstep

/turf/simulated/floor/grass/alt
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "grass_alt"
	initial_flooring = /singleton/flooring/grass/alt

//Tiles
/turf/simulated/floor/tiled
	name = "steel tiles"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = /singleton/flooring/tiling

/turf/simulated/floor/tiled/cooled
	name = "cooled steel tiles"
	temperature = 278

/turf/simulated/floor/tiled/full
	name = "full steel tile"
	icon_state = "steel_full"
	initial_flooring = /singleton/flooring/tiling/full

/turf/simulated/floor/tiled/full/airless
	name = "airless full steel tile"
	initial_gas = null

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /singleton/flooring/reinforced
	footstep_sound = /singleton/sound_category/plating_footstep

/turf/simulated/floor/reinforced/cooled
	name = "cooled reinforced floor"
	temperature = 278

/turf/simulated/floor/reinforced/airless
	initial_gas = null

	roof_type = null

/turf/simulated/floor/reinforced/airmix
	initial_gas = list("oxygen" = MOLES_O2ATMOS, "nitrogen" = MOLES_N2ATMOS)

/turf/simulated/floor/reinforced/nitrogen
	initial_gas = list("nitrogen" = ATMOSTANK_NITROGEN)

// Reinforced Reactor Flooring
/turf/simulated/floor/reinforced/reactor
	name = "reinforced reactor floor"
	initial_gas = list("nitrogen" = MOLES_CELLSTANDARD) // One atmosphere of nitrogen.

/turf/simulated/floor/reinforced/oxygen
	initial_gas = list("oxygen" = ATMOSTANK_OXYGEN)

/turf/simulated/floor/reinforced/phoron
	initial_gas = list("phoron" = ATMOSTANK_PHORON)

/turf/simulated/floor/reinforced/phoron/scarce
	initial_gas = list("phoron" = ATMOSTANK_PHORON_SCARCE)

/turf/simulated/floor/reinforced/carbon_dioxide
	initial_gas = list("carbon_dioxide" = ATMOSTANK_CO2)

/turf/simulated/floor/reinforced/n20
	initial_gas = list("sleeping_agent" = ATMOSTANK_NITROUSOXIDE)

/turf/simulated/floor/reinforced/hydrogen
	initial_gas = list("hydrogen" = ATMOSTANK_HYDROGEN)

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

/turf/simulated/floor/tiled/dark/cooled
	name = "cooled plasteel tiles"
	temperature = 278

/turf/simulated/floor/tiled/dark/airless
	initial_gas = null

/turf/simulated/floor/tiled/dark/full
	name = "full plasteel tile"
	icon_state = "dark_full"
	initial_flooring = /singleton/flooring/tiling/dark/full

/turf/simulated/floor/tiled/dark/full/airless
	name = "airless full plasteel tile"
	initial_gas = null

/turf/simulated/floor/tiled/red
	name = "red floor"
	color = COLOR_RED_GRAY
	icon_state = "white"
	initial_flooring = /singleton/flooring/tiling/red

/turf/simulated/floor/tiled/steel
	name = "steel floor"
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "steel_dirty"
	initial_flooring = /singleton/flooring/tiling/steel

/turf/simulated/floor/tiled/steel/airless
	initial_gas = null
	roof_type = null

/turf/simulated/floor/tiled/old
	name = "old floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "old_steel"
	initial_flooring = /singleton/flooring/tiling/old

/turf/simulated/floor/tiled/old_dark
	name = "old dark floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "old_dark"
	initial_flooring = /singleton/flooring/tiling/old_dark

/turf/simulated/floor/tiled/old_white
	name = "old sterile floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "old_white"
	initial_flooring = /singleton/flooring/tiling/old_white

/turf/simulated/floor/tiled/asteroid
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "asteroidfloor"
	initial_flooring = /singleton/flooring/tiling/asteroid

/turf/simulated/floor/tiled/asteroid/airless
	initial_gas = null
	roof_type = null

/turf/simulated/floor/plating/cooled
	name = "cooled plating"
	temperature = 278

/turf/simulated/floor/plating/asteroid
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "asteroidplating"

/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "white"
	initial_flooring = /singleton/flooring/tiling/white

/turf/simulated/floor/tiled/yellow
	name = "yellow floor"
	color = COLOR_BROWN
	icon_state = "white"
	initial_flooring = /singleton/flooring/tiling/yellow

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
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
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /singleton/flooring/linoleum

/turf/simulated/floor/lino/grey
	icon_state = "lino_grey"
	initial_flooring = /singleton/flooring/linoleum/grey

//ATMOS PREMADES
/turf/simulated/floor/reinforced/airless
	name = "vacuum floor"
	initial_gas = null
	temperature = TCMB
	roof_type = null

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

/turf/simulated/floor/tiled/white/airless
	name = "airless floor"
	initial_gas = null
	temperature = TCMB

// Placeholders

/turf/simulated/floor/airless/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"

/turf/simulated/floor/ice
	name = "ice"
	icon = 'icons/turf/snow.dmi'
	icon_state = "ice"

/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	footstep_sound = /singleton/sound_category/snow_footstep
	does_footprint = TRUE
	footprint_color = COLOR_SNOW
	track_distance = 4

/turf/simulated/floor/snow/Initialize()
	. = ..()
	icon_state = pick("snow[rand(1,2)]","snow0")

/turf/simulated/floor/plating/snow
	icon = 'icons/turf/snow.dmi'
	icon_state = "snowplating"
	footstep_sound = /singleton/sound_category/snow_footstep

/turf/simulated/floor/airless/ceiling
	icon_state = "asteroidplating"
	baseturf = /turf/space

/turf/simulated/floor/light

/turf/simulated/floor/silver
	name = "silver floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "silver"
	initial_flooring = /singleton/flooring/silver

/turf/simulated/floor/gold
	name = "golden floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "gold"
	initial_flooring = /singleton/flooring/gold

/turf/simulated/floor/uranium
	name = "uranium floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "uranium"
	initial_flooring =/singleton/flooring/uranium

/turf/simulated/floor/phoron
	name = "phoron floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "plasma"
	initial_flooring = /singleton/flooring/phoron

/turf/simulated/floor/diamond
	name = "diamond floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "diamond"
	initial_flooring = /singleton/flooring/diamond

/turf/simulated/floor/marble
	name = "light marble floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "lightmarble"
	initial_flooring = /singleton/flooring/marble

/turf/simulated/floor/marble/dark
	name = "dark marble floor"
	icon_state = "darkmarble"
	initial_flooring = /singleton/flooring/marble/dark

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
