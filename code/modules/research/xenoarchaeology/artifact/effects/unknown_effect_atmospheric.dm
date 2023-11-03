//Creating gasses


/datum/artifact_effect/gasco2
	effecttype = "gasco2"
	var/max_pressure
	var/target_percentage

/datum/artifact_effect/heat/New()
	..()
	effect_type = pick(6,7)

/datum/artifact_effect/gasco2/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	max_pressure = rand(115,1000)

/datum/artifact_effect/gasco2/DoEffectTouch(var/mob/living/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_CO2, rand(2, 15))

/datum/artifact_effect/gasco2/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_CO2, pick(0, 0, 0.1, rand()))

/datum/artifact_effect/gasnitro
	effecttype = "gasnitro"
	var/max_pressure
	var/target_percentage

/datum/artifact_effect/gasnitro/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(6,7)
	max_pressure = rand(115,1000)

/datum/artifact_effect/gasnitro/DoEffectTouch(var/mob/living/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_NITROGEN, rand(2, 15))

/datum/artifact_effect/gasnitro/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_NITROGEN, pick(0, 0, 0.1, rand()))


/datum/artifact_effect/gasoxy
	effecttype = "gasoxy"
	var/max_pressure

/datum/artifact_effect/gasoxy/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	max_pressure = rand(115,1000)
	effect_type = pick(6,7)


/datum/artifact_effect/gasoxy/DoEffectTouch(var/mob/living/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_OXYGEN, rand(2, 15))

/datum/artifact_effect/gasoxy/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_OXYGEN, pick(0, 0, 0.1, rand()))

/datum/artifact_effect/gasphoron
	effecttype = "gasphoron"
	var/max_pressure
	var/target_percentage

/datum/artifact_effect/gasphoron/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	max_pressure = rand(115,1000)
	effect_type = pick(6,7)

/datum/artifact_effect/gasphoron/DoEffectTouch(var/mob/living/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_OXYGEN, rand(2, 15))

/datum/artifact_effect/gasphoron/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_PHORON, pick(0, 0, 0.1, rand()))

/datum/artifact_effect/gassleeping
	effecttype = "gassleeping"
	var/max_pressure
	var/target_percentage

/datum/artifact_effect/gassleeping/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	max_pressure = rand(115,1000)
	effect_type = pick(6,7)

/datum/artifact_effect/gassleeping/DoEffectTouch(var/mob/living/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_N2O, rand(2, 15))

/datum/artifact_effect/gassleeping/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_N2O, pick(0, 0, 0.1, rand()))

/datum/artifact_effect/gashydrogen
	effecttype = "gashydrogen"
	var/max_pressure
	var/target_percentage

/datum/artifact_effect/gashydrogen/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	max_pressure = rand(115,1000)
	effect_type = pick(6,7)

/datum/artifact_effect/gashydrogen/DoEffectTouch(var/mob/living/user)
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_HYDROGEN, rand(2, 15))

/datum/artifact_effect/gashydrogen/DoEffectAura()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_HYDROGEN, pick(0, 0, 0.1, rand()))



//Temperature changes
/datum/artifact_effect/cold
	effecttype = "cold"
	var/target_temp

/datum/artifact_effect/cold/New()
	..()
	target_temp = rand(0, 250)
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(5,6,7)

/datum/artifact_effect/cold/DoEffectTouch(var/mob/living/user)
	if(holder)
		if(user.isSynthetic())
			to_chat(user, SPAN_NOTICE("You detect a decrease in temperature throughout your systems!"))
		else
			to_chat(user, SPAN_NOTICE("A chill passes up your spine!"))
		if(!holder.loc) return
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env)
			env.temperature = max(env.temperature - rand(5,50), 0)

/datum/artifact_effect/cold/DoEffectAura()
	if(holder && holder.loc)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env && env.temperature > target_temp)
			env.temperature -= pick(0, 0, 1)

/datum/artifact_effect/heat
	effecttype = "heat"
	var/target_temp

/datum/artifact_effect/heat/New()
	..()
	effect_type = pick(5,6,7)

/datum/artifact_effect/heat/New()
	..()
	target_temp = rand(300,600)
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)

/datum/artifact_effect/heat/DoEffectTouch(var/mob/living/user)
	if(holder && holder.loc)
		if(user.isSynthetic())
			to_chat(user, SPAN_WARNING("You detect a wave of heat surging through your systems."))
		else
			to_chat(user, SPAN_WARNING("You feel a wave of heat travel up your spine!"))
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env)
			env.temperature += rand(5,50)

/datum/artifact_effect/heat/DoEffectAura()
	if(holder && holder.loc)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env && env.temperature < target_temp)
			env.temperature += pick(0, 0, 1)
