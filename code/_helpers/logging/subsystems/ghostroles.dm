/proc/log_subsystem_ghostroles(text)
	if (config?.logsettings["log_subsystems_ghostroles"])
		WRITE_LOG(config.world_subsystems_ghostroles_log, "SSGhostroles: [text]")
