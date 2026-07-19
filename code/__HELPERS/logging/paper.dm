/// Logging for writing made on paper
/proc/log_paper(text, list/data)
	WRITE_LOG(GLOB.config.logfiles["world_paper_log"], "PAPER: [text]")
	logger?.Log(LOG_CATEGORY_PAPER, "PAPER: [text]", data)
