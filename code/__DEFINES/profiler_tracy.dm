// File for the byond-tracy profiler.
// Implements https://github.com/mafemergency/byond-tracy
// and https://github.com/ParadiseSS13/byond-tracy
// Tracy Client https://github.com/wolfpld/tracy

#define DISK_VERSION "disk"
#define CONNECTION_VERSION "connection"

/// Whether byond-tracy is currently running or not, no matter what version.
GLOBAL_VAR_INIT(byond_tracy_running, FALSE)

/// Which version of byond-tracy is currently running, so we call the right binary on destruction.
GLOBAL_VAR_INIT(byond_tracy_running_v, FALSE)

/// The path we have invoked to load byond tracy
GLOBAL_VAR_INIT(byond_tracy_path, FALSE)

/world/New()
	CAN_BE_REDEFINED(TRUE)
	if(GLOB.config.enable_byond_tracy)
		prof_init(DISK_VERSION) // This start's Affectedarc07's version of Tracy. Writing a .utracy file to the disk.
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
				switch(alert("Which version of Tracy would you like to run?", "Tracy Version", "Cancel", "Connection Based", "Disk Based"))
					if("Connection Based")
						world.SetConfig("env", "UTRACY_BIND_ADDRESS", "0.0.0.0")

						var/port = input("What port would you like to use?", "Tracy Port", "8086") as num
						if(!(port == 8086 || port > 4096))
							alert("Invalid port. Please enter a valid port number, either 8086 or bigger than 4096.")
							return

						world.SetConfig("env", "UTRACY_BIND_PORT", "[port]")
						prof_init(CONNECTION_VERSION) // This start's mafemergency's original version of Tracy. Requiring a direct connection, not writing to the disk.

					if("Disk Based")
						prof_init(DISK_VERSION) // This start's Affectedarc07's version of Tracy. Writing a .utracy file to the disk.

/**
 * Starts Tracy.
 */
/proc/prof_init(var/version)
	var/lib

	switch(version)
		if(CONNECTION_VERSION)
			if(world.system_type == MS_WINDOWS)
				lib = "tracy.dll"
			else if(world.system_type == UNIX)
				lib = "libprof.so"
			else
				CRASH("unsupported platform")

		if(DISK_VERSION)
			if(world.system_type == MS_WINDOWS)
				lib = "tracy-disk.dll"
			else if(world.system_type == UNIX)
				lib = "libprof-disk.so" //this doesn't currently exist btw
			else
				CRASH("unsupported platform")
		else
			CRASH("unsupported byond-tracy version [version]")

	GLOB.byond_tracy_path = lib
	var/init = call_ext(lib, "init")()
	if("0" != init) CRASH("[lib] init error: [init]")

	GLOB.byond_tracy_running = TRUE
	GLOB.byond_tracy_running_v = version

/**
 * Stops Tracy.
 * Doing this in the middle of the round is not good, don't do it.
 */
/proc/prof_destroy()
	var/lib

	switch(GLOB.byond_tracy_running_v)
		if(CONNECTION_VERSION)
			if(world.system_type == MS_WINDOWS)
				lib = "tracy.dll"
			else if(world.system_type == UNIX)
				lib = "libprof.so"
			else
				CRASH("unsupported platform")

		if(DISK_VERSION)
			if(world.system_type == MS_WINDOWS)
				lib = "tracy-disk.dll"
			else if(world.system_type == UNIX)
				lib = "libprof-disk.so" //this doesn't currently exist btw
			else
				CRASH("unsupported platform")

	call_ext(lib, "destroy")()

	GLOB.byond_tracy_running = FALSE
	GLOB.byond_tracy_running_v = null

#undef DISK_VERSION
#undef CONNECTION_VERSION
