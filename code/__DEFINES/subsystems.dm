// -- SSprocessing stuff --
#define START_PROCESSING(Processor, Datum) if (!Datum.isprocessing) {Datum.isprocessing = 1;Processor.processing += Datum}
#define STOP_PROCESSING(Processor, Datum) Datum.isprocessing = 0;Processor.processing -= Datum

/// START specific to SSmachinery
#define START_PROCESSING_MACHINE(machine, flag)\
	if(!istype(machine, /obj/machinery)) CRASH("A non-machine [log_info_line(machine)] was queued to process on the machinery subsystem.");\
	machine.processing_flags |= flag;\
	START_PROCESSING(SSmachinery, machine)

/// STOP specific to SSmachinery
#define STOP_PROCESSING_MACHINE(machine, flag)\
	machine.processing_flags &= ~flag;\
	if(machine.processing_flags == 0) STOP_PROCESSING(SSmachinery, machine)

//! ## Timing subsystem
/**
 * Don't run if there is an identical unique timer active
 *
 * if the arguments to addtimer are the same as an existing timer, it doesn't create a new timer,
 * and returns the id of the existing timer
 */
#define TIMER_UNIQUE (1<<0)

///For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE (1<<1)

/**
 * Timing should be based on how timing progresses on clients, not the server.
 *
 * Tracking this is more expensive,
 * should only be used in conjuction with things that have to progress client side, such as
 * animate() or sound()
 */
#define TIMER_CLIENT_TIME (1<<2)

///Timer can be stopped using deltimer()
#define TIMER_STOPPABLE (1<<3)

///prevents distinguishing identical timers with the wait variable
///
///To be used with TIMER_UNIQUE
#define TIMER_NO_HASH_WAIT (1<<4)

///Loops the timer repeatedly until qdeleted
///
///In most cases you want a subsystem instead, so don't use this unless you have a good reason
#define TIMER_LOOP (1<<5)

///Delete the timer on parent datum Destroy() and when deltimer'd
#define TIMER_DELETE_ME (1<<6)

///Empty ID define
#define TIMER_ID_NULL -1

/// Used to trigger object removal from a processing list
#define PROCESS_KILL 26

// -- SSatoms stuff --
// Technically this check will fail if someone loads a map mid-round, but that's not enabled right now.

///TRUE if the INITIAL SSatoms initialization has finished, aka the atoms are initialized and mapload has finished
#define SSATOMS_IS_PROBABLY_DONE (SSatoms.initialized == INITIALIZATION_INNEW_REGULAR)

///type and all subtypes should always immediately call Initialize in New()
#define INITIALIZE_IMMEDIATE(X) ##X/New(loc, ...){\
	..();\
	if(!(flags_1 & INITIALIZED_1)) {\
		var/previous_initialized_value = SSatoms.initialized;\
		SSatoms.initialized = INITIALIZATION_INNEW_MAPLOAD;\
		args[1] = TRUE;\
		SSatoms.InitAtom(src, FALSE, args);\
		SSatoms.initialized = previous_initialized_value;\
	}\
}

/* Initialization subsystem */

///New should not call Initialize
#define INITIALIZATION_INSSATOMS 0
///New should call Initialize(TRUE)
#define INITIALIZATION_INNEW_MAPLOAD 2
///New should call Initialize(FALSE)
#define INITIALIZATION_INNEW_REGULAR 1

///Nothing happens.
#define INITIALIZE_HINT_NORMAL 0

/**
 * call LateInitialize at the end of all atom Initalization
 *
 * The item will be added to the late_loaders list, this is iterated over after
 * initalization of subsystems is complete and calls LateInitalize on the atom
 * see [this file for the LateIntialize proc](atom.html#proc/LateInitialize)
 */
#define INITIALIZE_HINT_LATELOAD 1

///Call qdel on the atom after intialization
#define INITIALIZE_HINT_QDEL 2


// -- SSoverlays --
#define CUT_OVERLAY_IN(ovr, time) addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, cut_overlay), ovr), time, TIMER_STOPPABLE | TIMER_CLIENT_TIME)
#define ATOM_USING_SSOVERLAY(atom) (atom.our_overlays || atom.priority_overlays)

// -- SSticker --
#define ROUND_IS_STARTED (SSticker.current_state >= GAME_STATE_PLAYING)

// -- SSeffects --
// tick/process() return vals.
#define EFFECT_CONTINUE 0 	// Keep processing.
#define EFFECT_HALT 1		// Stop processing, but don't qdel.
#define EFFECT_DESTROY 2	// qdel.

// Effect helpers.
#define QUEUE_EFFECT(effect) if (!effect.isprocessing) {effect.isprocessing = TRUE; SSeffects.effect_systems += effect;}
#define QUEUE_VISUAL(visual) if (!visual.isprocessing) {visual.isprocessing = TRUE; SSeffects.visuals += visual;}
#define STOP_EFFECT(effect) effect.isprocessing = FALSE; SSeffects.effect_systems -= effect;
#define STOP_VISUAL(visual)	visual.isprocessing = FALSE; SSeffects.visuals -= visual;

