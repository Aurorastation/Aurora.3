/obj/machinery/atmospherics/pipe/simple/heat_exchanging
	desc_info = "This radiates heat from the pipe's gas to space, cooling it down."
	icon = 'icons/atmos/heat.dmi'
	icon_state = "intact"
	pipe_icon = "hepipe"
	color = "#404040"
	level = 2
	connect_types = CONNECT_TYPE_HE
	var/initialize_directions_he
	var/surface = 2	//surface area in m^2
	var/icon_temperature = T20C //stop small changes in temperature causing an icon refresh
	appearance_flags = KEEP_TOGETHER

	minimum_temperature_difference = 20
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT

	buckle_lying = 1

	volume = ATMOS_DEFAULT_VOLUME_HE_PIPE

	// BubbleWrap
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/Initialize()
	. = ..()
	initialize_directions_he = initialize_directions	// The auto-detection from /pipe is good enough for a simple HE pipe
// BubbleWrap END
	color = "#404040" //we don't make use of the fancy overlay system for colours, use this to set the default.
	add_filter("glow", 1, list(type="drop_shadow", x = 0, y = 0, offset = 0, size = 4))

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/atmos_init()
	normalize_dir()
	var/node1_dir
	var/node2_dir

	for(var/direction in GLOB.cardinal)
		if(direction&initialize_directions_he)
			if (!node1_dir)
				node1_dir = direction
			else if (!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node1_dir))
		if(target.initialize_directions_he & get_dir(target,src))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node2_dir))
		if(target.initialize_directions_he & get_dir(target,src))
			node2 = target
			break
	if(!node1 && !node2)
		qdel(src)
		return

	atmos_initialised = TRUE
	queue_icon_update()

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/process()
	if(!parent)
		..()
	else
		var/datum/gas_mixture/pipe_air = return_air()
		if(istype(loc, /turf/space) || (isopenturf(loc) && (istype(GetBelow(loc), /turf/space) || istype(GetAbove(loc), /turf/space))))
			parent.radiate_heat_to_space(surface, 1)
		else if(istype(loc, /turf/simulated/))
			var/environment_temperature = 0
			if(loc:blocks_air)
				environment_temperature = loc:temperature
			else
				var/datum/gas_mixture/environment = loc.return_air()
				environment_temperature = environment.temperature
			if(abs(environment_temperature-pipe_air.temperature) > minimum_temperature_difference)
				parent.temperature_interact(loc, volume, thermal_conductivity)

		if(istype(buckled, /mob/living))
			var/mob/living/M = buckled
			var/hc = pipe_air.heat_capacity()
			var/avg_temp = (pipe_air.temperature * hc + M.bodytemperature * 3500) / (hc + 3500)
			pipe_air.temperature = avg_temp
			M.bodytemperature = avg_temp

			var/heat_limit = 1000

			var/mob/living/carbon/human/H = buckled
			if(istype(H) && H.species)
				heat_limit = H.species.heat_level_3

			if(pipe_air.temperature > heat_limit + 1)
				M.apply_damage(4 * log(pipe_air.temperature - heat_limit), DAMAGE_BURN, BP_CHEST, used_weapon = "Excessive Heat")

		//fancy radiation glowing
		if(pipe_air.temperature && (icon_temperature > 500 || pipe_air.temperature > 500)) //start glowing at 500K
			if(abs(pipe_air.temperature - icon_temperature) > 10)
				icon_temperature = pipe_air.temperature
				var/scale = max((icon_temperature - 500) / 1500, 0)

				var/h_r = heat2color_r(icon_temperature)
				var/h_g = heat2color_g(icon_temperature)
				var/h_b = heat2color_b(icon_temperature)

				if(icon_temperature < 2000) //scale up overlay until 2000K
					h_r = 64 + (h_r - 64)*scale
					h_g = 64 + (h_g - 64)*scale
					h_b = 64 + (h_b - 64)*scale
				var/scale_color = rgb(h_r, h_g, h_b)
				var/list/animate_targets = get_above_oo() + src
				for (var/thing in animate_targets)
					var/atom/movable/AM = thing
					animate(AM, color = scale_color, time = 2 SECONDS, easing = SINE_EASING)
				animate_filter("glow", list(color = scale_color, time = 2 SECONDS, easing = LINEAR_EASING))
				set_light(min(3, scale*2.5), min(3, scale*2.5), scale_color)
		else
			set_light(0)


/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction
	icon = 'icons/atmos/junction.dmi'
	icon_state = "intact"
	pipe_icon = "hejunction"
	level = 2
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_HE
	minimum_temperature_difference = 300
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

// BubbleWrap
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/Initialize()
	. = ..()
	switch (dir)
		if (SOUTH)
			initialize_directions = NORTH
			initialize_directions_he = SOUTH
		if (NORTH)
			initialize_directions = SOUTH
			initialize_directions_he = NORTH
		if (EAST)
			initialize_directions = WEST
			initialize_directions_he = EAST
		if (WEST)
			initialize_directions = EAST
			initialize_directions_he = WEST
	// BubbleWrap END

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/atmos_init()
	for(var/obj/machinery/atmospherics/target in get_step(src,initialize_directions))
		if(target.initialize_directions & get_dir(target,src))
			node1 = target
			break

	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,initialize_directions_he))
		if(target.initialize_directions_he & get_dir(target,src))
			node2 = target
			break

	if(!node1 && !node2)
		qdel(src)
		return

	atmos_initialised = TRUE
	queue_icon_update()
