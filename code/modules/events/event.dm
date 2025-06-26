/datum/event_meta
	var/name 		= ""

	///Whether or not the event is available for random selection at all
	var/enabled = TRUE

	///The base weight of this event. A zero means it may never fire, but see get_weight()
	var/weight = 0

	///The minimum weight that this event will have. Only used if non-zero
	var/min_weight = 0

	///The maximum weight that this event will have. Only use if non-zero
	var/max_weight = 0

	///The current severity of this event
	var/severity = 0

	///If TRUE, then the event will not be re-added to the list of available events
	var/one_shot = FALSE

	///If TRUE, add back to the queue of events upon finishing
	var/add_to_queue = TRUE

	var/list/role_weights = list()

	///Minimum amount of jobs required for the event to fire
	var/list/minimum_job_requirement = list()

	///Minimum amount of player_list mobs for this to fire
	var/pop_requirement = 1

	/// A lazylist of gamemodes during which this event won't fire
	var/list/excluded_gamemodes

	var/datum/event/event_type

/datum/event_meta/New(event_severity, event_name, datum/event/type, event_weight, list/job_weights,
						is_one_shot = FALSE, min_event_weight = 0, max_event_weight = 0, list/excluded_roundtypes,
						add_to_queue = TRUE, list/minimum_job_requirement_list, pop_needed = 1)

	name = event_name
	severity = event_severity
	event_type = type
	one_shot = is_one_shot
	weight = event_weight
	min_weight = min_event_weight
	max_weight = max_event_weight
	src.add_to_queue = add_to_queue
	pop_requirement = pop_needed
	if(job_weights)
		role_weights = job_weights
	if(minimum_job_requirement_list)
		minimum_job_requirement = minimum_job_requirement_list
	if(excluded_roundtypes)
		excluded_gamemodes = excluded_roundtypes

/datum/event_meta/proc/get_weight(list/active_with_role)
	if(!enabled)
		return 0

	var/n = 0
	for (var/mob/living in GLOB.player_list)
		n++
	if(n <= pop_requirement)
		return 0

	if(LAZYISIN(excluded_gamemodes, SSticker.mode.name))
		// There's no way it'll be run this round anyways.
		enabled = FALSE
		return 0

	var/job_weight = 0
	var/minimum_met = TRUE
	if(minimum_job_requirement)
		for(var/role in minimum_job_requirement)
			if(active_with_role[role] >= minimum_job_requirement[role])
				minimum_met = TRUE
			else
				minimum_met = FALSE
	if(minimum_met)
		for(var/role in role_weights)
			if(role in active_with_role)
				job_weight += active_with_role[role] * role_weights[role]

	var/total_weight = weight + job_weight

	// Only min/max the weight if the values are non-zero
	if(min_weight && total_weight < min_weight) total_weight = min_weight
	if(max_weight && total_weight > max_weight) total_weight = max_weight

	return total_weight

/datum/event	//NOTE: Times are measured in master controller ticks!

	///When in the lifetime to call start()
	var/startWhen = 0

	///When in the lifetime to call announce()
	var/announceWhen = 0

	///When in the lifetime the event should end
	var/endWhen = 0

	///Severity. Lower means less severe, higher means more severe. Does not have to be supported. Is set on New()
	var/severity = 0

	///How long the event has existed. You don't need to change this
	var/activeFor = 0

	///If this event is currently running. You should not change this
	var/isRunning = TRUE

	///When this event started
	var/startedAt = 0

	///When this event ended
	var/endedAt = 0

	var/datum/event_meta/event_meta = null
	var/list/affecting_z

	///If set to TRUE, this event will not be picked for false announcements
	///This should really only be used for events that have no announcement
	var/no_fake = FALSE

	///A lore-suitable name that maintains the mystery, used for faking events
	var/ic_name = null

	///If TRUE, this event is a dummy instance used for retrieving values, it should not run or add/remove itself from any lists
	var/dummy =	FALSE

	///used for events that run secondary announcements, like releasing maint access
	var/two_part = FALSE

	var/has_skybox_image = FALSE
	var/obj/effect/overmap/visitable/ship/affected_ship
	var/announce_to_sensor_console = FALSE

