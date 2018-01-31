/spell/hand
	var/min_range = 0
	var/list/compatible_targets = list(/atom)
	var/casts = 1
	var/spell_delay = 5
	var/move_delay
	var/click_delay
	var/hand_state = "magic"
	var/lightful = 0
	var/lightful_c
	var/obj/item/organ/brain/brain
	var/obj/item/organ/brain/psybrain
	var/target_self = 0
	var/hand_icon
	var/obj/item/weapon/magic_hand/hand

/spell/hand/choose_targets(mob/user = usr)
	return list(user)

/spell/hand/cast(list/targets, mob/user)
	for(var/mob/M in targets)
		if(M.get_active_hand())
			user << "<span class='warning'>You need an empty hand to cast this spell.</span>"
			return
		var/obj/item/weapon/magic_hand/H = new(get_turf(user), src, user)
		if(!M.put_in_active_hand(H))
			qdel(H)
			return
		hand = H
		user << "You ready the [name] spell ([casts]/[casts] charges)."

/spell/hand/proc/valid_target(var/atom/A,var/mob/user) //we use seperate procs for our target checking for the hand spells.
	if(A == user && !target_self)
		return 0
	var/distance = get_dist(A,user)
	if((min_range && distance < min_range) || (range && distance > range))
		return 0
	if(!is_type_in_list(A,compatible_targets))
		return 0
	return 1

/spell/hand/proc/cast_hand(var/atom/A,var/mob/user) //same for casting.
	return 1