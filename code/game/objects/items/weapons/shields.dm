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
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
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

	armor = list(
		melee = ARMOR_MELEE_KEVLAR,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_KEVLAR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)

	/// The max amount of health the shield has
	var/max_shield_health = 150

	/// The current amount of health the shield has
	var/shield_health

	/// The material type that the shield can be repaired with
	var/material_repair_type

	recyclable = TRUE

	trait_slots = list(
		slot_l_hand,
		slot_r_hand
	)

	equipped_traits = list(TRAIT_UNPUSHABLE)

/obj/item/shield/Initialize(mapload, ...)
	. = ..()
	shield_health = max_shield_health

/obj/item/shield/get_examine_text(mob/user, distance, is_adjacent, infix, suffix, get_extended)
	. = ..()
	. += get_durability_examine_text(user, distance, is_adjacent, infix, suffix, get_extended)

/obj/item/shield/proc/get_durability_examine_text(mob/user, distance, is_adjacent, infix, suffix, get_extended)
	. = list()
	if(is_adjacent)
		. += SPAN_NOTICE("\The [src] has [SPAN_BOLD("[shield_health]")]/[SPAN_BOLD("[max_shield_health]")] durability remaining.")
		. += SPAN_NOTICE("\The [src] can be repaired with [SPAN_BOLD("[material_repair_type]")].") // TO-DO

/obj/item/shield/attackby(obj/item/attacking_item, mob/user)
	if(material_repair_type && istype(attacking_item, /obj/item/stack/material))
		var/obj/item/stack/material/material_stack = attacking_item
		if(material_stack.material.name != material_repair_type)
			return
		if(shield_health == max_shield_health)
			to_chat(user, SPAN_WARNING("\The [src] is already fully repaired!"))
			return
		var/amount_to_use = 3
		if(!material_stack.can_use(amount_to_use))
			to_chat(user, SPAN_WARNING("You don't have enough material to repair \the [src]!"))
			return
		user.visible_message("[SPAN_BOLD("[user]")] starts repairing \the [src] with \the [material_stack]...", SPAN_NOTICE("You start repairing \the [src] with \the [material_stack]."))
		if(do_after(user, 20 SECONDS, src, do_flags = DO_UNIQUE))
			if(!material_stack.can_use(amount_to_use))
				to_chat(user, SPAN_WARNING("You don't have enough material to repair \the [src]!"))
				return
			material_stack.use(amount_to_use)
			shield_health = clamp(shield_health + (max_shield_health / 3), 0, max_shield_health)
			user.visible_message("[SPAN_BOLD("[user]")] [shield_health != max_shield_health ? "partially repairs" : "repairs"] \the [src] with \the [material_stack]...", SPAN_NOTICE("You [shield_health != max_shield_health ? "partially repair" : "repair"] \the [src] with \the [material_stack]."))
			update_icon()
		return
	return ..()

/obj/item/shield/handle_shield(mob/user, var/on_back, var/damage, obj/damage_source = null, mob/attacker = null, def_zone = null, attack_text = "the attack")
	var/shield_dir = on_back ? user.dir : GLOB.reverse_dir[user.dir]

	if(user.incapacitated() || !(check_shield_arc(user, shield_dir, damage_source, attacker)))
		return FALSE

	var/datum/component/armor/armor_datum = GetComponent(/datum/component/armor)
	var/list/damage_args = armor_datum.apply_damage_modifications(damage, damage_source?.damage_type() || DAMAGE_BRUTE, damage_source?.damage_flags() || 0, user, damage_source?.armor_penetration || 0, TRUE)
	handle_damage(user, damage_args[1])

	if(shield_health > 0)
		user.visible_message(SPAN_DANGER("\The [user] blocks [attack_text] with \the [src]!"))
		return PROJECTILE_STOPPED

	return FALSE

/obj/item/shield/proc/handle_damage(var/mob/user, var/damage)
	if(shield_health <= 0)
		return

	shield_health = clamp(shield_health - damage, 0, max_shield_health)

	if(shield_health <= 0)
		playsound(get_turf(user), /singleton/sound_category/wood_break_sound, 50, TRUE)
		to_chat(user, SPAN_DANGER("\The [src] breaks!"))
		user.balloon_alert_to_viewers("Shield Broken", "Shield Broken")

/obj/item/shield/can_shield_back()
	return TRUE

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
	matter = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_PLASTIC = 7500)
	material_repair_type = MATERIAL_PLASTIC
	attack_verb = list("shoved", "bashed")

	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)

	/// shield bash cooldown. based on world.time
	var/cooldown = 0

