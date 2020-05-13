//Cat
/mob/living/simple_animal/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	icon = 'icons/mob/npc/pets.dmi'
	icon_state = "cat2"
	item_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	icon_rest = "cat2_rest"
	can_nap = 1
	speak = list("Meow!","Esp!","Purr!","HSSSSS")
	speak_emote = list("purrs", "meows")
	emote_hear = list("meows","mews")
	emote_see = list("shakes their head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	var/mob/flee_target
	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	holder_type = /obj/item/holder/cat
	mob_size = 2.5
	scan_range = 3//less aggressive about stealing food
	metabolic_factor = 0.75
	max_nutrition = 60
	density = 0
	var/mob/living/simple_animal/rat/rattarget = null
	seek_speed = 5
	pass_flags = PASSTABLE
	canbrush = TRUE
	possession_candidate = 1
	emote_sounds = list('sound/effects/creatures/cat_meow.ogg', 'sound/effects/creatures/cat_meow2.ogg')
	butchering_products = list(/obj/item/stack/material/animalhide/cat = 2)

/mob/living/simple_animal/cat/think()
	//MICE!
	..()
	if (!stat)
		for(var/mob/living/simple_animal/rat/snack in oview(src,7))
			if(snack.stat != DEAD && prob(65))//The probability allows her to not get stuck target the first rat, reducing exploits
				rattarget = snack
				movement_target = snack
				if(prob(15))
					audible_emote(pick("hisses and spits!","mrowls fiercely!","eyes [snack] hungrily."))

				addtimer(CALLBACK(src, .proc/attack_mice), 2)
				break


		if(!buckled)
			if (turns_since_move > 5 || (flee_target || rattarget))
				walk_to(src,0)
				turns_since_move = 0

				if (flee_target) //fleeing takes precendence
					handle_flee_target()
				else
					handle_movement_target()

		if (!movement_target)
			walk_to(src,0)

		if(prob(2)) //spooky
			var/mob/abstract/observer/spook = locate() in range(src,5)
			if(spook)
				var/turf/T = spook.loc
				var/list/visible = list()
				for(var/obj/O in T.contents)
					if(!O.invisibility && O.name)
						visible += O
				if(visible.len)
					var/atom/A = pick(visible)
					visible_emote("suddenly stops and stares at something unseen[istype(A) ? " near [A]":""].",0)

/mob/living/simple_animal/cat/proc/attack_mice()
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/rat/M in oview(src,1))
				if(M.stat != DEAD)
					M.splat()
					visible_emote(pick("bites \the [M]!","toys with \the [M].","chomps on \the [M]!"),0)
					movement_target = null
					stop_automated_movement = 0
					if (prob(75))
						break//usually only kill one rat per proc

/mob/living/simple_animal/cat/Released()
	//A thrown cat will immediately attack mice near where it lands
	handle_movement_target()
	addtimer(CALLBACK(src, .proc/attack_mice), 3)
	..()

/mob/living/simple_animal/cat/death()
	.=..()
	stat = DEAD


/mob/living/simple_animal/cat/proc/handle_flee_target()
	//see if we should stop fleeing
	if (flee_target && !(flee_target.loc in view(src)))
		flee_target = null
		stop_automated_movement = 0

	if (flee_target)
		if(prob(25)) say("HSSSSS")
		stop_automated_movement = 1
		walk_away(src, flee_target, 7, 2)

/mob/living/simple_animal/cat/proc/set_flee_target(atom/A)
	if(A)
		flee_target = A
		turns_since_move = 5

/mob/living/simple_animal/cat/attackby(var/obj/item/O, var/mob/user)
	. = ..()
	if(O.force)
		set_flee_target(user? user : src.loc)

/mob/living/simple_animal/cat/attack_hand(mob/living/carbon/human/M as mob)
	. = ..()
	if(M.a_intent == I_HURT)
		set_flee_target(M)

/mob/living/simple_animal/cat/ex_act(var/severity = 2.0)
	. = ..()
	set_flee_target(src.loc)

/mob/living/simple_animal/cat/bullet_act(var/obj/item/projectile/proj)
	. = ..()
	set_flee_target(proj.firer? proj.firer : src.loc)

/mob/living/simple_animal/cat/hitby(atom/movable/AM)
	. = ..()
	set_flee_target(AM.thrower? AM.thrower : src.loc)

