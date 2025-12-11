#define TURF_FIRE_REQUIRED_TEMP (T0C+10)
#define TURF_FIRE_TEMP_BASE (T0C+100)
#define TURF_FIRE_POWER_LOSS_ON_LOW_TEMP 7
#define TURF_FIRE_TEMP_INCREMENT_PER_POWER 3
#define TURF_FIRE_VOLUME 150
#define TURF_FIRE_MAX_POWER 50

#define TURF_FIRE_ENERGY_PER_BURNED_OXY_MOL 12000
#define TURF_FIRE_BURN_RATE_BASE 0.12
#define TURF_FIRE_BURN_RATE_PER_POWER 0.02
#define TURF_FIRE_BURN_MINIMUM_OXYGEN_REQUIRED 0.5
#define TURF_FIRE_BURN_PLAY_SOUND_EFFECT_CHANCE 6

#define TURF_FIRE_STATE_SMALL 1
#define TURF_FIRE_STATE_MEDIUM 2
#define TURF_FIRE_STATE_LARGE 3
#define TURF_FIRE_STATE_MAX 4

/obj/turf_fire
	icon = 'icons/effects/turf_fire.dmi'
	layer = BELOW_DOOR_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	/// How much power have we got. This is treated like fuel, be it flamethrower liquid or any random thing you could come up with
	var/fire_power = 20
	/// If false, it does not interact with atmos.
	var/interact_with_atmos = TRUE

	/// If false, it will not lose power by itself. Mainly for adminbus events or mapping.
	var/passive_loss = TRUE

	/// Visual state of the fire. Kept track to not do too many updates.
	var/current_fire_state

	light_color = COLOR_ORANGE

///All the subtypes are for adminbussery and or mapping
/obj/turf_fire/magical
	interact_with_atmos = FALSE
	passive_loss = FALSE
	color = COLOR_LIGHT_CYAN

/obj/turf_fire/small
	fire_power = 10

/obj/turf_fire/small/magical
	interact_with_atmos = FALSE
	passive_loss = FALSE
	color = COLOR_SPRING_GREEN

/obj/turf_fire/inferno
	fire_power = 30

/obj/turf_fire/inferno/magical
	interact_with_atmos = FALSE
	passive_loss = FALSE
	color = COLOR_VIOLET

/obj/turf_fire/Initialize(mapload, power, fire_color)
	. = ..()
	var/turf/open_turf = loc
	if(open_turf.turf_fire)
		return INITIALIZE_HINT_QDEL

	if(fire_color && ((color != fire_color) && isnull(color))) //Take colour from proc unless base colour was already custom
		color = fire_color
	if(color != null)
		set_color(color)

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)

	AddElement(/datum/element/connect_loc, loc_connections)

	open_turf.turf_fire = src
	SSturf_fire.fires += src
	if(power)
		fire_power = min(TURF_FIRE_MAX_POWER, power)
	UpdateFireState()

/obj/turf_fire/Destroy()
	var/turf/T = loc
	T.turf_fire = null
	SSturf_fire.fires -= src
	return ..()

//Approximates colour. It will not change value or saturation, just hue.
/obj/turf_fire/proc/set_color(_color)
	light_color = _color
	var/base = rgb2num(COLOR_ORANGE, COLORSPACE_HSV) //Base sprite is red fire, but maybe other fires want to be different
	var/target =  rgb2num(_color, COLORSPACE_HSV)
	var/baseAngle  = base[1]
	var/targetAngle= target[1]

	var/angle = (targetAngle - baseAngle)
	filters = filter(type = "color", color = list(1,0,0,0,
													  0,1,0,0,
													  0,0,1,0,
													  0,0,0,1,
													  angle/360,0,0,0), space = FILTER_COLOR_HSV)
	color = null //The actual colour should remain white so transform makes sense

/obj/turf_fire/proc/process_waste()
	var/total_oxidizer = 0
	var/turf/T = loc
	var/datum/gas_mixture/env = T.return_air()
	for (var/g in env.gas)
		if(gas_data.flags[g] & XGM_GAS_OXIDIZER)
			total_oxidizer += env.gas[g]
	if (total_oxidizer < TURF_FIRE_BURN_MINIMUM_OXYGEN_REQUIRED)
		return FALSE
	var/burn_rate = TURF_FIRE_BURN_RATE_BASE + fire_power * TURF_FIRE_BURN_RATE_PER_POWER
	if(burn_rate > total_oxidizer)
		burn_rate = total_oxidizer

	env.remove_by_flag(XGM_GAS_OXIDIZER, burn_rate)

	env.adjust_gas(GAS_CO2, burn_rate)

	var/energy_released = burn_rate * TURF_FIRE_ENERGY_PER_BURNED_OXY_MOL
	env.add_thermal_energy(energy_released)
	SSair.mark_for_update(T)
	return TRUE

