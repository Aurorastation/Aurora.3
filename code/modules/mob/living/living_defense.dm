/mob/living/proc/modify_damage_by_armor(def_zone, damage, damage_type, damage_flags, mob/living/victim, armor_pen, silent = FALSE)
	var/list/armors = get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = args.Copy(2)
	for(var/armor in armors)
		var/datum/component/armor/armor_datum = armor
		. = armor_datum.apply_damage_modifications(arglist(.))

/mob/living/check_projectile_armor(def_zone, obj/projectile/impacting_projectile, is_silent)
	if(impacting_projectile.damage > 0) // Run the block computation if we did damage or if we only use armor for effects (nodamage)
		//Since we get a ratio from this and we need a percentage, we multiply by 100 to get the percentage
		return (get_blocked_ratio(def_zone, impacting_projectile.damage_type, impacting_projectile.damage_flags(), impacting_projectile.armor_penetration, impacting_projectile.damage) * 100)
	return 0

/mob/living/proc/get_blocked_ratio(def_zone, damage_type, damage_flags, armor_pen, damage)
	var/list/armors = get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = 0
	for(var/armor in armors)
		var/datum/component/armor/armor_datum = armor
		. = 1 - (1 - .) * (1 - armor_datum.get_blocked(damage_type, damage_flags, armor_pen, damage)) // multiply the amount we let through
	. = min(1, .)

/mob/living/proc/get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = list()
	var/natural_armor = GetComponent(/datum/component/armor)
	if(natural_armor)
		. += natural_armor
	if(psi)
		var/armor = psi.GetComponent(/datum/component/armor/psionic)
		if(armor)
			. += armor

/**
 * Determines if the mob has a shield, and what to do with it
 *
 * Returns one of the `BULLET_ACT_*` defines
 *
 * `BULLET_ACT_HIT` if the shield didn't block the hit,
 * `BULLET_ACT_BLOCK` if the shield blocked the hit,
 * `BULLET_ACT_FORCE_PIERCE` if the shield avoided the mob from being hit, but whatever hit it wasn't stopped (eg. a bullet that doesn't hit the mob, but gets deflected)
 */
/mob/living/proc/check_shields(damage, atom/damage_source, mob/attacker, def_zone, attack_text)
	return BULLET_ACT_HIT

