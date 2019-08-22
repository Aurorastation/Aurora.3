/obj/item/projectile/change
	name = "bolt of change"
	icon_state = "ice_1"
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"
	var/possible_transformations = list(/mob/living/simple_animal/lizard/wizard, /mob/living/simple_animal/rat/wizard, /mob/living/simple_animal/corgi, /mob/living/simple_animal/penguin/wizard, /mob/living/simple_animal/cat/wizard, /mob/living/simple_animal/slime/wizard, /mob/living/simple_animal/hostile/giant_spider/wizard, /mob/living/simple_animal/hostile/carp/wizard)

/obj/item/projectile/change/on_hit(var/atom/change)
	if (isliving(change))
		shapeshift(change, duration = 400, possible_transformations = possible_transformations, newVars = list("health" = 150, "maxHealth" = 150))