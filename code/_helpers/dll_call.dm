
/** A function to wrap calls to DLLs for debugging purposes.
 */
/proc/dll_call(dll, func, ...)

	var/start = world.timeofday

	var/list/calling_arguments = length(args) > 2 ? args.Copy(3) : null

	. = call(dll, func)(arglist(calling_arguments))

	if (world.timeofday - start > 2 SECONDS)
		crash_with("DLL call took longer than 2 seconds: [func]")