/mob/living/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	/*#############################################
		THINGS THAT CAN AVOID THE MOB BEING HIT
		OR ALTER THE DAMAGE WE TAKE
	#############################################*/

	var/blocked

	//Auras, essentially magic and encompassing around us, gets checked first
	if(!src.aura_check(AURA_TYPE_BULLET, hitting_projectile, def_zone, piercing_hit))
		blocked = 100
		return BULLET_ACT_FORCE_PIERCE


	//Shields, in front of us (hopefully), check the bullet before it reaches us
	var/shield_check = check_shields(hitting_projectile.damage, hitting_projectile, hitting_projectile.firer, def_zone, "the [hitting_projectile.name]")
	if(shield_check != BULLET_ACT_HIT)
		hitting_projectile.on_hit(src, 100, def_zone)
		return shield_check


	//Armor, right above our skin, can soften the hit

	// we need a second, silent armor check to actually know how much to reduce damage taken, as opposed to
	// on [/atom/proc/bullet_act] where it's just to pass it to the projectile's on_hit().
	blocked = check_projectile_armor(def_zone, hitting_projectile, is_silent = TRUE)

	var/damage = hitting_projectile.damage //We use a supporting variable to store the damage, since we can alter it below
	//If it's anti material vulnerable, apply the anti-material potential factor
	if(is_anti_materiel_vulnerable())
		damage = hitting_projectile.damage * hitting_projectile.anti_materiel_potential

	/*##################################
		OK WE ARE BEING HIT NOW IF
		WE HAVE REACHED THIS POINT
	##################################*/

	//If the projectile has damage and it's not completely blocked, apply it
	if(damage > 0 && blocked < 100)
		//Apply the damage to the living mob
		apply_damage(damage, hitting_projectile.damage_type, def_zone, blocked, used_weapon = hitting_projectile, damage_flags = hitting_projectile.damage_flags(), used_weapon = hitting_projectile, armor_pen = hitting_projectile.armor_penetration)

		/*### START Other effects of being hit and damaged ###*/

		//Being hit while using a cloaking device
		var/obj/item/cloaking_device/C = locate(/obj/item/cloaking_device) in src
		if(C && C.active)
			C.attack_self(src)//Should shut it off
			update_icon()
			to_chat(src, SPAN_NOTICE("Your [C.name] was disrupted!"))
			Stun(2)

		//Being hit while using a deadman switch
		var/obj/item/device/assembly/signaler/signaler = get_active_hand()
		if(istype(signaler))
			if(signaler.deadman && prob(80))
				log_and_message_admins("has triggered a signaler deadman's switch")
				src.visible_message(SPAN_WARNING("[src] triggers their deadman's switch!"))
				signaler.signal()

		/*### END Other effects of being hit and damaged ###*/

	bullet_impact_visuals(hitting_projectile, def_zone, damage, blocked)

	//Messages related to being hit (not necessarily damaged)
	if(!hitting_projectile.do_not_log)
		var/impacted_organ = get_organ_name_from_zone(def_zone)

		//If the projectile was blocked and it's not at point blank range, then it missed
		if(blocked >= 100 && !hitting_projectile.point_blank)
			src.visible_message(SPAN_NOTICE("\The [hitting_projectile] misses [src] narrowly!"))
			playsound(src, /singleton/sound_category/bulletflyby_sound, 50, 1)

		//Otherwise it hit
		else

			//If the projectile is suppressed, give a message only to the mob, and a smaller one
			if(hitting_projectile.suppressed)
				to_chat(src, SPAN_DANGER("You've been hit in the [impacted_organ] by \a [hitting_projectile]!"))

			//Otherwise announce it as a visible message, and make it larger
			else
				//X has fired Y is now given by the guns so you cant tell who shot you if you could not see the shooter
				src.visible_message(SPAN_DANGER("\The [src] is hit by \a [hitting_projectile] in the [impacted_organ]!"),
									SPAN_DANGER(FONT_LARGE("You are hit by \a [hitting_projectile] in the [impacted_organ]!")))


	if(blocked < 100)
		return BULLET_ACT_HIT
	else
		return BULLET_ACT_BLOCK

/mob/living/proc/get_flash_protection(ignore_inherent = FALSE)
	return FLASH_PROTECTION_NONE

/mob/living/proc/get_hearing_protection()
	return FALSE

/mob/living/proc/get_hearing_sensitivity()
	return FALSE

/mob/living/proc/aura_check(var/type)
	if(!auras)
		return TRUE
	. = TRUE
	var/list/newargs = args - args[1]
	for(var/obj/aura/aura as anything in auras)
		var/result = 0
		switch(type)
			if(AURA_TYPE_WEAPON)
				result = aura.attackby(arglist(newargs))
			if(AURA_TYPE_BULLET)
				result = aura.bullet_act(arglist(newargs))
			if(AURA_TYPE_THROWN)
				result = aura.hitby(arglist(newargs))
			if(AURA_TYPE_LIFE)
				result = aura.life_tick()
		if(result & AURA_FALSE)
			. = FALSE
		if(result & AURA_CANCEL)
			break

/**
 * For visuals, blood splatters and so on
 *
 * * impacting_projectile - The `/obj/projectile` that hit the mob
 * * def_zone - The zone that the projectile hit the mob in, use the defines
 * * damage - The amount of damage the projectile did
 * * blocked - The **percentage** of damage that was blocked, eg. by armor, a number
 */
/mob/living/proc/bullet_impact_visuals(obj/projectile/impacting_projectile, def_zone, damage, blocked)
	SHOULD_NOT_SLEEP(TRUE)

	var/list/impact_sounds = LAZYACCESS(impacting_projectile.impact_sounds, get_bullet_impact_effect_type(def_zone))
	if(length(impact_sounds))
		playsound(src, pick(impact_sounds), 75)

/mob/living/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_MEAT

