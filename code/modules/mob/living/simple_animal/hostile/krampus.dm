/mob/living/simple_animal/hostile/krampus
	name = "Krampus"
	desc = "An evil spirit of Christmas, it is known for punishing misbehaving children."
	speak_emote = list("gibbers")
	icon = 'icons/mob/krampus.dmi'
	icon_state = "krampus"
	icon_living = "krampus"
	icon_dead = "krampus_dead"
	stop_automated_movement = 1
	universal_speak = 1
	universal_understand = 1

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	tameable = FALSE

	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	maxHealth = 1000
	health = 1000
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	mob_size = 25
	environment_smash = 2
	attacktext = "punished"
	attack_sound = 'sound/weapons/bladeslice.ogg'

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	faction = "Krampus"

	var/is_punishing = FALSE


/mob/living/simple_animal/hostile/krampus/death(gibbed)
	..()
	if(!gibbed)
		for (var/mob/living/A in contents)
			A.forceMove(get_turf(src))
		visible_message("<span class='warning'>\The [src] vanishes!</span>")
		dust()
		return TRUE

/mob/living/simple_animal/hostile/krampus/verb/punish(mob/living/target as mob in oview())
	set name = "Punish"
	set desc = "Punish some naughty mortal by dragging them to the depths of hell."
	set category = "Krampus"

	if(!Adjacent(target))
		return

	if(src.is_punishing)
		return

	if(!health)
		return

	if(last_special > world.time)
		to_chat(src, "<span class='warning'>You must wait a little while before you can use this ability again!</span>")
		return

	src.visible_message("<span class='danger'>\The [src] starts stuffing \the [target] inside his bag!</span>", \
						"<span class='danger'>You begin to drag \the [target] to the depths of hell!</span>")
	src.is_punishing = TRUE

	if(!do_mob(src, target, 60))
		to_chat(src, "<span class='danger'>\The [target] has managed to escape!</span>")
		src.is_punishing = FALSE
		return

	src.visible_message("<span class='danger'>\The [target] vanishes into \the [src]'s bag!</span>")
	target.forceMove(src)
	to_chat(target, "<span class='danger'>You have been captured by \the [src], you will soon be punished due to your misdeeds!</span>")
	addtimer(CALLBACK(src, .proc/send_to_hell, target), 5 MINUTES)
	last_special = world.time + 100
	src.is_punishing = FALSE
	return

/mob/living/simple_animal/hostile/krampus/verb/mischief()
	set name = "Spread Mischief"
	set desc = "Summon several malicious gifts to cause mischief among the mortals."
	set category = "Krampus"

	if(!health)
		return

	if(last_special > world.time)
		return

	last_special = world.time + 30

	visible_message("<span class='danger'>\The [src] vomits a cloud of rancid smoke and neatly wrapped gifts!</span>")

	var/datum/effect/effect/system/smoke_spread/bad/smoke = new /datum/effect/effect/system/smoke_spread/bad
	smoke.attach(src)
	smoke.set_up(10, 0, get_turf(src), 10)
	smoke.start()

	for(var/i in 1 to 5)
		var/mob/living/simple_animal/hostile/gift/T = new /mob/living/simple_animal/hostile/gift(get_turf(src))
		var/turf/landing = get_step(src, pick(alldirs))
		addtimer(CALLBACK(T, /atom/movable/.proc/throw_at, landing, 30, 5), 0)

/mob/living/simple_animal/hostile/krampus/proc/send_to_hell(mob/living/M)
	if(!M)
		return
	to_chat(M, "<span class='danger'>You are dragged to the depths of hell to be eternally punished for your misdeeds!</span>")
	qdel(M)
	rejuvenate()
	updatehealth()

/mob/living/simple_animal/hostile/gift
	name = "christmas gift"
	desc = "PRESENTS!!!!...OH SHIT!"
	icon = 'icons/obj/items.dmi'
	icon_state = "gift1_evil"
	icon_living = "gift1_evil"
	icon_dead = "gift1"

	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"
	speed = 4
	maxHealth = 50
	health = 50

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = "nibbled"
	attack_sound = 'sound/weapons/bite.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "Krampus"
	move_to_delay = 4

	tameable = FALSE

	var/size = "small"

/mob/living/simple_animal/hostile/gift/Initialize()
	. = ..()
	size = pick ("small", "medium", "big")

	switch(size)

		if("medium")
			icon_state = "gift2_evil"
			icon_living = "gift2_evil"
			icon_dead = "gift2"
			maxHealth = 100
			health = 100
			melee_damage_lower = 10
			melee_damage_upper = 10

		if("big")
			icon_state = "gift3_evil"
			icon_living = "gift3_evil"
			icon_dead = "gift3"
			maxHealth = 150
			health = 150
			melee_damage_lower = 15
			melee_damage_upper = 15

	updatehealth()


/mob/living/simple_animal/hostile/gift/death()
	..()
	switch(size)

		if("medium")
			new /obj/item/xmasgift/medium(get_turf(src))

		if("big")
			new /obj/item/xmasgift/large(get_turf(src))

		else
			new /obj/item/xmasgift/small(get_turf(src))

	qdel(src)