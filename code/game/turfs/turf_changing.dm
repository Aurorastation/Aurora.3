/turf
	var/tmp/changing_turf
	var/openspace_override_type	// If defined, this type is spawned instead of openturfs.

/turf/proc/ReplaceWithLattice()
	ChangeTurf(baseturf)
	new /obj/structure/lattice(src)

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		qdel(L)

// Called after turf replaces old one
/turf/proc/post_change()
	levelupdate()
	if (above)
		above.update_mimic()

	queue_smooth_neighbors(src)

// Helper to change this turf into an appropriate openturf type, generally you should use this instead of ChangeTurf(/turf/simulated/open).
/turf/proc/ChangeToOpenturf()
	. = ChangeTurf(/turf/space)

//Creates a new turf.
// N is the type of the turf.
/turf/proc/ChangeTurf(N, tell_universe = TRUE, force_lighting_update = FALSE)
	if (!N)
		return
	if(!use_preloader && N == type) // Don't no-op if the map loader requires it to be reconstructed
		return src

	// This makes sure that turfs are not changed to space when there's a multi-z turf below
	if(N == /turf/space && HasBelow(z))
		N = openspace_override_type || /turf/simulated/open/airless

	var/obj/fire/old_fire = fire
	var/old_baseturf = baseturf
	var/old_above = above
	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
	var/list/old_affecting_lights = affecting_lights
	var/old_lighting_overlay = lighting_overlay
	var/list/old_corners = corners

	changing_turf = TRUE

	if(connections)
		connections.erase_all()

	// So we call destroy.
	qdel(src)

	var/turf/simulated/W = new N(src)

#ifndef AO_USE_LIGHTING_OPACITY
	// If we're using opacity-based AO, this is done in recalc_atom_opacity().
	if (permit_ao)
		regenerate_ao()
#endif

	recalc_atom_opacity()
	lighting_overlay = old_lighting_overlay
	if (lighting_overlay && lighting_overlay.loc != src)
		// This is a hack, but I can't figure out why the fuck they're not on the correct turf in the first place.
		lighting_overlay.forceMove(src, harderforce = TRUE)
		
	affecting_lights = old_affecting_lights
	corners = old_corners

	if ((old_opacity != opacity) || (dynamic_lighting != old_dynamic_lighting) || force_lighting_update)
		reconsider_lights()

	if (dynamic_lighting != old_dynamic_lighting)
		if (dynamic_lighting)
			lighting_build_overlay()
		else
			lighting_clear_overlay()

	if (config.starlight)
		for (var/turf/space/S in RANGE_TURFS(1, src))
			S.update_starlight()

	W.above = old_above

	if(ispath(N, /turf/simulated))
		if(old_fire)
			fire = old_fire
		if (istype(W,/turf/simulated/floor))
			W.RemoveLattice()
	else if(old_fire)
		old_fire.RemoveFire()

	if(tell_universe)
		universe.OnTurfChange(W)

	SSair.mark_for_update(src) //handle the addition of the new turf.

	if(!W.baseturf)
		W.baseturf = old_baseturf

	W.post_change()

	. = W

/turf/proc/transport_properties_from(turf/other)
	if(!istype(other, src.type))
		return 0

	src.set_dir(other.dir)
	src.icon_state = other.icon_state
	src.icon = other.icon
	src.overlays = other.overlays.Copy()
	src.underlays = other.underlays.Copy()
	return 1

//I would name this copy_from() but we remove the other turf from their air zone for some reason
/turf/simulated/transport_properties_from(turf/simulated/other)
	if(!..())
		return 0

	if(other.zone)
		if(!src.air)
			src.make_air()
		src.air.copy_from(other.zone.air)
		other.zone.remove(other)
	return 1

// Copies this turf to other, overwriting it.
// Returns a ref to the other turf post-change.
/turf/proc/copy_turf(turf/other)
	if (other.type != type)
		. = other.ChangeTurf(type)
	else
		. = other

	if (dir != other.dir)
		other.set_dir(dir)

	other.icon = icon
	other.icon_state = icon_state
	other.underlays = underlays.Copy()

	if (our_overlays)
		other.our_overlays = our_overlays

	if (priority_overlays)
		other.priority_overlays = priority_overlays

	other.overlays = overlays.Copy()

/turf/simulated/copy_turf(turf/simulated/other, ignore_air = FALSE)
	. = ..()

	if (ignore_air || !zone || !istype(other))
		return

	if (!other.air)
		other.make_air()

	other.air.copy_from(zone.air)

	SSair.mark_for_update(other)

	other.update_icon()
