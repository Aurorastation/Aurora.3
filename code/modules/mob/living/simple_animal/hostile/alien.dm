// Xenoarch aliens.
/mob/living/simple_animal/hostile/retaliate/samak
	name = "samak"
	desc = "A fast, armored predator accustomed to hiding and ambushing in cold terrain."
	faction = "samak"
	icon_state = "samak"
	icon_living = "samak"
	icon_dead = "samak_dead"
	icon = 'icons/jungle.dmi'
	move_to_delay = 2
	maxHealth = 125
	health = 125
	speed = 2
	melee_damage_lower = 5
	melee_damage_upper = 15
	attacktext = "mauled"
	cold_damage_per_tick = 0
	speak_chance = 5
	speak = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its mane","stomps")
	emote_hear = list("snuffles")
	mob_size = 10

/mob/living/simple_animal/hostile/retaliate/diyaab
	name = "diyaab"
	desc = "A small pack animal. Although omnivorous, it will hunt meat on occasion."
	faction = "diyaab"
	icon_state = "diyaab"
	icon_living = "diyaab"
	icon_dead = "diyaab_dead"
	icon = 'icons/jungle.dmi'
	move_to_delay = 1
	maxHealth = 25
	health = 25
	speed = 1
	meat_amount = 3
	melee_damage_lower = 1
	melee_damage_upper = 8
	attacktext = "gouged"
	cold_damage_per_tick = 0
	speak_chance = 5
	speak = list("Awrr?","Aowrl!","Worrl")
	emote_see = list("sniffs the air cautiously","looks around")
	emote_hear = list("snuffles")
	pass_flags = PASSTABLE
	density = 0
	mob_size = 3

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai

/mob/living/simple_animal/hostile/retaliate/shantak
	name = "shantak"
	desc = "A piglike creature with a bright iridiscent mane that sparkles as though lit by an inner light. Don't be fooled by its beauty though."
	faction = "shantak"
	icon_state = "shantak"
	icon_living = "shantak"
	icon_dead = "shantak_dead"
	icon = 'icons/jungle.dmi'
	move_to_delay = 1
	maxHealth = 75
	health = 75
	speed = 1
	melee_damage_lower = 3
	melee_damage_upper = 12
	attacktext = "gouged"
	cold_damage_per_tick = 0
	speak_chance = 5
	speak = list("Shuhn","Shrunnph?","Shunpf")
	emote_see = list("scratches the ground","shakes out it's mane","tinkles gently")
	mob_size = 5

/mob/living/simple_animal/yithian
	name = "yithian"
	desc = "A friendly creature vaguely resembling an oversized snail without a shell."
	icon_state = "yithian"
	icon_living = "yithian"
	icon_dead = "yithian_dead"
	icon = 'icons/jungle.dmi'
	pass_flags = PASSTABLE
	density = 0
	mob_size = 2
	canbrush = TRUE
	brush = /obj/item/reagent_containers/glass/rag

/mob/living/simple_animal/tindalos
	name = "tindalos"
	desc = "It looks like a large, flightless grasshopper."
	icon_state = "tindalos"
	icon_living = "tindalos"
	icon_dead = "tindalos_dead"
	icon = 'icons/jungle.dmi'
	pass_flags = PASSTABLE
	density = 0
	mob_size = 1.5
	canbrush = TRUE
	brush = /obj/item/reagent_containers/glass/rag
