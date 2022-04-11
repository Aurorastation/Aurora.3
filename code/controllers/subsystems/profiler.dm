
var/datum/controller/subsystem/profiler/SSprofiler

/datum/controller/subsystem/profiler
	name = "Profiler"
	wait = 1
	priority = SS_PRIORITY_PROFILE

	flags = SS_TICKER|SS_FIRE_IN_LOBBY

	var/last_fire_rt = 0
	var/threshold = 0

	var/next_restart = 0
	var/restart_period = 0

/datum/controller/subsystem/profiler/New()
	NEW_SS_GLOBAL(SSprofiler)

/datum/controller/subsystem/profiler/Initialize()
	if (!config.profiler_is_enabled)
		..()
		flags |= SS_NO_FIRE
		return

	restart_period = config.profiler_restart_period
	threshold = config.profiler_timeout_threshold

	..()

/datum/controller/subsystem/profiler/fire()
	. = world.timeofday

	if (!last_fire_rt)
		last_fire_rt = .
		next_restart = world.time + restart_period
		world.Profile(PROFILE_START)

	if (. - last_fire_rt > threshold)
		DumpData()
	else if (world.time > next_restart)
		RestartProfiler()

	last_fire_rt = .

/datum/controller/subsystem/profiler/proc/DumpData()
	log_debug("Profiler: dump profile after CPU spike.")
	admin_notice(SPAN_DANGER("Profiler: dump profile after CPU spike."), R_SERVER|R_DEV)

	var/name = "[game_id]_[time2text(world.timeofday, "hh-mm-ss")]"
	text2file(world.Profile(0, "json"), "data/logs/profiler/[game_id]/[name].json")

/datum/controller/subsystem/profiler/proc/RestartProfiler()
	world.Profile(PROFILE_CLEAR)
	next_restart = world.time + restart_period
