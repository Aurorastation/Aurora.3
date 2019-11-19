#define BORG_CAMERA_BUFFER 30

// ROBOT MOVEMENT

// Update the portable camera everytime the Robot moves.
// This might be laggy, comment it out if there are problems.
/mob/living/silicon/var/synd_updating = 0

/mob/living/silicon/robot/Move()
	var/oldLoc = src.loc
	. = ..()
	if (.)
		if(provides_synd_vision())
			if(!synd_updating)
				synd_updating = 1
				addtimer(CALLBACK(src, .proc/camera_post_move, oldLoc), BORG_CAMERA_BUFFER)

/mob/living/silicon/robot/proc/camera_post_move_synd(oldLoc)
	if (oldLoc != loc)
		syndnet.updatePortableCamera(camera)

	synd_updating = 0

#undef BORG_CAMERA_BUFFER

// CAMERA

// An addition to deactivate which removes/adds the camera from the chunk list based on if it works or not.

/obj/machinery/camera/deactivate(user as mob, var/choice = 1)
	..(user, choice)
	if(!(NETWORK_SYNDICATE in network))
		return
	invalidateCameraCache()
	if(src.can_use())
		syndnet.addCamera(src)
	else
		src.set_light(0)
		syndnet.removeCamera(src)

/obj/machinery/camera/Initialize()
	. = ..()
	//Camera must be added to global list of all cameras no matter what...
	if(NETWORK_SYNDICATE in network)
		syndnet.cameras += src
		syndnet.cameras_unsorted = TRUE
	update_coverage(1)

/obj/machinery/camera/Destroy()
	clear_all_networks()
	if(src in syndnet.cameras)
		syndnet.cameras -= src
	return ..()

/obj/machinery/camera/add_networks(var/list/networks)
	..()
	if(can_use() && NETWORK_SYNDICATE in networks)
		syndnet.addCamera(src)

/obj/machinery/camera/remove_networks(var/list/networks)
	..()
	if(NETWORK_SYNDICATE in networks)
		syndnet.removeCamera(src)
