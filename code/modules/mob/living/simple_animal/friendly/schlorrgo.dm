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
	emote_hear = list("moans", "moans raucously")
	emote_see = list("rolls around")

	emote_sounds = list('sound/effects/creatures/ough.ogg')

	meat_amount = 1
	hunger_enabled = TRUE
	canbrush = TRUE

	maxHealth = 30
	health = 30

	has_udder = TRUE
	milk_type = /singleton/reagent/drink/milk/schlorrgo

	friendly = "bumped"

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	organ_names = list("head", "chest", "fatty core", "blubberous torso", "thick centre", "left leg", "right leg")
	butchering_products = list(/obj/item/reagent_containers/food/snacks/spreads/lard = 2)

	holder_type = /obj/item/holder/schlorrgo

	max_nutrition = 100

	stomach_size_mult = 10

	metabolic_factor = 0.3

	var/starting_nutrition = 100
	var/nutrition_threshold = 80

	var/current_size = BABY_SCHLORRGO

/mob/living/simple_animal/schlorrgo/Initialize()
	. = ..()
	nutrition = starting_nutrition
	check_wideness_change()

/mob/living/simple_animal/schlorrgo/unarmed_harm_attack(mob/living/carbon/human/user)
	var/obj/item/organ/external/left_leg = user.get_organ(BP_L_LEG)
	var/obj/item/organ/external/right_leg = user.get_organ(BP_R_LEG)

	if(left_leg?.is_usable() && right_leg?.is_usable())
		if(current_size >= WIDE_SCHLORRGO)
			user.visible_message(SPAN_WARNING("[user] harmlessly kicks \the [src]!"))
			var/obj/item/organ/external/leg = pick(right_leg, left_leg)
			if(leg)
				leg.take_damage(5)
		else
			user.visible_message(SPAN_WARNING("[user] punts \the [src]!"))
			user.do_attack_animation(src)
			make_noise()
			throw_at(get_edge_target_turf(user, get_dir(user, src)), 4, 1)
			poke(TRUE)
	else
		..()

/mob/living/simple_animal/schlorrgo/turf_collision(var/turf/T, var/speed = THROWFORCE_SPEED_DIVISOR)
	visible_message(SPAN_WARNING("[src] harmlessly bounces off \the [T]!"))
	playsound(T, 'sound/effects/bangtaper.ogg', 50, 1, 1)
	make_noise()

/mob/living/simple_animal/schlorrgo/fall_impact()
	visible_message(SPAN_NOTICE("\The [src] bounces after landing!"))
	step(src, pick(alldirs), 1)
	return FALSE

/mob/living/simple_animal/schlorrgo/process_food()
	..()
	check_wideness_change()

/mob/living/simple_animal/schlorrgo/proc/check_wideness_change()
	if(nutrition >= nutrition_threshold)
		increase_wideness()

/mob/living/simple_animal/schlorrgo/proc/increase_wideness()
	switch(current_size)

		if(EGG_SCHLORRGO)
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

		if(FAT_SCHLORRGO)
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
			melee_damage_lower = 15
			melee_damage_upper = 15
			attacktext = "crushed"
			environment_smash = 1
			resistance = 2
			mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
			mob_push_flags = ALLMOBS
			a_intent = I_HURT
			emote_sounds = list('sound/effects/creatures/schlorrgo_scream.ogg')
			holder_type = null

		if(WIDE_SCHLORRGO)
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
			pixel_x = -8
			anchored = TRUE
			opacity = TRUE
			melee_damage_lower = 25
			melee_damage_upper = 25
			environment_smash = 2
			resistance = 3
			mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
			mob_push_flags = ALLMOBS
			a_intent = I_HURT
			emote_sounds = list('sound/effects/creatures/schlorrgo_scream.ogg')
			holder_type = null

	update_icon()

/mob/living/simple_animal/schlorrgo/Move()
	if(current_size >= COLOSSAL_SCHLORRGO)
		return
	..()

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