/mob/living/simple_animal/cat/fall_impact()
	src.visible_message("<span class='notice'>\The [src] lands softly on \the [loc]!</span>")
	return FALSE

//Basic friend AI
/mob/living/simple_animal/cat/fluff
	var/mob/living/carbon/human/friend
	var/befriend_job = null

/mob/living/simple_animal/cat/fluff/handle_movement_target()
	if (!QDELETED(friend))
		var/follow_dist = 5
		if (friend.stat >= DEAD || friend.health <= config.health_threshold_softcrit) //danger
			follow_dist = 1
		else if (friend.stat || friend.health <= 50) //danger or just sleeping
			follow_dist = 2
		var/near_dist = max(follow_dist - 2, 1)
		var/current_dist = get_dist(src, friend)

		if (movement_target != friend)
			if (current_dist > follow_dist && !istype(movement_target, /mob/living/simple_animal/rat) && (friend in oview(src)))
				//stop existing movement
				walk_to(src,0)
				turns_since_scan = 0

				//walk to friend
				stop_automated_movement = 1
				movement_target = friend
				walk_to(src, movement_target, near_dist, DS2TICKS(seek_move_delay))

		//already following and close enough, stop
		else if (current_dist <= near_dist)
			walk_to(src,0)
			movement_target = null
			stop_automated_movement = 0
			if (prob(10))
				say("Meow!")

	if (!friend || movement_target != friend)
		..()

/mob/living/simple_animal/cat/fluff/think()
	..()
	if (stat || QDELETED(friend))
		return
	if (get_dist(src, friend) <= 1)
		if (friend.stat >= DEAD || friend.health <= config.health_threshold_softcrit)
			if (prob((friend.stat < DEAD)? 50 : 15))
				var/verb = pick("meows", "mews", "mrowls")
				audible_emote(pick("[verb] in distress.", "[verb] anxiously."))
		else
			if (prob(5))
				visible_emote(pick("nuzzles [friend].",
								   "brushes against [friend].",
								   "rubs against [friend].",
								   "purrs."),0)
	else if (friend.health <= 50)
		if (prob(10))
			var/verb = pick("meows", "mews", "mrowls")
			audible_emote("[verb] anxiously.")

/mob/living/simple_animal/cat/fluff/verb/friend()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	if(friend && usr == friend)
		set_dir(get_dir(src, friend))
		say("Meow!")
		return

	if (!(ishuman(usr) && befriend_job && usr.job == befriend_job))
		to_chat(usr, "<span class='notice'>[src] ignores you.</span>")
		return

	friend = usr

	set_dir(get_dir(src, friend))
	say("Meow!")

//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_animal/cat/fluff/Runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	gender = FEMALE
	icon_state = "cat"
	item_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	icon_rest = "cat_rest"
	can_nap = 1
	befriend_job = "Chief Medical Officer"
	holder_type = /obj/item/holder/cat/black

/mob/living/simple_animal/cat/fluff/Runtime/death()
	.=..()
	desc = "Oh no, Runtime is dead! What kind of monster would do this?"

/mob/living/simple_animal/cat/kitten
	name = "kitten"
	desc = "D'aaawwww"
	icon_state = "kitten"
	item_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	can_nap = 0 //No resting sprite
	gender = NEUTER
	holder_type = /obj/item/holder/cat/kitten

/mob/living/simple_animal/cat/kitten/death()
	.=..()
	desc = "It's a dead kitten! What kind of monster would do this?"

/mob/living/simple_animal/cat/fluff/bones
	name = "Bones"
	desc = "That's Bones the cat. He's a laid back, black cat. Meow."
	gender = MALE
	icon_state = "cat3"
	item_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"
	icon_rest = "cat3_rest"
	can_nap = 1
	var/friend_name = "Erstatz Vryroxes"
	holder_type = /obj/item/holder/cat/black

/mob/living/simple_animal/cat/fluff/bones/death()
	.=..()
	desc = "Bones is dead"

/mob/living/simple_animal/cat/kitten/Initialize()
	. = ..()
	gender = pick(MALE, FEMALE)

/mob/living/simple_animal/cat/penny
	name = "Penny"
	desc = "An important cat, straight from Central Command."
	icon_state = "penny"
	item_state = "penny"
	icon_living = "penny"
	icon_dead = "penny_dead"
	icon_rest = "penny_rest"
	holder_type = /obj/item/holder/cat/penny
