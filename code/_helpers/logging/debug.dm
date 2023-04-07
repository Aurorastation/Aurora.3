/**
 * Use the macro LOG_DEBUG instead of calling this directly.
 * Used for general_purpose debug logging, please use more specific ones if available, or consider adding your own
 */
/proc/log_debug(text,level = SEVERITY_DEBUG)
	if (isnull(config) ? TRUE : config.logsettings["log_debug"])
		log_world("DEBUG: [text]")

	if (level == SEVERITY_ERROR) // Errors are always logged
		log_world("ERROR: [text]")

	for(var/s in staff)
		var/client/C = s
		if(!C.prefs) //This is to avoid null.toggles runtime error while still initialyzing players preferences
			return
		if(C.prefs.toggles & CHAT_DEBUGLOGS)
			to_chat(C, "DEBUG: [text]")
	send_gelf_log(short_message = text, long_message = "[time_stamp()]: [text]", level = level, category = "DEBUG")

/// Logging for loading and caching assets
/proc/log_asset(text)
	if(config.logsettings["log_asset"])
		WRITE_LOG(config.world_asset_log, "ASSET: [text]")

/// Logging for config errors
/// Rarely gets called; just here in case the config breaks.
/proc/log_config(text)
	WRITE_LOG(isnull(config) ? "config_error.log" : config.config_error_log, "CONFIG: [text]")
	SEND_TEXT(world.log, "CONFIG: [text]")

/proc/log_filter_raw(text)
	WRITE_LOG(config.filter_log, "FILTER: [text]")

/// Logging for job slot changes
/proc/log_job_debug(text)
	if (config.logsettings["log_job_debug"])
		WRITE_LOG(config.world_job_debug_log, "JOB: [text]")

/// Logging for lua scripting
/proc/log_lua(text)
	WRITE_LOG(config.lua_log, "LUA: [text]")

/// Logging for mapping errors
/proc/log_mapping(text, skip_world_log)
	WRITE_LOG(config.world_map_error_log, "MAPPING: [text]")
	if(skip_world_log)
		return
	SEND_TEXT(world.log, "MAPPING: [text]")

/// Logging for game performance
/proc/log_perf(list/perf_info)
	. = "[perf_info.Join(",")]\n"
	WRITE_LOG_NO_FORMAT(config.perf_log, .)

/// Logging for hard deletes
/proc/log_qdel(text)
	WRITE_LOG(config.world_qdel_log, "QDEL: [text]")

/// Logging for SQL errors
/proc/log_query_debug(text)
	WRITE_LOG(config.query_debug_log, "SQL: [text]")

/* Log to the logfile only. */
/proc/log_runtime(text)
	WRITE_LOG(isnull(config) ? "world_runtime.log" : config.world_runtime_log, "RUNTIME: [text]")

/proc/_log_signal(text)
	if(config.logsettings["log_signals"])
		WRITE_LOG(config.signals_log, "SIGNAL: [text]")

/// Logging for DB errors
/proc/log_sql(text)
	WRITE_LOG(config.sql_error_log, "SQL: [text]")

/// Logging for world/Topic
/proc/_log_topic(text)
	WRITE_LOG(config.world_game_log, "TOPIC: [text]")

/// Log to both DD and the logfile.
/proc/log_world(text)
#ifdef USE_CUSTOM_ERROR_HANDLER
	WRITE_LOG(isnull(config) ? "world_runtime.log" : config.world_runtime_log, "WORLD: [text]")
#endif
	SEND_TEXT(world.log, "WORLD: [text]")
