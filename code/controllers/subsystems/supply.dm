var/datum/subsystem/cargo/SScargo

/datum/subsystem/cargo
	name = "Cargo"
	wait = 30 SECONDS
	flags = SS_NO_TICK_CHECK
	init_order = SS_INIT_CARGO

/datum/subsystem/cargo/Initialize(timeofday)
	var/datum/cargospawner/spawner = new
	spawner.start()
	qdel(spawner)
	..()

/datum/subsystem/cargo/fire(resume = FALSE)
	supply_controller.process()
