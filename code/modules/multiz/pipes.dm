////////////////////////////
// parent class for pipes //
////////////////////////////
/obj/machinery/atmospherics/pipe/zpipe
	icon = 'icons/atmos/pipes.dmi'
	icon_state = "up"
	/// What direction of pipe this is. Used for icons.
	var/ptype

	name = "upwards pipe"
	desc = "A pipe segment to connect upwards."

	volume = 70

	dir = SOUTH
	initialize_directions = SOUTH

	var/minimum_temperature_difference = 300
	// WALL_HEAT_TRANSFER_COEFFICIENT
	var/thermal_conductivity = 0

	var/travel_verbname = "UNDEFINED"
	var/travel_direction_verb = "UNDEFINED"
	var/travel_direction_name = "UNDEFINED"
	var/travel_direction = "UNDEFINED"

	level = 1

/obj/machinery/atmospherics/pipe/zpipe/Entered(mob/living/M)
	if(istype(M))
		to_chat(M, SPAN_NOTICE("You are in a vertical pipe section. Use [travel_verbname] from the IC menu to [travel_direction_verb] a level."))
		. = ..()

/obj/machinery/atmospherics/pipe/zpipe/update_icon()
	color = pipe_color

/////////////////////////
// the elusive up pipe //
/////////////////////////
/obj/machinery/atmospherics/pipe/zpipe/up
	icon_state = "up"
	ptype = "up"

	name = "upwards pipe"
	desc = "A pipe segment to connect upwards."

	build_icon = "up"

	travel_verbname = "Move Upwards"
	travel_direction_verb = "ascend"
	travel_direction_name = "up"
	travel_direction = UP

/obj/machinery/atmospherics/pipe/zpipe/up/atmos_init()
	..()
	var/turf/current_turf = get_turf(src)
	var/turf/above = GET_TURF_ABOVE(current_turf)
	if(above)
		for(var/obj/machinery/atmospherics/target in above)
			if(istype(target, /obj/machinery/atmospherics/pipe/zpipe/down) && check_connect_types(target,src))
				LAZYDISTINCTADD(nodes_to_networks, target)

///////////////////////
// and the down pipe //
///////////////////////

/obj/machinery/atmospherics/pipe/zpipe/down
	icon_state = "down"
	ptype = "down"

	name = "downwards pipe"
	desc = "A pipe segment to connect downwards."

	build_icon = "down"

	travel_verbname = "Move Downwards"
	travel_direction_verb = "descend"
	travel_direction_name = "down"
	travel_direction = DOWN

/obj/machinery/atmospherics/pipe/zpipe/down/atmos_init()
	..()
	var/turf/current_turf = get_turf(src)
	var/turf/below = GET_TURF_BELOW(current_turf)
	if(below)
		for(var/obj/machinery/atmospherics/target in below)
			if(istype(target, /obj/machinery/atmospherics/pipe/zpipe/up) && check_connect_types(target,src))
				LAZYDISTINCTADD(nodes_to_networks, target)

////////////////////////////////
// supply/scrubbers/fuel/aux  //
////////////////////////////////

/obj/machinery/atmospherics/pipe/zpipe/up/scrubbers
	icon_state = "up-scrubbers"
	name = "upwards scrubbers pipe"
	desc = "A scrubbers pipe segment to connect upwards."
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/zpipe/up/supply
	icon_state = "up-supply"
	name = "upwards supply pipe"
	desc = "A supply pipe segment to connect upwards."
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/zpipe/up/fuel
	icon_state = "up-fuel"
	name = "upwards fuel pipe"
	desc = "A fuel pipe segment to connect upwards."
	connect_types = CONNECT_TYPE_FUEL
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/zpipe/up/aux
	icon_state = "up-aux"
	name = "upwards auxiliary pipe"
	desc = "A auxiliary pipe segment to connect upwards."
	connect_types = CONNECT_TYPE_AUX
	icon_connect_type = "-aux"
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/zpipe/down/scrubbers
	icon_state = "down-scrubbers"
	name = "downwards scrubbers pipe"
	desc = "A scrubbers pipe segment to connect downwards."
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/zpipe/down/supply
	icon_state = "down-supply"
	name = "downwards supply pipe"
	desc = "A supply pipe segment to connect downwards."
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/zpipe/down/fuel
	icon_state = "down-fuel"
	name = "downwards fuel pipe"
	desc = "A fuel pipe segment to connect downwards."
	connect_types = CONNECT_TYPE_FUEL
	icon_connect_type = "-fuel"
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/zpipe/down/aux
	icon_state = "down-aux"
	name = "downwards auxiliary pipe"
	desc = "An auxiliary pipe segment to connect downwards."
	connect_types = CONNECT_TYPE_AUX
	icon_connect_type = "-supply"
	color = PIPE_COLOR_CYAN

// Colored misc. pipes
/obj/machinery/atmospherics/pipe/zpipe/up/cyan
	color = PIPE_COLOR_CYAN
/obj/machinery/atmospherics/pipe/zpipe/down/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/zpipe/up/black
	color = PIPE_COLOR_BLACK
/obj/machinery/atmospherics/pipe/zpipe/down/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/zpipe/up/green
	color = PIPE_COLOR_GREEN
/obj/machinery/atmospherics/pipe/zpipe/down/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/zpipe/up/red
	color = PIPE_COLOR_RED
/obj/machinery/atmospherics/pipe/zpipe/down/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/zpipe/up/yellow
	color = PIPE_COLOR_YELLOW
/obj/machinery/atmospherics/pipe/zpipe/down/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/zpipe/up/blue
	color = PIPE_COLOR_BLUE
/obj/machinery/atmospherics/pipe/zpipe/down/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/zpipe/up/purple
	color = PIPE_COLOR_PURPLE
/obj/machinery/atmospherics/pipe/zpipe/down/purple
	color = PIPE_COLOR_PURPLE
