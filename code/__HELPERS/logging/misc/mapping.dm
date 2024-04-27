/// Logging for mapping
/proc/log_mapping(text, skip_world_log)
#if defined(UNIT_TEST)
	LOG_GITHUB_NOTICE("Mapping: [text]")
#else
	WRITE_LOG(GLOB.config.logfiles["world_map_error_log"], "MAPPING: [text]")
	if(skip_world_log)
		return
	SEND_TEXT(world.log, "MAPPING: [text]")
#endif

/// Logging for mapping errors
/proc/log_mapping_error(text, skip_world_log)
#if defined(UNIT_TEST)
	LOG_GITHUB_ERROR("Mapping: [text]")
#else
	WRITE_LOG(GLOB.config.logfiles["world_map_error_log"], "MAPPING: [text]")
	if(skip_world_log)
		return
	SEND_TEXT(world.log, "MAPPING: [text]")
#endif
