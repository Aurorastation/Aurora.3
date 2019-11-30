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
	var/mob/living/carbon/brain/brainmob = null
	var/list/datum/brain_trauma/traumas = list()
	var/lobotomized = 0
	var/can_lobotomize = 1

/obj/item/organ/internal/brain/process()
	..()

	if(!owner)
		return

	if(lobotomized && (owner.getBrainLoss() < 40)) //lobotomized brains cannot be healed with chemistry. Part of the brain is irrevocably missing. Can be fixed magically with cloning, ofc.
		owner.setBrainLoss(40)

	for(var/T in owner.get_traumas())
		var/datum/brain_trauma/BT = T
		if(!BT.suppressed)
			BT.on_life()

	var/blood_volume = round(owner.vessel.get_reagent_amount("blood"))
	switch(blood_volume)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			var/word = pick("dizzy","woosey","faint")
			to_chat(owner, "<span class='warning'>You feel [word]...</span>")
			if(prob(1))
				word = pick("dizzy","woosey","faint")
				to_chat(owner, "<span class='warning'>You feel [word]...</span>")
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			owner.eye_blurry = max(owner.eye_blurry,6)
			owner.oxyloss += 1
			if(prob(15))
				owner.Paralyse(rand(1,3))
				var/word = pick("dizzy","woosey","faint")
				to_chat(owner, "<span class='warning'>You feel extremely [word]...</span>")
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			owner.oxyloss += 3
			owner.toxloss += 3
			if(prob(15))
				var/word = pick("dizzy","woosey","faint")
				to_chat(owner, "<span class='warning'>You feel extremely [word]...</span>")
		if(0 to BLOOD_VOLUME_SURVIVE)
			// There currently is a strange bug here. If the mob is not below -100 health
			// when death() is called, apparently they will be just fine, and this way it'll
			// spam deathgasp. Adjusting toxloss ensures the mob will stay dead.
			owner.toxloss += 300 // just to be safe!
			owner.death()

	if(owner.species.has_organ[BP_HEART]) //This is where the bad times start if you have no heart.
		var/obj/item/organ/internal/heart/H = owner.internal_organs_by_name[BP_HEART]
		if(!istype(H))
			var/damprob
			owner.eye_blurry = max(owner.eye_blurry,6)
			damprob = owner.chem_effects[CE_STABLE] ? 80 : 100
			if(prob(10))
				to_chat(owner, "<span class='danger'><font size=3>You jerk and gasp for breath, yet you still feel like you're suffocating!</font></span>")
				owner.emote("jerks and gasps!")
			if(prob(damprob))
				owner.adjustOxyLoss(15)
		
