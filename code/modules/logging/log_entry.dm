// Current schema: 1.0.0
// [timestamp, category, message, data, world_state, semver_store, id, schema_version]

/// A datum which contains one structured log line.
/datum/log_entry
	/// Next id to assign to a log entry.
	var/static/next_id = 0
	/// Unique id of the log entry.
	var/id
	/// Schema version of the log entry
	var/schema_version = "1.0.0"
	/// Human-readable timestamp of the log entry
	var/timestamp
	/// Category of the log entry.
	var/category
	/// Message of the log entry.
	var/message
	/// Bitfield that describes how to log this entry.
	var/flags = NONE
	/// Optional structured data.
	var/list/data
	/// Semver store for serialized data entries.
	var/list/semver_store

GENERAL_PROTECT_DATUM(/datum/log_entry)

/datum/log_entry/New(timestamp, category, message, flags, list/data, list/semver_store)
	..()

	src.id = next_id++
	src.timestamp = timestamp
	src.category = category
	src.flags = flags
	src.message = message
	with_data(data)
	with_semver_store(semver_store)

/datum/log_entry/proc/with_data(list/data)
	if(!isnull(data))
		if(!islist(data))
			src.data = list("data" = data)
			stack_trace("Log entry data was not a list.")
		else
			src.data = data
	return src

/datum/log_entry/proc/with_semver_store(list/semver_store)
	if(isnull(semver_store))
		return src
	if(!islist(semver_store))
		stack_trace("Log entry semver store was not a list.")
	else
		src.semver_store = semver_store
	return src

/// Converts the log entry to a human-readable string.
/datum/log_entry/proc/to_readable_text(format = TRUE)
	var/output = ""
	if(format)
		output += "\[[timestamp]\] [uppertext(category)]: [message]"
	else
		output += "[uppertext(category)]: [message]"

	if(flags & ENTRY_USE_DATA_W_READABLE)
		output += " [json_encode(data)]"

	return output

#define MANUAL_JSON_ENTRY(list, key, value) list.Add("\"[key]\":[(!isnull(value)) ? json_encode(value) : "null"]")

/// Converts the log entry to a JSON string.
/datum/log_entry/proc/to_json_text()
	var/list/json_entries = list()
	MANUAL_JSON_ENTRY(json_entries, LOG_ENTRY_KEY_TIMESTAMP, timestamp)
	MANUAL_JSON_ENTRY(json_entries, LOG_ENTRY_KEY_CATEGORY, category)
	MANUAL_JSON_ENTRY(json_entries, LOG_ENTRY_KEY_MESSAGE, message)
	MANUAL_JSON_ENTRY(json_entries, LOG_ENTRY_KEY_DATA, data)
	MANUAL_JSON_ENTRY(json_entries, LOG_ENTRY_KEY_WORLD_STATE, world.get_world_state_for_logging())
	MANUAL_JSON_ENTRY(json_entries, LOG_ENTRY_KEY_SEMVER_STORE, semver_store)
	MANUAL_JSON_ENTRY(json_entries, LOG_ENTRY_KEY_ID, id)
	MANUAL_JSON_ENTRY(json_entries, LOG_ENTRY_KEY_SCHEMA_VERSION, schema_version)
	return "{[json_entries.Join(",")]}"

#undef MANUAL_JSON_ENTRY

/// Writes the JSON log entry to a file.
/datum/log_entry/proc/write_entry_to_file(file)
	if(!fexists(file) && !logger?.recover_category_file(category, "log.json"))
		stack_trace("Unable to recover structured log file [file] for category [category].")
	rustg_log_write(file, "[to_json_text()]\n", "false")

/// Writes the log entry to a file as human-readable text.
/datum/log_entry/proc/write_readable_entry_to_file(file, format_internally = TRUE)
	if(!fexists(file) && !logger?.recover_category_file(category, "log"))
		stack_trace("Unable to recover readable structured log file [file] for category [category].")
	if(format_internally)
		rustg_log_write(file, "[to_readable_text(format = TRUE)]\n", "false")
	else
		rustg_log_write(file, "[to_readable_text(format = FALSE)]", "true")
