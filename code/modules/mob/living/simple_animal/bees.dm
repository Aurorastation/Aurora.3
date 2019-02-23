//Bees are spawned from an apiary, and will slowly die if it is destroyed.

/mob/living/simple_animal/bee
	name = "bees"
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "bees1"
	icon_dead = "bees1"
	mob_size = 0.5
	unsuitable_atoms_damage = 2.5
	maxHealth = 20
	density = 0
	var/strength = 1
	var/feral = 0
	var/mut = 0
	var/toxic = 0
	var/turf/target_turf
	var/mob/target_mob
	var/obj/machinery/beehive/parent
	var/loner = 0
	pass_flags = PASSTABLE
	turns_per_move = 6
	var/obj/machinery/portable_atmospherics/hydroponics/my_hydrotray

/mob/living/simple_animal/bee/Initialize(mapload, var/obj/machinery/beehive/new_parent)
	. = ..()
	parent = new_parent

/mob/living/simple_animal/bee/Destroy()
	if(parent)
		parent.owned_bee_swarms.Remove(src)
	my_hydrotray = null
	parent = null
	target_turf = null
	target_mob = null
	return ..()


//Special death behaviour. When bees accumulate enough damage to 'die', they don't outright die.  Thus no call to parent
//Instead the swarm strength (ie, size, or quantity of bees) drops and their health is refilled
//Repeat until strength hits zero. only THEN do they die, and they qdel and leave no corpse in doing so
//Because we don't have sprites for a carpet made of bee corpses.
/mob/living/simple_animal/bee/death()
	if (!QDELING(src))
		strength -= 1
		if (strength <= 0)
			if (prob(35))//probability to reduce spam
				src.visible_message("<span class='warning'>The bee swarm completely dissipates.</span>")
			qdel(src)
			return
		else
			health = maxHealth
			if (prob(35))//probability to reduce spam
				src.visible_message("<span class='warning'>The bee swarm starts to thin out a little.</span>")

		update_icons()
	else
		..()

/mob/living/simple_animal/bee/Life()
	if(!loner && strength && !parent && prob(7-strength))
		strength -= 1

	if(strength <= 0)
		death()
	else
		update_icons()

	..()


