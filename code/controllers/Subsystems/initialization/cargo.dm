var/datum/subsystem/cargo/SScargo

/datum/subsystem/cargo
	name = "Cargo Stock"
	init_order = SS_INIT_CARGO
	flags = SS_NO_FIRE

/datum/subsystem/New()
	NEW_SS_GLOBAL(SScargo)

/datum/subsystem/Initialize(timeofday)
	spawn_cargo_stock()
	..()
