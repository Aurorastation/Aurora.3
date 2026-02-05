/obj/item/gun/equipped(mob/living/user, slot)
	if(istype(user) && !(slot in user.held_item_slots))
		user.stop_aiming(src)
	return ..()

//Compute how to fire.....
//Return TRUE if a target was found, FALSE otherwise.
/obj/item/gun/proc/PreFire(atom/A, mob/living/user, params)
	return istype(user) && user.aim_at(A, src)
