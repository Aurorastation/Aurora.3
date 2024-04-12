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
/turf/proc/post_change(queue_neighbors = TRUE)
	levelupdate()
	if (above)
		above.update_mimic()

	if(queue_neighbors)
		SSicon_smooth.add_to_queue_neighbors(src)
	else if(smoothing_flags && !(smoothing_flags & SMOOTH_QUEUED)) // we check here because proc overhead
		SSicon_smooth.add_to_queue(src)

	if (SSatlas.current_map.use_overmap)
		var/obj/effect/overmap/visitable/sector/exoplanet/E = GLOB.map_sectors["[z]"]
		if (istype(E) && istype(E.theme))
			E.theme.on_turf_generation(src, E.planetary_area)

// Helper to change this turf into an appropriate openturf type, generally you should use this instead of ChangeTurf(/turf/simulated/open).
/turf/proc/ChangeToOpenturf()
	. = ChangeTurf(/turf/space)

//Creates a new turf.
// N is the type of the turf.
/turf/proc/ChangeTurf(N, tell_universe = TRUE, force_lighting_update = FALSE, ignore_override = FALSE, mapload = FALSE)
	if (!N)
		return

	// This makes sure that turfs are not changed to space when there's a multi-z turf below
	if(ispath(N, /turf/space) && HasBelow(z) && !ignore_override)
		N = openspace_override_type || /turf/simulated/open/airless

	var/obj/fire/old_fire = fire
	var/old_baseturf = baseturf
	var/old_above = above
	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
	var/list/old_affecting_lights = affecting_lights
	var/old_lighting_overlay = lighting_overlay
	var/list/old_corners = corners
	var/list/old_blueprints = blueprints
	var/list/old_decals = decals
	var/old_outside = is_outside
	var/old_is_open = is_open()

	changing_turf = TRUE

	if(connections)
		connections.erase_all()

	// So we call destroy.
	qdel(src)

	var/turf/W = new N(src)

#ifndef AO_USE_LIGHTING_OPACITY
	// If we're using opacity-based AO, this is done in recalc_atom_opacity().
	if (permit_ao)
		regenerate_ao()
#endif

	if(lighting_overlays_initialized)
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

		if (GLOB.config.starlight)
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
		GLOB.universe.OnTurfChange(W)

	// we check the var rather than the proc, because area outside values usually shouldn't be set on turfs
	W.last_outside_check = OUTSIDE_UNCERTAIN
	if(W.is_outside != old_outside)
		W.set_outside(old_outside, skip_weather_update = TRUE)

	SSair.mark_for_update(src) //handle the addition of the new turf.

	if(!W.baseturf)
		W.baseturf = old_baseturf

	W.blueprints = old_blueprints
	for(var/image/I as anything in W.blueprints)
		I.loc = W
		I.plane = 0

	W.decals = old_decals

	W.post_change(!mapload)

	W.update_weather(force_update_below = W.is_open() != old_is_open)

	. = W

	for(var/turf/T in RANGE_TURFS(1, src))
		T.update_icon()

/turf/proc/transport_properties_from(turf/other)
	if(!istype(other, src.type))
		return 0

	src.set_dir(other.dir)
	src.icon_state = other.icon_state
	src.icon = other.icon
	src.overlays = other.overlays.Copy()
	src.underlays = other.underlays.Copy()
	if(other.decals)
		src.decals = other.decals.Copy()
		other.decals.Cut()
		other.update_icon()
		src.update_icon()
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
	other.name = name
	other.layer = layer
	other.decals = decals
	other.roof_flags = roof_flags
	other.roof_type = roof_type

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

/turf/simulated/wall/copy_turf(turf/simulated/wall/other, ignore_air = FALSE)
	.=..()
	other.damage = damage

/turf/simulated/floor/copy_turf(turf/simulated/floor/other, ignore_air = FALSE)
	.=..()
	other.flooring = flooring

/turf/simulated/wall/shuttle/dark/corner/underlay/copy_turf(turf/simulated/wall/shuttle/dark/corner/underlay/other, ignore_air = FALSE)
	.=..()
	other.underlay_dir = underlay_dir
