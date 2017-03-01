/turf/proc/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		return direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			return 0
		if(direction == DOWN) //on a turf above, trying to enter
			return !density

/turf/simulated/open/CanZPass(atom, direction)
	return 1

/turf/space/CanZPass(atom, direction)
	return 1

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	plane = PLANE_SPACE_BACKGROUND
	density = 0
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts
	mouse_opacity = 0	// Overlays will handle mouse interaction.

	var/turf/below
	var/list/openspace_overlays
	var/updating = FALSE

/turf/simulated/open/post_change()
	..()
	update()

/turf/simulated/open/initialize()
	..()
	update()

/turf/simulated/open/proc/update()
	below = GetBelow(src)
	levelupdate()
	for(var/atom/movable/A in src)
		A.fall()
	update_icon()

/turf/simulated/open/update_dirt()
	return 0

/turf/simulated/open/Entered(var/atom/movable/mover)
	..()
	mover.fall()

// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/update_icon()
	if(!updating && below)
		updating = TRUE
		openturf_update_queue += src

/turf/simulated/open/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>You lay down the support lattice.</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(locate(src.x, src.y, src.z))
		return

	if (istype(C, /obj/item/stack/tile))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless)
			return
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")

	//To lay cable.
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
		return
	return

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return 1
