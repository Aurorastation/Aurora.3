/turf/simulated/floor/exoplanet/abyss
	name = "abyss"
	desc = "It stares back at you."
	icon = 'icons/turf/smooth/abyss.dmi'
	smoothing_flags = SMOOTH_TRUE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	smoothing_hints = SMOOTHHINT_CUT_F | SMOOTHHINT_ONLY_MATCH_TURF | SMOOTHHINT_TARGETS_NOT_UNIQUE
	icon_state = "smooth"
	var/static/list/forbidden_types = typecacheof(list(
		/obj/singularity,
		/obj/structure/lattice,
		/obj/projectile,
		/obj/effect,
		/obj/machinery/light,
		/obj/structure/railing,
		/obj/structure/stairs_railing,
		/obj/structure/platform,
		/obj/structure/platform_deco,
		/obj/structure/extinguisher_cabinet,
		/obj/structure/sign,
		/obj/machinery/atmospherics/pipe
		))
	has_resources = FALSE

/turf/simulated/floor/exoplanet/abyss/Initialize()
	. = ..()
	icon_state = "Fill"

/turf/simulated/floor/exoplanet/abyss/Entered(atom/movable/AM, atom/oldloc)
	if(is_type_in_typecache(AM, forbidden_types))
		return TRUE

	else if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(locate(/obj/structure/lattice, src))	// Should be safe to walk upon.
			return TRUE
		if(!L.CanAvoidGravity())
			L.visible_message(SPAN_DANGER("\The [L] falls into \the [src]."), SPAN_DANGER("You plummet down into \the [src]!"))
			L.death()
			if(L)
				L.loc = null
				qdel(L)
		else
			return TRUE


	else if(istype(AM, /obj/item) || istype(AM, /obj/structure) || istype(AM, /obj/machinery))
		if(locate(/obj/structure/lattice, src))	// Should be safe to be placed upon.
			return TRUE
		var/obj/O = AM
		O.visible_message(SPAN_DANGER("\The [O] falls into \the [src]."))
		qdel(O)

	else
		..()

/turf/simulated/floor/exoplanet/abyss/is_open()
	return TRUE
