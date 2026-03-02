/*

Making Bombs with ZAS:
Get gas to react in an air tank so that it gains pressure. If it gains enough pressure, it goes boom.
The more pressure, the more boom.
If it gains pressure too slowly, it may leak or just rupture instead of exploding.
*/

#define FIRE_LIGHT_1	2 //These defines are the power of the light given off by fire at various stages
#define FIRE_LIGHT_2	4
#define FIRE_LIGHT_3	5

//The absolute minimum temperature, below which a fire will go out. In Kelvins
#define MINIMUM_HEAT_THRESHOLD 220

/turf

//Some legacy definitions so fires can be started.
/atom/proc/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return null


/turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = 0)
	return

/**
 * Create a temporary ignition source at turf. Think sparks/igniters.
 *
 * Checks for flammable materials at its location.
 *
 * * exposed_temperature - ignition source temp (K)
 * * exposed_volume - gas volume (passed to fire_act() for locs)
 *
 * Returns boolean and/or executes create_fire(exposed_temperature).
 */
/turf/simulated/hotspot_expose(exposed_temperature, exposed_volume)
	if(fire_protection > world.time-300)
		return FALSE
	if(locate(/obj/hotspot) in src)
		return TRUE
	var/datum/gas_mixture/air_contents = return_air()
	if(!air_contents || exposed_temperature < PHORON_MINIMUM_BURN_TEMPERATURE)
		return FALSE

	var/igniting = FALSE
	var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in src
	var/is_cmb = liquid ? CMB_LIQUID_FUEL : 0
	CHECK_COMBUSTIBLE(is_cmb, air_contents)
	if(liquid && is_cmb)
		IgniteTurf(liquid.amount * 10)
		QDEL_NULL(liquid)

	var/obj/effect/decal/cleanable/napalm/napalm = locate() in src
	if(napalm)
		napalm.Ignite()

	if(is_cmb)
		igniting = TRUE
		create_fire(exposed_temperature)

	return igniting

/zone/proc/process_fire()
	var/datum/gas_mixture/burn_gas = air.remove_ratio(GLOB.vsc.fire_consuption_rate, LAZYLEN(fire_tiles))

	var/firelevel = burn_gas.react(src, fire_tiles, force_burn = TRUE, no_check = TRUE)

	air.merge(burn_gas)

	if(firelevel)
		for(var/turf/T in fire_tiles)
			if(T.hotspot)
				T.hotspot.firelevel = firelevel
			else
				LAZYREMOVE(fire_tiles, T)
	else
		for(var/turf/simulated/T in fire_tiles)
			if(istype(T.hotspot))
				qdel(T.hotspot)
		LAZYCLEARLIST(fire_tiles)
		UNSETEMPTY(fire_tiles)

	if(!LAZYLEN(fire_tiles))
		SSair.active_fire_zones.Remove(src)

/turf/proc/create_fire(fl)
	return FALSE

/turf/simulated/create_fire(fl)

	if(hotspot)
		hotspot.firelevel = max(fl, hotspot.firelevel)
		return TRUE

	if(!zone)
		return TRUE

	hotspot = new(src, fl)
	SSair.active_fire_zones |= zone

	var/obj/effect/decal/cleanable/foam/extinguisher_foam = locate() in src
	if(extinguisher_foam && extinguisher_foam.reagents)
		hotspot.firelevel *= max(0,1 - (extinguisher_foam.reagents.total_volume*0.04))
		//25 units will eliminate the fire completely

	LAZYOR(zone.fire_tiles, src)

	return FALSE

// Future low-quality heat effect
/obj/heat
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	appearance_flags = PIXEL_SCALE | NO_CLIENT_COLOR
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	render_target = HEAT_EFFECT_PLATE_RENDER_TARGET

/obj/hotspot
	//Icon for fire on turfs.
	//Different from turf fires
	anchored = 1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	blend_mode = BLEND_ADD

	icon = 'icons/effects/fire.dmi'
	icon_state = "wavey_fire"
	light_color = LIGHT_COLOR_FIRE
	layer = FIRE_LAYER

	var/firelevel = 1 //Calculated by gas_mixture.calculate_firelevel()

