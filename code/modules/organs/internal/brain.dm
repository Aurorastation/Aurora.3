/obj/item/organ/internal/brain
	name = "brain"
	health = 400 //They need to live awhile longer than other organs. Is this even used by organ code anymore?
	desc = "A piece of juicy meat found in a person's head."
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	icon_state = "brain"
	force = 1.0
	w_class = 2.0
	throwforce = 1.0
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	toxin_type = CE_NEUROTOXIC
	relative_size = 85
	var/mob/living/carbon/brain/brainmob = null
	var/list/datum/brain_trauma/traumas = list()
	var/lobotomized = 0
	var/can_lobotomize = 1

	var/const/damage_threshold_count = 10
	var/damage_threshold_value
	var/healed_threshold = 1
	var/oxygen_reserve = 6

/obj/item/organ/internal/brain/can_recover()
	return ~status & ORGAN_DEAD

/obj/item/organ/internal/brain/proc/get_current_damage_threshold()
	return round(damage / damage_threshold_value)

/obj/item/organ/internal/brain/proc/past_damage_threshold(var/threshold)
	return (get_current_damage_threshold() > threshold)

/obj/item/organ/internal/brain/set_max_damage(var/ndamage)
	..()
	damage_threshold_value = round(max_damage / damage_threshold_count)

/obj/item/organ/internal/brain/Initialize(mapload)
	. = ..()
	if(species)
		set_max_damage(species.total_health)
	else
		set_max_damage(200)
	if(!mapload)
		addtimer(CALLBACK(src, .proc/clear_screen), 5)

/obj/item/organ/internal/brain/process()
	..()

	if(!owner)
		return

	if(CE_BRAIN_REGEN in owner.chem_effects)
		damage -= min(damage, owner.chem_effects[CE_BRAIN_REGEN])
	
	if(lobotomized && (owner.getBrainLoss() < 40)) //lobotomized brains cannot be healed with chemistry. Part of the brain is irrevocably missing. Can be fixed magically with cloning, ofc.
		owner.setBrainLoss(40)

	for(var/T in owner.get_traumas())
		var/datum/brain_trauma/BT = T
		if(!BT.suppressed)
			BT.on_life()

	if(owner.species.has_organ[BP_HEART]) //This is where the bad times start if you have no heart.
		// No heart? You are going to have a very bad time. Not 100% lethal because heart transplants should be a thing.
		var/blood_volume = owner.get_blood_oxygenation()
		if(blood_volume < BLOOD_VOLUME_SURVIVE)
			if(!owner.chem_effects[CE_STABLE] || prob(60))
				oxygen_reserve = max(0, oxygen_reserve-1)
		else
			oxygen_reserve = min(initial(oxygen_reserve), oxygen_reserve+1)
		if(!oxygen_reserve) //(hardcrit)
			owner.Paralyse(3)
		var/can_heal = damage && damage < max_damage && (damage % damage_threshold_value || (!past_damage_threshold(3) && owner.chem_effects[CE_STABLE]))
		var/damprob
		//Effects of bloodloss
		switch(blood_volume)

			if(BLOOD_VOLUME_SAFE to INFINITY)
				if(can_heal)
					damage = max(damage-1, 0)
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				if(prob(1))
					to_chat(owner, "<span class='warning'>You feel [pick("dizzy","woozy","faint")]...</span>")
				damprob = owner.chem_effects[CE_STABLE] ? 30 : 60
				if(!past_damage_threshold(2) && prob(damprob))
					take_internal_damage(1)
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				owner.eye_blurry = max(owner.eye_blurry,6)
				damprob = owner.chem_effects[CE_STABLE] ? 40 : 80
				if(!past_damage_threshold(4) && prob(damprob))
					take_internal_damage(1)
				if(!owner.paralysis && prob(10))
					owner.Paralyse(rand(1,3))
					to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woozy","faint")]...</span>")
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
				owner.eye_blurry = max(owner.eye_blurry,6)
				damprob = owner.chem_effects[CE_STABLE] ? 60 : 100
				if(!past_damage_threshold(6) && prob(damprob))
					take_internal_damage(1)
				if(!owner.paralysis && prob(15))
					owner.Paralyse(3,5)
					to_chat(owner, "<span class='warning'>You feel extremely [pick("dizzy","woozy","faint")]...</span>")
			if(-(INFINITY) to BLOOD_VOLUME_SURVIVE) // Also see heart.dm, being below this point puts you into cardiac arrest.
				owner.eye_blurry = max(owner.eye_blurry,6)
				damprob = owner.chem_effects[CE_STABLE] ? 80 : 100
				if(prob(damprob))
					take_internal_damage(1)
				if(prob(damprob))
					take_internal_damage(1)
	..()
