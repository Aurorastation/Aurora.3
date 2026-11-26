//Compute how to fire.....
//Return TRUE if a target was found, FALSE otherwise.
/obj/item/gun/proc/PreFire(atom/A, mob/living/user, params)
	return istype(user) && user.aim_at(A, src)
