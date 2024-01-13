/proc/auxtools_stack_trace(msg)
	CRASH(msg)

/proc/auxtools_expr_stub()
	CRASH("auxtools not loaded")

/proc/enable_debugging(mode, port)
	CRASH("auxtools not loaded")

/world/Del()
	if(byond_version < 515)
		var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
		if (debug_server)
			call(debug_server, "auxtools_shutdown")()
	. = ..()
