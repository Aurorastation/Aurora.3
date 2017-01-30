//Prevents robots dropping their modules.
/proc/dropsafety(var/atom/movable/A)
	if (istype(A.loc, /mob/living/silicon))
		return 0

	else if (istype(A.loc, /obj/item/rig_module))
		return 0
	return 1

