//Bees are spawned from an apiary, and will slowly die if it is destroyed.

/datum/ai_holder/simple_animal/passive/bee
	can_flee = FALSE
	stand_ground = TRUE

/datum/ai_holder/simple_animal/passive/bee/should_flee(force = FALSE)
	return FALSE

/datum/ai_holder/simple_animal/passive/bee/handle_special_tactic()
	var/mob/living/simple_animal/bee/bees = holder
	if(!target)
		return
	var/mob/living/carbon/human/sting_target = target
	if(bees.feral <= 0 || !istype(sting_target) || !bees.verify_stingable(sting_target) || !(sting_target in view(5, bees)))
		remove_target(FALSE)
		return
	bees.do_sting(sting_target)
	if(!bees.Adjacent(sting_target) && world.time >= next_movement)
		var/turf/target_turf = get_step(bees, get_dir(bees, sting_target))
		if(target_turf && !DirBlocked(target_turf, get_dir(bees, sting_target)) && bees.AIMove(target_turf) == AI_MOVEMENT_SUCCESS)
			next_movement = world.time + bees.AIMovementDelay()
			if(prob(10))
				bees.visible_message(SPAN_NOTICE("The bees swarm after [sting_target]!"))
	if(prob(5))
		bees.feral++

/datum/ai_holder/simple_animal/passive/bee/handle_special_strategical()
	var/mob/living/simple_animal/bee/bees = holder
	if(bees.feral > 0 && !target && prob(bees.feral * 20))
		bees.feral--
	else if(bees.feral < 0)
		bees.feral++

	if(prob(2))
		bees.audible_message("[SPAN_BOLD("\The [bees]")] [pick("buzz", "hum")].")
		playsound(bees, pick('sound/effects/Buzz1.ogg', 'sound/effects/Buzz2.ogg'), 10, TRUE, -4)

	if(bees.feral && isturf(bees.loc))
		var/static/list/calmers = typecacheof(list(
			/obj/effect/smoke,
			/obj/effect/effect/water,
			/obj/effect/effect/foam,
			/obj/effect/effect/steam,
			/obj/effect/mist
		))
		if(range_in_typecache(bees, 2, calmers))
			if(bees.feral > 0)
				bees.visible_message(SPAN_NOTICE("The bees calm down!"))
			bees.feral = -15
			remove_target(FALSE)

	for(var/mob/living/simple_animal/bee/other_swarm in bees.loc)
		if(other_swarm == bees)
			continue
		if(bees.feral > 0 && prob(50))
			if(other_swarm.strength > bees.strength)
				bees.mut = other_swarm.mut
				bees.toxic = other_swarm.toxic
			bees.strength += other_swarm.strength
			other_swarm.strength = 0
			qdel(other_swarm)
			bees.update_icon()
		else if(prob(10))
			var/total_bees = other_swarm.strength + bees.strength
			if(total_bees < 10)
				other_swarm.strength = min(5, total_bees)
				bees.strength = total_bees - other_swarm.strength
				bees.update_icon()
				other_swarm.update_icon()
				if(bees.strength <= 0)
					qdel(bees)
					return
				var/turf/separation_turf = get_step(bees, pick(GLOB.cardinals))
				if(istype(separation_turf, /turf/simulated/floor))
					bees.AIMove(separation_turf)
		break

	if(bees.feral > 0 && !target)
		for(var/mob/living/carbon/human/new_target in view(bees, 7))
			if(bees.verify_stingable(new_target))
				give_target(new_target, TRUE)
				break

	if(bees.feral <= 0 && target)
		remove_target(FALSE)

	if(bees.feral <= 0 && !target && bees.strength > 5)
		var/mob/living/simple_animal/bee/new_swarm = new(get_turf(bees), bees.parent)
		new_swarm.strength = rand(1, 5)
		bees.strength -= new_swarm.strength
		bees.update_icon()
		new_swarm.update_icon()
		bees.parent?.owned_bee_swarms |= new_swarm

	if(bees.feral > 0)
		bees.turns_per_move = rand(1, 3)
	else if(bees.feral < 0)
		bees.turns_since_move = 0
	else if(!bees.my_hydrotray || bees.my_hydrotray.loc != bees.loc || bees.my_hydrotray.dead || !bees.my_hydrotray.seed)
		bees.my_hydrotray = locate() in bees.loc
		if(bees.my_hydrotray && !bees.my_hydrotray.dead && bees.my_hydrotray.seed)
			bees.turns_per_move = rand(20, 50)
		else
			bees.my_hydrotray = null

	animate(bees, pixel_x = rand(-12, 12), pixel_y = rand(-12, 12), time = 0.5)

/mob/living/simple_animal/bee
	ai_holder_type = /datum/ai_holder/simple_animal/passive/bee
	name = "bees"
	icon = 'icons/obj/beekeeping.dmi'
	icon_state = "bees1"
	icon_dead = "bees1"
	mob_size = 0.5
	unsuitable_atoms_damage = 2.5
	maxhealth = 20
	density = 0
	var/strength = 1
	var/feral = 0
	var/mut = 0
	var/toxic = 0
	var/obj/structure/machinery/beehive/parent
	var/loner = 0
	pass_flags = PASSTABLE | PASSRAILING
	turns_per_move = 6
	var/obj/structure/machinery/portable_atmospherics/hydroponics/my_hydrotray
	emote_sounds = list('sound/effects/creatures/bees.ogg')

