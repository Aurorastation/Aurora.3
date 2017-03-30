#define SS_INIT_MISC_FIRST			13
#define SS_INIT_ASTEROID			12
#define SS_INIT_OBJECTS			    11
#define SS_INIT_AREA				10	// Includes turf initialization.
#define SS_INIT_SHUTTLE             9
#define SS_INIT_POWERNET            8
#define SS_INIT_PIPENET				7
#define SS_INIT_ATMOS				6
#define SS_INIT_AIR                 5
#define SS_INIT_PARALLAX			4
#define SS_INIT_LIGHTING			3	// Generation of lighting overlays, but not pre-bake.
#define SS_INIT_CARGO 				2	// Random warehouse generation.
#define SS_INIT_MISC				1	// Default.
#define SS_INIT_TICKER 				0	// Should be last-ish. Lobby timer starts here.
#define SS_INIT_SMOOTHING          -1
#define SS_INIT_OVERLAY            -2
#define SS_INIT_NIGHT              -4	// Nightmode controller. Will trigger lighting updates.

// Something to remember when setting priorities: SS_TICKER runs before Normal, which runs before SS_BACKGROUND.
// Each group has its own priority bracket.
// SS_BACKGROUND handles high server load differently than Normal and SS_TICKER do.

// SS_TICKER
#define SS_PRIORITY_OVERLAY        500	// Applies overlays. May cause overlay pop-in if it gets behind.
#define SS_PRIORITY_ORBIT          30	// Orbit datum updates.
#define SS_PRIORITY_SMOOTHING      35   // Smooth turf generation.
#define SS_PRIORITY_AIRFLOW        20	// Handles object movement due to ZAS airflow.
#define SS_PRIORITY_DISPOSALS      10	// Disposal holder movement.

// Normal
#define SS_PRIORITY_TICKER         200	// Gameticker.
#define SS_PRIORITY_MOB            150
#define SS_PRIORITY_NANOUI         120
#define SS_PRIORITY_VOTE           110
#define SS_PRIORITY_MACHINERY      90	// Machinery + powernet ticks.
#define SS_PRIORITY_CHEMISTRY      85
#define SS_PRIORITY_SHUTTLE        80
#define SS_PRIORITY_SINGULARITY    75	// Singularity, Tesla, and Nar'sie processing.
#define SS_PRIORITY_AIR            70	// ZAS processing.
#define SS_PRIORITY_EVENT          65
#define SS_PRIORITY_DISEASE        60	// Disease ticks.
#define SS_PRIORITY_ALARMS         50
#define SS_PRIORITY_PLANTS         40	// Spreading plant effects.
#define SS_PRIORITY_LIGHTING       20	// Queued lighting engine updates.
#define SS_PRIORITY_MODIFIER       10

// SS_BACKGROUND
#define SS_PRIORITY_PROCESSING     10	// Generic datum processor. Replaces objects processor.
#define SS_PRIORITY_OBJECTS        9
#define SS_PRIORITY_EFFECTS        8	// Effect master (Sparks)
#define SS_PRIORITY_EXPLOSIVES     7	// Explosion processor. Doesn't have much effect on explosion tick-checking.
#define SS_PRIORITY_WIRELESS       6	// Handles pairing of wireless devices. Usually will be asleep.
#define SS_PRIORITY_NIGHT          5	// Nightmode.
#define SS_PRIORITY_STATISTICS     4	// Player population polling & AFK kick.
#define SS_PRIORITY_SUN            3	// Sun movement & Solar tracking.
#define SS_PRIORITY_GARBAGE        2	// Garbage collection.
