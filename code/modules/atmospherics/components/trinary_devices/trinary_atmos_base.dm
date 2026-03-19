/obj/machinery/atmospherics/trinary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|WEST
	layer = EXPOSED_PIPE_LAYER

	var/datum/gas_mixture/air1
	var/datum/gas_mixture/air2
	var/datum/gas_mixture/air3

	pipe_class = PIPE_CLASS_TRINARY
	connect_dir_type = SOUTH | NORTH | WEST

/obj/machinery/atmospherics/trinary/Initialize()
	air1 = new
	air2 = new
	air3 = new

	air1.volume = 200
	air2.volume = 200
	air3.volume = 200
	. = ..()

/obj/machinery/atmospherics/trinary/Destroy()
	QDEL_NULL(air1)
	QDEL_NULL(air2)
	QDEL_NULL(air3)

	. = ..()

/obj/machinery/atmospherics/trinary/air_in_dir(direction)
	if(direction == dir)
		return air3
	else if(direction == turn(dir, -90))
		return air2
	else if(direction == turn(dir, 180))
		return air1
