//** Shield Helpers
//These are shared by various items that have shield-like behaviour

//bad_arc is the ABSOLUTE arc of directions from which we cannot block. If you want to fix it to e.g. the user's facing you will need to rotate the dirs yourself.
/proc/check_shield_arc(mob/user, bad_arc, atom/damage_source = null, mob/attacker = null)
	//check attack direction
	var/attack_dir = 0 //direction from the user to the source of the attack
	if(istype(damage_source, /obj/projectile))
		var/obj/projectile/P = damage_source
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
	if(istype(damage_source, /obj/projectile) || (attacker && get_dist(user, attacker) > 1) || user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = REVERSE_DIR(user.dir) //arc of directions from which we cannot block
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

/obj/item/shield
	name = "shield"
	icon = 'icons/obj/weapons.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/weapons/lefthand_shield.dmi',
		slot_r_hand_str = 'icons/mob/items/weapons/righthand_shield.dmi'
		)
	var/base_block_chance = 50
	recyclable = TRUE

/obj/item/shield/handle_shield(mob/user, var/on_back, var/damage, atom/damage_source = null, mob/attacker = null, def_zone = null, attack_text = "the attack")
	var/shield_dir = on_back ? user.dir : REVERSE_DIR(user.dir)

	if(user.incapacitated() || !(check_shield_arc(user, shield_dir, damage_source, attacker)))
		return BULLET_ACT_HIT

	if(prob(get_block_chance(user, damage, damage_source, attacker)))
		user.visible_message(SPAN_DANGER("\The [user] blocks [attack_text] with \the [src]!"))
		return BULLET_ACT_BLOCK
	return BULLET_ACT_HIT

/obj/item/shield/can_shield_back()
	return TRUE

/obj/item/shield/proc/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	return base_block_chance

/obj/item/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon_state = "riot"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	slot_flags = SLOT_BACK
	force = 11
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 7500)
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

/obj/item/shield/riot/handle_shield(mob/user)
	. = ..()
	if(. != BULLET_ACT_HIT)
		playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/riot/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/projectile))
		var/obj/projectile/P = damage_source
		//plastic shields do not stop bullets or lasers, even in space. Will block beanbags, rubber bullets, and stunshots just fine though.
		if((is_sharp(P) && damage > 10) || istype(P, /obj/projectile/beam))
			return 0
	return base_block_chance

/obj/item/shield/riot/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/melee/baton))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_WARNING("[user] bashes [src] with [attacking_item]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/obj/item/shield/buckler
	name = "selfmade shield"
	desc = "A sturdy buckler used to block sharp things from entering your body back in the day."
	icon = 'icons/obj/square_shield.dmi'
	icon_state = "square_buckler"
	item_state = "square_buckler"
	contained_sprite = TRUE
	slot_flags = SLOT_BACK
	force = 18
	throwforce = 8
	base_block_chance = 60
	throw_speed = 10
	throw_range = 20
	w_class = WEIGHT_CLASS_BULKY
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_WOOD = 1000)
	attack_verb = list("shoved", "bashed")

/obj/item/shield/buckler/handle_shield(mob/user)
	. = ..()
	if(. != BULLET_ACT_HIT)
		playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/buckler/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/projectile))
		var/obj/projectile/P = damage_source
		if((is_sharp(P) && damage > 10) || istype(P, /obj/projectile/beam))
			return 0
	return base_block_chance

/*
 * Energy Shield
 */

/obj/item/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon_state = "eshield0"
	obj_flags = OBJ_FLAG_CONDUCTABLE
	force = 3
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_TINY
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	attack_verb = list("shoved", "bashed")
	var/shield_power = 150
	var/active = FALSE
	var/next_action
	var/sound_token
	var/sound_id

/obj/item/shield/energy/Destroy()
	QDEL_NULL(sound_token)
	return ..()

/obj/item/shield/energy/Initialize()
	. = ..()
	sound_id = "[sequential_id(/obj/item/shield/energy)]"

/obj/item/shield/energy/update_icon()
	icon_state = "eshield[active]"
	if(active)
		set_light(1.5, 1.5, "#006AFF")
	else
		set_light(0)

/obj/item/shield/energy/attack_self(mob/living/user)
	var/time = world.time
	if(time < next_action)
		return
	next_action = time + 3 SECONDS
	active = !active
	if(active)
		HandleTurnOn()
	else
		HandleShutOff()
	add_fingerprint(user)
	update_icon()
	user.update_inv_l_hand()
	user.update_inv_r_hand()

/obj/item/shield/energy/handle_shield(mob/user, on_back, damage, atom/damage_source = null, mob/attacker = null, def_zone = null, attack_text = "the attack")
	var/shield_dir = on_back ? user.dir : REVERSE_DIR(user.dir)

	if(!active || user.incapacitated() || !(check_shield_arc(user, shield_dir, damage_source, attacker)))
		return BULLET_ACT_HIT

	if(prob(get_block_chance(user, damage, damage_source, attacker)))
		spark(user.loc, 5)
		shield_power -= round(damage/4)

		if(shield_power <= 0)
			visible_message(SPAN_DANGER("\The [user]'s [src.name] overloads!"))
			active = FALSE
			HandleShutOff()

		if(isenergy(damage_source) || isbeam(damage_source))
			var/obj/projectile/P = damage_source

			var/reflectchance = 80 - (damage/3)
			if(P.starting && prob(reflectchance))
				visible_message(SPAN_DANGER("\The [user]'s [src.name] reflects [attack_text]!"))

				// Find a turf near or on the original location to bounce to
				var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
				var/turf/curloc = get_turf(src)

				// redirect the projectile
				P.original = locate(new_x, new_y, P.z)
				P.starting = curloc
				P.firer = user
				P.yo = new_y - curloc.y
				P.xo = new_x - curloc.x
				var/new_angle_s = P.Angle + rand(120,240)
				while(new_angle_s > 180) // Translate to regular projectile degrees
					new_angle_s -= 360
				P.set_angle(new_angle_s)

				return BULLET_ACT_FORCE_PIERCE // complete projectile permutation
			else
				user.visible_message(SPAN_DANGER("\The [user] blocks [attack_text] with \the [src]!"))
				return BULLET_ACT_BLOCK
		else
			user.visible_message(SPAN_DANGER("\The [user] blocks [attack_text] with \the [src]!"))
			return BULLET_ACT_BLOCK
	else
		return BULLET_ACT_HIT

