/obj/structure/lattice
	name = "lattice"
	desc = "A lightweight support lattice."
	icon = 'icons/obj/smooth/lattice.dmi'
	icon_state = "lattice"
	density = 0
	anchored = 1.0
	w_class = 3
	layer = 2.3 //under pipes
	//	flags = CONDUCT
	smooth = SMOOTH_MORE
	canSmoothWith = list(
		/obj/structure/lattice,
		/turf/simulated/wall,
		/turf/simulated/floor,
		/turf/simulated/mineral,
		/obj/structure/grille
	)

/obj/structure/lattice/Initialize()
	. = ..()
///// Z-Level Stuff
	if(!(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open) || istype(src.loc, /turf/simulated/floor/asteroid)))
///// Z-Level Stuff
		return INITIALIZE_HINT_QDEL
	for(var/obj/structure/lattice/LAT in src.loc)
		if(LAT != src)
			qdel(LAT)

/obj/structure/lattice/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			return
		else
	return

/obj/structure/lattice/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/tile/floor))
		var/turf/T = get_turf(src)
		T.attackby(C, user) //BubbleWrap - hand this off to the underlying turf instead
		return
	if (istype(C, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			user << "<span class='notice'>Slicing lattice joints ...</span>"
		new /obj/item/stack/rods(src.loc)
		qdel(src)
