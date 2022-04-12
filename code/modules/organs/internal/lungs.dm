#define HUMAN_MAX_OXYLOSS 1 //Defines how much oxyloss humans can get per tick. A tile with no air at all (such as space) applies this value, otherwise it's a percentage of it.

/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	organ_tag = BP_LUNGS
	parent_organ = BP_CHEST
	robotic_name = "gas exchange system"
	min_bruised_damage = 30
	min_broken_damage = 45
	toxin_type = CE_PNEUMOTOXIC

	max_damage = 80
	relative_size = 60

	var/breathing = 0

	// Handles rupture grace period
	var/rupture_imminent = FALSE // If this is true and the pressure is too high or low, our lungs will rupture
	var/checking_rupture = TRUE // If this is false, the rupture check won't run, granting a grace period

	var/rescued = FALSE // whether or not a collapsed lung has been rescued with a syringe
	var/oxygen_deprivation = 0
	var/last_successful_breath
	var/breath_fail_ratio //How badly they failed a breath

/obj/item/organ/internal/lungs/proc/remove_oxygen_deprivation(var/amount)
	var/last_suffocation = oxygen_deprivation
	oxygen_deprivation = min(species.total_health,max(0,oxygen_deprivation - amount))
	return -(oxygen_deprivation - last_suffocation)

/obj/item/organ/internal/lungs/proc/add_oxygen_deprivation(var/amount)
	var/last_suffocation = oxygen_deprivation
	oxygen_deprivation = min(species.total_health,max(0,oxygen_deprivation + amount))
	return (oxygen_deprivation - last_suffocation)

// Returns a percentage value for use by GetOxyloss().
/obj/item/organ/internal/lungs/proc/get_oxygen_deprivation()
	if(status & ORGAN_DEAD)
		return 100
	return round((oxygen_deprivation/species.total_health)*100)

/obj/item/organ/internal/lungs/process()
	..()

	if(!owner || owner.stat == DEAD)
		return

	if(germ_level > INFECTION_LEVEL_ONE)
		if(prob(5))
			owner.emote("cough")		//Respiratory tract infection

	if(is_broken() || (is_bruised() && !rescued) && !owner.is_asystole()) // a thoracostomy can only help with a collapsed lung, not a mangled one
		if(prob(2))
			owner.visible_message(
				"<B>\The [owner]</B> coughs up blood!",
				"<span class='warning'>You cough up blood!</span>",
				"You hear someone coughing!",
				)
			owner.drip(10)
		if(prob(4))
			owner.visible_message(
				"<B>\The [owner]</B> gasps for air!",
				"<span class='danger'>You can't breathe!</span>",
				"You hear someone gasp for air!",
			)
			owner.losebreath = max(round(damage / 2), owner.losebreath)

	if(rescued)
		if(is_bruised())
			if(prob(4))
				to_chat(owner, SPAN_WARNING("It feels hard to breathe..."))
				if (owner.losebreath < 5)
					owner.losebreath = min(owner.losebreath + 1, 5) // it's still not good, but it's much better than an untreated collapsed lung
		else
			if(prob(2))
				to_chat(owner, SPAN_WARNING("It feels hard to breathe, and something in your chest is whistling..."))
				if (owner.losebreath < 2)
					owner.losebreath = min(owner.losebreath + 1, 2)

/obj/item/organ/internal/lungs/proc/rupture()
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent))
		owner.custom_pain("You feel a stabbing pain in your [parent.name]!", 50, affecting = parent)
	rupture_imminent = FALSE
	bruise()

/obj/item/organ/internal/lungs/proc/handle_failed_breath()
	if(prob(15) && !owner.nervous_system_failure())
		if(!owner.is_asystole())
			if(owner.is_submerged())
				owner.emote("flail")
			else
				owner.emote("gasp")
		else
			owner.emote(pick("shiver","twitch"))

	if(damage || owner.chem_effects[CE_BREATHLOSS] || world.time > last_successful_breath + 2 MINUTES)
		owner.adjustOxyLoss(HUMAN_MAX_OXYLOSS * breath_fail_ratio)
	owner.oxygen_alert = max(owner.oxygen_alert, 2)

/obj/item/organ/internal/lungs/proc/enable_rupture()
	rupture_imminent = TRUE
	checking_rupture = TRUE
	addtimer(CALLBACK(src, .proc/disable_rupture), 5 SECONDS, TIMER_UNIQUE)

/obj/item/organ/internal/lungs/proc/disable_rupture()
	rupture_imminent = FALSE

