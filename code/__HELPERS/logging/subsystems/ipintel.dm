/// Logging for the IPIntel (XKeyScore) subsystem
/proc/log_subsystem_ipintel(text)
	if (GLOB.config?.logsettings["log_subsystems_ipintel"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_ipintel"], "IPINTEL: [text]")
