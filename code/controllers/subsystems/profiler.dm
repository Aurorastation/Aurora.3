
var/datum/controller/subsystem/profiler/SSprofiler

/datum/controller/subsystem/profiler
	name = "Profiler"
	wait = 1
	priority = SS_PRIORITY_PROFILE

	flags = SS_TICKER

	var/next_restart = 0
	var/restart_period = 0
	var/threshold = 0

/datum/controller/subsystem/profiler/New()
	NEW_SS_GLOBAL(SSprofiler)

/datum/controller/subsystem/profiler/Initialize()
	if (!config.profiler_is_enabled)
		..()
		flags |= SS_NO_FIRE
		return

	restart_period = config.profiler_restart_period + restart_period
	threshold = config.profiler_tick_usage_threshold

	next_restart = world.time
	world.Profile(PROFILE_START)

	..()

/datum/controller/subsystem/profiler/fire()
	if (world.cpu > threshold)
		DumpData()
	else if (world.time > next_restart)
		world.Profile(PROFILE_CLEAR)
		next_restart = world.time + restart_period

/datum/controller/subsystem/profiler/proc/DumpData()
	log_debug("Profiler: dump profile after CPU spike.")
	var/name = "[game_id]_[time2text(world.realtime, "hh-mm-ss")_[world.time]]"
	text2file(world.Profile(0, "json"), "data/logs/profile/[game_id]/[name].json")
