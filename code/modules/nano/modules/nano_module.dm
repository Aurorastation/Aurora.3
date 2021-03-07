/datum/nano_module
	var/name
	var/datum/host
	var/available_to_ai = TRUE
	var/datum/topic_manager/topic_manager

/datum/nano_module/New(var/datum/host, var/topic_manager)
	..()
	src.host = host
	src.topic_manager = topic_manager

/datum/nano_module/ui_host()
	return host ? host.ui_host() : src

/datum/nano_module/proc/can_still_topic(var/datum/topic_state/state = default_state)
	return CanUseTopic(usr, state) == STATUS_INTERACTIVE

/datum/nano_module/proc/check_eye(var/mob/user)
	return -1

/datum/nano_module/proc/check_access(var/mob/user, var/access)
	if(!access)
		return TRUE

	if(!istype(user))
		return FALSE

	var/obj/item/card/id/I = user.GetIdCard()
	if(!I)
		return FALSE

	if(islist(access))
		for(var/a in access)
			if(a in I.access)
				return TRUE
	else
		if(access in I.access)
			return TRUE

	return FALSE

/datum/nano_module/Topic(href, href_list)
	if(topic_manager && topic_manager.Topic(href, href_list))
		return TRUE
	. = ..()

/datum/proc/initial_data()
	return list()

/datum/proc/update_layout()
	return FALSE