/obj/item/shield/riot/update_icon()
	if(shield_health <= 0)
		icon_state = "[initial(icon_state)]_broken"
		item_state = "[initial(icon_state)]_broken"
	else
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(icon_state)]"

	if(ismob(loc))
		var/mob/user = loc
		user.update_inv_l_hand()
		user.update_inv_r_hand()
		user.update_inv_back()

/obj/item/shield/riot/handle_damage(mob/user, damage)
	. = ..()
	if(shield_health <= 0)
		update_icon()

/obj/item/shield/riot/handle_shield(mob/user)
	. = ..()
	if(.)
		playsound(get_turf(user), 'sound/weapons/Genhit.ogg', 50, TRUE)

/obj/item/shield/riot/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/melee/baton))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_WARNING("[user] bashes [src] with [attacking_item]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, TRUE)
			cooldown = world.time
		return
	return ..()

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
	throw_speed = 10
	throw_range = 20
	w_class = WEIGHT_CLASS_BULKY
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_WOOD = 1000)
	material_repair_type = MATERIAL_WOOD
	attack_verb = list("shoved", "bashed")

	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_MINOR
	)

/obj/item/shield/buckler/handle_shield(mob/user)
	. = ..()
	if(.)
		playsound(get_turf(user), 'sound/weapons/Genhit.ogg', 50, TRUE)

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

	equipped_traits = null

	armor = list(
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_CARBINE,
		laser = ARMOR_LASER_RIFLE,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)

	var/active = FALSE
	var/next_action
	var/sound_token
	var/sound_id

/obj/item/shield/energy/Initialize()
	. = ..()
	sound_id = "[sequential_id(/obj/item/shield/energy)]"

/obj/item/shield/energy/Destroy()
	QDEL_NULL(sound_token)
	return ..()

/obj/item/shield/energy/get_durability_examine_text(mob/user, distance, is_adjacent, infix, suffix, get_extended)
	. = list()
	if(is_adjacent)
		. += SPAN_NOTICE("\The [src] has [SPAN_BOLD("[shield_health]")]/[SPAN_BOLD("[max_shield_health]")] power remaining.")
		. += SPAN_NOTICE("\The [src] will automatically recharge its power over the course of a minute.")

/obj/item/shield/energy/process(seconds_per_tick)
	var/power_to_charge = (max_shield_health / 60) * seconds_per_tick
	shield_health = clamp(shield_health + power_to_charge, 0, max_shield_health)
	if(shield_health == max_shield_health)
		return PROCESS_KILL

/obj/item/shield/energy/update_icon()
	icon_state = "eshield[active]"
	if(active)
		set_light(1.5, 1.5, "#006AFF")
	else
		set_light(0)

	if(ismob(loc))
		var/mob/user = loc
		user.update_inv_l_hand()
		user.update_inv_r_hand()
		user.update_inv_back()

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

/obj/item/shield/energy/handle_shield(mob/user, on_back, damage, obj/damage_source = null, mob/attacker = null, def_zone = null, attack_text = "the attack")
	var/shield_dir = on_back ? user.dir : GLOB.reverse_dir[user.dir]

	if(!active || user.incapacitated() || !(check_shield_arc(user, shield_dir, damage_source, attacker)))
		return FALSE

	var/datum/component/armor/armor_datum = GetComponent(/datum/component/armor)
	var/list/damage_args = armor_datum.apply_damage_modifications(damage, damage_source?.damage_type() || DAMAGE_BRUTE, damage_source?.damage_flags() || 0, user, damage_source?.armor_penetration || 0, TRUE)
	handle_damage(user, damage_args[1])

	if(shield_health > 0)
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

				return PROJECTILE_CONTINUE // complete projectile permutation
			else
				user.visible_message(SPAN_DANGER("\The [user] blocks [attack_text] with \the [src]!"))
				return PROJECTILE_STOPPED
		else
			user.visible_message(SPAN_DANGER("\The [user] blocks [attack_text] with \the [src]!"))
			return PROJECTILE_STOPPED

	return FALSE

/obj/item/shield/energy/handle_damage(var/mob/user, var/damage)
	if(shield_health <= 0)
		return

	spark(user.loc, 5)
	shield_health = clamp(shield_health - damage, 0, max_shield_health)

	if(!(datum_flags & DF_ISPROCESSING))
		START_PROCESSING(SSprocessing, src)

	if(shield_health == 0)
		playsound(user.loc, /singleton/sound_category/wood_break_sound, 50, TRUE)
		to_chat(user, SPAN_DANGER("\The [src] overloads!"))
		user.balloon_alert_to_viewers("Shield Overloaded", "Shield Overloaded")
		HandleShutOff()

