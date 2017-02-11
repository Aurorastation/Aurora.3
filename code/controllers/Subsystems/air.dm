var/datum/subsystem/air/SSair

var/air_processing_killed = FALSE

/datum/subsystem/air
	name = "ZAS"
	wait = 2 SECONDS
	priority = SS_PRIORITY_AIR

/datum/subsystem/air/Initialize(timeofday)
	if (!air_master)
		air_master = new
		air_master.Setup()
	..()

/datum/subsystem/air/fire(resumed = FALSE)
	if (!air_processing_killed)
		if (!air_master.Tick())
			air_master.failed_ticks++

			if (air_master.failed_ticks > 5)
				world << span("danger", "RUNTIMES IN ATMOS TICKER! Killing air simulation!")
				world.log << "### ZAS SHUTDOWN"

				message_admins("ZASALERT: Shutting down! status: [air_master.tick_progress]")
				log_admin("ZASALERT: Shutting down! status: [air_master.tick_progress]")

				air_processing_killed = TRUE
				air_master.failed_ticks = 0
