/mob/living/proc/modify_damage_by_armor(def_zone, damage, damage_type, damage_flags, mob/living/victim, armor_pen, silent = FALSE)
	var/list/armors = get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = args.Copy(2)
	for(var/armor in armors)
		var/datum/component/armor/armor_datum = armor
		. = armor_datum.apply_damage_modifications(arglist(.))

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

/mob/living/bullet_act(var/obj/item/projectile/P, var/def_zone, var/used_weapon = null)

	//Being hit while using a cloaking device
	var/obj/item/cloaking_device/C = locate(/obj/item/cloaking_device) in src
	if(C && C.active)
		C.attack_self(src)//Should shut it off
		update_icon()
		to_chat(src, "<span class='notice'>Your [C.name] was disrupted!</span>")
		Stun(2)

	//Being hit while using a deadman switch
	if(istype(get_active_hand(),/obj/item/device/assembly/signaler))
		var/obj/item/device/assembly/signaler/signaler = get_active_hand()
		if(signaler.deadman && prob(80))
			log_and_message_admins("has triggered a signaler deadman's switch")
			src.visible_message("<span class='warning'>[src] triggers their deadman's switch!</span>")
			signaler.signal()

	//Armor
	var/damage = P.damage
	var/flags = P.damage_flags()
	if(is_anti_materiel_vulnerable())
		damage = P.damage * P.anti_materiel_potential
	var/damaged
	if(!P.nodamage)
		damaged = apply_damage(damage, P.damage_type, def_zone, damage_flags = P.damage_flags(), used_weapon = P, armor_pen = P.armor_penetration)
	if(damaged || P.nodamage) // Run the block computation if we did damage or if we only use armor for effects (nodamage)
		. = get_blocked_ratio(def_zone, P.damage_type, flags, P.armor_penetration, P.damage)
	bullet_impact_visuals(P, def_zone, damage, .)
	P.on_hit(src, ., def_zone)

/mob/living/proc/aura_check(var/type)
	if(!auras)
		return TRUE
	. = TRUE
	var/list/newargs = args - args[1]
	for(var/a in auras)
		var/obj/aura/aura = a
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

//For visuals, blood splatters and so on.
/mob/living/proc/bullet_impact_visuals(var/obj/item/projectile/P, var/def_zone, var/damage, var/blocked_ratio)
	var/list/impact_sounds = LAZYACCESS(P.impact_sounds, get_bullet_impact_effect_type(def_zone))
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
		apply_damage(agony_amount, PAIN, def_zone, used_weapon)
		apply_effect(agony_amount / 10, STUTTER)
		apply_effect(agony_amount / 10, EYE_BLUR)

/mob/living/proc/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/tesla_shock = 0, var/ground_zero)
	return 0 //only carbon liveforms have this proc

/mob/living/emp_act(severity)
	var/list/L = src.get_contents()
	for(var/obj/O in L)
		O.emp_act(severity)
	..()

/mob/living/proc/get_attack_victim(obj/item/I, mob/living/user, var/target_zone)
	return src

/mob/living/proc/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)
	return target_zone

//Called when the mob is hit with an item in combat. Returns the blocked result
/mob/living/proc/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone, var/ground_zero)
	visible_message("<span class='danger'>[src] has been [LAZYPICK(I.attack_verb,"attacked")] with [I] by [user]!</span>")

	. = standard_weapon_hit_effects(I, user, effective_force, hit_zone)

	if(I.damtype == BRUTE && prob(33) && I.force) // Added blood for whacking non-humans too
		var/turf/simulated/location = get_turf(src)
		if(istype(location)) location.add_blood_floor(src)

//returns 0 if the effects failed to apply for some reason, 1 otherwise.
/mob/living/proc/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	if(!effective_force)
		return FALSE

	//Hulk modifier
	if(HULK in user.mutations)
		effective_force *= 2

	//Apply weapon damage
	var/damage_flags = I.damage_flags()

	return apply_damage(effective_force, I.damtype, hit_zone, I, damage_flags, I.armor_penetration)

