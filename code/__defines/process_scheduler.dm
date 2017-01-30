// Process status defines
#define PROCESS_STATUS_IDLE 1
#define PROCESS_STATUS_QUEUED 2
#define PROCESS_STATUS_RUNNING 3
#define PROCESS_STATUS_MAYBE_HUNG 4
#define PROCESS_STATUS_PROBABLY_HUNG 5
#define PROCESS_STATUS_HUNG 6

// Process time thresholds
#define PROCESS_DEFAULT_HANG_WARNING_TIME 	300 // 30 seconds
#define PROCESS_DEFAULT_HANG_ALERT_TIME 	600 // 60 seconds
#define PROCESS_DEFAULT_HANG_RESTART_TIME 	900 // 90 seconds
#define PROCESS_DEFAULT_SCHEDULE_INTERVAL 	50  // 50 ticks
#define PROCESS_DEFAULT_TICK_ALLOWANCE		20	// 20% of one tick

// SCHECK macros
// This references src directly to work around a weird bug with try/catch
#define SCHECK sleepCheck()

#define F_SCHECK \
	calls_since_last_scheck = 0; \
	if (killed) CRASH("A killed process is still running somehow..."); \
	if (hung) { \
		handleHung(); \
		CRASH("Process [name] hung and was restarted."); \
	} \
	if (world.tick_usage > 100 || (world.tick_usage - tick_start) > tick_allowance) { \
		sleep(world.tick_lag); \
		cpu_defer_count++; \
		last_slept = TimeOfHour; \
		tick_start = world.tick_usage; \
		}