// -- SSfalling --
#define ADD_FALLING_ATOM(atom) if (!atom.multiz_falling) { atom.multiz_falling = 1; SSfalling.falling[atom] = 0; }

// -- SSlistener --
#define GET_LISTENERS(id) (id ? SSlistener.listeners["[id]"] : null)

// Connection prefixes for player-editable fields
#define WP_ELECTRONICS "elec_"

// -- SSicon_cache --
#define LIGHT_FIXTURE_CACHE(icon,state,color) SSicon_cache.light_fixture_cache["[icon]_[state]_[color]"] || (SSicon_cache.light_fixture_cache["[icon]_[state]_[color]"] = SSicon_cache.generate_color_variant(icon,state,color))


// -- SSmob_ai --
#define MOB_START_THINKING(mob) if (!mob.thinking_enabled) { SSmob_ai.processing += mob; mob.on_think_enabled(); mob.thinking_enabled = TRUE; }
#define MOB_STOP_THINKING(mob) SSmob_ai.processing -= mob; mob.on_think_disabled(); mob.thinking_enabled = FALSE;

#define MOB_SHIFT_TO_FAST_THINKING(mob) if(!mob.is_fast_processing) { SSmob_ai.processing -= mob; SSmob_fast_ai.processing += mob; mob.is_fast_processing = TRUE; }
#define MOB_SHIFT_TO_NORMAL_THINKING(mob) if(mob.is_fast_processing) { SSmob_fast_ai.processing -= mob; SSmob_ai.processing += mob; mob.is_fast_processing = FALSE; }


// - SSrecords --
#define RECORD_GENERAL 1
#define RECORD_MEDICAL 2
#define RECORD_SECURITY 4
#define RECORD_LOCKED 8
#define RECORD_WARRANT 16
#define RECORD_VIRUS 32


// - SSjobs --
// departments
#define DEPARTMENT_COMMAND "Command"
#define DEPARTMENT_COMMAND_SUPPORT "Command Support"
#define DEPARTMENT_SECURITY "Security"
#define DEPARTMENT_ENGINEERING "Engineering"
#define DEPARTMENT_MEDICAL "Medical"
#define DEPARTMENT_SCIENCE "Science"
#define DEPARTMENT_CARGO "Operations"
#define DEPARTMENT_SERVICE "Service"
#define DEPARTMENT_CIVILIAN "Civilian"
#define DEPARTMENT_EQUIPMENT "Equipment"
#define DEPARTMENT_MISCELLANEOUS "Miscellaneous"
#define DEPARTMENTS_LIST_INIT list(\
	DEPARTMENT_COMMAND = list(),\
	DEPARTMENT_COMMAND_SUPPORT = list(),\
	DEPARTMENT_SECURITY = list(),\
	DEPARTMENT_ENGINEERING = list(),\
	DEPARTMENT_MEDICAL = list(),\
	DEPARTMENT_SCIENCE = list(),\
	DEPARTMENT_CARGO = list(),\
	DEPARTMENT_SERVICE = list(),\
	DEPARTMENT_CIVILIAN = list(),\
	DEPARTMENT_EQUIPMENT = list(),\
	DEPARTMENT_MISCELLANEOUS = list(),\
)

// job roles within departments
#define JOBROLE_DEFAULT 0                    // This is the default "job role", no special meaning.
#define JOBROLE_SUPERVISOR (1 << 0)          // Indicates that the job is a supervisory position, i.e a head of department.
#define SIMPLEDEPT(dept) list(dept = JOBROLE_DEFAULT)

#define ASSET_CROSS_ROUND_CACHE_DIRECTORY "tmp/assets"

//! ### SS initialization hints
/**
 * Negative values incidate a failure or warning of some kind, positive are good.
 * 0 and 1 are unused so that TRUE and FALSE are guarenteed to be invalid values.
 */

/// Subsystem failed to initialize entirely. Print a warning, log, and disable firing.
#define SS_INIT_FAILURE -2

/// The default return value which must be overriden. Will succeed with a warning.
#define SS_INIT_NONE -1

/// Subsystem initialized sucessfully.
#define SS_INIT_SUCCESS 2

/// If your system doesn't need to be initialized (by being disabled or something)
#define SS_INIT_NO_NEED 3

/// Succesfully initialized, BUT do not announce it to players (generally to hide game mechanics it would otherwise spoil)
#define SS_INIT_NO_MESSAGE 4

/// The timer key used to know how long subsystem initialization takes
#define SS_INIT_TIMER_KEY "ss_init"

//! ### SS initialization load orders
// Subsystem init_order, from highest priority to lowest priority
// Subsystems shutdown in the reverse of the order they initialize in
// The numbers just define the ordering, they are meaningless otherwise.

