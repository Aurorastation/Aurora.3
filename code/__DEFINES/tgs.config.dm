#define TGS_EXTERNAL_CONFIGURATION
#define TGS_DEFINE_AND_SET_GLOBAL(Name, Value) GLOBAL_VAR_INIT(##Name, ##Value); GLOBAL_PROTECT(##Name)
#define TGS_READ_GLOBAL(Name) GLOB.##Name
#define TGS_WRITE_GLOBAL(Name, Value) GLOB.##Name = ##Value
#define TGS_WORLD_ANNOUNCE(message) to_chat(world, SPAN_BOLDANNOUNCE("[html_encode(##message)]"))
#define TGS_INFO_LOG(message) tgs_info_log(##message)
#define TGS_WARNING_LOG(message) tgs_warning_log(##message)
#define TGS_ERROR_LOG(message) tgs_error_log(##message)
#define TGS_NOTIFY_ADMINS(event) message_admins(##event)
#define TGS_CLIENT_COUNT GLOB.clients.len
#define TGS_PROTECT_DATUM(Path) GENERAL_PROTECT_DATUM(##Path)
