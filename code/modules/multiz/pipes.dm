////////////////////////////
// parent class for pipes //
////////////////////////////
/obj/machinery/atmospherics/pipe/zpipe
	icon = 'icons/atmos/pipes.dmi'
	icon_state = "up"
	var/ptype	// What direction of pipe this is. Used for icons.

	name = "upwards pipe"
	desc = "A pipe segment to connect upwards."

	volume = 70

	dir = SOUTH
	initialize_directions = SOUTH

	var/minimum_temperature_difference = 300
	var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

	var/maximum_pressure = 70*ONE_ATMOSPHERE
	var/fatigue_pressure = 55*ONE_ATMOSPHERE
	alert_pressure = 55*ONE_ATMOSPHERE

	var/travel_verbname = "UNDEFINED"
	var/travel_direction_verb = "UNDEFINED"
	var/travel_direction_name = "UNDEFINED"
	var/travel_direction = "UNDEFINED"

	level = 1

/obj/machinery/atmospherics/pipe/zpipe/Initialize()
	icon = null

	switch(dir)
		if(SOUTH)
			initialize_directions = SOUTH
		if(NORTH)
			initialize_directions = NORTH
		if(WEST)
			initialize_directions = WEST
		if(EAST)
			initialize_directions = EAST
		if(NORTHEAST)
			initialize_directions = NORTH
		if(NORTHWEST)
			initialize_directions = WEST
		if(SOUTHEAST)
			initialize_directions = EAST
		if(SOUTHWEST)
			initialize_directions = SOUTH

	. = ..()


/obj/machinery/atmospherics/pipe/zpipe/Entered(mob/living/M)
	if(istype(M))
		to_chat(M, span("notice", "You are in a vertical pipe section. Use [travel_verbname] from the IC menu to [travel_direction_verb] a level."))
		. = ..()

/obj/machinery/atmospherics/pipe/zpipe/hide(var/i)
	if(istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	queue_icon_update()

/obj/machinery/atmospherics/pipe/zpipe/machinery_process()
	if(!parent) //This should cut back on the overhead calling build_network thousands of times per cycle
		..()
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/zpipe/check_pressure(pressure)
	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure_difference = pressure - environment.return_pressure()

	if(pressure_difference > maximum_pressure)
		burst()

	else if(pressure_difference > fatigue_pressure)
		//TODO: leak to turf, doing pfshhhhh
		if(prob(5))
			burst()

	else return 1

/obj/machinery/atmospherics/pipe/zpipe/proc/burst()
	src.visible_message("<span class='warning'>\The [src] bursts!</span>");
	playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
	var/datum/effect/effect/system/smoke_spread/smoke = new
	smoke.set_up(1,0, src.loc, 0)
	smoke.start()
	qdel(src) // Yes QDel.

/obj/machinery/atmospherics/pipe/zpipe/proc/normalize_dir()
	if(dir==3)
		set_dir(1)
	else if(dir==12)
		set_dir(4)

/obj/machinery/atmospherics/pipe/zpipe/Destroy()
	if(node1)
		node1.disconnect(src)
	if(node2)
		node2.disconnect(src)
	return ..()

/obj/machinery/atmospherics/pipe/zpipe/pipeline_expansion()
	return list(node1, node2)

/obj/machinery/atmospherics/pipe/zpipe/update_icon()
	if (!check_icon_cache())
		return

	cut_overlays()

	if(!node1 && !node2)
		var/turf/T = get_turf(src)
		new /obj/item/pipe(loc, make_from=src)
		for (var/obj/machinery/meter/meter in T)
			if (meter.target == src)
				new /obj/item/pipe_meter(T)
				qdel(meter)
		qdel(src)
	else
		add_overlay(icon_manager.get_atmos_icon("pipe", , pipe_color, "[ptype][icon_connect_type]"))

/obj/machinery/atmospherics/pipe/zpipe/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node2 = null

	return null
/////////////////////////
// the elusive up pipe //
/////////////////////////
/obj/machinery/atmospherics/pipe/zpipe/up
	icon_state = "up"
	ptype = "up"

	name = "upwards pipe"
	desc = "A pipe segment to connect upwards."

	travel_verbname = "Move Upwards"
	travel_direction_verb = "ascend"
	travel_direction_name = "up"
	travel_direction = UP

/obj/machinery/atmospherics/pipe/zpipe/up/atmos_init()
	normalize_dir()
	var/node1_dir

	for(var/direction in cardinal)
		if(direction&initialize_directions)
			if (!node1_dir)
				node1_dir = direction

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node1 = target
				break

	var/turf/above = GetAbove(src)
	if(above)
		for(var/obj/machinery/atmospherics/target in above)
			if(target.initialize_directions && istype(target, /obj/machinery/atmospherics/pipe/zpipe/down))
				if (check_connect_types(target,src))
					node2 = target
					break


	var/turf/T = src.loc			// hide if turf is not intact
	hide(!T.is_plating())

///////////////////////
// and the down pipe //
///////////////////////

/obj/machinery/atmospherics/pipe/zpipe/down
	icon_state = "down"
	ptype = "down"

	name = "downwards pipe"
	desc = "A pipe segment to connect downwards."

	travel_verbname = "Move Downwards"
	travel_direction_verb = "descend"
	travel_direction_name = "down"
	travel_direction = DOWN

/obj/machinery/atmospherics/pipe/zpipe/down/atmos_init()
	normalize_dir()
	var/node1_dir

	for(var/direction in cardinal)
		if(direction&initialize_directions)
			if (!node1_dir)
				node1_dir = direction

	for(var/obj/machinery/atmospherics/target in get_step(src,node1_dir))
		if(target.initialize_directions & get_dir(target,src))
			if (check_connect_types(target,src))
				node1 = target
				break

	var/turf/below = GetBelow(src)
	if(below)
		for(var/obj/machinery/atmospherics/target in below)
			if(target.initialize_directions && istype(target, /obj/machinery/atmospherics/pipe/zpipe/up))
				if (check_connect_types(target,src))
					node2 = target
					break


	var/turf/T = src.loc			// hide if turf is not intact
	hide(!T.is_plating())

///////////////////////
// supply/scrubbers  //
///////////////////////

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