/datum/event/nothing
	no_fake = 1

///Called first before processing.
///Allows you to setup your event, such as randomly
///setting the startWhen and or announceWhen variables.
///Only called once.
/datum/event/proc/setup()
	return

///Called when the tick is equal to the startWhen variable.
///Allows you to start before announcing or vice versa.
///Only called once.
/datum/event/proc/start()
	SHOULD_CALL_PARENT(TRUE)
	if(has_skybox_image)
		SSskybox.rebuild_skyboxes(affecting_z)
	announce_start()

///Called when the tick is equal to the announceWhen variable.
///Allows you to announce before starting or vice versa.
///Only called once.
/datum/event/proc/announce()
	return

/datum/event/proc/announce_start()
	if(announce_to_sensor_console)
		send_sensor_message("Entering [ic_name].")
		return FALSE
	return TRUE

/datum/event/proc/announce_end(var/faked)
	if(announce_to_sensor_console)
		send_sensor_message("Exiting [ic_name].")
		return FALSE
	return TRUE

///Called on or after the tick counter is equal to startWhen.
///You can include code related to your event or add your own
///time stamped events.
///Called more than once.
/datum/event/proc/tick()
	return

///Called on or after the tick is equal or more than endWhen
///You can include code related to the event ending.
///Do not place spawn() in here, instead use tick() to check for
///the activeFor variable.
///For example: if(activeFor == myOwnVariable + 30) doStuff()
///Only called once.
///faked indicates this is a false alarm. Used to prevent announcements and other things from happening during false alarms.
/datum/event/proc/end(var/faked)
	SHOULD_CALL_PARENT(TRUE)
	announce_end(faked)

///Returns the latest point of event processing
/datum/event/proc/lastProcessAt()
	return max(startWhen, max(announceWhen, endWhen))

///Do not override this proc, instead use the appropiate procs
///This proc will handle the calls to the appropiate procs
/datum/event/process()
	SHOULD_NOT_OVERRIDE(TRUE)

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

///Called when start(), announce() and end() has all been called
/datum/event/proc/kill(failed_to_spawn = FALSE)
	// If this event was forcefully killed run end() for individual cleanup

	if(!dummy && isRunning)
		end()

	if(failed_to_spawn)
		var/datum/event_container/killed_ec = SSevents.event_containers[severity]
		killed_ec.start_event()

	isRunning = 0
	endedAt = world.time

	if(has_skybox_image)
		SSskybox.rebuild_skyboxes(affecting_z)

	if(!dummy)
		SSevents.active_events -= src
		SSevents.event_complete(src)


/datum/event/New(datum/event_meta/EM = null, is_dummy = 0, obj/effect/overmap/visitable/ship/overmap_ship, obj/effect/overmap/event/overmap_hazard)
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

	setup()
	if(overmap_ship && overmap_hazard)
		setup_for_overmap(overmap_ship, overmap_hazard)

	if(!affecting_z)
		affecting_z = SSmapping.levels_by_trait(ZTRAIT_STATION)

	// event needs to be responsible for this, as stuff like APLUs currently make their own events for curious reasons
	SSevents.active_events += src
	startedAt = world.time

	..()

/datum/event/proc/location_name()
	if(!SSatlas.current_map.use_overmap)
		return station_name()

	var/obj/effect/overmap/O = GLOB.map_sectors["[pick(affecting_z)]"]
	return O ? O.name : "Unknown Location"

/datum/event/proc/get_skybox_image()
	return

/datum/event/proc/setup_for_overmap(obj/effect/overmap/visitable/ship/ship, obj/effect/overmap/event/hazard)
	startWhen = 0
	endWhen = INFINITY
	affecting_z = ship.map_z
	affected_ship = ship
	announce_to_sensor_console = istype(ship, /obj/effect/overmap/visitable/ship/landable)
	if(announce_to_sensor_console)
		announceWhen = -1
	ic_name = hazard.name

/datum/event/proc/send_sensor_message(message)
	for(var/obj/machinery/computer/ship/sensors/console in affected_ship.consoles)
		console.display_message(message)
