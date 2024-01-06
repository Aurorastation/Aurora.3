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

// -- SStimer stuff --
//Don't run if there is an identical unique timer active
#define TIMER_UNIQUE		(1<<0)

//For unique timers: Replace the old timer rather then not start this one
#define TIMER_OVERRIDE		(1<<1)

//Timing should be based on how timing progresses on clients, not the sever.
//	tracking this is more expensive,
//	should only be used in conjuction with things that have to progress client side, such as animate() or sound()
#define TIMER_CLIENT_TIME	(1<<2)

//Timer can be stopped using deltimer()
#define TIMER_STOPPABLE		(1<<3)

//To be used with TIMER_UNIQUE
//prevents distinguishing identical timers with the wait variable
#define TIMER_NO_HASH_WAIT  (1<<4)

//Loops the timer repeatedly until qdeleted
//In most cases you want a subsystem instead
#define TIMER_LOOP			(1<<5)

//number of byond ticks that are allowed to pass before the timer subsystem thinks it hung on something
#define TIMER_NO_INVOKE_WARNING 600

#define TIMER_ID_NULL -1

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

// Subsystem fire priority, from lowest to highest priority
// If the subsystem isn't listed here it's either DEFAULT or PROCESS (if it's a processing subsystem child)

#define FIRE_PRIORITY_DEFAULT 50


/* AURORA SHIT */

// Don't display in processes panel.
#define SS_NO_DISPLAY 128

#define SS_IS_RUNNING(subsystem) (subsystem.can_fire && (GAME_STATE & subsystem.runlevels))
