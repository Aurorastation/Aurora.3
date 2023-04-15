/proc/auxtools_stack_trace(msg)
	CRASH(msg)

/proc/auxtools_expr_stub()
	CRASH("auxtools not loaded")

/proc/enable_debugging(mode, port)
	CRASH("auxtools not loaded")

// Remove byond version check when spacemanDMM / auxtools are updated to 515
// otherwise your world/New will conk out and die
/world/New()
	if(byond_version < 515)
		var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
		if (debug_server)
			call(debug_server, "auxtools_init")()
			enable_debugging()
	. = ..()

/world/Del()
	if(byond_version < 515)
		var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
		if (debug_server)
			call(debug_server, "auxtools_shutdown")()
	. = ..()
