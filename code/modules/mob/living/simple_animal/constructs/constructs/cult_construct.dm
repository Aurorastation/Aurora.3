/mob/living/simple_animal/construct
	name = "Construct"
	real_name = "Construct"
	desc = ""
	speak_emote = list("hisses")
	emote_hear = list("wails", "screeches")
	response_help = "thinks better of touching"
	response_disarm = "flailed at"
	response_harm = "punched"
	icon_dead = "shade_dead"
	speed = -1
	a_intent = I_HURT
	stop_automated_movement = TRUE
	status_flags = CANPUSH
	universal_speak = TRUE
	universal_understand = TRUE
	attack_sound = 'sound/weapons/spiderlunge.ogg'
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	show_stat_health = TRUE
	faction = "cult"
	supernatural = TRUE
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_ONE
	blood_type = "#000000"

	tameable = FALSE

	var/nullblock = FALSE

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS
	hunger_enabled = FALSE
	var/list/construct_spells = list()
	var/can_repair = FALSE

	var/health_prefix = ""
	appearance_flags = NO_CLIENT_COLOR


/mob/living/simple_animal/construct/cultify()
	return

/mob/living/simple_animal/construct/Initialize()
	. = ..()
	var/static/list/construct_descriptors = list("lumbering", "ponderous", "rumbling", "sleek", "solid", "ephemeral", "dense", "shimmering", "dull", "glittering", "shining", "sluggish", "quiet", "ominious", "weighty", "mysterious")
	name = "[capitalize(pick(construct_descriptors))] [initial(name)]"
	real_name = name
	add_language(LANGUAGE_CULT)
	add_language(LANGUAGE_OCCULT)
	for(var/spell in construct_spells)
		src.add_spell(new spell, "const_spell_ready")
	updateicon()
	add_glow()

/mob/living/simple_animal/construct/death()
	new /obj/item/ectoplasm(get_turf(src))
	..(null, "collapses in a shattered heap.")
	ghostize()
	qdel(src)

/mob/living/simple_animal/construct/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_METAL

/mob/living/simple_animal/construct/attack_generic(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(user, /mob/living/simple_animal/construct))
		var/mob/living/simple_animal/construct/C = user
		if(C.can_repair)
			if(getBruteLoss())
				adjustBruteLoss(-5)
				adjustFireLoss(-5)
				user.visible_message(span("notice", "\The [user] mends some of \the [src]'s wounds."))
			else
				if (health < maxHealth)
					to_chat(user, span("notice", "Healing \the [src] any further is beyond your abilities."))
				else
					to_chat(user, span("notice", "\The [src] is undamaged."))
			return
	return ..()

/mob/living/simple_animal/construct/examine(mob/user)
	..(user)
	if(health < maxHealth)
		if(health >= maxHealth / 2)
			to_chat(user, span("warning", "It looks slightly dented."))
		else
			to_chat(user, span("warning", "It looks severely dented!"))

/mob/living/simple_animal/construct/UnarmedAttack(var/atom/A, var/proximity)
	if(istype(A, /obj/effect/rune))
		var/obj/effect/rune/R = A
		do_attack_animation(R)
		R.attack_hand(src)
	else
		..()

/mob/living/simple_animal/construct/proc/add_glow()
	cut_overlays()
	var/overlay_layer = LIGHTING_LAYER + 0.1
	if(layer != MOB_LAYER)
		overlay_layer = TURF_LAYER + 0.2

	add_overlay(image(icon, "glow-[icon_state]", overlay_layer))
	set_light(2, -2, l_color = COLOR_WHITE)

/mob/living/simple_animal/construct/Life()
	. = ..()
	if(.)
		var/newstate
		if(fire)
			newstate = fire_alert ? "fire1" : "fire0"
			if(fire.icon_state != newstate)
				fire.icon_state = newstate

		if(pullin)
			newstate = pulling ? "pull1" : "pull0"
			if(pullin.icon_state != newstate)
				pullin.icon_state = newstate

		if(purged)
			newstate = purge > 0 ? "purge1" : "purge0"
			if(purged.icon_state != newstate)
				purged.icon_state = newstate

		silence_spells(purge)

	if(healths)
		var/health_percent = (health / maxHealth) * 100
		var/newstate = 0
		switch(health_percent)
			if(84 to INFINITY)
				newstate = 0
			if(70 to 84)
				newstate = 1
			if(56 to 70)
				newstate = 2
			if(42 to 56)
				newstate = 3
			if(28 to 42)
				newstate = 4
			if(14 to 28)
				newstate = 5
			if(1 to 14)
				newstate = 6
			else
				newstate = 7

		newstate = "[health_prefix]_health[newstate]"
		if(healths.icon_state != newstate)
			healths.icon_state = newstate
