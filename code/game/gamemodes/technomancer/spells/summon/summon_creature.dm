/datum/technomancer/spell/summon_creature
	name = "Summon Creature"
	desc = "Teleports a specific creature from their current location in the universe to the targeted tile, \
	after a delay. The creature summoned can be chosen by using the ability in your hand. \
	Available creatures are; mice, crabs, parrots, bats, goats, cats, corgis, spiders, and space carp. \
	The creatures take a few moments to be teleported to the targeted tile. Note that the creatures summoned are \
	not inherently loyal to the technomancer, and that the creatures will be hurt slightly from being teleported to you."
	enhancement_desc = "Summoned entities will never harm their summoner."
	spell_power_desc = "The strength and endurance of the summoned creature will be greater."
	cost = 100
	ability_icon_state = "wiz_carp"
	obj_path = /obj/item/spell/summon/summon_creature
	category = UTILITY_SPELLS

/obj/item/spell/summon/summon_creature
	name = "summon creature"
	desc = "Chitter chitter."
	summoned_mob_type = null
	summon_options = list(
		"Rat"					=	/mob/living/simple_animal/rat,
		"Lizard"				=	/mob/living/simple_animal/lizard,
		"Chicken"				=	/mob/living/simple_animal/chicken,
		"Chick"					=	/mob/living/simple_animal/chick,
		"Crab"					=	/mob/living/simple_animal/crab,
		"Parrot"				=	/mob/living/simple_animal/parrot,
		"Goat"					=	/mob/living/simple_animal/hostile/retaliate/goat,
		"Cat"					=	/mob/living/simple_animal/cat,
		"Corgi"					=	/mob/living/simple_animal/corgi,
		"Corgi Pup"				=	/mob/living/simple_animal/corgi/puppy,
		"BAT"					=	/mob/living/simple_animal/hostile/scarybat,
		"GREIMORIAN"			=	/mob/living/simple_animal/hostile/giant_spider,
		"GREIMORIAN HUNTER"		=	/mob/living/simple_animal/hostile/giant_spider/hunter,
		"GREIMORIAN BOMBARDIER"	=	/mob/living/simple_animal/hostile/giant_spider/bombardier,
		"GREIMORIAN NURSE"		=	/mob/living/simple_animal/hostile/giant_spider/nurse,
		"CARP"					=	/mob/living/simple_animal/hostile/carp,
		"BEAR"					=	/mob/living/simple_animal/hostile/bear
		)
	cooldown = 30
	instability_cost = 10
	energy_cost = 1000

/obj/item/spell/summon/summon_creature/on_summon(var/mob/living/simple_animal/summoned)
	if(check_for_scepter())
		if(istype(summoned, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/H = summoned
			H.friends += owner

	// Makes their new pal big and strong, if they have spell power.
	summoned.maxHealth = calculate_spell_power(summoned.maxHealth)
	summoned.health = calculate_spell_power(summoned.health)
	summoned.melee_damage_lower = calculate_spell_power(summoned.melee_damage_lower)
	summoned.melee_damage_upper = calculate_spell_power(summoned.melee_damage_upper)

	var/new_size = calculate_spell_power(1)
	if(new_size != 1)
		adjust_scale(new_size)


	// Now we hurt their new pal, because being forcefully abducted by teleportation can't be healthy.
	summoned.adjustBruteLoss(summoned.getMaxHealth() * 0.3) // Lose 30% of max health on arrival (but could be healed back up).
