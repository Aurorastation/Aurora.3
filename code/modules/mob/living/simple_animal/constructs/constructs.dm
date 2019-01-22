/mob/living/simple_animal/construct
	name = "Construct"
	real_name = "Construct"
	desc = ""
	speak_emote = list("hisses")
	emote_hear = list("wails","screeches")
	response_help  = "thinks better of touching"
	response_disarm = "flailed at"
	response_harm   = "punched"
	icon_dead = "shade_dead"
	speed = -1
	a_intent = I_HURT
	stop_automated_movement = 1
	status_flags = CANPUSH
	universal_speak = 1
	universal_understand = 1
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
	show_stat_health = 1
	faction = "cult"
	supernatural = 1
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	tameable = FALSE

	var/nullblock = 0

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS
	hunger_enabled = 0
	var/list/construct_spells = list()
	var/can_repair = 0

	var/health_prefix = ""
	appearance_flags = NO_CLIENT_COLOR


/mob/living/simple_animal/construct/cultify()
	return

/mob/living/simple_animal/construct/Initialize()
	. = ..()
	name = text("[initial(name)] ([rand(1, 1000)])")
	real_name = name
	add_language("Cult")
	add_language("Occult")
	for(var/spell in construct_spells)
		src.add_spell(new spell, "const_spell_ready")
	updateicon()
	add_glow()

/mob/living/simple_animal/construct/death()
	new /obj/item/weapon/ectoplasm (src.loc)
	..(null,"collapses in a shattered heap.")
	ghostize()
	qdel(src)

/mob/living/simple_animal/construct/attack_generic(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(user, /mob/living/simple_animal/construct))
		var/mob/living/simple_animal/construct/C = user
		if (C.can_repair)
			if(getBruteLoss() > 0)
				adjustBruteLoss(-5)
				adjustFireLoss(-5)
				user.visible_message("<span class='notice'>\The [user] mends some of \the [src]'s wounds.</span>")
			else
				if (health < maxHealth)
					user << "<span class='notice'>Healing \the [src] any further is beyond your abilities.</span>"
				else
					user << "<span class='notice'>\The [src] is undamaged.</span>"
			return
	return ..()

/mob/living/simple_animal/construct/examine(mob/user)
	..(user)
	var/msg = "<span cass='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n"
	if (src.health < src.maxHealth)
		msg += "<span class='warning'>"
		if (src.health >= src.maxHealth/2)
			msg += "It looks slightly dented.\n"
		else
			msg += "<B>It looks severely dented!</B>\n"
		msg += "</span>"
	msg += "*---------*</span>"

	user << msg

/mob/living/simple_animal/construct/UnarmedAttack(var/atom/A, var/proximity)
	if(istype(A, /obj/effect/rune))
		var/obj/effect/rune/R = A
		do_attack_animation(R)
		R.attack_hand(src)
	else
		..()


/////////////////Juggernaut///////////////



/mob/living/simple_animal/construct/armoured
	name = "Juggernaut"
	real_name = "Juggernaut"
	desc = "A possessed suit of armour driven by the will of the restless dead."
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 400
	health = 400
	health_prefix = "juggernaut"
	response_harm   = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	attacktext = "smashed their armoured gauntlet into"
	mob_size = MOB_LARGE
	speed = 3
	environment_smash = 2
	attack_sound = 'sound/weapons/heavysmash.ogg'
	status_flags = 0
	resistance = 10
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser)

/mob/living/simple_animal/construct/armoured/Life()
	weakened = 0
	..()

/mob/living/simple_animal/construct/armoured/bullet_act(var/obj/item/projectile/P)
	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
		var/reflectchance = 80 - round(P.damage/3)
		if(prob(reflectchance))
			adjustBruteLoss(P.damage * 0.3)
			visible_message("<span class='danger'>The [P.name] gets reflected by [src]'s shell!</span>", \
							"<span class='danger'>The [P.name] gets reflected by [src]'s shell!</span>")

			// Find a turf near or on the original location to bounce to
			if(P.starting)
				var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)

				// redirect the projectile
				P.firer = src
				P.old_style_target(locate(new_x, new_y, P.z))

			return -1 // complete projectile permutation

	return (..(P))

////////////////////////Wraith/////////////////////////////////////////////



/mob/living/simple_animal/construct/wraith
	name = "Wraith"
	real_name = "Wraith"
	desc = "A wicked bladed shell contraption piloted by a bound spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "floating"
	icon_living = "floating"
	maxHealth = 75
	health = 75
	health_prefix = "wraith"
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "slashed"
	speed = -1
	environment_smash = 1
	see_in_dark = 7
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/targeted/ethereal_jaunt/shift)

	flying = TRUE

