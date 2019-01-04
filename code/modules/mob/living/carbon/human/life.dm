//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!
#define HUMAN_MAX_OXYLOSS 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.
#define HUMAN_CRIT_MAX_OXYLOSS ( 2.0 / 6) //The amount of damage you'll get when in critical condition. We want this to be a 5 minute deal = 300s. There are 50HP to get through, so (1/6)*last_tick_duration per second. Breaths however only happen every 4 ticks. last_tick_duration = ~2.0 on average

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
	var/in_stasis = 0
	var/heartbeat = 0

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

	in_stasis = istype(loc, /obj/structure/closet/body_bag/cryobag) && loc:opened == 0
	if(in_stasis) loc:used++

	..()

	if(life_tick%30==5)//Makes huds update every 10 seconds instead of every 30 seconds
		hud_updateflag = 1022

	voice = GetVoice()

	//No need to update all of these procs if the guy is dead.
	if(stat != DEAD && !in_stasis)
		//Updates the number of stored chemicals for powers
		handle_changeling()

		//Organs and blood
		handle_organs()
		stabilize_body_temperature() //Body temperature adjusts itself (self-regulation)

		//Random events (vomiting etc)
		handle_random_events()

		handle_shock()

		handle_pain()

		handle_medical_side_effects()

		handle_heartbeat()

		handle_brain_damage()

		//Handles regenerating stamina if we have sufficient air and no oxyloss
		handle_stamina()

		if (is_diona())
			diona_handle_light(DS)

		handle_shared_dreaming()

	handle_stasis_bag()

	if(!handle_some_updates())
		return											//We go ahead and process them 5 times for HUD images and other stuff though.

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	pulse = handle_pulse()

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
	if(!in_stasis)
		..()

// Calculate how vulnerable the human is to under- and overpressure.
// Returns 0 (equals 0 %) if sealed in an undamaged suit, 1 if unprotected (equals 100%).
// Suitdamage can modifiy this in 10% steps.
/mob/living/carbon/human/proc/get_pressure_weakness()
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
		vision =  internal_organs_by_name[species.vision_organ] || organs_by_name[species.vision_organ]

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
			src << "<span class='warning'>You have a seizure!</span>"
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
	if (disabilities & NERVOUS)
		speech_problem_flag = 1
		if (prob(10))
			stuttering = max(10, stuttering)
	// No. -- cib
	/*if (getBrainLoss() >= 60 && stat != 2)
		if (prob(3))
			switch(pick(1,2,3))
				if(1)
					say(pick("IM A PONY NEEEEEEIIIIIIIIIGH", "without oxigen blob don't evoluate?", "CAPTAINS A COMDOM", "[pick("", "that meatball traitor")] [pick("joerge", "george", "gorge", "gdoruge")] [pick("mellens", "melons", "mwrlins")] is grifing me HAL;P!!!", "can u give me [pick("telikesis","halk","eppilapse")]?", "THe saiyans screwed", "Bi is THE BEST OF BOTH WORLDS>", "I WANNA PET TEH monkeyS", "stop grifing me!!!!", "SOTP IT#"))
				if(2)
					say(pick("FUS RO DAH","fucking 4rries!", "stat me", ">my face", "roll it easy!", "waaaaaagh!!!", "red wonz go fasta", "FOR TEH EMPRAH", "lol2cat", "dem dwarfs man, dem dwarfs", "SPESS MAHREENS", "hwee did eet fhor khayosss", "lifelike texture ;_;", "luv can bloooom", "PACKETS!!!"))
				if(3)
					emote("drool")
	*/

	if(stat != DEAD)
		var/rn = rand(0, 200)
		var/bloss = getBrainLoss()
		if(bloss >= 5)
			if(0 <= rn && rn <= 3)
				custom_pain("Your head feels numb and painful.")
		if(bloss >= 15)
			if(4 <= rn && rn <= 6) if(eye_blurry <= 0)
				src << "<span class='warning'>It becomes hard to see for some reason.</span>"
				eye_blurry = 10
		if(bloss >= 35)
			if(7 <= rn && rn <= 9) if(get_active_hand())
				src << "<span class='danger'>Your hand won't respond properly, you drop what you're holding!</span>"
				drop_item()
		if(bloss >= 45)
			if(10 <= rn && rn <= 12)
				if(prob(50))
					src << "<span class='danger'>You suddenly black out!</span>"
					Paralyse(10)
				else if(!lying)
					src << "<span class='danger'>Your legs won't respond properly, you fall down!</span>"
					Weaken(10)

