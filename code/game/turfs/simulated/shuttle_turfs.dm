
//--Walls--//

/turf/simulated/wall/shuttle
	icon = 'icons/turf/smooth/shuttle_wall.dmi'
	icon_state = "map-shuttle"
	permit_ao = 0
	smooth = SMOOTH_MORE|SMOOTH_DIAGONAL
	canSmoothWith = list(
		/turf/simulated/wall/shuttle,
		/obj/structure/window/shuttle,
		/obj/machinery/door/airlock,
		/obj/machinery/door/unpowered/shuttle,
		/obj/structure/shuttle/engine/propulsion
	)

/turf/simulated/wall/shuttle/Initialize(mapload)
	. = ..(mapload, "shuttle", "shuttle")

/turf/simulated/wall/shuttle/cardinal
	smooth = SMOOTH_TRUE

/turf/simulated/wall/shuttle/dark
	icon = 'icons/turf/smooth/shuttle_wall_dark.dmi'
	canSmoothWith = null

/turf/simulated/wall/shuttle/dark/cardinal
	smooth = SMOOTH_MORE
	canSmoothWith = list(
		/turf/simulated/wall/shuttle/dark,
		/obj/structure/shuttle_part/dark
	)

/turf/simulated/wall/shuttle/dark/long_diagonal_2
	name = "test diagonal"
	icon = 'icons/turf/smooth/shuttle_wall_dark.dmi'
	icon_state = "d2-we-1"
	use_set_icon_state = TRUE
	smooth = null
	canSmoothWith = null

/obj/structure/shuttle_part/dark
	name = "spaceship alloy wall"
	icon = 'icons/turf/smooth/shuttle_wall_dark.dmi'
	icon_state = "d2-we-1"
	outside_part = FALSE

/turf/simulated/wall/shuttle/dark/corner
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall3"
	use_set_icon_state = 1
	smooth = null
	canSmoothWith = null

/turf/simulated/wall/shuttle/dark/corner/underlay
	var/underlay_dir

/turf/simulated/wall/shuttle/dark/corner/underlay/update_icon()
	..()
	underlays.Cut()
	var/underlay_fetch_dir = dir
	if(underlay_dir)
		underlay_fetch_dir = underlay_dir
	var/turf/T = get_step(src, underlay_fetch_dir)
	var/mutable_appearance/underlay_appearance = mutable_appearance(null, layer = TURF_LAYER)
	var/list/U = list(underlay_appearance)
	if(T && !istype(T, /turf/simulated/open))
		underlay_appearance.appearance = T
		underlays = U

/turf/simulated/wall/shuttle/scc_space_ship
	name = "spaceship hull"
	icon = 'icons/turf/smooth/scc_ship.dmi'
	canSmoothWith = null

/turf/simulated/wall/shuttle/scc_space_ship/cardinal
	smooth = SMOOTH_MORE
	canSmoothWith = list(
		/turf/simulated/wall/shuttle/scc_space_ship,
		/obj/structure/window/shuttle/scc_space_ship
	)

/obj/structure/shuttle_part/scc_space_ship
	name = "spaceship alloy wall"
	icon = 'icons/turf/smooth/scc_ship.dmi'
	icon_state = "map-shuttle"
	outside_part = FALSE

/turf/simulated/wall/shuttle/raider
	icon = 'icons/turf/smooth/composite_metal.dmi'
	icon_state = "composite_metal"
	smooth = SMOOTH_TRUE
	canSmoothWith = null
	color = "#6C7364"

/turf/simulated/wall/shuttle/legion
	icon = 'icons/turf/smooth/shuttle_wall_legion.dmi'

/turf/simulated/wall/shuttle/legion/cardinal
	smooth = SMOOTH_MORE

/turf/simulated/wall/shuttle/palepurple
	icon = 'icons/turf/smooth/shuttle_wall_palepurple.dmi'
	canSmoothWith = list(
		/turf/simulated/wall/shuttle/palepurple,
		/obj/structure/window/shuttle/palepurple,
		/obj/machinery/door/airlock,
		/obj/machinery/door/unpowered/shuttle,
		/obj/structure/shuttle/engine/propulsion
	)

/turf/simulated/wall/shuttle/palepurple/cardinal
	smooth = SMOOTH_MORE

