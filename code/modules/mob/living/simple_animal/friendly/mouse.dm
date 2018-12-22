/mob/living/simple_animal/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small, disgusting rodent, often found being annoying, and aiding in the spread of disease."

	icon = 'icons/mob/mouse.dmi'
	icon_state = "mouse_gray"
	item_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	icon_rest = "mouse_gray_sleep"
	can_nap = 1
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	var/soft_squeaks = list('sound/effects/creatures/mouse_squeaks_1.ogg',
	'sound/effects/creatures/mouse_squeaks_2.ogg',
	'sound/effects/creatures/mouse_squeaks_3.ogg',
	'sound/effects/creatures/mouse_squeaks_4.ogg')
	var/last_softsqueak = null//Used to prevent the same soft squeak twice in a row
	var/squeals = 5//Spam control.
	var/maxSqueals = 2//SPAM PROTECTION
	var/last_squealgain = 0// #TODO-FUTURE: Remove from life() once something else is created
	var/squeakcooldown = 0
	pass_flags = PASSTABLE
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/mice
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps on"
	density = 0
	meat_amount = 2
	var/body_color //brown, gray and white, leave blank for random
	layer = MOB_LAYER
	mob_size = MOB_MINISCULE
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	universal_speak = 0
	universal_understand = 1
	holder_type = /obj/item/weapon/holder/mouse
	digest_factor = 0.05
	min_scan_interval = 2
	max_scan_interval = 20
	seek_speed = 1

	can_pull_size = 1
	can_pull_mobs = MOB_PULL_NONE

	var/decompose_time = 18000

	kitchen_tag = "rodent"

/mob/living/simple_animal/mouse/Life()
	if(..())

		if(client)
			walk_to(src,0)

			//Player-animals don't do random speech normally, so this is here
			//Player-controlled mice will still squeak, but less often than NPC mice
			if (stat == CONSCIOUS && prob(speak_chance*0.05))
				squeak_soft(0)

			if(is_ventcrawling == 0)
				sight = initial(sight) // Returns mouse sight to normal when they leave a vent

			if (squeals < maxSqueals)
				var/diff = world.time - last_squealgain
				if (diff > 600)
					squeals++
					last_squealgain = world.time

	else
		if ((world.time - timeofdeath) > decompose_time)
			dust()

/mob/living/simple_animal/mouse/Destroy()
	SSmob.all_mice -= src

	return ..()

//Pixel offsetting as they scamper around
/mob/living/simple_animal/mouse/Move()
	if(..())
		if (prob(50))
			var/new_pixelx = pixel_x
			new_pixelx += rand(-2,2)
			new_pixelx = Clamp(new_pixelx, -10, 10)
			animate(src, pixel_x = new_pixelx, time = 0.5)
		else
			var/new_pixely = pixel_y
			new_pixely += rand(-2,2)
			new_pixely = Clamp(new_pixely, -4, 14)
			animate(src, pixel_y = new_pixely, time = 0.5)

/mob/living/simple_animal/mouse/Initialize()
	. = ..()

	nutrition = rand(max_nutrition*0.25, max_nutrition*0.75)
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(name == initial(name))
		name = "[name] ([rand(1, 1000)])"
	real_name = name

	if(!body_color)
		body_color = pick( list("brown","gray","white") )
	icon_state = "mouse_[body_color]"
	item_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_rest = "mouse_[body_color]_sleep"
	icon_dead = "mouse_[body_color]_dead"
	if (body_color == "brown")
		holder_type = /obj/item/weapon/holder/mouse/brown
	if (body_color == "gray")
		holder_type = /obj/item/weapon/holder/mouse/gray
	if (body_color == "white")
		holder_type = /obj/item/weapon/holder/mouse/white

	//verbs += /mob/living/simple_animal/mouse/proc/squeak
	//verbs += /mob/living/simple_animal/mouse/proc/squeak_soft
	//verbs += /mob/living/simple_animal/mouse/proc/squeak_loud(1)

	SSmob.all_mice += src

/mob/living/simple_animal/mouse/speak_audio()
	squeak_soft(0)

/mob/living/simple_animal/mouse/beg(var/atom/thing, var/atom/holder)
	squeak_soft(0)
	visible_emote("squeaks timidly, sniffs the air and gazes longingly up at \the [thing.name].",0)

/mob/living/simple_animal/mouse/attack_hand(mob/living/carbon/human/M as mob)
	if (src.stat == DEAD)//If the mouse is dead, we don't pet it, we just pickup the corpse on click
		get_scooped(M, usr)
		return
	else
		..()

/mob/living/simple_animal/mouse/proc/splat()
	src.health = 0
	src.death()
	src.icon_dead = "mouse_[body_color]_splat"
	src.icon_state = "mouse_[body_color]_splat"
	if(client)
		client.time_died_as_mouse = world.time

