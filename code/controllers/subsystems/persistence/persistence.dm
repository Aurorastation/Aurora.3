/*
 * Persistence subsystem
 * Subsytem for managing any form of persistent content across rounds.
 *
 * This subsystem consists of multiple partial files, split into different responsibilities:
 *   persistence.dm - Subsystem define and related code
 *   Objects and types (with Generics and History respectively), each containing:
 *     Base file (no suffix), public procs (_public.dm suffix), SQL code (_sql.dm suffix)
 */

SUBSYSTEM_DEF(persistence)
	name = "Persistence"
	init_order = INIT_ORDER_PERSISTENCE // The order is tied with the init and maploading subsystem.
	flags = SS_NO_FIRE // This subsystem has no continues workload, it's init and shutdown only.
	/// Sanity check to confirm init was a success before finalizing.
	var/init_success = FALSE
	/// Global toggle to prevent saving at round end, changed by toggle_persistence proc, used for admin purposes.
	var/prevent_saving = FALSE
	/// In-memory register of all persistent objects that were loaded or created during the round, used for tracking and finalization purposes.
	var/object_track_register = list()
	/// Dictionary<"[type](+[attribute])" cache of persistent history records.
	var/history_cache = alist()
	/// Manual record counter of cache containers.
	var/history_cache_count = 0
	/// ID of last found history record.
	/// Higher found IDs mean the record is not yet found in the database, lower or equal found ID means the are record that are already in the database.
	/// Used during history_virtual_id init and read-through cache hits.
	var/history_last_database_id = 0
	/// ID used for instanciating new history records during the round, used for cache tracking.
	/// Their database ID will be set during insert/finalization.
	var/history_virtual_id = 0
	/// Dictionary<char_id, charname> cache of Character name by ID for history/character helper.
	var/char_cache = alist()
	/// Dictionary<"[type](+[attribute])", container> cache of persistent generics.
	var/generic_cache = alist()

/**
 * Subsystem info stub message generation.
 */
/datum/controller/subsystem/persistence/stat_entry(msg)
	msg = ("[init_success ? "" : "INIT FAILED!!!|"][prevent_saving ? "SAVING DISABLED!|" : ""]Objects:[length(object_track_register)]|Containers:[length(history_cache)]>Records:[history_cache_count]|Generics:[length(generic_cache)]")
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

	feedback_add_details("admin_verb","TPS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

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
	catch(var/exception/e_objects)
		log_subsystem_persistence_panic("Unhandled exception during persistent objects initialization!", e_objects)
		return SS_INIT_FAILURE

	try
		typesInitialize()
	catch(var/exception/e_types)
		log_subsystem_persistence_panic("Unhandled exception during persistent type initialization!", e_types)
		return SS_INIT_FAILURE

	init_success = TRUE
	return SS_INIT_SUCCESS

/**
 * Shutdown of the persistence subsystem.
 * The shutdown consists of finalization steps for each persistent data type.
 */
/datum/controller/subsystem/persistence/Shutdown()
	if(!init_success)
		log_subsystem_persistence_panic("Init success flag is FALSE. Something went wrong during subsystem init! Aborting finalization to prevent corrupt data!")
		return

	if(prevent_saving)
		log_subsystem_persistence_warning("Persistence subsystem was toggled to not save. Skipping subsystem finalization.")
		return

	if(!databaseCheckConnection("subsystem shutdown"))
		log_subsystem_persistence_panic("SQL error during persistence subsystem shutdown. Cannot finalise persistence of the round.")
		return

	try
		objectsFinalize()
	catch(var/exception/e_objects)
		log_subsystem_persistence_panic("Unhandled exception during persistent objects finalization!", e_objects)

	try
		typesFinalize()
	catch(var/exception/e_types)
		log_subsystem_persistence_panic("Unhandled exception during persistent types finalization!", e_types)
