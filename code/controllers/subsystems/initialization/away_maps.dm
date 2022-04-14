/datum/controller/subsystem/away_maps
	name = "Away Map Initialization"
	init_order = SS_INIT_AWAY_MAPS
	flags = SS_NO_FIRE | SS_NO_DISPLAY

/datum/controller/subsystem/away_maps/Initialize(timeofday)
	current_map.build_away_sites()

	current_map.build_exoplanets()

	..(timeofday)
