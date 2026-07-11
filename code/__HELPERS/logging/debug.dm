/**
 * Use the macro LOG_DEBUG instead of calling this directly.
 * Used for general_purpose debug logging, please use more specific ones if available, or consider adding your own
 */
/proc/log_debug(text,level = SEVERITY_DEBUG)
	if (isnull(GLOB.config) ? TRUE : GLOB.config.logsettings["log_debug"])
		log_world("DEBUG: [text]")
	logger?.Log(LOG_CATEGORY_DEBUG, "DEBUG: [text]", list("severity" = level))

	if (level == SEVERITY_ERROR) // Errors are always logged
		log_world("ERROR: [text]")
		logger?.Log(LOG_CATEGORY_WORLD, "ERROR: [text]", list("severity" = level))

	for(var/s in GLOB.staff)
		var/client/C = s
		if(!C.prefs) //This is to avoid null.toggles runtime error while still initialyzing players preferences
			return
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			to_chat(C, "<span class='debug'>DEBUG: [text]</span>")

/// Logging for loading and caching assets
/proc/log_asset(text, list/data)
	if(GLOB.config.logsettings["log_asset"])
		WRITE_LOG(GLOB.config.logfiles["world_asset_log"], "ASSET: [text]")
	logger?.Log(LOG_CATEGORY_DEBUG_ASSET, "ASSET: [text]", data)

/// Logging for config errors
/// Rarely gets called; just here in case the config breaks.
/proc/log_config(text, list/data)
	if(GLOB.config_error_log && !GLOB.log_directory)
		rustg_log_write(GLOB.config_error_log, "CONFIG: [text]", "true")

	WRITE_LOG(isnull(GLOB.config) ? "config_error.log" : GLOB.config.logfiles["config_error_log"], "CONFIG: [text]")
	logger?.Log(LOG_CATEGORY_CONFIG, "CONFIG: [text]", data)

	// Do not print to world.log during unit tests
	#if !defined(UNIT_TEST)
	SEND_TEXT(world.log, "CONFIG: [text]")
	#endif

/// Logging for job slot changes
/proc/log_job_debug(text, list/data)
	if (GLOB.config.logsettings["log_job_debug"])
		WRITE_LOG(GLOB.config.logfiles["world_job_debug_log"], "JOB: [text]")
	logger?.Log(LOG_CATEGORY_DEBUG_JOB, "JOB: [text]", data)

/// Logging for game performance
/proc/log_perf(list/perf_info)
	. = "[perf_info.Join(",")]\n"
	WRITE_LOG_NO_FORMAT(GLOB.config.logfiles["perf_log"], .)
	logger?.Log(LOG_CATEGORY_PERF, "[perf_info.Join(",")]", list("perf" = perf_info))

/// Logging for SQL errors
/proc/log_query_debug(text, list/data)
	WRITE_LOG(GLOB.config.logfiles["query_debug_log"], "SQL: [text]")
	logger?.Log(LOG_CATEGORY_DEBUG_SQL, "SQL: [text]", data)

/* Log to the logfile only. */
/proc/log_runtime(text, list/data)
	WRITE_LOG(isnull(GLOB.config) ? "world_runtime.log" : GLOB.config.logfiles["world_runtime_log"], "RUNTIME: [text]")
	logger?.Log(LOG_CATEGORY_RUNTIME, "RUNTIME: [text]", data)

/proc/_log_signal(text, list/data)
	if(GLOB.config.logsettings["log_signals"])
		WRITE_LOG(GLOB.config.logfiles["signals_log"], "SIGNAL: [text]")
	logger?.Log(LOG_CATEGORY_SIGNAL, "SIGNAL: [text]", data)

/// Logging for DB errors
/proc/log_sql(text, list/data)
	WRITE_LOG(GLOB.config.logfiles["sql_error_log"], "SQL: [text]")
	logger?.Log(LOG_CATEGORY_DEBUG_SQL, "SQL: [text]", data)
	if(SSsentry)
		SSsentry.capture_message(text, "error", "sql")

/// Logging for world/Topic
/proc/_log_topic(text, list/data)
	WRITE_LOG(GLOB.config.logfiles["topic_log"], "TOPIC: [text]")
	logger?.Log(LOG_CATEGORY_TOPIC, "TOPIC: [text]", data)

/// Log to both DD and the logfile. A non-list second argument is accepted for legacy callers and ignored.
/proc/log_world(text, data)
	var/list/log_data = islist(data) ? data : null
#ifdef USE_CUSTOM_ERROR_HANDLER
	WRITE_LOG(isnull(GLOB.config) ? "world_runtime.log" : GLOB.config.logfiles["world_runtime_log"], "WORLD: [text]")
#endif
	logger?.Log(LOG_CATEGORY_WORLD, "WORLD: [text]", log_data)
	SEND_TEXT(world.log, "WORLD: [text]")
