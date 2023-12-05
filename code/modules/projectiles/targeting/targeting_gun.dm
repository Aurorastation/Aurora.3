//Removing the lock and the buttons.
/obj/item/gun/dropped(mob/living/user)
	if(istype(user))
		user.stop_aiming(src)
	return ..()

/obj/item/gun/equipped(mob/living/user, slot)
	if(istype(user) && (slot != slot_l_hand && slot != slot_r_hand))
		user.stop_aiming(src)
	return ..()

//Compute how to fire.....
//Return TRUE if a target was found, FALSE otherwise.
/obj/item/gun/proc/PreFire(atom/A, mob/living/user, params)
	return istype(user) && user.aim_at(A, src)
