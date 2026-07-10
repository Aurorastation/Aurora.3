/**
 * Use the macro LOG_DEBUG instead of calling this directly.
 * Used for general_purpose debug logging, please use more specific ones if available, or consider adding your own
 */
/proc/log_debug(text,level = SEVERITY_DEBUG)
	logger?.Log(LOG_CATEGORY_DEBUG, "DEBUG: [text]", list("severity" = level))

	if (level == SEVERITY_ERROR) // Errors are always logged
		logger?.Log(LOG_CATEGORY_WORLD, "ERROR: [text]", list("severity" = level))

	for(var/s in GLOB.staff)
		var/client/C = s
		if(!C.prefs) //This is to avoid null.toggles runtime error while still initialyzing players preferences
			return
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			to_chat(C, "<span class='debug'>DEBUG: [text]</span>")

/// Logging for loading and caching assets
/proc/log_asset(text, list/data)
	logger?.Log(LOG_CATEGORY_DEBUG_ASSET, "ASSET: [text]", data)

/// Logging for config errors
/// Rarely gets called; just here in case the config breaks.
/proc/log_config(text, list/data)
	if(GLOB.config_error_log && !GLOB.log_directory)
		rustg_log_write(GLOB.config_error_log, "CONFIG: [text]", "true")

	logger?.Log(LOG_CATEGORY_CONFIG, "CONFIG: [text]", data)

	// Do not print to world.log during unit tests
	#if !defined(UNIT_TEST)
	SEND_TEXT(world.log, "CONFIG: [text]")
	#endif

/proc/log_filter_raw(text, list/data)
	logger?.Log(LOG_CATEGORY_FILTER, "FILTER: [text]", data)

/// Logging for job slot changes
/proc/log_job_debug(text, list/data)
	logger?.Log(LOG_CATEGORY_DEBUG_JOB, "JOB: [text]", data)

/// Logging for lua scripting
/proc/log_lua(text, list/data)
	logger?.Log(LOG_CATEGORY_DEBUG_LUA, "LUA: [text]", data)

/// Logging for game performance
/proc/log_perf(list/perf_info)
	var/message = "[perf_info.Join(",")]"
	logger?.Log(LOG_CATEGORY_PERF, message, list("perf" = perf_info))

/// Logging for SQL errors
/proc/log_query_debug(text, list/data)
	logger?.Log(LOG_CATEGORY_DEBUG_SQL, "SQL: [text]", data)

/* Log to the logfile only. */
/proc/log_runtime(text, list/data)
	logger?.Log(LOG_CATEGORY_RUNTIME, "RUNTIME: [text]", data)

/proc/_log_signal(text, list/data)
	logger?.Log(LOG_CATEGORY_SIGNAL, "SIGNAL: [text]", data)

/// Logging for DB errors
/proc/log_sql(text, list/data)
	logger?.Log(LOG_CATEGORY_DEBUG_SQL, "SQL: [text]", data)
	if(SSsentry)
		SSsentry.capture_message(text, "error", "sql")

/// Logging for world/Topic
/proc/_log_topic(text, list/data)
	logger?.Log(LOG_CATEGORY_TOPIC, "TOPIC: [text]", data)

/// Log to both DD and the logfile.
/proc/log_world(text, list/data)
	logger?.Log(LOG_CATEGORY_WORLD, "WORLD: [text]", data)
	SEND_TEXT(world.log, "WORLD: [text]")
