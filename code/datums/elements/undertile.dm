/// The alpha used for hidden underfloor objects that should still have a T-ray/blueprint silhouette.
#define ALPHA_UNDERTILE 128

/// Add to an object if it should follow underfloor visibility rules.
/datum/element/undertile
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2

	/// Trait applied while fully hidden, such as TRAIT_T_RAY_VISIBLE.
	var/invisibility_trait
	/// Invisibility level applied while fully hidden.
	var/invisibility_level
	/// Optional turf overlay applied while covered.
	var/tile_overlay
	/// Whether hidden objects should be faded for scanners/blueprints.
	var/use_alpha

/datum/element/undertile/Attach(datum/target, invisibility_trait, invisibility_level = INVISIBILITY_MAXIMUM, tile_overlay, use_alpha = TRUE)
	. = ..()

	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_OBJ_HIDE, PROC_REF(hide))

	src.invisibility_trait = invisibility_trait
	src.invisibility_level = invisibility_level
	src.tile_overlay = tile_overlay
	src.use_alpha = use_alpha

/datum/element/undertile/proc/hide(atom/movable/source, underfloor_accessibility)
	SIGNAL_HANDLER

	var/turf/turf = get_turf(source)

	if(isobj(source))
		var/obj/source_obj = source
		if(!source_obj.uses_undertile())
			source.set_invisibility(initial(source.invisibility))
			SET_PLANE_IMPLICIT(source, source.undertile_restored_plane())
			source.layer = source.undertile_restored_layer()
			REMOVE_TRAIT(source, TRAIT_UNDERFLOOR, REF(src))
			if(invisibility_trait)
				REMOVE_TRAIT(source, invisibility_trait, REF(src))
			if(use_alpha)
				source.alpha = initial(source.alpha)
			SEND_SIGNAL(source, COMSIG_UNDERTILE_UPDATED)
			return

	if(underfloor_accessibility < UNDERFLOOR_VISIBLE)
		source.set_invisibility(invisibility_level)
	else
		source.set_invisibility(initial(source.invisibility))

	if(underfloor_accessibility < UNDERFLOOR_INTERACTABLE)
		if(PLANE_TO_TRUE(source.plane) != FLOOR_PLANE)
			SET_PLANE_IMPLICIT(source, FLOOR_PLANE)

		source.layer = source.undertile_layer()

		ADD_TRAIT(source, TRAIT_UNDERFLOOR, REF(src))

		if(tile_overlay && turf)
			turf.AddOverlays(tile_overlay)

		if(underfloor_accessibility < UNDERFLOOR_VISIBLE)
			if(use_alpha)
				source.alpha = ALPHA_UNDERTILE

			if(invisibility_trait)
				ADD_TRAIT(source, invisibility_trait, REF(src))
	else
		SET_PLANE_IMPLICIT(source, source.undertile_restored_plane())
		source.layer = source.undertile_restored_layer()
		REMOVE_TRAIT(source, TRAIT_UNDERFLOOR, REF(src))

		if(invisibility_trait)
			REMOVE_TRAIT(source, invisibility_trait, REF(src))

		if(tile_overlay && turf)
			turf.overlays -= tile_overlay

		if(use_alpha)
			source.alpha = initial(source.alpha)

	SEND_SIGNAL(source, COMSIG_UNDERTILE_UPDATED)

/datum/element/undertile/Detach(atom/movable/source, invisibility_trait, invisibility_level = INVISIBILITY_MAXIMUM)
	. = ..()

	hide(source, UNDERFLOOR_INTERACTABLE)
	source.set_invisibility(initial(source.invisibility))

#undef ALPHA_UNDERTILE
