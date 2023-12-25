/// Logging for writing made on paper
/proc/log_paper(text)
	WRITE_LOG(config.logfiles["world_paper_log"], "PAPER: [text]")
