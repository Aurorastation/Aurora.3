/mob/living/simple_animal/hostile/retaliate/aquatic/carp
	name = "carp"
	desc = "A ferocious fish. May be too hardcore."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	faction = "fishes"
	meat_amount = 3

	maxHealth = 20
	health = 20
	harm_intent_damage = 5
	melee_damage_lower = 12
	melee_damage_upper = 12
	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat

/mob/living/simple_animal/hostile/retaliate/aquatic/carp/New()
	..()
	pixel_x = rand(-8,8)
	pixel_y = rand(-8,8)