/mob/living/simple_animal/bee/think()
	..()
	if (stat != CONSCIOUS)
		return

	//if we're strong enough, sting some people
	var/mob/living/carbon/human/M = target_mob
	var/sting_prob = 40 // Bees will always try to sting.
	var/prob_mult = 1
	if(M && M in view(src,1)) // Can I see my target?
		var/obj/item/clothing/worn_suit = M.wear_suit
		var/obj/item/clothing/worn_helmet = M.head
		if(worn_suit) // Are you wearing clothes?
			if ((worn_suit.flags & THICKMATERIAL))
				prob_mult -= 0.7
			else
				prob_mult -= 0.01 * (min(LAZYACCESS(worn_suit.armor, "bio"), 70)) // Is it sealed? I can't get to 70% of your body.
		if(worn_helmet)
			if ((worn_helmet.flags & THICKMATERIAL))
				prob_mult -= 0.3
			else
				prob_mult -= 0.01 *(min(LAZYACCESS(worn_helmet.armor, "bio"), 30))// Is your helmet sealed? I can't get to 30% of your body.
		if( prob(sting_prob*prob_mult) && (M.stat == CONSCIOUS || (M.stat == UNCONSCIOUS && prob(25*prob_mult))) ) // Try to sting! If you're not moving, think about stinging.
			M.apply_damage(min(strength*0.85,2)+mut, BURN, sharp=1) // Stinging. The more mutated I am, the harder I sting.
			M.apply_damage(max(strength*0.2,(round(feral/10,1)*(max((round(strength/20,1)),1)))+toxic), TOX) // Bee venom based on how angry I am and how many there are of me!
			to_chat(M, "<span class='warning'>You have been stung!</span>")
			M.flash_pain()



	//calm down a little bit
	if(feral > 0 && !target_mob)
		if(prob(feral * 20))
			feral -= 1
	else
		//if feral is less than 0, we're becalmed by smoke or steam
		if(feral < 0)
			feral += 1

		if(target_mob)
			target_mob = null
			target_turf = null
		if(strength > 5)
			//calm down and spread out a little
			var/mob/living/simple_animal/bee/B = new(get_turf(src))
			B.strength = rand(1,5)
			src.strength -= B.strength
			update_icons()
			B.update_icons()
			if(src.parent)
				B.parent = src.parent
				src.parent.owned_bee_swarms.Add(B)

	//make some noise
	if(prob(3))
		src.visible_message("<span class='notice'>[pick("Buzzzz.","Hmmmmm.","Bzzz.")]</span>")
		playsound(src.loc, pick('sound/effects/Buzz1.ogg','sound/effects/Buzz2.ogg'), 15, 1,-4)

	if (feral && isturf(loc))
		//smoke, water and steam calms us down
		var/static/list/calmers = typecacheof(list(
			/obj/effect/effect/smoke,
			/obj/effect/effect/water,
			/obj/effect/effect/foam,
			/obj/effect/effect/steam,
			/obj/effect/mist
		))

		if(range_in_typecache(src, 2, calmers))
			if(feral > 0)
				src.visible_message("<span class='notice'>The bees calm down!</span>")
			feral = -15
			target_mob = null
			target_turf = null
			wander = 1

	for(var/mob/living/simple_animal/bee/B in src.loc)
		if(B == src)
			continue

		if(feral > 0)
			src.strength += B.strength
			B.strength = 0
			B.update_icons()
			update_icons()

		else if(prob(10))
			//make the other swarm of bees stronger, then move away
			var/total_bees = B.strength + src.strength
			if(total_bees < 10)
				B.strength = min(5, total_bees)
				src.strength = total_bees - B.strength

				update_icons()
				B.update_icons()
				if(src.strength <= 0)
					qdel(src)
					return
				var/turf/simulated/floor/T = get_step(src, pick(1,2,4,8))
				density = 1
				Move(T)
				density = 0
			break


	if(target_mob)//If we have a target
		if(target_mob in view(src,7))//Check that we can still see them
			target_turf = get_turf(target_mob)//If so, update the location
			wander = 0
		else//Otherwise, if our target is out of view, we clear them so we can pick a new one in the next step
			target_mob = null
			target_turf = null
			wander = 1

	//If we're angry but have no target, lets search for one
	if (!target_mob && feral)
		for(var/mob/living/carbon/G in view(src,7))
			target_mob = G
			break

	//if we're chasing someone, get a little bit angry
	if(target_mob && prob(5))
		feral++

	if(target_turf)
		if (!(DirBlocked(get_step(src, get_dir(src,target_turf)),get_dir(src,target_turf)))) // Check for windows and doors!
			Move(get_step(src, get_dir(src,target_turf)))
			if (prob(10))
				src.visible_message("<span class='notice'>The bees swarm after [target_mob]!</span>")
		if(src.loc == target_turf)
			target_turf = null
			wander = 1
	else
		//find some flowers, harvest
		//angry bee swarms don't hang around
		if(feral > 0)
			turns_per_move = rand(1,3)
		else if(feral < 0)
			turns_since_move = 0
		else if(!my_hydrotray || my_hydrotray.loc != src.loc || my_hydrotray.dead || !my_hydrotray.seed)
			var/obj/machinery/portable_atmospherics/hydroponics/my_hydrotray = locate() in src.loc
			if(my_hydrotray)
				if(!my_hydrotray.dead && my_hydrotray.seed)
					turns_per_move = rand(20,50)
				else
					my_hydrotray = null

	animate(src, pixel_x = rand(-12, 12), pixel_y = rand(-12, 12), time = 0.5)


/mob/living/simple_animal/bee/update_icons()
	if(strength <= 5)
		icon_state = "bees[round(strength,1)]"
	else
		icon_state = "bees_swarm"

//Kill it with fire!
/mob/living/simple_animal/bee/adjustFireLoss(damage)
	..(damage * 2)


//No more grabbing bee swarms
/mob/living/simple_animal/bee/attempt_grab(var/mob/living/grabber)
	if (prob(strength*5))//if the swarm is big you might grab a few bees, you won't make a serious dent
		to_chat(grabber, "<span class = 'warning'>You attempt to grab the swarm, but only manage to snatch a scant handful of crushed bees.</span>")
		apply_damage(strength*0.5, BRUTE, used_weapon = "Crushing by [grabber.name]")
	else
		to_chat(grabber, "<span class = 'warning'>For some bizarre reason known only to yourself, you attempt to grab ahold of the swarm of bees. You come away with nothing but empty, slightly stung hands.</span>")
		grabber.apply_damage(strength*0.5, BURN)

	return 0

/mob/living/simple_animal/bee/attempt_pull(var/mob/living/grabber)
	return attempt_grab(grabber)

/mob/living/simple_animal/bee/can_fall()
	return FALSE

/mob/living/simple_animal/bee/can_ztravel()
	return TRUE

/mob/living/simple_animal/bee/CanAvoidGravity()
	return TRUE

//Bee for spawning as a hostile mob, it wont fade without a hive
/mob/living/simple_animal/bee/standalone
	loner = 1

/mob/living/simple_animal/bee/standalone/Initialize(mapload, var/obj/machinery/beehive/new_parent)
	. = ..()
	strength = rand(4,8)
	update_icons()

/mob/living/simple_animal/bee/beegun
	maxHealth = 30
	strength = 5
	feral = 30
