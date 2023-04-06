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


//This is an external call, "true" and "false" are how rust parses out booleans

#if defined(UNIT_TEST)
#define WRITE_LOG(file, text) log_world("\[[file]\]: [text]")

#elif DM_VERSION < 515
#define WRITE_LOG(file, text) config.all_logs_to_chat ? to_chat(world, "\[[file]\]: [text]") : rustg_log_write("./data/logs/[game_id]/[file]", "[game_id] \[[__FILE__]:[__LINE__]\]: [text][log_end]", "true")

#else
#define WRITE_LOG(file, text) config.all_logs_to_chat ? to_chat(world, "\[[file]\]: [text]") : rustg_log_write("./data/logs/[game_id]/[file]", "[game_id] [nameof(__PROC__)]: [text][log_end]", "true")

#endif

#define WRITE_LOG_NO_FORMAT(file, text) rustg_log_write(file, text, "false")


#define LOG_DEBUG(msg) log_debug(msg + " @@@ [__FILE__]:[__LINE__]")
