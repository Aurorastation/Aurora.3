// File for the byond-tracy profiler.
// Implements https://github.com/mafemergency/byond-tracy
// and https://github.com/ParadiseSS13/byond-tracy
// Tracy Client https://github.com/wolfpld/tracy

var/byond_tracy_running = 0			// Whether byond-tracy is currently running or not, no matter what version.
var/byond_tracy_running_v = null	// Which version of byond-tracy is currently running, so we call the right binary on destruction.

/world/New()
	if(GLOB.config.enable_byond_tracy)
		prof_init("tracy_disk") // This start's Affectedarc07's version of Tracy. Writing a .utracy file to the disk.
	. = ..()

/world/Del()
	if(byond_tracy_running)
		prof_destroy()
	. = ..()

/client/proc/profiler_start()
	set name = "Start Tracy Profiler"
	set category = "Debug"
	set desc = "Starts the tracy profiler, which will await the client connection or save utracy files to the server's disk."
	if(!byond_tracy_running)
		switch(alert("Are you sure? Tracy will remain active until the server restarts.", "Tracy Init", "No", "Yes"))
			if("Yes")
				switch(alert("Which version of Tracy would you like to run?", "Tracy Version", "Cancel", "Connection Based", "Disk Based"))
					if("Connection Based")
						prof_init("tracy") // This start's mafemergency's original version of Tracy. Requiring a direct connection, not writing to the disk.
					if("Disk Based")
						prof_init("tracy_disk") // This start's Affectedarc07's version of Tracy. Writing a .utracy file to the disk.

/**
 * Starts Tracy.
 */
/proc/prof_init(var/version)
	var/lib

	switch(version)
		if("tracy") lib = "tracy.dll"
		if("tracy_disk") lib = "tracy-disk.dll"

	var/init = LIBCALL(lib, "init")()
	if("0" != init) CRASH("[lib] init error: [init]")

	byond_tracy_running = 1
	byond_tracy_running_v = version

/**
 * Stops Tracy.
 * Doing this in the middle of the round is not good, don't do it.
 */
/proc/prof_destroy()
	var/lib

	switch(byond_tracy_running_v)
		if("tracy") lib = "tracy.dll"
		if("tracy_disk") lib = "tracy-disk.dll"

	LIBCALL(lib, "destroy")()

	byond_tracy_running = 0
	byond_tracy_running_v = null
