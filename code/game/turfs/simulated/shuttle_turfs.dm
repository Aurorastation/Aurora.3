
//--Walls--//

/turf/simulated/wall/shuttle
	icon = 'icons/turf/smooth/shuttle_wall.dmi'
	icon_state = "map-shuttle"
	roof_flags = ROOF_CLEANUP
	permit_ao = 0
	smooth = SMOOTH_MORE|SMOOTH_DIAGONAL
	use_standard_smoothing = 1
	canSmoothWith = list(
		/turf/simulated/wall/shuttle,
		/obj/structure/window/shuttle,
		/obj/machinery/door/airlock,
		/obj/machinery/door/unpowered/shuttle,
		/obj/structure/shuttle/engine/propulsion
	)

/turf/simulated/wall/shuttle/Initialize(mapload)
	. = ..(mapload,"shuttle")

/turf/simulated/wall/shuttle/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (!user)
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	if(!istype(user.loc, /turf))
		return

	if(locate(/obj/effect/overlay/wallrot) in src)
		if(W.iswelder() )
			var/obj/item/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				to_chat(user, "<span class='notice'>You burn away the fungi with \the [WT].</span>")
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			to_chat(user, "<span class='notice'>\The [src] crumbles away under the force of your [W.name].</span>")
			src.dismantle_wall(1)
			return

	if(thermite)
		if(W.iswelder() )
			var/obj/item/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/gun/energy/plasmacutter))
			thermitemelt(user)
			return

		else if( istype(W, /obj/item/melee/energy/blade) )
			var/obj/item/melee/energy/blade/EB = W

			spark(EB, 5)
			to_chat(user, "<span class='notice'>You slash \the [src] with \the [EB]; the thermite ignites!</span>")
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade.ogg', 50, 1)

			thermitemelt(user)
			return

	if(!istype(W, /obj/item/reagent_containers))
		return attack_hand(user)

/turf/simulated/wall/shuttle/cardinal
	smooth = SMOOTH_TRUE

/turf/simulated/wall/shuttle/dark
	icon = 'icons/turf/smooth/shuttle_wall_dark.dmi'
	canSmoothWith = null

/turf/simulated/wall/shuttle/dark/cardinal
	smooth = SMOOTH_TRUE
	canSmoothWith = null

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

/turf/simulated/wall/shuttle/Initialize(mapload)
	. = ..(mapload,"skrell")

/turf/simulated/wall/shuttle/skrell/cardinal
	smooth = SMOOTH_MORE

/turf/simulated/wall/shuttle/skrell/corner
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "skrell_diagonal"
	use_set_icon_state = 1
	smooth = null
	canSmoothWith = null


//--Floors--//

/turf/simulated/floor/shuttle
	name = "shuttle floor"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "floor"
	roof_flags = ROOF_CLEANUP
	permit_ao = 0
	initial_flooring = /decl/flooring/shuttle
	footstep_sound = "plating"

/turf/simulated/floor/shuttle/yellow
	icon_state = "floor2"
	initial_flooring = /decl/flooring/shuttle/yellow

/turf/simulated/floor/shuttle/white
	icon_state = "floor3"
	initial_flooring = /decl/flooring/shuttle/white

/turf/simulated/floor/shuttle/red
	icon_state = "floor4"
	initial_flooring = /decl/flooring/shuttle/red

/turf/simulated/floor/shuttle/dark_red
	icon_state = "floor6"
	initial_flooring = /decl/flooring/shuttle/dark_red

/turf/simulated/floor/shuttle/black
	icon_state = "floor7"
	initial_flooring = /decl/flooring/shuttle/black

/turf/simulated/floor/shuttle/tan
	icon_state = "floor8"
	initial_flooring = /decl/flooring/shuttle/tan

/turf/simulated/floor/shuttle/dark_blue
	icon_state = "floor9"
	initial_flooring = /decl/flooring/shuttle/dark_blue

/turf/simulated/floor/shuttle/advanced
	icon_state = "advanced_plating"
	initial_flooring = /decl/flooring/shuttle/advanced

/turf/simulated/floor/shuttle/advanced/alt
	icon_state = "advanced_plating_alt"
	initial_flooring = /decl/flooring/shuttle/advanced/alt

/turf/simulated/floor/shuttle/skrell
	icon_state = "skrell_purple"
	initial_flooring = /decl/flooring/shuttle/skrell
	footstep_sound = "sandstep"

/turf/simulated/floor/shuttle/skrell/blue
	icon_state = "skrell_blue"
	initial_flooring = /decl/flooring/shuttle/skrell/blue

/turf/simulated/floor/shuttle/skrell/ramp
	name = "footramp"
	icon_state = "skrellramp-bottom"
	initial_flooring = /decl/flooring/shuttle/skrell/ramp

/turf/simulated/floor/shuttle/skrell/ramp/top
	icon_state = "skrellramp-top"
	initial_flooring = /decl/flooring/shuttle/skrell/ramp/top

//--Roofs--//

/turf/simulated/shuttle_roof
	name = "shuttle roof"
	icon = 'icons/turf/smooth/roof_white.dmi'
	icon_state = "roof_white"
	smooth = SMOOTH_DIAGONAL|SMOOTH_TRUE
	smooth_underlays = TRUE
	oxygen = 0
	nitrogen = 0
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
