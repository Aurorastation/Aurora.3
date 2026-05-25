
/**
 *  A function to wrap calls to DLLs for debugging purposes.
 */
/proc/dll_call(dll, func, ...)
	var/start = world.timeofday

	var/list/calling_arguments = length(args) > 2 ? args.Copy(3) : null

#ifdef OPENDREAM
	. = call_ext(dll, func)(calling_arguments)
#else
	. = call_ext(dll, func)(arglist(calling_arguments))
#endif
	if (world.timeofday - start > 10 SECONDS)
		crash_with("DLL call took longer than 10 seconds: [func]")
