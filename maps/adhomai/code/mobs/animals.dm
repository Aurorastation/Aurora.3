/mob/living/simple_animal/chicken/ice_tunneler
	name = "ice tunneler"
	desc = "An egg producing beast from Adhomai. It is known for burrowing in ice and snow."
	icon = 'icons/adhomai/animals.dmi'
	icon_state = "tunneler"
	icon_living = "tunneler"
	icon_dead = "tunneler_dead"
	speak = list("Fiiiiiii!")
	speak_emote = list("whistles")
	emote_hear = list("whistles loudly")
	emote_see = list("whistles")
	holder_type = null

/mob/living/simple_animal/chicken/ice_tunneler/update_icons()
	if (stat == DEAD)
		icon_state = icon_dead
	else if ((stat == UNCONSCIOUS || resting) && icon_rest)
		icon_state = icon_rest
	else if (icon_living)
		icon_state = icon_living

/mob/living/simple_animal/cow/fatshouter
	name = "fatshouter"
	desc = "An adhomian animal known for its production of milk and wool."
	icon = 'icons/adhomai/animals.dmi'
	icon_state = "fatshouter"
	icon_living = "fatshouter"
	icon_dead = "fatshouter_dead"
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/adhomai

/mob/living/simple_animal/hostile/retaliate/rafama
	name = "steed of Mata'ke"
	desc = "An animal native to Adhomai, known for its agressive behavior and mighty tusks."
	icon = 'icons/adhomai/animals.dmi'
	icon_state = "rafama"
	icon_living = "rafama"
	icon_dead = "rafama_dead"
	turns_per_move = 3
	speak_emote = list("chuffs")
	emote_hear = list("growls")
	emote_see = list("shakes its head", "stamps a foot", "glares around")
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	mob_size = 12
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/adhomai

	maxHealth = 50
	health = 50

	harm_intent_damage = 3
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	butchering_products = list(/obj/item/stack/material/animalhide = 8)
	meat_amount = 10