#define INIT_ORDER_PERSISTENT_CONFIGURATION 101 //Aurora snowflake conflg handling
#define INIT_ORDER_PROFILER 101
#define INIT_ORDER_GARBAGE 99
#define INIT_ORDER_SOUNDS 83
#define INIT_ORDER_DISCORD 78
#define INIT_ORDER_JOBS 65 // Must init before atoms, to set up properly the dynamic job lists.
#define INIT_ORDER_TICKER 55
#define INIT_ORDER_SEEDS 52 // More aurora snowflake, needs to load before the atoms init as it generates images for seeds that are used
#define INIT_ORDER_MISC_FIRST 51 //Another aurora snowflake system? Who would have guessed... Anyways, need to load before mapping or global HUDs are not ready when atoms request them
#define INIT_ORDER_MAPPING 50 //This is the ATLAS subsystem
#define INIT_ORDER_PARALLAX 49 // Parallax image cache generation. Must run before ghosts are able to join. Another aurora snowflake code, run after mapping or it runtimes
#define INIT_ORDER_EARLY_ASSETS 48
#define INIT_ORDER_SPATIAL_GRID 43
#define INIT_ORDER_ECONOMY 40
#define INIT_ORDER_MAPFINALIZE 31 //Asteroid generation, another aurora snowflake, must run before the atoms init
#define INIT_ORDER_ATOMS 30
#define INIT_ORDER_MACHINES 20
#define INIT_ORDER_DEFAULT 0
#define INIT_ORDER_TIMER 1
#define INIT_ORDER_AIR -1
#define INIT_ORDER_AWAY_MAPS -2 //Loading away sites and exoplanets, should start after air, must initialize before ghost roles in order for their spawnpoints to work
#define INIT_ORDER_GHOSTROLES -2.1 //Ghost roles must initialize before SS_INIT_MISC due to some roles (matriarch drones) relying on the assumption that this SS is initialized.
#define INIT_ORDER_MISC -2.2 //Aurora snowflake, Subsystems without an explicitly set initialization order start here
#define INIT_ORDER_CODEX -3 // Codex subsystem. Should be initialized after chemistry and cooking recipes.
#define INIT_ORDER_VOTE -4
#define INIT_ORDER_ASSETS -5
#define INIT_ORDER_ICON_UPDATE -5.5 //Yet another aurora snowflake, Icon update queue flush. Should run before overlays, probably before smoothing the icon too
#define INIT_ORDER_VISCONTENTS -5.6  // Queued vis_contents updates.
#define INIT_ORDER_ICON_SMOOTHING -6
#define INIT_ORDER_OVERLAY -7
#define INIT_ORDER_WEATHER    -9
#define INIT_ORDER_LIGHTING -20
#define INIT_ORDER_ZCOPY -21 //Aurora snowflake, Z-mimic flush. Should run after SSoverlay & SSicon_smooth so it copies the smoothed sprites.
#define INIT_ORDER_PATH -50
#define INIT_ORDER_STATPANELS -97
#define INIT_ORDER_CHAT -100 //Should be last to ensure chat remains smooth during init.

// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)

#define FIRE_PRIORITY_PING 10
#define FIRE_PRIORITY_GARBAGE 15
#define FIRE_PRIORITY_ASSETS 20
#define FIRE_PRIORITY_PATHFINDING 23
#define FIRE_PRIORITY_DEFAULT 50
#define FIRE_PRIORITY_STATPANEL 390
#define FIRE_PRIORITY_CHAT 400
#define FIRE_PRIORITY_RUNECHAT 410
#define FIRE_PRIORITY_TIMER 700
#define FIRE_PRIORITY_SOUND_LOOPS 800

/**
	Create a new timer and add it to the queue.
	* Arguments:
	* * callback the callback to call on timer finish
	* * wait deciseconds to run the timer for
	* * flags flags for this timer, see: code\__DEFINES\subsystems.dm
	* * timer_subsystem the subsystem to insert this timer into
*/
#define addtimer(args...) _addtimer(args, file = __FILE__, line = __LINE__)

/* AURORA SHIT */

// Don't display in processes panel.
#define SS_NO_DISPLAY 128

#define SS_IS_RUNNING(subsystem) (subsystem.can_fire && (GAME_STATE & subsystem.runlevels))

// Vote subsystem counting methods
/// First past the post. One selection per person, and the selection with the most votes wins.
#define VOTE_COUNT_METHOD_SINGLE 1
/// Approval voting. Any number of selections per person, and the selection with the most votes wins.
#define VOTE_COUNT_METHOD_MULTI 2

/// The choice with the most votes wins. Ties are broken by the first choice to reach that number of votes.
#define VOTE_WINNER_METHOD_SIMPLE "Simple"
/// The winning choice is selected randomly based on the number of votes each choice has.
#define VOTE_WINNER_METHOD_WEIGHTED_RANDOM "Weighted Random"
/// There is no winner for this vote.
#define VOTE_WINNER_METHOD_NONE "None"
