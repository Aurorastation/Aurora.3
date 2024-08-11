/client/proc/global_ao_regenerate()
	set name = "Regenerate AO (Global)"
	set desc = "Regenerates AO caches across the map."
	set category = "Debug"

	if (!check_rights(R_DEBUG)) return

	log_and_message_admins("has triggered a global ambient occlusion rebuild.")
	to_chat(usr, "Beginning global AO rebuild.")

	SSao.can_fire = FALSE

	for (var/turf/T in world)	// Yes, in world.
		T.ao_neighbors = null	// To force a recalc.
		T.ao_neighbors_mimic = null
		if (T.permit_ao)
			T.queue_ao()

		CHECK_TICK

	SSao.can_fire = TRUE

	to_chat(usr, "AO rebuild complete.")
