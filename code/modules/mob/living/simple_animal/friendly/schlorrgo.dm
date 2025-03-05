#define EGG_SCHLORRGO 0
#define BABY_SCHLORRGO 1
#define NORMAL_SCHLORRGO 2
#define FAT_SCHLORRGO 3
#define WIDE_SCHLORRGO 4
#define COLOSSAL_SCHLORRGO 5

/mob/living/simple_animal/schlorrgo
	name = "schlorrgo"
	desc = "A fat creature native to the world of Hro'zamal."
	icon = 'icons/mob/npc/schlorrgo.dmi'
	icon_state = "schlorrgo"
	icon_living = "schlorrgo"
	icon_dead = "schlorrgo_dead"
	speak = list("Ough!")
	speak_emote = list("moans", "moans raucously")
	speak_chance = 1
	emote_hear = list("moans", "moans raucously")
	emote_see = list("rolls around")

	emote_sounds = list('sound/effects/creatures/ough.ogg')

	hunger_enabled = TRUE
	canbrush = TRUE

	maxHealth = 30
	health = 30

	can_be_milked = TRUE
	milk_type = /singleton/reagent/drink/milk/schlorrgo

	friendly = "bumped"
	response_help = "pets"

	meat_amount = 1
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	organ_names = list("head", "chest", "fatty core", "blubberous torso", "thick centre", "left leg", "right leg")
	butchering_products = list(/obj/item/reagent_containers/food/snacks/spreads/lard = 2)

	holder_type = /obj/item/holder/schlorrgo

	max_nutrition = 100
	stomach_size_mult = 10
	digest_factor = 0.6 // fast eater
	metabolic_factor = 0.3
	forbidden_foods = list(/obj/item/reagent_containers/food/snacks/egg/schlorrgo)

	faction = "Hro'zamal"

	var/starting_nutrition = 100
	/// When this threshold is reached, grow the Schlorrgo
	var/nutrition_threshold = 80

	/// Current size of the Schlorrgo.
	var/current_size = BABY_SCHLORRGO

	/// How many eggs the Schlorrgo is able to lay
	var/eggs_left = 0
	/// Bigger Schlorrgos can lay more eggs. Starts to increase after schlorrgo becomes fat. When set to 0, Schlorrgo will never lay eggs
	var/max_eggs = 0

/mob/living/simple_animal/schlorrgo/Initialize()
	. = ..()
	nutrition = starting_nutrition
	check_wideness_change()

/mob/living/simple_animal/schlorrgo/Life(seconds_per_tick, times_fired)
	. =..()
	if(!.)
		return
	if(!stat && prob(3) && eggs_left > 0) // Only fat schlorrgos lay eggs
		lay_egg()

/mob/living/simple_animal/schlorrgo/proc/lay_egg()
	if(!eggs_left)
		return FALSE
	// If colossal, high chance for egg to be crushed under weight.....
	if(current_size >= COLOSSAL_SCHLORRGO && prob(75))
		visible_message("[src] attempts to lift up high enough to lay an egg, but fails, crushing the egg!")
		audible_emote("cries out in agony!",0)
		make_noise()
		eggs_left--
		new /obj/effect/decal/cleanable/egg_smudge(get_turf(src))
		return
	visible_message("[src] lays an egg.")
	eggs_left--
	var/obj/item/reagent_containers/food/snacks/egg/schlorrgo/egg = new /obj/item/reagent_containers/food/snacks/egg/schlorrgo(get_turf(src))
	egg.fertilize()
	egg.pixel_x = rand(-6,6)
	egg.pixel_y = rand(-6,6)

/mob/living/simple_animal/schlorrgo/unarmed_harm_attack(mob/living/carbon/human/user)
	var/obj/item/organ/external/left_leg = user.get_organ(BP_L_LEG)
	var/obj/item/organ/external/right_leg = user.get_organ(BP_R_LEG)

	if(left_leg?.is_usable() && right_leg?.is_usable())
		user.do_attack_animation(src)
		make_noise()
		audible_emote("[pick(emote_hear)].")
		if(current_size >= WIDE_SCHLORRGO)
			user.visible_message(SPAN_WARNING("[user] kicks \the [src], but it doesn't move an inch!"), SPAN_DANGER("Your kick is suddenly stopped by \the [src]'s sheer fat!"))
			var/obj/item/organ/external/leg = pick(right_leg, left_leg)
			if(leg)
				if(current_size >= COLOSSAL_SCHLORRGO) //break leg
					leg.fracture()
					leg.take_damage(10)
				leg.take_damage(5)
		else
			user.visible_message(SPAN_WARNING("[user] punts \the [src]!"))
			throw_at(get_edge_target_turf(user, get_dir(user, src)), 4, 1)
			poke(TRUE)
	else
		..()

/mob/living/simple_animal/schlorrgo/turf_collision(var/turf/T, var/speed = THROWFORCE_SPEED_DIVISOR)
	visible_message(SPAN_WARNING("[src] harmlessly bounces off \the [T]!"))
	playsound(T, 'sound/effects/bangtaper.ogg', 50, 1, 1)

