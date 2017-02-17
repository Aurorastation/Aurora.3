/datum/subsystem/events
	name = "Event Controller"
	wait = 2 SECONDS

	flags = SS_NO_INIT
	priority = SS_PRIORITY_EVENT

	var/tmp/list/processing_events = list()
	var/tmp/pos = EVENT_LEVEL_MUNDANE

/datum/subsystem/events/fire(resumed = FALSE)
	if (!resumed)
		processing_events = event_manager.active_events.Copy()
		pos = EVENT_LEVEL_MUNDANE

	while (processing_events.len)
		var/datum/event/E = processing_events[processing_events.len]
		processing_events.len--

		E.process()

		if (MC_TICK_CHECK)
			return

	while (pos <= EVENT_LEVEL_MAJOR)
		var/list/datum/event_container/EC = event_manager.event_containers[pos]
		EC.process()
		pos++
		
		if (MC_TICK_CHECK)
			return
