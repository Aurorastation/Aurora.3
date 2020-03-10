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

	damage_reduction = 0
	relative_size = 85

	var/mob/living/carbon/brain/brainmob = null
	var/list/datum/brain_trauma/traumas = list()
	var/lobotomized = 0
	var/can_lobotomize = 1

	var/const/damage_threshold_count = 10
	var/damage_threshold_value
	var/healed_threshold = 1
	var/oxygen_reserve = 6

/obj/item/organ/internal/brain/Initialize(mapload)
	. = ..()
	if(species)
		set_max_damage(species.total_health)
	else
		set_max_damage(200)
	if(!mapload)
		addtimer(CALLBACK(src, .proc/clear_screen), 5)

/obj/item/organ/internal/brain/Destroy()
	if(brainmob)
		QDEL_NULL(brainmob)
	return ..()

/obj/item/organ/internal/brain/removed(var/mob/living/user)

	for(var/X in traumas)
		var/datum/brain_trauma/BT = X
		BT.on_lose(TRUE)
		BT.owner = null

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

	for(var/X in traumas)
		var/datum/brain_trauma/BT = X
		BT.owner = owner
		BT.on_gain()

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

/obj/item/organ/internal/brain/process()
	if(owner)
		if(damage > max_damage / 2 && healed_threshold)
			handle_severe_brain_damage()

		if(damage < (max_damage / 4))
			healed_threshold = 1

		handle_damage_effects()

		// Brain damage from low oxygenation or lack of blood.
		if(owner.should_have_organ(BP_HEART))

			// No heart? You are going to have a very bad time. Not 100% lethal because heart transplants should be a thing.
			var/blood_volume = owner.get_blood_oxygenation()
			if(blood_volume < BLOOD_VOLUME_SURVIVE)
				if(!owner.chem_effects[CE_STABLE] || prob(60))
					oxygen_reserve = max(0, oxygen_reserve-1)
			else
				oxygen_reserve = min(initial(oxygen_reserve), oxygen_reserve+1)
			if(!oxygen_reserve) //(hardcrit)
				owner.Paralyse(3)
			var/can_heal = damage && damage < max_damage && (damage % damage_threshold_value || owner.chem_effects[CE_BRAIN_REGEN] || (!past_damage_threshold(3) && owner.chem_effects[CE_STABLE]))
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
					if(!owner.paralysis)
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

/obj/item/organ/internal/brain/take_internal_damage(var/damage, var/silent)
	set waitfor = 0
	..()
	if(damage >= (max_damage / 3)) //This probably won't be triggered by oxyloss or mercury. Probably.
		var/damage_secondary = damage * 0.20
		owner.eye_blurry += damage_secondary
		owner.confused += damage_secondary * 2
		owner.Weaken(round(damage, 1))
		if(prob(30))
			addtimer(CALLBACK(src, .proc/brain_damage_callback, damage), rand(6, 20) SECONDS, TIMER_UNIQUE)

/obj/item/organ/internal/brain/proc/brain_damage_callback(var/damage) //Confuse them as a somewhat uncommon aftershock. Side note: Only here so a spawn isn't used. Also, for the sake of a unique timer.
	to_chat(owner, "<span class = 'notice' font size='10'><B>I can't remember which way is forward...</B></span>")
	owner?.confused += damage

/obj/item/organ/internal/brain/proc/handle_severe_brain_damage()
	set waitfor = FALSE
	healed_threshold = 0
	to_chat(owner, "<span class = 'notice' font size='10'><B>Where am I...?</B></span>")
	sleep(5 SECONDS)
	if(!owner)
		return
	to_chat(owner, "<span class = 'notice' font size='10'><B>What's going on...?</B></span>")
	sleep(10 SECONDS)
	if(!owner)
		return
	to_chat(owner, "<span class = 'notice' font size='10'><B>What happened...?</B></span>")
	alert(owner.find_mob_consciousness(), "You have taken massive brain damage! You will not be able to remember the events leading up to your injury.", "Brain Damaged")

/obj/item/organ/internal/brain/proc/handle_damage_effects()
	if(owner.stat)
		return
	if(damage > 0 && prob(1))
		owner.custom_pain("Your head feels numb and painful.",10)
	if(is_bruised() && prob(1) && owner.eye_blurry <= 0)
		to_chat(owner, "<span class='warning'>It becomes hard to see for some reason.</span>")
		owner.eye_blurry = 10
	if(damage >= 0.5*max_damage && prob(1) && owner.get_active_hand())
		to_chat(owner, "<span class='danger'>Your hand won't respond properly, and you drop what you are holding!</span>")
		owner.drop_item()
	if(damage >= 0.6*max_damage)
		owner.stuttering = max(owner.slurring, 2)
	if(is_broken())
		if(!owner.lying && prob(5))
			to_chat(owner, "<span class='danger'>You black out!</span>")
		owner.Paralyse(10)

