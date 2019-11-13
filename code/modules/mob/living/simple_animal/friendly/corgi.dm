//Corgi
/mob/living/simple_animal/corgi
	name = "corgi"
	real_name = "corgi"
	desc = "It's a corgi."
	icon_state = "corgi"
	icon_living = "corgi"
	icon_dead = "corgi_dead"
	speak = list("YAP!", "Woof!", "Bark!", "AUUUUUU!")
	speak_emote = list("barks", "woofs")
	emote_hear = list("barks", "woofs", "yaps","pants")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 10
	meat_type = /obj/item/reagent_containers/food/snacks/meat/corgi
	meat_amount = 3
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	see_in_dark = 5
	mob_size = 3.5
	max_nutrition = 80	//Dogs are insatiable eating monsters. This scales with their mob size too
	stomach_size_mult = 30
	seek_speed = 6
	possession_candidate = 1

	holder_type = /obj/item/holder/corgi

	butchering_products = list(/obj/item/stack/material/animalhide/corgi = 3)

	var/obj/item/inventory_head
	var/obj/item/inventory_back
	emote_sounds = list('sound/effects/creatures/dog_bark.ogg', 'sound/effects/creatures/dog_bark2.ogg', 'sound/effects/creatures/dog_bark3.ogg')

/mob/living/simple_animal/corgi/Initialize()
	. = ..()
	nutrition = max_nutrition * 0.3	//Ian doesn't start with a full belly so will be hungry at roundstart

//IAN! SQUEEEEEEEEE~
/mob/living/simple_animal/corgi/Ian
	name = "Ian"
	real_name = "Ian"	//Intended to hold the name without altering it.
	gender = MALE
	desc = "It's a corgi."
	//var/obj/movement_target
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"

/mob/living/simple_animal/corgi/Ian/think()
	..()

	if(!stat && !resting && !buckled)
		if(prob(1))
			visible_emote(pick("dances around","chases their tail"),0)
			INVOKE_ASYNC(src, .proc/do_dance, list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))

/mob/living/simple_animal/corgi/proc/do_dance(list/directions = list())
	for(var/i in directions)
		set_dir(i)
		sleep(1)

/mob/living/simple_animal/corgi/beg(var/atom/thing, var/atom/holder)
	visible_emote("stares at the [thing] that [holder] has with sad puppy eyes.",0)

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well you know..."

/mob/living/simple_animal/corgi/attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
	if(istype(O, /obj/item/newspaper))
		if(!stat)
			visible_message(
				"<span class='notice'>[user] baps [src] on the nose with the rolled up [O.name].</span>",
				"<span class='alert'>[user] baps you on the nose with the rolled up [O.name]!</span>"
			)
			scan_interval = max_scan_interval
			movement_target = null
			foodtarget = 0
			stop_automated_movement = 0
			turns_since_scan = 0

			INVOKE_ASYNC(src, .proc/do_dance, list(1,2,4,8,4,2,1,2))
	else
		..()

/mob/living/simple_animal/corgi/regenerate_icons()
	cut_overlays()

	if(inventory_head)
		var/head_icon_state = inventory_head.icon_state
		if(health <= 0)
			head_icon_state += "2"

		var/icon/head_icon = image('icons/mob/corgi_head.dmi',head_icon_state)
		if(head_icon)
			add_overlay(head_icon)

	if(inventory_back)
		var/back_icon_state = inventory_back.icon_state
		if(health <= 0)
			back_icon_state += "2"

		var/icon/back_icon = image('icons/mob/corgi_back.dmi',back_icon_state)
		if(back_icon)
			add_overlay(back_icon)

/mob/living/simple_animal/corgi/puppy
	name = "corgi puppy"
	real_name = "corgi"
	desc = "It's a corgi puppy."
	icon_state = "puppy"
	icon_living = "puppy"
	icon_dead = "puppy_dead"

	butchering_products = list(/obj/item/stack/material/animalhide/corgi = 1)

//pupplies cannot wear anything.
/mob/living/simple_animal/corgi/puppy/Topic(href, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(usr, "<span class='warning'>You can't fit this on [src]</span>")
		return
	..()


//LISA! SQUEEEEEEEEE~
/mob/living/simple_animal/corgi/Lisa
	name = "Lisa"
	real_name = "Lisa"
	gender = FEMALE
	desc = "It's a corgi with a cute pink bow."
	icon_state = "lisa"
	icon_living = "lisa"
	icon_dead = "lisa_dead"
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	var/puppies = 0

//Lisa already has a cute bow!
/mob/living/simple_animal/corgi/Lisa/Topic(href, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(usr, "<span class='warning'>[src] already has a cute bow!</span>")
		return
	..()

/mob/living/simple_animal/corgi/Lisa/think()
	..()
	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 15)
			turns_since_scan = 0
			var/alone = 1
			var/ian = 0
			for(var/mob/M in oviewers(7, src))
				if(istype(M, /mob/living/simple_animal/corgi/Ian))
					if(M.client)
						alone = 0
						break
					else
						ian = M
				else
					alone = 0
					break
			if(alone && ian && puppies < 4)
				if(near_camera(src) || near_camera(ian))
					return
				new /mob/living/simple_animal/corgi/puppy(loc)
				puppies++

	if (!stat && !resting && !buckled && prob(1))
		visible_emote(pick("dances around","chases her tail"),0)
		INVOKE_ASYNC(src, .proc/do_dance, list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
