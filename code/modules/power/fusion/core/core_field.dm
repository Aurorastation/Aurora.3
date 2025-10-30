#define FUSION_INSTABILITY_DIVISOR		100000
#define FUSION_RUPTURE_THRESHOLD		25000
#define FUSION_REACTANT_CAP				10000
#define FUSION_WARNING_DELAY 			20
#define FUSION_BLACKBODY_MULTIPLIER		350
#define FUSION_INTEGRITY_RATE_LIMIT		0.11
#define FUSION_TICK_MAX_TEMP_CHANGE		0.3

/obj/effect/fusion_em_field
	name = "electromagnetic field"
	desc = "A coruscating, barely visible field of energy. It is shaped like a slightly flattened torus."
	alpha = 30
	layer = ABOVE_ABOVE_HUMAN_LAYER
	light_color = COLOR_RED
	mouse_opacity = MOUSE_OPACITY_ICON

	/// Temporary pool for energy being added to the field from a Gyrotron.
	var/energy = 0
	/// Actual core field energy (temperature).
	var/plasma_temperature = 0
	/// Effective core field energy (temperature) as modified by field magnitude constriction or relaxation.
	// var/plasma_temperature_effective
	/// Current excess radiation from ongoing reactions.
	var/radiation = 0
	/// Radiation of the previous three ticks averaged out (if != 0).
	var/radiation_avg = 0
	/// Archived radiation. Used for averaging out new SSradiation.radiate() source creation.
	var/radiation_archive_1 = 0
	var/radiation_archive_2 = 0
	var/radiation_archive_3 = 0
	var/radiation_archive_4 = 0
	var/radiation_archive_5 = 0
	/**
	 * The currently configured Field Strength (0.2 = 20 Tesla). Capped by TGUI at 1.2 (120 Tesla).
	 *
	 * Field Strength scales plasma temperature entropy. With higher field strength, each tick will lose more temp and produce more radiation.
	 * Field Strength scales power output per temperature. With higher field strength, each degree Kelvin will produce more electricity.
	 * Field Strength scales instability increase. With higher field strength, more instability for a given reaction will be produced each tick.
	 */
	var/field_strength = 20
	/// Current field strength multiplier applied to entropy.
	var/field_strength_entropy_multiplier = 1.0
	/// Current field strength multiplier applied to instability.
	var/field_strength_instability_multiplier = 1.0
	/// Current field strength multiplier applied to power output.
	var/field_strength_power_multiplier = 1.0
	/// Radius of the EM field. Scales with Field Strength.
	var/size = 1

	/// Instability generated on this current tick.
	var/tick_instability = 0
	/// Ranges from 0-1. At or over 1, boom.
	var/percent_unstable = 0
	var/percent_unstable_archive = 0

	var/obj/machinery/power/fusion_core/owned_core
	var/list/reactants = list()
	var/list/particle_catchers = list()

	var/list/ignore_types = list(
		/obj/projectile,
		/obj/effect,
		/obj/structure/cable,
		/obj/machinery/atmospherics,
		/obj/machinery/air_sensor,
		/obj/machinery/camera
		)

	var/light_min_range = 2
	var/light_min_power = 0.2
	var/light_max_range = 24
	var/light_max_power = 1

	var/last_range
	var/last_power

	var/last_reactants = 0

	particles = new/particles/fusion

	var/animating_ripple = FALSE

	var/obj/item/device/radio/radio
	var/safe_alert = "NOTICE: INDRA reactor stabilizing."
	var/safe_warned = FALSE
	var/public_alert = FALSE
	var/warning_alert = "WARNING: INDRA reactor destabilizing!"
	var/emergency_alert = "DANGER: INDRA REACTOR MELTDOWN IMMINENT!"
	var/lastwarning = 0

	/// Power output this tick. We average this like we do radiation for player-presenting data.
	var/power_output
	/// Power of the previous five ticks averaged out (if != 0).
	var/output_avg = 0
	/// Archived power. Used for averaging out the power dumped into the powernet for players to see.
	var/output_archive_1 = 0
	var/output_archive_2 = 0
	var/output_archive_3 = 0
	var/output_archive_4 = 0
	var/output_archive_5 = 0

	var/vfx_radius_actual
	//var/vfx_radius_visual
	var/pause_rupture = FALSE

	var/power_log_base = 1.35
	var/power_multiplier = 3.5
	var/power_power = 2.9

