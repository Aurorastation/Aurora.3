var/datum/controller/subsystem/parallax/SSparallax

/datum/controller/subsystem/parallax
	name = "Space Parallax Cache"
	init_order = SS_INIT_PARALLAX
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/parallax/New()
	NEW_SS_GLOBAL(SSparallax)

/datum/controller/subsystem/parallax/Initialize(timeofday)
	create_global_parallax_icons()
	..(timeofday, TRUE)
