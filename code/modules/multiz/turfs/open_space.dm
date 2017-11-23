/**
 * Open turf class.
 *
 * All atoms are able to pass through this, and also to see under it.
 */
/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = "opendebug"
	plane = PLANE_SPACE_BACKGROUND
	density = 0
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts
	is_hole = TRUE
	flags = MIMIC_BELOW | MIMIC_OVERWRITE

	roof_type = null

	// A lazy list to contain a list of mobs who are currently scaling
	// up this turf. Used in human/can_fall.

	var/tmp/list/climbers


	var/no_mutate = FALSE	// If TRUE, SSopenturf will not modify the appearance of this turf.

// An override of turf/Enter() to make it so that magboots allow you to stop
// falling off the damned rock.
/turf/simulated/open/Enter(mob/living/carbon/human/mover, atom/oldloc)
	if (istype(mover) && isturf(oldloc))
		if (mover.Check_Shoegrip(FALSE) && mover.can_fall(below, src))
			to_chat(mover, span("notice",
				"You are stopped from falling off the edge by \the [mover.shoes] you're wearing!"))
			return FALSE

	return ..()

// Add a falling atom by default. Even if it's not an atom that can actually fall.
// SSfalling will check this on its own and remove if necessary. This is saner, as it
// centralizes control to SSfalling.
/turf/simulated/open/Entered(atom/movable/mover)
	..()
	if (is_hole)
		ADD_FALLING_ATOM(mover)

// Override to deny a climber exit if they're set to adhere to CLIMBER_NO_EXIT
/turf/simulated/open/Exit(atom/movable/mover, atom/newloc)
	var/flags = remove_climber(mover)

	if (flags & CLIMBER_NO_EXIT)
		if (is_hole)
			ADD_FALLING_ATOM(mover)
		return FALSE

	return ..()

// Remove from climbers just in case.
/turf/simulated/open/Exited(atom/movable/mover, atom/newloc)
	..()
	LAZYREMOVE(climbers, mover)

/turf/simulated/open/Destroy()
	LAZYCLEARLIST(climbers)
	UNSETEMPTY(climbers)
	return ..()

/turf/simulated/open/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.appearance = src
	return TRUE

/**
 * Used to add a climber to the climbers list. Climbers do not fall down this specific tile.
 *
 * @param climber The atom to be added as a climber.
 * @param flags Bitflags to control the status of the climber. Should always be non-0!
 *
 * @return TRUE if a climber was successfully added. FALSE if the climber is already
 * present or an error occured.
 */
/turf/simulated/open/proc/add_climber(atom/climber, flags = CLIMBER_DEFAULT)
	if (!flags)
		PROCLOG_WEIRD("Attempted to add climber [climber] without flags.")
		return FALSE

	if (LAZYACCESS(climbers, climber))
		return FALSE

	LAZYINITLIST(climbers)
	climbers[climber] = flags
	return TRUE

/**
 * Used to remove a climber from the climbers list. Returns the flags the climber
 * was assigned.
 *
 * @param climber The atom to be removed from climbers.
 *
 * @return The flags assigned to the climber if it was present in the list. 0 otherwise.
 */
/turf/simulated/open/proc/remove_climber(atom/climber)
	. = 0

	if (LAZYACCESS(climbers, climber))
		. = climbers[climber]
		LAZYREMOVE(climbers, climber)

/turf/simulated/open/airless
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/open/post_change()
	..()
	update()

/turf/simulated/open/Initialize()
	. = ..()
	icon_state = ""	// Clear out the debug icon.
	update()

/**
 * Updates the turf with open turf's variables and basically resets it properly.
 */
/turf/simulated/open/proc/update()
	levelupdate()
	if (is_hole)
		for (var/atom/movable/A in src)
			ADD_FALLING_ATOM(A)
	update_icon()

/turf/simulated/open/update_dirt()
	return 0

// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/update_icon()
	update_mimic()

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
	if(iscoil(C))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
		return
	return

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return TRUE
