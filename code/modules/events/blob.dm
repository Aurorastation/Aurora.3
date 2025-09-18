/datum/event/blob
	// Quite a short fuse due to the potential severity of this event.
	announceWhen = 12

	/// The number of blob cores active.
	var/list/obj/effect/blob/core/cores = list()
	ic_name = "a biohazard"

/datum/event/blob/announce()
	level_seven_announcement(affecting_z)

/datum/event/blob/start()
	..()

	// This stores the list of the possible number of blobs, weighted towards 2. Adjust if a different weighting is desired.
	var/list/numberOfBlobs = list(1, 2, 2, 3)

	// We pick randomly from the list to determine how many we spawn.
	for(var/i = 0; i <= pick(numberOfBlobs); i++)
		var/turf/T = pick_subarea_turf(/area/horizon/maintenance, list(/proc/is_station_turf, /proc/not_turf_contains_dense_objects))
		if(!T)
			log_and_message_admins("Blob failed to find a viable turf.")
			kill(TRUE)
			break

		log_and_message_admins("Blob spawned at \the [get_area(T)]", location = T)
		// Spawn the blob in.
		var/obj/effect/blob/core/Blob = new /obj/effect/blob/core(T)
		// Add this blob to the list of all currently extant blobs.
		cores.Add(Blob)

		// Blobs receive a burst of growth from the moment they spawn!
		for(var/int = 1; int < rand(3, 4); int++)
			Blob.process()

/datum/event/blob/tick()
	for(var/obj/effect/blob/core in cores)
		// If a core is absent, remove it from the list.
		if(!core || !core.loc)
			cores.Remove(core)

		// If the list is empty, kill the event - all blobs have been destroyed.
		if(isemptylist(cores))
			end()
			kill()
			return

		// Otherwise, process for every third tick.
		if(IsMultiple(activeFor, 3))
			core.process()
