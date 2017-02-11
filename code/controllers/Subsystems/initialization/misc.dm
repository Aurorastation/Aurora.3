/datum/subsystem/misc_late
	name = "Late Miscellaneous Init"
	init_order = SS_INIT_MISC
	flags = SS_NO_FIRE

/datum/subsystem/misc_late/Initialize(timeofday)
	populate_antag_type_list()
	populate_spawn_points()
	setupgenetics()
	global.corp_regs = new

/datum/subsystem/misc_early
	name = "Early Miscellaneous Init"
	init_order = SS_INIT_MISC_FIRST
	flags = SS_NO_FIRE

/datum/subsystem/misc_early/Initialize(timeofday)
	// This is kinda important. Set up details of what the hell things are made of.
	populate_material_list()

	// Create autolathe recipes, as above.
	populate_lathe_recipes()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	if(config.ToRban)
		ToRban_autoupdate()
		
	..()
