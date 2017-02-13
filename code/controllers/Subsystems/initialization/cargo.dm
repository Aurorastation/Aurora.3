/datum/subsystem/cargo
	name = "Cargo Stock"
	init_order = SS_INIT_CARGO
	flags = SS_NO_FIRE

/datum/subsystem/cargo/Initialize(timeofday)
	var/datum/cargospawner/spawner = new
	spawner.start()
	..()
