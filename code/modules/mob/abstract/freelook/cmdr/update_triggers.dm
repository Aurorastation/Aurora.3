// SYND CAMERA

// An addition to deactivate which removes/adds the camera from the chunk list based on if it's on the right network

/obj/machinery/camera/deactivate(user as mob, var/choice = 1)
	..(user, choice)
	syndnet.update_visibility(src)

/obj/machinery/camera/Initialize()
	. = ..()
	if(NETWORK_SYNDICATE in network)
		syndnet.add_source(src)

/obj/machinery/camera/Destroy()
	if(NETWORK_SYNDICATE in network)
		syndnet.remove_source(src)
	. = ..()

/obj/machinery/camera/update_coverage(var/network_change = 0)
	. = ..()
	if(network_change)
		// Add or remove camera from the camera net as necessary
		if(!(NETWORK_SYNDICATE in network))
			syndnet.remove_source(src)
		else if(NETWORK_SYNDICATE in network)
			syndnet.add_source(src)
	else
		syndnet.update_visibility(src)

	invalidateCameraCache()