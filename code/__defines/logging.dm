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


#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")

/**
 * This is to suppress their printing out in github by default, as they are a ton and doesn't seem often useful
 * Run the UTs in debug mode to see them
 *
 * Eventually to pack them up and upload as artifact?
 */
#define LOG_GITHUB_DEBUG(text) SEND_TEXT(world.log, "::debug::[text]")


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
 * - UNIT_TEST: Send to world.log, which gets captured by github
 * - PRE-515: Use FILE:LINE format to reference the location
 * - POST-515: Use nameof(proc) format to reference the proc name
 */
#if defined(UNIT_TEST)
#define WRITE_LOG(file, text) SEND_TEXT(world.log, "\[[file]\]: [text]")

#elif DM_VERSION < 515
#define WRITE_LOG(file, text)\
rustg_log_write(LOGPATH(file), "[game_id] \[[__FILE__]:[__LINE__]\]: [text][log_end]", "true");\
\
if(config?.all_logs_to_chat) { \
	to_chat(world, "\[[file]\]: [text]");\
}\
\
if(config?.condense_all_logs) {\
	rustg_log_write(LOGPATH("condensed.log"), "[game_id] \[[__FILE__]:[__LINE__]\]: [text][log_end]", "true");\
}

#else
#define WRITE_LOG(file, text)\
rustg_log_write(LOGPATH(file), "[game_id] [nameof(__PROC__)]: [text][log_end]", "true");\
\
if(config?.all_logs_to_chat) { \
	to_chat(world, "\[[file]\]: [text]");\
}\
if(config?.condense_all_logs) {\
	rustg_log_write(LOGPATH("condensed.log"), "[game_id] [nameof(__PROC__)]: [text][log_end]", "true");\
}
#endif

/**
 * Basically the same as WRITE_LOG, but do not format the text
 */
#if defined(UNIT_TEST)
#define WRITE_LOG_NO_FORMAT(file, text) SEND_TEXT(world.log, "\[[file]\]: [text]")

#else
#define WRITE_LOG_NO_FORMAT(file, text)\
rustg_log_write(LOGPATH(file), text, "false");\
\
if(config?.all_logs_to_chat) { \
	to_chat(world, "\[[file]\]: [text]");\
}\
if(config?.condense_all_logs) { \
	rustg_log_write(LOGPATH("condensed.log"), text, "false");\
}

#endif


//// INLINER DEFINES ////

#define LOG_DEBUG(msg)\
if(config?.logsettings["log_debug"]) { \
	log_debug(msg + " @@@ [__FILE__]:[__LINE__]");\
}
