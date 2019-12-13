//animals from moghes
/mob/living/simple_animal/hostile/biglizard
	name = "plain-tyrant"
	desc = "A giant reptile-looking creature, it hails from the world of Moghes."
	icon = 'icons/mob/biglizard.dmi'
	icon_state = "biglizard"
	icon_living = "biglizard"
	icon_dead = "biglizard_dead"
	speak_emote = list("hisses","roars")
	emote_hear = list("hisses","grumbles","growls")
	emote_see = list("hisses ferociously", "stomps")
	turns_per_move = 5
	speak_chance = 5
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat
	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	maxHealth = 450
	health = 450
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	mob_size = 30
	environment_smash = 2
	attacktext = "chomped"
	attack_sound = 'sound/effects/creatures/monstergrowl.ogg'

	faction = "lizard"
	butchering_products = list(/obj/item/stack/material/animalhide/lizard = 20)

/mob/living/simple_animal/hostile/biglizard/AttackingTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(25))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\The [src] knocks down \the [L]!</span>")
