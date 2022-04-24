/*
	This state checks that the user is an admin, end of story
*/
/var/global/datum/topic_state/staff_state/admin_state = new(R_ADMIN)
/var/global/datum/topic_state/staff_state/moderator_state = new(R_MOD)
/var/global/datum/topic_state/staff_state/staff_state = new()

/datum/topic_state/staff_state
	var/rigths_to_check = null

/datum/topic_state/staff_state/New(var/new_rigths = null)
	if(new_rigths)
		rigths_to_check = new_rigths

/datum/topic_state/staff_state/can_use_topic(var/src_object, var/mob/user)
	if(rigths_to_check == null)
		return user.client.holder ? STATUS_INTERACTIVE : STATUS_CLOSE
	return (user.client.holder && check_rights(rigths_to_check, 0, user)) ? STATUS_INTERACTIVE : STATUS_CLOSE
