//Psionics is like magic, but instead of relying on energy from extradimensional sources, it relies on the infinitely untapped energy within the sentient mind.
//Everyone has the potential within them, but only a select few have learned the secrets of unlocking their brain. These special few are called the AWOKEN.
//Awoken ranged in power levels, from mere freshly awoken Initiates, with a sparse few powers and all the parlour tricks of their discipline, to LEVIATHANS.
//Awoken in game can only mechanically reach the power level of Grandmasterclass. Perhaps in the future we will consider the godlike LEVIATHANS.
//Psionic power is tied to the brain item, because everyone with a brain has psionic potential. Currently there are only mechanics for the Urlamians, who all spawn
//Awoken. Perhaps in the future there will be means of awakening throughout the course of the round.




//FIX THIS OH GOD. Don't make everything a subtype that overwrites every original function. Just overwrite valid_target and cast_hand like God intended.
//Don't make this a mess.

/spell/hand/psyker
	name = "Psionic Power"
	desc = "A psionic power."
	still_recharging_msg = "<span class='notice'>This psionic power is still recharging.</span>"
	spell_flags = Z2NOCAST
	invocation_type = SpI_NONE
	message = ""
	sparks_spread = 0
	sparks_amt = 0
	power_level = 0
	power_cost = 0
	duration = 0
	casts = 0
	spell_delay = 5
	charge_max = 100
	hand_state = "psy_hand"
	hand_icon = 'icons/obj/wizard.dmi'
	var/friendly = 0 //spell is not hostile if 1
	lightful = 1
	lightful_c = "#800080"

	hud_state = "wiz_psy"

/spell/hand/psyker/cast(list/targets, mob/user)
	for(var/mob/M in targets)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.get_active_hand())
				user << "<span class='warning'>You need an empty hand to cast this power.</span>"
				return
			psybrain = H.internal_organs_by_name["brain"]
			if(!istype(psybrain,/obj/item/organ/brain) || !psybrain)
				user << "<span class='warning'>You lack the brain necessary for psionic power!</span>"
				return
			if(psybrain.max_willpower <= 0)
				user << "<span class='warning'>You lack the willpower necessary for psionic power!</span>"
				return
			if(!psybrain.awoken)
				user << "<span class='warning'>You do not know how to access the secrets of the mind!</span>"
				return
			psybrain.willpower -= power_cost
			if(psybrain.willpower < 0)
				H.backblast(((psybrain.willpower*psybrain.power_level) * -1))
		else
			user << "<span class='warning'>Your mind is not complex enough for such artistry!</span>"
			return
	..()

/spell/hand/psyker/valid_target(var/atom/A,var/mob/user)
	if(A == user && !target_self)
		return 0
	var/distance = get_dist(A,user)
	if((min_range && distance < min_range) || (range && distance > range))
		return 0
	if(!is_type_in_list(A,compatible_targets))
		return 0
	if(A != user || !friendly) //spells targeted on yourself don't get resisted by yourself, usually. friendly spells like healing don't get resisted
		if(ishuman(A) && ishuman(user))
			var/mob/living/carbon/human/H = A
			var/mob/living/carbon/human/psyker = user
			/*if(H.stat == DEAD)
				psyker << "<span class='warning'>You cannot penetrate the depths of the unconscious mind!</span>"
				return 0*/
			brain = H.internal_organs_by_name["brain"]
			if(!istype(brain,/obj/item/organ/brain) || !brain)
				psyker << "<span class='warning'>You cannot recognize the mechanisms of \the [H]'s mind!</span>"
				return 0
			else if(brain.max_willpower < 0)
				psyker << "<span class='warning'>\The [H] is immune to your psionic tricks!</span>"
				return 0
			else
				if(brain.willpower >= psybrain.willpower && brain.willpower < psybrain.willpower * 3)
					brain.willpower -= psybrain.power_level*3
					if(prob(brain.willpower/10))
						return 0
					if(brain.awoken)
						psyker << "<span class='warning'>\The [H] consciously battles against your psionic power!</span>"
						H << "<span class='warning'>You resist against \the [psyker]'s insidious mental assault!</span>"
					else
						psyker << "<span class='warning'>\The [H] subconsciously battles against your psionic power!</span>"
				else if(brain.willpower >= psybrain.willpower * 3)
					psyker << "<span class='warning'>\The [H]'s strength of will far surpasses your own! Pull out, pull out!!</span>"
					psyker.backblast(5)
					if(brain.awoken)
						H << "<span class='warning'>You swat away \the [psyker]'s insidious mental assault like a fly!</span>"
					return 0
	return 1

/mob/living/proc/backblast(var/amount)
	//src << 'sound/effects/psi/power_feedback.ogg'
	src << "<span class='danger'><font size=3>Wild energistic feedback blasts across your psyche!</font></span>"
	if(prob(60))
		emote("scream")
	if(amount)
		adjustBrainLoss(amount)
	for(var/obj/item/weapon/magic_hand/psi in contents)
		drop_from_inventory(psi)

/mob/living/carbon/human/backblast(var/amount)
	..()
	var/obj/item/organ/brain/sponge = internal_organs_by_name["brain"]
	if(sponge && istype(sponge,/obj/item/organ/brain))
		if(sponge.damage >= sponge.max_damage)
			var/obj/item/organ/external/affecting = get_organ("head")
			if(affecting && !affecting.is_stump())
				affecting.droplimb(0, DROPLIMB_BLUNT)
				if(sponge)
					qdel(sponge)