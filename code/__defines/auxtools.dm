/proc/auxtools_stack_trace(msg)
	CRASH(msg)

/proc/enable_debugging(mode, port)
	CRASH("auxtools not loaded")

/world/New()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		call(debug_server, "auxtools_init")()
		enable_debugging()
	. = ..()

/world/Del()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		call(debug_server, "auxtools_shutdown")()
	. = ..()