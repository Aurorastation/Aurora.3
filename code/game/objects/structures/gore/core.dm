/obj/structure/gore
	name = "alien thing"
	desc = "There's something alien about this."
	icon = 'icons/obj/gore_structures.dmi'
	anchored = TRUE
	density = FALSE
	var/destroy_message = "THE STRUCTURE collapses in on itself!"
	var/maxHealth = 50
	var/health = 50

/obj/structure/gore/Initialize(mapload)
	. = ..()
	health = maxHealth

/obj/structure/gore/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/health_div = health / maxHealth
		if(health_div >= 0.9)
			. += SPAN_NOTICE("\The [src] appears completely intact.")
		else if(health_div >= 0.7)
			. += SPAN_NOTICE("\The [src] is starting to tear somewhat.")
		else if(health_div >= 0.4)
			. += SPAN_WARNING("\The [src] is starting to fall apart.")
		else
			. += SPAN_WARNING("\The [src] is barely holding itself together!")

/obj/structure/gore/proc/healthcheck()
	if(health <= 0)
		var/final_message = replacetext(destroy_message, "THE STRUCTURE", "\The [src]")
		visible_message(SPAN_WARNING(final_message))
		qdel(src)

/obj/structure/gore/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	healthcheck()
	return ..()

/obj/structure/gore/ex_act(severity)
	switch(severity)
		if(1.0)
			health -= 50
		if(2.0)
			health -= 50
		if(3.0)
			if(prob(50))
				health -= 50
			else
				health -= 25
	healthcheck()

/obj/structure/gore/hitby(atom/movable/AM, var/speed = THROWFORCE_SPEED_DIVISOR)
	. = ..()
	visible_message(SPAN_WARNING("\The [src] was hit by \the [AM]."))
	playsound(loc, 'sound/effects/attackblob.ogg', 100, TRUE)
	var/throw_force = 0
	if(isobj(AM))
		var/obj/O = AM
		throw_force = O.throwforce
	else if(ismob(AM))
		throw_force = 10
	health -= throw_force
	healthcheck()

/obj/structure/gore/attack_generic()
	attack_hand(usr)

/obj/structure/gore/attackby(obj/item/attacking_item, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src, attacking_item)
	var/force_damage = attacking_item.force
	if(attacking_item.damtype == DAMAGE_BURN)
		force_damage *= 1.25
	health -= force_damage
	playsound(loc, 'sound/effects/attackblob.ogg', 80, TRUE)
	healthcheck()

/obj/structure/gore/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return FALSE
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density