/obj/hotspot/process()
	. = 1

	var/turf/simulated/my_tile = loc
	if(!istype(my_tile) || !my_tile.zone)
		if(my_tile && my_tile.hotspot == src)
			my_tile.hotspot = null
		qdel(src)
		return PROCESS_KILL

	var/datum/gas_mixture/air_contents = my_tile.return_air()

	if(firelevel > 6)
		set_light(9, FIRE_LIGHT_3)	// We set color later in the proc, that should trigger an update.
	else if(firelevel > 2.5)
		set_light(7, FIRE_LIGHT_2)
	else
		set_light(5, FIRE_LIGHT_1)

	loc.fire_act(air_contents.temperature, air_contents.volume)
	for(var/atom/A in loc)
		var/mob/living/L = astype(A)
		L?.FireBurn(firelevel, air_contents.temperature, XGM_PRESSURE(air_contents))
		A.fire_act(air_contents.temperature, air_contents.volume)

	//spread
	for(var/direction in GLOB.cardinals)
		var/turf/simulated/enemy_tile = get_step(my_tile, direction)

		if(istype(enemy_tile))
			if(my_tile.open_directions & direction) //Grab all valid bordering tiles
				if(!enemy_tile.zone || enemy_tile.hotspot)
					continue

				//if(!enemy_tile.zone.fire_tiles.len) TODO - optimize
				var/datum/gas_mixture/acs = enemy_tile.return_air()
				if(!acs)
					continue

				var/is_cmb = 0
				CHECK_COMBUSTIBLE(is_cmb, acs)

				if(!is_cmb)
					continue

				//If extinguisher mist passed over the turf it's trying to spread to, don't spread and
				//reduce firelevel.
				if(enemy_tile.fire_protection > world.time-30)
					firelevel -= 1.5
					continue

				//Spread the fire.
				if(prob( 50 + 50 * (firelevel/GLOB.vsc.fire_firelevel_multiplier) ) && my_tile.CanPass(null, enemy_tile, 0,0) && enemy_tile.CanPass(null, my_tile, 0,0))
					enemy_tile.create_fire(firelevel)

			else
				enemy_tile.adjacent_fire_act(loc, air_contents, air_contents.temperature, air_contents.volume)

	set_light(l_color = fire_color(air_contents.temperature, TRUE))
	var/list/animate_targets = get_above_oo() + src
	for (var/thing in animate_targets)
		var/atom/movable/AM = thing
		animate(AM, color = fire_color(air_contents.temperature), 5)

/obj/hotspot/Initialize(mapload, fl)
	. = ..()

	if(!isturf(loc))
		return INITIALIZE_HINT_QDEL

	set_dir(pick(GLOB.cardinals))

	var/datum/gas_mixture/air_contents = loc.return_air()
	color = fire_color(air_contents.temperature)
	set_light(3, 1, color)

	firelevel = fl
	SSair.active_hotspots.Add(src)

	//If this is a turf and it can burn maybe it should be ignited too - Lingering fire effect of sorts
	var/turf/simulated/floor/F = loc
	if(istype(F) && F.flooring && F.flooring.flags & TURF_CAN_BURN)
		if(prob(30))
			F.IgniteTurf(rand(8,22))

/obj/hotspot/proc/fire_color(var/env_temperature)
	var/temperature = max(4000*sqrt(firelevel/GLOB.vsc.fire_firelevel_multiplier), env_temperature)
	return heat2color(temperature)

/obj/hotspot/Destroy()
	var/turf/T = loc
	if (istype(T))
		set_light(0)
		T.hotspot = null
	SSair.active_hotspots.Remove(src)
	. = ..()

/turf/simulated
	var/tmp/fire_protection = 0 //Protects newly extinguished tiles from being overrun again.

/turf/proc/apply_fire_protection()
	return

/turf/simulated/apply_fire_protection()
	fire_protection = world.time

