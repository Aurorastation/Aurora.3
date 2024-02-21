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

/obj/proc/ishammer()
	return FALSE

/obj/proc/ispen()
	return FALSE

// If delay between the start and the end of tool operation is less than MIN_TOOL_SOUND_DELAY,
// tool sound is only played when op is started. If not, it's played twice.
#define MIN_TOOL_SOUND_DELAY 20

#define SCREWDRIVER "screwdriver"
#define WRENCH "wrench"
#define CROWBAR "crowbar"
#define WIRECUTTER "wirecutter"

// Defines for barricade states
#define BARRICADE_DMG_NONE 0
#define BARRICADE_DMG_SLIGHT 1
#define BARRICADE_DMG_MODERATE 2
#define BARRICADE_DMG_HEAVY 3

#define BARRICADE_BSTATE_FORTIFIED 	3 // Used by handrails to indicate reinforcing
#define BARRICADE_BSTATE_SECURED 	2 // fresh barricade
#define BARRICADE_BSTATE_UNSECURED 	1 // intermediate state before cade is movable (no apparent effect on health)
#define BARRICADE_BSTATE_MOVABLE 	0 // ready to be deconstructed and can be moved

// Defines for liquidbag tresholds
#define BARRICADE_LIQUIDBAG_TRESHOLD_1	75
#define BARRICADE_LIQUIDBAG_TRESHOLD_2	150
#define BARRICADE_LIQUIDBAG_TRESHOLD_3	225
#define BARRICADE_LIQUIDBAG_TRESHOLD_4	300
#define BARRICADE_LIQUIDBAG_TRESHOLD_5	350

// Defines for liquidbag build stages
#define BARRICADE_LIQUIDBAG_1 1
#define BARRICADE_LIQUIDBAG_2 2
#define BARRICADE_LIQUIDBAG_3 3
#define BARRICADE_LIQUIDBAG_4 4
#define BARRICADE_LIQUIDBAG_5 5

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

#define HELMET_GARB_PASS_ICON "pass_icon"
