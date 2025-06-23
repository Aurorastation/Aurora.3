// The area list is put together here, because some things need it early on. Turrets controls, for example.

SUBSYSTEM_DEF(finalize)
	name = "Map Finalization"
	flags = SS_NO_FIRE | SS_NO_DISPLAY
	init_order = INIT_ORDER_MAPFINALIZE

/datum/controller/subsystem/finalize/Initialize(timeofday)
	// Setup the global antag uplink. This needs to be done after SSatlas as it requires current_map.
	GLOB.uplink = new

	// This is dependant on markers.
	populate_antag_spawns()

	return SS_INIT_SUCCESS
