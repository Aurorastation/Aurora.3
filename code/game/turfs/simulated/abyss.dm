/turf/simulated/abyss
	name = "abyss"
	desc = "It stares back at you."
	icon = 'icons/turf/smooth/abyss.dmi'
	smooth = SMOOTH_TRUE | SMOOTH_BORDER | SMOOTH_NO_CLEAR_ICON
	smoothing_hints = SMOOTHHINT_CUT_F | SMOOTHHINT_ONLY_MATCH_TURF | SMOOTHHINT_TARGETS_NOT_UNIQUE
	icon_state = "smooth"
	var/static/list/forbidden_types = typecacheof(list(
		/obj/singularity,
		/obj/structure/lattice,
		/obj/item/projectile,
		/obj/effect
		))

/turf/simulated/abyss/Initialize()
	. = ..()
	icon_state = "Fill"

/turf/simulated/abyss/Entered(atom/movable/AM, atom/oldloc)
	if(is_type_in_typecache(forbidden_types))
		return TRUE

	else if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(locate(/obj/structure/lattice/catwalk, src))	//should be safe to walk upon
			return TRUE
		if(!L.CanAvoidGravity())
			L.visible_message(SPAN_DANGER("\The [L] falls into \the [src]."), SPAN_DANGER("You plummet down into \the [src]!"))
			L.death()
			if(L)
				L.loc = null
				qdel(L)
		else
			return TRUE


	else if(istype(AM, /obj/item))
		var/obj/item/I = AM
		I.visible_message(SPAN_DANGER("\The [I] falls into \the [src]."))
		qdel(I)

	else
		..()
