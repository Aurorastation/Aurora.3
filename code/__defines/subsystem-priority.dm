#define SS_INIT_PERSISTENT_CONFIG 24
#define SS_INIT_MISC_FIRST  23
#define SS_INIT_SEEDS       22	// Plant controller setup.
#define SS_INIT_MAPLOAD     21	// DMM parsing and load. Unless you know what you're doing, make sure this remains first.
#define SS_INIT_JOBS        20
#define SS_INIT_MAPFINALIZE 19	// Asteroid generation.
#define SS_INIT_PARALLAX    17	// Parallax image cache generation. Must run before ghosts are able to join.
#define SS_INIT_HOLOMAP     16
#define SS_INIT_ATOMS       15	// World initialization. Will trigger lighting updates. Observers can join after this loads.
#define SS_INIT_POWER       14	// Initial powernet build.
#define SS_INIT_ECONOMY     13  // Cargo needs economy set up
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

// Priorities are a weight that controls how much of the BYOND tick the subsystem will be allowed to use. 50 is the default, so a subsystem with a priority of 100 would
//  be allocated twice the amount of runtime as normal, and 25 would get half the amount.

// SS_TICKER
#define SS_PRIORITY_OVERLAY   100	// Applies overlays. May cause overlay pop-in if it gets behind.
//#define SS_PRIORITY_DEFAULT  50	// This is defined somewhere else.
#define SS_PRIORITY_TIMER      20	// Timed event scheduling. This is important.
#define SS_PRIORITY_SMOOTHING  10	// Smooth turf generation.
#define SS_PRIORITY_ORBIT       5	// Orbit datum updates.
#define SS_PRIORITY_ICON_UPDATE 5	// Queued icon updates. Mostly used by APCs and tables.
#define SS_PRIORITY_PROJECTILES 5	// Projectile processing!

// Normal
#define SS_PRIORITY_TICKER     100	// Gameticker.
//#define SS_PRIORITY_DEFAULT   50	// This is defined somewhere else.
#define SS_PRIORITY_LIGHTING    50	// Queued lighting engine updates.
#define SS_PRIORITY_MOB         30	// Mob Life().
#define SS_PRIORITY_AIR         30	// ZAS processing.
#define SS_PRIORITY_NANOUI      20	// UI updates.
#define SS_PRIORITY_VOTE        20
#define SS_PRIORITY_ELECTRONICS 20	// Integrated Electronics processing.
#define SS_PRIORITY_MACHINERY   20	// Machinery + powernet ticks.
#define SS_PRIORITY_CALAMITY    20	// Singularity, Tesla, Nar'sie, blob, etc.
#define SS_PRIORITY_EVENT       20
#define SS_PRIORITY_DISEASE     20	// Disease ticks.
#define SS_PRIORITY_ALARMS      20
#define SS_PRIORITY_PLANTS      20	// Spreading plant effects.
#define SS_PRIORITY_EFFECTS     20	// New-style effects manager. Timing of effects may be off if this gets too far behind.
#define SS_PRIORITY_CHEMISTRY   10	// Multi-tick chemical reactions.
#define SS_PRIORITY_SHUTTLE     10	// Shuttle movement.
#define SS_PRIORITY_AIRFLOW     10	// Handles object movement due to ZAS airflow.
#define SS_PRIORITY_ZCOPY       10	// Z-mimic icon generation/updates.

// SS_BACKGROUND
#define SS_PRIORITY_PROCESSING    50	// Generic datum processor. Replaces objects processor.
//#define SS_PRIORITY_DEFAULT     50	// This is defined somewhere else.
#define SS_PRIORITY_PSYCHICS      30
#define SS_PRIORITY_ARRIVALS      30	// Centcomm arrivals shuttle auto-launch. Usually asleep.
#define SS_PRIORITY_EXPLOSIVES    20	// Explosion processor. Doesn't have much effect on explosion tick-checking.
#define SS_PRIORITY_DISPOSALS     20	// Disposal holder movement.
#define SS_PRIORITY_MODIFIER      10
#define SS_PRIORITY_NIGHT         10	// Nightmode.
#define SS_PRIORITY_STATISTICS    10	// Player population polling & AFK kick.
#define SS_PRIORITY_SUN           10	// Sun movement & Solar tracking.
#define SS_PRIORITY_GARBAGE        5	// Garbage collection.
