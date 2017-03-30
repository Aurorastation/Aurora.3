/atom
	var/initialized = FALSE

/atom/New(loc, ...)
	//. = ..() //uncomment if you are dumb enough to add a /datum/New() proc

	var/do_initialize = SSatoms.initialized
	if(do_initialize > INITIALIZATION_INSSATOMS)
		if(QDELETED(src))
			CRASH("Found new qdeletion in type [type]!")
		var/mapload = do_initialize == INITIALIZATION_INNEW_MAPLOAD
		args[1] = mapload
		if(Initialize(arglist(args)) && mapload)
			LAZYADD(SSatoms.late_loaders, src)

/atom/proc/Initialize(mapload, ...)
	if(initialized)
		crash_with("Warning: [src]([type]) initialized multiple times!")
	initialized = TRUE

	if (light_power && light_range)
		update_light()

	if (opacity && isturf(loc))
		var/turf/T = loc
		T.has_opaque_atom = TRUE // No need to recalculate it in this case, it's guaranteed to be on afterwards anyways.
