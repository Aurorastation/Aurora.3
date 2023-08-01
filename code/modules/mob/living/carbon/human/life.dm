//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 4 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 1000K point

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

#define RADIATION_SPEED_COEFFICIENT 0.1

/mob/living/carbon/human
	var/oxygen_alert = 0
	var/phoron_alert = 0
	var/co2_alert = 0
	var/fire_alert = 0
	var/pressure_alert = 0
	var/temperature_alert = 0

/mob/living/carbon/human/Life()
	set background = BACKGROUND_ENABLED

	if (transforming)
		return

	fire_alert = 0 //Reset this here, because both breathe() and handle_environment() have a chance to set it.

	//TODO: seperate this out
	// update the current life tick, can be used to e.g. only do something every 4 ticks
	life_tick++

	// This is not an ideal place for this but it will do for now.
	if(wearing_rig && wearing_rig.offline)
		wearing_rig = null

	..()

	if(life_tick%30==5)//Makes huds update every 10 seconds instead of every 30 seconds
		hud_updateflag = 1022

	voice = GetVoice()

	//No need to update all of these procs if the guy is dead or in stasis
	if(stat != DEAD && !InStasis())
		//Updates the number of stored chemicals for powers
		handle_changeling()

		//Organs
		handle_organs()
		stabilize_body_temperature() //Body temperature adjusts itself (self-regulation)

		//Random events (vomiting etc)
		handle_random_events()

		handle_shock()

		handle_pain()

		handle_medical_side_effects()

		handle_fever()

		//Handles regenerating stamina if we have sufficient air and no oxyloss
		handle_stamina()

		if (is_diona())
			diona_handle_light(DS)

		handle_shared_dreaming()

	if(!handle_some_updates())
		return											//We go ahead and process them 5 times for HUD images and other stuff though.

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	if(mind)
		var/datum/vampire/vampire = mind.antag_datums[MODE_VAMPIRE]
		if(vampire)
			handle_vampire()

/mob/living/carbon/human/think()
	..()
	species.handle_npc(src)

/mob/living/carbon/human/proc/handle_some_updates()
	if(life_tick > 5 && timeofdeath && (timeofdeath < 5 || world.time - timeofdeath > 6000))	//We are long dead, or we're junk mobs spawned like the clowns on the clown shuttle
		return 0
	return 1

/mob/living/carbon/human/breathe()
	if(!InStasis())
		..()

// Calculate how vulnerable the human is to the current pressure.
// Returns 0 (equals 0 %) if sealed in an undamaged suit that's rated for the pressure, 1 if unprotected (equals 100%).
// Suitdamage can modifiy this in 10% steps.
/mob/living/carbon/human/get_pressure_weakness(pressure)
	var/pressure_adjustment_coefficient = 0
	var/list/zones = list(HEAD, UPPER_TORSO, LOWER_TORSO, LEGS, FEET, ARMS, HANDS)
	for(var/zone in zones)
		var/list/covers = get_covering_equipped_items(zone)
		var/zone_exposure = 1
		for(var/obj/item/clothing/C in covers)
			zone_exposure = min(zone_exposure, C.get_pressure_weakness(pressure,zone))
		if(zone_exposure >= 1)
			return 1
		pressure_adjustment_coefficient = max(pressure_adjustment_coefficient, zone_exposure)
	pressure_adjustment_coefficient = Clamp(pressure_adjustment_coefficient, 0, 1) // So it isn't less than 0 or larger than 1.

	return pressure_adjustment_coefficient

// Calculate how much of the enviroment pressure-difference affects the human.
/mob/living/carbon/human/calculate_affecting_pressure(var/pressure)
	var/pressure_difference

	// First get the absolute pressure difference.
	if(pressure < ONE_ATMOSPHERE) // We are in an underpressure.
		pressure_difference = ONE_ATMOSPHERE - pressure

	else //We are in an overpressure or standard atmosphere.
		pressure_difference = pressure - ONE_ATMOSPHERE

	if(pressure_difference < 5) // If the difference is small, don't bother calculating the fraction.
		pressure_difference = 0

	else
		// Otherwise calculate how much of that absolute pressure difference affects us, can be 0 to 1 (equals 0% to 100%).
		// This is our relative difference.
		pressure_difference *= get_pressure_weakness()

	// The difference is always positive to avoid extra calculations.
	// Apply the relative difference on a standard atmosphere to get the final result.
	// The return value will be the adjusted_pressure of the human that is the basis of pressure warnings and damage.
	if(pressure < ONE_ATMOSPHERE)
		return ONE_ATMOSPHERE - pressure_difference
	else
		return ONE_ATMOSPHERE + pressure_difference

/mob/living/carbon/human/handle_disabilities()
	..()
	//Vision
	var/obj/item/organ/vision
	if(species.vision_organ)
		vision = species.get_vision_organ(src)

	if (!vision)
		if (species.vision_organ) // if they should have eyes but don't, they can't see
			eye_blind = 1
			blinded = 1
			eye_blurry = 1
		else // if they're not supposed to have a vision organ, then they must see by some other means
			eye_blind = 0
			blinded = 0
			eye_blurry = 0
	else if (vision.is_broken()) // if their eyes have been damaged or detached, they're blinded
		eye_blind = 1
		blinded = 1
		eye_blurry = 1
	else
		//blindness
		if(!(sdisabilities & BLIND))
			if(!src.is_diona() && equipment_tint_total >= TINT_BLIND)	// Covered eyes, heal faster
				eye_blurry = max(eye_blurry-2, 0)
			else
				eye_blurry = max(eye_blurry-1, 0)

	if (disabilities & EPILEPSY)
		if ((prob(1) && paralysis < 1))
			to_chat(src, "<span class='warning'>You have a seizure!</span>")
			for(var/mob/O in viewers(src, null))
				if(O == src)
					continue
				O.show_message(text("<span class='danger'>[src] starts having a seizure!</span>"), 1)
			Paralyse(10)
			make_jittery(1000)
	if (disabilities & COUGHING)
		if ((prob(5) && paralysis <= 1))
			drop_item()
			spawn( 0 )
				emote("cough")
				return

	if((disabilities & ASTHMA) && getOxyLoss() >= 10)
		if(prob(5))
			emote("cough")

	if(disabilities & STUTTERING)
		var/aid = 1 + chem_effects[CE_NOSTUTTER]
		if(aid < 3 && prob(10/aid)) //NOSTUTTER at 2 or above prevents it completely.
			stuttering = max(10/aid, stuttering)

/mob/living/carbon/human/handle_mutations_and_radiation()
	if(InStasis())
		return

	if(getFireLoss() && (HAS_FLAG(mutations, COLD_RESISTANCE) || prob(1)))
		heal_organ_damage(0,1)

	// DNA2 - Gene processing.
	// The HULK stuff that was here is now in the hulk gene.
	for(var/datum/dna/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			gene.OnMobLife(src)

	total_radiation = Clamp(total_radiation,0,100)

	if (total_radiation)
		if(src.is_diona())
			diona_handle_regeneration(get_dionastats())
			return
		else
			var/damage = 0
			total_radiation -= 1 * RADIATION_SPEED_COEFFICIENT
			if(prob(25))
				damage = 1

			if (total_radiation > 50)
				damage = 1
				total_radiation -= 1 * RADIATION_SPEED_COEFFICIENT
				if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT))
					src.apply_radiation(-5 * RADIATION_SPEED_COEFFICIENT)
					to_chat(src, "<span class='warning'>You feel weak.</span>")
					Weaken(3)
					if(!lying)
						emote("collapse")
				if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT) && species.name == SPECIES_HUMAN) //apes go bald
					if((h_style != "Bald" || f_style != "Shaved" ))
						to_chat(src, "<span class='warning'>Your hair falls out.</span>")
						h_style = "Bald"
						f_style = "Shaved"
						update_hair()

			if (total_radiation > 75)
				src.apply_radiation(-1 * RADIATION_SPEED_COEFFICIENT)
				damage = 3
				if(prob(5))
					take_overall_damage(0, 5 * RADIATION_SPEED_COEFFICIENT, used_weapon = "Radiation Burns")
				if(prob(1))
					to_chat(src, "<span class='warning'>You feel strange!</span>")
					adjustCloneLoss(5 * RADIATION_SPEED_COEFFICIENT)
					emote("gasp")
				hallucination = max(hallucination, 20) //At this level, you're in a constant state of low-level hallucinations. As if you didn't have enough problems.


			if(damage)
				adjustToxLoss(damage * RADIATION_SPEED_COEFFICIENT)
				updatehealth()
				if(organs.len)
					var/obj/item/organ/external/O = pick(organs)
					if(istype(O)) O.add_autopsy_data("Radiation Poisoning", damage)

	/** breathing **/