//Handles the effects of "stun" weapons
/mob/living/proc/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone, var/used_weapon, var/damage_flags)
	flash_pain(stun_amount)

	if(stun_amount)
		Stun(stun_amount)
		Weaken(stun_amount)
		apply_effect(stun_amount, STUTTER)
		apply_effect(stun_amount, EYE_BLUR)

	if(agony_amount)
		apply_damage(agony_amount, DAMAGE_PAIN, def_zone, used_weapon)
		apply_effect(agony_amount / 10, STUTTER)
		apply_effect(agony_amount / 10, EYE_BLUR)

/mob/living/proc/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null, var/tesla_shock = 0, var/ground_zero)
	return 0 //only carbon liveforms have this proc

/mob/living/emp_act(severity)
	. = ..()

	var/list/L = src.get_contents()
	for(var/obj/O in L)
		O.emp_act(severity)

/mob/living/flash_act(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, ignore_inherent = FALSE, type = /atom/movable/screen/fullscreen/flash, length = 2.5 SECONDS)
	if(is_blind() && !(override_blindness_check || affect_silicon))
		return FALSE

	if(get_flash_protection(ignore_inherent) >= intensity)
		return FALSE

	overlay_fullscreen("flash", type)
	addtimer(CALLBACK(src, /mob/proc/clear_fullscreen, "flash", length), length)
	return TRUE

/// Called when the mob hears a very loud noise!
/// Intensity can be an EAR_PROTECTION_X define or an arbitrary/computed value between -1 and 2 (or more if you're insane)
/mob/living/proc/noise_act(intensity = EAR_PROTECTION_MODERATE, stun_pwr = 0, damage_pwr = 0, deafen_pwr = 0)
	return FALSE

/mob/living/proc/get_attack_victim(obj/item/I, mob/living/user, var/target_zone)
	return src

/mob/living/proc/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)
	return target_zone

//Called when the mob is hit with an item in combat. Returns the blocked result
/mob/living/proc/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone, var/ground_zero)
	visible_message(SPAN_DANGER("[src] has been [LAZYPICK(I.attack_verb,"attacked")] with [I] by [user]!"))

	. = standard_weapon_hit_effects(I, user, effective_force, hit_zone)

	if(I.damtype == DAMAGE_BRUTE && prob(33) && I.force) // Added blood for whacking non-humans too
		var/turf/simulated/location = get_turf(src)
		if(istype(location)) location.add_blood_floor(src)

//returns 0 if the effects failed to apply for some reason, 1 otherwise.
/mob/living/proc/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	if(!effective_force)
		return FALSE

	//Hulk modifier
	if((user.mutations & HULK))
		effective_force *= 2

	//Apply weapon damage
	var/damage_flags = I.damage_flags()

	return apply_damage(effective_force, I.damtype, hit_zone, I, damage_flags, I.armor_penetration)