/obj/item/organ/internal/brain/surgical_fix(mob/user)
	var/blood_volume = owner.get_blood_oxygenation()
	if(blood_volume < BLOOD_VOLUME_SURVIVE)
		to_chat(user, "<span class='danger'>Parts of [src] didn't survive the procedure due to lack of air supply!</span>")
		set_max_damage(Floor(max_damage - 0.25*damage))
	heal_damage(damage)

/obj/item/organ/internal/brain/get_scarring_level()
	. = (species.total_health - max_damage)/species.total_health

////////////////////////////////////TRAUMAS////////////////////////////////////////

/obj/item/organ/internal/brain/proc/has_trauma_type(brain_trauma_type, consider_permanent = FALSE)
	for(var/X in traumas)
		var/datum/brain_trauma/BT = X
		if(istype(BT, brain_trauma_type) && (consider_permanent || !BT.permanent))
			return BT


//Add a specific trauma
/obj/item/organ/internal/brain/proc/gain_trauma(datum/brain_trauma/trauma, permanent = FALSE, list/arguments)
	var/trauma_type
	if(ispath(trauma))
		trauma_type = trauma
		traumas += new trauma_type(arglist(list(src, permanent) + arguments))
	else
		traumas += trauma
		trauma.permanent = permanent

//Add a random trauma of a certain subtype
/obj/item/organ/internal/brain/proc/gain_trauma_type(brain_trauma_type = /datum/brain_trauma, permanent = FALSE)
	var/list/datum/brain_trauma/possible_traumas = list()
	for(var/T in subtypesof(brain_trauma_type))
		var/datum/brain_trauma/BT = T
		if(initial(BT.can_gain))
			possible_traumas += BT

	var/trauma_type = pick(possible_traumas)
	traumas += new trauma_type(src, permanent)

//Cure a random trauma of a certain subtype
/obj/item/organ/internal/brain/proc/cure_trauma_type(brain_trauma_type, cure_permanent = FALSE)
	var/datum/brain_trauma/trauma = has_trauma_type(brain_trauma_type)
	if(trauma && (cure_permanent || !trauma.permanent))
		qdel(trauma)

/obj/item/organ/internal/brain/proc/cure_all_traumas(cure_permanent = FALSE, cure_type = "")
	for(var/X in traumas)
		var/datum/brain_trauma/trauma = X
		if(trauma.cure_type == cure_type || cure_type == CURE_ADMIN)
			if(cure_permanent || !trauma.permanent)
				qdel(trauma)
				if(cure_type != CURE_ADMIN)
					break

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

	to_chat(brainmob, "<span class='notice'>You feel slightly disoriented. That's normal when you're just a [initial(src.name)].</span>")
	callHook("debrain", list(brainmob))

/obj/item/organ/internal/brain/examine(mob/user) // -- TLE
	..(user)
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		to_chat(user, "You can feel the small spark of life still left in this one.")
	else
		to_chat(user, "This one seems particularly lifeless. Perhaps it will regain some of its luster later..")

/obj/item/organ/internal/brain/proc/lobotomize(mob/user as mob)
	lobotomized = 1

	if(owner)
		to_chat(owner, "<span class='danger'>As part of your brain is drilled out, you feel your past self, your memories, your very being slip away...</span>")
		to_chat(owner, "<b>Your brain has been surgically altered to remove your memory recall. Your ability to recall your former life has been surgically removed from your brain, and while your brain is in this state you remember nothing that ever came before this moment.</b>")

	else if(brainmob)
		to_chat(brainmob, "<span class='danger'>As part of your brain is drilled out, you feel your past self, your memories, your very being slip away...</span>")
		to_chat(brainmob, "<b>Your brain has been surgically altered to remove your memory recall. Your ability to recall your former life has been surgically removed from your brain, and while your brain is in this state you remember nothing that ever came before this moment.</b>")

	return

/obj/item/organ/internal/brain/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/surgery/surgicaldrill))
		if(!can_lobotomize)
			return
		if(!lobotomized)
			user.visible_message("<span class='danger'>[user] drills [src] deftly with [W] into the brain!</span>")
			lobotomize(user)
		else
			to_chat(user, "<span class='notice'>The brain has already been operated on!</span>")
	..()