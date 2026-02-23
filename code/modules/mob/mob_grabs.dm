// Casting stubs for grabs, check /mob/living for full definition.
/mob/proc/apply_damage(damage = 0, damagetype = DAMAGE_BRUTE, def_zone, used_weapon, damage_flags = 0, armor_pen, silent = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	return
/mob/proc/get_blocked_ratio(def_zone, damage_type, damage_flags, armor_pen, damage)
	return
/mob/proc/standard_weapon_hit_effects(obj/item/I, mob/living/user, effective_force, hit_zone)
	return
/mob/proc/apply_effect(effect = 0, effect_type = STUN, blocked = 0)
	SHOULD_NOT_SLEEP(TRUE)
	return
// End grab casting stubs.

/mob/can_be_grabbed(mob/grabber, target_zone)
	if(!grabber.can_pull_mobs)
		to_chat(grabber, SPAN_WARNING("\The [src] won't budge!"))
		return FALSE
	. = ..() && !buckled
	if(.)
		if((grabber.mob_size < mob_size) && grabber.can_pull_mobs != MOB_PULL_LARGER)
			to_chat(grabber, SPAN_WARNING("You are too small to move \the [src]!"))
			return FALSE
		if((grabber.mob_size == mob_size) && grabber.can_pull_mobs == MOB_PULL_SMALLER)
			to_chat(grabber, SPAN_WARNING("\The [src] is too large for you to move!"))
			return FALSE

/mob/proc/get_grab_targets(list/L = list(), list/grabs = null)
	if(!LAZYLEN(grabs))
		grabs = get_active_grabs()
		if(!length(grabs))
			return L
	for(var/obj/item/grab/grab as anything in grabs)
		if(grab.grabbed)
			L |= grab.grabbed
			var/mob/living/grabbed_mob = astype(grab.get_grabbed_mob())
			grabbed_mob?.get_grab_targets(L)
	return L

/mob/proc/handle_grab_damage()
	set waitfor = FALSE

/mob/proc/handle_grabs_after_move(turf/old_loc, direction, new_glide_size)
	set waitfor = FALSE

/mob/proc/add_grab(obj/item/grab/G, defer_hand = FALSE)
	return FALSE

/mob/proc/ProcessGrabs()
	return

/mob/proc/get_active_grabs()
	. = list()
	for(var/obj/item/grab/G in contents)
		. += G

/mob/get_object_size()
	return mob_size
