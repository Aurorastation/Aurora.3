// Signals related to weather and weather transitions
// Sent primarily from weather_fsm.dm

// global (weather) signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice

/// Called by weather_fsm.dm whenever a weather transition begins
#define COMSIG_GLOB_Z_WEATHER_CHANGE "!z_weather_change"

/// Called by survey_probe.dm whenever a survey probe broadcasts a weather change
#define COMSIG_GLOB_Z_WEATHER_BROADCAST "!z_weather_broadcast"

/// Called by SSweather after a weather system is registered: (obj/abstract/weather_system/weather)
#define COMSIG_WEATHER_SYSTEM_REGISTERED "weather_system_registered"

/// Called by SSweather after a weather system is unregistered: (obj/abstract/weather_system/weather)
#define COMSIG_WEATHER_SYSTEM_UNREGISTERED "weather_system_unregistered"

/// Called by a weather system after its visual state changes: (obj/abstract/weather_system/weather)
#define COMSIG_WEATHER_SYSTEM_UPDATED "weather_system_updated"
