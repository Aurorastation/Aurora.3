var/datum/subsystem/cargo/SScargo

/datum/subsystem/cargo
	name = "Cargo Stock"
	init_order = SS_INIT_CARGO
	flags = SS_NO_FIRE

/datum/subsystem/cargo/New()
	NEW_SS_GLOBAL(SScargo)

/datum/subsystem/Initialize(timeofday)
	new /datum/cargospawner()
	..()
