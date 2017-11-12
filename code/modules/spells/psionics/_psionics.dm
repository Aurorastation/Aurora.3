//Psionics is like magic, but instead of relying on energy from extradimensional sources, it relies on the infinitely untapped energy within the sentient mind.
//Everyone has the potential within them, but only a select few have learned the secrets of unlocking their brain. These special few are called the AWOKEN.
//Awoken ranged in power levels, from mere freshly awoken Initiates, with a sparse few powers and all the parlour tricks of their discipline, to LEVIATHANS.
//Awoken in game can only mechanically reach the power level of Grandmasterclass. Perhaps in the future we will consider the godlike LEVIATHANS.
//Psionic power is tied to the brain item, because everyone with a brain has psionic potential. Currently there are only mechanics for the Urlamians, who all spawn
//Awoken. Perhaps in the future there will be means of awakening throughout the course of the round.

/spell/hand/psyker
	name = "Psionic Power"
	desc = "A psionic power."
	school = "Undisciplined"
	panel = "Psionic Powers"
	still_recharging_msg = "<span class='notice'>This psionic power is still recharging.</span>"
	spell_flags = Z2NOCAST
	invocation = "is surrounded by purplish light as their dominant hand fills with psionic energy."
	invocation_type = SpI_EMOTE
	message = ""
	sparks_spread = 0
	sparks_amt = 0
	power_level = 0
	power_cost = 0
	duration = 0
	casts = 0
	spell_delay = 5
	touch = 0
	charge_max = 100
	var/friendly = 0 //spell is not hostile if 1

	hud_state = "wiz_psy"
	var/obj/item/organ/brain/brain

/spell/hand/psyker/cast(list/targets, mob/user)
	for(var/mob/M in targets)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.get_active_hand())
				user << "<span class='warning'>You need an empty hand to cast this spell.</span>"
				return
			brain = H.internal_organs_by_name["brain"]
			if(!istype(brain,/obj/item/organ/brain) || !brain)
				user << "<span class='warning'>You lack the brain necessary for psionic power!</span>"
				return
			if(brain.max_willpower <= 0)
				user << "<span class='warning'>You lack the willpower necessary for psionic power!</span>"
				return
			if(!brain.awoken)
				user << "<span class='warning'>You do not know how to access the secrets of the mind!</span>"
				return
			var/obj/item/magic_hand/psyker/Hand = new(src)
			if(!H.put_in_active_hand(Hand))
				qdel(Hand)
				return
			brain.willpower -= power_cost
			if(brain.willpower < 0)
				H.backblast((brain.willpower * -1))
		else
			user << "<span class='warning'>Your mind is not complex enough for such artistry!</span>"
			return

/spell/hand/psyker/cast_hand(var/atom/A,var/mob/user) //same for casting.
	if(A != user || friendly) //spells targeted on yourself don't get resisted by yourself, usually. friendly spells like healing don't get resisted
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(H.stat == UNCONSCIOUS || H.stat == DEAD)
				user << "<span class='warning'>You cannot penetrate the depths of the unconscious mind!</span>"
				return 0
			brain = H.internal_organs_by_name["brain"]
			if(!istype(brain,/obj/item/organ/brain) || !brain)
				user << "<span class='warning'>You cannot recognize the mechanisms of \the [H]'s mind!</span>"
				return 0
			else if(brain.max_willpower < 0)
				user << "<span class='warning'>\The [H] is immune to your psionic tricks!</span>"
				return 0
			else
				if(brain.willpower >= brain.willpower && brain.willpower < brain.willpower * 3)
					brain.willpower -= brain.power_level*3
					if(prob(66))
						return 0
					if(brain.awoken)
						user << "<span class='warning'>\The [H] consciously battles against your psionic power!</span>"
						H << "<span class='warning'>You resist against \the [user]'s insidious mental assault!</span>"
					else
						user << "<span class='warning'>\The [H] subconsciously battles against your psionic power!</span>"
				else if(brain.willpower >= brain.willpower * 3)
					user << "<span class='warning'>\The [H]'s strength of will far surpasses your own! Pull out, pull out!!</span>"
					if(isliving(user))
						var/mob/living/L = user
						L.backblast(5)
					if(brain.awoken)
						H << "<span class='warning'>You swat away \the [user]'s insidious mental assault like a fly!</span>"
					return 0

/obj/item/magic_hand/psyker
	name = "psionic power"
	icon = 'icons/obj/wizard.dmi'
	flags = 0
	abstract = 1
	w_class = 5.0
	icon_state = "psy_hand"
	var/duration
	var/obj/item/organ/brain/brain

/obj/item/magic_hand/psyker/New(var/spell/hand/psyker/S)
	...()
	set_light(2,1,"#800080")
	brain = S.brain
	duration = S.duration
	if(casts == 0) //if casts is predefined, use that instead
		if(S.power_level > 0)
			casts = S.casts * round(brain.power_level/S.power_level) //Ex: at power level 5 you gain 5 casts of a 1st level spell, but only 1 cast of a 5th level spell
		else
			casts = -1 //You can c	ast a cantrip infinitely within its duration.
		QDEL_IN(src, duration SECONDS)

/mob/living/proc/backblast(var/amount)
	//src << 'sound/effects/psi/power_feedback.ogg'
	src << "<span class='danger'><font size=3>Wild energistic feedback blasts across your psyche!</font></span>"
	if(prob(60))
		emote("scream")
	if(amount)
		adjustBrainLoss(amount)
	for(var/obj/item/magic_hand/psyker/psi in contents)
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