//this proc handles being hit by a thrown atom
/mob/living/hitby(atom/movable/AM, var/speed = THROWFORCE_SPEED_DIVISOR)//Standardization and logging -Sieve
	if(!aura_check(AURA_TYPE_THROWN, AM, speed))
		return
	if(isobj(AM))
		var/obj/O = AM
		var/dtype = O.damtype
		var/throw_damage = O.throwforce*(speed/THROWFORCE_SPEED_DIVISOR)

		var/miss_chance = 15
		if (O.throw_source)
			var/distance = get_dist(O.throw_source, loc)
			miss_chance = max(15*(distance-2), 0)

		if (prob(miss_chance))
			visible_message("<span class='notice'>\The [O] misses [src] narrowly!</span>")
			playsound(src, 'sound/effects/throw_miss.ogg', 50, 1)
			return

		src.visible_message("<span class='warning'>[src] has been hit by [O].</span>")
		apply_damage(throw_damage, dtype, null, damage_flags = O.damage_flags(), used_weapon = O)

		O.throwing = 0		//it hit, so stop moving

		if(ismob(O.thrower))
			var/mob/M = O.thrower
			var/client/assailant = M.client
			if(assailant)
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with a [O], thrown by [M.name] ([assailant.ckey])</font>")
				M.attack_log += text("\[[time_stamp()]\] <span class='warning'>Hit [src.name] ([src.ckey]) with a thrown [O]</span>")
				if(!istype(src,/mob/living/simple_animal/rat))
					msg_admin_attack("[src.name] ([src.ckey]) was hit by a [O], thrown by [M.name] ([assailant.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(M),ckey_target=key_name(src))

		// Begin BS12 momentum-transfer code.
		var/mass = 1.5
		if(istype(O, /obj/item))
			var/obj/item/I = O
			mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR
		var/momentum = speed*mass

		if(O.throw_source && momentum >= THROWNOBJ_KNOCKBACK_SPEED)
			var/dir = get_dir(O.throw_source, src)

			visible_message("<span class='warning'>[src] staggers under the impact!</span>","<span class='warning'>You stagger under the impact!</span>")
			src.throw_at(get_edge_target_turf(src,dir),1,momentum)

			if(!O || !src)
				return

			if(O.sharp) //Projectile is suitable for pinning.
				//Handles embedding for non-humans and simple_animals.
				embed(O)

				var/turf/T = near_wall(dir,2)

				if(T)
					src.forceMove(T)
					visible_message("<span class='warning'>[src] is pinned to the wall by [O]!</span>","<span class='warning'>You are pinned to the wall by [O]!</span>")
					src.anchored = 1
					src.pinned += O

/mob/living/proc/embed(var/obj/O, var/def_zone=null)
	O.forceMove(src)
	src.embedded += O
	src.verbs += /mob/proc/yank_out_object

/mob/living/proc/turf_collision(var/atom/T, var/speed = THROWFORCE_SPEED_DIVISOR, var/sound_to_play = 'sound/effects/bangtaper.ogg')
	visible_message("<span class='danger'>[src] slams into \the [T]!</span>")
	playsound(T, sound_to_play, 50, 1, 1)//so it plays sounds on the turf instead, makes for awesome carps to hull collision and such
	apply_damage(speed*5, BRUTE)

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

/mob/living/attack_generic(var/mob/user, var/damage, var/attack_message, var/armor_penetration, var/attack_flags)
	if(!damage)
		return

	adjustBruteLoss(damage)
	user.attack_log += text("\[[time_stamp()]\] <span class='warning'>attacked [src.name] ([src.ckey])</span>")
	src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [user.name] ([user.ckey])</font>")
	if (attack_message)
		src.visible_message("<span class='danger'>[user] has [attack_message] [src]!</span>")
	user.do_attack_animation(src)
	spawn(1) updatehealth()
	return 1

/mob/living/proc/IgniteMob(var/fire_stacks_to_add = 0)

	if(fire_stacks_to_add)
		adjust_fire_stacks(fire_stacks_to_add)

	if(fire_stacks > 0 && !on_fire)
		set_on_fire()
		update_fire()
		return TRUE

	return FALSE

#define MOB_FIRE_LIGHT_RANGE  3  //These control the intensity and range of light given off by a mob which is on fire
#define MOB_FIRE_LIGHT_POWER  2

/mob/living/proc/set_on_fire()
	to_chat(src, SPAN_DANGER(FONT_LARGE("You're set on fire!")))
	on_fire = TRUE
	set_light(light_range + MOB_FIRE_LIGHT_RANGE, light_power + MOB_FIRE_LIGHT_POWER)

/mob/living/proc/ExtinguishMob(var/fire_stacks_to_remove = 0)

	if (fire_stacks_to_remove)
		adjust_fire_stacks(-fire_stacks_to_remove)

	if(fire_stacks <= 0 && on_fire)
		extinguish_fire()
		update_fire()
		return TRUE

	return FALSE

/mob/living/proc/extinguish_fire()
	to_chat(src, SPAN_GOOD(FONT_LARGE("You are no longer on fire.")))
	on_fire = FALSE
	set_light(max(0, light_range - MOB_FIRE_LIGHT_RANGE), max(0, light_power - MOB_FIRE_LIGHT_POWER))

/mob/living/proc/ExtinguishMobCompletely()
	return ExtinguishMob(fire_stacks)

/mob/living/proc/update_fire()
	return

/mob/living/proc/adjust_fire_stacks(var/add_fire_stacks)
	fire_stacks = Clamp(fire_stacks + add_fire_stacks, FIRE_MIN_STACKS, FIRE_MAX_STACKS)

	return fire_stacks

/mob/living/proc/handle_fire()
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

/mob/living/fire_act()
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
			if(!I.action)
				I.action = new I.default_action_type
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
		button_number++
		if(A.button == null)
			var/obj/screen/movable/action_button/N = new(hud_used)
			N.owner = A
			A.button = N

		var/obj/screen/movable/action_button/B = A.button

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

#undef	MOB_FIRE_LIGHT_RANGE  //These control the intensity and range of light given off by a mob which is on fire
#undef	MOB_FIRE_LIGHT_POWER