//Returns the firelevel
/datum/gas_mixture/proc/react(zone/zone, force_burn, no_check = 0)
	. = 0
	var/is_cmb = no_check ? TRUE : 0
	if(!is_cmb)
		CHECK_COMBUSTIBLE(is_cmb, src)
	if((temperature > PHORON_MINIMUM_BURN_TEMPERATURE || force_burn) && is_cmb)

		#ifdef ZASDBG
		log_subsystem_zas_debug("***************** FIREDBG *****************")
		log_subsystem_zas_debug("Burning [zone? zone.name : "zoneless gas_mixture"]!")
		#endif

		var/gas_fuel = 0
		var/total_fuel = 0
		var/total_oxidizers = 0

		//*** Get the fuel and oxidizer amounts
		for(var/g in gas)
			if(gas_data.flags[g] & XGM_GAS_FUEL)
				gas_fuel += gas[g]
			if(gas_data.flags[g] & XGM_GAS_OXIDIZER)
				total_oxidizers += gas[g]
		gas_fuel *= group_multiplier
		total_oxidizers *= group_multiplier

		total_fuel = gas_fuel
		if(total_fuel <= 0.005)
			return 0

		//*** Determine how fast the fire burns

		//get the current thermal energy of the gas mix
		//this must be taken here to prevent the addition or deletion of energy by a changing heat capacity
		var/starting_energy = temperature * heat_capacity()

		//determine how far the reaction can progress
		var/reaction_limit = min(total_oxidizers*(FIRE_REACTION_FUEL_AMOUNT/FIRE_REACTION_OXIDIZER_AMOUNT), total_fuel) //stoichiometric limit

		//vapour fuels are extremely volatile! The reaction progress is a percentage of the total fuel (similar to old zburn).)
		var/gas_firelevel = calculate_firelevel(gas_fuel, total_oxidizers, reaction_limit, volume*group_multiplier) / GLOB.vsc.fire_firelevel_multiplier
		var/min_burn = 0.30*volume*group_multiplier/CELL_VOLUME //in moles - so that fires with very small gas concentrations burn out fast
		var/gas_reaction_progress = min(max(min_burn, gas_firelevel*gas_fuel)*FIRE_GAS_BURNRATE_MULT, gas_fuel)

		var/firelevel = (gas_fuel*gas_firelevel)/total_fuel

		var/total_reaction_progress = gas_reaction_progress
		var/used_fuel = min(total_reaction_progress, reaction_limit)
		var/used_oxidizers = used_fuel*(FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT)

		#ifdef ZASDBG
		log_subsystem_zas_debug("gas_fuel = [gas_fuel], total_oxidizers = [total_oxidizers]")
		log_subsystem_zas_debug("total_fuel = [total_fuel], reaction_limit = [reaction_limit]")
		log_subsystem_zas_debug("firelevel -> [firelevel] (gas: [gas_firelevel])")
		log_subsystem_zas_debug("gas_reaction_progress = [gas_reaction_progress]")
		log_subsystem_zas_debug("total_reaction_progress = [total_reaction_progress]")
		log_subsystem_zas_debug("used_fuel = [used_fuel], used_oxidizers = [used_oxidizers]; ")
		#endif

		//if the reaction is progressing too slow then it isn't self-sustaining anymore and burns out
		if(zone) //be less restrictive with canister and tank reactions
			if((!gas_fuel || used_fuel <= FIRE_GAS_MIN_BURNRATE*length(zone.contents)))
				return 0


		//*** Remove fuel and oxidizer, add carbon dioxide and heat

		//remove and add gasses as calculated
		var/used_gas_fuel = min(max(0.25, used_fuel*(gas_reaction_progress/total_reaction_progress)), gas_fuel) //remove in proportion to the relative reaction progress

		//remove_by_flag() and adjust_gas() handle the group_multiplier for us.
		remove_by_flag(XGM_GAS_OXIDIZER, used_oxidizers)
		remove_by_flag(XGM_GAS_FUEL, used_gas_fuel)
		adjust_gas(GAS_CO2, used_oxidizers)

		//calculate the energy produced by the reaction and then set the new temperature of the mix
		temperature = (starting_energy + GLOB.vsc.fire_fuel_energy_release * (used_gas_fuel)) / heat_capacity()
		total_moles = 0
		for(var/g in gas)
			if(gas[g] <= 0)
				gas -= g
			else
				total_moles += gas[g]

		#ifdef ZASDBG
		log_subsystem_zas_debug("used_gas_fuel = [used_gas_fuel]; total = [used_fuel]")
		log_subsystem_zas_debug("new temperature = [temperature]; new pressure = [XGM_PRESSURE(src)]")
		#endif

		if (temperature < MINIMUM_HEAT_THRESHOLD)
			firelevel = 0

		return firelevel

/datum/gas_mixture/proc/check_recombustability(list/fuel_objs)
	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_OXIDIZER && gas[g] >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(fuel_objs && length(fuel_objs))
		return 1

	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_FUEL && gas[g] >= 0.1)
			. = 1
			break

