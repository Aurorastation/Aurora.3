//! Defines that give qdel hints.
//!
//! These can be given as a return in [/atom/proc/Destroy] or by calling [/proc/qdel].

/// `qdel` should queue the object for deletion.
#define QDEL_HINT_QUEUE 		0
/// `qdel` should let the object live after calling [/datum/proc/Destroy].
#define QDEL_HINT_LETMELIVE		1
/// Functionally the same as above. `qdel` should assume the object will gc on its own, and not check it.
#define QDEL_HINT_IWILLGC		2
/// `qdel` should assume this object won't GC, and queue a hard delete using a hardref.
#define QDEL_HINT_HARDDEL		3
/// `qdel` should assume this object won't GC, and hard delete it immediately.
#define QDEL_HINT_HARDDEL_NOW	4

/*
* If REFERENCE_TRACKING and [GC_FAILURE_HARD_LOOKUP] are not enabled, these are functionally identical to [QDEL_HINT_QUEUE].
* If they are enabled, qdel will call this object's find_references() verb.
*/
#define QDEL_HINT_FINDREFERENCE	5
/// Same behavior as [QDEL_HINT_FINDREFERENCE], but only if GC fails and a hard delete is forced.
#define QDEL_HINT_IFFAIL_FINDREFERENCE 6

// Defines for the time an item has to get its reference cleaned before it fails the queue and moves to the next.
#define GC_FILTER_QUEUE (1 SECONDS)
#define GC_CHECK_QUEUE (5 MINUTES)
#define GC_DEL_QUEUE (10 SECONDS)

//defines for the gc_destroyed var
#define GC_QUEUED_FOR_QUEUING -1
#define GC_QUEUED_FOR_HARD_DEL -2
#define GC_CURRENTLY_BEING_QDELETED -3

#define QDELING(X) (X.gc_destroyed)
#define QDELETED(X) (!X || X.gc_destroyed)
#define QDESTROYING(X) (!X || X.gc_destroyed == GC_CURRENTLY_BEING_QDELETED)

#define QDEL_IN(item, time) addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), item), time, TIMER_STOPPABLE)
#define QDEL_IN_CLIENT_TIME(item, time) addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), item), time, TIMER_STOPPABLE | TIMER_CLIENT_TIME)
#define QDEL_NULL(item) qdel(item); item = null
#define QDEL_NULL_LIST(x) if(x) { for(var/y in x) { qdel(y) }}; if(x) {x.Cut(); x = null } // Second x check to handle items that LAZYREMOVE on qdel.
#define QDEL_NULL_ASSOC(x) if(x) { for(var/y in x) { qdel(x[y])}}; if(x) {x.Cut(); x = null } // As above, but qdels the value rather than the key
