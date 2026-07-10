GLOBAL_VAR(round_id)

/// The directory in which all round log files should be stored.
GLOBAL_VAR(log_directory)
GLOBAL_PROTECT(log_directory)

#define DECLARE_LOG_NAMED(log_var_name, log_file_name)\
GLOBAL_VAR(##log_var_name);\
GLOBAL_PROTECT(##log_var_name);\
/world/_initialize_log_files(temp_log_override = null){\
	..();\
	GLOB.##log_var_name = temp_log_override || "[GLOB.log_directory]/[##log_file_name].log";\
}

#define DECLARE_LOG(log_name) DECLARE_LOG_NAMED(##log_name, "[copytext(#log_name, 1, length(#log_name) - 3)]")

/// Populated by log declaration macros to set log file names.
/world/proc/_initialize_log_files(temp_log_override = null)
	SHOULD_CALL_PARENT(TRUE)
	return

DECLARE_LOG(config_error_log)
DECLARE_LOG(perf_log)

/// Picture logging root used by tg-style camera/picture logging.
GLOBAL_VAR(picture_log_directory)
GLOBAL_PROTECT(picture_log_directory)

GLOBAL_VAR_INIT(picture_logging_id, 1)
GLOBAL_PROTECT(picture_logging_id)

GLOBAL_VAR(picture_logging_prefix)
GLOBAL_PROTECT(picture_logging_prefix)

#undef DECLARE_LOG
#undef DECLARE_LOG_NAMED
