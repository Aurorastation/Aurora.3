/obj/effect/decal/cleanable/napalm
	name = "napalm gel"
	desc = "Some kind of sticky, flammable liquid."
	icon = 'icons/effects/effects.dmi'
	icon_state = "napalm"
	layer = BLOOD_LAYER
	anchored = 1
	///How much power we want to use for each reagent amount
	var/power_mult = 250 // Over 2k Kelvin in a few seconds
	///The color of the fire. Null will default to the standard
	var/fire_color = null
	///How much reagent we have
	var/amount = 1
	///Are we currently on fire?
	var/on_fire = FALSE

/obj/effect/decal/cleanable/napalm/Initialize(mapload, amt = 1, nologs = FALSE, ignite_immediately = FALSE)
	. = ..()
	if(!nologs && !mapload)
		log_and_message_admins("spilled [name]", user = usr, location = get_turf(src))
	src.amount = amt

	var/has_spread = 0
	//Be absorbed by any other liquid fuel in the tile.
	for(var/obj/effect/decal/cleanable/napalm/other in loc)
		if(other != src)
			other.amount += src.amount
			other.Spread(ignite_immediately)
			has_spread = 1
			break

	if(!has_spread)
		Spread(ignite_immediately)
	else
		qdel(src)

	if(ignite_immediately)
		Ignite()

/obj/effect/decal/cleanable/napalm/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/effect/decal/cleanable/napalm/proc/Spread(ignite_immediately = FALSE)
	if(amount < 100)
		return
	var/turf/simulated/S = loc
	if(!istype(S))
		return
	for(var/d in GLOB.cardinals)
		var/turf/simulated/target = get_step(src,d)
		if(istype(target))
			continue
		var/turf/simulated/origin = get_turf(src)
		if(origin.CanPass(null, target, 0, 0) && target.CanPass(null, origin, 0, 0))
			var/obj/effect/decal/cleanable/napalm/other_fuel = locate() in target
			if(other_fuel)
				other_fuel.amount += amount*0.5
				if(ignite_immediately)
					other_fuel.Ignite()
			else
				new /obj/effect/decal/cleanable/napalm(target, amount*0.5, TRUE, ignite_immediately)
			amount *= 0.5

/obj/effect/decal/cleanable/napalm/process(seconds_per_tick)
	var/turf/simulated/src_turf = get_turf(src)
	var/datum/gas_mixture/air_contents = src_turf?.return_air()
	var/is_cmb = CMB_LIQUID_FUEL
	if(air_contents)
		CHECK_COMBUSTIBLE(is_cmb, air_contents)
	else
		is_cmb = FALSE
	if(!is_cmb)
		PutOut()
		return

	var/napalm_used = min(amount, seconds_per_tick * 0.4) // We use roughly 0.4 per second, or less if there isn't enough napalm

	var/burn_amount = power_mult * napalm_used

	src_turf.IgniteTurf(burn_amount, fire_color)
	amount -= napalm_used

	if(amount <= 0)
		qdel(src)

	//Stick to mobs in our turf
	for(var/mob/living/L in src_turf)
		var/sticky = min(rand(power_mult,5*power_mult), amount) * seconds_per_tick
		if(sticky > 1 * seconds_per_tick)
			L.adjust_fire_stacks(sticky)
			amount = max(1, amount - sticky)

	if(amount <= 0)
		qdel(src)

/obj/effect/decal/cleanable/napalm/proc/Ignite()
	var/turf/simulated/src_turf = get_turf(src)
	var/datum/gas_mixture/air_contents = src_turf?.return_air()
	//If we can't ignite, return
	var/is_cmb = CMB_LIQUID_FUEL
	if(air_contents)
		CHECK_COMBUSTIBLE(is_cmb, air_contents)
	else
		is_cmb = FALSE
	if(!is_cmb)
		return
	//Otherwise, start a fire!
	on_fire = TRUE
	var/napalm_used = min(amount, 1)

	var/burn_amount = power_mult * napalm_used

	src_turf.IgniteTurf(burn_amount, fire_color)
	amount -= napalm_used

	if(amount > 0)
		START_PROCESSING(SSprocessing, src)
	else
		qdel(src)

/obj/effect/decal/cleanable/napalm/proc/PutOut()
	on_fire = FALSE
	STOP_PROCESSING(SSprocessing, src)

/obj/effect/decal/cleanable/napalm/proc/add_napalm(add_amount)
	amount += add_amount
	Spread()

/obj/effect/decal/cleanable/napalm/zorane_fire
	name = "\improper Zo'rane fire gel"
	desc = "Some kind of sticky, flammable liquid."
	icon_state = "zorane"
	power_mult = 1000 // Four times as good
	fire_color = "#5fcae8"

/obj/effect/decal/cleanable/napalm/zorane_fire/Spread(ignite_immediately = FALSE)
	if(amount < 100)
		return
	var/turf/simulated/S = loc
	if(!istype(S))
		return
	for(var/d in GLOB.cardinals)
		var/turf/simulated/target = get_step(src,d)
		if(istype(target))
			continue
		var/turf/simulated/origin = get_turf(src)
		if(origin.CanPass(null, target, 0, 0) && target.CanPass(null, origin, 0, 0))
			var/obj/effect/decal/cleanable/napalm/zorane_fire/other_fuel = locate() in target
			if(other_fuel)
				other_fuel.amount += amount*0.5
				if(ignite_immediately)
					other_fuel.Ignite()
			else
				new /obj/effect/decal/cleanable/napalm/zorane_fire(target, amount*0.5, TRUE, ignite_immediately)
			amount *= 0.5
