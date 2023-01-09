#define AUXTOOLS "debug_server.dll"

/proc/auxtools_stack_trace(msg)
	CRASH(msg)

/proc/auxtools_expr_stub()
	CRASH("auxtools not loaded")

/proc/enable_debugging(mode, port)
	CRASH("auxtools not loaded")

/world/New()
	call_ext(AUXTOOLS, "auxtools_init")()
	enable_debugging()
	. = ..()

/world/Del()
	call_ext(AUXTOOLS, "auxtools_shutdown")()
	. = ..()
