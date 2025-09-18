/obj/item/melee/energy
	var/active = 0
	var/active_force
	var/active_throwforce
	var/active_w_class
	sharp = 0
	edge = FALSE
	armor_penetration = 20
	atom_flags = ATOM_FLAG_NO_BLOOD
	can_embed = 0//No embedding pls
	var/base_reflectchance = 40
	var/base_block_chance = 25
	var/shield_power = 100
	var/can_block_bullets = 0
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/weapons/lefthand_energy.dmi',
		slot_r_hand_str = 'icons/mob/items/weapons/righthand_energy.dmi'
		)

/obj/item/melee/energy/proc/activate(mob/living/user)
	if(active)
		return
	active = 1
	force = active_force
	throwforce = active_throwforce
	sharp = 1
	edge = TRUE
	w_class = active_w_class
	playsound(user, 'sound/weapons/saberon.ogg', 50, 1)

/obj/item/melee/energy/proc/deactivate(mob/living/user)
	if(!active)
		return
	playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
	active = 0
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	w_class = initial(w_class)

/obj/item/melee/energy/dropped(mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

/obj/item/melee/energy/attack_self(mob/living/user as mob)
	if(active)
		if ((user.is_clumsy()) && prob(50))
			user.visible_message(SPAN_DANGER("\The [user] accidentally cuts [user.get_pronoun("himself")] with \the [src]."),\
			SPAN_DANGER("You accidentally cut yourself with \the [src]."))
			user.take_organ_damage(5,5)
		deactivate(user)
	else
		activate(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/melee/energy/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(active && default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message(SPAN_DANGER("\The [user] parries [attack_text] with \the [src]!"))
		spark(src, 5)
		playsound(user.loc, 'sound/weapons/blade.ogg', 50, 1)
		return BULLET_ACT_BLOCK
	else
		if(!active)
			return BULLET_ACT_HIT //turn it on first!

		if(user.incapacitated())
			return BULLET_ACT_HIT

		//block as long as they are not directly behind us
		var/bad_arc = REVERSE_DIR(user.dir) //arc of directions from which we cannot block
		if(check_shield_arc(user, bad_arc, damage_source, attacker))

			if(prob(base_block_chance) && shield_power)
				spark(src, 5)
				playsound(user.loc, 'sound/weapons/blade.ogg', 50, 1)
				shield_power -= round(damage * 0.75)

				if(shield_power <= 0)
					to_chat(user, SPAN_DANGER("\The [src]'s integrated shield goes out! It will no longer assist in parrying."))
					shield_power = 0
					return BULLET_ACT_HIT

				if(istype(damage_source, /obj/projectile/energy) || istype(damage_source, /obj/projectile/beam))
					var/obj/projectile/P = damage_source

					var/reflectchance = base_reflectchance - round(damage/3)
					if(!(def_zone in list(BP_CHEST, BP_GROIN,BP_HEAD)))
						reflectchance /= 2
					if(P.starting && prob(reflectchance))
						visible_message(SPAN_DANGER("\The [user]'s [src.name] reflects [attack_text]!"))

						// Find a turf near or on the original location to bounce to
						var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
						var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)

						// redirect the projectile
						P.firer = user
						P.old_style_target(locate(new_x, new_y, P.z))

						return BULLET_ACT_FORCE_PIERCE // complete projectile permutation
					else
						user.visible_message(SPAN_DANGER("\The [user] blocks [attack_text] with \the [src]!"))
						return BULLET_ACT_BLOCK

				else if(istype(damage_source, /obj/projectile/bullet) && can_block_bullets)
					var/reflectchance = (base_reflectchance) - round(damage/3)
					if(!(def_zone in list(BP_CHEST, BP_GROIN,BP_HEAD)))
						reflectchance /= 2
					if(prob(reflectchance))
						user.visible_message(SPAN_DANGER("\The [user] blocks [attack_text] with \the [src]!"))
						return BULLET_ACT_BLOCK
			else
				return BULLET_ACT_HIT

/obj/item/melee/energy/get_print_info()
	. = ..()
	. += "Active Damage: [active_force]<br>"
	. += "Active Throw Force: [active_throwforce]<br>"
	. += "Blocks Bullets: [can_block_bullets ? "true" : "false"]<br>"
	. += "Block Chance: [base_block_chance]<br>"
	. += "Projectile Reflection Chance: [base_reflectchance]<br>"
	. += "Shield Rating: [shield_power]<br>"

/obj/item/melee/energy/glaive
	name = "energy glaive"
	desc = "An energized glaive."
	icon_state = "eglaive0"
	force = 25
	throwforce = 30
	active_force = 44
	active_throwforce = 60
	active_w_class = WEIGHT_CLASS_HUGE
	armor_penetration = 20
	throw_speed = 5
	throw_range = 10
	w_class = WEIGHT_CLASS_HUGE
	atom_flags = ATOM_FLAG_NO_BLOOD
	obj_flags = OBJ_FLAG_CONDUCTABLE
	origin_tech = list(TECH_COMBAT = 6, TECH_PHORON = 4, TECH_MATERIAL = 7, TECH_ILLEGAL = 4)
	attack_verb = list("stabbed", "chopped", "sliced", "cleaved", "slashed", "cut")
	sharp = 1
	edge = TRUE
	slot_flags = SLOT_BACK
	base_reflectchance = 0
	base_block_chance = 0 //cannot be used to block guns
	shield_power = 0
	can_block_bullets = 0

/obj/item/melee/energy/glaive/activate(mob/living/user)
	..()
	icon_state = "eglaive1"
	to_chat(user, SPAN_NOTICE("\The [src] is now energised."))

/obj/item/melee/energy/glaive/deactivate(mob/living/user)
	..()
	icon_state = initial(icon_state)
	to_chat(user, SPAN_NOTICE("\The [src] is de-energised."))

/obj/item/melee/energy/glaive/attack(mob/living/target_mob, mob/living/user, target_zone)
	user.setClickCooldown(16)
	..()

/obj/item/melee/energy/glaive/pre_attack(var/mob/living/target, var/mob/living/user)
	if(istype(target))
		cleave(user, target)
	..()

/*
 * Energy Axe
 */
/obj/item/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
	active_force = 60
	active_throwforce = 35
	active_w_class = WEIGHT_CLASS_HUGE
	force = 25
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL
	atom_flags = ATOM_FLAG_NO_BLOOD
	obj_flags = OBJ_FLAG_CONDUCTABLE
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4)
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = TRUE
	base_reflectchance = 0
	base_block_chance = 0 //cannot be used to block guns
	shield_power = 0
	can_block_bullets = 0
	armor_penetration = 35

/obj/item/melee/energy/axe/activate(mob/living/user)
	..()
	icon_state = "axe1"
	to_chat(user, SPAN_NOTICE("\The [src] is now energised."))

/obj/item/melee/energy/axe/deactivate(mob/living/user)
	..()
	icon_state = initial(icon_state)
	to_chat(user, SPAN_NOTICE("\The [src] is de-energised. It's just a regular axe now."))

/obj/item/melee/energy/axe/can_woodcut()
	if(active)
		return TRUE
	else
		return FALSE

/*
 * Energy Sword
 */
/obj/item/melee/energy/sword
	name = "energy sword"
	desc = "An energy sword. Quite rare, very dangerous."
	icon_state = "sword0"
	active_force = 33
	armor_penetration = 25
	active_throwforce = 20
	active_w_class = WEIGHT_CLASS_BULKY
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	atom_flags = ATOM_FLAG_NO_BLOOD
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	sharp = 1
	edge = TRUE
	shield_power = 75
	can_block_bullets = TRUE
	base_reflectchance = 30
	base_block_chance = 30
	var/blade_color

/obj/item/melee/energy/sword/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "The energy sword is a very strong melee weapon, capable of severing limbs easily, if they are targeted."
	. += "It also has a chance to block projectiles and melee attacks while it is on and being held."
	. += "The sword can be toggled on or off by using it in your hand."
	. += "While it is off, it can be concealed in your pocket or bag."

/obj/item/melee/energy/sword/Initialize(mapload, ...)
	. = ..()
	blade_color = pick("red","blue","green","purple")

/obj/item/melee/energy/sword/green/Initialize(mapload, ...)
	. = ..()
	blade_color = "green"

/obj/item/melee/energy/sword/red/Initialize(mapload, ...)
	. = ..()
	blade_color = "red"

/obj/item/melee/energy/sword/blue/Initialize(mapload, ...)
	. = ..()
	blade_color = "blue"

/obj/item/melee/energy/sword/purple/Initialize(mapload, ...)
	. = ..()
	blade_color = "purple"

/obj/item/melee/energy/sword/activate(mob/living/user)
	if(!active)
		to_chat(user, SPAN_NOTICE("\The [src] is now energised."))
	..()
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	icon_state = "sword[blade_color]"

/obj/item/melee/energy/sword/deactivate(mob/living/user)
	if(active)
		to_chat(user, SPAN_NOTICE("\The [src] deactivates!"))
	..()
	attack_verb = list()
	icon_state = initial(icon_state)

/obj/item/melee/energy/sword/perform_technique(mob/living/carbon/human/target, mob/living/carbon/human/user, target_zone)
	. = ..()
	var/armor_reduction = target.get_blocked_ratio(target_zone, DAMAGE_BRUTE, DAMAGE_FLAG_EDGE|DAMAGE_FLAG_SHARP, damage = force)*100
	var/obj/item/organ/external/affecting = target.get_organ(target_zone)
	if(!affecting)
		return
	user.do_attack_animation(target)

	if(target_zone == BP_HEAD || target_zone == BP_EYES || target_zone == BP_MOUTH)
		if(prob(70 - armor_reduction))
			target.eye_blurry += 5
			target.confused += 10
			return TRUE

	if(target_zone == BP_R_ARM || target_zone == BP_L_ARM || target_zone == BP_R_HAND || target_zone == BP_L_HAND)
		if(prob(80 - armor_reduction))
			if(target_zone == BP_R_ARM || target_zone == BP_R_HAND)
				target.drop_r_hand()
			else
				target.drop_l_hand()
			return TRUE

	if(target_zone == BP_R_FOOT || target_zone == BP_R_FOOT || target_zone == BP_R_LEG || target_zone == BP_L_LEG)
		if(prob(60 - armor_reduction))
			target.Weaken(5)
			return TRUE

	return FALSE

/obj/item/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"

	slot_flags = SLOT_BELT
	base_reflectchance = 60
	base_block_chance = 60

/obj/item/melee/energy/sword/pirate/activate(mob/living/user)
	..()
	icon_state = "cutlass1"

/obj/item/melee/energy/sword/pirate/generic
	desc = "An energy with a curved output, useful for defense and intimidation."
	active_force = 25

/obj/item/melee/energy/glaive/hegemony
	name = "hegemony energy glaive"
	desc = "A standard melee weapon for Unathi infantry, known across Hegemony space as a symbol of Izweski might."
	icon_state = "hegemony-eglaive0"

/obj/item/melee/energy/glaive/hegemony/activate(mob/living/user)
	..()
	icon_state = "hegemony-eglaive1"
	to_chat(user, SPAN_NOTICE("\The [src] is now energised."))

/obj/item/melee/energy/glaive/hegemony/deactivate(mob/living/user)
	..()
	icon_state = initial(icon_state)
	to_chat(user, SPAN_NOTICE("\The [src] is de-energised."))


/obj/item/melee/energy/sword/hegemony
	name = "hegemony energy blade"
	desc = "A righteous hardlight blade to strike down the dishonourable."
	slot_flags = SLOT_BELT
	icon_state = "kataphract-esword0"

/obj/item/melee/energy/sword/hegemony/activate(mob/living/user)
	..()
	icon_state = "kataphract-esword1"
	to_chat(user, SPAN_NOTICE("\The [src] is now energised."))

/obj/item/melee/energy/sword/hegemony/deactivate(mob/living/user)
	..()
	icon_state = initial(icon_state)
	to_chat(user, SPAN_NOTICE("\The [src] is de-energised."))

/obj/item/melee/energy/sword/knife
	name = "energy utility knife"
	desc = "Some cheap energy blade. Easier to conceal and carry than the larger energy swords, it is a mainstay in militaries across the spur for its utility as a tool and a backup weapon."
	icon_state = "edagger0"
	base_reflectchance = 10
	base_block_chance = 10
	active_force = 25
	force = 15
	origin_tech = list(TECH_MAGNET = 3)

/obj/item/melee/energy/sword/knife/activate(mob/living/user)
	..()
	icon_state = "edagger1"

/obj/item/melee/energy/sword/knife/sol
	name = "solarian energy dagger"
	desc = "A relatively inexpensive energy blade, this is the standard-issue combat knife given to the Solarian military."
	icon_state = "sol_edagger0"
	base_reflectchance = 10
	base_block_chance = 10
	active_force = 25
	force = 15
	origin_tech = list(TECH_MAGNET = 3)

/obj/item/melee/energy/sword/knife/sol/activate(mob/living/user)
	..()
	icon_state = "sol_edagger1"

/*
*Power Sword
*/

/obj/item/melee/energy/sword/powersword
	name = "power sword"
	desc = "For when you really want to ruin someone's day. It is extremely heavy."
	icon = 'icons/obj/sword.dmi'
	icon_state = "runesword0"
	item_state = "runesword0" //same icon, lol
	contained_sprite = TRUE
	base_reflectchance = 65
	active_force = 44
	base_block_chance = 65
	active_w_class = WEIGHT_CLASS_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /singleton/sound_category/sword_pickup_sound
	equip_sound = /singleton/sound_category/sword_equip_sound

/obj/item/melee/energy/sword/powersword/activate(mob/living/user)
	..()
	icon_state = "runesword1"
	item_state = "runesword1"

/obj/item/melee/energy/sword/powersword/deactivate(mob/living/user)
	..()
	icon_state = "runesword0"
	item_state = "runesword0"

/obj/item/melee/energy/sword/powersword/attack_self(mob/living/user as mob)
	..()
	if(prob(30))
		user.visible_message(SPAN_DANGER("\The [user] accidentally cuts [user.get_pronoun("himself")] with \the [src]."),\
		SPAN_DANGER("You accidentally cut yourself with \the [src]."))
		user.take_organ_damage(5,5)
/*
 *Energy Blade
 */
/obj/item/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	force = 30
	active_force = 44 //Normal attacks deal very high damage - about the same as wielded fire axe
	sharp = TRUE
	edge = TRUE
	anchored = 1    // Never spawned outside of inventory, should be fine.
	throwforce = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = WEIGHT_CLASS_BULKY//So you can't hide it in your pocket or some such.
	atom_flags = ATOM_FLAG_NO_BLOOD
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/mob/living/creator
	base_reflectchance = 140
	base_block_chance = 75
	can_block_bullets = TRUE
	active = TRUE
	var/datum/effect_system/sparks/spark_system

/obj/item/melee/energy/blade/Initialize()
	. = ..()
	spark_system = bind_spark(src, 3)
	START_PROCESSING(SSprocessing, src)

/obj/item/melee/energy/blade/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	QDEL_NULL(spark_system)
	return ..()

/obj/item/melee/energy/blade/deactivate(mob/living/user)
	if(!active)
		return
	playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
	user.drop_from_inventory(src)
	QDEL_IN(src, 1)


/obj/item/melee/energy/blade/dropped()
	. = ..()
	QDEL_IN(src, 1)

/obj/item/melee/energy/blade/process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 1)
