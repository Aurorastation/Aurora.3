/obj/machinery/atmospherics/binary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH
	layer = EXPOSED_PIPE_LAYER

	var/datum/gas_mixture/air1
	var/datum/gas_mixture/air2

	pipe_class = PIPE_CLASS_BINARY
	connect_dir_type = SOUTH | NORTH

/obj/machinery/atmospherics/binary/Initialize()
	air1 = new
	air2 = new

	air1.volume = 200
	air2.volume = 200
	. = ..()

/obj/machinery/atmospherics/binary/Destroy()
	QDEL_NULL(air1)
	QDEL_NULL(air2)

	. = ..()

/obj/machinery/atmospherics/binary/air_in_dir(direction)
	if(direction == dir)
		return air2
	else if(direction == turn(dir, 180))
		return air1

/obj/machinery/atmospherics/binary/AltClick(var/mob/user)
	if(src.anchored)
		if(!allowed(user))
			to_chat(user, SPAN_WARNING("Access denied."))
			return
		Topic(src, list("power" = "1"))
	else
		. = ..()