//returns a value between 0 and vsc.fire_firelevel_multiplier
/datum/gas_mixture/proc/calculate_firelevel(total_fuel, total_oxidizers, reaction_limit, gas_volume)
	//Calculates the firelevel based on one equation instead of having to do this multiple times in different areas.
	var/firelevel = 0

	var/total_combustables = (total_fuel + total_oxidizers)
	var/active_combustables = (FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT + 1)*reaction_limit

	if(total_combustables > 0)
		//slows down the burning when the concentration of the reactants is low
		var/damping_multiplier
		if(!total_moles || !group_multiplier)
			damping_multiplier = min(1, active_combustables)
		else if(!total_moles)
			damping_multiplier = min(1, active_combustables / group_multiplier)
		else if(!group_multiplier)
			damping_multiplier = min(1, active_combustables / total_moles)
		else
			damping_multiplier = min(1, active_combustables / (total_moles/group_multiplier))

		//weight the damping mult so that it only really brings down the firelevel when the ratio is closer to 0
		damping_multiplier = 2*damping_multiplier - (damping_multiplier*damping_multiplier)

		//calculates how close the mixture of the reactants is to the optimum
		//fires burn better when there is more oxidizer -- too much fuel will choke the fire out a bit, reducing firelevel.
		var/mix_multiplier = 1 / (1 + (5 * ((total_fuel / total_combustables) ** 2)))

		#ifdef ZASDBG
		ASSERT(damping_multiplier <= 1)
		ASSERT(mix_multiplier <= 1)
		#endif

		//toss everything together -- should produce a value between 0 and fire_firelevel_multiplier
		firelevel = GLOB.vsc.fire_firelevel_multiplier * mix_multiplier * damping_multiplier

	return max( 0, firelevel)


/mob/living/proc/FireBurn(firelevel, last_temperature, pressure)
	var/mx = 5 * firelevel/GLOB.vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)
	apply_damage(2.5*mx, DAMAGE_BURN)

/**
 * Applies direct damage to human mobs to fire.
 * On the chopping block depending on how we feel.
 * We can decide its fate in future reworks.
 */
/mob/living/carbon/human/FireBurn(firelevel, last_temperature, pressure)
	//Burns mobs due to fire. Respects heat transfer coefficients on various body parts.
	//Due to TG reworking how fireprotection works, this is kinda less meaningful.

	var/head_exposure = 1
	var/chest_exposure = 1
	var/groin_exposure = 1
	var/legs_exposure = 1
	var/arms_exposure = 1

	//Get heat transfer coefficients for clothing.

	for(var/obj/item/clothing/C in src)
		if(l_hand == C || r_hand == C)
			continue

		if( C.max_heat_protection_temperature >= last_temperature )
			if(C.body_parts_covered & HEAD)
				head_exposure = 0
			if(C.body_parts_covered & UPPER_TORSO)
				chest_exposure = 0
			if(C.body_parts_covered & LOWER_TORSO)
				groin_exposure = 0
			if(C.body_parts_covered & LEGS)
				legs_exposure = 0
			if(C.body_parts_covered & ARMS)
				arms_exposure = 0
	//minimize this for low-pressure enviroments
	var/mx = 5 * firelevel/GLOB.vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)

	//Always check these damage procs first if fire damage isn't working. They're probably what's wrong.

	apply_damage(2.5*mx*head_exposure, DAMAGE_BURN, BP_HEAD, used_weapon = "Fire")
	apply_damage(2.5*mx*chest_exposure, DAMAGE_BURN, BP_CHEST, used_weapon = "Fire")
	apply_damage(2.0*mx*groin_exposure, DAMAGE_BURN, BP_GROIN, used_weapon =  "Fire")
	apply_damage(0.6*mx*legs_exposure, DAMAGE_BURN, BP_L_LEG, used_weapon = "Fire")
	apply_damage(0.6*mx*legs_exposure, DAMAGE_BURN, BP_R_LEG, used_weapon = "Fire")
	apply_damage(0.4*mx*arms_exposure, DAMAGE_BURN, BP_L_ARM, used_weapon = "Fire")
	apply_damage(0.4*mx*arms_exposure, DAMAGE_BURN, BP_R_ARM, used_weapon = "Fire")

#undef FIRE_LIGHT_1
#undef FIRE_LIGHT_2
#undef FIRE_LIGHT_3

#undef MINIMUM_HEAT_THRESHOLD
