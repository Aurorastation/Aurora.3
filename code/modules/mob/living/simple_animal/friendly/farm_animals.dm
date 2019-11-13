//goat
/mob/living/simple_animal/hostile/retaliate/goat
	name = "goat"
	desc = "Not known for their pleasant disposition."
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"
	speak = list("EHEHEHEHEH","eh?")
	speak_emote = list("brays")
	emote_hear = list("brays")
	emote_see = list("shakes its head", "stamps a foot", "glares around")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 6
	mob_size = 4.5//weight based on Chanthangi goats
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	faction = "goat"
	attacktext = "kicked"
	maxHealth = 40
	melee_damage_lower = 1
	melee_damage_upper = 5
	udder = null
	emote_sounds = list('sound/effects/creatures/goat.ogg')
	has_udder = TRUE

	butchering_products = list(/obj/item/stack/material/animalhide = 3)

/mob/living/simple_animal/hostile/retaliate/goat/beg(var/atom/thing, var/atom/holder)
	visible_emote("butts insistently at [holder]'s legs and reaches towards their [thing].",0)

/mob/living/simple_animal/hostile/retaliate/goat/Life()
	. = ..()
	if(.)
		if(locate(/obj/effect/plant) in loc)
			var/obj/effect/plant/SV = locate() in loc
			SV.die_off(1)

		if(locate(/obj/machinery/portable_atmospherics/hydroponics/soil/invisible) in loc)
			var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/SP = locate() in loc
			qdel(SP)

/mob/living/simple_animal/hostile/retaliate/goat/think()
	..()
	//chance to go crazy and start wacking stuff
	if(!enemies.len && prob(1))
		Retaliate()

	if(enemies.len && prob(10))
		enemies = list()
		LoseTarget()
		src.visible_message("<span class='notice'>[src] calms down.</span>")

	if(!pulledby)
		var/obj/effect/plant/food = locate(/obj/effect/plant) in oview(5,loc)
		if(food)
			var/step = get_step_to(src, food, 0)
			Move(step)

/mob/living/simple_animal/hostile/retaliate/goat/Retaliate()
	..()
	if(stat == CONSCIOUS)
		visible_message("<span class='warning'>[src] gets an evil-looking gleam in their eye.</span>")

/mob/living/simple_animal/hostile/retaliate/goat/Move()
	..()
	if(!stat)
		for(var/obj/effect/plant/SV in loc)
			SV.die_off(1)

//cow
/mob/living/simple_animal/cow
	name = "cow"
	desc = "Known for their milk, just don't tip them over."
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"
	speak = list("moo?","moo","MOOOOOO")
	speak_emote = list("moos","moos hauntingly")
	emote_hear = list("brays")
	emote_see = list("shakes its head")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	meat_amount = 40 //Cows are huge, should be worth a lot of meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"
	health = 250
	autoseek_food = 0
	beg_for_food = 0
	mob_size = 20//based on mass of holstein fresian dairy cattle, what the sprite is based on
	emote_sounds = list('sound/effects/creatures/cow.ogg')
	has_udder = TRUE
	butchering_products = list(/obj/item/stack/material/animalhide = 8)

/mob/living/simple_animal/cow/attack_hand(mob/living/carbon/M as mob)
	if(!stat && M.a_intent == I_DISARM && icon_state != icon_dead)
		M.visible_message("<span class='warning'>[M] tips over [src].</span>","<span class='notice'>You tip over [src].</span>")
		Weaken(30)
		icon_state = icon_dead
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/list/responses = list(	"[src] looks at you imploringly.",
											"[src] looks at you pleadingly",
											"[src] looks at you with a resigned expression.",
											"[src] seems resigned to its fate.")
				to_chat(M, pick(responses))
	else
		..()

/mob/living/simple_animal/chick
	name = "\improper chick"
	desc = "Adorable! They make such a racket though."
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	speak_emote = list("cheeps")
	emote_hear = list("cheeps")
	emote_see = list("pecks at the ground","flaps its tiny wings")
	speak_chance = 2
	turns_per_move = 2
	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken
	meat_amount = 1
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"
	maxHealth = 1
	var/amount_grown = 0
	pass_flags = PASSTABLE | PASSGRILLE
	holder_type = /obj/item/holder/chick
	autoseek_food = 0
	beg_for_food = 0
	density = 0
	mob_size = 0.75//just a rough estimate, the real value should be way lower
	hunger_enabled = FALSE
	emote_sounds = list('sound/effects/creatures/chick.ogg')

/mob/living/simple_animal/chick/Initialize()
	. = ..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)

/mob/living/simple_animal/chick/Life()
	. =..()
	if(!.)
		return
	if(!stat)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			new /mob/living/simple_animal/chicken(src.loc)
			qdel(src)

/mob/living/simple_animal/chick/death()
	..()
	desc = "How could you do this? You monster!"

