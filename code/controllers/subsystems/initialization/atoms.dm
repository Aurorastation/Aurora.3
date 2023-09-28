#define SUBSYSTEM_INIT_SOURCE "subsystem init"

var/datum/controller/subsystem/atoms/SSatoms

#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8

/datum/controller/subsystem/atoms
	name = "Atoms"
	init_order = SS_INIT_ATOMS
	flags = SS_NO_FIRE

	/// A stack of list(source, desired initialized state)
	/// We read the source of init changes from the last entry, and assert that all changes will come with a reset
	var/list/initialized_state = list()
	var/base_initialized

	var/initialized = INITIALIZATION_INSSATOMS
	var/old_initialized

	var/list/late_misc_firers // this is a list of things that fire when late misc init is called

	var/list/late_loaders
	var/list/created_atoms
	var/list/late_qdel

	var/list/BadInitializeCalls = list()

/datum/controller/subsystem/atoms/New()
	NEW_SS_GLOBAL(SSatoms)

/datum/controller/subsystem/atoms/Initialize(timeofday)
	initialized = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()
	initialized = INITIALIZATION_INNEW_REGULAR
	return ..()

/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atoms)
	if(initialized == INITIALIZATION_INSSATOMS)
		return

	set_tracked_initalized(INITIALIZATION_INNEW_MAPLOAD, SUBSYSTEM_INIT_SOURCE)

	LAZYINITLIST(late_loaders)
	LAZYINITLIST(late_qdel)

	var/count
	var/list/mapload_arg = list(TRUE)
	if(atoms)
		created_atoms = list()
		count = atoms.len
		for(var/I in 1 to atoms.len)
			var/atom/A = atoms[I]
			InitAtom(A, mapload_arg)
			CHECK_TICK
	else
		count = 0
		for(var/atom/A as anything in world)
			if(!A.initialized)
				InitAtom(A, mapload_arg)
				++count
				CHECK_TICK

	admin_notice(SPAN_DANGER("Initialized [count] atoms."), R_DEBUG)
	log_subsystem("atoms", "Initialized [count] atoms.")

	clear_tracked_initalize(SUBSYSTEM_INIT_SOURCE)

	if(late_loaders.len)
		for(var/I in 1 to late_loaders.len)
			var/atom/A = late_loaders[I]
			if(QDELETED(A))
				continue
			A.LateInitialize()
		admin_notice(SPAN_DANGER("Late-initialized [late_loaders.len] atoms."), R_DEBUG)
		log_subsystem("atoms", "Late initialized [late_loaders.len] atoms")
		late_loaders.Cut()

	if(late_qdel.len)
		var/num_qdels = late_qdel.len
		for(var/thing in late_qdel)
			qdel(thing)

		admin_notice(SPAN_DANGER("Late-qdeleted [num_qdels] atoms."), R_DEBUG)
		log_subsystem("atoms", "Late qdeleted [num_qdels] atoms.")

		late_qdel.Cut()

	if(atoms)
		. = created_atoms + atoms
		created_atoms = null
		// Note this doesn't actually do anything because we didn't finish porting TG init :^)

/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		BadInitializeCalls[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE

	var/start_tick = world.time

	var/result = A.Initialize(arglist(arguments))

	if(start_tick != world.time)
		BadInitializeCalls[the_type] |= BAD_INIT_SLEPT

	if(result !=INITIALIZE_HINT_NORMAL)
		switch(result)
			if(INITIALIZE_HINT_LATELOAD)
				if(arguments[1])	//mapload
					late_loaders += A
				else
					A.LateInitialize()
			if(INITIALIZE_HINT_QDEL)
				qdel(A)
				return TRUE
			if(INITIALIZE_HINT_LATEQDEL)
				if(arguments[1])	//mapload
					late_qdel += A
				else
					qdel(A)
					return TRUE
			else
				BadInitializeCalls[the_type] |= BAD_INIT_NO_HINT

	if(!A)	//possible harddel
		return TRUE
	else if(!A.initialized)
		BadInitializeCalls[the_type] |= BAD_INIT_DIDNT_INIT

	return QDELETED(A)

/datum/controller/subsystem/atoms/proc/ForceInitializeContents(atom/A)
	var/list/mload_args = list(TRUE)
	var/loaded = 0

	set_tracked_initalized(INITIALIZATION_INNEW_MAPLOAD, SUBSYSTEM_INIT_SOURCE+"- ForceInitializeContents: [text_ref(A)]")

	for (var/thing in A)
		var/atom/movable/AM = thing
		if (!AM.initialized)
			InitAtom(AM, mload_args)
			++loaded

	clear_tracked_initalize(SUBSYSTEM_INIT_SOURCE+"- ForceInitializeContents: [text_ref(A)]")

	LOG_DEBUG("atoms: force-loaded [loaded] out of [A.contents.len] atoms in [A].")

/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for(var/path in BadInitializeCalls)
		. += "Path : [path] \n"
		var/fails = BadInitializeCalls[path]
		if(fails & BAD_INIT_DIDNT_INIT)
			. += "- Didn't call atom/Initialize()\n"
		if(fails & BAD_INIT_NO_HINT)
			. += "- Didn't return an Initialize hint\n"
		if(fails & BAD_INIT_QDEL_BEFORE)
			. += "- Qdel'd in New()\n"
		if(fails & BAD_INIT_SLEPT)
			. += "- Slept during Initialize()\n"

/*datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if(initlog)
		world.log <<  initlog*/

/datum/controller/subsystem/atoms/Recover()
	initialized = SSatoms.initialized
	if(initialized == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()
	initialized_state = SSatoms.initialized_state
	BadInitializeCalls = SSatoms.BadInitializeCalls

/datum/controller/subsystem/atoms/proc/map_loader_begin(source)
	set_tracked_initalized(INITIALIZATION_INSSATOMS, source)

/datum/controller/subsystem/atoms/proc/map_loader_stop(source)
	clear_tracked_initalize(source)

/// Use this to set initialized to prevent error states where the old initialized is overriden, and we end up losing all context
/// Accepts a state and a source, the most recent state is used, sources exist to prevent overriding old values accidentially
/datum/controller/subsystem/atoms/proc/set_tracked_initalized(state, source)
	if(!length(initialized_state))
		base_initialized = initialized
	initialized_state += list(list(source, state))
	initialized = state

/datum/controller/subsystem/atoms/proc/clear_tracked_initalize(source)
	if(!length(initialized_state))
		return
	for(var/i in length(initialized_state) to 1 step -1)
		if(initialized_state[i][1] == source)
			initialized_state.Cut(i, i+1)
			break

	if(!length(initialized_state))
		initialized = base_initialized
		base_initialized = INITIALIZATION_INNEW_REGULAR
		return
	initialized = initialized_state[length(initialized_state)][2]

/// Returns TRUE if anything is currently being initialized
/datum/controller/subsystem/atoms/proc/initializing_something()
	return length(initialized_state) > 1

#undef SUBSYSTEM_INIT_SOURCE
