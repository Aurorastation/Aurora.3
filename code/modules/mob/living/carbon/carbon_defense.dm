
//Called when the mob is hit with an item in combat.
/mob/living/carbon/resolve_item_attack(obj/item/I, mob/living/user, var/hit_zone)
	if(check_attack_throat(I, user))
		return null
	return ..()

/mob/living/carbon/hitby(atom/movable/AM as mob|obj,var/speed = THROWFORCE_SPEED_DIVISOR)
	..(AM, speed)
	var/t_him = "it"
	if (src.gender == MALE)
		t_him = "him"
	else if (src.gender == FEMALE)
		t_him = "her"
	var/show_ssd
	var/mob/living/carbon/human/H
	if(ishuman(src))
		H = src
		show_ssd = H.species.show_ssd
	if(H && show_ssd && !client && !teleop)
		if(H.bg)
			visible_message(SPAN_DANGER("[src] is hit by [AM] waking [t_him] up!"))
			if(H.health / H.maxHealth < 0.5)
				H.bg.awaken_impl(TRUE)
				sleeping = 0
				willfully_sleeping = FALSE
			else
				to_chat(H, SPAN_DANGER("You sense great disturbance to your physical body!"))
		else if(!vr_mob)
			visible_message(SPAN_DANGER("[src] is hit by [AM], but they do not respond... Maybe they have S.S.D?"))
	else if(client && willfully_sleeping)
		visible_message(SPAN_DANGER("[src] is hit by [AM] waking [t_him] up!"))
		sleeping = 0
		willfully_sleeping = FALSE

/mob/living/carbon/bullet_act(var/obj/item/projectile/P, var/def_zone)
	..(P, def_zone)
	var/t_him = "it"
	if (src.gender == MALE)
		t_him = "him"
	else if (src.gender == FEMALE)
		t_him = "her"
	var/show_ssd
	var/mob/living/carbon/human/H
	if(ishuman(src))
		H = src
		show_ssd = H.species.show_ssd
	if(H && show_ssd && !client && !teleop)
		if(H.bg)
			visible_message("<span class='danger'>[P] hit [src] waking [t_him] up!</span>")
			if(H.health / H.maxHealth < 0.5)
				H.bg.awaken_impl(TRUE)
				sleeping = 0
				willfully_sleeping = FALSE
			else
				to_chat(H, SPAN_DANGER("You sense great disturbance to your physical body!"))
		else if(!vr_mob)
			visible_message("<span class='danger'>[P] hit [src], but they do not respond... Maybe they have S.S.D?</span>")
	else if(client && willfully_sleeping)
		visible_message("<span class='danger'>[P] hit [src] waking [t_him] up!</span>")
		sleeping = 0
		willfully_sleeping = FALSE

/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	var/t_him = "it"
	if (src.gender == MALE)
		t_him = "him"
	else if (src.gender == FEMALE)
		t_him = "her"
	var/show_ssd
	var/mob/living/carbon/human/H
	if(ishuman(src))
		H = src
		show_ssd = H.species.show_ssd
	if(H && show_ssd && !client && !teleop)
		if(H.bg)
			if(H.health / H.maxHealth < 0.5)
				H.bg.awaken_impl(TRUE)
				sleeping = 0
				willfully_sleeping = FALSE
			else
				to_chat(H, SPAN_DANGER("You sense great disturbance to your physical body!"))
		else if(!vr_mob)
			user.visible_message("<span class='danger'>[user] attacks [src] with [I] waking [t_him] up!</span>", \
					    "<span class='danger'>You attack [src] with [I], but they do not respond... Maybe they have S.S.D?</span>")
	else if(client && willfully_sleeping)
		user.visible_message("<span class='danger'>[user] attacked [src] with [I] waking [t_him] up!</span>", \
							"<span class='danger'>You attack [src] with [I], waking [t_him] up!</span>")
		sleeping = 0
		willfully_sleeping = FALSE


	if(!effective_force)
		return 0

	//Hulk modifier
	if(HULK in user.mutations)
		effective_force *= 2

	//Apply weapon damage
	var/damage_flags = I.damage_flags()
	apply_damage(effective_force, I.damtype, hit_zone, I, damage_flags, I.armor_penetration)

	//Melee weapon embedded object code.
	if (I && I.damtype == BRUTE && !I.anchored && !is_robot_module(I) && I.canremove)
		var/damage = effective_force //just the effective damage used for sorting out embedding, no further damage is applied here
		damage *= 1 - get_blocked_ratio(hit_zone, I.damtype, I.damage_flags(), I.armor_penetration, I.force)

		if(I.can_embed) //If this weapon is allowed to embed in people.
			//blunt objects should really not be embedding in things unless a huge amount of force is involved
			var/sharp = damage_flags & DAM_SHARP
			var/edge = damage_flags & DAM_EDGE
			var/embed_chance = sharp? damage/I.w_class : damage/(I.w_class*3)
			var/embed_threshold = edge? 5*I.w_class : 15*I.w_class

			//Sharp objects will always embed if they do enough damage.
			if((sharp && damage > (10*I.w_class)) || (damage > embed_threshold && prob(embed_chance)))
				src.embed(I, hit_zone)

	return 1

