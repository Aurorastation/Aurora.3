// Syndicate camera net

/datum/visualnet/camera/syndicate
	chunk_type = /datum/chunk/syndicate

// Removes a camera from a chunk.

/datum/visualnet/camera/syndicate/removeCamera(obj/machinery/camera/c)
	if(c.can_use())
		majorChunkChange(c, 0)

// Add a camera to a chunk.

/datum/visualnet/camera/syndicate/addCamera(obj/machinery/camera/c)
	if(c.can_use() && NETWORK_SYNDICATE in c.network)
		majorChunkChange(c, 1)

// Used for Cyborg cameras. Since portable cameras can be in ANY chunk.

/datum/visualnet/camera/syndicate/updatePortableCamera(obj/machinery/camera/c)
	if(c.can_use() && NETWORK_SYNDICATE in c.network)
		majorChunkChange(c, 1)

/datum/visualnet/camera/syndicate/onMajorChunkChange(atom/c, var/choice, var/datum/chunk/syndicate/chunk)
// Only add actual cameras to the list of cameras
	if(istype(c, /obj/machinery/camera))
		var/obj/machinery/camera/cam = c
		if(choice == 0)
			// Remove the camera.
			chunk.cameras -= cam
		else if(choice == 1)
			// You can't have the same camera in the list twice.
			chunk.cameras |= cam