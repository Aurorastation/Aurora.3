/obj/item/organ/internal/brain
	name = "brain"
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	possible_modifications = list ("Normal","Assisted")
	vital = TRUE
	icon_state = "brain"
	force = 1
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	toxin_type = CE_NEUROTOXIC

	damage_reduction = 0
	relative_size = 85

	var/mob/living/carbon/brain/brainmob = null
	var/prepared = FALSE
	var/can_prepare = TRUE

	var/const/damage_threshold_count = 10
	var/damage_threshold_value
	var/healed_threshold = 1
	var/oxygen_reserve = 6

	/**
	 * The base amount brain damage is changed by "Per second", differentiated by tick time.
	 * This is then modified based on the blood volume being pumped, and whether or not a patient has been stabilized with Inaprovaline.
	 * It's also directly 1:1 with your brain's numerical healthbar. If your brain has 200hp, consider that it has "200 seconds" of budget.
	 */
	var/brain_damage_per_second = 1

	/**
	 * Brain damage modifier used for 85% blood volume and up.
	 * This one is actually used for the passive healing rate mainly.
	 */
	var/safe_damage_modifier = 1

	/**
	 * Base brain damage modifier used for 70% to 85% blood volume.
	 * This is where a patient starts taking real damage, but not a lot, easily stabilized. They are likely to recover naturally.
	 */
	var/okay_damage_modifier = 1

	/**
	 * "Okay" blood volume, stabilized with inaprovaline.
	 * For a default unmodified brain, this would take 666.666s to kill. You've got plenty of time.
	 */
	var/okay_stabilized_mod = 0.3

	/**
	 * "Okay" blood volume, not stabilized with inaprovaline.
	 * For a default unmodified brain, this is 333.333s to kill. Get them Inaprovaline, and you'll have plenty of time.
	 */
	var/okay_unstable_mod = 0.6

	/**
	 * Base brain damage modifier used for 60% to 70% blood volume.
	 * This is where a character starts being at a real risk of death.
	 */
	var/bad_damage_modifier = 1

	/**
	 * "Bad" blood volume, stabilized with inaprovaline.
	 * For a default unmodified brain, this would take 500s to kill. Inaprovaline makes a big difference.
	 */
	var/bad_stabilized_mod = 0.4

	/**
	 * "Bad" blood volume, not stabilized with inaprovaline.
	 * For a default unmodified brain, this is 250s to kill.
	 */
	var/bad_unstable_mod = 0.8

	/**
	 * Base brain damage modifier used for 30% to 60% blood volume.
	 * Death is extremely likely without aid. Even inaprovaline starts to help a lot less.
	 * If someone has gotten to this point, they likely don't have 200 brain health left to begin with, they probably actually have far less.
	 */
	var/crit_damage_modifier = 1

	/**
	 * "Critical" blood volume, stabilized with inaprovaline.
	 * For a default unmodified brain, this would take 333.333s to kill.
	 */
	var/crit_stabilized_mod = 0.6

	/**
	 * "Bad" blood volume, not stabilized with inaprovaline.
	 * For a default unmodified brain, this is 200s to kill.
	 */
	var/crit_unstable_mod = 1

	/**
	 * Base brain damage modifier used for 00% to 30% blood volume.
	 * Death is imminent, and is very likely to occur without an extremely skilled doctor throwing away most of the ship's resources.
	 * If someone has gotten to this point, they likely don't have 200 brain health left to begin with, they probably actually have far less.
	 */
	var/dying_damage_modifier = 2

	/**
	 * "Dying" blood volume, stabilized with inaprovaline.
	 * For a default unmodified brain, this would take 125s to kill.
	 */
	var/dying_stabilized_mod = 0.8

	/**
	 * "Dying" blood volume, not stabilized with inaprovaline.
	 * For a default unmodified brain, this is 100s to kill. By the time someone gets to this point, they probably have closer to 30s.
	 */
	var/dying_unstable_mod = 1

/obj/item/organ/internal/brain/Initialize(mapload)
	. = ..()
	if(species)
		set_max_damage(species.total_health)
	else
		set_max_damage(200)
	if(!mapload)
		addtimer(CALLBACK(src, PROC_REF(clear_screen)), 5)

/obj/item/organ/internal/brain/Destroy()
	if(brainmob)
		QDEL_NULL(brainmob)
	return ..()

