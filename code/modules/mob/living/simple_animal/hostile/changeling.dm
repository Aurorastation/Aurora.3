/mob/living/simple_animal/hostile/true_changeling
	name = "shambling horror"
	desc = "A monstrous creature, made of twisted flesh and bone."
	speak_emote = list("gibbers")
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "abomination"
	icon_living = "abomination"
	icon_dead = "abomination_dead"
	stop_automated_movement = TRUE
	universal_speak = TRUE
	universal_understand = TRUE

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	tameable = FALSE

	organ_names = list("head", "chest", "tail", "leg")
	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	maxHealth = 750
	health = 750
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	resist_mod = 3
	mob_size = 25
	environment_smash = 2
	attacktext = "mangled"
	attack_sound = 'sound/weapons/bloodyslice.ogg'

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	var/is_devouring = FALSE
	var/mob/living/carbon/human/occupant = null

/mob/living/simple_animal/hostile/true_changeling/Initialize()
	. = ..()
	if(prob(25))
		icon_state = "horror"
		icon_living = "horror"
		icon_dead = "horror_dead"
	else if(prob(25))
		icon_state = "horror_alt"
		icon_living = "horror_alt"
		icon_dead = "horror_alt_dead"

/mob/living/simple_animal/hostile/true_changeling/do_animate_chat(var/message, var/datum/language/language, var/small, var/list/show_to, var/duration, var/list/message_override)
	INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, message, language, small, show_to, duration)

/mob/living/simple_animal/hostile/true_changeling/Life()
	..()
	adjustBruteLoss(-10) //it will slowly heal brute damage, making fire/laser a stronger option

/mob/living/simple_animal/hostile/true_changeling/mind_initialize()
	..()
	mind.assigned_role = "Changeling"

/mob/living/simple_animal/hostile/true_changeling/death(gibbed)
	..()
	if(!gibbed)
		visible_message("<b>[src]</b> lets out a waning scream as it falls, twitching, to the floor!")
		playsound(loc, 'sound/effects/creepyshriek.ogg', 30, 1)
		if(occupant)
			qdel(occupant)
		gibs(src.loc)
		qdel(src)
		return

/mob/living/simple_animal/hostile/true_changeling/verb/ling_devour(mob/living/target as mob in oview())
	set category = "Changeling"
	set name = "Devour"
	set desc = "Devours a creature, destroying its body and regenerating health."

	if(!Adjacent(target))
		return

	if(target.isSynthetic())
		return

	if(src.is_devouring)
		to_chat(src, "<span class='warning'>We are already feasting on something!</span>")
		return 0

	if(!health)
		to_chat(src, "<span class='notice'>We are dead, we cannot use any abilities!</span>")
		return

	if(last_special > world.time)
		to_chat(src, "<span class='warning'>We must wait a little while before we can use this ability again!</span>")
		return

	src.visible_message("<span class='warning'>[src] begins ripping apart and feasting on [target]!</span>")
	src.is_devouring = TRUE

	target.adjustBruteLoss(35)

	if(!do_after(src,150))
		to_chat(src, "<span class='warning'>You need to wait longer to devour \the [target]!</span>")
		src.is_devouring = FALSE
		return 0

	src.visible_message("<span class='warning'>[src] tears a chunk from \the [target]'s flesh!</span>")

	target.adjustBruteLoss(35)

	if(!do_after(src,150))
		to_chat(src, "<span class='warning'>You need to wait longer to devour \the [target]!</span>")
		src.is_devouring = FALSE
		return 0

	src.visible_message("<span class='warning'>[target] is completely devoured by [src]!</span>", \
						"<span class='danger'>You completely devour \the [target]!</span>")
	target.gib()
	rejuvenate()
	updatehealth()
	last_special = world.time + 100
	src.is_devouring = FALSE
	return

/mob/living/simple_animal/hostile/true_changeling/verb/dart(mob/living/target as mob in oview())
	set name = "Launch Bone Dart"
	set desc = "Launches a Bone Dart at a target."
	set category = "Changeling"

	if(!health)
		to_chat(usr, "<span class='notice'>We are dead, we cannot use any abilities!</span>")
		return

	if(last_special > world.time)
		return

	last_special = world.time + 30

	visible_message("<span class='warning'>\The [src]'s skin bulges and tears, launching a bone-dart at [target]!</span>")

	playsound(src.loc, 'sound/weapons/bloodyslice.ogg', 50, 1)
	var/obj/item/bone_dart/A = new /obj/item/bone_dart(usr.loc)
	A.throw_at(target, 10, 20, usr)
	add_logs(src, target, "launched a bone dart at")

/mob/living/simple_animal/hostile/lesser_changeling
	name = "crawling horror"
	desc = "An agile monster made of twisted flesh and bone."
	speak_emote = list("gibbers")
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "lesser_ling"
	icon_living = "lesser_ling"

	stop_automated_movement = TRUE
	universal_speak = TRUE
	universal_understand = TRUE

	tameable = FALSE

	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	maxHealth = 50
	health = 50
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 10
	mob_size = 15
	attacktext = "mangled"
	attack_sound = 'sound/weapons/bloodyslice.ogg'

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	pass_flags = PASSTABLE

	density = FALSE

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	speed = -1

	var/mob/living/carbon/human/occupant = null

/mob/living/simple_animal/hostile/lesser_changeling/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl

/mob/living/simple_animal/hostile/lesser_changeling/mind_initialize()
	..()
	mind.assigned_role = "Changeling"

/mob/living/simple_animal/hostile/lesser_changeling/death(gibbed)
	..()
	if(!gibbed)
		if(occupant)
			occupant.forceMove(get_turf(src))
			occupant.status_flags &= ~GODMODE
			if(mind)
				mind.transfer_to(occupant)

		visible_message("<span class='warning'>\The [src] explodes into a shower of gore!</span>")
		gibs(src.loc)
		qdel(src)
		return

/mob/living/simple_animal/hostile/lesser_changeling/verb/untransform()
	set name = "Return to original form"
	set desc = "Return to your original form."
	set category = "Changeling"

	if(!health)
		to_chat(usr, "<span class='notice'>We are dead, we cannot use any abilities!</span>")
		return

	if(last_special > world.time)
		return

	if(!isturf(loc))
		return

	last_special = world.time + 30

	if(occupant)
		occupant.forceMove(get_turf(src))
		occupant.status_flags &= ~GODMODE
		if(mind)
			mind.transfer_to(occupant)
		visible_message("<span class='warning'>\The [src] explodes into a shower of gore!</span>")
		gibs(src.loc)
		qdel(src)