#define SEVERITY_ALERT    1 //Alert: action must be taken immediately
#define SEVERITY_CRITICAL 2 //Critical: critical conditions
#define SEVERITY_ERROR    3 //Error: error conditions
#define SEVERITY_WARNING  4 //Warning: warning conditions
#define SEVERITY_NOTICE   5 //Notice: normal but significant condition
#define SEVERITY_INFO     6 //Informational: informational messages
#define SEVERITY_DEBUG    7 //Debug: debug-level messages

//wrapper macros for easier grepping
#define DIRECT_OUTPUT(A, B) A << B
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)


#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")

// This is to suppress their printing out by default, as they are a ton and doesn't seem often
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


//This is an external call, "true" and "false" are how rust parses out booleans

#if defined(UNIT_TEST)
#define WRITE_LOG(file, text) SEND_TEXT(world.log, "\[[file]\]: [text]")

#elif DM_VERSION < 515
#define WRITE_LOG(file, text)\
rustg_log_write("./data/logs/[game_id]/[file]", "[game_id] \[[__FILE__]:[__LINE__]\]: [text][log_end]", "true");\
\
if(config?.all_logs_to_chat) { \
	to_chat(world, "\[[file]\]: [text]");\
}\
\
if(config?.condense_all_logs) {\
	rustg_log_write("./data/logs/[game_id]/condensed.log", "[game_id] \[[__FILE__]:[__LINE__]\]: [text][log_end]", "true");\
}

#else
#define WRITE_LOG(file, text)\
rustg_log_write("./data/logs/[game_id]/[file]", "[game_id] [nameof(__PROC__)]: [text][log_end]", "true");\
\
if(config?.all_logs_to_chat) { \
	to_chat(world, "\[[file]\]: [text]");\
}\
if(config?.condense_all_logs) {\
	rustg_log_write("./data/logs/[game_id]/condensed.log", "[game_id] [nameof(__PROC__)]: [text][log_end]", "true");\
}
#endif



#define WRITE_LOG_NO_FORMAT(file, text)\
rustg_log_write("./data/logs/[game_id]/[file]", text, "false");\
\
if(config?.all_logs_to_chat) { \
	to_chat(world, "\[[file]\]: [text]");\
}\
if(config?.condense_all_logs) { \
	rustg_log_write("./data/logs/[game_id]/condensed.log", text, "false");\
}

//// INLINER DEFINES ////

#define LOG_DEBUG(msg)\
if(config?.logsettings["log_debug"]) { \
	log_debug(msg + " @@@ [__FILE__]:[__LINE__]");\
}
