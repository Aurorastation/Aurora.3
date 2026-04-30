SUBSYSTEM_DEF(materials)
	name = "Materials"
	init_order = INIT_ORDER_MISC_FIRST
	flags = SS_NO_FIRE

/// This will eventually need to house chemistry reactions
/datum/controller/subsystem/materials/Initialize()
	return SS_INIT_SUCCESS
