// CAMERA NET
//
// The datum containing all the chunks.

/datum/visualnet/camera
	// The cameras on the map, no matter if they work or not.
	var/list/cameras
	chunk_type = /datum/chunk/camera
	valid_source_types = list(/obj/structure/machinery/camera, /mob/living/silicon/ai)

/datum/visualnet/camera/New()
	cameras = list()
	..()

/datum/visualnet/camera/Destroy()
	cameras.Cut()
	return ..()

/datum/visualnet/camera/proc/get_stack_key_z(z)
	var/list/stack = SSmapping.get_connected_levels(z)
	if(length(stack))
		return stack[stack.len]
	return z

/datum/visualnet/camera/is_chunk_generated(x, y, z)
	x &= ~0xf
	y &= ~0xf
	z = get_stack_key_z(z)
	var/key = "[x],[y],[z]"
	return !isnull(chunks[key])

/datum/visualnet/camera/get_chunk(x, y, z)
	x &= ~0xf
	y &= ~0xf
	z = get_stack_key_z(z)
	var/key = "[x],[y],[z]"
	if(!chunks[key])
		chunks[key] = new chunk_type(src, x, y, z)

	return chunks[key]

/datum/visualnet/camera/add_source(obj/structure/machinery/camera/c)
	if(istype(c))
		if(c in cameras)
			return FALSE
		. = ..(c, c.can_use())
		if(.)
			dd_binaryInsertSorted(cameras, c)
	else if(isAI(c))
		var/mob/living/silicon/AI = c
		return ..(AI, AI.stat != DEAD)
	else
		..()

/datum/visualnet/camera/remove_source(obj/structure/machinery/camera/c)
	if(istype(c) && cameras.Remove(c))
		. = ..(c, c.can_use())
	if(isAI(c))
		var/mob/living/silicon/AI = c
		return ..(AI, AI.stat != DEAD)
	else
		..()
