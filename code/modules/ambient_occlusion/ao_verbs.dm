/client/proc/global_ao_regenerate()
	set name = "Regenerate AO (Global)"
	set desc = "Regenerates AO caches across the map."
	set category = "Debug"

	if (!check_rights(R_DEBUG)) return

	log_and_message_admins("has triggered a global ambient occlusion rebuild.")
	usr << "Beginning global AO rebuild."

	SSocclusion.disable()

	for (var/turf/T in world)	// Yes, in world.
		T.ao_neighbors = null	// To force a recalc.
		T.ao_neighbors_mimic = null
		if (T.permit_ao)
			T.queue_ao()

		CHECK_TICK

	SSocclusion.enable()

	usr << "AO rebuild complete."
