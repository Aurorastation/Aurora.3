/obj/machinery/atmospherics/pipe/simple/heat_exchanging
	icon = 'icons/atmos/heat.dmi'
	icon_state = "11"
	color = PIPE_COLOR_DARK_GREY
	pipe_color = PIPE_COLOR_DARK_GREY
	level = 2
	connect_types = CONNECT_TYPE_HE
	var/initialize_directions_he
	var/surface = 2	//surface area in m^2
	var/icon_temperature = T20C //stop small changes in temperature causing an icon refresh
	appearance_flags = KEEP_TOGETHER
	build_icon_state = "he"

	minimum_temperature_difference = 20
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT

	maximum_pressure = 360*ONE_ATMOSPHERE
	fatigue_pressure = 300*ONE_ATMOSPHERE
	alert_pressure = 360*ONE_ATMOSPHERE

	can_buckle = TRUE
	buckle_lying = TRUE

	volume = ATMOS_DEFAULT_VOLUME_HE_PIPE

	burst_type = /obj/machinery/atmospherics/pipe/burst/heat

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This radiates heat from the pipe's gas to space, cooling it down."

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/Initialize()
	. = ..()
	add_filter("glow", 1, list(type="drop_shadow", x = 0, y = 0, offset = 0, size = 4))

///obj/machinery/atmospherics/pipe/simple/heat_exchanging/pipe_color_check(color)
//	if (color == initial(pipe_color))
//		return TRUE
//	return FALSE

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/set_dir(new_dir)
	..()
	initialize_directions_he = get_initialize_directions() // all directions are HE

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/atmos_init()
	atmos_initialised = TRUE
	for(var/obj/machinery/atmospherics/node as anything in nodes_to_networks)
		QDEL_NULL(nodes_to_networks[node])
	nodes_to_networks = null
	for(var/direction in GLOB.cardinals)
		if(direction & initialize_directions_he) // connect to HE pipes with HE ends in the HE directions
			for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,direction))
				if((target.initialize_directions_he & get_dir(target, src)) && check_connect_types(target, src))
					LAZYDISTINCTADD(nodes_to_networks, target)
		else if(direction & initialize_directions) // and to normal pipes normally in the other directions
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if((target.initialize_directions & get_dir(target, src)) && check_connect_types(target, src))
					if(istype(target, /obj/machinery/atmospherics/pipe/simple/heat_exchanging))
						var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/heat = target
						if(heat.initialize_directions_he & get_dir(target, src)) // this means we are connecting a normal end to an HE end on an HE part; not OK
							continue
					LAZYDISTINCTADD(nodes_to_networks, target)
	queue_icon_update()

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/process()
	if(!parent)
		..()
		return

	var/datum/gas_mixture/pipe_air = return_air()
	var/turf/T = get_turf(loc)
	var/turf/turf_above = GET_TURF_ABOVE(T)
	ClearOverlays()

	if(istype(loc, /turf/space) || (isopenturf(loc) && (istype(GET_TURF_BELOW(T), /turf/space) || istype(turf_above, /turf/space))))
		parent.radiate_heat_to_space(surface, 1)

	else if(istype(loc, /turf/simulated/lava))
		// we want to heat up the pipe to some arbitrary temperature of lava
		// need to add some thermal energy to pipe air
		// but only up to a limit so it does not heat up instantly to max
		// and stop heating when it is at that temperature
		var/max_energy_change = 200 KILO WATTS
		var/lava_temperature = 1500
		var/energy_to_temp = parent.air.get_thermal_energy_change(lava_temperature)
		parent.air.add_thermal_energy(max(min(energy_to_temp, max_energy_change), 0))

	else if(istype(loc, /turf/simulated))
		var/turf/simulated/simulated_turf = loc
		var/environment_temperature = 0
		if(simulated_turf.blocks_air)
			environment_temperature = simulated_turf.temperature
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
			var/mutable_appearance/emissive = emissive_appearance(icon, icon_state, alpha = min(3, scale*2.5))
			AddOverlays(emissive)
	else
		set_light(0)


/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction
	icon = 'icons/atmos/junction.dmi'
	icon_state = "11"
	level = 2
	connect_types = CONNECT_TYPE_REGULAR|CONNECT_TYPE_HE|CONNECT_TYPE_FUEL
	build_icon_state = "junction"
	rotate_class = PIPE_ROTATE_STANDARD

// Doubling up on initialize_directions is necessary to allow HE pipes to connect
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/set_dir(new_dir)
	. = ..()
	initialize_directions_he = dir

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/cap
	name = "heat exchanging pipe endcap"
	desc = "An endcap for heat exchanging pipes"
	icon_state = "he_cap"
	level = 2

	volume = 35

	pipe_class = PIPE_CLASS_UNARY
	dir = SOUTH
	initialize_directions = null
	build_icon_state = "he_cap"
	can_buckle = FALSE
	rotate_class = PIPE_ROTATE_STANDARD

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/cap/set_dir(new_dir)
	. = ..()
	initialize_directions_he = dir

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/cap/update_icon()
	icon_state = "he_cap"
	color = pipe_color
