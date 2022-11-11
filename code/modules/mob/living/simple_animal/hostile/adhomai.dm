/mob/living/simple_animal/hostile/wind_devil
	name = "sham'tyr"
	desc = "A flying adhomian creature, known for their loud wails that can be heard far below the clouds they soar above."
	icon_state = "devil"
	icon_living = "devil"
	icon_dead = "devil_dead"
	icon_rest = "devil_rest"
	turns_per_move = 3

	organ_names = list("head", "chest", "right wing", "left wing", "right leg", "left leg")
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = -2
	maxHealth = 80
	health = 80
	mob_size = 10

	pass_flags = PASSTABLE

	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	environment_smash = 1

	faction = "Adhomai"
	flying = TRUE
	butchering_products = list(/obj/item/stack/material/animalhide = 1)
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 5