/obj/item/shield/energy/proc/HandleTurnOn()
	active = TRUE
	addtimer(CALLBACK(src, /obj/item/shield/energy/proc/UpdateSoundLoop), 0.25 SECONDS)
	playsound(src, 'sound/items/shield/energy/shield-start.ogg', 40)
	force = 15
	w_class = WEIGHT_CLASS_BULKY
	update_icon()

	LAZYDISTINCTADD(equipped_traits, TRAIT_UNPUSHABLE)

	if(ismob(loc))
		var/mob/wielder = loc
		if(get_equip_slot() in trait_slots)
			add_equipped_traits_to_mob(wielder)

/obj/item/shield/energy/proc/HandleShutOff()
	active = FALSE
	addtimer(CALLBACK(src, /obj/item/shield/energy/proc/UpdateSoundLoop), 0.1 SECONDS)
	playsound(src, 'sound/items/shield/energy/shield-stop.ogg', 40)
	force = initial(force)
	w_class = initial(w_class)
	update_icon()

	if(ismob(loc))
		var/mob/wielder = loc
		if(get_equip_slot() in trait_slots)
			remove_equipped_traits_from_mob(wielder)

	LAZYREMOVE(equipped_traits, TRAIT_UNPUSHABLE)

/obj/item/shield/energy/proc/UpdateSoundLoop()
	if (!active)
		QDEL_NULL(sound_token)
		return
	sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id,'sound/items/shield/energy/shield-loop.ogg', 10, 4)

/obj/item/shield/energy/hegemony
	name = "hegemony barrier"
	desc = "A Zkrehk-Guild manufactured energy shield capable of protecting the wielder from both material and energy attack."
	icon_state = "hegemony-eshield0"

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

	equipped_traits = null

	var/active = FALSE

/obj/item/shield/riot/tact/update_icon()
	if(active)
		icon_state = "[initial(icon_state)]_[active]"
		item_state = "[initial(item_state)]_[active]"
	else
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"

	if(ismob(loc))
		var/mob/user = loc
		user.update_inv_l_hand()
		user.update_inv_r_hand()
		user.update_inv_back()

/obj/item/shield/riot/tact/handle_shield(mob/user)
	if(!active)
		return FALSE //turn it on first!

	. = ..()
	if(.)
		playsound(get_turf(user), 'sound/weapons/Genhit.ogg', 50, TRUE)

/obj/item/shield/riot/tact/handle_damage(var/mob/user, var/damage)
	. = ..()
	if(shield_health <= 0)
		HandleClose()

/obj/item/shield/riot/tact/attack_self(mob/living/user)
	if(!active && shield_health <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is too damaged to open!"))
		return

	active = !active
	playsound(src.loc, 'sound/weapons/click.ogg', 50, TRUE)

	if(active)
		HandleOpen()
		to_chat(user, SPAN_NOTICE("You extend \the [src] downward with a sharp snap of your wrist."))
	else
		HandleClose()
		to_chat(user, SPAN_NOTICE("\The [src] folds inwards neatly as you snap your wrist upwards and push it back into the frame."))

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)

/obj/item/shield/riot/tact/proc/HandleOpen()
	active = TRUE
	force = 11
	throwforce = 5
	throw_speed = 2
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK

	LAZYDISTINCTADD(equipped_traits, TRAIT_UNPUSHABLE)

	if(ismob(loc))
		var/mob/wielder = loc
		if(get_equip_slot() in trait_slots)
			add_equipped_traits_to_mob(wielder)

	update_icon()

/obj/item/shield/riot/tact/proc/HandleClose()
	active = FALSE
	force = 3
	throwforce = 3
	throw_speed = 3
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = 0

	if(ismob(loc))
		var/mob/wielder = loc
		if(get_equip_slot() in trait_slots)
			remove_equipped_traits_from_mob(wielder)

	LAZYREMOVE(equipped_traits, TRAIT_UNPUSHABLE)

	update_icon()

/obj/item/shield/riot/tact/legion
	name = "\improper TCAF ballistic shield"
	desc = "A highly advanced ballistic shield crafted from durable materials and plated ablative panels. Can be collapsed for mobility. This one has been painted in the colors of the Tau Ceti Armed Forces."
	icon_state = "legion_tactshield"
	item_state = "legion_tactshield"

	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_MEDIUM,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
