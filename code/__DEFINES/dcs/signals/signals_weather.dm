// Signals related to weather and weather transitions
// Sent primarily from weather_fsm.dm

// global (weather) signals
// These are signals which can be listened to by any component on any parent
// start global signals with "!", this used to be necessary but now it's just a formatting choice

/// Called by weather_fsm.dm whenever a weather transition begins
#define COMSIG_GLOB_Z_WEATHER_CHANGE "!z_weather_change"

/// Called by survey_probe.dm whenever a survey probe broadcasts a weather change
#define COMSIG_GLOB_Z_WEATHER_BROADCAST "!z_weather_broadcast"
