#define SEVERITY_ALERT    1 //Alert: action must be taken immediately
#define SEVERITY_CRITICAL 2 //Critical: critical conditions
#define SEVERITY_ERROR    3 //Error: error conditions
#define SEVERITY_WARNING  4 //Warning: warning conditions
#define SEVERITY_NOTICE   5 //Notice: normal but significant condition
#define SEVERITY_INFO     6 //Informational: informational messages
#define SEVERITY_DEBUG    7 //Debug: debug-level messages

/**
 * The path where the logs should be saved
 */
#define LOGPATH(file) "./data/logs/[game_id]/[file]"

//wrapper macros for easier grepping
#define DIRECT_OUTPUT(A, B) A << B
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)


#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")

/**
 * This is mainly used to prettify and highlight the logs in github, as well as hide the unlikely useful ones (debug)
 */
#if defined(MANUAL_UNIT_TEST)
#define LOG_GITHUB_DEBUG(text)\
SEND_TEXT(world.log, "DEBUG: [text]");\
rustg_log_write(LOGPATH("condensed.log"), "[text][log_end]", "true")

#define LOG_GITHUB_NOTICE(text)\
SEND_TEXT(world.log, "NOTICE: [text] @@@ → [__FILE__]:[__LINE__]");\
rustg_log_write(LOGPATH("condensed.log"), "[text][log_end]", "true")

#define LOG_GITHUB_WARNING(text)\
SEND_TEXT(world.log, "WARNING: [text] @@@ → [__FILE__]:[__LINE__]");\
rustg_log_write(LOGPATH("condensed.log"), "[text][log_end]", "true")

#define LOG_GITHUB_ERROR(text)\
SEND_TEXT(world.log, "ERROR: [text] @@@ → [__FILE__]:[__LINE__]");\
rustg_log_write(LOGPATH("condensed.log"), "[text][log_end]", "true")



#else
#define LOG_GITHUB_DEBUG(text)\
SEND_TEXT(world.log, "::debug::[text]");\
rustg_log_write(LOGPATH("condensed.log"), "[text][log_end]", "true")

#define LOG_GITHUB_NOTICE(text)\
SEND_TEXT(world.log, "::notice file=[__FILE__],line=[__LINE__]::[text]");\
rustg_log_write(LOGPATH("condensed.log"), "[text][log_end]", "true")

#define LOG_GITHUB_WARNING(text)\
SEND_TEXT(world.log, "::warning file=[__FILE__],line=[__LINE__]::[text]");\
rustg_log_write(LOGPATH("condensed.log"), "[text][log_end]", "true")

#define LOG_GITHUB_ERROR(text)\
SEND_TEXT(world.log, "::error file=[__FILE__],line=[__LINE__]::[text]");\
rustg_log_write(LOGPATH("condensed.log"), "[text][log_end]", "true")

#endif

/**
 * This handles the log_world (and consequently log_debug) to be printed to config.world_runtime_log during debugging or unit testing,
 * otherwise, they are only printed to world.log
 */
#if defined(DEBUG)
#define USE_CUSTOM_ERROR_HANDLER
#elif defined(UNIT_TEST)
#define USE_CUSTOM_ERROR_HANDLER
#endif


/**
 * Handles the log writing in different scenarios:
 *
 * - UNIT_TEST: Send to world.log, which gets captured by github, and the condensed logfile
 * - PRE-515: Use FILE:LINE format to reference the location
 * - POST-515: Use nameof(proc) format to reference the proc name
 */
#if defined(UNIT_TEST)
#define WRITE_LOG(file, text) \
SEND_TEXT(world.log, "\[[file]\]: [text]");\
rustg_log_write(LOGPATH("condensed.log"), "[text]", "true")

#else
#define WRITE_LOG(file, text)\
rustg_log_write(LOGPATH(file), "[game_id] [text]", "true");\
\
if(GLOB.config?.all_logs_to_chat) { \
	to_chat(world, "\[[file]\]: [text]");\
}\
if(GLOB.config?.condense_all_logs) {\
	rustg_log_write(LOGPATH("condensed.log"), "[game_id] [text]", "true");\
}
#endif

/**
 * Basically the same as WRITE_LOG, but do not format the text
 */
#if defined(UNIT_TEST)
#define WRITE_LOG_NO_FORMAT(file, text) \
SEND_TEXT(world.log, "\[[file]\]: [text]");\
rustg_log_write(LOGPATH("condensed.log"), text, "false");

#else
#define WRITE_LOG_NO_FORMAT(file, text)\
rustg_log_write(LOGPATH(file), text, "false");\
\
if(GLOB.config?.all_logs_to_chat) { \
	to_chat(world, "\[[file]\]: [text]");\
}\
if(GLOB.config?.condense_all_logs) { \
	rustg_log_write(LOGPATH("condensed.log"), text, "false");\
}

#endif


//// INLINER DEFINES ////

#define LOG_DEBUG(msg)\
if(GLOB.config?.logsettings["log_debug"]) { \
	log_debug(msg + " @@@ [__FILE__]:[__LINE__]");\
}
