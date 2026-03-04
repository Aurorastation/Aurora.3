SUBSYSTEM_DEF(turf_fire)
	name = "Turf Fire"
	runlevels = RUNLEVELS_PLAYING
	wait = 2 SECONDS
	flags = SS_NO_INIT
	var/list/fires = list()

/datum/controller/subsystem/turf_fire/fire(resumed)
	var/seconds_per_tick = wait * 0.1
	for(var/obj/turf_fire/fire as anything in fires)
		fire.process(seconds_per_tick)
		if(MC_TICK_CHECK)
			return

/turf
	/// Reference to the turf fire on the turf
	var/obj/turf_fire/turf_fire
	/// Reference to the hotspot on the turf
	var/obj/hotspot/hotspot = null
