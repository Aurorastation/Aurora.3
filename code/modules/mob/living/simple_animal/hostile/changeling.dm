/mob/living/simple_animal/hostile/true_changeling
	name = "shambling horror"
	desc = "An entity ripped from your nightmares. A monstrous creature, a warped parody of a living being. It is created from a twisted amalgamation of flesh and bone, covered in oozing sores, open wounds, and serrated knife-like blades of bone. A strong, sickening smell of rot, blood, and sickness emanates from it."
	speak_emote = list("snarls")
	emote_hear = list("gibbers")
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

	organ_names = list("gaping maw", "misshapen head", "engorged abdomen", "bladed tail", "warped legs", "scythelike arm")
	response_help  = "pokes"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	blood_amount = 1000
	maxHealth = 1250
	health = 1250
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 45
	armor_penetration = 30
	ranged = 1
	projectiletype = /obj/item/projectile/bonedart/ling
	projectilesound = 'sound/weapons/bloodyslice.ogg'
	resist_mod = 15
	mob_size = 25
	environment_smash = 2
	attacktext = "mangled"
	attack_sound = 'sound/weapons/bloodyslice.ogg'
	emote_sounds = list('sound/effects/creatures/bear_loud_1.ogg', 'sound/effects/creatures/bear_loud_2.ogg', 'sound/effects/creatures/bear_loud_3.ogg', 'sound/effects/creatures/bear_loud_4.ogg')

	see_invisible = SEE_INVISIBLE_NOLIGHTING

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 5
	max_co2 = 0
	max_tox = 0

	var/is_devouring = FALSE
	var/mob/living/carbon/human/occupant = null
	var/loud_sounds = list('sound/effects/creatures/bear_loud_1.ogg',
	'sound/effects/creatures/bear_loud_2.ogg',
	'sound/effects/creatures/bear_loud_3.ogg',
	'sound/effects/creatures/bear_loud_4.ogg')

/mob/living/simple_animal/hostile/true_changeling/Initialize()
	. = ..()
	if(prob(25))
		icon_state = "horror"
		icon_living = "horror"
		icon_dead = "horror_dead"

/mob/living/simple_animal/hostile/true_changeling/mind_initialize()
	..()
	mind.assigned_role = "Changeling"


/mob/living/simple_animal/hostile/true_changeling/Life()
	if(prob(10))
		custom_emote(VISIBLE_MESSAGE, pick( list("shrieks!","roars!", "screeches!", "snarls!", "bellows!", "screams!") ) )
		var/sound = pick(loud_sounds)
		playsound(src, sound, 90, 1, 15, pressure_affected = 0)


/mob/living/simple_animal/hostile/true_changeling/death(gibbed)
	..()
	if(!gibbed)
		visible_message("<b>[src]</b> lets out a waning scream as it disintegrates into a pile of flesh!")
		playsound(loc, 'sound/effects/creatures/vannatusk_attack.ogg', 90, 1, 15)
		if(occupant)
			qdel(occupant)
		gibs(src.loc)
		qdel(src)
		return

/mob/living/simple_animal/hostile/true_changeling/verb/ling_devour(mob/living/target as mob in oview())
	set category = "Changeling"
	set name = "Devour (Heal)"
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

/mob/living/simple_animal/hostile/true_changeling/attempt_grab(var/mob/living/grabber)
	to_chat(grabber, SPAN_WARNING("\The [src] contorts and shifts away from you when you try to grab it!"))
	return FALSE

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

	/// after this amount of time, we gain the untransform verb
	var/untransform_time = 0
	/// if we don't have an occupant yet, we'll use this one when we gain the untransform verb
	var/mob/living/carbon/human/untransform_occupant = null

/mob/living/simple_animal/hostile/lesser_changeling/revive
	untransform_time = 5 MINUTES

/mob/living/simple_animal/hostile/lesser_changeling/Initialize()
	. = ..()
	add_verb(src, /mob/living/proc/ventcrawl)
	if(!untransform_time)
		add_verb(src, /mob/living/simple_animal/hostile/lesser_changeling/proc/untransform)
	else
		addtimer(CALLBACK(src, PROC_REF(add_untransform_verb)), untransform_time, TIMER_UNIQUE|TIMER_OVERRIDE)

/mob/living/simple_animal/hostile/lesser_changeling/mind_initialize()
	..()
	mind.assigned_role = "Changeling"

/mob/living/simple_animal/hostile/lesser_changeling/Destroy()
	. = ..()
	QDEL_NULL(occupant)
	QDEL_NULL(untransform_occupant)

/mob/living/simple_animal/hostile/lesser_changeling/proc/add_untransform_verb()
	if(!occupant)
		occupant = untransform_occupant
		untransform_occupant = null
	to_chat(src, SPAN_ALIEN("We are now ready to assume a greater form."))
	add_verb(src, /mob/living/simple_animal/hostile/lesser_changeling/proc/untransform)

/mob/living/simple_animal/hostile/lesser_changeling/death(gibbed)
	..()
	if(!gibbed)
		if(occupant)
			occupant.forceMove(get_turf(src))
			occupant.status_flags &= ~GODMODE
			if(mind)
				mind.transfer_to(occupant)
				occupant.client.init_verbs()
			occupant = null

		visible_message("<span class='warning'>\The [src] explodes into a shower of gore!</span>")
		gibs(src.loc)
		qdel(src)
		return

/mob/living/simple_animal/hostile/lesser_changeling/proc/untransform()
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
		occupant.client.init_verbs()
		occupant = null
		visible_message("<span class='warning'>\The [src] explodes into a shower of gore!</span>")
		gibs(src.loc)
		qdel(src)
