/mob/living/simple_animal/hostile/cavern_geist
	name = "cavern geist"
	desc = "A near-mythical adhomian predator, known to haunt the caverns. Its eyes sparkle with a mixture of intelligence and malice."
	speak_emote = list("gibbers")
	icon = 'icons/mob/npc/cavern_geist.dmi'
	icon_state = "geist"
	icon_living = "geist"
	icon_dead = "geist_dead"

	universal_understand = TRUE

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	tameable = FALSE

	organ_names = list("chest", "lower body", "left arm", "right arm", "left leg", "right leg", "head")
	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	blood_amount = 600
	maxHealth = 500
	health = 500
	harm_intent_damage = 0
	melee_damage_lower = 35
	melee_damage_upper = 35
	resist_mod = 3
	mob_size = 25
	environment_smash = 2
	attacktext = "mangled"
	attack_sound = 'sound/weapons/bloodyslice.ogg'

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	pixel_x = -16
	speed = -1


	var/is_devouring = FALSE

/mob/living/simple_animal/hostile/cavern_geist/death(gibbed)
	..()
	anchored = TRUE

/mob/living/simple_animal/hostile/cavern_geist/verb/devour(mob/living/target as mob in oview())
	set category = "Cavern Geist"
	set name = "Devour"
	set desc = "Devours a creature, destroying its body and regenerating health."

	if(!Adjacent(target))
		return

	if(target.isSynthetic())
		return

	if(is_devouring)
		to_chat(src, SPAN_WARNING("You are already feasting on something!"))
		return

	if(!health)
		to_chat(src, SPAN_NOTICE("You are dead, you cannot use any abilities!"))
		return

	if(last_special > world.time)
		to_chat(src, SPAN_WARNING("You must wait a little while before we can use this ability again!"))
		return

	visible_message(SPAN_WARNING("\The [src] begins ripping apart and feasting on [target]!"))
	is_devouring = TRUE

	target.adjustBruteLoss(35)

	if(!do_after(src,150))
		to_chat(src, SPAN_WARNING("You need to wait longer to devour \the [target]!"))
		src.is_devouring = FALSE
		return FALSE

	visible_message(SPAN_WARNING("[src] tears a chunk from \the [target]'s flesh!"))

	target.adjustBruteLoss(35)

	if(!do_after(src,150))
		to_chat(src, SPAN_WARNING("You need to wait longer to devour \the [target]!"))
		is_devouring = FALSE
		return FALSE

	visible_message(SPAN_WARNING("[target] is completely devoured by [src]!"), \
						SPAN_WARNING("You completely devour \the [target]!"))
	target.gib()
	rejuvenate()
	updatehealth()
	last_special = world.time + 100
	is_devouring = FALSE
	return