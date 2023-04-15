/var/global/datum/topic_state/default/default_state = new()

/datum/topic_state/default/href_list(var/mob/user)
	return list()

/datum/topic_state/default/can_use_topic(var/src_object, var/mob/user)
	return user.default_can_use_topic(src_object)

/mob/proc/default_can_use_topic(var/src_object)
	return STATUS_CLOSE // By default no mob can do anything with NanoUI

/mob/abstract/observer/default_can_use_topic(var/src_object)
	if(can_admin_interact())
		return STATUS_INTERACTIVE							// Admins are more equal
	if(!client || get_dist(src_object, src)	> client.view)	// Preventing ghosts from having a million windows open by limiting to objects in range
		return STATUS_CLOSE
	return STATUS_UPDATE									// Ghosts can view updates

/mob/living/silicon/pai/default_can_use_topic(var/src_object)
	if(src_object == parent_computer)
		if(!parent_computer.pAI_lock)
			return STATUS_INTERACTIVE
		else
			to_chat(src, SPAN_WARNING("Error. pAI Access Lock systems still engaged."))
			return ..()
	if((src_object == src || src_object == radio) && !stat)
		return STATUS_INTERACTIVE
	else
		return ..()

/mob/living/silicon/robot/default_can_use_topic(var/src_object)
	. = shared_nano_interaction()
	if(. <= STATUS_DISABLED)
		return

	// robots can interact with things they can see within their view range
	if((src_object in view(src)) && get_dist(src_object, src) <= src.client.view)
		return STATUS_INTERACTIVE	// interactive (green visibility)
	return STATUS_CLOSE			// close the UI if no longer in view

/mob/living/silicon/ai/default_can_use_topic(var/src_object)
	. = shared_nano_interaction()
	if(. != STATUS_INTERACTIVE)
		return

	// Prevents the AI from using Topic on admin levels (by for example viewing through the court/thunderdome cameras)
	// unless it's on the same level as the object it's interacting with.
	var/turf/T = get_turf(src_object)
	if(!T || !(z == T.z || isStationLevel(T.z)))
		return STATUS_CLOSE

	// If an object is in view then we can interact with it
	if(src_object in view(client.view, src))
		return STATUS_INTERACTIVE

	// If we're installed in a chassi, rather than transfered to an inteliCard or other container, then check if we have camera view
	if(is_in_chassis())
		//stop AIs from leaving windows open and using then after they lose vision
		if(cameranet && !cameranet.is_turf_visible(get_turf(src_object)))
			return STATUS_CLOSE
		return STATUS_INTERACTIVE
	else if(get_dist(src_object, src) <= client.view)	// View does not return what one would expect while installed in an inteliCard
		return STATUS_INTERACTIVE

	return STATUS_CLOSE

//Some atoms such as vehicles might have special rules for how mobs inside them interact with NanoUI.
/atom/proc/contents_nano_distance(var/src_object, var/mob/living/user)
	return user.shared_living_nano_distance(src_object)

/mob/living/heavy_vehicle/contents_nano_distance(src_object, mob/living/user)
	if(src_object in contents)
		return STATUS_INTERACTIVE
	if(hatch_closed && body.pilot_coverage == 100 && !istype(user, /mob/living/simple_animal/spiderbot)) // spiderbots get a pass cuz they need a bone, call it RFID bullshit
		to_chat(user, SPAN_WARNING("You can't interact with things outside \the [src] if its hatch is closed!"))
		return STATUS_CLOSE
	if(!src.Adjacent(src_object))
		return STATUS_CLOSE
	return STATUS_INTERACTIVE

/mob/living/proc/shared_living_nano_distance(var/atom/movable/src_object)
	if (!(src_object in view(4, src))) 	// If the src object is not in visable, disable updates
		return STATUS_CLOSE

	var/dist = get_dist(src_object, src)
	if (dist <= 1)
		return STATUS_INTERACTIVE	// interactive (green visibility)
	else if (dist <= 2)
		return STATUS_UPDATE 		// update only (orange visibility)
	else if (dist <= 4)
		return STATUS_DISABLED 		// no updates, completely disabled (red visibility)
	return STATUS_CLOSE

/mob/living/default_can_use_topic(var/src_object)
	. = shared_nano_interaction(src_object)
	if(. != STATUS_CLOSE)
		if(loc)
			if(istype(loc, /mob/living/heavy_vehicle))
				return loc.contents_nano_distance(src_object, src)
			else
				. = min(., loc.contents_nano_distance(src_object, src))
	if(. == STATUS_INTERACTIVE)
		return STATUS_UPDATE

/mob/living/carbon/human/default_can_use_topic(var/src_object)
	. = shared_nano_interaction(src_object)
	if(. != STATUS_CLOSE)
		if(loc)
			if(istype(loc, /mob/living/heavy_vehicle))
				. = loc.contents_nano_distance(src_object, src)
			else
				. = min(., loc.contents_nano_distance(src_object, src))
		else
			. = min(., shared_living_nano_distance(src_object))
