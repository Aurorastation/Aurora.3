GLOBAL_VAR(round_id)

/// The directory in which all round log files should be stored.
GLOBAL_VAR(log_directory)
GLOBAL_PROTECT(log_directory)

GLOBAL_VAR(config_error_log)
GLOBAL_PROTECT(config_error_log)

GLOBAL_VAR(perf_log)
GLOBAL_PROTECT(perf_log)

/// Populated by log declaration macros to set log file names.
/world/proc/_initialize_log_files(temp_log_override = null)
	SHOULD_CALL_PARENT(TRUE)
	GLOB.config_error_log = temp_log_override || "[GLOB.log_directory]/config_error.log"
	GLOB.perf_log = "[GLOB.log_directory]/perf.log"
	return

/// Picture logging root used by tg-style camera/picture logging.
GLOBAL_VAR(picture_log_directory)
GLOBAL_PROTECT(picture_log_directory)

GLOBAL_VAR_INIT(picture_logging_id, 1)
GLOBAL_PROTECT(picture_logging_id)

GLOBAL_VAR(picture_logging_prefix)
GLOBAL_PROTECT(picture_logging_prefix)