// Attacking someone with a weapon while they are neck-grabbed
/mob/living/carbon/proc/check_attack_throat(obj/item/W, mob/user)
	if(user.a_intent == I_HURT)
		for(var/obj/item/grab/G in src.grabbed_by)
			if(G.assailant == user && G.state >= GRAB_NECK)
				if(attack_throat(W, G, user))
					return 1
	return 0

// Knifing
/mob/living/carbon/proc/attack_throat(obj/item/W, obj/item/grab/G, mob/user)
	var/damage_flags = W.damage_flags()
	if(!(damage_flags & (DAM_SHARP|DAM_EDGE)) || W.damtype != BRUTE)
		return FALSE //unsuitable weapon

	user.visible_message("<span class='danger'>\The [user] begins to slit [src]'s throat with \the [W]!</span>")

	user.next_move = world.time + 20 //also should prevent user from triggering this repeatedly
	if(!W.use_tool(src, user, 20, volume = 50))
		return 0
	if(!(G && G.assailant == user && G.affecting == src)) //check that we still have a grab
		return 0

	var/damage_mod = 1
	//presumably, if they are wearing a helmet that stops pressure effects, then it probably covers the throat as well
	var/obj/item/clothing/head/helmet = get_equipped_item(slot_head)
	if(istype(helmet) && (helmet.body_parts_covered & HEAD) && (helmet.min_pressure_protection == 0))
		var/datum/component/armor/armor_component = helmet.GetComponent(/datum/component/armor)
		if(armor_component)
			damage_mod -= armor_component.get_blocked(BRUTE, damage_flags, W.armor_penetration, W.force*1.5)

	var/total_damage = 0
	for(var/i in 1 to 3)
		var/damage = min(W.force*1.5, 20)*damage_mod
		apply_damage(damage, W.damtype, BP_HEAD, 0, used_weapon = W, damage_flags = damage_flags)
		total_damage += damage

	var/oxyloss = total_damage
	if(total_damage >= 40) //threshold to make someone pass out
		oxyloss = 60 // Brain lacks oxygen immediately, pass out

	adjustOxyLoss(min(oxyloss, 100 - getOxyLoss())) //don't put them over 100 oxyloss

	if(total_damage)
		if(getOxyLoss() >= 40)
			user.visible_message("<span class='danger'>\The [user] slices [src]'s throat open with \the [W]!</span>")
		else
			user.visible_message("<span class='danger'>\The [user] cuts [src]'s neck open with \the [W]!</span>")

		if(W.hitsound)
			playsound(loc, W.hitsound, W.get_clamped_volume(), 1, -1)

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
		if(head)
			head.sever_artery()

	G.last_action = world.time
	flick(G.hud.icon_state, G.hud)

	user.attack_log += "\[[time_stamp()]\]<span class='warning'> Knifed [name] ([ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])</span>"
	src.attack_log += "\[[time_stamp()]\]<font color='orange'> Got knifed by [user.name] ([user.ckey]) with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])</font>"
	msg_admin_attack("[key_name_admin(user)] knifed [key_name_admin(src)] with [W.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(W.damtype)])",ckey=key_name(user),ckey_target=key_name(src) )
	return 1

/mob/living/carbon/Stun(amount)
	help_up_offer = 0
	..()

/mob/living/carbon/Weaken(amount)
	help_up_offer = 0
	..()

/mob/living/carbon/Paralyse(amount)
	help_up_offer = 0
	..()

/mob/living/carbon/Sleeping(amount)
	help_up_offer = 0
	..()

/mob/living/carbon/Resting(amount)
	help_up_offer = 0
	..()