/mob/living/simple_animal/schlorrgo/fall_impact()
	visible_message(SPAN_NOTICE("\The [src] bounces after landing!"))
	playsound(src, 'sound/effects/bangtaper.ogg', 50, 1, 1)
	audible_emote("[pick(emote_hear)].",0)
	make_noise()
	step(src, pick(GLOB.alldirs), 1)
	return FALSE

/mob/living/simple_animal/schlorrgo/process_food()
	..()
	if(prob(4) && eggs_left < max_eggs && current_size >= FAT_SCHLORRGO) // Change to add egg when fat
		eggs_left += 1 // only +1 since this can proc often
	check_wideness_change()

/mob/living/simple_animal/schlorrgo/proc/check_wideness_change()
	if(nutrition >= nutrition_threshold)
		increase_wideness()

/mob/living/simple_animal/schlorrgo/proc/increase_wideness()
	switch(current_size)
		if(EGG_SCHLORRGO)
			if(!named)
				name = "schlorrgo hatchling"
			desc = "A fat creature native to the world of Hro'zamal. This one just hatched from an egg."
			current_size = BABY_SCHLORRGO
			max_nutrition = 100
			nutrition_threshold = 80
			maxHealth = 30
			health = 30
			mob_size = MOB_TINY
			meat_amount = 1
			butchering_products = list(/obj/item/reagent_containers/food/snacks/spreads/lard = 2)
			icon_state = "schlorrgo_baby"
			icon_living = "schlorrgo_baby"
			icon_dead = "schlorrgo_baby_dead"
			holder_type = /obj/item/holder/schlorrgo/baby

		if(BABY_SCHLORRGO)
			if(!named)
				name = "schlorrgo"
			desc = "A fat creature native to the world of Hro'zamal."
			current_size = NORMAL_SCHLORRGO
			max_nutrition = 200
			nutrition_threshold = 150
			maxHealth = 50
			health = 50
			mob_size = MOB_SMALL
			meat_amount = 3
			butchering_products = list(/obj/item/reagent_containers/food/snacks/spreads/lard = 5)
			icon_state = "schlorrgo"
			icon_living = "schlorrgo"
			icon_dead = "schlorrgo_dead"
			holder_type = /obj/item/holder/schlorrgo

		if(NORMAL_SCHLORRGO)
			if(!named)
				name = "fat schlorrgo"
			desc = "A fat creature native to the world of Hro'zamal. This one is fatter than most schlorrgo."
			current_size = FAT_SCHLORRGO
			max_nutrition = 400
			nutrition_threshold = 300
			maxHealth = 100
			health = 100
			mob_size = MOB_MEDIUM
			meat_amount = 6
			butchering_products = list(/obj/item/reagent_containers/food/snacks/spreads/lard = 8)
			icon_state = "schlorrgo_fat"
			icon_living = "schlorrgo_fat"
			icon_dead = "schlorrgo_fat_dead"
			holder_type = /obj/item/holder/schlorrgo/fat
			max_eggs = 3

		if(FAT_SCHLORRGO)
			if(!named)
				name = "massive schlorrgo"
			desc = "A fat creature native to the world of Hro'zamal. This one is so big it can barely walk."
			current_size = WIDE_SCHLORRGO
			max_nutrition = 1000
			nutrition_threshold = 800
			maxHealth = 250
			health = 250
			mob_size = MOB_LARGE
			meat_amount = 12
			butchering_products = list(/obj/item/reagent_containers/food/snacks/spreads/lard = 12)
			icon_state = "schlorrgo_wide"
			icon_living = "schlorrgo_wide"
			icon_dead = "schlorrgo_wide_dead"
			response_help = "rubs [name]'s belly"
			melee_damage_lower = 15
			melee_damage_upper = 15
			attacktext = "crushed"
			environment_smash = 1
			resistance = 2
			mob_swap_flags = HUMAN|ROBOT
			mob_push_flags = HUMAN|ROBOT
			a_intent = I_HURT
			emote_sounds = list('sound/effects/creatures/schlorrgo_scream.ogg')
			holder_type = null
			max_eggs = 6

		if(WIDE_SCHLORRGO)
			if(!named)
				name = "colossal schlorrgo"
			desc = "A fat creature native to the world of Hro'zamal. This one has been immobilized by its massive weight."
			current_size = COLOSSAL_SCHLORRGO
			max_nutrition = 1500
			maxHealth = 450
			health = 450
			mob_size = MOB_LARGE
			meat_amount = 25
			butchering_products = list(/obj/item/reagent_containers/food/snacks/spreads/lard = 25)
			icon = 'icons/mob/npc/colossal_schlorrgo.dmi'
			icon_state = "schlorrgo_colossal"
			icon_living = "schlorrgo_colossal"
			icon_dead = "schlorrgo_colossal_dead"
			response_help = "rubs a part of the [name]'s fat mass"
			emote_see = list("attempts to roll")
			pixel_x = -8
			anchored = TRUE
			opacity = TRUE
			melee_damage_lower = 25
			melee_damage_upper = 25
			environment_smash = 2
			resistance = 3
			mob_bump_flag = HEAVY // Oh lord he comin
			mob_swap_flags = HEAVY
			mob_push_flags = HEAVY
			can_be_buckled = FALSE
			a_intent = I_HURT
			emote_sounds = list('sound/effects/creatures/schlorrgo_scream.ogg')
			holder_type = null
			max_eggs = 9

	update_icon()

