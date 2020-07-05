/turf/simulated/floor/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet"
	initial_flooring = /decl/flooring/carpet
	footstep_sound = "carpet"

/turf/simulated/floor/carpet/blue
	name = "blue carpet"
	icon_state = "bcarpet"
	initial_flooring = /decl/flooring/carpet/blue

/turf/simulated/floor/carpet/rubber
	name = "rubber carpet"
	icon_state = "rub_carpet"
	initial_flooring = /decl/flooring/carpet/rubber

/turf/simulated/floor/carpet/art
	icon_state = "artcarpet"
	initial_flooring = /decl/flooring/carpet/art

/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit/green

/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	initial_flooring = /decl/flooring/wood
	footstep_sound = "wood"

/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass
	footstep_sound = "grass"

/turf/simulated/floor/grass/alt
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "grass_alt"
	initial_flooring = /decl/flooring/grass/alt

/turf/simulated/floor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "steel"
	initial_flooring = /decl/flooring/tiling

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /decl/flooring/reinforced
	footstep_sound = "plating"

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

/turf/simulated/floor/reinforced/oxygen
	oxygen = ATMOSTANK_OXYGEN
	nitrogen = 0

/turf/simulated/floor/reinforced/phoron
	oxygen = 0
	nitrogen = 0
	phoron = ATMOSTANK_PHORON

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
	air.adjust_gas("sleeping_agent", ATMOSTANK_NITROUSOXIDE)

/turf/simulated/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /decl/flooring/reinforced/cult
	appearance_flags = NO_CLIENT_COLOR

/turf/simulated/floor/cult/cultify()
	return

/turf/simulated/floor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	initial_flooring = /decl/flooring/tiling/dark

/turf/simulated/floor/tiled/red
	name = "red floor"
	color = COLOR_RED_GRAY
	icon_state = "white"
	initial_flooring = /decl/flooring/tiling/red

/turf/simulated/floor/tiled/steel
	name = "steel floor"
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "steel_dirty"
	initial_flooring = /decl/flooring/tiling/steel

/turf/simulated/floor/tiled/steel/airless
	oxygen = 0
	nitrogen = 0
	roof_type = null

/turf/simulated/floor/tiled/old
	name = "old floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "old_steel"
	initial_flooring = /decl/flooring/tiling/old

/turf/simulated/floor/tiled/old_dark
	name = "old dark floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "old_dark"
	initial_flooring = /decl/flooring/tiling/old_dark

/turf/simulated/floor/tiled/old_white
	name = "old sterile floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "old_white"
	initial_flooring = /decl/flooring/tiling/old_white

/turf/simulated/floor/tiled/asteroid
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "asteroidfloor"
	initial_flooring = /decl/flooring/tiling/asteroid

/turf/simulated/floor/tiled/asteroid/airless
	oxygen = 0
	nitrogen = 0
	roof_type = null

/turf/simulated/floor/plating/asteroid
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "asteroidplating"

/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "white"
	initial_flooring = /decl/flooring/tiling/white

/turf/simulated/floor/tiled/yellow
	name = "yellow floor"
	color = COLOR_BROWN
	icon_state = "white"
	initial_flooring = /decl/flooring/tiling/yellow

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	initial_flooring = /decl/flooring/tiling/freezer

/turf/simulated/floor/tiled/ramp
	name = "foot ramp"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "ramptop"
	initial_flooring = /decl/flooring/reinforced/ramp

/turf/simulated/floor/tiled/ramp/bottom
	name = "foot ramp"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "rampbot"
	initial_flooring = /decl/flooring/reinforced/ramp/bottom

/turf/simulated/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /decl/flooring/linoleum

/turf/simulated/floor/lino/grey
	icon_state = "lino_grey"
	initial_flooring = /decl/flooring/linoleum/grey

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
	footstep_sound = "plating"

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
	footstep_sound = "snow"
	does_footprint = TRUE
	footprint_color = COLOR_SNOW
	track_distance = 4

/turf/simulated/floor/snow/Initialize()
	. = ..()
	icon_state = pick("snow[rand(1,12)]","snow0")

/turf/simulated/floor/plating/snow
	icon = 'icons/turf/snow.dmi'
	icon_state = "snowplating"
	footstep_sound = "snow"

/turf/simulated/floor/airless/ceiling
	icon_state = "asteroidplating"
	baseturf = /turf/space

/turf/simulated/floor/light

/turf/simulated/floor/silver
	name = "silver floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "silver"
	initial_flooring = /decl/flooring/silver

/turf/simulated/floor/gold
	name = "golden floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "gold"
	initial_flooring = /decl/flooring/gold

/turf/simulated/floor/uranium
	name = "uranium floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "uranium"
	initial_flooring =/decl/flooring/uranium

/turf/simulated/floor/phoron
	name = "phoron floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "plasma"
	initial_flooring = /decl/flooring/phoron

/turf/simulated/floor/diamond
	name = "diamond floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "diamond"
	initial_flooring = /decl/flooring/diamond

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
		to_chat(user, span("notice","You clear away the metal foam."))