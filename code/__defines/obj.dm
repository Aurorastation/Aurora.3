#define OBJ_FLAG_ROTATABLE          (1<<1) //Can this object be rotated?
#define OBJ_FLAG_ROTATABLE_ANCHORED (1<<2) // This object can be rotated even while anchored
#define OBJ_FLAG_SIGNALER           (1<<3) // Can this take a signaler? only in use for machinery

/obj/proc/issurgerycompatible() // set to false for things that are too unwieldy for surgery
	return TRUE

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

#define SCREWDRIVER "screwdriver"
#define WRENCH "wrench"
#define CROWBAR "crowbar"
#define WIRECUTTER "wirecutter"

/proc/check_tool_quality(var/obj/tool, var/quality, var/return_value, var/requires_surgery_compatibility = FALSE)
	switch(quality)
		if(SCREWDRIVER)
			if(tool.isscrewdriver() && (!requires_surgery_compatibility || tool.issurgerycompatible()))
				return return_value
		if(WRENCH)
			if(tool.iswrench() && (!requires_surgery_compatibility || tool.issurgerycompatible()))
				return return_value
		if(CROWBAR)
			if(tool.iscrowbar() && (!requires_surgery_compatibility || tool.issurgerycompatible()))
				return return_value
		if(WIRECUTTER)
			if(tool.iswirecutter() && (!requires_surgery_compatibility || tool.issurgerycompatible()))
				return return_value
	return null