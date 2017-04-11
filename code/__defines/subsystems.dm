#define SS_INIT_MISC_FIRST          6
#define SS_INIT_SEEDS               5
#define SS_INIT_ASTEROID            4	// Asteroid generation.
#define SS_INIT_SHUTTLE             3	// Shuttle setup.
#define SS_INIT_CARGO               2	// Random warehouse generation.
#define SS_INIT_ATOMS               1	// World initialization. Will trigger lighting updates.
#define SS_INIT_TICKER              0	// Lobby timer starts here.
#define SS_INIT_MACHINERY          -1	// Machinery prune and powernet build.
#define SS_INIT_PIPENET            -2	// Initial pipenet build.
#define SS_INIT_ATMOS              -3	// Miscellaneous atmos machinery initialization.
#define SS_INIT_AIR                -4	// Air setup and pre-bake.
#define SS_INIT_PARALLAX           -5	// Parallax image cache generation.
#define SS_INIT_NIGHT              -6	// Nightmode controller. Will trigger lighting updates.
#define SS_INIT_SMOOTHING          -7	// Object icon smoothing. Creates overlays.
#define SS_INIT_OVERLAY            -8	// Overlay flush.
#define SS_INIT_OPENTURF           -9	// Openturf should be after smoothing so it copies the smoothed turfs. Causes lighting updates.
#define SS_INIT_MISC              -10	// Default.
#define SS_INIT_LIGHTING          -11	// Generation of lighting overlays and pre-bake.

// Something to remember when setting priorities: SS_TICKER runs before Normal, which runs before SS_BACKGROUND.
// Each group has its own priority bracket.
// SS_BACKGROUND handles high server load differently than Normal and SS_TICKER do.

// SS_TICKER
#define SS_PRIORITY_OVERLAY        500	// Applies overlays. May cause overlay pop-in if it gets behind.
#define SS_PRIORITY_ORBIT          30	// Orbit datum updates.
#define SS_PRIORITY_SMOOTHING      35   // Smooth turf generation.
#define SS_PRIORITY_DISPOSALS      10	// Disposal holder movement.

// Normal
#define SS_PRIORITY_TICKER         200	// Gameticker.
#define SS_PRIORITY_MOB            150	// Mob Life().
#define SS_PRIORITY_NANOUI         120	// UI updates.
#define SS_PRIORITY_VOTE           110
#define SS_PRIORITY_MACHINERY      95	// Machinery + powernet ticks.
#define SS_PRIORITY_CHEMISTRY      90	// Multi-tick chemical reactions.
#define SS_PRIORITY_SHUTTLE        85	// Shuttle movement.
#define SS_PRIORITY_CALAMITY       80	// Singularity, Tesla, Nar'sie, blob, etc. 
#define SS_PRIORITY_AIR            75	// ZAS processing.
#define SS_PRIORITY_EVENT          70
#define SS_PRIORITY_AIRFLOW        65	// Handles object movement due to ZAS airflow.
#define SS_PRIORITY_DISEASE        60	// Disease ticks.
#define SS_PRIORITY_ALARMS         50
#define SS_PRIORITY_PLANTS         40	// Spreading plant effects.
#define SS_PRIORITY_LIGHTING       20	// Queued lighting engine updates.
#define SS_PRIORITY_AIRFLOW        15

// SS_BACKGROUND
#define SS_PRIORITY_EFFECTS       10	// Effect master (Sparks)
#define SS_PRIORITY_OPENTURF       9	// Open turf icon generation/updates.
#define SS_PRIORITY_EXPLOSIVES     8	// Explosion processor. Doesn't have much effect on explosion tick-checking.
#define SS_PRIORITY_WIRELESS       7
#define SS_PRIORITY_ARRIVALS       6	// Centcomm arrivals shuttle auto-launch.
#define SS_PRIORITY_MODIFIER       5

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
