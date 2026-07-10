#define SEVERITY_ALERT    1 //Alert: action must be taken immediately
#define SEVERITY_CRITICAL 2 //Critical: critical conditions
#define SEVERITY_ERROR    3 //Error: error conditions
#define SEVERITY_WARNING  4 //Warning: warning conditions
#define SEVERITY_NOTICE   5 //Notice: normal but significant condition
#define SEVERITY_INFO     6 //Informational: informational messages
#define SEVERITY_DEBUG    7 //Debug: debug-level messages

/// The number of entries to store per category, don't make this too large or you'll start to see performance issues.
#define CONFIG_MAX_CACHED_LOG_ENTRIES 1000

/// The number of minimum ticks between each log re-render. Admins can still manually request a re-render.
#define LOG_UPDATE_TIMEOUT 5 SECONDS

// Logging types for log_message()
#define LOG_ATTACK (1 << 0)
#define LOG_SAY (1 << 1)
#define LOG_WHISPER (1 << 2)
#define LOG_EMOTE (1 << 3)
#define LOG_DSAY (1 << 4)
#define LOG_PDA (1 << 5)
#define LOG_CHAT (1 << 6)
#define LOG_COMMENT (1 << 7)
#define LOG_TELECOMMS (1 << 8)
#define LOG_OOC (1 << 9)
#define LOG_ADMIN (1 << 10)
#define LOG_OWNERSHIP (1 << 11)
#define LOG_GAME (1 << 12)
#define LOG_ADMIN_PRIVATE (1 << 13)
#define LOG_ASAY (1 << 14)
#define LOG_MECHA (1 << 15)
/// Bit 16 is tg virology logging, leaving empty for the moment
#define LOG_SHUTTLE (1 << 17)
#define LOG_ECON (1 << 18)
#define LOG_VICTIM (1 << 19)
#define LOG_RADIO_EMOTE (1 << 20)
#define LOG_SPEECH_INDICATORS (1 << 21)
#define LOG_TRANSPORT (1 << 22)

// Individual logging panel pages.
#define INDIVIDUAL_GAME_LOG (LOG_GAME)
#define INDIVIDUAL_ATTACK_LOG (LOG_ATTACK | LOG_VICTIM)
#define INDIVIDUAL_SAY_LOG (LOG_SAY | LOG_WHISPER | LOG_DSAY | LOG_SPEECH_INDICATORS)
#define INDIVIDUAL_EMOTE_LOG (LOG_EMOTE | LOG_RADIO_EMOTE)
#define INDIVIDUAL_COMMS_LOG (LOG_PDA | LOG_CHAT | LOG_COMMENT | LOG_TELECOMMS)
#define INDIVIDUAL_OOC_LOG (LOG_OOC | LOG_ADMIN)
#define INDIVIDUAL_SHOW_ALL_LOG (LOG_ATTACK | LOG_SAY | LOG_WHISPER | LOG_EMOTE | LOG_RADIO_EMOTE | LOG_DSAY | LOG_PDA | LOG_CHAT | LOG_COMMENT | LOG_TELECOMMS | LOG_OOC | LOG_ADMIN | LOG_OWNERSHIP | LOG_GAME | LOG_ADMIN_PRIVATE | LOG_ASAY | LOG_MECHA | LOG_SHUTTLE | LOG_ECON | LOG_VICTIM | LOG_SPEECH_INDICATORS | LOG_TRANSPORT)

#define LOGSRC_CKEY "Ckey"
#define LOGSRC_MOB "Mob"

// Log header keys
#define LOG_HEADER_CATEGORY "cat"
#define LOG_HEADER_CATEGORY_LIST "cat-list"
#define LOG_HEADER_INIT_TIMESTAMP "ts"
#define LOG_HEADER_ROUND_ID "round-id"
#define LOG_HEADER_SECRET "secret"

// Log json keys
#define LOG_JSON_CATEGORY "cat"
#define LOG_JSON_ENTRIES "entries"
#define LOG_JSON_LOGGING_START "log-start"

