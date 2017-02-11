/datum/subsystem/events
	name = "Event Controller"
	wait = 2 SECONDS

	flags = SS_NO_INIT

	var/tmp/list/processing_events = list()
	var/tmp/pos = EVENT_LEVEL_MUNDANE

/datum/subsystem/events/fire(resumed = FALSE)
	if (!resumed)
		processing_events = event_manager.active_events.Copy()
		pos = EVENT_LEVEL_MUNDANE

	while (processing_events)
		var/datum/event/E = processing_events[processing_events.len]
		processing_events.len--

		E.process()

		if (MC_TICK_CHECK)
			return

	while (i++ < EVENT_LEVEL_MAJOR)
		last_object = event_manager.event_containers[i]
		var/list/datum/event_container/EC = last_object
		EC.process()
		
		if (MC_TICK_CHECK)
			return
