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

/turf/simulated/shuttle/wall/dark
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall3"
	smooth = SMOOTH_FALSE
	canSmoothWith = null
	permit_ao = TRUE

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"
	footstep_sound = "concretestep"
	permit_ao = FALSE

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"
	footstep_sound = "concretestep"
	level = 1

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
	icon_state = "roof_white"

	smooth = SMOOTH_DIAGONAL|SMOOTH_TRUE

	oxygen = 0
	nitrogen = 0

	roof_type = null

/turf/simulated/shuttle/roof/black
	icon_state = "roof_black"
