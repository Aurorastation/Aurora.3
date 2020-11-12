#define OBJ_FLAG_ROTATABLE          (1<<1) //Can this object be rotated?
#define OBJ_FLAG_ROTATABLE_ANCHORED (1<<2) // This object can be rotated even while anchored

/obj/proc/iswrench()
	return FALSE

/obj/proc/isscrewdriver()
	return FALSE

/obj/proc/iswirecutter()
	return FALSE

/obj/proc/ismultitool()
	return FALSE

/obj/proc/iscrowbar()
	return FALSE

/obj/proc/iswelder()
	return FALSE

/obj/proc/iscoil()
	return FALSE

/obj/proc/ispen()
	return FALSE
