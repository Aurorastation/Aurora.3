#define SS_INIT_MISC_FIRST  22
#define SS_INIT_SEEDS       21	// Plant controller setup.
#define SS_INIT_MAPLOAD     20	// DMM parsing and load. Unless you know what you're doing, make sure this remains first.
#define SS_INIT_JOBS        19
#define SS_INIT_MAPFINALIZE 18	// Asteroid generation.
#define SS_INIT_SHUTTLE     17	// Shuttle setup.
#define SS_INIT_PARALLAX    16	// Parallax image cache generation. Must run before ghosts are able to join.
#define SS_INIT_HOLOMAP     15
#define SS_INIT_ATOMS       14	// World initialization. Will trigger lighting updates. Observers can join after this loads.
#define SS_INIT_POWER       13	// Initial powernet build.
#define SS_INIT_CARGO       12	// Random warehouse generation. Runs after SSatoms because it assumes objects are initialized when it runs.
#define SS_INIT_PIPENET     11	// Initial pipenet build.
#define SS_INIT_MACHINERY   10	// Machinery prune and powernet build.
#define SS_INIT_AIR         9	// Air setup and pre-bake.
#define SS_INIT_NIGHT       8	// Nightmode controller. Will trigger lighting updates.
#define SS_INIT_SMOOTHING   7	// Object icon smoothing. Creates overlays.
#define SS_INIT_ICON_UPDATE 6	// Icon update queue flush. Should run before overlays.
#define SS_INIT_AO          5	// Wall AO neighbour build.
#define SS_INIT_OVERLAY     4	// Overlay flush.
#define SS_INIT_MISC        3	// Subsystems without an explicitly set initialization order start here.
#define SS_INIT_SUNLIGHT    2	// Sunlight setup. Creates lots of lighting & SSzcopy updates.
#define SS_INIT_LIGHTING    1	// Generation of lighting overlays and pre-bake. May cause openturf updates, should initialize before SSzcopy.
#define SS_INIT_ZCOPY       0	// Z-mimic flush. Should run after SSoverlay & SSicon_smooth so it copies the smoothed sprites.
#define SS_INIT_LOBBY      -1	// Lobby timer starts here. The lobby timer won't actually start going down until the MC starts ticking, so you probably want this last.

// Something to remember when setting priorities: SS_TICKER runs before Normal, which runs before SS_BACKGROUND.
// Each group has its own priority bracket.
// SS_BACKGROUND handles high server load differently than Normal and SS_TICKER do.

// SS_TICKER
#define SS_PRIORITY_OVERLAY        500	// Applies overlays. May cause overlay pop-in if it gets behind.
//#define SS_PRIORITY_DEFAULT      50	// This is defined somewhere else.
#define SS_PRIORITY_TIMER          45	// Timed event scheduling. This is important.
#define SS_PRIORITY_SMOOTHING      35	// Smooth turf generation.
#define SS_PRIORITY_ORBIT          30	// Orbit datum updates.
#define SS_PRIORITY_ICON_UPDATE    20	// Queued icon updates. Mostly used by APCs and tables.

// Normal
#define SS_PRIORITY_TICKER        200	// Gameticker.
#define SS_PRIORITY_MOB           150	// Mob Life().
#define SS_PRIORITY_NANOUI        120	// UI updates.
#define SS_PRIORITY_VOTE          110
#define SS_PRIORITY_ELECTRONICS   100	// Integrated Electronics processing.
#define SS_PRIORITY_MACHINERY      95	// Machinery + powernet ticks.
#define SS_PRIORITY_CHEMISTRY      90	// Multi-tick chemical reactions.
#define SS_PRIORITY_SHUTTLE        85	// Shuttle movement.
#define SS_PRIORITY_CALAMITY       75	// Singularity, Tesla, Nar'sie, blob, etc. 
#define SS_PRIORITY_EVENT          70
#define SS_PRIORITY_LIGHTING       65	// Queued lighting engine updates.
#define SS_PRIORITY_DISEASE        60	// Disease ticks.
#define SS_PRIORITY_AIR            55	// ZAS processing.
//#define SS_PRIORITY_DEFAULT      50	// This is defined somewhere else.
#define SS_PRIORITY_ALARMS         45
#define SS_PRIORITY_PLANTS         40	// Spreading plant effects.
#define SS_PRIORITY_EFFECTS        35	// New-style effects manager. Timing of effects may be off if this gets too far behind.
#define SS_PRIORITY_AIRFLOW        15	// Handles object movement due to ZAS airflow.
#define SS_PRIORITY_ZCOPY          10	// Z-mimic icon generation/updates.

// SS_BACKGROUND
//#define SS_PRIORITY_DEFAULT     50	// This is defined somewhere else.
#define SS_PRIORITY_MODIFIER      18
#define SS_PRIORITY_ARRIVALS      16	// Centcomm arrivals shuttle auto-launch. Usually asleep.
#define SS_PRIORITY_PROCESSING    15	// Generic datum processor. Replaces objects processor.
#define SS_PRIORITY_EXPLOSIVES    13	// Explosion processor. Doesn't have much effect on explosion tick-checking.
#define SS_PRIORITY_DISPOSALS     12	// Disposal holder movement.
#define SS_PRIORITY_WIRELESS      12	// Handles pairing of wireless devices. Usually will be asleep.
#define SS_PRIORITY_NIGHT          5	// Nightmode.
#define SS_PRIORITY_STATISTICS     4	// Player population polling & AFK kick.
#define SS_PRIORITY_SUN            3	// Sun movement & Solar tracking.
#define SS_PRIORITY_GARBAGE        2	// Garbage collection.
