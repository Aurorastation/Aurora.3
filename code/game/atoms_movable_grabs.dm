/// Fires when a mob attempts to grab this movable, and passes their own can_grab check. Returns TRUE if this movable is grabbable. If not, it MUST return FALSE,
/// and present a message to the mob/grabber that explains why they cannot grab the object unless it is plainly obvious. (Object deleted, etc.)
/atom/movable/proc/can_be_grabbed(mob/grabber, target_zone)
	if(!istype(grabber) || !isturf(loc) || !isturf(grabber.loc))
		return FALSE
	if(!buckled_grab_check(grabber))
		return FALSE
	if(anchored)
		to_chat(grabber, SPAN_WARNING("\The [src] won't budge!"))
		return FALSE
	return TRUE

/atom/movable/proc/buckled_grab_check(mob/grabber)
	if(grabber.buckled == src && buckled == grabber)
		return TRUE
	if(grabber.anchored)
		to_chat(grabber, SPAN_WARNING("You can't move!"))
		return FALSE
	if(grabber.buckled)
		to_chat(grabber, SPAN_WARNING("You're buckled to \the [buckled]!"))
		return FALSE
	return TRUE

/atom/movable/handle_grab_interaction(mob/user)
	if(isliving(user) && user.a_intent == I_GRAB && !user.lying && !anchored)
		return try_make_grab(user)
	return ..()

/// Attempts to make a grab with USER as the grabber and SRC as the grabbed AM
/atom/movable/proc/try_make_grab(mob/living/user, defer_hand = FALSE)
	if(istype(user) && use_check_and_message(user, USE_ALLOW_NON_ADV_TOOL_USR) && !user.lying)
		if(user == buckled)
			return give_control_grab(buckled)
		return user.make_grab(src, defer_hand = defer_hand)
	return null

/atom/movable/proc/give_control_grab(mob/M)
	return
