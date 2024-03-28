
//--Walls--//

/turf/simulated/wall/shuttle
	icon = 'icons/turf/smooth/shuttle_wall_dark.dmi'
	icon_state = "map-shuttle"
	permit_ao = 0
	smoothing_flags = SMOOTH_MORE
	canSmoothWith = list(
		/turf/unsimulated/wall/steel, // Centcomm wall.
		/turf/unsimulated/wall/darkshuttlewall, // Centcomm wall.
		/turf/unsimulated/wall/riveted, // Centcomm wall.
		/obj/structure/window_frame,
		/obj/structure/window_frame/unanchored,
		/obj/structure/window_frame/empty,
		/obj/machinery/door,
		/turf/simulated/wall/shuttle,
		/obj/structure/window/shuttle,
		/obj/machinery/door/airlock,
		/obj/machinery/door/unpowered/shuttle,
		/obj/structure/shuttle/engine/propulsion
	)

/turf/simulated/wall/shuttle/Initialize(mapload)
	. = ..(mapload, MATERIAL_SHUTTLE, MATERIAL_SHUTTLE)

/turf/simulated/wall/shuttle/cardinal
	smoothing_flags = SMOOTH_TRUE

/turf/simulated/wall/shuttle/dark
	canSmoothWith = null

/turf/simulated/wall/shuttle/dark/cardinal
	smoothing_flags = SMOOTH_MORE
	canSmoothWith = list(
		/turf/simulated/wall/shuttle/dark,
		/obj/structure/shuttle_part/dark,
		/obj/structure/window_frame/shuttle,
		/obj/machinery/door/airlock
	)

/turf/simulated/wall/shuttle/dark/cardinal/merc
	color = "#8b7d86"

/turf/simulated/wall/shuttle/dark/cardinal/khaki
	color = "#ac8b78"

/turf/simulated/wall/shuttle/dark/cardinal/purple
	color = "#7846b1"

/turf/simulated/wall/shuttle/dark/cardinal/red
	color = "#c24f4f"

/turf/simulated/wall/shuttle/dark/cardinal/blue
	color = "#6176a1"

/turf/simulated/wall/shuttle/dark/cardinal/gold
	color = COLOR_GOLD

/turf/simulated/wall/shuttle/dark/long_diagonal_2
	name = "test diagonal"
	icon_state = "d2-we-1"
	use_set_icon_state = TRUE
	smoothing_flags = null
	canSmoothWith = null

/obj/structure/shuttle_part/dark
	name = "spaceship alloy wall"
	icon_state = "d2-we-1"
	outside_part = FALSE

/turf/simulated/wall/shuttle/dark/corner
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall3"
	use_set_icon_state = 1
	smoothing_flags = null
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
	icon = 'icons/turf/smooth/scc_ship/scc_ship_exterior.dmi'
	icon_state = "map-wall"
	canSmoothWith = null

/turf/simulated/wall/shuttle/scc_space_ship/cardinal
	smoothing_flags = SMOOTH_MORE
	canSmoothWith = list(
		/turf/simulated/wall,
		/turf/simulated/wall/r_wall,
		/turf/simulated/wall/shuttle/scc_space_ship,
		/obj/structure/window/shuttle/scc_space_ship,
		/obj/machinery/door/airlock
	)

/obj/structure/shuttle_part/scc_space_ship
	name = "spaceship alloy wall"
	icon = 'icons/turf/smooth/scc_ship/scc_ship_exterior.dmi'
	icon_state = "map-wall"
	outside_part = FALSE

/turf/simulated/wall/shuttle/raider
	color = "#6C7364"

/turf/simulated/wall/shuttle/legion
	color = "#5F78A0"

/turf/simulated/wall/shuttle/palepurple
	color = COLOR_PALE_PURPLE_GRAY
	canSmoothWith = list(
		/turf/simulated/wall/shuttle/palepurple,
		/obj/structure/window/shuttle/palepurple,
		/obj/machinery/door/airlock,
		/obj/machinery/door/unpowered/shuttle,
		/obj/structure/shuttle/engine/propulsion
	)


/turf/simulated/wall/shuttle/skrell
	color = COLOR_PURPLE
	canSmoothWith = list(
		/turf/simulated/wall/shuttle/skrell,
		/obj/structure/window/shuttle,
		/obj/machinery/door/airlock,
		/obj/structure/shuttle/engine/propulsion,
		/turf/unsimulated/wall/fakeairlock
	)

/turf/simulated/wall/shuttle/skrell/Initialize(mapload)
	. = ..(mapload,"skrell")

/turf/simulated/wall/shuttle/scc
	color = "#AAAFC7"

//Corporate shuttle and ship walls//
/turf/simulated/wall/shuttle/idris
	color = "#4B7A73"

/turf/simulated/wall/shuttle/space_ship
	color = "#BDB6AE"

/turf/simulated/wall/shuttle/space_ship/mercenary
	color = "#5b5b5b"

//--Unique Shuttles--//