/obj/item/organ/internal/lungs/proc/handle_breath(datum/gas_mixture/breath)
	if(!owner)
		return 1

	if(!breath || (max_damage <= 0))
		breath_fail_ratio = 1
		handle_failed_breath()
		return 1

	var/high_pressure = breath.total_moles / (owner.species?.breath_vol_mul || 1) > BREATH_MOLES * 5
	var/low_pressure = breath.total_moles / (owner.species?.breath_vol_mul || 1) < BREATH_MOLES / 5
	//exposure to extreme pressures can rupture lungs
	if(checking_rupture && damage < min_bruised_damage && (high_pressure || low_pressure))
		if(rupture_imminent)
			rupture()
		else
			if(low_pressure)
				to_chat(owner, FONT_LARGE(SPAN_WARNING("You feel air rapidly beginning to exit your lungs!")))
			else if(high_pressure)
				to_chat(owner, FONT_LARGE(SPAN_WARNING("You feel vast amounts of air force itself into your lungs!")))
			else
				to_chat(owner, FONT_LARGE(SPAN_WARNING("You feel as if your lungs are about to blow!")))
			addtimer(CALLBACK(src, .proc/enable_rupture), 2 SECONDS, TIMER_UNIQUE)
			checking_rupture = FALSE

	var/safe_pressure_min = owner.species.breath_pressure // Minimum safe partial pressure of breathable gas in kPa
	// Lung damage increases the minimum safe pressure.
	safe_pressure_min *= 1 + rand(1,4) * damage/max_damage

	var/safe_exhaled_max = 10
	var/safe_toxins_max = 0.2
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/inhaled_gas_used = 0

	var/breath_pressure = (breath.total_moles * R_IDEAL_GAS_EQUATION * breath.temperature) / (BREATH_VOLUME * owner.species.breath_vol_mul)

	var/inhaling
	var/poison
	var/exhaling

	var/breath_type
	var/poison_type
	var/exhale_type

	var/failed_inhale = 0
	var/failed_exhale = 0

	if(owner.species.breath_type)
		breath_type = species.breath_type
	else
		breath_type = GAS_OXYGEN

	inhaling = breath.gas[breath_type]

	if(owner.species.poison_type)
		poison_type = species.poison_type
	else
		poison_type = GAS_PHORON
	poison = breath.gas[poison_type]

	if(owner.species.exhale_type)
		exhale_type = species.exhale_type
		exhaling = breath.gas[exhale_type]
	else
		exhaling = 0

	var/toxins_pp = (poison/breath.total_moles)*breath_pressure
	var/exhaled_pp = (exhaling/breath.total_moles)*breath_pressure

	var/inhale_efficiency = min(round(((inhaling/breath.total_moles)*breath_pressure)/safe_pressure_min, 0.001), 3)

	// Not enough to breathe
	if(inhale_efficiency < 1)
		if(prob(20))
			if(inhale_efficiency < 0.8)
				if(owner.is_submerged())
					owner.emote("flail")
				else
					owner.emote("gasp")
			else if(prob(20))
				to_chat(owner, SPAN_WARNING("It's hard to breathe..."))
		breath_fail_ratio = 1 - inhale_efficiency
		failed_inhale = 1
	else
		breath_fail_ratio = 0

	owner.oxygen_alert = failed_inhale * 2

	inhaled_gas_used = inhaling/6 * (owner.species?.breath_eff_mul || 1)

	breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards

	if(exhale_type)
		breath.adjust_gas_temp(exhale_type, inhaled_gas_used, owner.bodytemperature, update = 0) //update afterwards

		// Too much exhaled gas in the air
		if(exhaled_pp > safe_exhaled_max)
			if (!owner.co2_alert|| prob(15))
				var/word = pick("extremely dizzy","short of breath","faint","confused")
				to_chat(owner, "<span class='danger'>You feel [word].</span>")

			owner.co2_alert = 1
			failed_exhale = 1

		else if(exhaled_pp > safe_exhaled_max * 0.7)
			if (!owner.co2_alert || prob(1))
				var/word = pick("dizzy","short of breath","faint","momentarily confused")
				to_chat(owner, "<span class='warning'>You feel [word].</span>")

			owner.co2_alert = 1
			failed_exhale = 1

		else if(exhaled_pp > safe_exhaled_max * 0.6)
			if (prob(0.3))
				var/word = pick("a little dizzy","short of breath")
				to_chat(owner, "<span class='warning'>You feel [word].</span>")

		else
			owner.co2_alert = 0

	// Too much poison in the air.
	if(toxins_pp > safe_toxins_max)
		var/ratio = (poison/safe_toxins_max) * 10
		if(reagents)
			reagents.add_reagent(/decl/reagent/toxin, Clamp(ratio, MIN_TOXIN_DAMAGE, MAX_TOXIN_DAMAGE))
			breath.adjust_gas(poison_type, -poison/6, update = 0) //update after
		owner.phoron_alert = max(owner.phoron_alert, 1)
	else
		owner.phoron_alert = 0

	// If there's some other shit in the air lets deal with it here.
	if(breath.gas[GAS_N2O])
		var/SA_pp = (breath.gas[GAS_N2O] / breath.total_moles) * breath_pressure

		// Enough to make us paralysed for a bit
		if(SA_pp > SA_para_min)

			// 3 gives them one second to wake up and run away a bit!
			owner.Paralyse(3)

			// Enough to make us sleep as well
			if(SA_pp > SA_sleep_min)
				owner.Sleeping(10)

		// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
		else if(SA_pp > 0.15)
			if(prob(20))
				spawn(0)
					owner.emote(pick("giggle", "laugh"))
		breath.adjust_gas(GAS_N2O, -breath.gas[GAS_N2O]/6, update = 0) //update after

	// Were we able to breathe?
	if (failed_inhale || failed_exhale)
		owner.failed_last_breath = 1
	else
		owner.failed_last_breath = 0

	// Hot air hurts :(
	handle_temperature_effects(breath)

	breath.update_values()

	var/failed_breath = failed_inhale || failed_exhale

	if(failed_breath)
		handle_failed_breath()
	else
		last_successful_breath = world.time
		owner.oxygen_alert = 0
		if(owner.disabilities & ASTHMA)
			owner.adjustOxyLoss(rand(-5,0) * inhale_efficiency)
		else
			owner.adjustOxyLoss(-5 * inhale_efficiency)
		if(!BP_IS_ROBOTIC(src) && species.breathing_sound && is_below_sound_pressure(get_turf(owner)))
			if(breathing || owner.shock_stage >= 10)
				sound_to(owner, sound(species.breathing_sound,0,0,0,5))
				breathing = 0
			else
				breathing = 1

	return failed_breath

