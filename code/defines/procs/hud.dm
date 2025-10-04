/mob/proc/in_view(var/turf/T)
	RETURN_TYPE(/list)

	return get_hearers_in_LOS(client?.view, T)

/mob/abstract/eye/in_view(var/turf/T)
	RETURN_TYPE(/list)

	// This was like this before, honestly i don't see the point of doing it this way hence the change, but I left the code for reference in case shit hits the fan
	// var/list/viewed = new
	// for(var/mob/living/carbon/human/H in GLOB.mob_list)
	// 	if(get_dist(H, T) <= client?.view)
	// 		viewed += H
	// return viewed

	//Some virtual eyes eg. the AI eye doesn't have a client but an owner, select it as preferred if so, otherwise use the mob's client itself
	return get_hearers_in_range((src.owner ? src.owner.client?.view : src.client?.view), T)

/obj/item/proc/get_sechud_job_icon_state()
	var/obj/item/card/id/I = GetID()

	if (I) return "hud[ckey(I.GetJobName())]"
	return "hudunknown"

/// Wrapper for adding anything to a client's screen
/client/proc/add_to_screen(screen_add)
	screen += screen_add
	SEND_SIGNAL(src, COMSIG_CLIENT_SCREEN_ADD, screen_add)

/// Wrapper for removing anything from a client's screen
/client/proc/remove_from_screen(screen_remove)
	screen -= screen_remove
	SEND_SIGNAL(src, COMSIG_CLIENT_SCREEN_REMOVE, screen_remove)
