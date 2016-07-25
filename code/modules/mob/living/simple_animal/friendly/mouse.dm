/mob/living/simple_animal/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small rodent."
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	var/soft_squeaks = list('sound/effects/creatures/mouse_squeaks_1.ogg',
	'sound/effects/creatures/mouse_squeaks_2.ogg',
	'sound/effects/creatures/mouse_squeaks_3.ogg',
	'sound/effects/creatures/mouse_squeaks_4.ogg')
	var/last_softsqueak = null//Used to prevent the same soft squeak twice in a row

	pass_flags = PASSTABLE
	small = 1
	speak_chance = 4
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	density = 0
	var/body_color //brown, gray and white, leave blank for random
	layer = MOB_LAYER
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	universal_speak = 0
	universal_understand = 1
	mob_size = 1
	holder_type = /obj/item/weapon/holder/mouse

/mob/living/simple_animal/mouse/Life()
	..()
	//Player-animals don't do random speech normally, so this is here
		//Player-controlled mice will still squeak, but less often than NPC mice
	if(client && stat == CONSCIOUS && prob(speak_chance*0.4))
		squeak_soft()

	if(!ckey && stat == CONSCIOUS && prob(0.5))
		stat = UNCONSCIOUS
		icon_state = "mouse_[body_color]_sleep"
		wander = 0
		speak_chance = 0
		//snuffles
	else if(stat == UNCONSCIOUS)
		if(ckey || prob(1))
			stat = CONSCIOUS
			icon_state = "mouse_[body_color]"
			wander = 1
			speak_chance = initial(speak_chance)
		else if(prob(5))
			audible_emote("snuffles.")

/mob/living/simple_animal/mouse/New()
	..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
	real_name = name

	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	icon_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"
	desc = "It's a small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."
	if (body_color == "brown")
		holder_type = /obj/item/weapon/holder/mouse/brown
	if (body_color == "gray")
		holder_type = /obj/item/weapon/holder/mouse/gray
	if (body_color == "white")
		holder_type = /obj/item/weapon/holder/mouse/white

	verbs += /mob/living/simple_animal/mouse/proc/squeak
	verbs += /mob/living/simple_animal/mouse/proc/squeak_soft
	verbs += /mob/living/simple_animal/mouse/proc/squeak_loud

/mob/living/simple_animal/mouse/speak_audio()
	squeak_soft()

/mob/living/simple_animal/mouse/attack_hand(mob/living/carbon/human/M as mob)
	if (src.stat == DEAD)//If the mouse is dead, we don't pet it, we just pickup the corpse on click
		get_scooped(M)
		return
	else
		..()

/mob/living/simple_animal/mouse/proc/splat()
	src.health = 0
	src.stat = DEAD
	src.icon_dead = "mouse_[body_color]_splat"
	src.icon_state = "mouse_[body_color]_splat"
	layer = MOB_LAYER
	if(client)
		client.time_died_as_mouse = world.time

/mob/living/simple_animal/mouse/start_pulling(var/atom/movable/AM)//Prevents mouse from pulling things
	src << "<span class='warning'>You are too small to pull anything.</span>"
	return



//Plays a sound.
//This is triggered when a mob steps on an NPC mouse, or manually by a playermouse
/mob/living/simple_animal/mouse/proc/squeak()
	set name = "Squeak"
	set category = "Abilities"
	playsound(src, 'sound/effects/mousesqueek.ogg', 90, 1)




//Plays a random selection of four sounds, at a low volume
//This is triggered randomly periodically by any mouse, or manually
/mob/living/simple_animal/mouse/proc/squeak_soft()
	set name = "Soft Squeaking"
	set category = "Abilities"

	var/list/new_squeaks = last_softsqueak ? soft_squeaks - last_softsqueak : soft_squeaks
	var/sound = pick(new_squeaks)

	last_softsqueak = sound
	playsound(src, sound, 15, 1)



//Plays a loud sound
//Triggered manually, when a mouse dies, or rarely when its stepped on
/mob/living/simple_animal/mouse/proc/squeak_loud()
	set name = "Squeal!"
	set category = "Abilities"
	playsound(src, 'sound/effects/creatures/mouse_squeak_loud.ogg', 100, 1)

/mob/living/simple_animal/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			M << "\blue \icon[src] Squeek!"
			if (prob(95))
				squeak()
			else
				squeak_loud()//You trod on its tail
	..()

/mob/living/simple_animal/mouse/MouseDrop(atom/over_object)

	var/mob/living/carbon/H = over_object
	if(!istype(H) || !Adjacent(H)) return ..()

	if(H.a_intent == "help")
		get_scooped(H)
		return
	else
		return ..()

/mob/living/simple_animal/mouse/death()
	layer = MOB_LAYER
	squeak_loud()//deathgasp

	if(client)
		client.time_died_as_mouse = world.time
	.=..()

/mob/living/simple_animal/mouse/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = !resting
	icon_state = resting ? "mouse_[body_color]_sleep" : "mouse_[body_color]"
	src << "\blue You are now [resting ? "resting" : "getting up"]"

	canmove = !resting


/*
 * Mouse types
 */

/mob/living/simple_animal/mouse/white
	body_color = "white"
	icon_state = "mouse_white"
	holder_type = /obj/item/weapon/holder/mouse/white

/mob/living/simple_animal/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"
	holder_type = /obj/item/weapon/holder/mouse/gray

/mob/living/simple_animal/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"
	holder_type = /obj/item/weapon/holder/mouse/brown

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."

/mob/living/simple_animal/mouse/brown/Tom/New()
	..()
	// Change my name back, don't want to be named Tom (666)
	name = initial(name)

/mob/living/simple_animal/mouse/cannot_use_vents()
	return
