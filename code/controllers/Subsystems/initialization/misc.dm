var/datum/subsystem/misc/SSmisc

/datum/subsystem/misc
	name = "Miscellaneous"
	init_order = SS_INIT_MISC
	flags = SS_NO_FIRE

/datum/subsystem/misc/New()
	NEW_SS_GLOBAL(SSmisc)

/datum/subsystem/misc/Initialize()
	populate_antag_type_list()
	populate_spawn_points()
	setupgenetics()
	global.corp_regs = new
	..()