// Log entry keys
#define LOG_ENTRY_KEY_TIMESTAMP "ts"
#define LOG_ENTRY_KEY_CATEGORY "cat"
#define LOG_ENTRY_KEY_MESSAGE "msg"
#define LOG_ENTRY_KEY_DATA "data"
#define LOG_ENTRY_KEY_WORLD_STATE "w-state"
#define LOG_ENTRY_KEY_SEMVER_STORE "s-store"
#define LOG_ENTRY_KEY_ID "id"
#define LOG_ENTRY_KEY_SCHEMA_VERSION "s-ver"

// Internal categories
#define LOG_CATEGORY_INTERNAL_CATEGORY_NOT_FOUND "internal-category-not-found"
#define LOG_CATEGORY_INTERNAL_ERROR "internal-error"

// Misc categories
#define LOG_CATEGORY_ATTACK "attack"
#define LOG_CATEGORY_COMBAT "combat"
#define LOG_CATEGORY_CONFIG "config"
#define LOG_CATEGORY_DEBUG_MAPPING "debug-mapping"
#define LOG_CATEGORY_FILTER "filter"
#define LOG_CATEGORY_HARDDEL "harddel"
#define LOG_CATEGORY_LOADOUT "loadout"
#define LOG_CATEGORY_MANIFEST "manifest"
#define LOG_CATEGORY_MISC "misc"
#define LOG_CATEGORY_NTSL "ntsl"
#define LOG_CATEGORY_PAPER "paper"
#define LOG_CATEGORY_PERF "perf"
#define LOG_CATEGORY_QDEL "qdel"
#define LOG_CATEGORY_SIGNAL "signal"
#define LOG_CATEGORY_SUSPICIOUS_LOGIN "suspicious_logins"
#define LOG_CATEGORY_TELECOMMS "telecomms"
#define LOG_CATEGORY_TGS "tgs"
#define LOG_CATEGORY_TOOL "tool"
#define LOG_CATEGORY_TOPIC "topic"
#define LOG_CATEGORY_WORLD "world"

// Debug categories
#define LOG_CATEGORY_DEBUG "debug"
#define LOG_CATEGORY_DEBUG_ASSET "debug-asset"
#define LOG_CATEGORY_DEBUG_JOB "debug-job"
#define LOG_CATEGORY_DEBUG_LUA "debug-lua"
#define LOG_CATEGORY_DEBUG_SQL "debug-sql"
#define LOG_CATEGORY_RUNTIME "runtime"

// HREF categories
#define LOG_CATEGORY_HREF "href"
#define LOG_CATEGORY_HREF_TGUI "href-tgui"

// Admin categories
#define LOG_CATEGORY_ADMIN "admin"
#define LOG_CATEGORY_ADMIN_CIRCUIT "admin-circuit"
#define LOG_CATEGORY_ADMIN_DSAY "admin-dsay"
#define LOG_CATEGORY_ADMIN_PRIVATE "adminprivate"
#define LOG_CATEGORY_ADMIN_PRIVATE_ASAY "adminprivate-asay"

// Game categories
#define LOG_CATEGORY_GAME "game"
#define LOG_CATEGORY_GAME_ACCESS "game-access"
#define LOG_CATEGORY_GAME_EMOTE "game-emote"
#define LOG_CATEGORY_GAME_GHOST_POLLS "game-ghost-polls"
#define LOG_CATEGORY_GAME_INTERNET_REQUEST "game-internet-request"
#define LOG_CATEGORY_GAME_MINIMAP_DRAWING "game-minimap-drawing"
#define LOG_CATEGORY_GAME_OOC "game-ooc"
#define LOG_CATEGORY_GAME_PRAYER "game-prayer"
#define LOG_CATEGORY_GAME_RADIO_EMOTE "game-radio-emote"
#define LOG_CATEGORY_GAME_SAY "game-say"
#define LOG_CATEGORY_GAME_TOPIC "game-topic"
#define LOG_CATEGORY_GAME_TRAITOR "game-traitor"
#define LOG_CATEGORY_GAME_VOTE "game-vote"
#define LOG_CATEGORY_GAME_WHISPER "game-whisper"

// Uplink categories
#define LOG_CATEGORY_UPLINK "uplink"
#define LOG_CATEGORY_UPLINK_CHANGELING "uplink-changeling"
#define LOG_CATEGORY_UPLINK_HERETIC "uplink-heretic"
#define LOG_CATEGORY_UPLINK_MALF "uplink-malf"
#define LOG_CATEGORY_UPLINK_SPELL "uplink-spell"

