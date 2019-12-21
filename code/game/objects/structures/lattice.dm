/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/smooth/lattice.dmi'
	icon_state = "lattice"
	density = FALSE
	anchored = TRUE
	w_class = 3
	layer = 2.3 //under pipes
	//	flags = CONDUCT
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

/obj/structure/lattice/Initialize()
	. = ..()
	if (restrict_placement)
		if(!(istype(loc, /turf/space) || isopenturf(loc) || istype(loc, /turf/unsimulated/floor/asteroid)))
			return INITIALIZE_HINT_QDEL
	for(var/obj/structure/lattice/LAT in loc)
		if(LAT != src)
			qdel(LAT)

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
		if(WT.remove_fuel(0, user))
			to_chat(user, "<span class='notice'>Slicing lattice joints ...</span>")
		new /obj/item/stack/rods(src.loc)
		qdel(src)
	if (istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
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
	smooth = SMOOTH_MORE
	canSmoothWith = list(/obj/structure/lattice/catwalk)

// Special catwalk that can be placed on regular flooring.
/obj/structure/lattice/catwalk/indoor
	desc = "A floor-mounted catwalk designed to protect pipes & station wiring from passing feet."
	restrict_placement = FALSE
	can_be_unanchored = TRUE
	layer = 2.7	// Above wires.

/obj/structure/lattice/catwalk/attackby(obj/item/C, mob/user)
	if (C.iswelder())
		var/obj/item/weldingtool/WT = C
		if (do_after(user, 5/C.toolspeed, act_target = src) && WT.remove_fuel(1, user))
			to_chat(user, "<span class='notice'>You slice apart [src].</span>")
			playsound(src, 'sound/items/Welder.ogg', 50, 1)
			new /obj/item/stack/rods{amount = 3}(loc)
			qdel(src)

/obj/structure/lattice/catwalk/indoor/attackby(obj/item/C, mob/user)
	if (C.isscrewdriver())
		anchored = !anchored
		to_chat(user, "<span class='notice'>You [anchored ? "" : "un"]anchor [src].</span>")
		playsound(src, C.usesound, 50, 1)
		queue_smooth(src)
		queue_smooth_neighbors(src)
	else
		..()

/obj/structure/lattice/catwalk/hoist_act(turf/dest)
	for (var/A in loc)
		var/atom/movable/AM = A
		AM.forceMove(dest)
	..()
