SUBSYSTEM_DEF(evac)
	name = "Evacuation"
	priority = SS_PRIORITY_EVAC
	//Initializes at default time
	flags = SS_BACKGROUND
	wait = 2 SECONDS

/datum/controller/subsystem/evac/Initialize()
	if(!evacuation_controller)
		evacuation_controller = new current_map.evac_controller_type ()
		evacuation_controller.set_up()

	return SS_INIT_SUCCESS

/datum/controller/subsystem/evac/fire()
	evacuation_controller.process()
