/mob/living/simple_animal/hostile/gumballmachine
	name = "abomination"
	desc = "A monstrous creature, made of twisted flesh and machinery."
	icon = 'icons/mob/mob.dmi'
	icon_state = "domingus"
	icon_living = "domingus"
	icon_dead = "domingus_dead"
	maxHealth = 20
	health = 20
	speak_emote = list("hisses","roars")
	emote_hear = list("hisses","grumbles","growls")
	emote_see = list("hisses ferociously", "stomps")
	turns_per_move = 10
	speak_chance = 5
	meat_type = /obj/item/clothing/mask/chewable/candy/gum
	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	mob_size = 30
	environment_smash = 2
	attacktext = "chomped"
	attack_sound = 'sound/misc/scarydemonnoise.ogg'

	faction = "russian"
	butchering_products = list(/obj/item/clothing/mask/chewable/candy/gum = 20)