/mob/living/simple_animal/chicken
	name = "\improper chicken"
	desc = "Hopefully the eggs are good this season."
	icon_state = "chicken"
	icon_living = "chicken"
	icon_dead = "chicken_dead"
	speak = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	speak_emote = list("clucks","croons")
	emote_hear = list("clucks")
	emote_see = list("pecks at the ground","flaps its wings viciously")
	speak_chance = 2
	turns_per_move = 3
	meat_type = /obj/item/reagent_containers/food/snacks/meat/chicken
	meat_amount = 4
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicked"
	maxHealth = 10
	var/eggsleft = 0
	var/body_color
	pass_flags = PASSTABLE
	holder_type = /obj/item/holder/chicken
	density = 0
	mob_size = 2
	hunger_enabled = FALSE

	var/static/chicken_count = 0
	emote_sounds = list('sound/effects/creatures/chicken.ogg', 'sound/effects/creatures/chicken_bwak.ogg')

/mob/living/simple_animal/chicken/Initialize()
	. = ..()
	if(!body_color)
		body_color = pick( list("brown","black","white") )
	icon_state = "chicken_[body_color]"
	icon_living = "chicken_[body_color]"
	icon_dead = "chicken_[body_color]_dead"
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	chicken_count += 1
	switch (body_color)
		if ("brown")
			holder_type = /obj/item/holder/chicken/brown
		if ("black")
			holder_type = /obj/item/holder/chicken/black
		if ("white")
			holder_type = /obj/item/holder/chicken/white

/mob/living/simple_animal/chicken/death()
	..()
	chicken_count -= 1
	desc = "Now it's ready for plucking and cooking!"

/mob/living/simple_animal/chicken/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/food/snacks/grown)) //feedin' dem chickens
		var/obj/item/reagent_containers/food/snacks/grown/G = O
		if(G.seed && G.seed.kitchen_tag == "wheat")
			if(!stat && eggsleft < 8)
				user.visible_message(
					span("notice", "\The [user] feeds \the [O] to \the [name]! It clucks happily."),
					span("notice", "You feed \the [O] to \the [name]! It clucks happily."),
					"You hear a cluck.")
				user.drop_from_inventory(O,get_turf(src))
				qdel(O)
				eggsleft += rand(1, 4)
			else
				to_chat(user, "\The [name] doesn't seem hungry!")
		else
			to_chat(user, "\The [name] doesn't seem interested in that.")
	else
		..()

/mob/living/simple_animal/chicken/Life()
	. =..()
	if(!.)
		return
	if(!stat && prob(3) && eggsleft > 0)
		visible_message("[src] [pick("lays an egg.","squats down and croons.","begins making a huge racket.","begins clucking raucously.")]")
		eggsleft--
		var/obj/item/reagent_containers/food/snacks/egg/E = new(get_turf(src))
		E.pixel_x = rand(-6,6)
		E.pixel_y = rand(-6,6)
		if(chicken_count < MAX_CHICKENS && prob(10))
			START_PROCESSING(SSprocessing, E)

/obj/item/reagent_containers/food/snacks/egg
	var/amount_grown = 0

/obj/item/reagent_containers/food/snacks/egg/process()
	if(isturf(loc))
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			visible_message("[src] hatches with a quiet cracking sound.")
			new /mob/living/simple_animal/chick(get_turf(src))
			STOP_PROCESSING(SSprocessing, src)
			qdel(src)
	else
		STOP_PROCESSING(SSprocessing, src)

// Penguins

/mob/living/simple_animal/penguin
	name = "penguin"
	desc = "A king of the icy regions."
	icon = 'icons/mob/npc/penguins.dmi'
	icon_state = "penguin"
	icon_living = "penguin"
	icon_dead = "penguin_dead"
	speak = list("Gah Gah!", "NOOT NOOT!", "NOOT!", "Noot", "noot", "Prah!", "Grah!")
	speak_emote = list("squawks", "gakkers")
	emote_hear = list("squawk!", "gakkers!", "noots.","NOOTS!")
	emote_see = list("shakes its beak", "flaps its wings","preens itself")
	faction = list("penguin")
	speak_chance = 1
	turns_per_move = 10
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	attacktext = "kicked"
	mob_size = 2

/mob/living/simple_animal/penguin/baby
	name = "baby penguin"
	desc = "Can't fly and barely waddles, yet the prince of all chicks."
	icon_state = "penguin_baby"
	icon_living = "penguin_baby"
	icon_dead = "penguin_baby_dead"
	speak = list("gah", "noot noot", "noot!", "noot", "squeee!", "noo!")
	pass_flags = PASSTABLE | PASSGRILLE
	mob_size = 0.75//just a rough estimate, the real value should be way lower

/mob/living/simple_animal/penguin/baby/death()
	..()
	desc = "Who would do such a thing? You monster!"

/mob/living/simple_animal/penguin/emperor
	name = "emperor penguin"
	desc = "Emperor of all he surveys."

