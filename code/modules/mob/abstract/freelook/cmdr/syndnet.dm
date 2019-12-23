// SYND NET
//
// The datum containing all the chunks.

/datum/visualnet/syndnet
	// Syndicate cameras.
	var/list/cameras
	chunk_type = /datum/chunk/syndicate
	valid_source_types = list(/obj/machinery/camera)

/datum/visualnet/syndnet/New()
	cameras = list()
	..()

/datum/visualnet/syndnet/Destroy()
	cameras.Cut()
	. = ..()

/datum/visualnet/syndnet/add_source(obj/machinery/camera/c)
	if(istype(c))
		if(c in cameras)
			return FALSE
		. = ..(c, c.can_use())
		if(.)
			dd_binaryInsertSorted(cameras, c)
	else
		..()

/datum/visualnet/syndnet/remove_source(obj/machinery/camera/c)
	if(istype(c) && cameras.Remove(c))
		. = ..(c, c.can_use())
	else
		..()