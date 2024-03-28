/mob/living/simple_animal/threshbeast
	name = "threshbeast"
	desc = "Large herbivorous reptiles native to Moghes, the azkrazal or 'threshbeast' is commonly used as a mount, beast of burden, or convenient food source by Unathi. They are highly valued for their speed and strength, capable of running at 30-42 miles per hour at top speed."
	icon = 'icons/mob/npc/moghes_64.dmi'
	icon_state = "threshbeast"
	icon_living = "threshbeast"
	icon_dead = "threshbeast_dead"
	speak_emote = list("chuffs", "hisses", "bellows")
	emote_hear = list("chuffs", "hisses", "bellows")
	emote_see = list("shakes its head", "thumps its tail")
	speak_chance = 1
	turns_per_move = 5

	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg", "tail")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"

	maxHealth = 100
	health = 100
	mob_size = 12
	pixel_x = -15

	canbrush = TRUE
	brush = /obj/item/reagent_containers/glass/rag

	butchering_products = list(/obj/item/stack/material/animalhide/lizard = 6)
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 4
	vehicle_version = /obj/vehicle/animal/threshbeast
	natural_armor = list(
		melee = ARMOR_MELEE_MEDIUM,
		bullet = ARMOR_BALLISTIC_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)

/mob/living/simple_animal/threshbeast/saddle
	desc = "Large herbivorous reptiles native to Moghes, the azkrazal or 'threshbeast' is commonly used as a mount, beast of burden, or convenient food source by Unathi. They are highly valued for their speed and strength, capable of running at 30-42 miles per hour at top speed. This one has been fitted with a saddle."
	icon_state = "threshbeast_s"
	icon_living = "threshbeast_s"
	icon_dead = "threshbeast_dead_s"

/mob/living/simple_animal/hostile/retaliate/hegeranzi
	name = "hegeranzi"
	desc = "A large species of herbivorous horned reptiles native to Moghes, the hegeranzi or 'warmount' is commonly used as  mount or beast of war by the Unathi. They are highly valued for their speed, aggression, and fearsome horns."
	icon = 'icons/mob/npc/moghes_64.dmi'
	icon_state = "warmount"
	icon_living = "warmount"
	icon_dead = "warmount_dead"
	speak_emote = list("roars", "snorts", "bellows")
	emote_hear = list("roars", "snorts", "bellows")
	emote_see = list("shakes its head", "stomps its hooves", "flicks its tongue")
	speak_chance = 1
	turns_per_move = 5

	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"

	maxHealth = 200
	health = 200
	mob_size = 16
	pixel_x = -14

	melee_damage_lower = 15
	melee_damage_upper = 15
	armor_penetration = 20
	attacktext = "gored"
	attack_sound = 'sound/weapons/pierce.ogg'
	canbrush = TRUE
	brush = /obj/item/reagent_containers/glass/rag

	butchering_products = list(/obj/item/stack/material/animalhide/lizard = 10)
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 6
	vehicle_version = /obj/vehicle/animal/hegeranzi
	natural_armor = list( //big tough war beast, has some more armor particularly against bullets and melee
		melee = ARMOR_MELEE_MAJOR,
		bullet = ARMOR_BALLISTIC_MEDIUM,
		laser = ARMOR_LASER_MINOR,
		bomb = ARMOR_BOMB_MINOR
	)

/mob/living/simple_animal/hostile/retaliate/hegeranzi/saddle
	name = "warmount"
	desc = "A large species of herbivorous horned reptiles native to Moghes, the hegeranzi or 'warmount' is commonly used as  mount or beast of war by the Unathi. They are highly valued for their speed, aggression, and fearsome horns. This one seems to have been fitted with a saddle."
	icon_state = "warmount_s_on"
	icon_living = "warmount_s_on"
	icon_dead = "warmount_dead_s"

/mob/living/simple_animal/aquatic/fish/moghes
	name = "orszi fish"
	desc = "A small fish native to the rivers and seas of the planet Moghes, the orzsi or 'swarm fish' is a common food source for noble and common Unathi alike."

/mob/living/simple_animal/otzek
	name = "otzek"
	desc = "The Otzek, or 'golden prey', is a species of herbivorous reptile native to the planet Moghes. They are known for their golden scales and curling horns, and were commonly hunted by both Moghresian predators and Unathi. Following the Contact War, large herds of otzek have fled into the Untouched Lands, becoming an invasive species."
	icon = 'icons/mob/npc/moghes.dmi'
	icon_state = "otzek"
	icon_living = "otzek"
	icon_dead = "otzek-dead"
	maxHealth = 80
	health = 80
	mob_size = 10
	speak_emote = list("chuffs", "hisses", "bellows")
	emote_hear = list("chuffs", "hisses", "bellows")
	emote_see = list("flicks its tongue", "shakes its head")
	speak_chance = 1
	turns_per_move = 5

	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg", "tail")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"
	canbrush = TRUE
	brush = /obj/item/reagent_containers/glass/rag
	speed = -1
	butchering_products = list(/obj/item/stack/material/animalhide/lizard = 4)
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 3

/mob/living/simple_animal/miervesh
	name = "miervesh"
	desc = "The miervesh is a small, reptile-avian creature native to Ouerea, with a forked tongue that samples the air. They are popular animals among Ouerean Unathi as they are small and sweet tempered, making them slow to respond to danger."
	icon = 'icons/mob/npc/moghes.dmi'
	icon_state = "miervesh-1"
	icon_living = "miervesh-1"
	icon_dead = "miervesh-1-dead"
	speed = -2
	maxHealth = 30
	health = 30
	speak_emote = list("chirps", "hisses", "croons")
	emote_hear = list("chirps", "hisses", "croons")
	emote_see = list("pecks at the ground","flaps its wings","flicks out its tongue")
	speak_chance = 1
	turns_per_move = 5

	organ_names = list("head", "chest", "left leg", "right leg", "left wing", "right wing")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "swats"
	attacktext = "swatted"
	flying = TRUE
	butchering_products = list(/obj/item/stack/material/animalhide = 1)
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 1
	var/chosen_icon

/mob/living/simple_animal/miervesh/Initialize()
	. = ..()
	chosen_icon = pick("miervesh-1", "miervesh-2")
	icon_state = chosen_icon
	icon_living = chosen_icon
	icon_dead = "[chosen_icon]-dead"