//this proc handles being hit by a thrown atom
/mob/living/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(!aura_check(AURA_TYPE_THROWN, hitting_atom, throwingdatum.speed))
		return
	if(isobj(hitting_atom))
		var/obj/O = hitting_atom
		var/dtype = O.damtype
		var/throw_damage = O.throwforce*(throwingdatum.speed/THROWFORCE_SPEED_DIVISOR)

		var/miss_chance = 15
		if (O.throwing?.thrower?.resolve())
			var/distance = get_dist(O.throwing?.thrower?.resolve(), loc)
			miss_chance = max(15*(distance-2), 0)

		if (prob(miss_chance))
			visible_message(SPAN_NOTICE("\The [O] misses [src] narrowly!"))
			playsound(src, 'sound/effects/throw_miss.ogg', 50, 1)
			return

		src.visible_message(SPAN_WARNING("[src] has been hit by [O]."))
		apply_damage(throw_damage, dtype, null, damage_flags = O.damage_flags(), used_weapon = O)

		O.throwing?.finalize(hit = TRUE, target = src)		//it hit, so stop moving

		if(ismob(O.throwing?.thrower?.resolve()))
			var/mob/M = O.throwing?.thrower?.resolve()
			var/client/assailant = M.client
			if(assailant)
				src.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been hit with a [O], thrown by [M.name] ([assailant.ckey])</font>"
				M.attack_log += "\[[time_stamp()]\] <span class='warning'>Hit [src.name] ([src.ckey]) with a thrown [O]</span>"
				if(!istype(src,/mob/living/simple_animal/rat))
					msg_admin_attack("[src.name] ([src.ckey]) was hit by a [O], thrown by [M.name] ([assailant.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(M),ckey_target=key_name(src))

		// Begin BS12 momentum-transfer code.
		var/mass = 1.5
		if(istype(O, /obj/item))
			var/obj/item/I = O
			mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR
		var/momentum = throwingdatum.speed*mass

		if(O.throwing?.thrower?.resolve() && momentum >= THROWNOBJ_KNOCKBACK_SPEED)
			var/dir = get_dir(O.throwing?.thrower?.resolve(), src)

			visible_message(SPAN_WARNING("[src] staggers under the impact!"),
							SPAN_WARNING("You stagger under the impact!"))

			src.throw_at(get_edge_target_turf(src,dir),1,momentum)

			if(!O || !src)
				return

			if(O.sharp) //Projectile is suitable for pinning.
				//Handles embedding for non-humans and simple_animals.
				embed(O)

				var/turf/T = near_wall(dir,2)

				if(T)
					src.forceMove(T)
					visible_message(SPAN_WARNING("[src] is pinned to the wall by [O]!"),
									SPAN_WARNING("You are pinned to the wall by [O]!"))

					src.anchored = 1
					src.pinned += O

/mob/living/proc/embed(var/obj/O, var/def_zone=null)
	O.forceMove(src)
	src.embedded += O
	add_verb(src, /mob/proc/yank_out_object)

///This is called when the mob is thrown into a dense turf
/mob/living/proc/turf_collision(var/atom/T, var/speed = THROWFORCE_SPEED_DIVISOR, var/sound_to_play = 'sound/effects/bangtaper.ogg')
	visible_message(SPAN_DANGER("[src] slams into \the [T]!"))
	playsound(T, sound_to_play, 50, 1, 1)//so it plays sounds on the turf instead, makes for awesome carps to hull collision and such
	apply_damage(speed*5, DAMAGE_BRUTE)

/mob/living/proc/near_wall(var/direction,var/distance=1)
	var/turf/T = get_step(get_turf(src),direction)
	var/turf/last_turf = src.loc
	var/i = 1

	while(i>0 && i<=distance)
		if(T.density) //Turf is a wall!
			return last_turf
		i++
		last_turf = T
		T = get_step(T,direction)

	return 0

// End BS12 momentum-transfer code.

/mob/living/attack_generic(var/mob/user, var/damage, var/attack_message, var/armor_penetration, var/attack_flags, var/damage_type = DAMAGE_BRUTE)
	if(!damage)
		return

	user.attack_log += "\[[time_stamp()]\] <span class='warning'>attacked [src.name] ([src.ckey])</span>"
	src.attack_log += "\[[time_stamp()]\] <font color='orange'>was attacked by [user.name] ([user.ckey])</font>"
	if (attack_message)
		src.visible_message(SPAN_DANGER("[user] has [attack_message] [src]!"))
	user.do_attack_animation(src)

	apply_damage(damage, damage_type, user.zone_sel?.selecting, armor_pen = armor_penetration, damage_flags = attack_flags)
	updatehealth()

	return TRUE

/mob/living/proc/IgniteMob(var/fire_stacks_to_add = 0)

	if(fire_stacks_to_add)
		adjust_fire_stacks(fire_stacks_to_add)

	if(fire_stacks > 0 && !on_fire)
		set_on_fire()
		update_fire()
		return TRUE

	return FALSE

/mob/living/proc/set_on_fire()
	on_fire = TRUE
	to_chat(src, SPAN_DANGER(FONT_LARGE("You are set on fire!")))
	set_light(3, 2, LIGHT_COLOR_FIRE)

/mob/living/proc/extinguish_fire()
	on_fire = FALSE
	to_chat(src, SPAN_GOOD(FONT_LARGE("You are no longer on fire.")))
	set_light(0)

/mob/living/proc/ExtinguishMob(var/fire_stacks_to_remove = 0)
	if(fire_stacks_to_remove)
		adjust_fire_stacks(-fire_stacks_to_remove)

	if(fire_stacks <= 0 && on_fire)
		extinguish_fire()
		update_fire()
		return TRUE

	return FALSE

/mob/living/proc/ExtinguishMobCompletely()
	return ExtinguishMob(fire_stacks)

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(var/add_fire_stacks)
	fire_stacks = clamp(fire_stacks + add_fire_stacks, FIRE_MIN_STACKS, FIRE_MAX_STACKS)

	return fire_stacks

/mob/living/proc/handle_fire()
	if(!loc)
		ExtinguishMobCompletely()
		return TRUE

	if(fire_stacks < 0)
		fire_stacks = min(0, ++fire_stacks) //If we've doused ourselves in water to avoid fire, dry off slowly

	if(!on_fire)
		return 1
	else if(fire_stacks <= 0)
		ExtinguishMobCompletely() //Fire's been put out.
		return 1

	var/datum/gas_mixture/G = loc.return_air() // Check if we're standing in an oxygenless environment
	if(G.gas[GAS_OXYGEN] < 1)
		ExtinguishMobCompletely() //If there's no oxygen in the tile we're on, put out the fire
		return 1

	var/turf/location = get_turf(src)
	location.hotspot_expose(fire_burn_temperature(), 50, 1)

/mob/living/fire_act(exposed_temperature, exposed_volume)
	. = ..()

	IgniteMob(2)

/mob/living/proc/get_cold_protection()
	return 0

/mob/living/proc/get_heat_protection()
	return 0

//Finds the effective temperature that the mob is burning at.
/mob/living/proc/fire_burn_temperature()
	if (fire_stacks <= 0)
		return 0

	//Scale quadratically so that single digit numbers of fire stacks don't burn ridiculously hot.
	//lower limit of 700 K, same as matches and roughly the temperature of a cool flame.
	return max(2.25*round(FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE*(fire_stacks/FIRE_MAX_FIRESUIT_STACKS)**2), 700)

/mob/living/proc/reagent_permeability()
	return 1

/mob/living/proc/handle_actions()
	//Pretty bad, i'd use picked/dropped instead but the parent calls in these are nonexistent
	for(var/datum/action/A in actions)
		if(A.CheckRemoval(src))
			A.Remove(src)

	for(var/obj/item/I in src)
		if(I.action_button_name)

			//If the item_action object does not exist, try to create it
			if(!I.action)
				//Try to use the default action type, if there is none, skip this implant
				if(I.default_action_type)
					I.action = new I.default_action_type
				else
					continue

			I.action.name = I.action_button_name
			I.action.SetTarget(I)
			I.action.Grant(src)
	return

/mob/living/update_action_buttons()
	if(!hud_used) return
	if(!client) return

	if(hud_used.hud_shown != 1)	//Hud toggled to minimal
		return

	client.screen -= hud_used.hide_actions_toggle
	for(var/datum/action/A in actions)
		if(A.button)
			client.screen -= A.button

	if(hud_used.action_buttons_hidden)
		if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used)
			hud_used.hide_actions_toggle.update_icon()

		if(!hud_used.hide_actions_toggle.moved)
			hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(1)
			//hud_used.SetButtonCoords(hud_used.hide_actions_toggle,1)

		client.screen += hud_used.hide_actions_toggle
		return

	var/button_number = 0
	for(var/datum/action/A in actions)
		if(QDELETED(A))
			continue

		button_number++
		if(A.button == null)
			var/atom/movable/screen/movable/action_button/N = new(hud_used)
			N.owner = A
			A.button = N

		var/atom/movable/screen/movable/action_button/B = A.button

		B.update_icon()

		B.name = A.UpdateName()

		client.screen += B

		if(!B.moved)
			B.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number)
			//hud_used.SetButtonCoords(B,button_number)

	if(button_number > 0)
		if(!hud_used.hide_actions_toggle)
			hud_used.hide_actions_toggle = new(hud_used)
			hud_used.hide_actions_toggle.InitialiseIcon(src)
		if(!hud_used.hide_actions_toggle.moved)
			hud_used.hide_actions_toggle.screen_loc = hud_used.ButtonNumberToScreenCoords(button_number+1)
			//hud_used.SetButtonCoords(hud_used.hide_actions_toggle,button_number+1)
		client.screen += hud_used.hide_actions_toggle
