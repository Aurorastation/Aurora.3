

/*
// Check target_mob if worthy of attack
/mob/living/simple_animal/slime/SA_attackable(target_mob)
	ai_log("SA_attackable([target_mob])",3)
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		if(L.stat == DEAD)
			if(can_consume(L)) // If we can eat them, then it doesn't matter if they're dead.
				return TRUE
	..()
*/

/mob/living/simple_animal/slime/PunchTarget()
	if(victim)
		return // Already eatting someone.
	if(!client) // AI controlled.
		if( (!target_mob.lying && prob(60 + (power_charge * 4) ) || (!target_mob.lying && optimal_combat) )) // "Smart" slimes always stun first.
			a_intent = I_DISARM // Stun them first.
		else if(can_consume(target_mob) && target_mob.lying)
			a_intent = I_GRAB // Then eat them.
		else
			a_intent = I_HURT // Otherwise robust them.
	ai_log("PunchTarget() will [a_intent] [target_mob]",2)
	..()

/mob/living/simple_animal/slime/proc/can_consume(var/mob/living/L)
	if(!L || !istype(L))
		to_chat(src, "This subject is incomparable...")
		return FALSE
	if(L.isSynthetic())
		to_chat(src, "This subject is not biological...")
		return FALSE
	if(L.getarmor(null, "bio") >= 80)
		to_chat(src, "I cannot reach this subject's biological matter...")
		return FALSE
	if(istype(L, /mob/living/simple_animal/slime))
		to_chat(src, "I cannot feed on other slimes...")
		return FALSE
	if(!Adjacent(L))
		to_chat(src, "This subject is too far away...")
		return FALSE
	if(istype(L, /mob/living/carbon) && L.getCloneLoss() >= L.getMaxHealth() * 1.5 || istype(L, /mob/living/simple_animal) && L.stat == DEAD)
		to_chat(src, "This subject does not have an edible life energy...")
		return FALSE
	if(L.buckled_mob)
		if(istype(L.buckled_mob, /mob/living/simple_animal/slime))
			if(L.buckled_mob != src)
				to_chat(src, "\The [L.buckled_mob] is already feeding on this subject...")
				return FALSE
	return TRUE

/mob/living/simple_animal/slime/proc/start_consuming(var/mob/living/L)
	if(!can_consume(L))
		return
	if(!Adjacent(L))
		return
	step_towards(src, L) // Get on top of them to feed.
	if(loc != L.loc)
		return
	if(L.buckle_mob(src, forced = TRUE))
		victim = L
		update_icon()
		victim.visible_message("<span class='danger'>\The [src] latches onto [victim]!</span>",
		"<span class='danger'>\The [src] latches onto you!</span>")

/mob/living/simple_animal/slime/proc/stop_consumption()
	if(!victim)
		return
	victim.unbuckle_mob()
	victim.visible_message("<span class='notice'>\The [src] slides off of [victim]!</span>",
	"<span class='notice'>\The [src] slides off of you!</span>")
	victim = null
	update_icon()


/mob/living/simple_animal/slime/proc/handle_consumption()
	if(victim && can_consume(victim) && !stat)

		var/armor_modifier = abs((victim.getarmor(null, "bio") / 100) - 1)
		if(istype(victim, /mob/living/carbon))
			victim.adjustCloneLoss(rand(5,6) * armor_modifier)
			victim.adjustToxLoss(rand(1,2) * armor_modifier)
			if(victim.health <= 0)
				victim.adjustToxLoss(rand(2,4) * armor_modifier)

		else if(istype(victim, /mob/living/simple_animal))
			victim.adjustBruteLoss(is_adult ? rand(7, 15) : rand(4, 12))

		else
			to_chat(src, "<span class='warning'>[pick("This subject is incompatable", \
			"This subject does not have a life energy", "This subject is empty", "I am not satisified", \
			"I can not feed from this subject", "I do not feel nourished", "This subject is not food")]...</span>")
			stop_consumption()

		adjust_nutrition(50 * armor_modifier)

		adjustOxyLoss(-10 * armor_modifier) //Heal yourself
		adjustBruteLoss(-10 * armor_modifier)
		adjustFireLoss(-10 * armor_modifier)
		adjustCloneLoss(-10 * armor_modifier)
		updatehealth()
		if(victim)
			victim.updatehealth()
	else
		stop_consumption()

