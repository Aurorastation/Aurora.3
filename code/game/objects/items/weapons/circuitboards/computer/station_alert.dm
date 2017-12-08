	name = T_BOARD("station alert console")
	build_path = /obj/machinery/computer/station_alert
	var/list/alarm_handlers

	alarm_handlers = new()
	set_expansion(/datum/expansion/multitool, new/datum/expansion/multitool/circuitboards/stationalert(src))
	..()

	if(..(SA))
		SA.unregister_monitor()

		var/datum/nano_module/alarm_monitor/monitor = new(SA)
		monitor.alarm_handlers.Cut()
		for(var/alarm_handler in alarm_handlers)
			monitor.alarm_handlers += alarm_handler

		SA.register_monitor(monitor)
		return 1

	if(..(SA))
		alarm_handlers.Cut()
		if(SA.alarm_monitor)
			for(var/alarm_handler in SA.alarm_monitor.alarm_handlers)
				alarm_handlers += alarm_handler
		return 1
