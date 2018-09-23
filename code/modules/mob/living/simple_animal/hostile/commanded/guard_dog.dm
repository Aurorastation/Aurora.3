/mob/living/simple_animal/hostile/commanded/dog
	name = "guard dog"
	short_name = "dog"
	desc = "A dog trained to listen and obey its owner commands, this one is a german shepherd."

	icon = 'icons/mob/dog.dmi'
	icon_state = "german"
	icon_living = "german"
	icon_dead = "german_dead"

	health = 75
	maxHealth = 75

	stop_automated_movement_when_pulled = 1 //so people can drag the dog around
	density = 1

	speak_chance = 1
	turns_per_move = 7
	see_in_dark = 6

	speak = list("Woof!", "Bark!", "AUUUUUU!","AwooOOOoo!")
	speak_emote = list("barks", "woofs")
	emote_hear = list("barks", "woofs")
	sad_emote = list("whines")

	attacktext = "bitten"
	attack_sound = 'sound/misc/dog_bark.ogg'
	harm_intent_damage = 5
	melee_damage_lower = 15
	melee_damage_upper = 15

	mob_size = 6

	response_help = "pets"
	response_harm = "hits"
	response_disarm = "pushes"

	hunger_enabled = 1 //so you can feed your dog or something
	autoseek_food = 0
	beg_for_food = 0

	known_commands = list("stay", "stop", "attack", "follow")

	var/name_changed = 0

	destroy_surroundings = FALSE

/mob/living/simple_animal/hostile/commanded/dog/verb/befriend()
	set name = "Befriend Dog"
	set category = "IC"
	set src in view(1)

	if(!master)
		var/mob/living/carbon/human/H = usr
		if(istype(H))
			master = usr
			audible_emote("[pick(emote_hear)].",0)
			playsound(src,'sound/misc/dog_bark.ogg',100, 1)
			. = 1
	else if(usr == master)
		. = 1 //already friends, but show success anyways

	else
		usr << "<span class='notice'>[src] ignores you.</span>"

	return

/mob/living/simple_animal/hostile/commanded/dog/verb/change_name()
	set name = "Name Dog"
	set category = "IC"
	set src in view(1)

	var/mob/M = usr
	if(!M.mind)	return 0

	if(!name_changed)

		var/input = sanitizeSafe(input("What do you want to name the dog?", ,""), MAX_NAME_LEN)
		var/short_input = sanitizeSafe(input("What nickname do you want to give the dog ?", , ""), MAX_NAME_LEN)

		if(src && input && !M.stat && in_range(M,src))
			name = input
			real_name = input
			if(short_input != "")
				short_name = short_input
			name_changed = 1
			return 1

	else
		usr << "<span class='notice'>[src] already has a name!</span>"
		return

/mob/living/simple_animal/hostile/commanded/dog/amaskan
	desc = "A dog trained to listen and obey its owner commands, this one is a Tamaskan."

	icon_state = "amaskan"
	icon_living = "amaskan"
	icon_dead = "amaskan_dead"


/mob/living/simple_animal/hostile/commanded/dog/columbo
	name = "Lt. Columbo"
	short_name = "Columbo"
	desc = "A dog trained to listen and obey its owner commands. This one looks about three days from retirement."

	melee_damage_lower = 5
	melee_damage_upper = 10

	name_changed = 1

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

	mob_size = 5

	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5





/mob/living/simple_animal/hostile/commanded/dog/iangang
	name = "Hood Rat Ian"
	short_name = "hoodian"
	desc = "Ian's Distant Cousin, however unlike Ian he only likes white girls and guns and money."
	icon_state = "iangang"
	icon_living = "iangang"
	icon_dead = "iangang_dead"
	melee_damage_lower=6
	melee_damage_upper=14
	name_changed = 1
	known_commands = list("stay", "stop", "attack", "follow")
	attacktext = "licked"
	attack_sound = 'sound/misc/dog_bark.ogg'

/mob/living/simple_animal/hostile/commanded/dog/iangang/listen(var/mob/speaker, var/text)
    for(var/command in known_commands)
        if(findtext(text,command))
            switch(command)
                if("stay")
                    if(stay_command(speaker,text)) //find a valid command? Stop. Dont try and find more.
                        break
                if("stop")
                    if(stop_command(speaker,text))
                        break
                if("lick")
                    if(attack_command(speaker,text))
                        break
                if("follow")
                    if(follow_command(speaker,text))
                        break
                else
                    misc_command(speaker,text) //for specific commands

    return 1