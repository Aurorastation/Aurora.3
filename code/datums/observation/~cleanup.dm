GLOBAL_LIST_EMPTY(global_listen_count)
GLOBAL_LIST_EMPTY(event_sources_count)
GLOBAL_LIST_EMPTY(event_listen_count)

/singleton/observ/register(datum/event_source, datum/listener, proc_call)
	. = ..()
	if(.)
		GLOB.event_sources_count[event_source] += 1
		GLOB.event_listen_count[listener] += 1

/singleton/observ/unregister(datum/event_source, datum/listener, proc_call)
	. = ..()
	if(.)
		GLOB.event_sources_count[event_source] -= 1
		GLOB.event_listen_count[listener] -= 1

		if(GLOB.event_sources_count[event_source] <= 0)
			GLOB.event_sources_count -= event_source
		if(GLOB.event_listen_count[listener] <= 0)
			GLOB.event_listen_count -= listener

/singleton/observ/register_global(datum/listener, proc_call)
	. = ..()
	if(.)
		GLOB.global_listen_count[listener] += 1

/singleton/observ/unregister_global(datum/listener, proc_call)
	. = ..()
	if(.)
		GLOB.global_listen_count[listener] -= 1
		if(GLOB.global_listen_count[listener] <= 0)
			GLOB.global_listen_count -= listener

