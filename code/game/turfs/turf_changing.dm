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
		QUEUE_SMOOTH_NEIGHBORS(src)
	else if(smoothing_flags && !(smoothing_flags & SMOOTH_QUEUED)) // we check here because proc overhead
		QUEUE_SMOOTH(src)

	if (SSatlas.current_map.use_overmap)
		// exoplanet
		var/obj/effect/overmap/visitable/sector/exoplanet/exoplanet = GLOB.map_sectors["[z]"]
		if (istype(exoplanet) && istype(exoplanet.theme))
			exoplanet.theme.on_turf_generation(src, exoplanet.planetary_area)
		// away site
		var/datum/map_template/ruin/away_site/away_site = GLOB.map_templates["[z]"]
		if (istype(away_site) && istype(away_site.exoplanet_theme_base))
			away_site.exoplanet_theme_base.on_turf_generation(src, null)

// Helper to change this turf into an appropriate openturf type, generally you should use this instead of ChangeTurf(/turf/simulated/open).
/turf/proc/ChangeToOpenturf()
	. = ChangeTurf(/turf/space)

//Creates a new turf
/turf/proc/ChangeTurf(path, tell_universe = TRUE, force_lighting_update = FALSE, ignore_override = FALSE, mapload = FALSE)
	if (!path)
		return

	// This makes sure that turfs are not changed to space when there's a multi-z turf below
	if(ispath(path, /turf/space) && GET_TURF_BELOW(src) && !ignore_override)
		path = openspace_override_type || /turf/simulated/open/airless

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
	var/list/old_resources = resources ? resources.Copy() : null

	changing_turf = TRUE

	if(connections)
		connections.erase_all()

	// So we call destroy.
	qdel(src)

	//We do this here so anything that doesn't want to persist can clear itself
	var/list/old_listen_lookup = _listen_lookup?.Copy()
	var/list/old_signal_procs = _signal_procs?.Copy()

	var/turf/new_turf = new path(src)

	// WARNING WARNING
	// Turfs DO NOT lose their signals when they get replaced, REMEMBER THIS
	// It's possible because turfs are fucked, and if you have one in a list and it's replaced with another one, the list ref points to the new turf
	if(old_listen_lookup)
		LAZYOR(new_turf._listen_lookup, old_listen_lookup)
	if(old_signal_procs)
		LAZYOR(new_turf._signal_procs, old_signal_procs)

#ifndef AO_USE_LIGHTING_OPACITY
	// If we're using opacity-based AO, this is done in recalc_atom_opacity().
	if (permit_ao)
		regenerate_ao()
#endif

	if(GLOB.lighting_overlays_initialized)
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

	new_turf.above = old_above

	if(ispath(path, /turf/simulated))
		if(old_fire)
			fire = old_fire
		if (istype(new_turf, /turf/simulated/floor))
			new_turf.RemoveLattice()
	else if(old_fire)
		old_fire.RemoveFire()

	if(tell_universe)
		GLOB.universe.OnTurfChange(new_turf)

	// we check the var rather than the proc, because area outside values usually shouldn't be set on turfs
	new_turf.last_outside_check = OUTSIDE_UNCERTAIN
	if(new_turf.is_outside != old_outside)
		new_turf.set_outside(old_outside, skip_weather_update = TRUE)

	SSair.mark_for_update(src) //handle the addition of the new turf.

	if(!new_turf.baseturf)
		new_turf.baseturf = old_baseturf

	new_turf.blueprints = old_blueprints
	for(var/image/I as anything in new_turf.blueprints)
		I.loc = new_turf
		I.plane = 0

	new_turf.decals = old_decals

	new_turf.post_change(!mapload)

	new_turf.update_weather(force_update_below = new_turf.is_open() != old_is_open)

	new_turf.resources = old_resources

	. = new_turf

	for(var/turf/T in RANGE_TURFS(1, src))
		T.update_icon()

	updateVisibility(src, FALSE)

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

	if (atom_overlay_cache)
		other.atom_overlay_cache = atom_overlay_cache

	if (atom_protected_overlay_cache)
		other.atom_protected_overlay_cache = atom_protected_overlay_cache

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