/obj/item/shield/energy/get_block_chance(mob/user, damage, atom/damage_source = null, mob/attacker = null)
	if(isprojectile(damage_source))
		if((is_sharp(damage_source) && damage > 10) || isbeam(damage_source))
			return (base_block_chance - round(damage / 3))
	return base_block_chance

/obj/item/shield/energy/proc/HandleTurnOn()
	addtimer(CALLBACK(src, /obj/item/shield/energy/proc/UpdateSoundLoop), 0.25 SECONDS)
	playsound(src, 'sound/items/shield/energy/shield-start.ogg', 40)
	force = 15
	w_class = WEIGHT_CLASS_BULKY

/obj/item/shield/energy/proc/HandleShutOff()
	addtimer(CALLBACK(src, /obj/item/shield/energy/proc/UpdateSoundLoop), 0.1 SECONDS)
	playsound(src, 'sound/items/shield/energy/shield-stop.ogg', 40)
	force = initial(force)
	w_class = initial(w_class)

/obj/item/shield/energy/proc/UpdateSoundLoop()
	if (!active)
		QDEL_NULL(sound_token)
		return
	sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id,'sound/items/shield/energy/shield-loop.ogg', 10, 4)

/obj/item/shield/energy/hegemony
	name = "hegemony barrier"
	desc = "A Zkrehk-Guild manufactured energy shield capable of protecting the wielder from both material and energy attack."
	icon_state = "hegemony-eshield0"
	base_block_chance = 60

/obj/item/shield/energy/hegemony/update_icon()
	icon_state = "hegemony-eshield[active]"
	if(active)
		set_light(1.5, 1.5, "#e68917")
	else
		set_light(0)

/obj/item/shield/energy/hegemony/kataphract
	name = "kataphract barrier"
	desc = "A hardlight kite shield capable of protecting the wielder from both material and energy attack."
	icon_state = "kataphract-eshield0"
	base_block_chance = 65

/obj/item/shield/energy/hegemony/kataphract/update_icon()
	icon_state = "kataphract-eshield[active]"
	if(active)
		set_light(1.5, 1.5, "#e68917")
	else
		set_light(0)

/obj/item/shield/energy/legion
	name = "energy barrier"
	desc = "A large deployable energy shield meant to provide excellent protection against ranged attacks."
	icon_state = "ebarrier0"
	base_block_chance = 55

/obj/item/shield/energy/legion/update_icon()
	icon_state = "ebarrier[active]"
	if(active)
		set_light(1.5, 1.5, "#33FFFF")
	else
		set_light(0)

/obj/item/shield/energy/dominia
	name = "dominian energy barrier"
	desc = "A hardlight energy shield meant to provide excellent protection in melee engagements."
	icon_state = "dominian-eshield0"
	base_block_chance = 60

/obj/item/shield/energy/dominia/update_icon()
	icon_state = "dominian-eshield[active]"
	if(active)
		set_light(1.5, 1.5, "#ff5132")
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
	force = 3
	throwforce = 3.0
	throw_speed = 3
	throw_range = 4
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("shoved", "bashed")
	var/active = 0

/obj/item/shield/riot/tact/legion
	name = "\improper TCAF ballistic shield"
	desc = "A highly advanced ballistic shield crafted from durable materials and plated ablative panels. Can be collapsed for mobility. This one has been painted in the colors of the Tau Ceti Armed Forces."
	icon_state = "legion_tactshield"
	item_state = "legion_tactshield"

/obj/item/shield/riot/tact/handle_shield(mob/user)
	if(!active)
		return BULLET_ACT_HIT //turn it on first!

	. = ..()
	if(. != BULLET_ACT_HIT)
		playsound(user.loc, 'sound/weapons/Genhit.ogg', 50, 1)

/obj/item/shield/riot/tact/attack_self(mob/living/user)
	active = !active
	playsound(src.loc, 'sound/weapons/click.ogg', 50, 1)

	if(active)
		icon_state = "[initial(icon_state)]_[active]"
		item_state = "[initial(item_state)]_[active]"
		force = 11
		throwforce = 5
		throw_speed = 2
		w_class = WEIGHT_CLASS_BULKY
		slot_flags = SLOT_BACK
		to_chat(user, SPAN_NOTICE("You extend \the [src] downward with a sharp snap of your wrist."))
	else
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
		force = 3
		throwforce = 3
		throw_speed = 3
		w_class = WEIGHT_CLASS_NORMAL
		slot_flags = 0
		to_chat(user, SPAN_NOTICE("\The [src] folds inwards neatly as you snap your wrist upwards and push it back into the frame."))

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return