/turf/simulated/wall/shuttle/skrell
	icon_state = "skrell_purple"
	icon = 'icons/turf/smooth/skrell_purple.dmi'
	canSmoothWith = list(
		/turf/simulated/wall/shuttle/skrell,
		/obj/structure/window/shuttle,
		/obj/machinery/door/airlock,
		/obj/structure/shuttle/engine/propulsion,
		/turf/unsimulated/wall/fakeairlock
	)

/turf/simulated/wall/shuttle/skrell/Initialize(mapload)
	. = ..(mapload,"skrell")

/turf/simulated/wall/shuttle/skrell/cardinal
	smooth = SMOOTH_MORE

/turf/simulated/wall/shuttle/skrell/corner
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "skrell_diagonal"
	use_set_icon_state = TRUE
	smooth = null
	canSmoothWith = null

/turf/simulated/wall/shuttle/scc
	icon = 'icons/turf/smooth/scc_shuttle.dmi'

/turf/simulated/wall/shuttle/scc/cardinal
	smooth = SMOOTH_MORE

//Corporate shuttle and ship walls//
/turf/simulated/wall/shuttle/idris
	icon = 'icons/turf/smooth/idris_ship.dmi'

/turf/simulated/wall/shuttle/idris/cardinal
	smooth = SMOOTH_MORE

/turf/simulated/wall/shuttle/space_ship
	icon = 'icons/turf/smooth/generic_shuttle.dmi'

/turf/simulated/wall/shuttle/space_ship/cardinal
	smooth = SMOOTH_MORE

/turf/simulated/wall/shuttle/space_ship/mercenary
	color = "#5b5b5b"

/turf/simulated/wall/shuttle/space_ship/mercenary/cardinal
	smooth = SMOOTH_MORE
	color = "#5b5b5b"

//--Unique Shuttles--//

/turf/simulated/wall/shuttle/unique
	name = "shuttle hull"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "floor5"
	use_set_icon_state = TRUE
	smooth = null
	canSmoothWith = null

/obj/structure/shuttle_part //For placing them over space, if the sprite doesn't cover the whole turf.
	name = "shuttle part"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "door0"
	anchored = TRUE
	density = TRUE
	var/outside_part = TRUE
	atmos_canpass = CANPASS_DENSITY
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED|OBJ_FLAG_NOFALL

/obj/structure/shuttle_part/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(density)
		return 0
	else
		return ..()

/obj/structure/window/shuttle/unique
	name = "shuttle window"
	desc = "It looks extremely strong. Might take many good hits to crack it."
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall2"
	health = 500
	maxhealth = 500
	smooth = null
	canSmoothWith = null
	can_be_unanchored = FALSE
	var/outside_window = FALSE

//merchant shuttle

/turf/simulated/wall/shuttle/unique/merchant
	icon = 'icons/turf/shuttles_unique/merchant_shuttle.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/merchant
	icon = 'icons/turf/shuttles_unique/merchant_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/merchant
	icon = 'icons/turf/shuttles_unique/merchant_shuttle.dmi'
	icon_state = "6,2"

//cargo shuttle

/turf/simulated/wall/shuttle/unique/cargo
	icon = 'icons/turf/shuttles_unique/cargo_shuttle.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/cargo
	icon = 'icons/turf/shuttles_unique/cargo_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/cargo
	icon = 'icons/turf/shuttles_unique/cargo_shuttle.dmi'
	icon_state = "6,2"

//ccia shuttle

/turf/simulated/wall/shuttle/unique/ccia
	icon = 'icons/turf/shuttles_unique/ccia_shuttle.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/ccia
	icon = 'icons/turf/shuttles_unique/ccia_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/ccia
	icon = 'icons/turf/shuttles_unique/ccia_shuttle.dmi'
	icon_state = "6,2"

//burglar shuttle

/turf/simulated/wall/shuttle/unique/burglar
	icon = 'icons/turf/shuttles_unique/ccia_shuttle_gray.dmi'
	icon_state = "8,4"

/obj/structure/shuttle_part/burglar
	icon = 'icons/turf/shuttles_unique/ccia_shuttle_gray.dmi'
	icon_state = "2,0"

