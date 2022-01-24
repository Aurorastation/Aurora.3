/obj/item/melee/energy
	var/active = 0
	var/active_force
	var/active_throwforce
	var/active_w_class
	sharp = 0
	edge = FALSE
	armor_penetration = 10
	flags = NOBLOODY
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

/obj/item/melee/energy/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

/obj/item/melee/energy/attack_self(mob/living/user as mob)
	if(active)
		if ((user.is_clumsy()) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts [user.get_pronoun("himself")] with \the [src].</span>",\
			"<span class='danger'>You accidentally cut yourself with \the [src].</span>")
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
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		spark(src, 5)
		playsound(user.loc, 'sound/weapons/blade.ogg', 50, 1)
		return PROJECTILE_STOPPED
	else
		if(!active)
			return FALSE //turn it on first!

		if(user.incapacitated())
			return FALSE

		//block as long as they are not directly behind us
		var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
		if(check_shield_arc(user, bad_arc, damage_source, attacker))

			if(prob(base_block_chance))
				spark(src, 5)
				playsound(user.loc, 'sound/weapons/blade.ogg', 50, 1)
				shield_power -= round(damage/4)

				if(shield_power <= 0)
					visible_message("<span class='danger'>\The [user]'s [src.name] overloads!</span>")
					deactivate()
					shield_power = initial(shield_power)
					return FALSE

				if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
					var/obj/item/projectile/P = damage_source

					var/reflectchance = base_reflectchance - round(damage/3)
					if(!(def_zone in list(BP_CHEST, BP_GROIN,BP_HEAD)))
						reflectchance /= 2
					if(P.starting && prob(reflectchance))
						visible_message("<span class='danger'>\The [user]'s [src.name] reflects [attack_text]!</span>")

						// Find a turf near or on the original location to bounce to
						var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
						var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)

						// redirect the projectile
						P.firer = user
						P.old_style_target(locate(new_x, new_y, P.z))

						return PROJECTILE_CONTINUE // complete projectile permutation
					else
						user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
						return PROJECTILE_STOPPED

				else if(istype(damage_source, /obj/item/projectile/bullet) && can_block_bullets)
					var/reflectchance = (base_reflectchance) - round(damage/3)
					if(!(def_zone in list(BP_CHEST, BP_GROIN,BP_HEAD)))
						reflectchance /= 2
					if(prob(reflectchance))
						user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
						return PROJECTILE_STOPPED

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
	active_force = 40
	active_throwforce = 60
	active_w_class = ITEMSIZE_HUGE
	force = 20
	throwforce = 30
	throw_speed = 5
	throw_range = 10
	w_class = ITEMSIZE_HUGE
	flags = CONDUCT | NOBLOODY
	origin_tech = list(TECH_COMBAT = 6, TECH_PHORON = 4, TECH_MATERIAL = 7, TECH_ILLEGAL = 4)
	attack_verb = list("stabbed", "chopped", "sliced", "cleaved", "slashed", "cut")
	sharp = 1
	edge = TRUE
	slot_flags = SLOT_BACK
	base_reflectchance = 0
	base_block_chance = 0 //cannot be used to block guns
	shield_power = 0
	can_block_bullets = 0
	armor_penetration = 20

/obj/item/melee/energy/glaive/activate(mob/living/user)
	..()
	icon_state = "eglaive1"
	to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")

/obj/item/melee/energy/glaive/deactivate(mob/living/user)
	..()
	icon_state = initial(icon_state)
	to_chat(user, "<span class='notice'>\The [src] is de-energised.</span>")

/obj/item/melee/energy/glaive/attack(mob/living/carbon/human/M as mob, mob/living/carbon/user as mob)
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
	//active_force = 150 //holy...
	active_force = 60
	active_throwforce = 35
	active_w_class = ITEMSIZE_HUGE
	//force = 40
	//throwforce = 25
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	flags = CONDUCT | NOBLOODY
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
	to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")

/obj/item/melee/energy/axe/deactivate(mob/living/user)
	..()
	icon_state = initial(icon_state)
	to_chat(user, "<span class='notice'>\The [src] is de-energised. It's just a regular axe now.</span>")

/*
 * Energy Sword
 */
/obj/item/melee/energy/sword
	color
	name = "energy sword"
	desc = "May the force be within you."
	desc_antag = "The energy sword is a very strong melee weapon, capable of severing limbs easily, if they are targeted.  It can also has a chance \
	to block projectiles and melee attacks while it is on and being held.  The sword can be toggled on or off by using it in your hand.  While it is off, \
	it can be concealed in your pocket or bag."
	icon_state = "sword0"
	active_force = 30
	active_throwforce = 20
	active_w_class = ITEMSIZE_LARGE
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	flags = NOBLOODY
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	sharp = 1
	edge = TRUE
	var/blade_color
	shield_power = 75

/obj/item/melee/energy/sword/New()
	blade_color = pick("red","blue","green","purple")

/obj/item/melee/energy/sword/green/New()
	blade_color = "green"

/obj/item/melee/energy/sword/red/New()
	blade_color = "red"

/obj/item/melee/energy/sword/blue/New()
	blade_color = "blue"

/obj/item/melee/energy/sword/purple/New()
	blade_color = "purple"

/obj/item/melee/energy/sword/activate(mob/living/user)
	if(!active)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
	..()
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	icon_state = "sword[blade_color]"

/obj/item/melee/energy/sword/deactivate(mob/living/user)
	if(active)
		to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")
	..()
	attack_verb = list()
	icon_state = initial(icon_state)

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
	active_force = 20 // 20 damage per hit, seems more balanced for what it can do

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
	desc = "Some cheap energy blade, branded at the hilt with the logo of the Tau Ceti Foreign Legion."
	icon_state = "edagger0"
	base_reflectchance = 10
	base_block_chance = 10
	active_force = 20
	force = 10
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
	active_force = 20
	force = 10
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
	active_force = 40
	base_block_chance = 65
	active_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_NORMAL
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = /decl/sound_category/sword_pickup_sound
	equip_sound = /decl/sound_category/sword_equip_sound

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
		user.visible_message("<span class='danger'>\The [user] accidentally cuts [user.get_pronoun("himself")] with \the [src].</span>",\
		"<span class='danger'>You accidentally cut yourself with \the [src].</span>")
		user.take_organ_damage(5,5)
/*
 *Energy Blade
 */
/obj/item/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	force = 40
	active_force = 40 //Normal attacks deal very high damage - about the same as wielded fire axe
	armor_penetration = 100
	sharp = 1
	edge = TRUE
	anchored = 1    // Never spawned outside of inventory, should be fine.
	throwforce = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = ITEMSIZE_LARGE//So you can't hide it in your pocket or some such.
	flags = NOBLOODY
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/mob/living/creator
	base_reflectchance = 140
	base_block_chance = 75
	shield_power = 150
	can_block_bullets = 1
	active = 1
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
