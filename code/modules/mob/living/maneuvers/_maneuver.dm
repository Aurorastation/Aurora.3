/singleton/maneuver
	var/name = "unnamed"
	var/delay = 2 SECONDS
	var/cooldown = 5 SECONDS
	var/stamina_cost = 10
	var/reflexive_modifier = 1
	var/charge_cost = 0 //Charge cost for robot species.

/singleton/maneuver/proc/can_be_used_by(var/mob/living/user, var/atom/target, var/silent = FALSE)
	if(!istype(user) || !user.can_do_maneuver(src, silent))
		return FALSE
	if(user.buckled_to)
		if(!silent)
			to_chat(user, SPAN_WARNING("You are buckled down and cannot maneuver!"))
		return FALSE
	if(!has_gravity(user))
		if(!silent)
			to_chat(user, SPAN_WARNING("You cannot maneuver in zero gravity!"))
		return FALSE
	if(user.incapacitated(INCAPACITATION_DISABLED) || user.lying || !isturf(user.loc))
		if(!silent)
			to_chat(user, SPAN_WARNING("You are not in position for maneuvering."))
		return FALSE
	if(world.time < user.last_special)
		if(!silent)
			to_chat(user, SPAN_WARNING("You cannot maneuver again for another [Floor((user.last_special - world.time)*0.1)] second\s."))
		return FALSE
	if(!isipc(user))
		if(user.stamina < stamina_cost)
			if(!silent)
				to_chat(user, SPAN_WARNING("You are too exhausted to maneuver right now."))
			return FALSE
	if (target && user.z != target.z)
		if (!silent)
			to_chat(user, SPAN_WARNING("You cannot maneuver to a different z-level!"))
		return FALSE
	return TRUE

/singleton/maneuver/proc/show_initial_message(var/mob/user, var/atom/target)
	return

/singleton/maneuver/proc/perform(var/mob/living/user, var/atom/target, var/strength, var/reflexively = FALSE)
	if(can_be_used_by(user, target))
		if(!reflexively)
			show_initial_message(user, target)
		user.face_atom(target)
		. = (!delay || reflexively || (do_after(user, delay, target) && can_be_used_by(user, target)))
		if(cooldown)
			user.last_special = world.time + cooldown
		if(stamina_cost)
			user.stamina -= stamina_cost
		if(isipc(user))
			var/mob/living/carbon/human/H = user
			var/obj/item/cell/C = H.internal_organs_by_name[BP_CELL]
			if(C)
				C.use(charge_cost)