/obj/structure/window/shuttle/unique/burglar
	icon = 'icons/turf/shuttles_unique/ccia_shuttle_gray.dmi'
	icon_state = "1,3"

//ert shuttle

/turf/simulated/wall/shuttle/unique/ert
	icon = 'icons/turf/shuttles_unique/ert_shuttle.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/ert
	icon = 'icons/turf/shuttles_unique/ert_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/ert
	icon = 'icons/turf/shuttles_unique/ert_shuttle.dmi'
	icon_state = "6,2"

//escape pod

/turf/simulated/wall/shuttle/unique/escape_pod
	icon = 'icons/turf/shuttles_unique/escape_pod.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/escape_pod
	icon = 'icons/turf/shuttles_unique/escape_pod.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/escape_pod
	icon = 'icons/turf/shuttles_unique/escape_pod.dmi'
	icon_state = "6,2"

//hapt shuttle

/turf/simulated/wall/shuttle/unique/hapt
	icon = 'icons/turf/shuttles_unique/escape_pod.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/hapt
	icon = 'icons/turf/shuttles_unique/hapt_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/hapt
	icon = 'icons/turf/shuttles_unique/hapt_shuttle.dmi'
	icon_state = "6,2"

//raider shuttle

/turf/simulated/wall/shuttle/unique/raider
	icon = 'icons/turf/shuttles_unique/raider_shuttle.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/raider
	name = "Skipjack"
	desc = "A quick, agile and sturdy shuttle. Perfect for smugglers and pirates, but recently proliferated in civilian hands."
	icon = 'icons/turf/shuttles_unique/raider_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/raider
	icon = 'icons/turf/shuttles_unique/raider_shuttle.dmi'
	icon_state = "6,2"

//tcfl shuttle

/turf/simulated/wall/shuttle/unique/tcfl
	icon = 'icons/turf/shuttles_unique/tcfl_shuttle.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/tcfl
	icon = 'icons/turf/shuttles_unique/tcfl_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/tcfl
	icon = 'icons/turf/shuttles_unique/tcfl_shuttle.dmi'
	icon_state = "6,2"

//transfer shuttle

/turf/simulated/wall/shuttle/unique/transfer
	icon = 'icons/turf/shuttles_unique/transfer_shuttle.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/transfer
	icon = 'icons/turf/shuttles_unique/transfer_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/transfer
	icon = 'icons/turf/shuttles_unique/transfer_shuttle.dmi'
	icon_state = "6,2"

//mercenary shuttle

/turf/simulated/wall/shuttle/unique/mercenary
	icon = 'icons/turf/shuttles_unique/merc_shuttle.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/mercenary
	icon = 'icons/turf/shuttles_unique/merc_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/mercenary
	icon = 'icons/turf/shuttles_unique/merc_shuttle.dmi'
	icon_state = "6,2"

//mercenary shuttle - small

/turf/simulated/wall/shuttle/unique/mercenary/small
	icon = 'icons/turf/shuttles_unique/merc_shuttle_small.dmi'
	icon_state = "1,2"

/obj/structure/shuttle_part/mercenary/small
	icon = 'icons/turf/shuttles_unique/merc_shuttle_small.dmi'
	icon_state = "1,0"

/obj/structure/window/shuttle/unique/mercenary/small
	icon = 'icons/turf/shuttles_unique/merc_shuttle_small.dmi'
	icon_state = "4,13"

//arrivals shuttle

/turf/simulated/wall/shuttle/unique/arrivals
	icon = 'icons/turf/shuttles_unique/arrivals_shuttle.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/arrivals
	icon = 'icons/turf/shuttles_unique/arrivals_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/arrivals
	icon = 'icons/turf/shuttles_unique/arrivals_shuttle.dmi'
	icon_state = "6,2"

//arrivals shuttle

/turf/simulated/wall/shuttle/unique/research
	icon = 'icons/turf/shuttles_unique/aurora_research_shuttle.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/research
	icon = 'icons/turf/shuttles_unique/aurora_research_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/research
	icon = 'icons/turf/shuttles_unique/aurora_research_shuttle.dmi'
	icon_state = "6,2"

//distress team shuttle

/turf/simulated/wall/shuttle/unique/distress
	icon = 'icons/turf/shuttles_unique/distress_shuttle.dmi'
	icon_state = "5,4"

