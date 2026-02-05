// CAMERA

// An addition to deactivate which removes/adds the camera from the chunk list based on if it works or not.

/obj/machinery/camera/proc/update_coverage(var/network_change = 0)
	if(network_change)
		var/list/open_networks = difflist(network, GLOB.restricted_camera_networks)
		// Add or remove camera from the camera net as necessary
		if(on_open_network && !open_networks.len)
			on_open_network = FALSE
			GLOB.cameranet.remove_source(src)
		else if(!on_open_network && open_networks.len)
			on_open_network = TRUE
			GLOB.cameranet.add_source(src)
	else
		GLOB.cameranet.update_visibility(src)

	invalidateCameraCache()
