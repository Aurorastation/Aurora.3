/proc/examinate(mob/user, atom/target, show_extended = FALSE)
	if((user.is_blind() || user.stat) && !isobserver(user))
		to_chat(user, SPAN_NOTICE("Something is there, but you cannot see it."))

	user.face_atom(target)

	var/distance = INFINITY
	var/is_adjacent = FALSE
	if(isobserver(user) || user.stat == DEAD)
		distance = 0
		is_adjacent = TRUE
	else
		var/turf/source_turf = get_turf(user)
		var/turf/target_turf = get_turf(target)
		if(source_turf && source_turf.z == target_turf?.z)
			distance = get_dist(source_turf, target_turf)
		is_adjacent = user.Adjacent(target)

	SEND_SIGNAL(user, COMSIG_MOB_EXAMINATE, target)

	if(!target.examine(user, distance, is_adjacent, show_extended = show_extended))
		crash_with("Improper /examine() override: [log_info_line(target)]")
