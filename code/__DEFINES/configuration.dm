// Config entry compatibility...
#define CONFIG_GET(X) config.Get(/datum/config_entry/##X)
#define CONFIG_SET(X, Y) config.Set(/datum/config_entry/##X, ##Y)
#define CONFIG_SET_FORCED(X, Y) config.Set(/datum/config_entry/##X, ##Y, TRUE)

/// Config entry cannot be edited through runtime tooling.
#define CONFIG_ENTRY_LOCKED (1<<0)
/// Config entry value should not be exposed through runtime tooling.
#define CONFIG_ENTRY_HIDDEN (1<<1)
