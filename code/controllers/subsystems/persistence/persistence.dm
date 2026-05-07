/*
 * Persistence subsystem
 * Subsytem for managing any form of persistent content across rounds.
 *
 * This subsystem consists of multiple partial files, following the structure:
 * - persistence.dm						- Subsystem definition and generic code.
 * - persistence_objects.dm				- Persistent objects related code.
 * - persistence_objects_sql.dm			- Persistent objects database code.
 * - persistence_objects_public.dm		- Persistent objects public procs.
 */

SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE // The order is tied with the init and maploading subsystem.
	flags = SS_NO_FIRE // This subsystem has no continues workload, it's init and shutdown only.
	var/prevent_saving = FALSE // Toggle to prevent saving at round end, changed by toggle_persistence proc, used for admin purposes.

/**
 * Subsystem info stub message generation.
 */
/datum/controller/subsystem/persistence/stat_entry(msg)
	msg = ("Register: [length(GLOB.persistence_object_track_register)] | Prevent saving: [SSpersistence.prevent_saving ? "TRUE" : "FALSE"]")
	return msg

/**
 * Helper method to check and log database connection.
 * RETURN: True if connection is scuccessful, false if not.
 * PARAMS:
 * 	action = Custom string of the action being performed written to log.
 */
/datum/controller/subsystem/persistence/proc/databaseCheckConnection(action = "unlabeled action")
	PRIVATE_PROC(TRUE)
	if(!SSdbcore.Connect())
		log_subsystem_persistence_error("SQL error during [action], connection failed.")
		return FALSE
	return TRUE

/**
 * Helper method to check the SQL query result and log possible errors.
 * RETURN: True if no error occured, false if an error was found.
 */
/datum/controller/subsystem/persistence/proc/databaseCheckQueryResult(datum/db_query/query, action = "unlabeled action")
	PRIVATE_PROC(TRUE)
	if (!query)
		log_subsystem_persistence_error("SQL error during [action], in addition query object provided to check was null.")
		return FALSE
	if (query.ErrorMsg())
		log_subsystem_persistence_error("SQL error during [action]. " + query.ErrorMsg())
		return FALSE
	return TRUE

/datum/admins/proc/toggle_persistence()
	set name = "Toggle Persistence"
	set category = "Special Verbs"

	if(!check_rights(R_ADMIN))
		return

	var/message = ""
	var/options = list()
	if(SSpersistence.prevent_saving)
		message = "The persistence subsystem will NOT save at the end of the round. Do you want to re-enable it?"
		options = list("Re-enable saving", "Cancel")
	else
		message = "The persistence subsystem will save at the end of the round. Do you want to prevent this? This can be un-done before the round ends."
		options = list("Prevent saving", "Cancel")

	var/confirm = tgui_alert(usr, message, "Toggle Persistence Saving", options)
	if(confirm == "Prevent saving")
		SSpersistence.prevent_saving = TRUE
		to_world(FONT_LARGE(EXAMINE_BLOCK_RED("Persistence saving at the end of the round has been [SPAN_BOLD(SPAN_WARNING("disabled"))] by an administrator.")))
		log_and_message_admins("has toggled persistence saving at round end, it is now disabled", usr)
	else if (confirm == "Re-enable saving")
		SSpersistence.prevent_saving = FALSE
		to_world(FONT_LARGE(EXAMINE_BLOCK_RED("Persistence saving at the end of the round has been [SPAN_BOLD(SPAN_GOOD("re-enabled"))] by an administrator.")))
		log_and_message_admins("has toggled persistence saving at round end, it is now re-enabled", usr)
	else
		return

	feedback_add_details("admin_verb","TP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/**
 * Initialization of the persistence subsystem.
 * Includes generic startup checks and init of the different persistent data types.
 */
/datum/controller/subsystem/persistence/Initialize()
	. = ..()
	if(!GLOB.config.sql_enabled)
		log_subsystem_persistence_warning("SQL configuration not enabled. Persistence subsystem requires SQL. Skipping init.")
		return SS_INIT_SUCCESS

	if(!databaseCheckConnection("subsystem init"))
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
	if(prevent_saving)
		log_subsystem_persistence_warning("Persistence subsystem was toggled to not save. Skipping subsystem finalization.")
		return

	if(!databaseCheckConnection("subsystem shutdown"))
		log_subsystem_persistence_panic("SQL error during persistence subsystem shutdown. Cannot finalise persistence of the round.")
		return

	try
		objectsFinalize()
	catch(var/exception/e)
		log_subsystem_persistence_panic("Unhandled exception during persistent objects finalization: [e]")
		return
