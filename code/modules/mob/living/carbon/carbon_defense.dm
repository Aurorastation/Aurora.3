/mob/living/carbon/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	..()
	var/show_ssd
	var/mob/living/carbon/human/H
	if(ishuman(src))
		H = src
		show_ssd = H.species.show_ssd
	if(H && show_ssd && !client && !teleop)
		if(H.bg)
			visible_message(SPAN_DANGER("[src] is hit by [hitting_atom] waking [get_pronoun("him")] up!"))
			if(H.health / H.maxHealth < 0.5)
				H.bg.awaken_impl(TRUE)
				sleeping = 0
				willfully_sleeping = FALSE
			else
				to_chat(H, SPAN_DANGER("You sense great disturbance to your physical body!"))
		else if(!vr_mob)
			visible_message(SPAN_DANGER("[src] is hit by [hitting_atom], but they do not respond... Maybe they have S.S.D?"))
	else if(client && willfully_sleeping)
		visible_message(SPAN_DANGER("[src] is hit by [hitting_atom] waking [get_pronoun("him")] up!"))
		sleeping = 0
		willfully_sleeping = FALSE

/mob/living/carbon/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	//Carbon have blood, so when hit with sufficient force, they bleed; this shows the effect of bleeding when hit by a projectile
	if(hitting_projectile.damage_type == DAMAGE_BRUTE && hitting_projectile.damage > 5) //weak hits shouldn't make you gush blood
		var/splatter_color = COLOR_HUMAN_BLOOD
		if (src.species && src.get_blood_color())
			splatter_color = src.get_blood_color()

		var/splatter_dir = hitting_projectile.starting ? get_dir(hitting_projectile.starting, get_turf(src)) : dir
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(src), splatter_dir, splatter_color)

	var/mob/living/carbon/human/H
	if(ishuman(src))
		H = src

	if(hitting_projectile.damage > 0)
		if(H && H.species.show_ssd && !client && !teleop)
			if(H.bg)
				if(!hitting_projectile.do_not_log)
					visible_message(SPAN_DANGER("[hitting_projectile] hit [src] waking [get_pronoun("him")] up!"))

				if(H.health / H.maxHealth < 0.5)
					H.bg.awaken_impl(TRUE)
					sleeping = 0
					willfully_sleeping = FALSE
				else
					if(!hitting_projectile.do_not_log)
						to_chat(H, SPAN_DANGER("You sense great disturbance to your physical body!"))

			else if(!vr_mob)
				if(!hitting_projectile.do_not_log)
					visible_message(SPAN_DANGER("[hitting_projectile] hit [src], but they do not respond... Maybe they have S.S.D?"))

		else if(client && willfully_sleeping)
			if(!hitting_projectile.do_not_log)
				visible_message(SPAN_DANGER("[hitting_projectile] hit [src] waking [get_pronoun("him")] up!"))

			sleeping = 0
			willfully_sleeping = FALSE

/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
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
			user.visible_message(SPAN_DANGER("[user] attacks [src] with [I] waking [get_pronoun("him")] up!"), \
									SPAN_DANGER("You attack [src] with [I], but they do not respond... Maybe they have S.S.D?"))
	else if(client && willfully_sleeping)
		user.visible_message(SPAN_DANGER("[user] attacked [src] with [I] waking [get_pronoun("him")] up!"), \
							SPAN_DANGER("You attack [src] with [I], waking [get_pronoun("him")] up!"))
		sleeping = 0
		willfully_sleeping = FALSE


	if(!effective_force)
		return 0

	//Hulk modifier
	if((user.mutations & HULK))
		effective_force *= 2

	//Apply weapon damage
	var/damage_flags = I.damage_flags()
	var/datum/wound/created_wound = apply_damage(effective_force, I.damtype, hit_zone, I, damage_flags, I.armor_penetration)

	//Melee weapon embedded object code.
	if (I && I.damtype == DAMAGE_BRUTE && !I.anchored && !is_robot_module(I) && I.canremove)
		var/damage = effective_force //just the effective damage used for sorting out embedding, no further damage is applied here
		damage *= 1 - get_blocked_ratio(hit_zone, I.damtype, I.damage_flags(), I.armor_penetration, I.force)

		if(I.can_embed) //If this weapon is allowed to embed in people.
			//blunt objects should really not be embedding in things unless a huge amount of force is involved
			var/sharp = damage_flags & DAMAGE_FLAG_SHARP
			var/edge = damage_flags & DAMAGE_FLAG_EDGE
			var/embed_chance = sharp? damage/I.w_class : damage/(I.w_class*3)
			var/embed_threshold = edge? 5*I.w_class : 15*I.w_class

			//Sharp objects will always embed if they do enough damage.
			if((sharp && damage > (10*I.w_class)) || (damage > embed_threshold && prob(embed_chance)))
				src.embed(I, hit_zone, supplied_wound = created_wound)

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
