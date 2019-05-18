/turf/simulated/floor/plating
	footstep_sound = "concretestep"

/turf/simulated/floor/diona
	name = "biomass flooring"
	icon_state = "diona"
	footstep_sound = "grassstep"
	initial_flooring = /decl/flooring/diona

/turf/simulated/floor/diona/attackby()
	return

/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2
	roof_flags = ROOF_CLEANUP
	var/destructible = FALSE
	var/damage = 0
	var/damage_overlay = 0
	var/material/material
	var/material/reinf_material
	roof_type = /turf/simulated/shuttle/roof/destructible

/turf/simulated/shuttle/Initialize(mapload)
	. = ..(mapload)
	material = new /material/steel (src.loc)
	reinf_material = new /material/plasteel (src.loc)

/turf/simulated/shuttle/wall
	icon = 'icons/turf/smooth/shuttle_wall.dmi'
	name = "wall"
	icon_state = "map-shuttle"
	opacity = 1
	density = 1
	blocks_air = 1
	smooth = SMOOTH_MORE | SMOOTH_DIAGONAL
	permit_ao = FALSE
	canSmoothWith = list(
		/turf/simulated/shuttle/wall,
		/obj/structure/window/shuttle,
		/obj/machinery/door/airlock,
		/obj/machinery/door/unpowered/shuttle,
		/obj/structure/shuttle/engine/propulsion
	)

/turf/simulated/shuttle/wall/blue
	icon = 'icons/turf/smooth/shuttle_wall_blue.dmi'

/turf/simulated/shuttle/wall/destructible
	name = "shuttle wall"
	icon = 'icons/turf/smooth/shuttle_wall.dmi'
	icon_state = "shuttle"
	destructible = TRUE

/turf/simulated/shuttle/wall/destructible/legion
	name = "dropship hull"
	roof_type = /turf/simulated/shuttle/roof/destructible/legion
	icon = 'icons/turf/smooth/shuttle_wall_blue.dmi'

/turf/simulated/shuttle/wall/dark
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall3"
	smooth = SMOOTH_FALSE
	canSmoothWith = null
	permit_ao = TRUE
	roof_type = /turf/simulated/shuttle/roof/destructible/black

/turf/simulated/shuttle/wall/dark/destructible
	destructible = TRUE

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"
	footstep_sound = "concretestep"
	permit_ao = FALSE

/turf/simulated/shuttle/floor/destructible
	destructible = TRUE

/turf/simulated/shuttle/floor/destructible/legion
	icon_state = "floor7"
	roof_type = /turf/simulated/shuttle/roof/destructible/legion

/turf/simulated/shuttle/floor/destructible/merc
	icon_state = "floor6"
	roof_type = /turf/simulated/shuttle/roof/destructible/black

/turf/simulated/shuttle/floor/destructible/merc/red
	icon_state = "floor4"

/turf/simulated/shuttle/floor/destructible/merc/black
	icon_state = "floor7"

/turf/simulated/shuttle/floor/destructible/merc/white
	icon_state = "floor3"

/turf/simulated/shuttle/floor/destructible/merc/yellow
	icon_state = "floor2"

/turf/simulated/shuttle/floor/tiled
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "floor"

/turf/simulated/shuttle/floor/tiled/destructible
	destructible = TRUE

/turf/simulated/shuttle/floor/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"
	level = 1

/turf/simulated/shuttle/floor/plating/destructible
	destructible = TRUE

/turf/simulated/shuttle/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"

/turf/simulated/shuttle/floor/wood/destructible
	destructible = TRUE

/turf/simulated/shuttle/floor/carpet
	name = "carpet"
	icon = 'icons/turf/total_floors.dmi'
	icon_state = "carpet"
	footstep_sound = "dirtstep"

/turf/simulated/shuttle/floor/carpet/destructible
	destructible = TRUE

/turf/simulated/shuttle/floor/plating/destructible/legion
	roof_type = /turf/simulated/shuttle/roof/destructible/legion

/turf/simulated/shuttle/floor/plating/destructible/black
	roof_type = /turf/simulated/shuttle/roof/destructible/black

/turf/simulated/shuttle/floor/ramp
	name = "steps"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "rampbot"

/turf/simulated/shuttle/floor/ramp/destructible
	destructible = TRUE

/turf/simulated/shuttle/floor/ramp/destructible/legion
	roof_type = /turf/simulated/shuttle/roof/destructible/legion

/turf/simulated/shuttle/plating/is_plating()
	return 1

/turf/simulated/shuttle/plating/vox //Skipjack plating
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/simulated/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/simulated/shuttle/floor4/vox //skipjack floors
	name = "skipjack floor"
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/simulated/shuttle/roof
	name = "shuttle roof"
	icon = 'icons/turf/smooth/roof_white.dmi'
	icon_state = "roof_white"
	smooth = SMOOTH_DIAGONAL|SMOOTH_TRUE
	smooth_underlays = TRUE
	oxygen = 0
	nitrogen = 0
	roof_type = null

/turf/simulated/shuttle/roof/destructible
	destructible = TRUE

/turf/simulated/shuttle/roof/destructible/legion
	name = "dropship roof"
	icon = 'icons/turf/smooth/roof_blue.dmi'
	icon_state = "roof_blue"

/turf/simulated/shuttle/roof/destructible/black
	icon = 'icons/turf/smooth/roof_black.dmi'
	icon_state = "roof_black"

