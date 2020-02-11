// Generic damage proc (slimes and monkeys).
/atom/proc/attack_generic(mob/user as mob)
	return 0

/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/human/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	var/obj/item/clothing/glasses/GS = glasses
	if(istype(G) && G.Touch(A,src,1))
		return
	
	else if(istype(GS) && GS.Look(A,src,1)) // for goggles
		return

	A.attack_hand(src)

/atom/proc/attack_hand(mob/user as mob)
	return

/mob/proc/attack_empty_hand(var/bp_hand)
	return

/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/human/RangedAttack(var/atom/A)
	var/obj/item/clothing/gloves/GV = gloves
	var/obj/item/clothing/glasses/GS = glasses
	
	if(istype(GS) && GS.Look(A,src,0)) // for goggles
		return
	
	if(istype(GV) && GV.Touch(A,src,0)) // for magic gloves
		return

	. = ..()

/mob/living/RestrainedClickOn(var/atom/A)
	return

/*
	Aliens
*/

/mob/living/carbon/alien/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/alien/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return 0

	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	A.attack_generic(src,rand(5,6),"bitten")

/*
	Slimes
	Nothing happening here
*/

/mob/living/carbon/slime/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/slime/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return

	// Eating
	if(victim)
		if (victim == A)
			Feedstop()
		return

	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	var/mob/living/M = A
	if(ishuman(M) && !istype(M, /mob/living/carbon/human/monkey) && content)
		return
	if(istype(M))
		switch(src.a_intent)
			if (I_HELP) // We just poke the other
				M.visible_message("<span class='notice'>[src] gently pokes [M]!</span>", "<span class='notice'>[src] gently pokes you!</span>")
			if (I_DISARM) // We stun the target, with the intention to feed
				var/stunprob = 1
				var/power = max(0, min(10, (powerlevel + rand(0, 3))))
				if (powerlevel > 0 && !istype(A, /mob/living/carbon/slime))
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						stunprob *= H.species.siemens_coefficient

					switch(power * 10)
						if(0)
							stunprob *= 10
						if(1 to 2)
							stunprob *= 20
						if(3 to 4)
							stunprob *= 30
						if(5 to 6)
							stunprob *= 40
						if(7 to 8)
							stunprob *= 60
						if(9)
							stunprob *= 70
						if(10)
							stunprob *= 95

				if(prob(stunprob))
					powerlevel = max(0, powerlevel-3)
					M.visible_message("<span class='danger'>[src] has shocked [M]!</span>", "<span class='danger'>[src] has shocked you!</span>")
					M.Weaken(power)
					M.Stun(power)
					M.stuttering = max(M.stuttering, power)

					spark(M, 5, alldirs)

					if(prob(stunprob) && powerlevel >= 8)
						M.adjustFireLoss(powerlevel * rand(6,10))
				else if(prob(40))
					M.visible_message("<span class='danger'>[src] has pounced at [M]!</span>", "<span class='danger'>[src] has pounced at you!</span>")
					M.Weaken(power)
				else
					M.visible_message("<span class='danger'>[src] has tried to pounce at [M]!</span>", "<span class='danger'>[src] has tried to pounce at you!</span>")
				M.updatehealth()
			if (I_GRAB) // We feed
				Wrap(M)
			if (I_HURT) // Attacking
				A.attack_generic(src, (is_adult ? rand(20,40) : rand(5,25)), "glomped")
	else
		A.attack_generic(src, (is_adult ? rand(20,40) : rand(5,25)), "glomped") // Basic attack.
/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/abstract/new_player/ClickOn()
	return

/*
	Animals
*/
/mob/living/simple_animal/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return
	if(istype(A,/mob/living))
		if(melee_damage_upper == 0)
			custom_emote(1,"[friendly] [A]!")
			return
		if(ckey)
			add_logs(src, A, attacktext)
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/damage = rand(melee_damage_lower, melee_damage_upper)
	if(A.attack_generic(src,damage,attacktext,environment_smash) && loc && attack_sound)
		playsound(loc, attack_sound, 50, 1, 1)
