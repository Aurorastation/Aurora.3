#define SS_INIT_MISC_FIRST			13
#define SS_INIT_ASTEROID			12
#define SS_INIT_JOBS				11
#define SS_INIT_OBJECTS			    10
#define SS_INIT_AREA				9
#define SS_INIT_SHUTTLE             8
#define SS_INIT_POWERNET            7
#define SS_INIT_PIPENET				6
#define SS_INIT_ATMOS				5
#define SS_INIT_PARALLAX			4
#define SS_INIT_LIGHTING			3
#define SS_INIT_CARGO 				2
#define SS_INIT_MISC				1
#define SS_INIT_OVERLAY             -1
#define SS_INIT_TICKER 				-2	// Should be last.

#define SS_PRIORITY_TICKER         200
#define SS_PRIORITY_MOB            150
#define SS_PRIORITY_NANOUI         120
#define SS_PRIORITY_VOTE           110
#define SS_PRIORITY_OBJECTS        100
#define SS_PRIORITY_PROCESSING     100	// Basically the objects processor, so same priority.
#define SS_PRIORITY_MACHINERY      90	// Machinery + powernet ticks.
#define SS_PRIORITY_AIR            70	// ZAS processing.
#define SS_PRIORITY_EVENT          65
#define SS_PRIORITY_DISEASE        60	// Disease ticks.
#define SS_PRIORITY_PLANTS         40	// Spreading plant effects.
#define SS_PRIORITY_ORBIT          30	// Orbit datum updates.
#define SS_PRIORITY_LIGHTING       20	// Queued lighting engine updates.
#define SS_PRIORITY_SUN            3
#define SS_PRIORITY_GARBAGE        2	// (SS_BACKGROUND)
