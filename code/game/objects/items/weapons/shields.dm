//** Shield Helpers
//These are shared by various items that have shield-like behaviour

//bad_arc is the ABSOLUTE arc of directions from which we cannot block. If you want to fix it to e.g. the user's facing you will need to rotate the dirs yourself.
/proc/check_shield_arc(mob/user, var/bad_arc, atom/damage_source = null, mob/attacker = null)
	//check attack direction
	var/attack_dir = 0 //direction from the user to the source of the attack
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		attack_dir = get_dir(get_turf(user), P.starting)
	else if(attacker)
		attack_dir = get_dir(get_turf(user), get_turf(attacker))
	else if(damage_source)
		attack_dir = get_dir(get_turf(user), get_turf(damage_source))

	if(!(attack_dir && (attack_dir & bad_arc)))
		return 1
	return 0

/proc/default_parry_check(mob/user, mob/attacker, atom/damage_source)
	//parry only melee attacks
	if(istype(damage_source, /obj/item/projectile) || (attacker && get_dist(user, attacker) > 1) || user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

/obj/item/shield
	name = "shield"
	hitsound = "swing_hit"
	icon = 'icons/obj/weapons.dmi'
	var/base_block_chance = 50

/obj/item/shield/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		if(prob(get_block_chance(user, damage, damage_source, attacker)))
			user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
			return 1
	return 0

/obj/item/shield/proc/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	return base_block_chance

/obj/item/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon_state = "riot"
	flags = CONDUCT
	slot_flags = SLOT_BACK
	force = 5.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 7500)
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

/obj/item/shield/riot/handle_shield(mob/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/riot/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		//plastic shields do not stop bullets or lasers, even in space. Will block beanbags, rubber bullets, and stunshots just fine though.
		if((is_sharp(P) && damage > 10) || istype(P, /obj/item/projectile/beam))
			return 0
	return base_block_chance

/obj/item/shield/riot/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/melee/baton))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/obj/item/shield/buckler
	name = "buckler"
	desc = "A wooden buckler used to block sharp things from entering your body back in the day."
	icon_state = "buckler"
	slot_flags = SLOT_BACK
	force = 8
	throwforce = 8
	base_block_chance = 60
	throw_speed = 10
	throw_range = 20
	w_class = 4.0
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 1000, "Wood" = 1000)
	attack_verb = list("shoved", "bashed")

/obj/item/shield/buckler/handle_shield(mob/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/buckler/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		if((is_sharp(P) && damage > 10) || istype(P, /obj/item/projectile/beam))
			return 0
	return base_block_chance

/*
 * Energy Shield
 */

/obj/item/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon_state = "eshield0" // eshield1 for expanded
	flags = CONDUCT
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = 1
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	attack_verb = list("shoved", "bashed")
	var/shield_power = 150
	var/active = 0

/obj/item/shield/energy/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(!active)
		return 0 //turn it on first!

	if(user.incapacitated())
		return 0

	if(.)
		spark(user.loc, 5)
		playsound(user.loc, 'sound/weapons/blade.ogg', 50, 1)

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))

		if(prob(get_block_chance(user, damage, damage_source, attacker)))
			spark(user.loc, 5)
			playsound(user.loc, 'sound/weapons/blade.ogg', 50, 1)
			shield_power -= round(damage/4)

			if(shield_power <= 0)
				visible_message("<span class='danger'>\The [user]'s [src.name] overloads!</span>")
				active = 0
				force = 3
				update_icon()
				w_class = 1
				playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
				shield_power = initial(shield_power)
				return 0

			if(istype(damage_source, /obj/item/projectile/energy) || istype(damage_source, /obj/item/projectile/beam))
				var/obj/item/projectile/P = damage_source

				var/reflectchance = 80 - round(damage/3)
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
					return 1
			else
				user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
				return 1

/obj/item/shield/energy/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		if((is_sharp(P) && damage > 10) || istype(P, /obj/item/projectile/beam))
			return (base_block_chance - round(damage / 3)) //block bullets and beams using the old block chance
	return base_block_chance

/obj/item/shield/energy/attack_self(mob/living/user as mob)
	if ((user.is_clumsy()) && prob(50))
		to_chat(user, "<span class='warning'>You beat yourself in the head with [src].</span>")
		user.take_organ_damage(5)
	active = !active
	if (active)
		force = 10
		update_icon()
		w_class = 4
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now active.</span>")

	else
		force = 3
		update_icon()
		w_class = 1
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/shield/energy/update_icon()
	icon_state = "eshield[active]"
	if(active)
		set_light(1.5, 1.5, "#006AFF")
	else
		set_light(0)

/obj/item/shield/energy/hegemony
	name = "hegemony barrier"
	desc = "A hardlight kite shield capable of protecting the wielder from both material and energy attack."
	icon_state = "kataphract-eshield0"
 
/obj/item/shield/energy/hegemony/update_icon()
	icon_state = "kataphract-eshield[active]"
	if(active)
		set_light(1.5, 1.5, "#e68917")
	else
		set_light(0)

/obj/item/shield/energy/legion
	name = "energy barrier"
	desc = "A large deployable energy shield meant to provide excellent protection against ranged attacks."
	icon_state = "ebarrier0"

/obj/item/shield/energy/legion/update_icon()
	icon_state = "ebarrier[active]"
	if(active)
		set_light(1.5, 1.5, "#33FFFF")
	else
		set_light(0)

// tact
/obj/item/shield/riot/tact
	name = "tactical shield"
	desc = "A highly advanced ballistic shield crafted from durable materials and plated ablative panels. Can be collapsed for mobility."
	icon = 'icons/obj/tactshield.dmi'
	icon_state = "tactshield"
	item_state = "tactshield"
	contained_sprite = 1
	force = 3.0
	throwforce = 3.0
	throw_speed = 3
	throw_range = 4
	w_class = 3
	attack_verb = list("shoved", "bashed")
	var/active = 0

/obj/item/shield/riot/tact/legion
	name = "legion ballistic shield"
	desc = "A highly advanced ballistic shield crafted from durable materials and plated ablative panels. Can be collapsed for mobility. This one has been painted in the colors of the Tau Ceti Foreign Legion."
	icon_state = "legion_tactshield"
	item_state = "legion_tactshield"

/obj/item/shield/riot/tact/handle_shield(mob/user)
	if(!active)
		return 0 //turn it on first!
	. = ..()

	if(.)
		if(.) playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/riot/tact/attack_self(mob/living/user)
	active = !active
	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)

	if(active)
		icon_state = "[initial(icon_state)]_[active]"
		item_state = "[initial(item_state)]_[active]"
		force = 5
		throwforce = 5
		throw_speed = 2
		w_class = 4
		slot_flags = SLOT_BACK
		to_chat(user, span("notice","You extend \the [src] downward with a sharp snap of your wrist."))
	else
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
		force = 3
		throwforce = 3
		throw_speed = 3
		w_class = 3
		slot_flags = 0
		to_chat(user, span("notice","\The [src] folds inwards neatly as you snap your wrist upwards and push it back into the frame."))

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return