/obj/item/organ/internal/brain/removed(var/mob/living/user)

	var/mob/living/simple_animal/borer/borer = owner.has_brain_worms()

	if(borer)
		borer.detach() //Should remove borer if the brain is removed - RR

	var/obj/item/organ/internal/brain/B = src
	if(istype(B) && istype(owner))
		B.transfer_identity(owner)

	..()

/obj/item/organ/internal/brain/replaced(var/mob/living/target)

	if(target.key)
		target.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(target)
		else
			target.key = brainmob.key
	..()

/obj/item/organ/internal/brain/getToxLoss()
	return 0

/obj/item/organ/internal/brain/can_recover()
	return ~status & ORGAN_DEAD

/obj/item/organ/internal/brain/proc/get_current_damage_threshold()
	return round(damage / damage_threshold_value)

/obj/item/organ/internal/brain/proc/past_damage_threshold(var/threshold)
	return (get_current_damage_threshold() > threshold)

/obj/item/organ/internal/brain/set_max_damage(var/ndamage)
	..()
	damage_threshold_value = round(max_damage / damage_threshold_count)

/obj/item/organ/internal/brain/process(seconds_per_tick)
	if(!owner)
		return ..()

	if(damage > (max_damage * 0.75) && healed_threshold)
		handle_severe_brain_damage()

	if(damage < (max_damage / 4))
		healed_threshold = 1

	handle_damage_effects()

	// Brain damage from low oxygenation or lack of blood.
	if(!owner.should_have_organ(BP_HEART))
		return ..()

	// Adjust the rate of brain healing and damage over time if the owner is in stasis.
	if(owner.stasis_value > 0)
		seconds_per_tick /= owner.stasis_value

	// No heart? You are going to have a very bad time. Not 100% lethal because heart transplants should be a thing.
	var/blood_volume = owner.get_blood_oxygenation()
	if(blood_volume < BLOOD_VOLUME_SURVIVE)
		if(!owner.chem_effects[CE_STABLE] || prob(60))
			oxygen_reserve = max(0, oxygen_reserve-1)
	else
		oxygen_reserve = min(initial(oxygen_reserve), oxygen_reserve+1)

	if(!oxygen_reserve) //(hardcrit)
		owner.Paralyse(10)

	var/can_heal = (damage && damage < max_damage && (damage % damage_threshold_value || owner.chem_effects[CE_BRAIN_REGEN] || (!past_damage_threshold(3) && owner.chem_effects[CE_STABLE]))) && (!(owner.chem_effects[CE_NEUROTOXIC]) || owner.chem_effects[CE_ANTITOXIN])
	var/dammod
	var/brain_regen_amount = owner.chem_effects[CE_BRAIN_REGEN]	* seconds_per_tick
	var/brain_damage_amount = brain_damage_per_second * seconds_per_tick
	//Effects of bloodloss
	switch(blood_volume)
		if(BLOOD_VOLUME_SAFE to INFINITY)
			if(can_heal && owner.chem_effects[CE_BRAIN_REGEN])
				damage -= min(damage, brain_regen_amount * safe_damage_modifier)
			else if(can_heal)
				damage -= min(damage, brain_damage_amount * safe_damage_modifier)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			owner.notify_message(SPAN_WARNING("You feel a bit [pick("lightheaded","dizzy","pale")]..."), rand(20 SECONDS, 40 SECONDS), key = "blood_volume_okay")
			dammod = owner.chem_effects[CE_STABLE] ? okay_stabilized_mod : okay_unstable_mod
			if(!past_damage_threshold(2))
				take_internal_damage(brain_damage_amount * dammod * okay_damage_modifier)
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			owner.notify_message(SPAN_WARNING("You feel [pick("weak","disoriented","faint","cold")]."), rand(20 SECONDS, 40 SECONDS), key = "blood_volume_bad")
			owner.eye_blurry = max(owner.eye_blurry,6)
			dammod = owner.chem_effects[CE_STABLE] ? bad_stabilized_mod : bad_unstable_mod
			if(!past_damage_threshold(4))
				take_internal_damage(brain_damage_amount * dammod * bad_damage_modifier)
			if(!owner.paralysis && prob(10))
				owner.Paralyse(rand(1,3))
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			owner.notify_message(SPAN_WARNING("You feel <b>extremely</b> [pick("cold","woozy","faint","weak","confused","tired","lethargic")]."), rand(20 SECONDS, 40 SECONDS), key = "blood_volume_survive")
			owner.eye_blurry = max(owner.eye_blurry,6)
			dammod = owner.chem_effects[CE_STABLE] ? crit_stabilized_mod : crit_unstable_mod
			if(!past_damage_threshold(6))
				take_internal_damage(brain_damage_amount * dammod * crit_damage_modifier)
			if(!owner.paralysis && prob(15))
				owner.Paralyse(rand(3, 5))
		if(-(INFINITY) to BLOOD_VOLUME_SURVIVE) // Also see heart.dm, being below this point puts you into cardiac arrest.
			owner.notify_message(SPAN_DANGER("You feel like death is imminent."), rand(20 SECONDS, 40 SECONDS), key = "blood_volume_dying")
			owner.eye_blurry = max(owner.eye_blurry,6)
			dammod = owner.chem_effects[CE_STABLE] ? dying_stabilized_mod : dying_unstable_mod
			take_internal_damage(brain_damage_amount * dammod * dying_damage_modifier)
	..()

