var/datum/controller/subsystem/atoms/SSatoms

#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8

/datum/controller/subsystem/atoms
	name = "Atoms"
	init_order = SS_INIT_ATOMS
	flags = SS_NO_FIRE

	var/initialized = INITIALIZATION_INSSATOMS
	var/old_initialized

	var/list/late_loaders
	var/list/created_atoms
	var/list/late_qdel

	var/list/BadInitializeCalls = list()

/datum/controller/subsystem/atoms/New()
	NEW_SS_GLOBAL(SSatoms)

/datum/controller/subsystem/atoms/Initialize(timeofday)
	initialized = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()
	return ..()

/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atoms)
	if(initialized == INITIALIZATION_INSSATOMS)
		return

	initialized = INITIALIZATION_INNEW_MAPLOAD

	LAZYINITLIST(late_loaders)
	LAZYINITLIST(late_qdel)

	var/count
	var/list/mapload_arg = list(TRUE)
	if(atoms)
		created_atoms = list()
		count = atoms.len
		for(var/I in atoms)
			if(InitAtom(I, mapload_arg))
				atoms -= I
			CHECK_TICK
	else
		count = 0
		for(var/atom/A in world)
			if(!A.initialized)
				InitAtom(A, mapload_arg)
				++count
				CHECK_TICK

	admin_notice(span("danger", "Initialized [count] atoms."), R_DEBUG)
	log_ss("atoms", "Initialized [count] atoms.")

	initialized = INITIALIZATION_INNEW_REGULAR

	if(late_loaders.len)
		for(var/I in late_loaders)
			var/atom/A = I
			A.LateInitialize()
		admin_notice(span("danger", "Late-initialized [late_loaders.len] atoms."), R_DEBUG)
		log_ss("atoms", "Late initialized [late_loaders.len] atoms")
		late_loaders.Cut()

	if(late_qdel.len)
		var/num_qdels = late_qdel.len
		for(var/thing in late_qdel)
			qdel(thing)

		admin_notice(span("danger", "Late-qdeleted [num_qdels] atoms."), R_DEBUG)
		log_ss("atoms", "Late qdeleted [num_qdels] atoms.")

		late_qdel.Cut()

	if(atoms)
		. = created_atoms + atoms
		created_atoms = null

/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		BadInitializeCalls[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE

	var/start_tick = world.time

	var/result = A.Initialize(arglist(arguments))

	if(start_tick != world.time)
		BadInitializeCalls[the_type] |= BAD_INIT_SLEPT

	if(result != INITIALIZE_HINT_NORMAL)
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
	for (var/thing in A)
		var/atom/movable/AM = thing
		if (!AM.initialized)
			InitAtom(AM, mload_args)
			++loaded

	log_debug("atoms: force-loaded [loaded] out of [A.contents.len] atoms in [A].")

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
	old_initialized = SSatoms.old_initialized

/datum/controller/subsystem/atoms/proc/map_loader_begin()
	old_initialized = initialized
	initialized = INITIALIZATION_INSSATOMS

/datum/controller/subsystem/atoms/proc/map_loader_stop()
	initialized = old_initialized

#undef BAD_INIT_QDEL_BEFORE
#undef BAD_INIT_DIDNT_INIT
#undef BAD_INIT_SLEPT
#undef BAD_INIT_NO_HINT
