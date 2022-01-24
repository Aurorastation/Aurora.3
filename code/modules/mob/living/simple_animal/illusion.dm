// Illusion type mobs pretend to be other things visually, and generally cannot be harmed as they're not 'real'.

/mob/living/simple_animal/illusion
	name = "illusion"
	desc = "If you can read me, the game broke. Please report this to a coder."

	resistance = 1000 // Holograms are tough.
	mob_bump_flag = 0 // If the illusion can't be swapped it will be obvious.

	var/atom/movable/copying = null // The thing we're trying to look like.
	var/realistic = FALSE // If true, things like bullets and weapons will hit it, to be a bit more convincing from a distance.

	psi_pingable = FALSE

/mob/living/simple_animal/illusion/update_icon() // We don't want the appearance changing AT ALL unless by copy_appearance().
	return

/mob/living/simple_animal/illusion/proc/copy_appearance(atom/movable/thing_to_copy)
	if(!thing_to_copy)
		return FALSE
	appearance = thing_to_copy.appearance
	copying = thing_to_copy
	density = thing_to_copy.density // So you can't bump into objects that aren't supposed to be dense.
	return TRUE

/mob/living/simple_animal/illusion/Destroy()
	copying = null
	return ..()	

// Because we can't perfectly duplicate some examine() output, we directly examine the AM it is copying.  It's messy but
// this is to prevent easy checks from the opposing force.
/mob/living/simple_animal/illusion/examine(mob/user)
	if(copying)
		return copying.examine(user)
	else
		return list("???")

/mob/living/simple_animal/illusion/bullet_act(obj/item/projectile/P)
	if(!P)
		return

	if(realistic)
		return ..()

	return PROJECTILE_FORCE_MISS

/mob/living/simple_animal/illusion/attack_hand(mob/living/carbon/human/M)
	if(!realistic)
		playsound(src, 'sound/weapons/punchmiss1.ogg', 25, 1, -1)
		visible_message(SPAN_NOTICE("\The [M]'s hand goes through \the [src]!"))
		return
	else
		switch(M.a_intent)
			if(I_HELP)
				M.visible_message(
					SPAN_NOTICE("\The [M] tap [src] to get their attention!"), \
					SPAN_NOTICE("You tap [src] to get their attention!")
					) // slightly redundant as at the moment most mobs still use the normal gender var, but it works and future-proofs it
				playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

			if(I_DISARM)
				playsound(src, 'sound/weapons/punchmiss1.ogg', 25, 1, -1)
				visible_message(SPAN_DANGER("\The [M] attempted to disarm [src]!"))
				M.do_attack_animation(src)

			if(I_GRAB)
				..()

			if(I_HURT)
				adjustBruteLoss(harm_intent_damage)
				M.visible_message(SPAN_DANGER("\The [M] [response_harm] \the [src]!"))
				M.do_attack_animation(src)

/mob/living/simple_animal/illusion/hit_with_weapon(obj/item/I, mob/living/user, effective_force, hit_zone)
	if(realistic)
		return ..()

	playsound(src, 'sound/weapons/punchmiss1.ogg', 25, 1, -1)
	visible_message(span("warning", "\The [user]'s [I] goes through \the [src]!"))
	return FALSE

/mob/living/simple_animal/illusion/ex_act()
	return
