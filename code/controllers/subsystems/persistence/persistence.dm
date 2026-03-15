SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE // The order is tied with the init and maploading subsystem.
	flags = SS_NO_FIRE // This subsystem has no continues workload, it's init and shutdown only.

/**
 * Subsystem info stub message generation.
 */
/datum/controller/subsystem/persistence/stat_entry(msg)
	msg = ("Object tracking register: [GLOB.persistence_register.len]")
	return ..()

/**
 * Initialization of the persistence subsystem.
 * Includes generic startup checks and init of the different persistent data types.
 */
/datum/controller/subsystem/persistence/Initialize()
	. = ..()
	if(!GLOB.config.sql_enabled)
		log_subsystem_persistence_warning("SQL configuration not enabled. Persistence subsystem requires SQL. Skipping init.")
		return SS_INIT_SUCCESS

	if(!SSdbcore.Connect())
		log_subsystem_persistence_error("SQL error during persistence subsystem init. Not connected.")
		return SS_INIT_FAILURE

	try
		objectsInitialize()
	catch(var/exception/e)
		log_subsystem_persistence_panic("Unhandled exception during persistent objects initialization: [e]")
		return SS_INIT_FAILURE

	return SS_INIT_SUCCESS

/**
 * Shutdown of the persistence subsystem.
 * The shutdown consists of finalization steps for each persistent data type.
 */
/datum/controller/subsystem/persistence/Shutdown()
	if(!SSdbcore.Connect())
		log_subsystem_persistence_panic("SQL error during persistence subsystem shutdown. Cannot finalise persistence of the round.")
		return

	try
		objectsFinalize()
	catch(var/exception/e)
		log_subsystem_persistence_panic("Unhandled exception during persistent objects finalization: [e]")
		return
