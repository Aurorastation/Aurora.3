var/datum/subsystem/supply/SSsupply

/datum/subsystem/supply
	name = "Supply"
	wait = 30 SECONDS
	flags = SS_NO_INIT | SS_NO_TICK_CHECK

/datum/subsystem/supply/fire(resume = FALSE)
	supply_controller.process()