/mob/living/carbon/human/handle_chemical_smoke(var/datum/gas_mixture/environment)
	if(wear_mask && (wear_mask.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(glasses && (glasses.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	if(head && (head.item_flags & BLOCK_GAS_SMOKE_EFFECT))
		return
	..()

/mob/living/carbon/human/get_breath_from_internal(volume_needed=BREATH_VOLUME)
	if(internal)

		var/obj/item/tank/rig_supply
		if(istype(back,/obj/item/rig))
			var/obj/item/rig/rig = back
			if(!rig.offline && (rig.air_supply && internal == rig.air_supply))
				rig_supply = rig.air_supply

		if (!rig_supply && (!contents.Find(internal) || !((wear_mask && (wear_mask.item_flags & AIRTIGHT)) || (head && (head.item_flags & AIRTIGHT)))))
			internal = null

		if(internal)
			return internal.remove_air_volume(volume_needed)
		else if(internals)
			internals.icon_state = "internal0"
	return null

/mob/living/carbon/human/get_breath_from_environment(var/volume_needed=BREATH_VOLUME)
	var/datum/gas_mixture/breath = ..()

	if(breath)
		//exposure to extreme pressures can rupture lungs
		var/check_pressure = breath.return_pressure()
		if(check_pressure < ONE_ATMOSPHERE / 5 || check_pressure > ONE_ATMOSPHERE * 5)
			if(!is_lung_ruptured() && prob(5))
				rupture_lung()

	return breath

/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment)
	if(!environment)
		return

	//Stuff like the xenomorph's plasma regen happens here.
	species.handle_environment_special(src)

	//Moved pressure calculations here for use in skip-processing check.
	var/pressure = environment.return_pressure()
	var/adjusted_pressure = calculate_affecting_pressure(pressure)

	if (consume_nutrition_from_air)
		environment.remove(diona_handle_air(get_dionastats(), pressure))

	//Check for contaminants before anything else because we don't want to skip it.
	for(var/g in environment.gas)
		if(gas_data.flags[g] & XGM_GAS_CONTAMINANT && environment.gas[g] > gas_data.overlay_limit[g] + 1)
			pl_effects()
			break

	if(istype(get_turf(src), /turf/space))
		//Don't bother if the temperature drop is less than 0.1 anyways. Hopefully BYOND is smart enough to turn this constant expression into a constant
		if(bodytemperature > (0.1 * HUMAN_HEAT_CAPACITY/(HUMAN_EXPOSED_SURFACE_AREA*STEFAN_BOLTZMANN_CONSTANT))**(1/4) + COSMIC_RADIATION_TEMPERATURE)
			//Thermal radiation into space
			var/heat_loss = HUMAN_EXPOSED_SURFACE_AREA * STEFAN_BOLTZMANN_CONSTANT * ((bodytemperature - COSMIC_RADIATION_TEMPERATURE)**4)
			var/temperature_loss = heat_loss/HUMAN_HEAT_CAPACITY
			bodytemperature -= temperature_loss
	else
		var/loc_temp = T0C
		if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			var/obj/machinery/atmospherics/unary/cryo_cell/C = loc
			loc_temp = C.air_contents?.temperature
		else
			loc_temp = environment.temperature

		if(adjusted_pressure < species.warning_high_pressure && adjusted_pressure > species.warning_low_pressure && abs(loc_temp - bodytemperature) < 20 && bodytemperature < species.heat_level_1 && bodytemperature > species.cold_level_1)
			pressure_alert = 0
			return // Temperatures are within normal ranges, fuck all this processing. ~Ccomp

		//Body temperature adjusts depending on surrounding atmosphere based on your thermal protection (convection)
		var/temp_adj = 0
		if(loc_temp < bodytemperature)			//Place is colder than we are
			var/thermal_protection = get_cold_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_COLD_DIVISOR)	//this will be negative
		else if (loc_temp > bodytemperature)			//Place is hotter than we are
			var/thermal_protection = get_heat_protection(loc_temp) //This returns a 0 - 1 value, which corresponds to the percentage of protection based on what you're wearing and what you're exposed to.
			if(thermal_protection < 1)
				temp_adj = (1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR)

		//Use heat transfer as proportional to the gas density. However, we only care about the relative density vs standard 101 kPa/20 C air. Therefore we can use mole ratios
		var/relative_density = environment.total_moles / MOLES_CELLSTANDARD
		bodytemperature += between(BODYTEMP_COOLING_MAX, temp_adj*relative_density, BODYTEMP_HEATING_MAX)

	var/cold_bonus = 0
	var/hot_bonus = 0
	if(HAS_TRAIT(src, TRAIT_ORIGIN_COLD_RESISTANCE))
		cold_bonus = 20
	if(HAS_TRAIT(src, TRAIT_ORIGIN_HOT_RESISTANCE))
		hot_bonus = 20

	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(bodytemperature >= (species.heat_level_1 + hot_bonus))
		//Body temperature is too hot.
		fire_alert = max(fire_alert, 1)
		if(status_flags & GODMODE)	return 1	//godmode
		var/burn_dam = 0
		if(bodytemperature < species.heat_level_2)
			burn_dam = HEAT_DAMAGE_LEVEL_1
		else if(bodytemperature < species.heat_level_3)
			burn_dam = HEAT_DAMAGE_LEVEL_2
		else
			burn_dam = HEAT_DAMAGE_LEVEL_3
		take_overall_damage(burn = burn_dam, used_weapon = "extreme heat")
		fire_alert = max(fire_alert, 2)

	else if(bodytemperature <= (species.cold_level_1 - cold_bonus))
		fire_alert = max(fire_alert, 1)
		if(status_flags & GODMODE)
			return 1

		var/burn_dam = 0

		if(bodytemperature > species.cold_level_2)
			burn_dam = COLD_DAMAGE_LEVEL_1
		else if(bodytemperature > species.cold_level_3)
			burn_dam = COLD_DAMAGE_LEVEL_2
		else
			burn_dam = COLD_DAMAGE_LEVEL_3
		SetStasis(getCryogenicFactor(bodytemperature), STASIS_COLD)
		if(!chem_effects[CE_CRYO])
			take_overall_damage(burn = burn_dam, used_weapon = "extreme cold")
			fire_alert = max(fire_alert, 1)

	// Account for massive pressure differences.  Done by Polymorph
	// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!
	if(status_flags & GODMODE)
		return 1	//godmode

	if(adjusted_pressure >= species.hazard_high_pressure)
		var/pressure_damage = min( ( (adjusted_pressure / species.hazard_high_pressure) -1 )*PRESSURE_DAMAGE_COEFFICIENT , MAX_HIGH_PRESSURE_DAMAGE)
		take_overall_damage(pressure_damage, used_weapon = "High Pressure")
		pressure_alert = 2
	else if(adjusted_pressure >= species.warning_high_pressure)
		pressure_alert = 1
	else if(adjusted_pressure >= species.warning_low_pressure)
		pressure_alert = 0
	else if(adjusted_pressure >= species.hazard_low_pressure)
		pressure_alert = -1
	else
		if(!pressure_resistant())
			var/list/obj/item/organ/external/organs = get_damageable_organs()
			for(var/obj/item/organ/external/O in organs)
				if(QDELETED(O))
					continue
				if((O.damage + LOW_PRESSURE_DAMAGE) < O.max_damage)
					O.take_damage(brute = LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")
			if(getOxyLoss() < 55)
				adjustOxyLoss(4)
			pressure_alert = -2
		else
			pressure_alert = -1

	if (is_diona())
		diona_handle_temperature(DS)

/mob/living/carbon/human/proc/get_baseline_body_temperature()
	var/baseline = species.body_temperature
	for(var/obj/item/clothing/clothing in list(w_uniform, wear_suit))
		baseline += clothing.body_temperature_change
	return baseline

/mob/living/carbon/human/proc/stabilize_body_temperature()
	if (species.passive_temp_gain) // We produce heat naturally.
		bodytemperature += species.passive_temp_gain
	if (species.body_temperature == null)
		return //this species doesn't have metabolic thermoregulation

	var/body_temperature_difference = get_baseline_body_temperature() - bodytemperature

	if (abs(body_temperature_difference) < 0.5)
		return //fuck this precision
	if (on_fire)
		return //too busy for pesky metabolic regulation

	if(bodytemperature < species.cold_level_1) //260.15 is 310.15 - 50, the temperature where you start to feel effects.
		if(nutrition >= 2) //If we are very, very cold we'll use up quite a bit of nutriment to heat us up.
			adjustNutritionLoss(2)
		var/recovery_amt = max((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
		bodytemperature += recovery_amt
	else if(species.cold_level_1 <= bodytemperature && bodytemperature <= species.heat_level_1)
		var/recovery_amt = body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR
		bodytemperature += recovery_amt
	else if(bodytemperature > species.heat_level_1) //360.15 is 310.15 + 50, the temperature where you start to feel effects.
		if(hydration >= 2)
			adjustHydrationLoss(2)
			if(HAS_FLAG(species.flags, CAN_SWEAT) && fire_stacks == 0)
				fire_stacks = -1
		var/recovery_amt = min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers
		bodytemperature += recovery_amt

	//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, UPPER_TORSO, LOWER_TORSO, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = 0
	//Handle normal clothing
	if(head)
		if(head.max_heat_protection_temperature && head.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= head.heat_protection
	if(wear_suit)
		if(wear_suit.max_heat_protection_temperature && wear_suit.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_suit.heat_protection
	if(w_uniform)
		if(w_uniform.max_heat_protection_temperature && w_uniform.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= w_uniform.heat_protection
	if(shoes)
		if(shoes.max_heat_protection_temperature && shoes.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= shoes.heat_protection
	if(gloves)
		if(gloves.max_heat_protection_temperature && gloves.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= gloves.heat_protection
	if(wear_mask)
		if(wear_mask.max_heat_protection_temperature && wear_mask.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= wear_mask.heat_protection

	return thermal_protection_flags

/mob/living/carbon/human/get_heat_protection(temperature) //Temperature is the temperature you're being exposed to.
	var/thermal_protection_flags = get_heat_protection_flags(temperature)

	var/thermal_protection = 0.0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & UPPER_TORSO)
			thermal_protection += THERMAL_PROTECTION_UPPER_TORSO
		if(thermal_protection_flags & LOWER_TORSO)
			thermal_protection += THERMAL_PROTECTION_LOWER_TORSO
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT


	return min(1,thermal_protection)

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	var/thermal_protection_flags = 0
	//Handle normal clothing

	if(head)
		if(head.min_cold_protection_temperature && head.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= head.cold_protection
	if(wear_suit)
		if(wear_suit.min_cold_protection_temperature && wear_suit.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_suit.cold_protection
	if(w_uniform)
		if(w_uniform.min_cold_protection_temperature && w_uniform.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= w_uniform.cold_protection
	if(shoes)
		if(shoes.min_cold_protection_temperature && shoes.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= shoes.cold_protection
	if(gloves)
		if(gloves.min_cold_protection_temperature && gloves.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= gloves.cold_protection
	if(wear_mask)
		if(wear_mask.min_cold_protection_temperature && wear_mask.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= wear_mask.cold_protection

	return thermal_protection_flags

/mob/living/carbon/human/get_cold_protection(temperature)
	if(HAS_FLAG(mutations, COLD_RESISTANCE))
		return 1 //Fully protected from the cold.

	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)

	var/thermal_protection = 0.0
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & UPPER_TORSO)
			thermal_protection += THERMAL_PROTECTION_UPPER_TORSO
		if(thermal_protection_flags & LOWER_TORSO)
			thermal_protection += THERMAL_PROTECTION_LOWER_TORSO
		if(thermal_protection_flags & LEG_LEFT)
			thermal_protection += THERMAL_PROTECTION_LEG_LEFT
		if(thermal_protection_flags & LEG_RIGHT)
			thermal_protection += THERMAL_PROTECTION_LEG_RIGHT
		if(thermal_protection_flags & FOOT_LEFT)
			thermal_protection += THERMAL_PROTECTION_FOOT_LEFT
		if(thermal_protection_flags & FOOT_RIGHT)
			thermal_protection += THERMAL_PROTECTION_FOOT_RIGHT
		if(thermal_protection_flags & ARM_LEFT)
			thermal_protection += THERMAL_PROTECTION_ARM_LEFT
		if(thermal_protection_flags & ARM_RIGHT)
			thermal_protection += THERMAL_PROTECTION_ARM_RIGHT
		if(thermal_protection_flags & HAND_LEFT)
			thermal_protection += THERMAL_PROTECTION_HAND_LEFT
		if(thermal_protection_flags & HAND_RIGHT)
			thermal_protection += THERMAL_PROTECTION_HAND_RIGHT

	return min(1,thermal_protection)

/mob/living/carbon/human/handle_chemicals_in_body()
	if(InStasis())
		return

	chem_effects.Cut()

	var/datum/reagents/metabolism/ingested = get_ingested_reagents()

	if(reagents)
		analgesic = 0

		if(touching) touching.metabolize()
		if(bloodstr) bloodstr.metabolize()
		if(ingested) metabolize_ingested_reagents()
		if(breathing) breathing.metabolize()

		if(CE_PAINKILLER in chem_effects)
			analgesic = chem_effects[CE_PAINKILLER]

		if(CE_TOXIN in chem_effects)
			adjustToxLoss(chem_effects[CE_TOXIN])

		if(CE_EMETIC in chem_effects)
			if(prob(chem_effects[CE_EMETIC]))
				delayed_vomit()

		if(CE_ITCH in chem_effects)
			var/itching = chem_effects[CE_ITCH]
			if(CE_NOITCH in chem_effects)
				itching -= chem_effects[CE_NOITCH]
			if(itching < 5)
				if(prob(5))
					to_chat(src, SPAN_WARNING(pick("You have an annoying itch.", "You have a slight itch.")))
			if(itching >= 5)
				if(prob(2))
					to_chat(src, SPAN_WARNING(pick("The itch is becoming progressively worse.", "You need to scratch that itch!", "The itch isn't going!")))

		if(CE_HAUNTED in chem_effects)
			var/haunted = chem_effects[CE_HAUNTED]
			if(haunted < 5)
				if(prob(20))
					set_see_invisible(SEE_INVISIBLE_CULT)
				if(prob(5))
					emote("shiver")
					to_chat(src, SPAN_GOOD(pick("You hear the clinking of dinner plates and laughter.", "You hear a distant voice of someone you know talking to you.", "Fond memories of a departed loved one flocks to your mind.", "You feel the reassuring presence of a departed loved one.", "You feel a hand squeezing yours.")))
			if(haunted >= 5)
				set_see_invisible(SEE_INVISIBLE_CULT)
				make_jittery(5)
				if(prob(5))
					visible_message("<b>[src]</b> trembles uncontrollably.", "<span class='warning'>You tremble uncontrollably.</span>")
					to_chat(src, SPAN_CULT(pick("You feel fingers tracing up your back.", "You hear the distant wailing and sobbing of a departed loved one.", "You feel like you are being closely watched.", "You hear the hysterical laughter of a departed loved one.", "You no longer feel the reassuring presence of a departed loved one.", "You feel a hand taking hold of yours, digging its nails into you as it clings on.")))
			if(haunted >= 10)
				if(prob(5))
					emote(pick("shiver", "twitch"))
					to_chat(src, SPAN_CULT(pick("You feel a cold and threatening air wrapping around you.", "Whispering shadows, ceaseless in their demands, twist your thoughts...", "The whispering, anything to make them stop!", "Your head spins amid the cacophony of screaming, wailing and maniacal laughter of distant loved ones.", "You feel vestiges of decaying souls cling to you, trying to re-enter the world of the living.")))

		sprint_speed_factor = species.sprint_speed_factor
		max_stamina = species.stamina
		stamina_recovery = species.stamina_recovery
		sprint_cost_factor = species.sprint_cost_factor
		move_delay_mod = 0

		if(CE_ADRENALINE in chem_effects)
			sprint_speed_factor += 0.1*chem_effects[CE_ADRENALINE]
			max_stamina *= 1 + chem_effects[CE_ADRENALINE]
			sprint_cost_factor -= 0.35 * chem_effects[CE_ADRENALINE]
			stamina_recovery += max ((stamina_recovery * 0.7 * chem_effects[CE_ADRENALINE]), 5)

		if(CE_SPEEDBOOST in chem_effects)
			sprint_speed_factor += 0.2 * chem_effects[CE_SPEEDBOOST]
			stamina_recovery *= 1 + 0.3 * chem_effects[CE_SPEEDBOOST]
			move_delay_mod += -1.5 * chem_effects[CE_SPEEDBOOST]

		var/obj/item/clothing/C = wear_suit
		if(!(C && (C.body_parts_covered & HANDS) && !(C.heat_protection & HANDS)) && !gloves)
			for(var/obj/item/I in src)
				if(I.contaminated && !(species.flags & PHORON_IMMUNE))
					if(I == r_hand)
						apply_damage(vsc.plc.CONTAMINATION_LOSS, DAMAGE_BURN, BP_R_HAND)
					else if(I == l_hand)
						apply_damage(vsc.plc.CONTAMINATION_LOSS, DAMAGE_BURN, BP_L_HAND)
					else
						adjustFireLoss(vsc.plc.CONTAMINATION_LOSS)

	if (intoxication)
		handle_intoxication()

	if(status_flags & GODMODE)	return 0	//godmode

	if(species.light_dam)
		var/light_amount = 0
		if(isturf(loc))
			var/turf/T = loc
			light_amount = T.get_lumcount() * 10
		if(light_amount > species.light_dam) //if there's enough light, start dying
			take_overall_damage(5,5)
		else //heal in the dark
			heal_overall_damage(5,5)

	// nutrition decrease over time
	if(max_nutrition > 0)
		if (nutrition > 0 && stat != 2)
			adjustNutritionLoss(nutrition_loss * nutrition_attrition_rate)

		if (nutrition / max_nutrition > CREW_NUTRITION_OVEREATEN)
			adjustNutritionLoss(1)
			if(overeatduration < 600) //capped so people don't take forever to unfat
				overeatduration++
		else
			if(overeatduration > 1)
				overeatduration -= 2 //doubled the unfat rate

	// hydration decrease over time
	if(max_hydration > 0)
		if (hydration > 0 && stat != 2)
			adjustHydrationLoss(hydration_loss * hydration_attrition_rate)

		if (hydration / max_hydration > CREW_HYDRATION_OVERHYDRATED)
			adjustHydrationLoss(2)
			if(overdrinkduration < 600) //capped so people don't take forever to undrink
				overdrinkduration++
		else
			if(overdrinkduration > 1)
				overdrinkduration -= 2 //doubled the undrink rate

	// TODO: stomach and bloodstream organ.
	if(!isSynthetic())
		handle_trace_chems()
	if(vessel && (/singleton/reagent/blood in vessel.reagent_data))
		// update the trace chems in our blood vessels
		var/singleton/reagent/blood/B = GET_SINGLETON(/singleton/reagent/blood)
		B.handle_trace_chems(vessel)

	for(var/_R in chem_doses)
		if ((_R in bloodstr.reagent_volumes) || (_R in ingested.reagent_volumes) || (_R in breathing.reagent_volumes) || (_R in touching.reagent_volumes))
			continue
		chem_doses -= _R //We're no longer metabolizing this reagent. Remove it from chem_doses

	updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/human/handle_regular_status_updates()
	if(!handle_some_updates())
		return 0

	if(status_flags & GODMODE)
		return 0

	//SSD check, if a logged player is awake put them back to sleep!
	if(species.show_ssd && (!client && !vr_mob) && !teleop && ((world.realtime - disconnect_time) >= 5 MINUTES)) //only sleep after 5 minutes, should help those with intermittent internet connections
		Sleeping(2)
	if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = 1
		silent = 0
	else				//ALIVE. LIGHTS ARE ON
		updatehealth()	//TODO

		if(handle_death_check())
			death()
			blinded = 1
			silent = 0
			return 1

		if(hallucination && (HAS_TRAIT(src, TRAIT_BYPASS_HALLUCINATION_RESTRICTION) || !HAS_FLAG(species.flags, NO_POISON|IS_PLANT)))
			handle_hallucinations()

		if(get_shock() >= species.total_health)
			if(!stat && !paralysis)
				to_chat(src, "<span class='warning'>[species.halloss_message_self]</span>")
				src.visible_message("<B>[src]</B> [species.halloss_message]")
			Paralyse(10)

		if(paralysis || sleeping || InStasis())
			blinded = TRUE
			if(sleeping)
				set_stat(UNCONSCIOUS)
				if(!sleeping_msg_debounce)
					sleeping_msg_debounce = TRUE
					to_chat(src, SPAN_NOTICE(FONT_LARGE("You are now unconscious.<br>You will not remember anything you \"see\" happening around you until you regain consciousness.")))

			adjustHalLoss(-3)
			if (species.tail)
				animate_tail_reset()
			if(prob(2) && is_asystole() && isSynthetic())
				visible_message("<b>[src]</b> [pick("emits low pitched whirr","beeps urgently")].")

		if(paralysis)
			AdjustParalysis(-1)

		else if(sleeping)
			handle_dreams()
			if(mind)
				//Are they SSD? If so we'll keep them asleep but work off some of that sleep var in case of stoxin or similar.
				if(client || sleeping > 3 || istype(bg))
					AdjustSleeping(-1)
			if(prob(2) && health && !failed_last_breath && !isSynthetic() && !InStasis())
				if(!paralysis)
					emote("snore")

		//CONSCIOUS
		else if(!InStasis())
			set_stat(CONSCIOUS)
			sleeping_msg_debounce = FALSE
			willfully_sleeping = FALSE

		// Check everything else.

		//Periodically double-check embedded_flag
		if(embedded_flag && !(life_tick % 10))
			if(!embedded_needs_process())
				embedded_flag = 0

		//Resting
		if(resting)
			dizziness = max(0, dizziness - 15)
			jitteriness = max(0, jitteriness - 15)
			drowsiness = max(0, drowsiness - 5)
			adjustHalLoss(-3)
		else
			dizziness = max(0, dizziness - 3)
			jitteriness = max(0, jitteriness - 3)
			adjustHalLoss(-1)

		//Other
		handle_statuses()

		if (drowsiness)
			if (drowsiness < 0)
				drowsiness = 0
			else
				drowsiness--
				eye_blurry = max(drowsiness, eye_blurry)
				if(drowsiness > 5)
					if(prob(drowsiness/5))
						slurring += rand(1, 5)
					if(prob(3))
						make_dizzy(100 + drowsiness)
						if(!sleeping)
							emote("yawn")
					if(prob(drowsiness/10))
						eye_blind += 2

		// If you're dirty, your gloves will become dirty, too.
		if(gloves && germ_level > gloves.germ_level && prob(10))
			gloves.germ_level += 1

	return 1


/mob/living/carbon/human
	var/tmp/last_brute_overlay
	var/tmp/last_frenzy_state
	var/tmp/last_oxy_overlay

	var/list/status_overlays = null

/mob/living/carbon/human/can_update_hud()
	if((!client && !bg) || QDELETED(src))
		return FALSE
	return TRUE

// corresponds with the status overlay in hud_status.dmi
#define DRUNK_STRING "drunk"
#define BLEEDING_STRING "bleeding"

/mob/living/carbon/human/handle_regular_hud_updates()
	if(hud_updateflag) // update our mob's hud overlays, AKA what others see flaoting above our head
		handle_hud_list()

	// now handle what we see on our screen
	if(!..())
		return

	if(stat != DEAD)
		if((stat == UNCONSCIOUS && health < maxHealth / 2) || paralysis || InStasis())
			//Critical damage passage overlay
			var/severity = 0
			switch(health - maxHealth/2)
				if(-20 to -10)			severity = 1
				if(-30 to -20)			severity = 2
				if(-40 to -30)			severity = 3
				if(-50 to -40)			severity = 4
				if(-60 to -50)			severity = 5
				if(-70 to -60)			severity = 6
				if(-80 to -70)			severity = 7
				if(-90 to -80)			severity = 8
				if(-95 to -90)			severity = 9
				if(-INFINITY to -95)	severity = 10
			if(paralysis || InStasis())
				severity = max(severity, 8)
			overlay_fullscreen("crit", /obj/screen/fullscreen/crit, severity)
		else
			clear_fullscreen("crit")
			//Oxygen damage overlay
			if(getOxyLoss())
				var/severity = 0
				switch(getOxyLoss())
					if(10 to 20)		severity = 1
					if(20 to 25)		severity = 2
					if(25 to 30)		severity = 3
					if(30 to 35)		severity = 4
					if(35 to 40)		severity = 5
					if(40 to 45)		severity = 6
					if(45 to INFINITY)	severity = 7
				overlay_fullscreen("oxy", /obj/screen/fullscreen/oxy, severity)
			else
				clear_fullscreen("oxy")

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = src.getBruteLoss() + src.getFireLoss() + damageoverlaytemp
		damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
		if(hurtdamage)
			var/severity = 0
			switch(hurtdamage)
				if(10 to 25)		severity = 1
				if(25 to 40)		severity = 2
				if(40 to 55)		severity = 3
				if(55 to 70)		severity = 4
				if(70 to 85)		severity = 5
				if(85 to INFINITY)	severity = 6
			overlay_fullscreen("brute", /obj/screen/fullscreen/brute, severity)
		else
			clear_fullscreen("brute")

		if(paralysis_indicator)
			if(paralysis)
				paralysis_indicator.icon_state = "paralysis1"
			else
				paralysis_indicator.icon_state = "paralysis0"

		if(healths)
			healths.overlays.Cut()
			if (chem_effects[CE_PAINKILLER] > 100)
				healths.icon_state = "health_numb"
			else
				// Generate a by-limb health display.
				healths.icon_state = "blank"

				var/no_damage = 1
				var/trauma_val = 0 // Used in calculating softcrit/hardcrit indicators.
				if(can_feel_pain())
					trauma_val = max(shock_stage,get_shock())/(species.total_health-100)
				// Collect and apply the images all at once to avoid appearance churn.
				var/list/health_images = list()
				for(var/obj/item/organ/external/E in organs)
					if(no_damage && (E.brute_dam || E.burn_dam))
						no_damage = 0
					health_images += E.get_damage_hud_image()

				// Apply a fire overlay if we're burning.
				if(on_fire)
					var/image/burning_image = image('icons/mob/screen1_health.dmi', "burning", pixel_x = species.healths_overlay_x)
					var/midway_point = FIRE_MAX_STACKS / 2
					burning_image.color = color_rotation((midway_point - fire_stacks) * 3)
					health_images += burning_image

				// Show a general pain/crit indicator if needed.
				if(is_asystole())
					var/image/hardcrit_image = image('icons/mob/screen1_health.dmi', "hardcrit", pixel_x = species.healths_overlay_x)
					health_images += hardcrit_image
				else if(trauma_val)
					if(can_feel_pain())
						if(trauma_val > 0.7)
							var/image/softcrit_image = image('icons/mob/screen1_health.dmi', "softcrit", pixel_x = species.healths_overlay_x)
							health_images += softcrit_image
						if(trauma_val >= 1)
							var/image/hardcrit_image = image('icons/mob/screen1_health.dmi', "hardcrit", pixel_x = species.healths_overlay_x)
							health_images += hardcrit_image
				else if(no_damage)
					var/image/fullhealth_image = image('icons/mob/screen1_health.dmi', "fullhealth", pixel_x = species.healths_overlay_x)
					health_images += fullhealth_image

				healths.overlays += health_images

		//Update hunger and thirst UI less often, its not important
		if((life_tick % 3 == 0))
			if(nutrition_icon)
				var/nut_factor = max_nutrition ? Clamp(nutrition / max_nutrition, 0, 1) : 1
				var/nut_icon = 5 //5 to 0, with 5 being lowest, 0 being highest
				if(nut_factor >= CREW_NUTRITION_OVEREATEN)
					nut_icon = 0
				else if (nut_factor >= CREW_NUTRITION_FULL)
					nut_icon = 1
				else if (nut_factor >= CREW_NUTRITION_SLIGHTLYHUNGRY)
					nut_icon = 2
				else if (nut_factor >= CREW_NUTRITION_HUNGRY)
					nut_icon = 3
				else if (nut_factor >= CREW_NUTRITION_VERYHUNGRY )
					nut_icon = 4
				var/new_val = "[isSynthetic() ? "charge" : "nutrition"][nut_icon]"
				if (nutrition_icon.icon_state != new_val)
					nutrition_icon.icon_state = new_val

			if(hydration_icon)
				var/hyd_factor = max_hydration ? Clamp(hydration / max_hydration, 0, 1) : 1
				var/hyd_icon = 5
				if(hyd_factor >= CREW_HYDRATION_OVERHYDRATED)
					hyd_icon = 0
				else if(hyd_factor >= CREW_HYDRATION_HYDRATED)
					hyd_icon = 1
				else if(hyd_factor >= CREW_HYDRATION_SLIGHTLYTHIRSTY)
					hyd_icon = 2
				else if(hyd_factor >= CREW_HYDRATION_THIRSTY)
					hyd_icon = 3
				else if(hyd_factor >= CREW_HYDRATION_VERYTHIRSTY)
					hyd_icon = 4
				var/new_val = "thirst[hyd_icon]"
				if (hydration_icon.icon_state != new_val)
					hydration_icon.icon_state = new_val

			if(isSynthetic())
				var/obj/item/organ/internal/cell/IC = internal_organs_by_name[BP_CELL]
				if(istype(IC) && IC.is_usable())
					var/chargeNum = Clamp(Ceiling(IC.percent()/25), 0, 4)	//0-100 maps to 0-4, but give it a paranoid clamp just in case.
					cells.icon_state = "charge[chargeNum]"
				else
					cells.icon_state = "charge-empty"

		if(pressure)
			var/new_pressure = "pressure[pressure_alert]"
			if (pressure.icon_state != new_pressure)
				pressure.icon_state = new_pressure

		if(toxin)
			var/new_tox = (phoron_alert) ? "tox1" : "tox0"
			if (toxin.icon_state != new_tox)
				toxin.icon_state = new_tox

		if(oxygen)
			var/new_oxy = (oxygen_alert) ? "oxy1" : "oxy0"
			if (oxygen.icon_state != new_oxy)
				oxygen.icon_state = new_oxy

		if(fire)
			//fire_alert is either 0 if no alert, 1 for cold and 2 for heat.
			var/new_fire = fire_alert ? "fire[fire_alert]" : "fire0"
			if (fire.icon_state != new_fire)
				fire.icon_state = new_fire

		if(bodytemp)
			var/new_temp
			if (!species)
				switch(bodytemperature) //310.055 optimal body temp
					if(370 to INFINITY)
						new_temp = "temp4"
					if(350 to 370)
						new_temp = "temp3"
					if(335 to 350)
						new_temp = "temp2"
					if(320 to 335)
						new_temp = "temp1"
					if(300 to 320)
						new_temp = "temp0"
					if(295 to 300)
						new_temp = "temp-1"
					if(280 to 295)
						new_temp = "temp-2"
					if(260 to 280)
						new_temp = "temp-3"
					else
						new_temp = "temp-4"
			else
				//TODO: precalculate all of this stuff when the species datum is created
				var/base_temperature = species.body_temperature
				if(base_temperature == null) //some species don't have a set metabolic temperature
					base_temperature = (species.heat_level_1 + species.cold_level_1)/2

				var/temp_step
				if (bodytemperature >= base_temperature)
					temp_step = (species.heat_level_1 - base_temperature)/4

					if (bodytemperature >= species.heat_level_1)
						new_temp = "temp4"
					else if (bodytemperature >= base_temperature + temp_step*3)
						new_temp = "temp3"
					else if (bodytemperature >= base_temperature + temp_step*2)
						new_temp = "temp2"
					else if (bodytemperature >= base_temperature + temp_step*1)
						new_temp = "temp1"
					else
						new_temp = "temp0"

				else if (bodytemperature < base_temperature)
					temp_step = (base_temperature - species.cold_level_1)/4

					if (bodytemperature <= species.cold_level_1)
						new_temp = "temp-4"
					else if (bodytemperature <= base_temperature - temp_step*3)
						new_temp = "temp-3"
					else if (bodytemperature <= base_temperature - temp_step*2)
						new_temp = "temp-2"
					else if (bodytemperature <= base_temperature - temp_step*1)
						new_temp = "temp-1"
					else
						new_temp = "temp0"

			if (bodytemp.icon_state != new_temp)
				bodytemp.icon_state = new_temp

		if(client)
			var/has_drunk_status = LAZYISIN(status_overlays, DRUNK_STRING)
			if(is_drunk())
				if(!has_drunk_status)
					add_status_to_hud(DRUNK_STRING, SPAN_GOOD("You are drunk. Your words are slurred, and your movements are uncoordinated."))
			else if(has_drunk_status)
				qdel(status_overlays[DRUNK_STRING])
				status_overlays -= DRUNK_STRING

			var/has_bleeding_limb = FALSE
			var/has_bleeding_status = LAZYISIN(status_overlays, BLEEDING_STRING)
			for(var/obj/item/organ/external/damaged_limb as anything in bad_external_organs)
				if(damaged_limb.status & ORGAN_BLEEDING)
					has_bleeding_limb = TRUE
					break
			if(has_bleeding_limb)
				if(!has_bleeding_status)
					add_status_to_hud(BLEEDING_STRING, SPAN_HIGHDANGER("Blood gushes from one of your bodyparts, inspect yourself and seal the wound."))
			else if(has_bleeding_status)
				qdel(status_overlays[BLEEDING_STRING])
				status_overlays -= BLEEDING_STRING

			UNSETEMPTY(status_overlays)
		else
			for(var/status in status_overlays)
				qdel(status_overlays[status])
			status_overlays = null
	return 1

#undef DRUNK_STRING
#undef BLEEDING_STRING

/mob/living/carbon/human/proc/add_status_to_hud(var/set_overlay, var/set_status_message)
	var/obj/screen/status/new_status = new /obj/screen/status(null, ui_style2icon(client.prefs.UI_style), set_overlay, set_status_message)
	new_status.alpha = client.prefs.UI_style_alpha
	new_status.color = client.prefs.UI_style_color
	new_status.screen_loc = get_status_loc(status_overlays ? LAZYLEN(status_overlays) + 1 : 1)
	client.screen += new_status
	LAZYSET(status_overlays, set_overlay, new_status)

/mob/living/carbon/human/proc/get_status_loc(var/placement)
	var/col = ((placement - 1)%(13)) + 1
	var/coord_col = "-[col-1]"
	var/coord_col_offset = "-[4+2*col]"

	var/row = round((placement-1)/13)
	var/coord_row = "[-1 - row]"
	var/coord_row_offset = 8
	return "EAST[coord_col]:[coord_col_offset],NORTH[coord_row]:[coord_row_offset]"

/mob/living/carbon/human/handle_random_events()
	if(InStasis())
		return

	// Puke if toxloss is too high
	if(!stat)
		if (getToxLoss() >= 45 && !lastpuke)
			if (prob(3))
				delayed_vomit()
			else if (prob(1))
				vomit()

	//0.1% chance of playing a scary sound to someone who's in complete darkness
	if(isturf(loc) && rand(1,1000) == 1)
		var/turf/T = loc
		if (T.get_lumcount() < 0.01)	// give a little bit of tolerance for near-dark areas.
			playsound_simple(null, pick(scarySounds), 50, TRUE)

		if(HAS_TRAIT(src, TRAIT_ORIGIN_DARK_AFRAID))
			if(T.get_lumcount() < 0.1)
				if(prob(2))
					var/list/assunzione_messages = list(
						"You feel a bit afraid...",
						"You feel somewhat nervous...",
						"You could use a little light here...",
						"Ennoia be with you, it's a bit too dark..."
					)
					to_chat(src, SPAN_WARNING(pick(assunzione_messages)))

		if(HAS_TRAIT(src, TRAIT_ORIGIN_LIGHT_SENSITIVE))
			if(T.get_lumcount() > 0.8)
				if(prob(1))
					if(prob(5))
						var/list/eye_sensitivity_messages = list(
							"Your eyes tire a bit.",
							"Your eyes sting a little.",
							"Your vision feels a bit strained."
						)
						to_chat(src, SPAN_WARNING(pick(eye_sensitivity_messages)))

/mob/living/carbon/human/proc/handle_changeling()
	if(mind)
		var/datum/changeling/changeling = mind.antag_datums[MODE_CHANGELING]
		if(changeling)
			changeling.regenerate()

/mob/living/carbon/human/proc/handle_shock()
	if(status_flags & GODMODE)
		return 0
	var/is_asystole = is_asystole()
	if(is_asystole && isSynthetic())
		if(!lying && !buckled_to)
			to_chat(src, SPAN_WARNING("You don't have enough energy to function!"))
		Paralyse(3)
		return
	if(!can_feel_pain())
		if(isSynthetic() &&(get_total_health() < maxHealth * 0.5))
			stuttering = max(stuttering, 5)
		return

	if(is_asystole)
		shock_stage = max(shock_stage + 1, 61)

	var/traumatic_shock = get_shock()
	if(traumatic_shock >= max(30, 0.8*shock_stage))
		shock_stage += 1
	else if (!is_asystole)
		shock_stage = min(shock_stage, 160)
		var/recovery = 1
		if(traumatic_shock < 0.5 * shock_stage) //lower shock faster if pain is gone completely
			recovery++
		if(traumatic_shock < 0.25 * shock_stage)
			recovery++
		shock_stage = max(shock_stage - recovery, 0)
		return

	if(stat)
		return 0

	if(shock_stage == 10)
		custom_pain("[pick(species.pain_messages)]!", 10, nohalloss = TRUE)

	if(shock_stage >= 30)
		if(shock_stage == 30)
			visible_message("<b>[src]</b> is having trouble keeping [get_pronoun("his")] eyes open.")
		if(prob(30))
			eye_blurry = max(2, eye_blurry)
			stuttering = max(stuttering, 5)

	if(shock_stage == 40)
		custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!", 40, nohalloss = TRUE)

	if (shock_stage >= 60)
		if(shock_stage == 60)
			visible_message("<b>[src]</b>'s body becomes limp.", SPAN_DANGER("Your body becomes limp."))
		if (prob(2))
			custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!", shock_stage, nohalloss = TRUE)
			Weaken(20)

	if(shock_stage >= 80)
		if (prob(5))
			custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!", shock_stage, nohalloss = TRUE)
			Weaken(20)

	if(shock_stage >= 120)
		if (prob(2))
			custom_pain("[pick("You black out", "You feel like you could die any moment now", "You're about to lose consciousness")]!", shock_stage, nohalloss = TRUE)
			Paralyse(5)

	if(shock_stage == 150)
		visible_message("<b>[src]</b> can no longer stand, collapsing!")
		Weaken(20)

	if(shock_stage >= 150)
		Weaken(20)


/*
	Called by life(), instead of having the individual hud items update icons each tick and check for status changes
	we only set those statuses and icons upon changes.  Then those HUD items will simply add those pre-made images.
	This proc below is only called when those HUD elements need to change as determined by the mobs hud_updateflag.
*/


/mob/living/carbon/human/proc/handle_hud_list(var/force_update = FALSE)
	if(force_update)
		hud_updateflag = 1022

	if (BITTEST(hud_updateflag, HEALTH_HUD))
		if(hud_list[HEALTH_HUD])
			var/image/holder = hud_list[HEALTH_HUD]
			if(stat == DEAD || (status_flags & FAKEDEATH))
				holder.icon_state = "0" 	// X_X
			else if(is_asystole())
				holder.icon_state = "flatline"
			else
				holder.icon_state = "[pulse()]"
			hud_list[HEALTH_HUD] = holder
		if(hud_list[TRIAGE_HUD])
			var/image/holder = hud_list[TRIAGE_HUD]
			holder.icon_state = triage_tag
			hud_list[TRIAGE_HUD] = holder

	if (BITTEST(hud_updateflag, LIFE_HUD) && hud_list[LIFE_HUD])
		var/image/holder = hud_list[LIFE_HUD]
		if(stat == DEAD || (status_flags & FAKEDEATH))
			holder.icon_state = "huddead"
		else
			holder.icon_state = "hudhealthy"
		hud_list[LIFE_HUD] = holder

	if (BITTEST(hud_updateflag, STATUS_HUD) && hud_list[STATUS_HUD] && hud_list[STATUS_HUD_OOC])
		var/image/holder = hud_list[STATUS_HUD]
		if(stat == DEAD || (status_flags & FAKEDEATH))
			holder.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder.icon_state = "hudxeno"
		else
			holder.icon_state = "hudhealthy"

		var/image/holder2 = hud_list[STATUS_HUD_OOC]
		if(stat == DEAD || (status_flags & FAKEDEATH))
			holder2.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder2.icon_state = "hudxeno"
		else if(has_brain_worms())
			holder2.icon_state = "hudbrainworm"
		else
			holder2.icon_state = "hudhealthy"

		hud_list[STATUS_HUD] = holder
		hud_list[STATUS_HUD_OOC] = holder2

	if (BITTEST(hud_updateflag, ID_HUD) && hud_list[ID_HUD])
		var/image/holder = hud_list[ID_HUD]

		//The following function is found in code/defines/procs/hud.dm
		holder.icon_state = get_sec_hud_icon(src)
		hud_list[ID_HUD] = holder

	if (BITTEST(hud_updateflag, WANTED_HUD))
		var/image/holder = hud_list[WANTED_HUD]
		holder.icon_state = "hudblank"
		var/perpname = name
		if(wear_id)
			var/obj/item/card/id/I = wear_id.GetID()
			if(I)
				perpname = I.registered_name

		var/datum/record/general/R = SSrecords.find_record("name", perpname)
		if(istype(R) && istype(R.security))
			if(R.security.criminal == "*Arrest*")
				holder.icon_state = "hudwanted"
			else if(R.security.criminal == "Search")
				holder.icon_state = "hudsearch"
			else if(R.security.criminal == "Incarcerated")
				holder.icon_state = "hudprisoner"
			else if(R.security.criminal == "Parolled")
				holder.icon_state = "hudparolled"
			else if(R.security.criminal == "Released")
				holder.icon_state = "hudreleased"
		hud_list[WANTED_HUD] = holder

	if (  BITTEST(hud_updateflag, IMPLOYAL_HUD) \
	   || BITTEST(hud_updateflag,  IMPCHEM_HUD) \
	   || BITTEST(hud_updateflag, IMPTRACK_HUD))

		var/image/holder1 = hud_list[IMPTRACK_HUD]
		var/image/holder2 = hud_list[IMPLOYAL_HUD]
		var/image/holder3 = hud_list[IMPCHEM_HUD]

		holder1.icon_state = "hudblank"
		holder2.icon_state = "hudblank"
		holder3.icon_state = "hudblank"
		for(var/obj/item/implant/I in src)
			if(I.implanted)
				if(istype(I,/obj/item/implant/tracking))
					holder1.icon_state = "hud_imp_tracking"
				if(istype(I,/obj/item/implant/mindshield))
					holder2.icon_state = "hud_imp_loyal"
				if(istype(I,/obj/item/implant/chem))
					holder3.icon_state = "hud_imp_chem"

		hud_list[IMPTRACK_HUD] = holder1
		hud_list[IMPLOYAL_HUD] = holder2
		hud_list[IMPCHEM_HUD]  = holder3

	if (BITTEST(hud_updateflag, SPECIALROLE_HUD))
		var/image/holder = hud_list[SPECIALROLE_HUD]
		holder.icon_state = "hudblank"
		if(mind && mind.special_role)
			if(hud_icon_reference[mind.special_role])
				holder.icon_state = hud_icon_reference[mind.special_role]
			else
				holder.icon_state = "hudsyndicate"
			hud_list[SPECIALROLE_HUD] = holder
	hud_updateflag = 0

/mob/living/carbon/human/handle_fire()
	if(..())
		return

	var/burn_temperature = fire_burn_temperature()
	var/thermal_protection = get_heat_protection(burn_temperature)

	if (thermal_protection < 1 && bodytemperature < burn_temperature)
		bodytemperature += round(BODYTEMP_HEATING_MAX*(1-thermal_protection), 1)

/mob/living/carbon/human/rejuvenate()
	restore_blood()
	..()

/mob/living/carbon/human/handle_vision()
	if(client)
		client.screen.Remove(global_hud.blurry, global_hud.druggy, global_hud.vimpaired, global_hud.darkMask, global_hud.nvg, global_hud.thermal, global_hud.meson, global_hud.science)
	if(machine)
		var/viewflags = machine.check_eye(src)
		if(viewflags < 0)
			reset_view(null, 0)
		else if(viewflags)
			set_sight(sight, viewflags)
	else if(eyeobj)
		if(eyeobj.owner != src)
			reset_view(null)
	else
		var/isRemoteObserve = 0
		if(z_eye && client?.eye == z_eye && !is_physically_disabled())
			isRemoteObserve = 1
		if(HAS_FLAG(mutations, mRemote) && remoteview_target)
			if(remoteview_target.stat==CONSCIOUS)
				isRemoteObserve = 1
		if(!isRemoteObserve && client && !client.adminobs)
			remoteview_target = null
			reset_view(null, 0)

	update_equipment_vision()
	species.handle_vision(src)

/mob/living/carbon/human/handle_hearing()
	..()

	if(ear_damage < HEARING_DAMAGE_LIMIT)
		//Hearing aids allow our ear_deaf to reach zero, if we have a hearing disability
		if(ear_deaf <= 1 && (sdisabilities & DEAF) && has_hearing_aid())
			setEarDamage(-1, max(ear_deaf-1, 0))

		var/ear_safety = get_hearing_protection()

		if(ear_safety >= EAR_PROTECTION_MAJOR)	// resting your ears make them heal faster
			adjustEarDamage(-0.15, 0)
			setEarDamage(-1)
		else if(ear_safety > EAR_PROTECTION_NONE)
			adjustEarDamage(-0.10, 0)
		else if(ear_damage < HEARING_DAMAGE_SLOW_HEAL)	//ear damage heals slowly under this threshold. otherwise you'll need earmuffs
			adjustEarDamage(-0.05, 0)

/mob/living/carbon/human/update_sight()
	..()
	if(stat == DEAD)
		return
	if(HAS_FLAG(mutations, XRAY))
		set_sight(sight|SEE_TURFS|SEE_MOBS|SEE_OBJS)

/mob/living/carbon/human/proc/handle_stamina()
	if (species.stamina == -1) //If species stamina is -1, it has special mechanics which will be handled elsewhere
		return //so quit this function

	if (!exhaust_threshold) // Also quit if there's no exhaust threshold specified, because division by 0 is amazing.
		return

	var/shock = get_shock() // used again later for stamina regeneration
	if (failed_last_breath || (getOxyLoss() + shock) > exhaust_threshold)//Can't catch our breath if we're suffocating
		flash_pain(getOxyLoss()/2)
		return

	if (nutrition <= 0)
		if (prob(1.5))
			to_chat(src, SPAN_WARNING("You feel hungry and exhausted, eat something to regain your energy!"))
		return

	if (hydration <= 0)
		if (prob(1.5))
			to_chat(src, SPAN_WARNING("You feel thirsty and exhausted, drink something to regain your energy!"))
		return

	if (stamina != max_stamina)
		//Any suffocation damage slows stamina regen.
		//This includes oxyloss from low blood levels
		var/regen = stamina_recovery * (1 - min(((getOxyLoss()) / exhaust_threshold) + (shock / exhaust_threshold), 1))
		if(is_drowsy())
			regen *= 0.85
		if (regen > 0)
			stamina = min(max_stamina, stamina+regen)
			adjustNutritionLoss(stamina_recovery*0.09)
			adjustHydrationLoss(stamina_recovery*0.32)
			if (client)
				hud_used.move_intent.update_move_icon(src)

/mob/living/carbon/human/proc/update_oxy_overlay()
	var/new_oxy
	if(getOxyLoss())
		var/severity = 0
		switch(getOxyLoss())
			if(10 to 20)		severity = 1
			if(20 to 25)		severity = 2
			if(25 to 30)		severity = 3
			if(30 to 35)		severity = 4
			if(35 to 40)		severity = 5
			if(40 to 45)		severity = 6
			if(45 to INFINITY)	severity = 7
		new_oxy = "oxydamageoverlay[severity]"

		if(new_oxy != last_oxy_overlay)
			damageoverlay.cut_overlay(last_oxy_overlay)
			damageoverlay.add_overlay(new_oxy)
			last_oxy_overlay = new_oxy
	else if (last_oxy_overlay)
		damageoverlay.cut_overlay(last_oxy_overlay)
		last_oxy_overlay = null

//Fevers
//This handles infection fevers as well as fevers caused by chem effects
/mob/living/carbon/human/proc/handle_fever()
	var/normal_temp = species?.body_temperature || (T0C+37)
	//If we have infections, they give us a fever. Get all of their germ levels and find what our bodytemp will raise by.
	var/fever = get_infection_germ_level() / INFECTION_LEVEL_ONE
	//See what chemicals in our body affect our fever for better or worse
	if(CE_FEVER in chem_effects)
		fever += chem_effects[CE_FEVER]
	if(CE_NOFEVER in chem_effects)
		fever -= chem_effects[CE_NOFEVER]

	//Apply changes to body temp. I absolutely hate body temp code -Doxx
	if(fever < 0) //If we have enough anti-fever meds to bring us back towards normal temperature, do so.
		if(bodytemperature >= normal_temp)  //We don't have any effect if we're colder than normal.
			bodytemperature = max(bodytemperature + fever, normal_temp)
		return
	if(fever > 0) //We're getting a fever, raise body temp. 10C above normal is our max for fevers.
		if(bodytemperature < normal_temp) //If we're colder than usual, we'll slowly raise to normal temperature
			bodytemperature = min(bodytemperature + fever, normal_temp)
		else if(bodytemperature <= normal_temp + 10) //If we're hotter than max due to like, being on fire, don't keep increasing.
			bodytemperature = normal_temp + min(fever, 10) //We use normal_temp here to maintain a steady temperature, otherwise even a small infection steadily increases bodytemp to max. This way it's easier to diagnose the intensity of an infection based on how bad the fever is.
	//Apply side effects for having a fever. Separate from body temp changes.
	if(fever >= 2)
		do_fever_effects(fever)


//Getting the total germ level for all infected organs, affects fever
/mob/living/carbon/human/proc/get_infection_germ_level()
	var/germs
	for(var/obj/item/organ/I in internal_organs)
		if(I.is_infected())
			germs += I.germ_level
	for(var/obj/item/organ/external/E in organs)
		if(E.is_infected())
			germs += E.germ_level
	return germs

/mob/living/carbon/human/proc/do_fever_effects(var/fever)
	if(prob(20/3)) // every 30 seconds, roughly
		to_chat(src, SPAN_WARNING(pick("You feel cold and clammy...", "You shiver as if a breeze has passed through.", "Your muscles ache.", "You feel tired and fatigued.")))
	if(prob(25)) // once every 8 seconds, roughly
		drowsiness += 5
	if(prob(20))
		adjustHalLoss(5 * min(fever, 5)) // muscle pain from fever
	if(fever >= 7 && prob(10)) // your organs are boiling, figuratively speaking
		var/obj/item/organ/internal/IO = pick(internal_organs)
		IO.take_internal_damage(1)