/obj/turf_fire/process(seconds_per_tick)
	var/turf/simulated/T = get_turf(src)
	if(!T || T.density)
		qdel(src)
		return
	if(T.hotspot) //If we have an active hotspot, let it do the damage instead and lets not loose power
		return
	if(interact_with_atmos)
		if(!process_waste())
			qdel(src)
			return
	if(passive_loss)
		if(T.air?.temperature < TURF_FIRE_REQUIRED_TEMP)
			fire_power -= TURF_FIRE_POWER_LOSS_ON_LOW_TEMP
		fire_power--
		if(fire_power <= 0)
			qdel(src)
			return
	var/effective_temperature = TURF_FIRE_TEMP_BASE + (TURF_FIRE_TEMP_INCREMENT_PER_POWER*fire_power)
	T.hotspot_expose( effective_temperature)
	//Nearby turfs may also trigger a fire (will only start fires if there's fuel, currently)
	//Guaranteed fire spread in the last tick
	if(prob(50 + fire_power) || fire_power == 1)
		for(var/direction in GLOB.cardinals)
			var/turf/simulated/other_tile = get_step(T, direction)

			if(istype(other_tile))
				if(T.open_directions & direction) //Grab all valid bordering tiles
					if(other_tile.hotspot || other_tile.turf_fire)
						continue
					other_tile.hotspot_expose( effective_temperature)

	for(var/atom/movable/burning_atom as anything in T)
		burning_atom.fire_act(exposed_temperature = effective_temperature, exposed_volume = TURF_FIRE_VOLUME)
	if(interact_with_atmos)
		if(prob(fire_power) && istype(T, /turf/simulated/floor))
			var/turf/simulated/floor/F = T
			F.burn_tile(effective_temperature)
		UpdateFireState()

/obj/turf_fire/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	var/turf/T = loc
	if(T.hotspot) //If we have an active hotspot, let it do the damage instead
		return
	if(istype(arrived))
		arrived.fire_act(exposed_temperature = TURF_FIRE_TEMP_BASE + (TURF_FIRE_TEMP_INCREMENT_PER_POWER*fire_power), exposed_volume = TURF_FIRE_VOLUME)
	return

/obj/turf_fire/proc/AddPower(power)
	fire_power = min(TURF_FIRE_MAX_POWER, fire_power + power)
	UpdateFireState()

/obj/turf_fire/proc/UpdateFireState()
	var/new_state
	switch(fire_power)
		if(0 to 10)
			new_state = TURF_FIRE_STATE_SMALL
		if(11 to 24)
			new_state = TURF_FIRE_STATE_MEDIUM
		if(25 to 39)
			new_state = TURF_FIRE_STATE_LARGE
		if(40 to INFINITY)
			new_state = TURF_FIRE_STATE_MAX

	if(new_state == current_fire_state)
		return
	current_fire_state = new_state

	switch(current_fire_state)
		if(TURF_FIRE_STATE_SMALL)
			icon_state = "small"
			set_light(1.5, 0.5)
		if(TURF_FIRE_STATE_MEDIUM)
			icon_state = "medium"
			set_light(2, 0.5)
		if(TURF_FIRE_STATE_LARGE)
			icon_state = "big"
			set_light(2, 0.6)
		if(TURF_FIRE_STATE_MAX)
			icon_state = "max"
			set_light(3, 0.7)

#undef TURF_FIRE_REQUIRED_TEMP
#undef TURF_FIRE_TEMP_BASE
#undef TURF_FIRE_POWER_LOSS_ON_LOW_TEMP
#undef TURF_FIRE_TEMP_INCREMENT_PER_POWER
#undef TURF_FIRE_VOLUME
#undef TURF_FIRE_MAX_POWER

#undef TURF_FIRE_ENERGY_PER_BURNED_OXY_MOL
#undef TURF_FIRE_BURN_RATE_BASE
#undef TURF_FIRE_BURN_RATE_PER_POWER
#undef TURF_FIRE_BURN_MINIMUM_OXYGEN_REQUIRED
#undef TURF_FIRE_BURN_PLAY_SOUND_EFFECT_CHANCE

#undef TURF_FIRE_STATE_SMALL
#undef TURF_FIRE_STATE_MEDIUM
#undef TURF_FIRE_STATE_LARGE
#undef TURF_FIRE_STATE_MAX
