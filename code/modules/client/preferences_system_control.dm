/*
 * These procs manage the calling of savefile or SQL oriented save and load procs for characters and preference data.
 * This way of doing it is necessary for migration to be possible without a huge load of hacks.
 * Will also ensure in neat and modular compatibility between the two systems, and the potential introduction of further systems.
 */

/datum/preferences/proc/handle_preferences_load(var/client/C)
	if (config.sql_saves)
		return load_preferences_sql(C)
	else
		return load_preferences()

/datum/preferences/proc/handle_preferences_save(var/client/C)
	if (config.sql_saves)
		return save_preferences_sql(C)
	else
		return save_preferences()

/datum/preferences/proc/handle_character_load(var/slot = 0, var/client/C)
	if (config.sql_saves)
		return load_character_sql(slot, C)
	else
		return load_character(slot)

/datum/preferences/proc/handle_character_save(var/client/C)
	if (config.sql_saves)
		return save_character_sql(C)
	else
		return save_character()

/datum/preferences/proc/get_default_character()
	if (config.sql_saves)
		return current_character
	else
		return default_slot