/mob/living/simple_animal/bee/Initialize(mapload, var/obj/structure/machinery/beehive/new_parent)
	. = ..()
	parent = new_parent

/mob/living/simple_animal/bee/Destroy()
	if(parent)
		parent.owned_bee_swarms.Remove(src)
	my_hydrotray = null
	parent = null
	return ..()

/mob/living/simple_animal/bee/can_name(var/mob/living/M)
	return FALSE

//Special death behaviour. When bees accumulate enough damage to 'die', they don't outright die.  Thus no call to parent
//Instead the swarm strength (ie, size, or quantity of bees) drops and their health is refilled
//Repeat until strength hits zero. only THEN do they die, and they qdel and leave no corpse in doing so
//Because we don't have sprites for a carpet made of bee corpses.
/mob/living/simple_animal/bee/death()
	if (!QDELING(src))
		strength -= 1
		if (strength <= 0)
			if (prob(25))//probability to reduce spam
				src.visible_message(SPAN_WARNING("The bee swarm completely dissipates."))
			qdel(src)
			return
		else
			health = maxhealth
			if (prob(25))//probability to reduce spam
				src.visible_message(SPAN_WARNING("The bee swarm starts to thin out a little."))

		update_icon()
	else
		..()

/mob/living/simple_animal/bee/Life(seconds_per_tick, times_fired)
	if(!loner && strength && !parent && prob(7-strength))
		strength -= 1

	if(strength <= 0)
		death()
	else
		update_icon()

	..()

/mob/living/simple_animal/bee/proc/verify_stingable(var/mob/living/M)
	if(M.isSynthetic()) //Can't sting robots, unfortunately
		return FALSE
	return TRUE

/mob/living/simple_animal/bee/proc/do_sting(mob/living/carbon/human/M)
	//if we're strong enough, sting some people
	if(!verify_stingable(M)) //If we can't sting this, why is it our target?
		return FALSE
	var/sting_prob = 40 // Bees will always try to sting.
	var/prob_mult = 1
	if(Adjacent(M)) //Can I reach my target?
		var/obj/item/clothing/worn_suit = M.wear_suit
		var/obj/item/clothing/worn_helmet = M.head
		if(worn_suit) // Are you wearing clothes?
			if ((worn_suit.item_flags & ITEM_FLAG_THICK_MATERIAL))
				prob_mult -= 0.7
			else
				prob_mult -= 0.01 * (min(LAZYACCESS(worn_suit.armor, BIO), 70)) // Is it sealed? I can't get to 70% of your body.
		if(worn_helmet)
			if ((worn_helmet.item_flags & ITEM_FLAG_THICK_MATERIAL))
				prob_mult -= 0.3
			else
				prob_mult -= 0.01 *(min(LAZYACCESS(worn_helmet.armor, BIO), 30))// Is your helmet sealed? I can't get to 30% of your body.
		if( prob(sting_prob*prob_mult) && (M.stat == CONSCIOUS || (M.stat == UNCONSCIOUS && prob(25*prob_mult))) ) // Try to sting! If you're not moving, think about stinging.
			M.apply_damage(min(strength*0.85,2)+mut, DAMAGE_BURN, damage_flags = DAMAGE_FLAG_SHARP) // Stinging. The more mutated I am, the harder I sting.
			var/venom_strength = max(strength*0.2, (round(feral/10,1) * (max(round(strength/20,1), 1)))) + toxic // Bee venom based on how angry I am and how many there are of me!
			M.apply_damage(venom_strength, DAMAGE_PAIN)  //Bee venom causes pain, not organ failure
			if(prob(max(80, strength * 10))) //If there's enough of a swarm, it can also cause breathing trouble. Yes, even without being allergic.
				M.apply_damage(venom_strength, DAMAGE_OXY)
			update_icon()
			to_chat(M, SPAN_WARNING("You have been stung!"))
			M.flash_pain(5)



/mob/living/simple_animal/bee/update_icon()
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
		apply_damage(strength*0.5, DAMAGE_BRUTE, used_weapon = "Crushing by [grabber.name]")
	else
		to_chat(grabber, "<span class = 'warning'>For some bizarre reason known only to yourself, you attempt to grab ahold of the swarm of bees. You come away with nothing but empty, slightly stung hands.</span>")
		if(verify_stingable(grabber))
			grabber.apply_damage(strength*0.5, DAMAGE_BURN)

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

/mob/living/simple_animal/bee/standalone/Initialize(mapload, var/obj/structure/machinery/beehive/new_parent)
	. = ..()
	strength = rand(4,8)
	update_icon()

/mob/living/simple_animal/bee/beegun
	maxhealth = 30
	strength = 5
	feral = 30

/mob/living/simple_animal/bee/beegun/Initialize()
	. = ..()
	mut = rand(0, 1) //We're creating bees out of energy. They have a chance of being mutated...
	toxic = rand(0, 1) //...or slightly more toxic