/mob/living/simple_animal/schlorrgo/Move()
	if(current_size >= COLOSSAL_SCHLORRGO)
		return

	. = ..()

/mob/living/simple_animal/schlorrgo/attempt_grab(var/mob/living/grabber)
	if(current_size >= WIDE_SCHLORRGO)
		to_chat(grabber, SPAN_WARNING("\The [src] is too large to grab!"))
		return FALSE
	else
		return TRUE

/mob/living/simple_animal/schlorrgo/baby
	max_nutrition = 50

	starting_nutrition = 50
	nutrition_threshold = 30

	current_size = EGG_SCHLORRGO

/mob/living/simple_animal/schlorrgo/cybernetic
	name = "cybernetic schlorrgo"
	desc = "A fat creature native to the world of Hro'zamal. This one has been heavily augmented by the People's Republic of Adhomai."
	icon = 'icons/mob/npc/schlorrgo.dmi'
	icon_state = "cyberschlorrgo"
	icon_living = "cyberschlorrgo"
	icon_dead = "cyberschlorrgo_dead"

	speak_emote = list("beeps", "beeps raucously")
	emote_hear = list("beeps", "beeps raucously")

	emote_sounds = list('sound/effects/creatures/cybeough.ogg')

	hunger_enabled = FALSE

	maxHealth = 80
	health = 80

	can_be_milked = FALSE

	organ_names = list("head", "chest", "augmented core", "augmented torso", "robotic centre", "left leg", "right leg")
	butchering_products = list(/obj/item/reagent_containers/food/snacks/spreads/lard = 1)

/mob/living/simple_animal/schlorrgo/cybernetic/emp_act(severity)
	. = ..()

	switch(severity)
		if(EMP_HEAVY)
			adjustFireLoss(rand(10, 15))
		if(EMP_LIGHT)
			adjustFireLoss(rand(5, 10))

/mob/living/simple_animal/schlorrgo/cybernetic/check_wideness_change()
	return


/mob/living/simple_animal/schlorrgo/cybernetic/death(gibbed)
	..(null, "dies!")
	if(!gibbed && prob(25))
		visible_message(SPAN_DANGER("\The [src] detonates!"))
		var/T = get_turf(src)
		new /obj/effect/gibspawner/generic(T)
		explosion(T, -1, 0, 2)
		qdel(src)

//the evil version

/mob/living/simple_animal/hostile/cybernetic_schlorrgo
	name = "cybernetic schlorrgo"
	desc = "A fat creature native to the world of Hro'zamal. This one has been heavily augmented by the People's Republic of Adhomai. It has an evil glare in its eyes."
	icon = 'icons/mob/npc/schlorrgo.dmi'
	icon_state = "cyberschlorrgo"
	icon_living = "cyberschlorrgo"
	icon_dead = "cyberschlorrgo_dead"

	speak = list("Ough!")
	emote_see = list("rolls around")
	speak_emote = list("beeps", "beeps maliciously")
	emote_hear = list("beeps", "beeps maliciously")
	emote_sounds = list('sound/effects/creatures/evil_cybeough.ogg')

	faction = "PRA" // Evil PRA Machine

	maxHealth = 80
	health = 80

	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "sawed"
	attack_sound = 'sound/weapons/saw/circsawhit.ogg'

	mob_size = MOB_SMALL
	organ_names = list("head", "chest", "augmented core", "augmented torso", "robotic centre", "left leg", "right leg")

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 1
	butchering_products = list(/obj/item/reagent_containers/food/snacks/spreads/lard = 1)

/mob/living/simple_animal/hostile/cybernetic_schlorrgo/Initialize()
	. = ..()
	if(prob(25))
		projectiletype = /obj/projectile/beam/pistol
		projectilesound = 'sound/weapons/laser1.ogg'
		rapid = FALSE
		ranged = TRUE

/mob/living/simple_animal/hostile/cybernetic_schlorrgo/emp_act(severity)
	. = ..()

	switch(severity)
		if(EMP_HEAVY)
			adjustFireLoss(rand(10, 15))
		if(EMP_LIGHT)
			adjustFireLoss(rand(5, 10))

/mob/living/simple_animal/hostile/cybernetic_schlorrgo/death(gibbed)
	..(null, "dies!")
	if(!gibbed && prob(25))
		visible_message(SPAN_DANGER("\The [src] detonates!"))
		var/T = get_turf(src)
		new /obj/effect/gibspawner/generic(T)
		explosion(T, -1, 0, 2)
		qdel(src)

#undef EGG_SCHLORRGO
#undef BABY_SCHLORRGO
#undef NORMAL_SCHLORRGO
#undef FAT_SCHLORRGO
#undef WIDE_SCHLORRGO
#undef COLOSSAL_SCHLORRGO