/obj/item/organ/internal/lungs/proc/handle_temperature_effects(datum/gas_mixture/breath)
	if((breath.temperature < species.cold_level_1 || breath.temperature > species.heat_level_1) && !(COLD_RESISTANCE in owner.mutations))

		if(breath.temperature <= owner.species.cold_level_1)
			if(prob(20))
				to_chat(owner, "<span class='danger'>You feel your face freezing and icicles forming in your lungs!</span>")
		else if(breath.temperature >= owner.species.heat_level_1)
			if(prob(20))
				to_chat(owner, "<span class='danger'>You feel your face burning and a searing heat in your lungs!</span>")

		if(breath.temperature >= owner.species.heat_level_1)
			if(breath.temperature < owner.species.heat_level_2)
				owner.apply_damage(HEAT_GAS_DAMAGE_LEVEL_1, BURN, BP_HEAD, used_weapon = "Excessive Heat")
				owner.fire_alert = max(owner.fire_alert, 2)
			else if(breath.temperature < species.heat_level_3)
				owner.apply_damage(HEAT_GAS_DAMAGE_LEVEL_2, BURN, BP_HEAD, used_weapon = "Excessive Heat")
				owner.fire_alert = max(owner.fire_alert, 2)
			else
				owner.apply_damage(HEAT_GAS_DAMAGE_LEVEL_3, BURN, BP_HEAD, used_weapon = "Excessive Heat")
				owner.fire_alert = max(owner.fire_alert, 2)

		else if(breath.temperature <= owner.species.cold_level_1)
			if(breath.temperature > species.cold_level_2)
				owner.apply_damage(COLD_GAS_DAMAGE_LEVEL_1, BURN, BP_HEAD, used_weapon = "Excessive Cold")
				owner.fire_alert = max(owner.fire_alert, 1)
			else if(breath.temperature > species.cold_level_3)
				owner.apply_damage(COLD_GAS_DAMAGE_LEVEL_2, BURN, BP_HEAD, used_weapon = "Excessive Cold")
				owner.fire_alert = max(owner.fire_alert, 1)
			else
				owner.apply_damage(COLD_GAS_DAMAGE_LEVEL_3, BURN, BP_HEAD, used_weapon = "Excessive Cold")
				owner.fire_alert = max(owner.fire_alert, 1)

		//breathing in hot/cold air also heats/cools you a bit
		var/temp_adj = breath.temperature - owner.bodytemperature
		if (temp_adj < 0)
			temp_adj /= (BODYTEMP_COLD_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed
		else
			temp_adj /= (BODYTEMP_HEAT_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed

		var/relative_density = breath.total_moles / (MOLES_CELLSTANDARD * BREATH_PERCENTAGE)
		temp_adj *= relative_density

		if (temp_adj > BODYTEMP_HEATING_MAX) temp_adj = BODYTEMP_HEATING_MAX
		if (temp_adj < BODYTEMP_COOLING_MAX) temp_adj = BODYTEMP_COOLING_MAX
		owner.bodytemperature += temp_adj

	else if(breath.temperature >= owner.species.heat_discomfort_level)
		owner.species.get_environment_discomfort(owner,"heat")
	else if(breath.temperature <= owner.species.cold_discomfort_level)
		owner.species.get_environment_discomfort(owner,"cold")

/obj/item/organ/internal/lungs/listen()
	if(owner.failed_last_breath)
		return "no respiration"

	if(BP_IS_ROBOTIC(src))
		if(is_bruised())
			return "malfunctioning fans"
		else
			return "air flowing"

	. = list()
	if(is_bruised())
		. += "[pick("wheezing", "gurgling")] sounds"
	if(rescued)
		. += "a whistling sound"

	var/list/breathtype = list()
	if(get_oxygen_deprivation() > 50)
		breathtype += pick("straining","labored")
	if(owner.shock_stage > 50)
		breathtype += pick("shallow and rapid")
	if(!breathtype.len)
		breathtype += "healthy"

	. += "[english_list(breathtype)] breathing"

	return english_list(.)

/obj/item/organ/internal/lungs/surgical_fix(mob/user)
	..()
	rescued = FALSE

#undef HUMAN_MAX_OXYLOSS
