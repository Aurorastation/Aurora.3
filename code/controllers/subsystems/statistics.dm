/datum/controller/subsystem/statistics
	name = "Statistics & Inactivity"
	wait = 60 SECONDS
	flags = SS_NO_TICK_CHECK

/datum/controller/subsystem/statistics/Initialize(timeofday)
	if (!config.kick_inactive && !(config.sql_enabled && config.sql_stats))
		disable()
	
	..(timeofday, silent = TRUE)

/datum/controller/subsystem/statistics/fire()
	// Handle AFK.
	if (config.kick_inactive)
		var/inactivity_threshold = config.kick_inactive MINUTES
		for (var/client/C in clients)
			if (C.is_afk(inactivity_threshold))
				if (!istype(C.mob, /mob/dead))
					log_access("AFK: [key_name(C)]")
					C << span("warning", "You have been inactive for more than [config.kick_inactive] minute\s and have been disconnected.")
					qdel(C)
	// Handle stats.
	if (config.sql_enabled && config.sql_stats)
		sql_poll_population()
