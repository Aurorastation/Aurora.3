/// Logging for mapping
/proc/log_mapping(text, skip_world_log)
	logger?.Log(LOG_CATEGORY_DEBUG_MAPPING, "MAPPING: [text]", list("error" = FALSE))
	if(skip_world_log)
		return
	SEND_TEXT(world.log, "MAPPING: [text]")

/// Logging for mapping errors
/proc/log_mapping_error(text, skip_world_log)
	logger?.Log(LOG_CATEGORY_DEBUG_MAPPING, "MAPPING: [text]", list("error" = TRUE))
	if(skip_world_log)
		return
	SEND_TEXT(world.log, "MAPPING: [text]")
