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
	layer = UNDER_PIPE_LAYER //under pipes
	var/restrict_placement = TRUE
	smooth = SMOOTH_MORE
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
	footstep_sound = /decl/sound_category/catwalk_footstep

/obj/structure/lattice/Initialize()
	. = ..()
	if (restrict_placement)
		if(!(istype(loc, /turf/space) || isopenturf(loc) || istype(loc, /turf/unsimulated/floor/asteroid)))
			return INITIALIZE_HINT_QDEL
	for(var/obj/structure/lattice/LAT in loc)
		if(LAT != src)
			qdel(LAT)
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

/obj/structure/lattice/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if (C.iswelder())
		var/obj/item/weldingtool/WT = C
		if(WT.use(0, user))
			to_chat(user, "<span class='notice'>Slicing lattice joints ...</span>")
		new /obj/item/stack/rods(src.loc)
		qdel(src)
	if (istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if (R.use(2))
			to_chat(user, "<span class='notice'>Constructing catwalk ...</span>")
			playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
			new /obj/structure/lattice/catwalk(src.loc)
			qdel(src)
		return

/obj/structure/lattice/catwalk
	name = "catwalk"
	desc = "A catwalk for easier EVA maneuvering."
	icon = 'icons/obj/smooth/catwalk.dmi'
	icon_state = "catwalk"
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
		/obj/structure/lattice/catwalk,
		/obj/structure/lattice/catwalk/indoor
	)
	var/return_amount = 3

// Special catwalk that can be placed on regular flooring.
/obj/structure/lattice/catwalk/indoor
	desc = "A floor-mounted catwalk designed to protect pipes & station wiring from passing feet."
	restrict_placement = FALSE
	can_be_unanchored = TRUE
	layer = 2.7	// Above wires.

/obj/structure/lattice/catwalk/attackby(obj/item/C, mob/user)
	if(C.iswelder())
		var/obj/item/weldingtool/WT = C
		if(!WT.use(1, user))
			to_chat(user, SPAN_WARNING("You need more welding fuel to complete this task."))
			return
		if(C.use_tool(src, user, 5, volume = 50))
			to_chat(user, SPAN_NOTICE("You slice apart [src]."))
			var/obj/item/stack/rods/R = new /obj/item/stack/rods(get_turf(src))
			R.amount = return_amount
			R.update_icon()
			qdel(src)

/obj/structure/lattice/catwalk/indoor/attackby(obj/item/C, mob/user)
	if(C.isscrewdriver())
		if(C.use_tool(src, user, 5, volume = 50))
			anchored = !anchored
			to_chat(user, SPAN_NOTICE("You [anchored ? "" : "un"]anchor [src]."))
			queue_smooth(src)
			queue_smooth_neighbors(src)
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
	icon_state = "grate_dark"
	return_amount = 1
	smooth = null
	var/base_icon_state = "grate_dark"
	var/damaged = FALSE

/obj/structure/lattice/catwalk/indoor/grate/old
	icon_state = "grate_dark_old"

/obj/structure/lattice/catwalk/indoor/grate/damaged
	icon_state = "grate_dark_dam0"
	damaged = TRUE

/obj/structure/lattice/catwalk/indoor/grate/damaged/Initialize()
	.=..()
	icon_state = "[base_icon_state]_dam[rand(0,3)]"

/obj/structure/lattice/catwalk/indoor/grate/light
	icon_state = "grate_light"
	base_icon_state = "grate_light"
	return_amount = 1

/obj/structure/lattice/catwalk/indoor/grate/light/old
	icon_state = "grate_light_old"

/obj/structure/lattice/catwalk/indoor/grate/light/damaged
	icon_state = "grate_light_dam0"
	damaged = TRUE

/obj/structure/lattice/catwalk/indoor/grate/light/damaged/Initialize()
	.=..()
	icon_state = "[base_icon_state]_dam[rand(0,3)]"

/obj/structure/lattice/catwalk/indoor/grate/attackby(obj/item/C, mob/user)
	if(C.iswelder() && damaged)
		var/obj/item/weldingtool/WT = C
		if(C.use_tool(src, user, 5, volume = 50) && WT.use(1, user))
			to_chat(user, SPAN_NOTICE("You slice apart the [src] leaving nothing useful behind."))
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