/obj/effect/fusion_em_field/proc/UpdateVisuals()
	//Take the particle system and edit it

	//size
	vfx_radius_actual = ((size-1) / 2) * WORLD_ICON_SIZE
	/*
	var/vfx_radius_next = ((size+1) / 2) * WORLD_ICON_SIZE
	var/percent_to_next_size = round(((field_strength + (size * 50)) - (size * 50)) / (((size + 1) / 2) * 50),0.01)
	var/radius_add = round(percent_to_next_size * WORLD_ICON_SIZE, 1)
	vfx_radius_visual = min(max(vfx_radius_actual + radius_add, vfx_radius_actual), vfx_radius_next)
	*/
	particles.position = generator("circle", vfx_radius_actual - size, vfx_radius_actual, NORMAL_RAND)

	//Radiation affects drift
	var/radiationfactor = clamp((radiation_avg * 0.001), 0, 0.75)
	particles.drift = generator("circle", (0.2 + radiationfactor), NORMAL_RAND)
	particles.spawning = last_reactants * 0.9 + Interpolate(0, 200, clamp(plasma_temperature / 70000, 0, 1))

/obj/effect/fusion_em_field/New(loc, obj/machinery/power/fusion_core/new_owned_core)
	..()

	filters = list(filter(type = "ripple", size = 4, "radius" = 1, "falloff" = 1)
	, filter(type="outline", size = 2, color =  COLOR_RED)
	, filter(type="bloom", size = 3, offset = 0.5, alpha = 235))

	set_light(light_min_power, light_min_range / 10, light_min_range)
	last_range = light_min_range
	last_power = light_min_power

	owned_core = new_owned_core
	if(!owned_core)
		qdel(src)
		return

	particles.spawning = 0 //Turn off particles until something calls for it

	// Create the gimmicky things to handle field collisions
	var/obj/effect/fusion_particle_catcher/catcher

	catcher = new (locate(src.x,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(1)
	particle_catchers.Add(catcher)

	for(var/iter=1,iter<=6,iter++)
		catcher = new (locate(src.x-iter,src.y,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

		catcher = new (locate(src.x+iter,src.y,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

		catcher = new (locate(src.x,src.y+iter,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

		catcher = new (locate(src.x,src.y-iter,src.z))
		catcher.parent = src
		catcher.SetSize((iter*2)+1)
		particle_catchers.Add(catcher)

	START_PROCESSING(SSprocessing, src)

/obj/effect/fusion_em_field/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(update_light_colors)), 10 SECONDS, TIMER_LOOP)
	radio = new /obj/item/device/radio{channels=list("Engineering")}(src)

/**
 * What are we doing every tick? A lot.
 * * Grab some gas from the env and convert it to reactants for the pool.
 * * Run react(), which updates a ton of vars for us to respond to here.
 * * Based on our updated heat values, dump power into the power net.
 * * Calculate what sort of entropy tax we're going to pay.
 * * Run check_instability() and decide how sad/angry we are.
 * * If we're sad/angry, try to send a warning.
 * * Run radiate(). This is us paying the entropy tax.
 */
/obj/effect/fusion_em_field/process()
	//make sure the field generator is still intact
	if(QDELETED(owned_core))
		qdel(src)
		return

	// Take some gas up from our environment.
	var/added_particles = FALSE
	var/datum/gas_mixture/uptake_gas = owned_core.loc.return_air()
	if(uptake_gas)
		uptake_gas = uptake_gas.remove_by_flag(XGM_GAS_FUSION_FUEL, rand(50,100))
	if(uptake_gas && uptake_gas.total_moles)
		for(var/gasname in uptake_gas.gas)
			if(uptake_gas.gas[gasname]*10 > reactants[gasname])
				AddParticles(gasname, uptake_gas.gas[gasname]*10)
				uptake_gas.adjust_gas(gasname, -(uptake_gas.gas[gasname]), update=FALSE)
				added_particles = TRUE
		if(added_particles)
			uptake_gas.update_values()

	// Let the particles inside the field react.
	React()

	field_strength_power_multiplier = max((owned_core.field_strength ** 1.2) / 100, 1)
	// Dump power to our powernet.
	power_output = ((log(power_log_base, plasma_temperature) * power_multiplier) ** power_power) * field_strength_power_multiplier
	output_archive_5 = output_archive_4
	output_archive_4 = output_archive_3
	output_archive_3 = output_archive_2
	output_archive_2 = output_archive_1
	output_archive_1 = power_output
	output_avg = ((output_archive_1 + output_archive_2 + output_archive_3 + output_archive_4 + output_archive_5 ) / 5)
	owned_core.add_avail(power_output)

	// Roundstart update
	if(field_strength < 20)
		field_strength = 20
	field_strength_entropy_multiplier = clamp((owned_core.field_strength ** 1.075) / 40, 0.8, 2.0)
	// Energy decay (entropy tax).
	if(plasma_temperature >= 1)
		var/lost = plasma_temperature * 0.00125
		radiation += lost
		var/temp_change = 0 - (lost * field_strength_entropy_multiplier)
		adjust_temperature(temp_change, cause = "Containment Entropy")

	// Handle some reactants formatting.
	for(var/reactant in reactants)
		var/amount = reactants[reactant]
		if(amount < 1)
			reactants.Remove(reactant)
		else if(amount >= FUSION_REACTANT_CAP)
			var/radiate = rand(amount / 16, 3 * amount / 16)
			reactants[reactant] -= radiate
			radiation += radiate

	check_instability()

	if(percent_unstable > 0.5 && (percent_unstable >= percent_unstable_archive))
		if((world.timeofday - lastwarning) >= FUSION_WARNING_DELAY * 10)
			warning()

	Radiate()
	return 1

/**
 * Handles checks for instability, does bad things if unstable. Instability
 * ranges from 0 to 1.
 *
 * Possible consequences:
 * * Field wobbles/ripples (visual only)
 * * Fuel loss (rad spikes)
 * * Flares (bigger rad spikes, bigger wobbles/ripples)
 * * Rupture (you're fucked, we done)
 *
 * If instability hits 1, boom. Otherwise, this code looks fucked up, best
 * document details later.
 */
/obj/effect/fusion_em_field/proc/check_instability()
	field_strength_instability_multiplier = max((owned_core.field_strength ** 1.1)/20, 1)
	if(tick_instability > 0)
		percent_unstable_archive = percent_unstable
		// Apply any modifiers to instability imparted by current field strength, but only apply up to FUSION_INTEGRITY_RATE_LIMIT additional instability.
		var/new_instability = min((tick_instability * field_strength_instability_multiplier)/FUSION_INSTABILITY_DIVISOR, FUSION_INTEGRITY_RATE_LIMIT)
		percent_unstable += new_instability
		tick_instability = 0
		UpdateVisuals()
	else
		if(percent_unstable < 0)
			percent_unstable = 0
		else
			if(percent_unstable > 1)
				percent_unstable = 1
			if(percent_unstable > 0)
				percent_unstable = max(0, percent_unstable-rand(0.02,0.08))
				UpdateVisuals()

	if(percent_unstable >= 1)
		owned_core.Shutdown(force_rupture=1)
	else
		if(percent_unstable > 0.5 && prob(percent_unstable*100))
			var/ripple_radius = ((size-1) / 2) + WORLD_ICON_SIZE
			var/wave_size = 4
			if(plasma_temperature < FUSION_RUPTURE_THRESHOLD)
				visible_message(SPAN_DANGER("\The [src] ripples uneasily, like a disturbed pond."))
			else
				var/flare
				var/fuel_loss
				var/rupture
				// Why the fuck are these less thans???
				if(percent_unstable < 0.7)
					visible_message(SPAN_DANGER("\The [src] ripples uneasily, like a disturbed pond."))
					fuel_loss = prob(5)
				else if(percent_unstable < 0.9)
					visible_message(SPAN_DANGER("\The [src] undulates violently, shedding plumes of plasma!"))
					flare = prob(50)
					fuel_loss = prob(20)
					rupture = prob(5)
					wave_size += 2
				else
					visible_message(SPAN_DANGER("\The [src] is wracked by a series of horrendous distortions, buckling and twisting like a living thing!"))
					flare = 1
					fuel_loss = prob(50)
					rupture = prob(25)
					wave_size += 4

				if(rupture && !pause_rupture)
					owned_core.Shutdown(force_rupture=1)
				else
					var/lost_plasma = (plasma_temperature*percent_unstable)
					radiation += lost_plasma
					if(flare)
						radiation += plasma_temperature/2
						wave_size += 6
					var/temp_change = 0 - lost_plasma
					adjust_temperature(temp_change, cause = "Instability Bleed-off")

					if(fuel_loss)
						for(var/particle in reactants)
							var/lost_fuel = reactants[particle]*percent_unstable
							radiation += lost_fuel
							reactants[particle] -= lost_fuel
							if(reactants[particle] <= 0)
								reactants.Remove(particle)
					Radiate()
			Ripple(wave_size, ripple_radius)
	return

/obj/effect/fusion_em_field/proc/warning()
	var/unstable = round(percent_unstable * 100)
	var/alert_msg = " Instability at [unstable]%."

	if(percent_unstable > 0.5)
		if(percent_unstable >= percent_unstable_archive)
			if(percent_unstable < 0.7)
				alert_msg = warning_alert + alert_msg
				lastwarning = world.timeofday
				safe_warned = FALSE
			else if(percent_unstable < 0.9)
				alert_msg = emergency_alert + alert_msg
				lastwarning = world.timeofday - FUSION_WARNING_DELAY * 4
			else if(percent_unstable > 0.9)
				lastwarning = world.timeofday - FUSION_WARNING_DELAY * 4
				alert_msg = emergency_alert + alert_msg
			else
				alert_msg = null
		else if(!safe_warned)
			safe_warned = TRUE
			alert_msg = safe_alert
			lastwarning = world.timeofday
		else
			alert_msg = null
	else
		alert_msg = null
	if(alert_msg)
		radio.autosay(alert_msg, "INDRA Reactor Monitor", "Engineering")

		if((percent_unstable > 0.9) && !public_alert)
			alert_msg = null
			radio.autosay(emergency_alert, "INDRA Reactor Monitor")
			public_alert = TRUE
			for(var/mob/M in GLOB.player_list)
				var/turf/T = get_turf(M)
				if(T && !istype(M, /mob/abstract/new_player) && !isdeaf(M))
					sound_to(M, 'sound/effects/nuclearsiren.ogg')
		else if(safe_warned && public_alert)
			radio.autosay(alert_msg, "INDRA Reactor Monitor")
			public_alert = FALSE

/**
 *	Handles visual animation.
 */
/obj/effect/fusion_em_field/proc/Ripple(_size, _radius)
	if(!animating_ripple)
		UNLINT(var/dm_filter/ripple = filters[1])
		UNLINT(ripple.size = _size)
		animate(filters[1], time = 0, loop = 1, radius = 0, flags=ANIMATION_PARALLEL)
		animate(time = 2 SECONDS, radius = _radius)
		animating_ripple = TRUE
		addtimer(CALLBACK(src, PROC_REF(ResetRipple)), 2 SECONDS, TIMER_CLIENT_TIME)

/obj/effect/fusion_em_field/proc/ResetRipple()
	animating_ripple = FALSE

/obj/effect/fusion_em_field/proc/is_shutdown_safe()
	return plasma_temperature < 1000

/**
 * EMP, rads, and a big fuckoff explosion.
 */
/obj/effect/fusion_em_field/proc/Rupture()
	if(pause_rupture)
		return
	visible_message(SPAN_DANGER("\The [src] convulses violently as gouts of plasma spill forth!"))
	set_light(1, 0.1, "#ccccff", 15, 2)
	empulse(get_turf(src), Ceil(plasma_temperature/1000000), Ceil(plasma_temperature/300000))
	RadiateAll()
	addtimer(CALLBACK(src, PROC_REF(RuptureExplosion)), 45 SECONDS)

/obj/effect/fusion_em_field/proc/RuptureExplosion()
	visible_message(SPAN_DANGER("\The [src] shudders like a dying animal before flaring to eye-searing brightness and rupturing!"))
	explosion(get_turf(owned_core), 6, 8)

/**
 * Sets field strength in Tesla, and corresponding field size.
 * This currently does nothing mechanically, and the UI locks us to 100 max strength anyway.
 */
/obj/effect/fusion_em_field/proc/ChangeFieldStrength(new_strength)
	var/calc_size = 1
	if(new_strength < 40)
		calc_size = 1
	else if(new_strength < 80)
		calc_size = 3
	// Right now the max value allowed by the interface is 120. Change this from 121->120 if we want to allow bigger reactors.
	else if(new_strength < 121)
		calc_size = 5
	else if(new_strength < 160)
		calc_size = 7
	else if(new_strength < 200)
		calc_size = 9
	else if(new_strength < 240)
		calc_size = 11
	else
		calc_size = 13
	field_strength = new_strength
	change_size(calc_size)

/obj/effect/fusion_em_field/proc/AddEnergy(a_energy, a_plasma_temperature)
	// Boost gyro effects at low temperatures for faster startup
	if(plasma_temperature <= 5000)
		a_energy = a_energy * 32
	else if(plasma_temperature <= 75000)
		a_energy = a_energy * 8
	energy += a_energy / 2

	plasma_temperature += a_plasma_temperature

	if(a_energy && percent_unstable > 0)
		percent_unstable = max(percent_unstable - (a_energy/10000), 0)
	while(energy >= 100)
		energy -= 100
		plasma_temperature += 1
	UpdateVisuals()

/obj/effect/fusion_em_field/proc/AddParticles(name, quantity = 1)
	if(name in reactants)
		reactants[name] += quantity
	else if(name != "proton" && name != "electron" && name != "neutron")
		reactants.Add(name)
		reactants[name] = quantity
	UpdateVisuals()

/**
 * Create our plasma field and dump it into our environment.
 */
/obj/effect/fusion_em_field/proc/RadiateAll(ratio_lost = 1)
	var/turf/T = get_turf(src)
	if(istype(T))
		var/datum/gas_mixture/plasma
		for(var/reactant in reactants)
			if(!gas_data.name[reactant])
				continue
			if(!plasma)
				plasma = new
			// *0.1 to compensate for *10 when uptaking gas.
			plasma.adjust_gas(reactant, max(1,round(reactants[reactant]*0.1)), 0)
		if(!plasma)
			return
		plasma.temperature = (plasma_temperature/2)
		plasma.update_values()
		T.assume_air(plasma)
		T.hotspot_expose(plasma_temperature)
		plasma = null

	// Radiate all our unspent fuel and energy.
	for(var/particle in reactants)
		radiation += reactants[particle]
		reactants.Remove(particle)
	radiation += plasma_temperature/8
	plasma_temperature = 0

	SSradiation.radiate(src, radiation)
	Radiate()

/**
 * Called as part of our regular Process()
 *
 * First, it checks if our current size is intersecting with any
 * offending objects. If it is... Well, it won't be for long, since it'll
 * probably blow up the entire reactor in about 5 seconds.
 *
 * After that, it'll return the air it stole this tick, just heated up.
 * The max temperature is capped so it can't be used for TEGs or shit.
 */
/obj/effect/fusion_em_field/proc/Radiate(safe = TRUE)
	if(istype(loc, /turf))
		for(var/atom/movable/AM in range(max(1,FLOOR(size/2, 1)), loc))

			if(AM == src || AM == owned_core || !AM.simulated)
				continue

			var/skip_obstacle
			for(var/ignore_path in ignore_types)
				if(istype(AM, ignore_path))
					skip_obstacle = TRUE
					break
			if(skip_obstacle)
				continue

			AM.visible_message(SPAN_DANGER("The field buckles visibly around \the [AM]!"))
			tick_instability += rand(10,25)
			AM.emp_act(EMP_LIGHT)

	if(owned_core && owned_core.loc)
		var/datum/gas_mixture/environment = owned_core.loc.return_air()
		// Putting an upper bound on it to stop it being used in a TEG.
		if(environment && environment.temperature < (T0C+1000))
			environment.add_thermal_energy(plasma_temperature*20000)

	// Radiation levels can spike unpredictably based on how many reagents we're throwing out, which reactions ran this cycle, etc.
	// And while we like some unpredictability, it gets a little excessive with the INDRA. Use these vars to balance out actual rad output.
	radiation_archive_5 = radiation_archive_4
	radiation_archive_4 = radiation_archive_3
	radiation_archive_3 = radiation_archive_2
	radiation_archive_2 = radiation_archive_1
	radiation_archive_1 = radiation

	if(radiation >= 1000)
		radiation_avg = ((radiation_archive_1 + radiation_archive_2 + radiation_archive_3 + radiation_archive_4 + radiation_archive_5 ) / 5)
		SSradiation.radiate(src, radiation_avg * 0.01)

	radiation = 0

/obj/effect/fusion_em_field/proc/change_size(newsize = 1)
	var/changed = 0
	if( ((newsize-1)%2==0) && (newsize<=13) )
		size = newsize
		changed = newsize
		UpdateVisuals()

	for(var/obj/effect/fusion_particle_catcher/catcher in particle_catchers)
		catcher.UpdateSize()
	return changed

/**
 * The !!fun!! part.
 *
 * Read through the whole code for actual details please, but TLDR:
 * * Maximum of 10000 reactants present in the pool at a given time.
 * * A random number of reactants are chosen to react in a given cycle.
 * * Reactions follow a priority list- IE deut+trit before deut+deut.
 * *
 */
/obj/effect/fusion_em_field/proc/React()
	// Loop through the reactants in random order.
	var/list/react_pool = reactants.Copy()
	last_reactants = 0

	// Can't have any reactions if there aren't any reactants present.
	if(length(react_pool))
		// Determine a random amount to actually react this cycle, and remove it from the standard pool.
		// This is a hack, and quite nonrealistic :(
		for(var/reactant in react_pool)
			react_pool[reactant] = rand(FLOOR(react_pool[reactant]/2, 1),react_pool[reactant])
			reactants[reactant] -= react_pool[reactant]
			if(!react_pool[reactant])
				react_pool -= reactant

		// Loop through all the reacting reagents, picking out random reactions for them.
		var/list/produced_reactants = new/list
		var/list/p_react_pool = react_pool.Copy()
		while(length(p_react_pool))
			// Pick one of the unprocessed reacting reagents randomly.
			var/cur_p_react = pick(p_react_pool)
			p_react_pool.Remove(cur_p_react)

			// Grab all the possible reactants to have a reaction with.
			var/list/possible_s_reacts = react_pool.Copy()
			// If there is only one of a particular reactant, then it can not react with itself so remove it.
			possible_s_reacts[cur_p_react] -= 1
			if(possible_s_reacts[cur_p_react] < 1)
				possible_s_reacts.Remove(cur_p_react)

			// Loop through and work out all the possible reactions.
			var/list/possible_reactions
			for(var/cur_s_react in possible_s_reacts)
				if(possible_s_reacts[cur_s_react] < 1)
					continue
				var/singleton/fusion_reaction/cur_reaction = get_fusion_reaction(cur_p_react, cur_s_react)
				if(cur_reaction && plasma_temperature >= (cur_reaction.minimum_energy_level)&& possible_s_reacts[cur_p_react] >= cur_reaction.minimum_p_react)
					LAZYDISTINCTADD(possible_reactions, cur_reaction)

			// If there are no possible reactions here, abandon this primary reactant and move on.
			if(!LAZYLEN(possible_reactions))
				continue

			// Sort based on reaction priority to avoid deut-deut eating all the deut before deut-trit can run etc.
			sortTim(possible_reactions, /proc/cmp_fusion_reaction_des)

			// Split up the reacting atoms between the possible reactions.
			while(length(possible_reactions))
				var/singleton/fusion_reaction/cur_reaction = possible_reactions[1]
				possible_reactions.Remove(cur_reaction)

				// Set the randmax to be the lower of the two involved reactants.
				var/max_num_reactants = react_pool[cur_reaction.p_react] > react_pool[cur_reaction.s_react] ? \
				react_pool[cur_reaction.s_react] : react_pool[cur_reaction.p_react]
				if(max_num_reactants < 1)
					continue

				// Make sure we have enough energy.
				// First, if minimum_reaction_temperature not set, make it the same as minimum_energy_level.
				if(!cur_reaction.minimum_reaction_temperature)
					cur_reaction.minimum_reaction_temperature = (cur_reaction.minimum_energy_level * 0.8)
				if(plasma_temperature < cur_reaction.minimum_reaction_temperature)
					continue

				if(plasma_temperature < max_num_reactants * cur_reaction.energy_consumption)
					max_num_reactants = round(plasma_temperature / cur_reaction.energy_consumption)
					if(max_num_reactants < 1)
						continue

				// Randomly determined amount to react. Starts at up to 1/20th, scales to up to 2/3rd at 20x min temp
				var/temp_over_min = plasma_temperature / (cur_reaction.minimum_energy_level * 20)
				var/max_react_percent = clamp(temp_over_min, (1/20), (2/3))
				var/amount_reacting = rand(1, (max_num_reactants * max_react_percent))

				// Removing the reacting substances from the list of substances that are primed to react this cycle.
				// If there aren't enough of that substance (there should be) then modify the reactant amounts accordingly.
				if( react_pool[cur_reaction.p_react] - amount_reacting >= 0 )
					react_pool[cur_reaction.p_react] -= amount_reacting
				else
					amount_reacting = react_pool[cur_reaction.p_react]
					react_pool[cur_reaction.p_react] = 0
				// Same again for secondary reactant
				if(react_pool[cur_reaction.s_react] - amount_reacting >= 0 )
					react_pool[cur_reaction.s_react] -= amount_reacting
				else
					react_pool[cur_reaction.p_react] += amount_reacting - react_pool[cur_reaction.p_react]
					amount_reacting = react_pool[cur_reaction.s_react]
					react_pool[cur_reaction.s_react] = 0

				// Attempt to run temperature changes in isolation to prevent weird drops
				var/plasma_temperature_change
				var/current_reaction_energy_production = cur_reaction.energy_production
				if(cur_reaction.maximum_effective_temperature && plasma_temperature > cur_reaction.maximum_effective_temperature)
					current_reaction_energy_production = current_reaction_energy_production * 0.4
				plasma_temperature_change -= max_num_reactants * cur_reaction.energy_consumption
				plasma_temperature_change += max_num_reactants * current_reaction_energy_production

				adjust_temperature(plasma_temperature_change, cur_reaction.max_temp_change_rate, cur_reaction.name)

				// Add any produced radiation.
				radiation += max_num_reactants * cur_reaction.radiation
				tick_instability += max_num_reactants * cur_reaction.instability
				last_reactants += amount_reacting

				// Create the reaction products.
				for(var/reactant in cur_reaction.products)
					var/success = 0
					for(var/check_reactant in produced_reactants)
						if(check_reactant == reactant)
							produced_reactants[reactant] += cur_reaction.products[reactant] * amount_reacting
							success = 1
							break
					if(!success)
						produced_reactants[reactant] = cur_reaction.products[reactant] * amount_reacting

				// Handle anything special. If this proc returns true, abort the current reaction.
				if(cur_reaction.handle_reaction_special(src))
					return

				// This reaction is done, and can't be repeated this sub-cycle.
				possible_reactions.Remove(cur_reaction.s_react)

		// Loop through the newly produced reactants and add them to the pool.
		for(var/reactant in produced_reactants)
			AddParticles(reactant, produced_reactants[reactant])

		// Check whether there are reactants left, and add them back to the pool.
		for(var/reactant in react_pool)
			AddParticles(reactant, react_pool[reactant])

	UpdateVisuals()

/obj/effect/fusion_em_field/Destroy()
	set_light(0)
	RadiateAll()
	QDEL_LIST(particle_catchers)
	QDEL_NULL(radio)
	if(owned_core)
		owned_core.owned_field = null
		owned_core = null
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/effect/fusion_em_field/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	AddEnergy(hitting_projectile.damage)
	update_icon()

/obj/effect/fusion_em_field/add_point_filter()
	return

/**
 * Handles clamping temperature changes to the core field to prevent excessive second-by-second shifts.
 * Lives in its own function to ensure consistent behavior across all potential core field temperature interactions.
 *
 * * var/temperature : The amount temperature is being changed by. Can be positive or negative.
 * * var/max_percentage : Limiting value on how much temp can change per tick. Only overriden by specific fusion reactions.
 * * var/cause : For debugging only.
 */
/obj/effect/fusion_em_field/proc/adjust_temperature(var/temp_change, var/max_percentage = FUSION_TICK_MAX_TEMP_CHANGE, var/cause)
	var/adjusted_plasma_temperature_change = min(temp_change, temp_change * FUSION_TICK_MAX_TEMP_CHANGE)
	plasma_temperature += adjusted_plasma_temperature_change

/**
 * Accurate(ish***) black-body radiation colors. Fuck you purple light; save it for a phoronics update!
 */
/obj/effect/fusion_em_field/proc/update_light_colors()
	var/use_range
	var/use_power = 0
	var/temp_mod = ((plasma_temperature-5000)/28000)
	/// super-duper brightness for super-duper temps (its a range multiplier)
	var/super = 1.0

	// Using real values for black-body radiation means the fusion reactor will almost always zip to top temp color.
	// This multiplier scales the below temperatures to better match intended range of temps in gameplay.
	var/effective_plasma_temperature = plasma_temperature / FUSION_BLACKBODY_MULTIPLIER

	use_range = light_min_range + Ceil((light_max_range-light_min_range)*temp_mod*super)
	use_power = light_min_power + Ceil((light_max_power-light_min_power)*temp_mod*super)
	switch (effective_plasma_temperature)
		if (-INFINITY to 1000)
			light_color = "#ff5800"
			alpha = 60
		if (1000 to 1400)
			light_color = "#ff6500"
			alpha = 80
		if (1400 to 1800)
			light_color = "#ff7e00"
			alpha = 100
		if (1800 to 2200)
			light_color = "#ff932c"
			alpha = 120
		if (2200 to 2600)
			light_color = "#ffa54f"
			alpha = 130
		if (2600 to 3000)
			light_color = "#ffb46b"
			alpha = 140
		if (3000 to 4000)
			light_color = "#ffd1a3"
			alpha = 150
		if (4000 to 5400)
			light_color = "#ffebdc"
			alpha = 140
		if (5400 to 6200)
			light_color = "#fff5f5"
			alpha = 150
		if (6200 to 7000)
			light_color = "#f5f3ff"
			alpha = 160
		if (7000 to 8000)
			light_color = "#e3e9ff"
			alpha = 170
		if (8000 to 9000)
			light_color = "#d6e1ff"
			alpha = 180
		if (9000 to 10000)
			light_color = "#ccdbff"
			alpha = 190
		if (1000 to 11000)
			light_color = "#c4d7ff"
			alpha = 200
		if (11000 to 12000)
			light_color = "#bfd3ff"
			alpha = 205
		if (12000 to 13000)
			light_color = "#bad0ff"
			alpha = 210
		if (13000 to 14000)
			light_color = "#b6ceff"
			alpha = 215
		if (14000 to 15000)
			light_color = "#b3ccff"
			alpha = 220
		if (15000 to 16000)
			light_color = "#b0caff"
			alpha = 225
		if (16000 to 17000)
			light_color = "#aec8ff"
			alpha = 230
		if (17000 to 18000)
			light_color = "#acc7ff"
			alpha = 235
		if (18000 to 20000)
			light_color = "#a8c5ff"
			alpha = 240
		if (20000 to 25000)
			light_color = "#94c2ff"
			alpha = 245
		if (25000 to 32000)
			light_color = "#699bff"
			alpha = 250
		if (32000 to INFINITY)
			light_color = "#1f69ff"
			alpha = 255
			super = 3.0

	if (last_range != use_range || last_power != use_power || color != light_color)
		set_light(use_range / 6, use_power ? 6 : 0, light_color)
		last_range = use_range
		last_power = use_power
		//Temperature based color

		particles.gradient = list(0, COLOR_WHITE, 0.85, light_color)
		UNLINT(var/dm_filter/outline = filters[2])
		UNLINT(outline.color = light_color)
		UNLINT(var/dm_filter/bloom = filters[3])
		UNLINT(bloom.alpha = alpha)

/particles/fusion
	width = 500
	height = 500
	count = 4000
	spawning = 260
	lifespan = 0.85 SECONDS
	fade = 0.95 SECONDS
	position = generator("circle", 2.5 * 32 - 5, 2.5 * 32 + 5, NORMAL_RAND)
	velocity = generator("circle", 0, 3, NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_WHITE, 0.75, COLOR_BLUE_LIGHT)
	color_change = 0.1
	color = 0
	drift = generator("circle", 0.2, NORMAL_RAND)

#undef FUSION_INSTABILITY_DIVISOR
#undef FUSION_RUPTURE_THRESHOLD
#undef FUSION_REACTANT_CAP
#undef FUSION_WARNING_DELAY
#undef FUSION_BLACKBODY_MULTIPLIER
#undef FUSION_INTEGRITY_RATE_LIMIT
#undef FUSION_TICK_MAX_TEMP_CHANGE