// PDA categories
#define LOG_CATEGORY_PDA "pda"
#define LOG_CATEGORY_PDA_CHAT "pda-chat"
#define LOG_CATEGORY_PDA_COMMENT "pda-comment"

// Aurora subsystem categories
#define LOG_CATEGORY_SUBSYSTEM "subsystem"
#define LOG_CATEGORY_SUBSYSTEM_ATLAS "subsystem-atlas"
#define LOG_CATEGORY_SUBSYSTEM_CARGO "subsystem-cargo"
#define LOG_CATEGORY_SUBSYSTEM_CHEMISTRY "subsystem-chemistry"
#define LOG_CATEGORY_SUBSYSTEM_CODEX "subsystem-codex"
#define LOG_CATEGORY_SUBSYSTEM_DBCORE "subsystem-dbcore"
#define LOG_CATEGORY_SUBSYSTEM_DISCORD "subsystem-discord"
#define LOG_CATEGORY_SUBSYSTEM_DOCUMENTS "subsystem-documents"
#define LOG_CATEGORY_SUBSYSTEM_FAIL2TOPIC "subsystem-fail2topic"
#define LOG_CATEGORY_SUBSYSTEM_GARBAGE "subsystem-garbage"
#define LOG_CATEGORY_SUBSYSTEM_GHOSTROLES "subsystem-ghostroles"
#define LOG_CATEGORY_SUBSYSTEM_HTTP "subsystem-http"
#define LOG_CATEGORY_SUBSYSTEM_IPINTEL "subsystem-ipintel"
#define LOG_CATEGORY_SUBSYSTEM_LAW "subsystem-law"
#define LOG_CATEGORY_SUBSYSTEM_MAPFINALIZATION "subsystem-mapfinalization"
#define LOG_CATEGORY_SUBSYSTEM_ODYSSEY "subsystem-odyssey"
#define LOG_CATEGORY_SUBSYSTEM_PERSISTENCE "subsystem-persistence"
#define LOG_CATEGORY_SUBSYSTEM_SENTRY "subsystem-sentry"
#define LOG_CATEGORY_SUBSYSTEM_TGUI "subsystem-tgui"
#define LOG_CATEGORY_SUBSYSTEM_ZAS "subsystem-zas"
#define LOG_CATEGORY_SUBSYSTEM_ZAS_DEBUG "subsystem-zas-debug"

// Aurora module categories
#define LOG_CATEGORY_MODULE "module"
#define LOG_CATEGORY_MODULE_CUSTOMITEMS "module-customitems"
#define LOG_CATEGORY_MODULE_EXOPLANETS "module-exoplanets"
#define LOG_CATEGORY_MODULE_GHOSTROLES "module-ghostroles"
#define LOG_CATEGORY_MODULE_RUINS "module-ruins"
#define LOG_CATEGORY_MODULE_SECTORS "module-sectors"

// Flags that apply to /datum/log_category/var/entry_flags.
/// Enables data list usage for readable log entries.
#define ENTRY_USE_DATA_W_READABLE (1<<0)

#define SCHEMA_VERSION "schema-version"

// Default log schema version.
#define LOG_CATEGORY_SCHEMA_VERSION_NOT_SET "0.0.1"

/**
 * The path where the logs should be saved
 */
#define LOGPATH(file) "./data/logs/[GLOB.round_id]/[file]"

//wrapper macros for easier grepping
#define DIRECT_OUTPUT(A, B) A << B
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
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
rustg_log_write(LOGPATH(file), "[GLOB.round_id] [text]", "true");\
\
if(GLOB.config?.all_logs_to_chat) { \
	to_chat(world, "\[[file]\]: [text]");\
}\
if(GLOB.config?.condense_all_logs) {\
	rustg_log_write(LOGPATH("condensed.log"), "[GLOB.round_id] [text]", "true");\
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
if(isnull(config) || CONFIG_GET(flag/log_debug)) { \
	log_debug(msg + " @@@ [__FILE__]:[__LINE__]");\
}
