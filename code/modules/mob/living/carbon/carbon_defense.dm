
//Called when the mob is hit with an item in combat.
/mob/living/carbon/resolve_item_attack(obj/item/I, mob/living/user, var/hit_zone)
	if(check_attack_throat(I, user))
		return null
	return ..()

	if(!effective_force || blocked >= 100)
		return 0

	//Hulk modifier
	if(HULK in user.mutations)
		effective_force *= 2



	if (I && I.damtype == BRUTE && !I.anchored && !is_robot_module(I))
		var/damage = effective_force //just the effective damage used for sorting out embedding, no further damage is applied here
		if (blocked)
			damage *= BLOCKED_MULT(blocked)

			//blunt objects should really not be embedding in things unless a huge amount of force is involved

			//Sharp objects will always embed if they do enough damage.
				src.embed(I, hit_zone)

	return 1

/mob/living/carbon/proc/check_attack_throat(obj/item/W, mob/user)
	if(user.a_intent == I_HURT)
			if(G.assailant == user && G.state >= GRAB_NECK)
				if(attack_throat(W, G, user))
					return 1
	return 0

// Knifing

	if(!W.edge || !W.force || W.damtype != BRUTE)

	user.visible_message("<span class='danger'>\The [user] begins to slit [src]'s throat with \the [W]!</span>")

	user.next_move = world.time + 20 //also should prevent user from triggering this repeatedly
	if(!do_after(user, 20))
		return 0
	if(!(G && G.assailant == user && G.affecting == src)) //check that we still have a grab
		return 0

	var/damage_mod = 1
	//presumably, if they are wearing a helmet that stops pressure effects, then it probably covers the throat as well
	var/obj/item/clothing/head/helmet = get_equipped_item(slot_head)
	if(istype(helmet) && (helmet.body_parts_covered & HEAD) && (helmet.flags & STOPPRESSUREDAMAGE))
		damage_mod = 1.0 - (LAZYACCESS(helmet.armor, "melee")/100)

	var/total_damage = 0
	for(var/i in 1 to 3)
		var/damage = min(W.force*1.5, 20)*damage_mod
		apply_damage(damage, W.damtype, "head", 0, sharp=W.sharp, edge=W.edge)
		total_damage += damage

	var/oxyloss = total_damage
	if(total_damage >= 40) //threshold to make someone pass out
		oxyloss = 60 // Brain lacks oxygen immediately, pass out

	adjustOxyLoss(min(oxyloss, 100 - getOxyLoss())) //don't put them over 100 oxyloss

	if(total_damage)
		if(oxyloss >= 40)
			user.visible_message("<span class='danger'>\The [user] slit [src]'s throat open with \the [W]!</span>")
		else
			user.visible_message("<span class='danger'>\The [user] cut [src]'s neck with \the [W]!</span>")

		if(W.hitsound)
			playsound(loc, W.hitsound, 50, 1, -1)

	G.last_action = world.time
	flick(G.hud.icon_state, G.hud)

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Knifed [name] ([ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])</font>"
	src.attack_log += "\[[time_stamp()]\]<font color='orange'> Got knifed by [user.name] ([user.ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])</font>"
	msg_admin_attack("[key_name_admin(user)] knifed [key_name_admin(src)] with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])",ckey=key_name(user),ckey_target=key_name(src) )
	return 1
