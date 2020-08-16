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

	//No need to update all of these procs if the guy is dead.
	if(stat != DEAD)
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

		//Handles regenerating stamina if we have sufficient air and no oxyloss
		handle_stamina()

		if (is_diona())
			diona_handle_light(DS)

		handle_shared_dreaming()

	if(!handle_some_updates())
		return											//We go ahead and process them 5 times for HUD images and other stuff though.

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	if(mind && mind.vampire)
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

// Calculate how vulnerable the human is to under- and overpressure.
// Returns 0 (equals 0 %) if sealed in an undamaged suit, 1 if unprotected (equals 100%).
// Suitdamage can modifiy this in 10% steps.
/mob/living/carbon/human/get_pressure_weakness()
	var/pressure_adjustment_coefficient = 1 // Assume no protection at first.

	if(wear_suit && (wear_suit.item_flags & STOPPRESSUREDAMAGE) && head && (head.item_flags & STOPPRESSUREDAMAGE)) // Complete set of pressure-proof suit worn, assume fully sealed.
		pressure_adjustment_coefficient = 0

		// Handles breaches in your space suit. 10 suit damage equals a 100% loss of pressure protection.
		if(istype(wear_suit,/obj/item/clothing/suit/space))
			var/obj/item/clothing/suit/space/S = wear_suit
			if(S.can_breach && S.damage)
				pressure_adjustment_coefficient += S.damage * 0.1

	pressure_adjustment_coefficient = min(1,max(pressure_adjustment_coefficient,0)) // So it isn't less than 0 or larger than 1.

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

	if (disabilities & TOURETTES)
		speech_problem_flag = 1
		if ((prob(10) && paralysis <= 1))
			Stun(10)
			spawn( 0 )
				switch(rand(1, 3))
					if(1)
						emote("twitch")
					if(2 to 3)
						say("[prob(50) ? ";" : ""][pick("SHIT", "PISS", "FUCK", "CUNT", "COCKSUCKER", "MOTHERFUCKER", "TITS")]")
				var/old_x = pixel_x
				var/old_y = pixel_y
				pixel_x += rand(-2,2)
				pixel_y += rand(-1,1)
				sleep(2)
				pixel_x = old_x
				pixel_y = old_y
				return
	if (disabilities & STUTTERING)
		speech_problem_flag = 1
		if (prob(10))
			stuttering = max(10, stuttering)

