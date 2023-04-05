/// Logging for loading and caching assets
/proc/log_asset(text)
	if(config.logsettings["log_asset"])
		WRITE_LOG(config.world_asset_log, "ASSET: [text]")

/// Logging for config errors
/// Rarely gets called; just here in case the config breaks.
/proc/log_config(text)
	WRITE_LOG(config.config_error_log, text)
	SEND_TEXT(world.log, text)

/proc/log_filter_raw(text)
	WRITE_LOG(config.filter_log, "FILTER: [text]")

/// Logging for job slot changes
/proc/log_job_debug(text)
	if (config.logsettings["log_job_debug"])
		WRITE_LOG(config.world_job_debug_log, "JOB: [text]")

/// Logging for lua scripting
/proc/log_lua(text)
	WRITE_LOG(config.lua_log, text)

/// Logging for mapping errors
/proc/log_mapping(text, skip_world_log)
	WRITE_LOG(config.world_map_error_log, text)
	if(skip_world_log)
		return
	SEND_TEXT(world.log, text)

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
	WRITE_LOG(config.world_runtime_log, text)

/proc/_log_signal(text)
	if(config.logsettings["log_signals"])
		WRITE_LOG(config.signals_log, text)

/// Logging for DB errors
/proc/log_sql(text)
	WRITE_LOG(config.sql_error_log, "SQL: [text]")

/// Logging for world/Topic
/proc/_log_topic(text)
	WRITE_LOG(config.world_game_log, "TOPIC: [text]")

/// Log to both DD and the logfile.
/proc/log_world(text)
#ifdef USE_CUSTOM_ERROR_HANDLER
	WRITE_LOG(config.world_runtime_log, text)
#endif
	SEND_TEXT(world.log, text)