/////////////////////////////Artificer/////////////////////////



/mob/living/simple_animal/construct/builder
	name = "Artificer"
	real_name = "Artificer"
	desc = "A bulbous construct dedicated to building and maintaining The Cult of Nar-Sie's armies."
	icon = 'icons/mob/mob.dmi'
	icon_state = "artificer"
	icon_living = "artificer"
	maxHealth = 50
	health = 50
	health_prefix = "artificer"
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "rammed"
	speed = 0
	environment_smash = 1
	attack_sound = 'sound/weapons/rapidslice.ogg'
	can_repair = 1
	construct_spells = list(/spell/aoe_turf/conjure/construct/lesser,
							/spell/aoe_turf/conjure/wall,
							/spell/aoe_turf/conjure/floor,
							/spell/aoe_turf/conjure/soulstone,
							/spell/aoe_turf/conjure/pylon
							)


/////////////////////////////Behemoth/////////////////////////


/mob/living/simple_animal/construct/behemoth
	name = "Behemoth"
	real_name = "Behemoth"
	desc = "The pinnacle of occult technology, Behemoths are the ultimate weapon in the Cult of Nar-Sie's arsenal."
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 750
	health = 750
	health_prefix = "juggernaut"
	speak_emote = list("rumbles")
	response_harm   = "harmlessly punched"
	harm_intent_damage = 0
	melee_damage_lower = 50
	melee_damage_upper = 50
	attacktext = "brutally crushed"
	speed = 5
	environment_smash = 2
	attack_sound = 'sound/weapons/heavysmash.ogg'
	resistance = 10
	var/energy = 0
	var/max_energy = 1000
	construct_spells = list(/spell/aoe_turf/conjure/forcewall/lesser)

////////////////////////Harvester////////////////////////////////



/mob/living/simple_animal/construct/harvester
	name = "Harvester"
	real_name = "Harvester"
	desc = "The promised reward of those who follow Nar'Sie, obtained by offering their bodies to the Geometer of Blood."
	icon = 'icons/mob/mob.dmi'
	icon_state = "harvester"
	icon_living = "harvester"
	maxHealth = 150
	health = 150
	health_prefix = "harvester"
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "violently stabbed"
	speed = -1
	environment_smash = 1
	see_in_dark = 7
	attack_sound = 'sound/weapons/pierce.ogg'
	can_repair = 1
	construct_spells = list(
			/spell/targeted/harvest,
			/spell/aoe_turf/knock/harvester,
			/spell/rune_write,
			/spell/aoe_turf/conjure/construct/lesser,
			/spell/aoe_turf/conjure/wall,
			/spell/aoe_turf/conjure/floor,
			/spell/aoe_turf/conjure/soulstone,
			/spell/aoe_turf/conjure/pylon,
			/spell/aoe_turf/conjure/forcewall/lesser
		)
	//Harvesters are endgame stuff, no harm giving them construct spells

	flying = TRUE

////////////////Glow//////////////////
/mob/living/simple_animal/construct/proc/add_glow()
	cut_overlays()
	var/overlay_layer = LIGHTING_LAYER+0.1
	if(layer != MOB_LAYER)
		overlay_layer=TURF_LAYER+0.2

	add_overlay(image(icon,"glow-[icon_state]",overlay_layer))
	set_light(2, -2, l_color = "#FFFFFF")

////////////////HUD//////////////////////

/mob/living/simple_animal/construct/Life()
	. = ..()
	if(.)
		var/newstate
		if(fire)
			newstate = fire_alert ? "fire1" : "fire0"
			if (fire.icon_state != newstate)
				fire.icon_state = newstate

		if(pullin)
			newstate = pulling ? "pull1" : "pull0"
			if (pullin.icon_state != newstate)
				pullin.icon_state = newstate

		if(purged)
			newstate = purge > 0 ? "purge1" : "purge0"
			if (purged.icon_state != newstate)
				purged.icon_state = newstate

		silence_spells(purge)

	if (healths)
		var/health_percent = (health/maxHealth)*100
		var/newstate = 0
		switch (health_percent)
			if (84 to INFINITY)
				newstate = 0
			if (70 to 84)
				newstate = 1
			if (56 to 70)
				newstate = 2
			if (42 to 56)
				newstate = 3
			if (28 to 42)
				newstate = 4
			if (14 to 28)
				newstate = 5
			if (1 to 14)
				newstate = 6
			else
				newstate = 7
		newstate = "[health_prefix][newstate]"
		if (healths.icon_state != newstate)
			healths.icon_state = newstate
