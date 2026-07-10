/proc/log_subsystem_ghostroles(text)
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_GHOSTROLES, "SSGhostroles: [text]")

/**
 * This is used to highlight errors in github
 */
/proc/log_subsystem_ghostroles_error(text)
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_GHOSTROLES, "ERROR: SSGhostroles: [text]")
