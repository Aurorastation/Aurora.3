/atom
	///First atom flags var
	var/flags_1 = NONE

	var/update_icon_on_init	// Default to 'no'.

/atom/Destroy(force = FALSE)
	if (reagents)
		QDEL_NULL(reagents)

	//We're being destroyed, no need to update the icon
	SSicon_update.remove_from_queue(src)

	LAZYCLEARLIST(our_overlays)
	LAZYCLEARLIST(priority_overlays)

	QDEL_NULL(light)

	if (orbiters)
		for (var/thing in orbiters)
			var/datum/orbit/O = thing
			if (O.orbiter)
				O.orbiter.stop_orbit()

	if(length(overlays))
		overlays.Cut()

	if(light)
		QDEL_NULL(light)

	if (length(light_sources))
		light_sources.Cut()

	if(smoothing_flags & SMOOTH_QUEUED)
		SSicon_smooth.remove_from_queues(src)

	return ..()
