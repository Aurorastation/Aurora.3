/proc/log_module_ruins(text)
	logger?.Log(LOG_CATEGORY_MODULE_RUINS, "Ruins: [text]")

/**
 * Used to highlight warnings on Github during Unit Tests
 */
/proc/log_module_ruins_warning(text)
	logger?.Log(LOG_CATEGORY_MODULE_RUINS, "WARNING: Ruins: [text]")