/obj/item/organ/internal/brain/proc/handle_severe_brain_damage()
	set waitfor = FALSE
	healed_threshold = 0
	to_chat(owner, "<span class = 'notice'><font size=4><B>Where am I...?</B></font></span>")
	owner.Paralyse(20)
	sleep(5 SECONDS)
	if(!owner)
		return
	to_chat(owner, "<span class = 'notice'><font size=4><B>What's going on...?</B></font></span>")
	sleep(10 SECONDS)
	if(!owner)
		return
	to_chat(owner, "<span class = 'notice'><font size=4><B>What happened...?</B></font></span>")
	alert(owner.find_mob_consciousness(), "You have taken massive brain damage! You will not be able to remember the events leading up to your injury.", "Brain Damaged")

/obj/item/organ/internal/brain/proc/handle_damage_effects()
	if(owner.stat)
		return
	if(damage > 0 && prob(1))
		owner.custom_pain("Your head feels numb and painful.",10)
	if(is_bruised() && prob(1) && owner.eye_blurry <= 0)
		to_chat(owner, SPAN_WARNING("It becomes hard to see for some reason."))
		owner.eye_blurry = 10
	if(damage >= 0.5*max_damage && prob(1) && owner.get_active_hand())
		to_chat(owner, SPAN_DANGER("Your hand won't respond properly, and you drop what you are holding!"))
		owner.drop_item()
	if(damage >= 0.6*max_damage)
		owner.stuttering = max(owner.slurring, 2)
	if(is_broken())
		if(!owner.lying && prob(5))
			to_chat(owner, SPAN_DANGER("You black out!"))
			owner.Paralyse(10)

/obj/item/organ/internal/brain/surgical_fix(mob/user)
	var/blood_volume = owner.get_blood_oxygenation()
	if(blood_volume < BLOOD_VOLUME_BAD)
		to_chat(user, SPAN_DANGER("Parts of [src] didn't survive the procedure due to lack of air supply!"))
		set_max_damage(FLOOR(max_damage - 0.25*damage, 1))
	heal_damage(damage)

/obj/item/organ/internal/brain/get_scarring_level()
	. = (species.total_health - max_damage)/species.total_health

//Miscellaneous

/obj/item/organ/internal/brain/proc/clear_screen()
	if (brainmob && brainmob.client)
		brainmob.client.screen.Cut()

/obj/item/organ/internal/brain/proc/transfer_identity(var/mob/living/carbon/H)
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna.Clone()
	brainmob.timeofhostdeath = H.timeofdeath
	if(H.mind)
		H.mind.transfer_to(brainmob)

	to_chat(brainmob, SPAN_NOTICE("You feel slightly disoriented. That's normal when you're just a [initial(src.name)]."))
	callHook("debrain", list(brainmob))

/obj/item/organ/internal/brain/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		. += "You can feel the small spark of life still left in this one."
	else
		. += "This one seems particularly lifeless. Perhaps it will regain some of its luster later.."

/obj/item/organ/internal/brain/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/surgery/surgicaldrill))
		if(!can_prepare)
			to_chat(user, SPAN_WARNING("\The [src] cannot be prepared!"))
			return
		if(!prepared)
			user.visible_message(SPAN_DANGER("[user] deftly uses \the [attacking_item] to drill into \the [src]!"))
			prepared = TRUE
		else
			to_chat(user, SPAN_WARNING("The brain has already been prepared!"))
		return
	return ..()

/obj/item/organ/internal/brain/zombie
	relative_size = 100
