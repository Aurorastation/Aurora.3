var/datum/subsystem/parallax/SSparallax

/datum/subsystem/parallax
	name = "Space Parallax Cache"
	init_order = SS_INIT_PARALLAX
	flags = SS_NO_FIRE

/datum/subsystem/parallax/New()
	NEW_SS_GLOBAL(SSparallax)

/datum/subsystem/parallax/Initialize(timeofday)
	create_global_parallax_icons()
	..(timeofday, TRUE)