//Plays a sound.
//This is triggered when a mob steps on an NPC mouse, or manually by a playermouse
/mob/living/simple_animal/mouse/proc/squeak(var/manual = 1)
	if (stat == CONSCIOUS)
		if (squeakcooldown > world.time) return
		squeakcooldown = world.time + 2 SECONDS
		playsound(src, 'sound/effects/mousesqueek.ogg', 70, 1)
		if (manual)
			log_say("[key_name(src)] squeaks! ",ckey=key_name(src))


//Plays a random selection of four sounds, at a low volume
//This is triggered randomly periodically by any mouse, or manually
/mob/living/simple_animal/mouse/proc/squeak_soft(var/manual = 1)
	if (stat != DEAD) //Soft squeaks are allowed while sleeping
		var/list/new_squeaks = last_softsqueak ? soft_squeaks - last_softsqueak : soft_squeaks
		var/sound = pick(new_squeaks)

		last_softsqueak = sound
		if (squeakcooldown > world.time) return

		squeakcooldown = world.time + 2 SECONDS
		playsound(src, sound, 5, 1, -4.6)

		if (manual)
			log_say("[key_name(src)] squeaks softly! ",ckey=key_name(src))


//Plays a loud sound
//Triggered manually, when a mouse dies, or rarely when its stepped on
/mob/living/simple_animal/mouse/proc/squeak_loud(var/manual = 0)
	if (stat == CONSCIOUS)
		if (squeakcooldown > world.time) return
		squeakcooldown = world.time + 4 SECONDS
	
		if (squeals > 0 || !manual)
			playsound(src, 'sound/effects/creatures/mouse_squeak_loud.ogg', 50, 1)
			squeals --
			log_say("[key_name(src)] squeals! ",ckey=key_name(src))
		else
			src << "<span class='warning'>Your hoarse mousey throat can't squeal just now, stop and take a breath!</span>"


//Wrapper verbs for the squeak functions
/mob/living/simple_animal/mouse/verb/squeak_loud_verb()
	set name = "Squeal!"
	set category = "Abilities"

	if (usr.client.handle_spam_prevention(null, MUTE_IC))
		return
	else if (usr.client.prefs.muted & MUTE_IC)
		usr << "<span class='danger'>You are muted from IC emotes.</span>"
		return

	squeak_loud(1)

/mob/living/simple_animal/mouse/verb/squeak_soft_verb()
	set name = "Soft Squeaking"
	set category = "Abilities"

	if (usr.client.handle_spam_prevention(null, MUTE_IC))
		return
	else if (usr.client.prefs.muted & MUTE_IC)
		usr << "<span class='danger'>You are muted from IC emotes.</span>"
		return

	squeak_soft(1)

/mob/living/simple_animal/mouse/verb/squeak_verb()
	set name = "Squeak"
	set category = "Abilities"

	if (usr.client.handle_spam_prevention(null, MUTE_IC))
		return
	else if (usr.client.prefs.muted & MUTE_IC)
		usr << "<span class='danger'>You are muted from IC emotes.</span>"
		return

	squeak(1)


/mob/living/simple_animal/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			M << "<span class='notice'>\icon[src] Squeek!</span>"
			poke(1) //Wake up if stepped on
			if (prob(95))
				squeak(0)
			else
				squeak_loud(0)//You trod on its tail

	if(!health)
		return

	if(istype(AM,/mob/living/simple_animal/mouse/king))
		var/mob/living/simple_animal/mouse/king/K = AM
		if(!K.health)
			return

		src.visible_message("<span class='warning'>[src] joins the [K.swarm_name] of \the [K]</span>", \
							"<span class='notice'>We join our brethren in \the [K.swarm_name]. Long live \the [K].</span>")
		K.absorb(src)
	..()

/mob/living/simple_animal/mouse/death()
	layer = MOB_LAYER
	if (stat != DEAD && (ckey || prob(50)))
		squeak_loud(0)//deathgasp

	if(client)
		client.time_died_as_mouse = world.time

	SSmob.all_mice -= src

	..()

/mob/living/simple_animal/mouse/dust()
	..(anim = "dust_[body_color]", remains = /obj/effect/decal/remains/mouse, iconfile = 'icons/mob/mouse.dmi')


/*
 * Mouse types
 */

/mob/living/simple_animal/mouse/white
	body_color = "white"
	icon_state = "mouse_white"
	icon_rest = "mouse_white_sleep"
	holder_type = /obj/item/weapon/holder/mouse/white

/mob/living/simple_animal/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"
	icon_rest = "mouse_gray_sleep"
	holder_type = /obj/item/weapon/holder/mouse/gray

/mob/living/simple_animal/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"
	icon_rest = "mouse_brown_sleep"
	holder_type = /obj/item/weapon/holder/mouse/brown

/mob/living/simple_animal/mouse/brown/Tom
	name = "Tom"
	real_name = "Tom"
	desc = "Jerry the cat is not amused."

/mob/living/simple_animal/mouse/brown/Tom/Initialize()
	. = ..()
	// Change my name back, don't want to be named Tom (666)
	name = initial(name)
	real_name = name

/mob/living/simple_animal/mouse/cannot_use_vents()
	return