/turf/simulated/wall/shuttle/unique
	name = "shuttle hull"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "floor5"
	use_set_icon_state = TRUE
	smoothing_flags = null
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
	alpha = 255
	smoothing_flags = null
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
	icon = 'icons/turf/shuttles_unique/scc/scc_shuttle_pieces.dmi'
	icon_state = "c1"

/obj/structure/shuttle_part/scc
	icon = 'icons/turf/shuttles_unique/scc/scc_shuttle_pieces.dmi'
	icon_state = "c1"

/obj/structure/window/shuttle/unique/scc
	icon = 'icons/turf/shuttles_unique/scc/scc_shuttle_pieces.dmi'
	icon_state = "c1"

//Canary pieces
/turf/simulated/wall/shuttle/unique/scc/scout
	name = "jester-type shuttle hull"
	desc = "The hull and reinforcement of a Jester-type corporate skiff. The phoron-purple colored bands indicate this, in bold text as the SCCV Canary."
	icon = 'icons/turf/shuttles_unique/scc/scout_shuttle/complete_hull.dmi'
	icon_state = "4,1"

/obj/structure/shuttle_part/scc/scout
	name = "jester-type shuttle hull"
	desc = "The hull and reinforcement of a Jester-type corporate skiff. The phoron-purple colored bands indicate this, in bold text as the SCCV Canary."
	icon = 'icons/turf/shuttles_unique/scc/scout_shuttle/complete_hull.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/scc/scout
	name = "jester-type shuttle hull"
	desc = "The hull and reinforcement of a Jester-type corporate skiff. This particular piece looks fragile and frames a cockpit viewport."
	icon = 'icons/turf/shuttles_unique/scc/scout_shuttle/complete_hull.dmi'
	icon_state = "4,1"

/obj/structure/window/shuttle/unique/scc/scout/over
	name = "jester-type shuttle cockpit"
	desc = "The strong glass face of a Jester-type shuttle cockpit."
	icon = 'icons/turf/shuttles_unique/scc/scout_shuttle/cockpit_windows.dmi'
	icon_state = "4,1"
	layer = ABOVE_HUMAN_LAYER

//Intrepid pieces
/turf/simulated/wall/shuttle/unique/scc/research
	name = "pathfinder class shuttle hull"
	desc = "The hull and reinforcement of a Pathfinder class corporate expedition shuttle. The phoron-purple colored bands indicate this, in bold text as the SCCV Intrepid."
	icon = 'icons/turf/shuttles_unique/scc/research_shuttle/complete_hull.dmi'
	icon_state = "8,10"

/obj/structure/shuttle_part/scc/research
	name = "pathfinder class shuttle hull"
	desc = "The hull and reinforcement of a Pathfinder class corporate expedition shuttle. The phoron-purple colored bands indicate this, in bold text as the SCCV Intrepid."
	icon = 'icons/turf/shuttles_unique/scc/research_shuttle/complete_hull.dmi'
	icon_state = "5,8"

/obj/structure/window/shuttle/unique/scc/research
	name = "pathfinder class shuttle hull"
	desc = "The hull and reinforcement of a Pathfinder class corporate expedition shuttle. This particular piece looks fragile and frames a viewport."
	icon = 'icons/turf/shuttles_unique/scc/research_shuttle/complete_hull.dmi'
	icon_state = "3,10"

/obj/structure/window/shuttle/unique/scc/tall//For side windows of the hull, can overlap seamlessly
	icon = 'icons/obj/spaceship/scc/windows_tall.dmi'
	icon_state = "long1-1"

/obj/structure/window/shuttle/unique/scc/research/over
	name = "pathfinder class shuttle cockpit"
	desc = "The strong glass face of a Pathfinder class shuttle cockpit."
	icon = 'icons/turf/shuttles_unique/scc/research_shuttle/cockpit_windows.dmi'
	icon_state = "2,1"
	layer = ABOVE_HUMAN_LAYER

//Spark pieces
/turf/simulated/wall/shuttle/unique/scc/mining
	name = "pickaxe class shuttle hull"
	desc = "The hull and reinforcement of a Pickaxe class corporate mining shuttle. The phoron-purple colored bands indicate this, in bold text as the SCCV Spark."
	icon = 'icons/turf/shuttles_unique/scc/mining_shuttle/complete_hull.dmi'
	icon_state = "1,8"

/obj/structure/shuttle_part/scc/mining
	name = "pickaxe class shuttle hull"
	desc = "The hull and reinforcement of a Pickaxe class corporate mining shuttle. The phoron-purple colored bands indicate this, in bold text as the SCCV Spark."
	icon = 'icons/turf/shuttles_unique/scc/mining_shuttle/complete_hull.dmi'
	icon_state = "1,0"

/obj/structure/window/shuttle/unique/scc/mining
	name = "pickaxe class shuttle hull"
	desc = "The hull and reinforcement of a Pickaxe class corporate mining shuttle. This particular piece looks fragile and frames a viewport."
	icon = 'icons/turf/shuttles_unique/scc/mining_shuttle/complete_hull.dmi'
	icon_state = "5,2"

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
	smoothing_flags = SMOOTH_DIAGONAL|SMOOTH_TRUE
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
