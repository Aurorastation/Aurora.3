#define GRID_WIDTH 3

var/datum/controller/subsystem/parallax/SSparallax

/datum/controller/subsystem/parallax
	name = "Space Parallax"
	init_order = SS_INIT_PARALLAX
	flags = SS_NO_FIRE

	var/list/parallax_on_clients = list()
	var/list/parallax_icon[(GRID_WIDTH**2)*3]
	var/space_color = "#050505"
	var/parallax_initialized = 0

/datum/controller/subsystem/parallax/New()
	NEW_SS_GLOBAL(SSparallax)

/datum/controller/subsystem/parallax/Initialize(timeofday)
	create_global_parallax_icons()
	..(timeofday, TRUE)

/datum/controller/subsystem/parallax/stat_entry()
	..("C:[parallax_on_clients.len]")

#undef GRID_WIDTH