/obj/structure/shuttle_part/distress
	icon = 'icons/turf/shuttles_unique/distress_shuttle.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/distress
	icon = 'icons/turf/shuttles_unique/distress_shuttle.dmi'
	icon_state = "6,2"

//scc shuttle pieces

/turf/simulated/wall/shuttle/unique/scc
	name = "shuttle hull"
	icon = 'icons/turf/shuttles_unique/scc_shuttle_pieces.dmi'
	icon_state = "c1"

//--Floors--//

/turf/simulated/floor/shuttle
	name = "shuttle floor"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "floor"
	permit_ao = 0
	initial_flooring = /singleton/flooring/shuttle
	footstep_sound = /singleton/sound_category/plating_footstep

/turf/simulated/floor/shuttle/yellow
	icon_state = "floor2"
	initial_flooring = /singleton/flooring/shuttle/yellow

/turf/simulated/floor/shuttle/white
	icon_state = "floor3"
	initial_flooring = /singleton/flooring/shuttle/white

/turf/simulated/floor/shuttle/red
	icon_state = "floor4"
	initial_flooring = /singleton/flooring/shuttle/red

/turf/simulated/floor/shuttle/dark_red
	icon_state = "floor6"
	initial_flooring = /singleton/flooring/shuttle/dark_red

/turf/simulated/floor/shuttle/black
	icon_state = "floor7"
	initial_flooring = /singleton/flooring/shuttle/black

/turf/simulated/floor/shuttle/tan
	icon_state = "floor8"
	initial_flooring = /singleton/flooring/shuttle/tan

/turf/simulated/floor/shuttle/dark_blue
	icon_state = "floor9"
	initial_flooring = /singleton/flooring/shuttle/dark_blue

/turf/simulated/floor/shuttle/dark_blue/airless
	initial_gas = null

/turf/simulated/floor/shuttle/advanced
	icon_state = "advanced_plating"
	initial_flooring = /singleton/flooring/shuttle/advanced

/turf/simulated/floor/shuttle/advanced/alt
	icon_state = "advanced_plating_alt"
	initial_flooring = /singleton/flooring/shuttle/advanced/alt

/turf/simulated/floor/shuttle/skrell
	icon_state = "skrell_purple"
	initial_flooring = /singleton/flooring/shuttle/skrell
	footstep_sound = /singleton/sound_category/sand_footstep

/turf/simulated/floor/shuttle/skrell/airless
	initial_gas = null

/turf/simulated/floor/shuttle/skrell/blue
	icon_state = "skrell_blue"
	initial_flooring = /singleton/flooring/shuttle/skrell/blue

/turf/simulated/floor/shuttle/skrell/blue/airless
	initial_gas = null

/turf/simulated/floor/shuttle/skrell/ramp
	name = "footramp"
	icon_state = "skrellramp-bottom"
	initial_flooring = /singleton/flooring/shuttle/skrell/ramp

/turf/simulated/floor/shuttle/skrell/ramp/top
	icon_state = "skrellramp-top"
	initial_flooring = /singleton/flooring/shuttle/skrell/ramp/top

//--Roofs--//

/turf/simulated/shuttle_roof
	name = "shuttle roof"
	icon = 'icons/turf/smooth/roof_white.dmi'
	icon_state = "roof_white"
	smooth = SMOOTH_DIAGONAL|SMOOTH_TRUE
	smooth_underlays = TRUE
	initial_gas = null
	roof_type = null
	permit_ao = 0
	canSmoothWith = list(
			/turf/simulated/shuttle_roof
	)

/turf/simulated/shuttle_roof/dark
	icon = 'icons/turf/smooth/roof_dark.dmi'
	icon_state = "roof_dark"
	canSmoothWith = list(
			/turf/simulated/shuttle_roof/dark
	)

/turf/simulated/shuttle_roof/legion
	name = "dropship roof"
	icon = 'icons/turf/smooth/roof_legion.dmi'
	icon_state = "roof_legion"
	canSmoothWith = list(
			/turf/simulated/shuttle_roof/legion
	)

/turf/simulated/shuttle_roof/ex_act(severity)
	if(severity == 1)
		src.ChangeTurf(baseturf)
	return
