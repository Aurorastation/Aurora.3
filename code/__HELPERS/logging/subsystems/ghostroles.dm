/proc/log_subsystem_ghostroles(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("SSGhostroles: [text]")
#else
	if (GLOB.config?.logsettings["log_subsystems_ghostroles"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_ghostroles_log"], "SSGhostroles: [text]")
#endif
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_GHOSTROLES, "SSGhostroles: [text]")

/**
 * This is used to highlight errors in github
 */
/proc/log_subsystem_ghostroles_error(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_ERROR("SSGhostroles: [text]")
#else
	if (GLOB.config?.logsettings["log_subsystems_ghostroles"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_ghostroles_log"], "SSGhostroles: [text]")
#endif
	logger?.Log(LOG_CATEGORY_SUBSYSTEM_GHOSTROLES, "ERROR: SSGhostroles: [text]")