/mob/living/carbon/human/proc/handle_stasis_bag()
	// Handle side effects from stasis bag
	if(in_stasis)
		// First off, there's no oxygen supply, so the mob will slowly take brain damage
		adjustOxyLoss(0.1)

		// Next, the method to induce stasis has some adverse side-effects, manifesting
		// as cloneloss
		adjustCloneLoss(0.1)

/mob/living/carbon/human/handle_mutations_and_radiation()
	if(in_stasis)
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
		//var/obj/item/organ/diona/nutrients/rad_organ = locate() in internal_organs
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
					src << "<span class='warning'>You feel weak.</span>"
					Weaken(3)
					if(!lying)
						emote("collapse")
				if(prob(5) && prob(100 * RADIATION_SPEED_COEFFICIENT) && species.name == "Human") //apes go bald
					if((h_style != "Bald" || f_style != "Shaved" ))
						src << "<span class='warning'>Your hair falls out.</span>"
						h_style = "Bald"
						f_style = "Shaved"
						update_hair()

			if (total_radiation > 75)
				src.apply_radiation(-1 * RADIATION_SPEED_COEFFICIENT)
				damage = 3
				if(prob(5))
					take_overall_damage(0, 5 * RADIATION_SPEED_COEFFICIENT, used_weapon = "Radiation Burns")
				if(prob(1))
					src << "<span class='warning'>You feel strange!</span>"
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

/mob/living/carbon/human/handle_post_breath(datum/gas_mixture/breath)
	..()
	//spread some viruses while we are at it
	if(breath && virus2.len > 0 && prob(10))
		for(var/mob/living/carbon/M in view(1,src))
			src.spread_disease_to(M)


/mob/living/carbon/human/get_breath_from_internal(volume_needed=BREATH_VOLUME)
	if(internal)

		var/obj/item/weapon/tank/rig_supply
		if(istype(back,/obj/item/weapon/rig))
			var/obj/item/weapon/rig/rig = back
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

