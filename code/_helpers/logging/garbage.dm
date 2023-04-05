/// Log for the garbage collector
/proc/log_gc(text, type, high_severity = FALSE)
	WRITE_LOG(config.garbage_collector_log, "GC [text]")
	send_gelf_log(text, "[time_stamp()]: [text]", high_severity ? SEVERITY_WARNING : SEVERITY_DEBUG, "GARBAGE", additional_data = list("_type" = "[type]"))

/proc/log_harddel(text)
	WRITE_LOG(config.harddel_log, text)
