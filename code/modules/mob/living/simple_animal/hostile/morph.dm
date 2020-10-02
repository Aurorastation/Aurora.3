#define MORPH_COOLDOWN 50

/mob/living/simple_animal/hostile/morph
	name = "morph"
	desc = "A revolting, pulsating pile of flesh."
	speak_emote = list("gurgles")
	emote_hear = list("gurgles")
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "morph"
	icon_living = "morph"
	icon_dead = "morph_dead"
	speed = 2.5
	stop_automated_movement = TRUE
	organ_names = list("bulbous node", "meaty core")
	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"

	mob_size = 15

	universal_speak = TRUE
	universal_understand = TRUE

	tameable = FALSE

	status_flags = CANPUSH
	pass_flags = PASSTABLE

	maxHealth = 125
	health = 125

	melee_damage_lower = 12
	melee_damage_upper = 16

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	wander = FALSE

	attacktext = "glomped"
	attack_sound = 'sound/effects/blobattack.ogg'

	var/morphed = FALSE
	var/melee_damage_disguised = 0
	var/eat_while_disguised = FALSE
	var/atom/movable/form = null
	var/morph_time = 0
	var/static/list/blacklist_typecache = typecacheof(list(/obj/screen, /obj/singularity, /mob/living/simple_animal/hostile/morph, /obj/effect))

/mob/living/simple_animal/hostile/morph/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl

/mob/living/simple_animal/hostile/morph/examine(mob/user)
	if(morphed)
		. = form.examine(user)
		if(get_dist(src, user) > 2)
			return
		to_chat(user, SPAN_WARNING("It doesn't look quite right..."))
	else
		return ..()

/mob/living/simple_animal/hostile/morph/proc/allowed(atom/movable/A)
	return !is_type_in_typecache(A, blacklist_typecache) && (isobj(A) || ismob(A))

/mob/living/simple_animal/hostile/morph/proc/eat(var/atom/movable/A, var/delay = 20)
	if(morphed && !eat_while_disguised)
		to_chat(src, SPAN_WARNING("You can't eat anything while you are disguised!"))
		return FALSE
	if(A?.loc == src)
		return FALSE
	visible_message(SPAN_WARNING("\The [src] begins swallowing \the [A] whole!"), SPAN_NOTICE("You begin swallowing \the [A] whole."))
	if(do_after(src, delay, act_target = A))
		visible_message(SPAN_WARNING("\The [src] swallows \the [A] whole!"), SPAN_NOTICE("You swallow \the [A] whole."))
		A.forceMove(src)
		return TRUE

/mob/living/simple_animal/hostile/morph/AltClickOn(atom/movable/A)
	if(morph_time <= world.time && !stat)
		if(A == src)
			restore()
		else if(istype(A) && allowed(A))
			assume(A)
	else
		to_chat(src, SPAN_WARNING("Your chameleon skin is still repairing itself!"))

/mob/living/simple_animal/hostile/morph/proc/assume(atom/movable/target)
	if(morphed)
		to_chat(src, SPAN_WARNING("You must restore to your original form first!"))
		return
	morphed = TRUE
	form = target
	visible_message(SPAN_WARNING("\The [src] suddenly twists and changes shape, becoming a copy of \the [target]!"), SPAN_NOTICE("You twist your body and assume the form of \the [target]."))
	appearance = target.appearance
	alpha = max(alpha, 150)	//fucking chameleons
	transform = initial(transform)
	pixel_y = initial(pixel_y)
	pixel_x = initial(pixel_x)

	//Morphed is weaker
	melee_damage_lower = melee_damage_disguised
	melee_damage_upper = melee_damage_disguised
	speed = 1
	mob_size = MOB_MINISCULE

	morph_time = world.time + MORPH_COOLDOWN
	return

/mob/living/simple_animal/hostile/morph/proc/restore()
	if(!morphed)
		to_chat(src, SPAN_WARNING("You're already in your normal form!"))
		return
	morphed = FALSE
	form = null
	alpha = initial(alpha)
	color = initial(color)
	desc = initial(desc)
	animate_movement = SLIDE_STEPS
	maptext = null

	visible_message(SPAN_WARNING("\The [src] suddenly collapses in on itself, dissolving into a pile of green flesh!"), SPAN_NOTICE("You reform to your normal body."))
	name = initial(name)
	icon = initial(icon)
	icon_state = initial(icon_state)
	cut_overlays()
	overlays = null

	//Baseline stats
	melee_damage_lower = initial(melee_damage_lower)
	melee_damage_upper = initial(melee_damage_upper)
	speed = 2.5
	mob_size = 15

	morph_time = world.time + MORPH_COOLDOWN

/mob/living/simple_animal/hostile/morph/death(gibbed)
	if(morphed)
		visible_message(SPAN_WARNING("\The [src] twists and dissolves into a pile of green flesh!"), SPAN_DANGER("Your skin ruptures! Your flesh breaks apart! No disguise can ward off de--"))
		restore()
	barf_contents()
	..()

/mob/living/simple_animal/hostile/morph/proc/barf_contents()
	for(var/atom/movable/AM in src)
		AM.forceMove(loc)
		if(prob(90))
			step(AM, pick(global.alldirs))

/mob/living/simple_animal/hostile/morph/UnarmedAttack(atom/A, proximity)
	if(morphed && !melee_damage_disguised)
		to_chat(src, SPAN_WARNING("You can't attack while disguised!"))
		return
	if(isliving(A)) //Eat Corpses to regen health
		var/mob/living/L = A
		if(L.stat == DEAD)
			if(eat(L, 30))
				adjustBruteLoss(-50)
				return
	else if(istype(A, /obj/item)) //Eat items just to be annoying
		var/obj/item/I = A
		if(!I.anchored)
			eat(I, 20)
			return
	return ..()

/mob/living/simple_animal/hostile/bullet_act(obj/item/projectile/P, def_zone)
	..()
	if (ismob(P.firer) && target_mob != P.firer)
		target_mob = P.firer
		stance = HOSTILE_STANCE_ATTACK

/mob/living/simple_animal/hostile/morph/attackby(obj/item/O, mob/user)
	..()
	if(morphed && user != src)
		restore()

/mob/living/simple_animal/hostile/morph/hitby(atom/movable/AM, speed)
	..()
	if(morphed)
		restore()

/mob/living/simple_animal/hostile/morph/attack_generic(mob/user, damage, attack_message)
	..()
	if(morphed)
		restore()

/mob/living/simple_animal/hostile/morph/attack_hand(mob/living/carbon/human/M)
	..()
	if(morphed && M != src)
		restore()

/mob/living/simple_animal/hostile/morph/start_ventcrawl()
	if(morphed)
		to_chat(src, SPAN_WARNING("You can't ventcrawl while disguised!"))
		return
	return ..()

/mob/living/simple_animal/hostile/morph/do_animate_chat(var/message, var/datum/language/language, var/small, var/list/show_to, var/duration, var/list/message_override)
	INVOKE_ASYNC(src, /atom/movable/proc/animate_chat, message, language, small, show_to, duration)