/mob/living/carbon/human/handle_breath(datum/gas_mixture/breath)
	if(status_flags & GODMODE)
		return

	//exposure to extreme pressures can rupture lungs
	if(breath && (breath.total_moles < BREATH_MOLES / 5 || breath.total_moles > BREATH_MOLES * 5))
		if(!is_lung_ruptured() && prob(5))
			rupture_lung()

	//check if we actually need to process breath
	if(!breath || (breath.total_moles == 0))
		failed_last_breath = 1
		if(health > config.health_threshold_crit)
			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
		else
			adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

		oxygen_alert = max(oxygen_alert, 1)
		return 0

	var/safe_pressure_min = species.breath_pressure // Minimum safe partial pressure of breathable gas in kPa

	// Lung damage increases the minimum safe pressure.
	var/handle_lungs = 0
	var/obj/item/organ/L = null
	if (species.breathing_organ)
		L = internal_organs_by_name[species.breathing_organ]
		handle_lungs = TRUE

	if (handle_lungs)
		if(!L)
			safe_pressure_min = INFINITY //No lungs, how are you breathing?
		else if(L.is_broken())
			safe_pressure_min *= 1.5
		else if(L.is_bruised())
			safe_pressure_min *= 1.25

	var/safe_exhaled_max = 10
	var/safe_toxins_max = 0.2
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/inhaled_gas_used = 0

	var/breath_pressure = (breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME

	var/inhaling
	var/poison
	var/exhaling

	var/breath_type
	var/poison_type
	var/exhale_type

	var/failed_inhale = 0
	var/failed_exhale = 0

	if(species.breath_type)
		breath_type = species.breath_type
	else
		breath_type = "oxygen"

	inhaling = breath.gas[breath_type]

	if(species.poison_type)
		poison_type = species.poison_type
	else
		poison_type = "phoron"
	poison = breath.gas[poison_type]

	if(species.exhale_type)
		exhale_type = species.exhale_type
		exhaling = breath.gas[exhale_type]
	else
		exhaling = 0

	var/inhale_pp = (inhaling/breath.total_moles)*breath_pressure
	var/toxins_pp = (poison/breath.total_moles)*breath_pressure
	var/exhaled_pp = (exhaling/breath.total_moles)*breath_pressure

	// Not enough to breathe
	if(inhale_pp < safe_pressure_min)
		if(prob(20))
			spawn(0) emote("gasp")

		var/ratio = inhale_pp/safe_pressure_min
		// Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!)
		adjustOxyLoss(max(HUMAN_MAX_OXYLOSS*(1-ratio), 0))
		failed_inhale = 1

		oxygen_alert = max(oxygen_alert, 1)
	else
		// We're in safe limits
		oxygen_alert = 0

	inhaled_gas_used = inhaling/6

	breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards

	if(exhale_type)
		breath.adjust_gas_temp(exhale_type, inhaled_gas_used, bodytemperature, update = 0) //update afterwards

		// Too much exhaled gas in the air
		if(exhaled_pp > safe_exhaled_max)
			if (!co2_alert|| prob(15))
				var/word = pick("extremely dizzy","short of breath","faint","confused")
				src << "<span class='danger'>You feel [word].</span>"

			adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			co2_alert = 1
			failed_exhale = 1

		else if(exhaled_pp > safe_exhaled_max * 0.7)
			if (!co2_alert || prob(1))
				var/word = pick("dizzy","short of breath","faint","momentarily confused")
				src << "<span class='warning'>You feel [word].</span>"

			//scale linearly from 0 to 1 between safe_exhaled_max and safe_exhaled_max*0.7
			var/ratio = 1.0 - (safe_exhaled_max - exhaled_pp)/(safe_exhaled_max*0.3)

			//give them some oxyloss, up to the limit - we don't want people falling unconcious due to CO2 alone until they're pretty close to safe_exhaled_max.
			if (getOxyLoss() < 50*ratio)
				adjustOxyLoss(HUMAN_MAX_OXYLOSS)
			co2_alert = 1
			failed_exhale = 1

		else if(exhaled_pp > safe_exhaled_max * 0.6)
			if (prob(0.3))
				var/word = pick("a little dizzy","short of breath")
				src << "<span class='warning'>You feel [word].</span>"

		else
			co2_alert = 0

	// Too much poison in the air.
	if(toxins_pp > safe_toxins_max)
		var/ratio = (poison/safe_toxins_max) * 10
		if(reagents)
			reagents.add_reagent("toxin", Clamp(ratio, MIN_TOXIN_DAMAGE, MAX_TOXIN_DAMAGE))
			breath.adjust_gas(poison_type, -poison/6, update = 0) //update after
		phoron_alert = max(phoron_alert, 1)
	else
		phoron_alert = 0

	// If there's some other shit in the air lets deal with it here.
	if(breath.gas["sleeping_agent"])
		var/SA_pp = (breath.gas["sleeping_agent"] / breath.total_moles) * breath_pressure

		// Enough to make us paralysed for a bit
		if(SA_pp > SA_para_min)

			// 3 gives them one second to wake up and run away a bit!
			Paralyse(3)

			// Enough to make us sleep as well
			if(SA_pp > SA_sleep_min)
				Sleeping(5)

		// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
		else if(SA_pp > 0.15)
			if(prob(20))
				spawn(0) emote(pick("giggle", "laugh"))
		breath.adjust_gas("sleeping_agent", -breath.gas["sleeping_agent"]/6, update = 0) //update after

	// Were we able to breathe?
	if (failed_inhale || failed_exhale)
		failed_last_breath = 1
	else
		failed_last_breath = 0
		if(disabilities & ASTHMA)
			adjustOxyLoss(rand(-5,0))
		else
			adjustOxyLoss(-5)


	// Hot air hurts :(
	if((breath.temperature < species.cold_level_1 || breath.temperature > species.heat_level_1) && !(COLD_RESISTANCE in mutations))

		if(breath.temperature <= species.cold_level_1)
			if(prob(20))
				src << "<span class='danger'>You feel your face freezing and icicles forming in your lungs!</span>"
		else if(breath.temperature >= species.heat_level_1)
			if(prob(20))
				src << "<span class='danger'>You feel your face burning and a searing heat in your lungs!</span>"

		if(breath.temperature >= species.heat_level_1)
			if(breath.temperature < species.heat_level_2)
				apply_damage(HEAT_GAS_DAMAGE_LEVEL_1, BURN, "head", used_weapon = "Excessive Heat")
				fire_alert = max(fire_alert, 2)
			else if(breath.temperature < species.heat_level_3)
				apply_damage(HEAT_GAS_DAMAGE_LEVEL_2, BURN, "head", used_weapon = "Excessive Heat")
				fire_alert = max(fire_alert, 2)
			else
				apply_damage(HEAT_GAS_DAMAGE_LEVEL_3, BURN, "head", used_weapon = "Excessive Heat")
				fire_alert = max(fire_alert, 2)

		else if(breath.temperature <= species.cold_level_1)
			if(breath.temperature > species.cold_level_2)
				apply_damage(COLD_GAS_DAMAGE_LEVEL_1, BURN, "head", used_weapon = "Excessive Cold")
				fire_alert = max(fire_alert, 1)
			else if(breath.temperature > species.cold_level_3)
				apply_damage(COLD_GAS_DAMAGE_LEVEL_2, BURN, "head", used_weapon = "Excessive Cold")
				fire_alert = max(fire_alert, 1)
			else
				apply_damage(COLD_GAS_DAMAGE_LEVEL_3, BURN, "head", used_weapon = "Excessive Cold")
				fire_alert = max(fire_alert, 1)

		//breathing in hot/cold air also heats/cools you a bit
		var/temp_adj = breath.temperature - bodytemperature
		if (temp_adj < 0)
			temp_adj /= (BODYTEMP_COLD_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed
		else
			temp_adj /= (BODYTEMP_HEAT_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed

		var/relative_density = breath.total_moles / (MOLES_CELLSTANDARD * BREATH_PERCENTAGE)
		temp_adj *= relative_density

		if (temp_adj > BODYTEMP_HEATING_MAX) temp_adj = BODYTEMP_HEATING_MAX
		if (temp_adj < BODYTEMP_COOLING_MAX) temp_adj = BODYTEMP_COOLING_MAX
		bodytemperature += temp_adj

	else if(breath.temperature >= species.heat_discomfort_level)
		species.get_environment_discomfort(src,"heat")
	else if(breath.temperature <= species.cold_discomfort_level)
		species.get_environment_discomfort(src,"cold")

	breath.update_values()
	return 1

/mob/living/carbon/human/handle_environment(datum/gas_mixture/environment)
	if(!environment)
		return

	//Stuff like the xenomorph's plasma regen happens here.
	species.handle_environment_special(src)

	//Moved pressure calculations here for use in skip-processing check.
	var/pressure = environment.return_pressure()
	var/adjusted_pressure = calculate_affecting_pressure(pressure)

	if (is_diona())
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
		if(istype(loc, /obj/mecha))
			var/obj/mecha/M = loc
			loc_temp =  M.return_temperature()
		else if(istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			loc_temp = loc:air_contents.temperature
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

		if(bodytemperature < species.heat_level_2)
			take_overall_damage(burn=HEAT_DAMAGE_LEVEL_1, used_weapon = "High Body Temperature")
			fire_alert = max(fire_alert, 2)
		else if(bodytemperature < species.heat_level_3)
			take_overall_damage(burn=HEAT_DAMAGE_LEVEL_2, used_weapon = "High Body Temperature")
			fire_alert = max(fire_alert, 2)
		else
			take_overall_damage(burn=HEAT_DAMAGE_LEVEL_3, used_weapon = "High Body Temperature")
			fire_alert = max(fire_alert, 2)

	else if(bodytemperature <= species.cold_level_1)
		fire_alert = max(fire_alert, 1)
		if(status_flags & GODMODE)	return 1	//godmode

		if (is_diona() == DIONA_WORKER)
			diona_contained_cold_damage()

		if(status_flags & GODMODE)	return 1	//godmode

		if(!istype(loc, /obj/machinery/atmospherics/unary/cryo_cell))
			if(bodytemperature > species.cold_level_2)
				take_overall_damage(burn=COLD_DAMAGE_LEVEL_1, used_weapon = "High Body Temperature")
				fire_alert = max(fire_alert, 1)
			else if(bodytemperature > species.cold_level_3)
				take_overall_damage(burn=COLD_DAMAGE_LEVEL_2, used_weapon = "High Body Temperature")
				fire_alert = max(fire_alert, 1)
			else
				take_overall_damage(burn=COLD_DAMAGE_LEVEL_3, used_weapon = "High Body Temperature")
				fire_alert = max(fire_alert, 1)

	// Account for massive pressure differences.  Done by Polymorph
	// Made it possible to actually have something that can protect against high pressure... Done by Errorage. Polymorph now has an axe sticking from his head for his previous hardcoded nonsense!
	if(status_flags & GODMODE)	return 1	//godmode

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
		if( !(COLD_RESISTANCE in mutations))
			take_overall_damage(brute=LOW_PRESSURE_DAMAGE, used_weapon = "Low Pressure")
			if(getOxyLoss() < 55) // 11 OxyLoss per 4 ticks when wearing internals;    unconsciousness in 16 ticks, roughly half a minute
				adjustOxyLoss(4)  // 16 OxyLoss per 4 ticks when no internals present; unconsciousness in 13 ticks, roughly twenty seconds
			pressure_alert = -2
		else
			pressure_alert = -1

	if (is_diona())
		diona_handle_temperature(DS)

	return

/*
/mob/living/carbon/human/proc/adjust_body_temperature(current, loc_temp, boost)
	var/temperature = current
	var/difference = abs(current-loc_temp)	//get difference
	var/increments// = difference/10			//find how many increments apart they are
	if(difference > 50)
		increments = difference/5
	else
		increments = difference/10
	var/change = increments*boost	// Get the amount to change by (x per increment)
	var/temp_change
	if(current < loc_temp)
		temperature = min(loc_temp, temperature+change)
	else if(current > loc_temp)
		temperature = max(loc_temp, temperature-change)
	temp_change = (temperature - current)
	return temp_change
*/

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
	if(in_stasis)
		return

	if(reagents)
		chem_effects.Cut()
		analgesic = 0

		if(touching) touching.metabolize()
		if(ingested) ingested.metabolize()
		if(bloodstr) bloodstr.metabolize()
		if(breathing) breathing.metabolize()

		if(CE_PAINKILLER in chem_effects)
			analgesic = chem_effects[CE_PAINKILLER]

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

	if(status_flags & GODMODE)	return 0

	//SSD check, if a logged player is awake put them back to sleep!
	if(species.show_ssd && !client && !teleop)
		Sleeping(2)
	if(stat == DEAD)	//DEAD. BROWN BREAD. SWIMMING WITH THE SPESS CARP
		blinded = 1
		silent = 0
	else				//ALIVE. LIGHTS ARE ON
		updatehealth()	//TODO

		if(health <= config.health_threshold_dead || (species.has_organ["brain"] && !has_brain()))
			death()
			blinded = 1
			silent = 0
			return 1

		//UNCONSCIOUS. NO-ONE IS HOME
		if((exhaust_threshold && getOxyLoss() > exhaust_threshold) || (health <= config.health_threshold_crit))
			Paralyse(3)

		if(hallucination)
			//Machines do not hallucinate.
			if (hallucination >= 20 && !(species.flags & (NO_POISON|IS_PLANT)))
				if(prob(3))
					fake_attack(src)
				if(!handling_hal)
					spawn handle_hallucinations() //The not boring kind!
				/*if(client && prob(5))
					client.dir = pick(2,4,8)
					var/client/C = client
					spawn(rand(20,50))
						if(C)
							C.dir = 1*/	// This breaks the lighting system.

			if(hallucination<=2)
				hallucination = 0
				halloss = 0
			else
				hallucination -= 2

		else
			for(var/atom/a in hallucinations)
				qdel(a)

		if(halloss > 100)
			src << "<span class='warning'>[species.halloss_message_self]</span>"
			src.visible_message("<B>[src]</B> [species.halloss_message].")
			Paralyse(10)
			setHalLoss(99)

		if(paralysis || sleeping)
			blinded = 1
			stat = UNCONSCIOUS

			adjustHalLoss(-3)
			if (species.tail)
				animate_tail_reset()

		if(paralysis)
			AdjustParalysis(-1)

		else if(sleeping)
			speech_problem_flag = 1
			handle_dreams()
			if (mind)
				//Are they SSD? If so we'll keep them asleep but work off some of that sleep var in case of stoxin or similar.
				if(client || sleeping > 3 || istype(bg))
					AdjustSleeping(-1)
			if( prob(2) && health && !hal_crit )
				spawn(0)
					emote("snore")
		//CONSCIOUS
		else
			stat = CONSCIOUS
			willfully_sleeping = 0

		// Check everything else.

		//Periodically double-check embedded_flag
		if(embedded_flag && !(life_tick % 10))
			if(!embedded_needs_process())
				embedded_flag = 0

		//Ears
		if(sdisabilities & DEAF)	//disabled-deaf, doesn't get better on its own
			ear_deaf = max(ear_deaf, 1)
		else if(ear_deaf)			//deafness, heals slowly over time
			ear_deaf = max(ear_deaf-1, 0)
		else if(istype(l_ear, /obj/item/clothing/ears/earmuffs) || istype(r_ear, /obj/item/clothing/ears/earmuffs))	//resting your ears with earmuffs heals ear damage faster
			ear_damage = max(ear_damage-0.15, 0)
			ear_deaf = max(ear_deaf, 1)
		else if(ear_damage < 25)	//ear damage heals slowly under this threshold. otherwise you'll need earmuffs
			ear_damage = max(ear_damage-0.05, 0)

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

		confused = max(0, confused - 1)

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

	if(stat == UNCONSCIOUS)
		//Critical damage passage overlay
		if(health <= 0)
			var/ovr = "passage0"
			switch(health)
				if(-20 to -10)
					ovr = "passage1"
				if(-30 to -20)
					ovr = "passage2"
				if(-40 to -30)
					ovr = "passage3"
				if(-50 to -40)
					ovr = "passage4"
				if(-60 to -50)
					ovr = "passage5"
				if(-70 to -60)
					ovr = "passage6"
				if(-80 to -70)
					ovr = "passage7"
				if(-90 to -80)
					ovr = "passage8"
				if(-95 to -90)
					ovr = "passage9"
				if(-INFINITY to -95)
					ovr = "passage10"

			if (ovr != last_brute_overlay)
				damageoverlay.cut_overlay(last_brute_overlay)
				damageoverlay.add_overlay(ovr)
				last_brute_overlay = ovr
	else
		//Oxygen damage overlay
		update_oxy_overlay()

		// Vampire frenzy overlay.
		if (mind.vampire)
			if (mind.vampire.status & VAMP_FRENZIED)
				if (!last_frenzy_state)
					damageoverlay.add_overlay("frenzyoverlay")
					last_frenzy_state = TRUE
			else if (last_frenzy_state)
				damageoverlay.cut_overlay("frenzyoverlay")
				last_frenzy_state = FALSE
		else if (last_frenzy_state)
			damageoverlay.cut_overlay("frenzyoverlay")
			last_frenzy_state = FALSE

		//Fire and Brute damage overlay (BSSR)
		var/hurtdamage = src.getBruteLoss() + src.getFireLoss() + damageoverlaytemp
		damageoverlaytemp = 0 // We do this so we can detect if someone hits us or not.
		if(hurtdamage)
			var/ovr
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

			if (last_brute_overlay != ovr)
				damageoverlay.cut_overlay(last_brute_overlay)
				damageoverlay.add_overlay(ovr)
				last_brute_overlay = ovr
		else if (last_brute_overlay)
			damageoverlay.cut_overlay(last_brute_overlay)
			last_brute_overlay = null

		update_health_display()

		//Update hunger and thirst UI less often, its not important
		if((life_tick % 3 == 0))
			if(nutrition_icon)
				var/nut_factor = max(0,min(nutrition / max_nutrition,1))
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
			var/new_tox = (hal_screwyhud == 4 || phoron_alert) ? "tox1" : "tox0"
			if (toxin.icon_state != new_tox)
				toxin.icon_state = new_tox

		if(oxygen)
			var/new_oxy = (hal_screwyhud == 3 || oxygen_alert) ? "oxy1" : "oxy0"
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
	if(in_stasis)
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
		if(T.get_lumcount() < 0.01)	// give a little bit of tolerance for near-dark areas.
			playsound_local(src,pick(scarySounds),50, 1, -1)

/mob/living/carbon/human/proc/handle_changeling()
	if(mind && mind.changeling)
		mind.changeling.regenerate()

/mob/living/carbon/human/handle_shock()
	..()
	if(status_flags & GODMODE)	return 0	//godmode
	if(species && species.flags & NO_PAIN) return

	if(health < config.health_threshold_softcrit)// health 0 makes you immediately collapse
		shock_stage = max(shock_stage, 61)

	if(traumatic_shock >= 80)
		shock_stage += 1
	else if(health < config.health_threshold_softcrit)
		shock_stage = max(shock_stage, 61)
	else
		shock_stage = min(shock_stage, 160)
		shock_stage = max(shock_stage-1, 0)
		return

	if(shock_stage == 10)
		src << "<span class='danger'>[pick("It hurts so much", "You really need some painkillers", "Dear god, the pain")]!</span>"

	if(shock_stage >= 30)
		if(shock_stage == 30) emote("me",1,"is having trouble keeping their eyes open.")
		eye_blurry = max(2, eye_blurry)
		stuttering = max(stuttering, 5)

	if(shock_stage == 40)
		src << "<span class='danger'>[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!</span>"

	if (shock_stage >= 60)
		if(shock_stage == 60) emote("me",1,"'s body becomes limp.")
		if (prob(2))
			src << "<span class='danger'>[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!</span>"
			Weaken(20)

	if(shock_stage >= 80)
		if (prob(5))
			src << "<span class='danger'>[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!</span>"
			Weaken(20)

	if(shock_stage >= 120)
		if (prob(2))
			src << "<span class='danger'>[pick("You black out", "You feel like you could die any moment now", "You're about to lose consciousness")]!</span>"
			Paralyse(5)

	if(shock_stage == 150)
		emote("me",1,"can no longer stand, collapsing!")
		Weaken(20)

	if(shock_stage >= 150)
		Weaken(20)

/mob/living/carbon/human/proc/handle_pulse()
	if(life_tick % 5) return pulse	//update pulse every 5 life ticks (~1 tick/sec, depending on server load)

	if(species && species.flags & NO_BLOOD)
		return PULSE_NONE //No blood, no pulse.

	if(stat == DEAD)
		return PULSE_NONE	//that's it, you're dead, nothing can influence your pulse

	var/temp = PULSE_NORM

	if(round(vessel.get_reagent_amount("blood")) <= BLOOD_VOLUME_BAD)	//how much blood do we have
		temp = PULSE_THREADY	//not enough :(

	if(status_flags & FAKEDEATH)
		temp = PULSE_NONE		//pretend that we're dead. unlike actual death, can be inflienced by meds

	//handles different chems' influence on pulse
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.id in bradycardics)
			if(temp <= PULSE_THREADY && temp >= PULSE_NORM)
				temp--
		if(R.id in tachycardics)
			if(temp <= PULSE_FAST && temp >= PULSE_NONE)
				temp++
		if(R.id in heartstopper) //To avoid using fakedeath
			var/obj/item/organ/heart/H = internal_organs_by_name["heart"]
			if(rand(0,6) == 3)
				H.take_damage(5)
		if(R.id in cheartstopper) //Conditional heart-stoppage
			if(R.volume >= R.overdose)
				var/obj/item/organ/heart/H = internal_organs_by_name["heart"]
				if(rand(0,6) == 3)
					H.take_damage(5)

	return temp

/mob/living/carbon/human/proc/handle_heartbeat()
	if(pulse == PULSE_NONE || !species.has_organ["heart"])
		return

	var/obj/item/organ/heart/H = internal_organs_by_name["heart"]

	if(!H || H.robotic >=2 )
		return

	if(pulse >= PULSE_2FAST || shock_stage >= 10 || istype(get_turf(src), /turf/space))
		//PULSE_THREADY - maximum value for pulse, currently it 5.
		//High pulse value corresponds to a fast rate of heartbeat.
		//Divided by 2, otherwise it is too slow.
		var/rate = (PULSE_THREADY - pulse)/2

		if(heartbeat >= rate)
			heartbeat = 0
			src << sound('sound/effects/singlebeat.ogg',0,0,0,50)
		else
			heartbeat++

/*
	Called by life(), instead of having the individual hud items update icons each tick and check for status changes
	we only set those statuses and icons upon changes.  Then those HUD items will simply add those pre-made images.
	This proc below is only called when those HUD elements need to change as determined by the mobs hud_updateflag.
*/


/mob/living/carbon/human/proc/handle_hud_list()
	if (BITTEST(hud_updateflag, HEALTH_HUD) && hud_list[HEALTH_HUD])
		var/image/holder = hud_list[HEALTH_HUD]
		if(stat == DEAD)
			holder.icon_state = "hudhealth-100" 	// X_X
		else
			var/percentage_health = RoundHealth((health-config.health_threshold_crit)/(maxHealth-config.health_threshold_crit)*100)

			if (percentage_health == "health100" && holder.icon_state && holder.icon_state != "hudhealth100" && holder.icon_state != "hudhealth100a")
				holder.icon_state = "hudhealth100a"
				spawn(30)//just to prevent any issues with the animation, we'll set it to the normal state after 3 seconds
					percentage_health = RoundHealth((health-config.health_threshold_crit)/(maxHealth-config.health_threshold_crit)*100)
					if (percentage_health == "health100")
						holder.icon_state = "hudhealth100"
			else
				holder.icon_state = "hud[percentage_health]"
		hud_list[HEALTH_HUD] = holder

	if (BITTEST(hud_updateflag, LIFE_HUD) && hud_list[LIFE_HUD])
		var/image/holder = hud_list[LIFE_HUD]
		if(stat == DEAD)
			holder.icon_state = "huddead"
		else
			holder.icon_state = "hudhealthy"
		hud_list[LIFE_HUD] = holder

	if (BITTEST(hud_updateflag, STATUS_HUD) && hud_list[STATUS_HUD] && hud_list[STATUS_HUD_OOC])
		var/foundVirus = 0
		for(var/datum/disease/D in viruses)
			if(!D.hidden[SCANNER])
				foundVirus++
		for (var/ID in virus2)
			if (ID in virusDB)
				foundVirus = 1
				break

		var/image/holder = hud_list[STATUS_HUD]
		if(stat == DEAD)
			holder.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder.icon_state = "hudxeno"
		else if(foundVirus)
			holder.icon_state = "hudill"
	/*	else if(has_brain_worms())
			var/mob/living/simple_animal/borer/B = has_brain_worms()
			if(B.controlling)
				holder.icon_state = "hudbrainworm"
			else
				holder.icon_state = "hudhealthy"*/
		else
			holder.icon_state = "hudhealthy"

		var/image/holder2 = hud_list[STATUS_HUD_OOC]
		if(stat == DEAD)
			holder2.icon_state = "huddead"
		else if(status_flags & XENO_HOST)
			holder2.icon_state = "hudxeno"
		else if(has_brain_worms())
			holder2.icon_state = "hudbrainworm"
		else if(virus2.len)
			holder2.icon_state = "hudill"
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
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				perpname = I.registered_name

		for(var/datum/data/record/E in data_core.general)
			if(E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.security)
					if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						holder.icon_state = "hudwanted"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Search"))
						holder.icon_state = "hudsearch"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Incarcerated"))
						holder.icon_state = "hudprisoner"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Parolled"))
						holder.icon_state = "hudparolled"
						break
					else if((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "Released"))
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
		for(var/obj/item/weapon/implant/I in src)
			if(I.implanted)
				if(istype(I,/obj/item/weapon/implant/tracking))
					holder1.icon_state = "hud_imp_tracking"
				if(istype(I,/obj/item/weapon/implant/loyalty))
					holder2.icon_state = "hud_imp_loyal"
				if(istype(I,/obj/item/weapon/implant/chem))
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
	if(species.flags & NO_PAIN)
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

	if (failed_last_breath || (oxyloss + halloss) > exhaust_threshold)//Can't catch our breath if we're suffocating
		flash_pain()
		return

	if (nutrition <= 0)
		if (prob(1.5))
			src << span("warning", "You feel hungry and exhausted, eat something to regain your energy!")
		return

	if (hydration <= 0)
		if (prob(1.5))
			src << span("warning", "You feel thirsty and exhausted, drink something to regain your energy!")
		return

	if (stamina != max_stamina)
		//Any suffocation damage slows stamina regen.
		//This includes oxyloss from low blood levels
		var/regen = stamina_recovery * (1 - min(((oxyloss) / exhaust_threshold) + ((halloss) / exhaust_threshold), 1))
		if (regen > 0)
			stamina = min(max_stamina, stamina+regen)
			adjustNutritionLoss(stamina_recovery*0.09)
			adjustHydrationLoss(stamina_recovery*0.32)
			if (client)
				hud_used.move_intent.update_move_icon(src)

/mob/living/carbon/human/proc/update_health_display()
	if(!healths)
		return

	var/new_state
	if (stat == DEAD)
		new_state = "health7"
	else if (analgesic > 100)
		new_state = "health_numb"
	else
		switch(hal_screwyhud)
			if(1)
				new_state = "health6"
			if(2)
				new_state = "health7"
			else
				//switch(health - halloss)
				switch(health - traumatic_shock)
					if(100 to INFINITY)
						new_state = "health0"
					if(80 to 100)
						new_state = "health1"
					if(60 to 80)
						new_state = "health2"
					if(40 to 60)
						new_state = "health3"
					if(20 to 40)
						new_state = "health4"
					if(0 to 20)
						new_state = "health5"
					else
						new_state = "health6"

	if (healths.icon_state != new_state)
		healths.icon_state = new_state

/mob/living/carbon/human/proc/update_oxy_overlay()
	var/new_oxy
	if(oxyloss)
		switch(oxyloss)
			if(10 to 20)
				new_oxy = "oxydamageoverlay1"
			if(20 to 25)
				new_oxy = "oxydamageoverlay2"
			if(25 to 30)
				new_oxy = "oxydamageoverlay3"
			if(30 to 35)
				new_oxy = "oxydamageoverlay4"
			if(35 to 40)
				new_oxy = "oxydamageoverlay5"
			if(40 to 45)
				new_oxy = "oxydamageoverlay6"
			if(45 to INFINITY)
				new_oxy = "oxydamageoverlay7"

		if (new_oxy != last_oxy_overlay)
			damageoverlay.cut_overlay(last_oxy_overlay)
			damageoverlay.add_overlay(new_oxy)
			last_oxy_overlay = new_oxy
	else if (last_oxy_overlay)
		damageoverlay.cut_overlay(last_oxy_overlay)
		last_oxy_overlay = null

////////////////
//BRAIN DAMAGE//
////////////////

/mob/living/carbon/human/proc/handle_brain_damage()
	for(var/T in get_traumas())
		var/datum/brain_trauma/BT = T
		if(!BT.suppressed)
			BT.on_life()

#undef HUMAN_MAX_OXYLOSS
#undef HUMAN_CRIT_MAX_OXYLOSS
