/obj/structure/machinery/atmospherics/unary
	dir = SOUTH
	initialize_directions = SOUTH

	layer = ABOVE_TILE_LAYER

	var/datum/gas_mixture/air_contents

	pipe_class = PIPE_CLASS_UNARY

/obj/structure/machinery/atmospherics/unary/Initialize()
	air_contents = new
	air_contents.volume = 200
	. = ..()

/obj/structure/machinery/atmospherics/unary/dismantle()
	if(loc && air_contents)
		loc.assume_air(air_contents)
	. = ..()

// Housekeeping and pipe network stuff below
/obj/structure/machinery/atmospherics/unary/return_network_air(datum/pipe_network/reference)
	for(var/node in nodes_to_networks)
		if(nodes_to_networks[node] == reference)
			return list(air_contents)

/obj/structure/machinery/atmospherics/proc/is_welded()
	return FALSE

/obj/structure/machinery/atmospherics/unary/vent_pump/is_welded()
	return welded

/obj/structure/machinery/atmospherics/unary/vent_scrubber/is_welded()
	return welded
