// Process status defines
#define PROCESS_STATUS_IDLE 1
#define PROCESS_STATUS_QUEUED 2
#define PROCESS_STATUS_RUNNING 3
#define PROCESS_STATUS_MAYBE_HUNG 4
#define PROCESS_STATUS_PROBABLY_HUNG 5
#define PROCESS_STATUS_HUNG 6

// Process time thresholds
#define PROCESS_DEFAULT_HANG_WARNING_TIME 	900 // 90 seconds
#define PROCESS_DEFAULT_HANG_ALERT_TIME 	1800 // 180 seconds
#define PROCESS_DEFAULT_HANG_RESTART_TIME 	2400 // 240 seconds
#define PROCESS_DEFAULT_SCHEDULE_INTERVAL 	50  // 50 ticks
#define PROCESS_DEFAULT_TICK_ALLOWANCE		20	// 20% of one tick

// SCHECK macros
// This references src directly to work around a weird bug with try/catch
#define SCHECK_EVERY(this_many_calls) if(++src.calls_since_last_scheck >= this_many_calls) sleepCheck()
#define SCHECK SCHECK_EVERY(50)
