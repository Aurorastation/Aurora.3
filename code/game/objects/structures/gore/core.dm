/obj/structure/gore
	name = "alien thing"
	desc = "There's something alien about this."
	icon = 'icons/obj/gore_structures.dmi'
	anchored = TRUE
	density = FALSE
	maxhealth = OBJECT_HEALTH_VERY_LOW
	var/destroy_message = "THE STRUCTURE collapses in on itself!"

/obj/structure/gore/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/health_div = health / maxhealth
		if(health_div >= 0.9)
			. += SPAN_NOTICE("\The [src] appears completely intact.")
		else if(health_div >= 0.7)
			. += SPAN_NOTICE("\The [src] is starting to tear somewhat.")
		else if(health_div >= 0.4)
			. += SPAN_WARNING("\The [src] is starting to fall apart.")
		else
			. += SPAN_WARNING("\The [src] is barely holding itself together!")

/obj/structure/gore/on_death(damage, damage_flags, damage_type, armor_penetration, obj/weapon)
	var/final_message = replacetext(destroy_message, "THE STRUCTURE", "\The [src]")
	visible_message(SPAN_WARNING(final_message))
	qdel(src)

/obj/structure/gore/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	add_damage(hitting_projectile.damage)

/obj/structure/gore/ex_act(severity)
	switch(severity)
		if(1.0)
			add_damage(50)
		if(2.0)
			add_damage(50)
		if(3.0)
			if(prob(50))
				add_damage(50)
			else
				add_damage(25)

/obj/structure/gore/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	. = ..()
	visible_message(SPAN_WARNING("\The [src] was hit by \the [hitting_atom]."))
	playsound(loc, 'sound/effects/attackblob.ogg', 100, TRUE)
	var/throw_force = 0
	if(isobj(hitting_atom))
		var/obj/O = hitting_atom
		throw_force = O.throwforce
	else if(ismob(hitting_atom))
		throw_force = 10
	add_damage(throw_force)

/obj/structure/gore/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	attack_hand(usr)

/obj/structure/gore/attackby(obj/item/attacking_item, mob/user)
	var/damage = attacking_item.force
	if(attacking_item.damtype == DAMAGE_BURN)
		damage *= 1.25
	. = ..()
	add_damage(damage)
	playsound(loc, 'sound/effects/attackblob.ogg', 80, TRUE)

/obj/structure/gore/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return FALSE
	if(mover?.movement_type & PHASING)
		return TRUE
	if(istype(mover) && mover.pass_flags & PASSGLASS)
		return !opacity
	return !density
