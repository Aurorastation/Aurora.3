/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	desc_info = "Add a metal floor tile to build a floor on top of the lattice.<br>\
	Lattices can be made by applying metal rods to a space tile."
	icon = 'icons/obj/smooth/lattice.dmi'
	icon_state = "lattice"
	density = FALSE
	anchored = TRUE
	w_class = ITEMSIZE_NORMAL
	layer = LATTICE_LAYER
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	smoothing_flags = SMOOTH_MORE
	canSmoothWith = list(
		/obj/structure/lattice,
		/turf/simulated/wall,
		/turf/simulated/floor,
		/turf/simulated/mineral,
		/turf/unsimulated/wall,
		/turf/unsimulated/floor,
		/obj/structure/grille,
		/turf/unsimulated/mineral/asteroid
	)
	footstep_sound = /singleton/sound_category/catwalk_footstep

/obj/structure/lattice/Initialize()
	. = ..()
	for(var/obj/structure/lattice/LAT in loc)
		if(LAT == src)
			continue
		stack_trace("multiple lattices found in ([loc.x], [loc.y], [loc.z])")
		return INITIALIZE_HINT_QDEL

	if(isturf(loc))
		var/turf/turf = loc
		turf.is_hole = FALSE

/obj/structure/lattice/Destroy()
	if(isturf(loc))
		var/turf/turf = loc
		turf.is_hole = initial(turf.is_hole)
	return ..()

/obj/structure/lattice/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			qdel(src)
	return

/obj/structure/lattice/attackby(obj/item/attacking_item, mob/user)
	if (istype(attacking_item, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(attacking_item, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if (attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(WT.use(1, user))
			to_chat(user, "<span class='notice'>Slicing lattice joints ...</span>")
		new /obj/item/stack/rods(src.loc)
		qdel(src)
	if (istype(attacking_item, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = attacking_item
		if (R.use(2))
			to_chat(user, "<span class='notice'>Constructing catwalk ...</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice/catwalk(src.loc)
			qdel(src)
		return

/obj/structure/lattice/catwalk
	name = "catwalk"
	desc = "A catwalk for easier EVA maneuvering."
	icon = 'icons/obj/smooth/catwalk.dmi'
	icon_state = "catwalk"
	smoothing_flags = SMOOTH_TRUE
	canSmoothWith = list(
		/obj/structure/lattice/catwalk,
		/obj/structure/lattice/catwalk/indoor
	)
	var/return_amount = 3

// Special catwalk that can be placed on regular flooring.
/obj/structure/lattice/catwalk/indoor
	desc = "A floor-mounted catwalk designed to protect pipes & station wiring from passing feet."
	can_be_unanchored = TRUE
	layer = CATWALK_LAYER

/obj/structure/lattice/catwalk/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswelder())
		var/obj/item/weldingtool/WT = attacking_item
		if(!WT.use(1, user))
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return
		if(attacking_item.use_tool(src, user, 5, volume = 50))
			to_chat(user, SPAN_NOTICE("You slice apart [src]."))
			var/obj/item/stack/rods/R = new /obj/item/stack/rods(get_turf(src))
			R.amount = return_amount
			R.update_icon()
			qdel(src)

/obj/structure/lattice/catwalk/indoor/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		if(attacking_item.use_tool(src, user, 5, volume = 50))
			anchored = !anchored
			to_chat(user, SPAN_NOTICE("You [anchored ? "" : "un"]anchor [src]."))
			SSicon_smooth.add_to_queue(src)
			SSicon_smooth.add_to_queue_neighbors(src)
	else
		..()

/obj/structure/lattice/catwalk/hoist_act(turf/dest)
	for (var/A in loc)
		var/atom/movable/AM = A
		AM.forceMove(dest)
	..()

/obj/structure/lattice/catwalk/indoor/grate
	name = "grate"
	desc = "A metal grate."
	icon = 'icons/obj/grate.dmi'
	icon_state = "grate"
	return_amount = 1
	smoothing_flags = null
	color = COLOR_TILED
	var/base_icon_state = "grate"
	var/damaged = FALSE

/obj/structure/lattice/catwalk/indoor/grate/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswelder() && damaged)
		var/obj/item/weldingtool/WT = attacking_item
		if(attacking_item.use_tool(src, user, 5, volume = 50) && WT.use(1, user))
			user.visible_message(
				SPAN_NOTICE("\The [user] slices apart \the [src], leaving nothing useful behind."),
				SPAN_NOTICE("You slice apart \the [src], leaving nothing useful behind."),
				SPAN_NOTICE("You hear the sound of a welder, slicing apart metal.")
			)
			playsound(src, 'sound/items/welder.ogg', 50, 1)
			qdel(src)
	else
		..()

/obj/structure/lattice/catwalk/indoor/grate/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if(!damaged)
				icon_state = "[base_icon_state]_dam[rand(0,3)]"
				damaged = TRUE
			else
				qdel(src)
	return

/obj/structure/lattice/catwalk/indoor/grate/old/Initialize()
	. = ..()
	add_overlay("rust")

/obj/structure/lattice/catwalk/indoor/grate/damaged
	icon_state = "grate_dark_dam0"
	damaged = TRUE

/obj/structure/lattice/catwalk/indoor/grate/damaged/Initialize()
	. = ..()
	icon_state = "[base_icon_state]_dam[rand(0,3)]"

/obj/structure/lattice/catwalk/indoor/grate/light
	icon_state = "grate_light"
	base_icon_state = "grate_light"
	return_amount = 1
	color = COLOR_GRAY50

/obj/structure/lattice/catwalk/indoor/grate/light/old/Initialize()
	. = ..()
	add_overlay("rust")

/obj/structure/lattice/catwalk/indoor/grate/light/damaged
	icon_state = "grate_light_dam0"
	damaged = TRUE

/obj/structure/lattice/catwalk/indoor/grate/light/damaged/Initialize()
	. = ..()
	icon_state = "[base_icon_state]_dam[rand(0,3)]"

/obj/structure/lattice/catwalk/indoor/grate/dark
	color = COLOR_DARK_GUNMETAL

/obj/structure/lattice/catwalk/indoor/grate/gunmetal
	color = COLOR_DARK_GUNMETAL

/obj/structure/lattice/catwalk/indoor/grate/slate
	color = COLOR_SLATE

/obj/structure/lattice/catwalk/indoor/urban
	name = "grate"
	desc = "A metal grate."
	icon = 'icons/obj/structure/over_turf.dmi'
	icon_state = "city_grate"
	return_amount = 1
	smoothing_flags = null

/obj/structure/lattice/catwalk/indoor/tatami
	name = "tatami spread"
	desc = "A straw mat rug of some sort, frequently referred to as a tatami."
	icon = 'icons/obj/structure/over_turf.dmi'
	icon_state = "tatami"
	return_amount = null
	smoothing_flags = null
	footstep_sound = /singleton/sound_category/carpet_footstep

/obj/structure/lattice/catwalk/indoor/planks
	name = "flooring plank"
	desc = "A ricket assortment of planks meant to be stood upon."
	icon = 'icons/obj/structure/urban/wood.dmi'
	icon_state = "plank"
	return_amount = null
	smoothing_flags = null
	footstep_sound = /singleton/sound_category/wood_footstep

/obj/structure/lattice/catwalk/indoor/planks/opaque
	icon_state = "plank_dark"

/obj/structure/lattice/catwalk/indoor/planks/stairs
	icon_state = "plank_stairs"

/obj/structure/lattice/catwalk/indoor/planks/deep
	icon_state = "plank_deep"
