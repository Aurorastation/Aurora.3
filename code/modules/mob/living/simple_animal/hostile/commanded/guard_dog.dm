/mob/living/simple_animal/hostile/commanded/dog
	name = "guard dog"
	short_name = "dog"
	desc = "A dog trained to listen and obey its owner commands, this one is a german shepherd."

	icon = 'icons/mob/npc/pets.dmi'
	icon_state = "german"
	icon_living = "german"
	icon_dead = "german_dead"

	health = 75
	maxHealth = 75

	stop_automated_movement_when_pulled = 1 //so people can drag the dog around
	density = 1

	speak_chance = 1
	turns_per_move = 7

	speak = list("Woof!", "Bark!", "AUUUUUU!","AwooOOOoo!")
	speak_emote = list("barks", "woofs")
	emote_hear = list("barks", "woofs")
	sad_emote = list("whines")
	emote_sounds = list('sound/effects/creatures/dog_bark.ogg', 'sound/effects/creatures/dog_bark2.ogg', 'sound/effects/creatures/dog_bark3.ogg')

	attacktext = "bitten"
	attack_sound = 'sound/effects/creatures/dog_bark.ogg'
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15
	resist_mod = 2

	mob_size = 5

	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")
	response_help = "pets"
	response_harm = "hits"
	response_disarm = "pushes"

	hunger_enabled = 1 //so you can feed your dog or something
	max_nutrition = 120
	canbrush = TRUE

	known_commands = list("stay", "stop", "attack", "follow")

	destroy_surroundings = FALSE
	attack_emote = "growls at"

	butchering_products = list(/obj/item/stack/material/animalhide = 2)

/mob/living/simple_animal/hostile/commanded/dog/verb/befriend()
	set name = "Befriend Dog"
	set category = "IC.Critters"
	set src in view(1)

	if(!master)
		var/mob/living/carbon/human/H = usr
		if(istype(H))
			master = usr
			audible_emote("[pick(emote_hear)].",0)
			playsound(src,'sound/effects/creatures/dog_bark.ogg',100, 1)
			. = 1
	else if(usr == master)
		. = 1 //already friends, but show success anyways

	else
		to_chat(usr, SPAN_NOTICE("[src] ignores you."))

	return

/mob/living/simple_animal/hostile/commanded/dog/amaskan
	desc = "A dog trained to listen and obey its owner commands, this one is a Tamaskan."

	icon_state = "amaskan"
	icon_living = "amaskan"
	icon_dead = "amaskan_dead"

/mob/living/simple_animal/hostile/commanded/dog/columbo
	name = "Lt. Columbo"
	short_name = "Columbo"
	desc = "A dog trained to listen and obey its owner's commands. This one looks about three days from retirement."
	named = TRUE
	gender = MALE

	health = 125
	maxHealth = 125

	icon_state = "columbo"
	icon_living = "columbo"
	icon_dead = "columbo_dead"

/mob/living/simple_animal/hostile/commanded/dog/pug
	name = "pug"
	desc = "A small dog with a wrinkly muzzle."

	icon_state = "pug"
	icon_living = "pug"
	icon_dead = "pug_dead"

	health = 25
	maxHealth = 25

	density = 0

	mob_size = 3.2
	max_nutrition = 80

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5

	butchering_products = list(/obj/item/stack/material/animalhide = 2)

/mob/living/simple_animal/hostile/commanded/dog/bullterrier
	name = "bull terrier"
	desc = "An odd looking dog with a head in the shape of an egg."

	icon_state = "bullterrier"
	icon_living = "bullterrier"
	icon_dead = "bullterrier_dead"

/mob/living/simple_animal/hostile/commanded/dog/harron
	name = "domesticated ha'rron"
	short_name = "ha'rron"

	desc = "A carnivorous adhomian animal. Some domesticated breeds make excellent hunting companions."

	icon = 'icons/mob/npc/adhomai.dmi'
	icon_state = "harron"
	icon_living = "harron"
	icon_dead = "harron_dead"

	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 5

/mob/living/simple_animal/hostile/commanded/dog/harron/cybernetic
	name = "cybernetic ha'rron"
	desc = "A heavily augmented ha'rron. It is commonly used by the People's Strategic Intelligence Service."

	icon_state = "cyber_harron"
	icon_living = "cyber_harron"
	icon_dead = "cyber_harron_dead"

	melee_damage_lower = 20
	melee_damage_upper = 20
	resist_mod = 4

	health = 100
	maxHealth = 100

	meat_amount = 3

/mob/living/simple_animal/hostile/commanded/dog/harron/cybernetic/emp_act(severity)
	. = ..()

	switch(severity)
		if(EMP_HEAVY)
			adjustFireLoss(rand(10, 15))
		if(EMP_LIGHT)
			adjustFireLoss(rand(5, 10))