/mob/living/simple_animal/slime/DoPunch(var/mob/living/L)
	if(!Adjacent(L)) // Might've moved away in the meantime.
		return

	if(istype(L))

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			// Slime attacks can be blocked with shields.
			if(H.check_shields(damage = 0, damage_source = null, attacker = src, def_zone = null, attack_text = "the attack"))
				return

		switch(a_intent)
			if(I_HELP)
				ai_log("DoPunch() against [L], helping.",2)
				L.visible_message("<span class='notice'>[src] gently pokes [L]!</span>",
				"<span class='notice'>[src] gently pokes you!</span>")
				do_attack_animation(L)
				post_attack(L, a_intent)

			if(I_DISARM)
				ai_log("DoPunch() against [L], disarming.",2)
				var/stun_power = between(0, power_charge + rand(0, 3), 10)

				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					stun_power *= max(H.species.siemens_coefficient,0)


				if(prob(stun_power * 10))
					power_charge = max(0, power_charge - 3)
					L.visible_message("<span class='danger'>[src] has shocked [L]!</span>", "<span class='danger'>[src] has shocked you!</span>")
					playsound(src, 'sound/weapons/Egloves.ogg', 75, 1)
					L.Weaken(4)
					L.Stun(4)
					do_attack_animation(L)
					if(L.buckled)
						L.buckled.unbuckle_mob() // To prevent an exploit where being buckled prevents slimes from jumping on you.
					L.stuttering = max(L.stuttering, stun_power)

					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, L)
					s.start()

					if(prob(stun_power * 10) && stun_power >= 8)
						L.adjustFireLoss(power_charge * rand(1, 2))
					post_attack(L, a_intent)

				else if(prob(40))
					L.visible_message("<span class='danger'>[src] has pounced at [L]!</span>", "<span class='danger'>[src] has pounced at you!</span>")
					playsound(src, 'sound/weapons/thudswoosh.ogg', 75, 1)
					L.Weaken(2)
					do_attack_animation(L)
					if(L.buckled)
						L.buckled.unbuckle_mob() // To prevent an exploit where being buckled prevents slimes from jumping on you.
					post_attack(L, a_intent)
				else
					L.visible_message("<span class='danger'>[src] has tried to pounce at [L]!</span>", "<span class='danger'>[src] has tried to pounce at you!</span>")
					playsound(src, 'sound/weapons/punchmiss.ogg', 75, 1)
					do_attack_animation(L)
				L.updatehealth()
				return L

			if(I_GRAB)
				ai_log("DoPunch() against [L], grabbing.",2)
				start_consuming(L)
				post_attack(L, a_intent)

			if(I_HURT)
				ai_log("DoPunch() against [L], hurting.",2)
				var/damage_to_do = rand(melee_damage_lower, melee_damage_upper)
				var/armor_modifier = abs((L.getarmor(null, "bio") / 100) - 1)

				L.attack_generic(src, damage_to_do, attacktext)
				playsound(src, 'sound/weapons/bite.ogg', 75, 1)

				// Give the slime some nutrition, if applicable.
				if(!L.isSynthetic())
					if(ishuman(L))
						if(L.getCloneLoss() < L.getMaxHealth() * 1.5)
							adjust_nutrition(damage_to_do * armor_modifier)

					else if(istype(L, /mob/living/simple_animal))
						if(!isslime(L))
							var/mob/living/simple_animal/SA = L
							if(!SA.stat)
								adjust_nutrition(damage_to_do)

				post_attack(L, a_intent)

	if(istype(L,/obj/mecha))
		var/obj/mecha/M = L
		M.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext)

/mob/living/simple_animal/slime/proc/post_attack(var/mob/living/L, var/intent = I_HURT)
	if(intent != I_HELP)
		if(L.reagents && L.can_inject() && reagent_injected)
			L.reagents.add_reagent(reagent_injected, injection_amount)

/mob/living/simple_animal/slime/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/clothing/head)) // Handle hat simulator.
		give_hat(W, user)
		return

	// Otherwise they're probably fighting the slime.
	if(prob(25))
		visible_message("<span class='danger'>\The [user]'s [W] passes right through [src]!</span>")
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		return
	..()

/mob/living/simple_animal/slime/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	..()
	if(!stat)
		if(O.force > 0 && discipline && !rabid) // wow, buddy, why am I getting attacked??
			adjust_discipline(1)
			return
		if(O.force >= 3)
			if(victim || target_mob) // We've been a bad slime.
				if(is_adult)
					if(prob(5 + round(O.force / 2)) )
						if(prob(80) && !client)
							adjust_discipline(2)
						if(user)
							step_away(src, user)
				else
					if(prob(10 + O.force * 2))
						if(prob(80) && !client)
							adjust_discipline(2)
						if(user)
							step_away(src, user)
			else
				if(user in friends) // Friend attacking us for no reason.
					if(prob(25))
						friends -= user
						say("[user]... not friend...")

/mob/living/simple_animal/slime/attack_hand(mob/living/carbon/human/M as mob)
	if(victim) // Are we eating someone?
		var/fail_odds = 30
		if(victim == M) // Harder to get the slime off if its eating you right now.
			fail_odds = 60

		if(prob(fail_odds))
			visible_message("<span class='warning'>[M] attempts to wrestle \the [name] off!</span>")
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

		else
			visible_message("<span class='warning'> [M] manages to wrestle \the [name] off!</span>")
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

			if(prob(40) && !client)
				adjust_discipline(1)
			stop_consumption()
			step_away(src,M)
	else
		if(M.a_intent == I_HELP)
			if(hat)
				remove_hat(M)
			else
				..()
		else
			..()

// Shocked grilles don't hurt slimes, and in fact give them charge.
/mob/living/simple_animal/slime/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null)
	power_charge = between(0, power_charge + round(shock_damage / 10), 10)
	to_chat(src, "<span class='notice'>\The [source] shocks you, and it charges you.</span>")
