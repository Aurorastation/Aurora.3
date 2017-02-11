var/datum/subsystem/garbage/garbage_collector
var/list/delayed_garbage = list()

/datum/var/gcDestroyed

#define GC_COLLECTIONS_PER_RUN 300
#define GC_COLLECTION_TIMEOUT (30 SECONDS)
#define GC_FORCE_DEL_PER_RUN 30

/datum/subsystem/garbage
	name = "Garbage Collector"
	wait = 5 SECONDS
	flags = SS_FIRE_IN_LOBBY | SS_BACKGROUND

	var/garbage_collect = 1			// Whether or not to actually do work
	var/total_dels 	= 0			// number of total del()'s
	var/tick_dels 	= 0			// number of del()'s we've done this tick
	var/soft_dels	= 0
	var/hard_dels 	= 0			// number of hard dels in total
	var/list/destroyed = list() // list of refID's of things that should be garbage collected
								// refID's are associated with the time at which they time out and need to be manually del()
								// we do this so we aren't constantly locating them and preventing them from being gc'd

	var/list/logging = list()	// list of all types that have failed to GC associated with the number of times that's happened.
								// the types are stored as strings

/datum/subsystem/garbage/New()
	NEW_SS_GLOBAL(SSgarbage)

/datum/subsystem/garbage/Initialize()
	if (!garbage_collector)
		garbage_collector = src

	for(var/garbage in delayed_garbage)
		qdel(garbage)
	delayed_garbage.Cut()
	delayed_garbage = null

/datum/subsystem/garbage/fire(resumed = 0)
	if (!garbage_collect)
		return

	tick_dels = 0
	var/time_to_kill = world.time - GC_COLLECTION_TIMEOUT
	var/checkRemain = GC_COLLECTIONS_PER_RUN
	var/remaining_force_dels = GC_FORCE_DEL_PER_RUN

	while (destroyed.len && --checkRemain >= 0)
		if(remaining_force_dels <= 0)
			#ifdef GC_DEBUG
			testing("GC: Reached max force dels per tick [dels] vs [maxDels]")
			#endif
			break // Server's already pretty pounded, everything else can wait 2 seconds
		var/refID = destroyed[1]
		var/GCd_at_time = destroyed[refID]
		if(GCd_at_time > time_to_kill)
			#ifdef GC_DEBUG
			testing("GC: [refID] not old enough, breaking at [world.time] for [GCd_at_time - time_to_kill] deciseconds until [GCd_at_time + collection_timeout]")
			#endif
			break // Everything else is newer, skip them
		var/datum/A = locate(refID)
		#ifdef GC_DEBUG
		testing("GC: [refID] old enough to test: GCd_at_time: [GCd_at_time] time_to_kill: [time_to_kill] current: [world.time]")
		#endif
		if(A && A.gcDestroyed == GCd_at_time) // So if something else coincidently gets the same ref, it's not deleted by mistake
			// Something's still referring to the qdel'd object.  Kill it.
			log_hard_delete(A)
			logging["[A.type]"]++
			del(A)

			hard_dels++
			remaining_force_dels--
		else
			#ifdef GC_DEBUG
			testing("GC: [refID] properly GC'd at [world.time] with timeout [GCd_at_time]")
			#endif
			soft_dels++
		tick_dels++
		total_dels++
		destroyed.Cut(1, 2)
		
		if (MC_TICK_CHECK)
			return
