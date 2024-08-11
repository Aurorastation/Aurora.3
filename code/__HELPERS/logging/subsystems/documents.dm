/proc/log_subsystem_documents(text)
#if defined(UNIT_TEST)
	LOG_GITHUB_DEBUG("SSdocuments: [text]")
#else
	if (GLOB.config?.logsettings["log_subsystems_documents"])
		WRITE_LOG(GLOB.config.logfiles["world_subsystems_documents_log"], "SSDocuments: [text]")
#endif
