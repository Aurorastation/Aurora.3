/obj/item/projectile/change
	name = "bolt of change"
	icon_state = "ice_1"
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"
	var/possible_transformations = list(/mob/living/simple_animal/lizard,/mob/living/simple_animal/rat,/mob/living/simple_animal/corgi, /mob/living/simple_animal/cat, /mob/living/simple_animal/slime, /mob/living/simple_animal/hostile/giant_spider, /mob/living/simple_animal/hostile/carp)

/obj/item/projectile/change/on_hit(var/atom/change)
	if (isliving(change))
		shapeshift(change, duration = 40, possible_transformations = possible_transformations)