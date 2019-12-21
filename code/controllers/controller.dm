/datum/controller
	var/name
	// The object used for the clickable stat() button.
	var/obj/effect/statclick/statclick
	var/list/systems_to_suspend

/datum/controller/proc/Initialize()
	systems_to_suspend = list(WEAKREF(SSmachinery), WEAKREF(SSmob_ai), WEAKREF(SSair))
//cleanup actions
/datum/controller/proc/Shutdown()

/datum/controller/proc/Recover()

/datum/controller/proc/stat_entry()

// Called when SSexplosives begins processing explosions.
/datum/controller/proc/ExplosionStart()
	for(var/datum/weakref/i in systems_to_suspend)
		var/datum/controller/subsystem/S = i.resolve()
		if(!S)
			continue
		S.suspended = TRUE
	

// Called when SSexplosives finishes processing all queued explosions.
/datum/controller/proc/ExplosionEnd()
	for(var/datum/weakref/i in systems_to_suspend)
		var/datum/controller/subsystem/S = i.resolve()
		if(!S)
			continue
		S.suspended = FALSE

//when we enter dmm_suite.load_map
/datum/controller/proc/StartLoadingMap()

//when we exit dmm_suite.load_map
/datum/controller/proc/StopLoadingMap()
