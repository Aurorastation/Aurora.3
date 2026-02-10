// File for the byond-tracy profiler.
// Implements https://github.com/mafemergency/byond-tracy
// and https://github.com/ParadiseSS13/byond-tracy
// Tracy Client https://github.com/wolfpld/tracy

/// Whether byond-tracy is currently running or not, no matter what version.
GLOBAL_VAR_INIT(byond_tracy_running, FALSE)

/// The path we have invoked to load byond tracy
GLOBAL_VAR_INIT(byond_tracy_path, FALSE)

/world/New()
	CAN_BE_REDEFINED(TRUE)
	if(GLOB.config.enable_byond_tracy)
		prof_init() // This start's Affectedarc07's version of Tracy. Writing a .utracy file to the disk.
	. = ..()

/world/Del()
	CAN_BE_REDEFINED(TRUE)
	if(GLOB.byond_tracy_running)
		prof_destroy()
	. = ..()

/client/proc/profiler_start()
	set name = "Start Tracy Profiler"
	set category = "Debug"
	set desc = "Starts the tracy profiler, which will await the client connection or save utracy files to the server's disk."
	if(!GLOB.byond_tracy_running)
		switch(alert("Are you sure? Tracy will remain active until the server restarts.", "Tracy Init", "No", "Yes"))
			if("Yes")
				prof_init() // This start's Affectedarc07's version of Tracy. Writing a .utracy file to the disk.

/**
 * Starts Tracy.
 */
/proc/prof_init()
	var/lib

	if(world.system_type == MS_WINDOWS)
		lib = "tracy-disk.dll"
	else if(world.system_type == UNIX)
		lib = "libprof-disk.so"
	else
		to_chat(usr,"unsupported platform")
		CRASH("unsupported platform")

	GLOB.byond_tracy_path = lib
	var/init = call_ext(lib, "init")()
	if("0" != init)
		to_chat(usr,"[lib] init error: [init]")
		CRASH("[lib] init error: [init]")

	GLOB.byond_tracy_running = TRUE

/**
 * Stops Tracy.
 * Doing this in the middle of the round is not good, don't do it.
 */
/proc/prof_destroy()
	var/lib

	if(world.system_type == MS_WINDOWS)
		lib = "tracy-disk.dll"
	else if(world.system_type == UNIX)
		lib = "libprof-disk.so"
	else
		to_chat(usr,"unsupported platform")
		CRASH("unsupported platform")

	call_ext(lib, "destroy")()

	GLOB.byond_tracy_running = FALSE