/mob/living/carbon/human/handle_mutations_and_radiation()
	if(InStasis())
		return

	if(getFireLoss())
		if((COLD_RESISTANCE in mutations) || (prob(1)))
			heal_organ_damage(0,1)

	// DNA2 - Gene processing.
	// The HULK stuff that was here is now in the hulk gene.
	for(var/datum/dna/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			speech_problem_flag = 1
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

	// +/- 50 degrees from 310.15K is the 'safe' zone, where no damage is dealt.
	if(bodytemperature >= species.heat_level_1)
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

	else if(bodytemperature <= species.cold_level_1)
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
		take_overall_damage(brute=pressure_damage, used_weapon = "High Pressure")
		pressure_alert = 2
	else if(adjusted_pressure >= species.warning_high_pressure)
		pressure_alert = 1
	else if(adjusted_pressure >= species.warning_low_pressure)
		pressure_alert = 0
	else if(adjusted_pressure >= species.hazard_low_pressure)
		pressure_alert = -1
	else
		if(!(COLD_RESISTANCE in mutations))
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

/mob/living/carbon/human/proc/stabilize_body_temperature()
	if (species.passive_temp_gain) // We produce heat naturally.
		bodytemperature += species.passive_temp_gain
	if (species.body_temperature == null)
		return //this species doesn't have metabolic thermoregulation

	var/body_temperature_difference = species.body_temperature - bodytemperature

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
		//We totally need a sweat system cause it totally makes sense...~
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
	if(COLD_RESISTANCE in mutations)
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
			var/nausea = chem_effects[CE_EMETIC]
			if(CE_ANTIEMETIC in chem_effects)
				nausea -= min(nausea, chem_effects[CE_ANTIEMETIC]) // so it can only go down to 0
			if(prob(nausea))
				delayed_vomit()

		if(CE_FEVER in chem_effects)
			var/normal_temp = species?.body_temperature || (T0C+37)
			var/fever = chem_effects[CE_FEVER]
			if(CE_NOFEVER in chem_effects)
				fever -= chem_effects[CE_NOFEVER] // a dose of 16u Perconol should offset a stage 4 virus
			bodytemperature = Clamp(bodytemperature+fever, normal_temp, normal_temp + 9) // temperature should range from 37C to 46C, 98.6F to 115F
			if(fever > 1)
				if(prob(20/3)) // every 30 seconds, roughly
					to_chat(src, SPAN_WARNING(pick("You feel cold and clammy...", "You shiver as if a breeze has passed through.", "Your muscles ache.", "You feel tired and fatigued.")))
				if(prob(20)) // once every 10 seconds, roughly
					drowsyness += 4
				if(prob(20))
					adjustHalLoss(15) // muscle pain from fever
			if(fever >= 5) // your organs are boiling, figuratively speaking
				var/obj/item/organ/internal/IO = pick(internal_organs)
				IO.take_internal_damage(1)

		var/total_phoronloss = 0
		for(var/obj/item/I in src)
			if(I.contaminated && !(isvaurca(src) && src.species.has_organ["filtration bit"]))
				total_phoronloss += vsc.plc.CONTAMINATION_LOSS
		if(!(status_flags & GODMODE)) adjustToxLoss(total_phoronloss)

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

	updatehealth()

	return //TODO: DEFERRED

/mob/living/carbon/human/handle_regular_status_updates()
	if(!handle_some_updates())
		return 0

	if(status_flags & GODMODE)
		return 0

	//SSD check, if a logged player is awake put them back to sleep!
	if(species.show_ssd && (!client && !vr_mob) && !teleop)
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

		if(hallucination && !(species.flags & (NO_POISON|IS_PLANT)))
			handle_hallucinations()

		if(get_shock() >= (species.total_health * 0.75))
			if(!stat)
				to_chat(src, "<span class='warning'>[species.halloss_message_self]</span>")
				src.visible_message("<B>[src]</B> [species.halloss_message]")
			Paralyse(10)

		if(paralysis || sleeping || InStasis())
			blinded = TRUE
			stat = UNCONSCIOUS

			adjustHalLoss(-3)
			if (species.tail)
				animate_tail_reset()

		if(paralysis)
			AdjustParalysis(-1)

		else if(sleeping)
			speech_problem_flag = 1
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
			stat = CONSCIOUS
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
			adjustHalLoss(-3)
		else
			dizziness = max(0, dizziness - 3)
			jitteriness = max(0, jitteriness - 3)
			adjustHalLoss(-1)

		//Other
		handle_statuses()

		if (drowsyness)
			if (drowsyness < 0)
				drowsyness = 0
			else
				drowsyness--
				eye_blurry = max(2, eye_blurry)
				if (prob(5))
					sleeping += 1
					Paralyse(5)

		// If you're dirty, your gloves will become dirty, too.
		if(gloves && germ_level > gloves.germ_level && prob(10))
			gloves.germ_level += 1

	return 1


/mob/living/carbon/human
	var/tmp/last_brute_overlay
	var/tmp/last_frenzy_state
	var/tmp/last_oxy_overlay

/mob/living/carbon/human/handle_regular_hud_updates()
	if(hud_updateflag) // update our mob's hud overlays, AKA what others see flaoting above our head
		handle_hud_list()

	// now handle what we see on our screen
	if(!..())
		return

	if(stat != DEAD)
		if(stat == UNCONSCIOUS && health < maxHealth/2)
			var/ovr
			var/severity
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
			ovr = "passage[severity]"

			if (ovr != last_brute_overlay)
				damageoverlay.cut_overlay(last_brute_overlay)
				damageoverlay.add_overlay(ovr)
				last_brute_overlay = ovr
		else
			update_oxy_overlay()

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = src.getBruteLoss() + src.getFireLoss() + damageoverlaytemp
		damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
		var/ovr
		if(hurtdamage)
			switch(hurtdamage)
				if(10 to 25)
					ovr = "brutedamageoverlay1"
				if(25 to 40)
					ovr = "brutedamageoverlay2"
				if(40 to 55)
					ovr = "brutedamageoverlay3"
				if(55 to 70)
					ovr = "brutedamageoverlay4"
				if(70 to 85)
					ovr = "brutedamageoverlay5"
				if(85 to INFINITY)
					ovr = "brutedamageoverlay6"

		if(last_brute_overlay != ovr)
			damageoverlay.cut_overlay(last_brute_overlay)
			damageoverlay.add_overlay(ovr)
			last_brute_overlay = ovr

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
					health_images += image('icons/mob/screen1_health.dmi',"burning")

				// Show a general pain/crit indicator if needed.
				if(is_asystole())
					health_images += image('icons/mob/screen1_health.dmi',"hardcrit")
				else if(trauma_val)
					if(can_feel_pain())
						if(trauma_val > 0.7)
							health_images += image('icons/mob/screen1_health.dmi',"softcrit")
						if(trauma_val >= 1)
							health_images += image('icons/mob/screen1_health.dmi',"hardcrit")
				else if(no_damage)
					health_images += image('icons/mob/screen1_health.dmi',"fullhealth")

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
				var/new_val = "nutrition[nut_icon]"
				if (nutrition_icon.icon_state != new_val)
					nutrition_icon.icon_state = new_val
			if(hydration_icon)
				var/hyd_factor = max(0,min(hydration / max_hydration,1))
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

	return 1

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

/mob/living/carbon/human/proc/handle_changeling()
	if(mind && mind.changeling)
		mind.changeling.regenerate()

/mob/living/carbon/human/proc/handle_shock()
	if(status_flags & GODMODE)
		return 0
	if(!can_feel_pain())
		return

	if(is_asystole())
		shock_stage = max(shock_stage + 1, 61)

	var/traumatic_shock = get_shock()
	if(traumatic_shock >= max(30, 0.8*shock_stage))
		shock_stage += 1
	else if (!is_asystole())
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
			visible_message("<b>[src]</b> is having trouble keeping \his eyes open.")
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


/mob/living/carbon/human/proc/handle_hud_list()
	if (BITTEST(hud_updateflag, HEALTH_HUD) && hud_list[HEALTH_HUD])
		var/image/holder = hud_list[HEALTH_HUD]
		if(stat == DEAD)
			holder.icon_state = "0" 	// X_X
		else if(is_asystole())
			holder.icon_state = "flatline"
		else
			holder.icon_state = "[pulse()]"
		hud_list[HEALTH_HUD] = holder

	if (BITTEST(hud_updateflag, LIFE_HUD) && hud_list[LIFE_HUD])
		var/image/holder = hud_list[LIFE_HUD]
		if(stat == DEAD)
			holder.icon_state = "huddead"
		else
			holder.icon_state = "hudhealthy"
		hud_list[LIFE_HUD] = holder

	if (BITTEST(hud_updateflag, STATUS_HUD) && hud_list[STATUS_HUD] && hud_list[STATUS_HUD_OOC])
		var/image/holder = hud_list[STATUS_HUD]
		if(stat == DEAD)
			holder.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder.icon_state = "hudxeno"
		else
			holder.icon_state = "hudhealthy"

		var/image/holder2 = hud_list[STATUS_HUD_OOC]
		if(stat == DEAD)
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

/mob/living/carbon/human/handle_silent()
	if(..())
		speech_problem_flag = 1
	return silent

/mob/living/carbon/human/handle_slurring()
	if(..())
		speech_problem_flag = 1
	return slurring

/mob/living/carbon/human/handle_stunned()
	if(!can_feel_pain())
		stunned = 0
		return 0
	if(..())
		speech_problem_flag = 1
	return stunned

/mob/living/carbon/human/handle_stuttering()
	if(..())
		speech_problem_flag = 1
	return stuttering

/mob/living/carbon/human/handle_tarded()
	if(..())
		speech_problem_flag = 1
	return tarded

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
			sight |= viewflags
	else if(eyeobj)
		if(eyeobj.owner != src)
			reset_view(null)
	else
		var/isRemoteObserve = 0
		if((mRemote in mutations) && remoteview_target)
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

		if(istype(l_ear, /obj/item/clothing/ears/earmuffs) || istype(r_ear, /obj/item/clothing/ears/earmuffs))	//resting your ears with earmuffs heals ear damage faster
			adjustEarDamage(-0.15, 0)
			setEarDamage(-1, max(ear_deaf, 1))
		else if(ear_damage < HEARING_DAMAGE_SLOW_HEAL)	//ear damage heals slowly under this threshold. otherwise you'll need earmuffs
			adjustEarDamage(-0.05, 0)

/mob/living/carbon/human/update_sight()
	..()
	if(stat == DEAD)
		return
	if(XRAY in mutations)
		sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS

/mob/living/carbon/human/proc/handle_stamina()
	if (species.stamina == -1) //If species stamina is -1, it has special mechanics which will be handled elsewhere
		return //so quit this function

	if (!exhaust_threshold) // Also quit if there's no exhaust threshold specified, because division by 0 is amazing.
		return

	if (failed_last_breath || (getOxyLoss() + get_shock()) > exhaust_threshold)//Can't catch our breath if we're suffocating
		flash_pain()
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
		var/regen = stamina_recovery * (1 - min(((getOxyLoss()) / exhaust_threshold) + ((get_shock()) / exhaust_threshold), 1))
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

