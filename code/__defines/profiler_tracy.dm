// Implements https://github.com/mafemergency/byond-tracy
// Client https://github.com/wolfpld/tracy
// As of now, only 0.8.2 is supported as a client, this might change in the future however
// /world/New()
// 	prof_init()
// 	. = ..()

/proc/prof_init()
	var/lib

	switch(world.system_type)
		if(MS_WINDOWS) lib = "prof.dll"
		if(UNIX) lib = "libprof.so"
		else CRASH("unsupported platform")

	var/init = LIBCALL(lib, "init")()
	if("0" != init) CRASH("[lib] init error: [init]")
