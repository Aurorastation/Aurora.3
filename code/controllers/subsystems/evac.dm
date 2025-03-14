SUBSYSTEM_DEF(evac)
	name = "Evacuation"
	priority = SS_PRIORITY_EVAC
	//Initializes at default time
	flags = SS_BACKGROUND
	wait = 2 SECONDS

/datum/controller/subsystem/evac/Initialize()
	if(!GLOB.evacuation_controller)
		GLOB.evacuation_controller = new SSatlas.current_map.evac_controller_type ()
		GLOB.evacuation_controller.set_up()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/evac/fire()
	GLOB.evacuation_controller.process()
