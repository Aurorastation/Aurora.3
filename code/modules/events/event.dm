/datum/event_meta
	var/name 		= ""
	var/enabled 	= 1	// Whether or not the event is available for random selection at all
	var/weight 		= 0 // The base weight of this event. A zero means it may never fire, but see get_weight()
	var/min_weight	= 0 // The minimum weight that this event will have. Only used if non-zero.
	var/max_weight	= 0 // The maximum weight that this event will have. Only use if non-zero.
	var/severity 	= 0 // The current severity of this event
	var/one_shot	= 0	// If true, then the event will not be re-added to the list of available events
	var/add_to_queue= 1	// If true, add back to the queue of events upon finishing.
	var/list/role_weights = list()
	var/list/excluded_gamemodes	// A lazylist of gamemodes during which this event won't fire.
	var/datum/event/event_type

/datum/event_meta/New(var/event_severity, var/event_name, var/datum/event/type, var/event_weight, var/list/job_weights, var/is_one_shot = 0, var/min_event_weight = 0, var/max_event_weight = 0, var/list/excluded_roundtypes, var/add_to_queue = TRUE)
	name = event_name
	severity = event_severity
	event_type = type
	one_shot = is_one_shot
	weight = event_weight
	min_weight = min_event_weight
	max_weight = max_event_weight
	src.add_to_queue = add_to_queue
	if(job_weights)
		role_weights = job_weights
	if(excluded_roundtypes)
		excluded_gamemodes = excluded_roundtypes

/datum/event_meta/proc/get_weight(var/list/active_with_role)
	if(!enabled)
		return 0

	if(LAZYISIN(excluded_gamemodes, SSticker.mode.name))
		// There's no way it'll be run this round anyways.
		enabled = FALSE
		return 0

	var/job_weight = 0
	for(var/role in role_weights)
		if(role in active_with_role)
			job_weight += active_with_role[role] * role_weights[role]

	var/total_weight = weight + job_weight

	// Only min/max the weight if the values are non-zero
	if(min_weight && total_weight < min_weight) total_weight = min_weight
	if(max_weight && total_weight > max_weight) total_weight = max_weight

	return total_weight

/datum/event	//NOTE: Times are measured in master controller ticks!
	var/startWhen		= 0	//When in the lifetime to call start().
	var/announceWhen	= 0	//When in the lifetime to call announce().
	var/endWhen			= 0	//When in the lifetime the event should end.

	var/severity		= 0 //Severity. Lower means less severe, higher means more severe. Does not have to be supported. Is set on New().
	var/activeFor		= 0	//How long the event has existed. You don't need to change this.
	var/isRunning		= 1 //If this event is currently running. You should not change this.
	var/startedAt		= 0 //When this event started.
	var/endedAt			= 0 //When this event ended.
	var/datum/event_meta/event_meta = null

	var/no_fake 		= 0
	//If set to 1, this event will not be picked for false announcements
	//This should really only be used for events that have no announcement

	var/ic_name			= null
	//A lore-suitable name that maintains the mystery, used for faking events

	var/dummy 			=	0
	//If 1, this event is a dummy instance used for retrieving values, it should not run or add/remove itself from any lists

	var/two_part		=	0
	//used for events that run secondary announcements, like releasing maint access.

/datum/event/nothing
	no_fake = 1

//Called first before processing.
//Allows you to setup your event, such as randomly
//setting the startWhen and or announceWhen variables.
//Only called once.
/datum/event/proc/setup()
	return

//Called when the tick is equal to the startWhen variable.
//Allows you to start before announcing or vice versa.
//Only called once.
/datum/event/proc/start()
	return

//Called when the tick is equal to the announceWhen variable.
//Allows you to announce before starting or vice versa.
//Only called once.
/datum/event/proc/announce()
	return

//Called on or after the tick counter is equal to startWhen.
//You can include code related to your event or add your own
//time stamped events.
//Called more than once.
/datum/event/proc/tick()
	return

//Called on or after the tick is equal or more than endWhen
//You can include code related to the event ending.
//Do not place spawn() in here, instead use tick() to check for
//the activeFor variable.
//For example: if(activeFor == myOwnVariable + 30) doStuff()
//Only called once.
//faked indicates this is a false alarm. Used to prevent announcements and other things from happening during false alarms.
/datum/event/proc/end(var/faked)
	return

//Returns the latest point of event processing.
/datum/event/proc/lastProcessAt()
	return max(startWhen, max(announceWhen, endWhen))

//Do not override this proc, instead use the appropiate procs.
//This proc will handle the calls to the appropiate procs.
/datum/event/process()
	if(activeFor > startWhen && activeFor < endWhen)
		tick()

	if(activeFor == startWhen)
		isRunning = 1
		start()

	if(activeFor == announceWhen)
		announce()

	if(activeFor == endWhen)
		isRunning = 0
		end()

	// Everything is done, let's clean up.
	if(activeFor >= lastProcessAt())
		kill()

	activeFor++

//Called when start(), announce() and end() has all been called.
/datum/event/proc/kill(var/failed_to_spawn = FALSE)
	// If this event was forcefully killed run end() for individual cleanup

	if(!dummy && isRunning)
		end()

	if(failed_to_spawn)
		var/datum/event_container/killed_ec = SSevents.event_containers[severity]
		killed_ec.start_event()

	isRunning = 0
	endedAt = world.time

	if(!dummy)
		SSevents.active_events -= src
		SSevents.event_complete(src)



/datum/event/New(var/datum/event_meta/EM = null, var/is_dummy = 0)
	dummy = is_dummy
	event_meta = EM
	if (event_meta)
		severity = event_meta.severity
		if(severity < EVENT_LEVEL_MUNDANE) severity = EVENT_LEVEL_MUNDANE
		if(severity > EVENT_LEVEL_MAJOR) severity = EVENT_LEVEL_MAJOR
	else
		severity = EVENT_LEVEL_MODERATE//Fixes runtime errors with admin triggered events

	if (dummy)
		return
	// event needs to be responsible for this, as stuff like APLUs currently make their own events for curious reasons
	SSevents.active_events += src
	startedAt = world.time

	setup()
	..()
