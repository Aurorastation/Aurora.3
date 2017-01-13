/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	var/show_stat_health = 1	//does the percentage health show in the stat panel for the mob

	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib = null	//We only try to show a gibbing animation if this exists.

	var/list/speak = list()
	var/speak_chance = 0
	var/list/emote_hear = list()	//Hearable emotes
	var/list/emote_see = list()		//Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps

	var/turns_per_move = 1
	var/turns_since_move = 0
	universal_speak = 0		//No, just no.
	var/meat_amount = 0
	var/meat_type
	var/stop_automated_movement = 0 //Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/wander = 1	// Does the mob wander around when idle?
	var/stop_automated_movement_when_pulled = 1 //When set to 1 this stops the animal from moving when someone is pulling it.
	var/atom/movement_target = null//Thing we're moving towards
	var/turns_since_scan = 0

	//Interaction
	var/response_help   = "tries to help"
	var/response_disarm = "tries to disarm"
	var/response_harm   = "tries to hurt"
	var/harm_intent_damage = 3

	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/heat_damage_per_tick = 3	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	var/fire_alert = 0

	//Atmos effect - Yes, you can make creatures that require phoron or co2 to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	var/min_oxy = 5
	var/max_oxy = 0					//Leaving something at 0 means it's off - has no maximum
	var/min_tox = 0
	var/max_tox = 1
	var/min_co2 = 0
	var/max_co2 = 5
	var/min_n2 = 0
	var/max_n2 = 0
	var/unsuitable_atoms_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above
	var/speed = 0 //LETS SEE IF I CAN SET SPEEDS FOR SIMPLE MOBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower, negative speed is faster

	//LETTING SIMPLE ANIMALS ATTACK? WHAT COULD GO WRONG. Defaults to zero so Ian can still be cuddly
	var/melee_damage_lower = 0
	var/melee_damage_upper = 0
	var/attacktext = "attacked"
	var/attack_sound = null
	var/friendly = "nuzzles"
	var/environment_smash = 0
	var/resistance		  = 0	// Damage reduction

	//Null rod stuff
	var/supernatural = 0
	var/purge = 0


	//Hunger/feeding vars
	var/hunger_enabled = 1//If set to 0, a creature ignores hunger
	max_nutrition = 50
	var/metabolic_factor = 1//A multiplier on how fast nutrition is lost. used to tweak the rates on a per-animal basis
	var/nutrition_step = 0.2 //nutrition lost per tick and per step, calculated from mob_size, 0.2 is a fallback
	var/bite_factor = 0.4
	var/digest_factor = 0.2 //A multiplier on how quickly reagents are digested
	var/stomach_size_mult = 5

	//Food behaviour vars
	var/autoseek_food = 1//If 0. this animal will not automatically eat
	var/beg_for_food = 1//If 0, this animal will not show interest in food held by a person
	var/min_scan_interval = 1//Minimum and maximum number of procs between a foodscan. Animals will slow down if there's no food around for a while
	var/max_scan_interval = 15
	var/scan_interval = 5//current scan interval, clamped between min and max
	//It gradually increases up to max when its left alone, to save performance
	//It will drop back to 1 if it spies any food.
		//This short time makes animals more responsive to interactions and more fun to play with

	var/seek_speed = 2//How many tiles per second the animal will move towards food
	var/seek_move_delay
	var/scan_range = 6//How far around the animal will look for food
	var/foodtarget = 0
	//Used to control how often ian scans for nearby food



/mob/living/simple_animal/proc/beg(var/atom/thing, var/atom/holder)
	visible_emote("gazes longingly at [holder]'s [thing]")

/mob/living/simple_animal/New()
	..()
	seek_move_delay = (1 / seek_speed) / (world.tick_lag / 10)//number of ticks between moves
	turns_since_scan = rand(min_scan_interval, max_scan_interval)//Randomise this at the start so animals don't sync up
	health = maxHealth
	verbs -= /mob/verb/observe
	health = maxHealth
	if (mob_size)
		nutrition_step = mob_size * 0.03 * metabolic_factor
		bite_factor = mob_size * 0.3
		max_nutrition *= 1 + (nutrition_step*4)//Max nutrition scales faster than costs, so bigger creatures eat less often
		reagents = new/datum/reagents(stomach_size_mult*mob_size, src)
	else
		reagents = new/datum/reagents(20, src)
	nutrition = max_nutrition

/mob/living/simple_animal/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != DEAD && hunger_enabled)
			src.nutrition -= nutrition_step

/mob/living/simple_animal/Released()
	//These will cause mobs to immediately do things when released.
	scan_interval = min_scan_interval
	turns_since_move = turns_per_move
	..()

/mob/living/simple_animal/Login()
	if(src && src.client)
		src.client.screen = null
	..()

/mob/living/simple_animal/examine(mob/user)
	..()

	if (hunger_enabled)
		if (!nutrition)
			user << "<span class='danger'>It looks starving!</span>"
		else if (nutrition < max_nutrition *0.5)
			user << "<span class='notice'>It looks hungry.</span>"
		else if ((reagents.total_volume > 0 && nutrition > max_nutrition *0.75) || nutrition > max_nutrition *0.9)
			user << "It looks full and contented."
	if (health < maxHealth * 0.5)
		user << "<span class='danger'>It looks badly wounded.</span>"
	else if (health < maxHealth)
		user << "<span class='warning'>It looks wounded.</span>"


/mob/living/simple_animal/Life()
	..()
	life_tick++
	if (stat == DEAD)
		return 0
	//Health
	updatehealth()

	if(health > maxHealth)
		health = maxHealth

	handle_stunned()
	handle_weakened()
	handle_paralysed()
	update_canmove()
	handle_supernatural()
	process_food()

	handle_foodscanning()
	//Movement
	turns_since_move++
	if(!client && !stop_automated_movement && wander && !anchored)
		if(isturf(src.loc) && !resting && !buckled && canmove)		//This is so it only moves if it's not inside a closet, gentics machine, etc.

			if(turns_since_move >= turns_per_move)
				if(!(stop_automated_movement_when_pulled && pulledby)) //Soma animals don't move when pulled
					var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I mention fuck BYOND
					moving_to = pick(cardinal)
					dir = moving_to			//How about we turn them the direction they are moving, yay.
					Move(get_step(src,moving_to))
					turns_since_move = 0

	//Speaking
	if(!client && speak_chance)
		if(rand(0,200) < speak_chance)
			if(speak && speak.len)
				if((emote_hear && emote_hear.len) || (emote_see && emote_see.len))
					var/length = speak.len
					if(emote_hear && emote_hear.len)
						length += emote_hear.len
					if(emote_see && emote_see.len)
						length += emote_see.len
					var/randomValue = rand(1,length)
					if(randomValue <= speak.len)
						say(pick(speak))
					else
						randomValue -= speak.len
						if(emote_see && randomValue <= emote_see.len)
							visible_emote("[pick(emote_see)].")
						else
							audible_emote("[pick(emote_hear)].")
				else
					say(pick(speak))
			else
				if(!(emote_hear && emote_hear.len) && (emote_see && emote_see.len))
					visible_emote("[pick(emote_see)].")
				if((emote_hear && emote_hear.len) && !(emote_see && emote_see.len))
					audible_emote("[pick(emote_hear)].")
				if((emote_hear && emote_hear.len) && (emote_see && emote_see.len))
					var/length = emote_hear.len + emote_see.len
					var/pick = rand(1,length)
					if(pick <= emote_see.len)
						visible_emote("[pick(emote_see)].")
					else
						audible_emote("[pick(emote_hear)].")
			speak_audio()


	//Atmos
	var/atmos_suitable = 1

	var/atom/A = src.loc

	if(istype(A,/turf))
		var/turf/T = A

		var/datum/gas_mixture/Environment = T.return_air()

		if(Environment)

			if( abs(Environment.temperature - bodytemperature) > 40 )
				bodytemperature += ((Environment.temperature - bodytemperature) / 5)

			if(min_oxy)
				if(Environment.gas["oxygen"] < min_oxy)
					atmos_suitable = 0
			if(max_oxy)
				if(Environment.gas["oxygen"] > max_oxy)
					atmos_suitable = 0
			if(min_tox)
				if(Environment.gas["phoron"] < min_tox)
					atmos_suitable = 0
			if(max_tox)
				if(Environment.gas["phoron"] > max_tox)
					atmos_suitable = 0
			if(min_n2)
				if(Environment.gas["nitrogen"] < min_n2)
					atmos_suitable = 0
			if(max_n2)
				if(Environment.gas["nitrogen"] > max_n2)
					atmos_suitable = 0
			if(min_co2)
				if(Environment.gas["carbon_dioxide"] < min_co2)
					atmos_suitable = 0
			if(max_co2)
				if(Environment.gas["carbon_dioxide"] > max_co2)
					atmos_suitable = 0

	//Atmos effect
	if(bodytemperature < minbodytemp)
		fire_alert = 2
		apply_damage(cold_damage_per_tick, BURN, used_weapon = "Cold Temperature")
	else if(bodytemperature > maxbodytemp)
		fire_alert = 1
		apply_damage(heat_damage_per_tick, BURN, used_weapon = "High Temperature")
	else
		fire_alert = 0

	if(!atmos_suitable)
		apply_damage(unsuitable_atoms_damage, OXY, used_weapon = "Atmosphere")
	return 1

/mob/living/simple_animal/proc/handle_supernatural()
	if(purge)
		purge -= 1



//Simple reagent processing for simple animals
//This allows animals to digest food, and only food
//Most drugs, poisons etc, are designed to work on carbons and affect many values a simple animal doesnt have
/mob/living/simple_animal/proc/process_food()
	if (hunger_enabled)
		if (nutrition)
			nutrition -= nutrition_step//Bigger animals get hungry faster
			nutrition = max(0,min(nutrition, max_nutrition))//clamp the value
		else
			if (prob(3))
				src << "You feel hungry..."


		if (!reagents || !reagents.total_volume)
			return

		for(var/datum/reagent/current in reagents.reagent_list)
			var/removed = min(current.metabolism*digest_factor, current.volume)
			if (istype(current, /datum/reagent/nutriment))//If its food, it feeds us
				var/datum/reagent/nutriment/N = current
				nutrition += removed*N.nutriment_factor
				var/heal_amount = removed*N.regen_factor
				if (bruteloss > 0)
					var/n = min(heal_amount, bruteloss)
					adjustBruteLoss(-n)
					heal_amount -= n
				if (fireloss && heal_amount)
					var/n = min(heal_amount, fireloss)
					adjustFireLoss(-n)
					heal_amount -= n
				updatehealth()
			current.remove_self(removed)//If its not food, it just does nothing. no fancy effects

/mob/living/simple_animal/can_eat()
	if (!hunger_enabled || nutrition > max_nutrition * 0.9)
		return 0//full

	else if ((nutrition > max_nutrition * 0.8) || health < maxHealth)
		return 1//content

	else return 2//hungry

/mob/living/simple_animal/gib()
	..(icon_gib,1)

/mob/living/simple_animal/emote(var/act, var/type, var/desc)
	if(act)
		..(act, type, desc)

//This is called when an animal 'speaks'. It does nothing here, but descendants should override it to add audio
/mob/living/simple_animal/proc/speak_audio()
	return

/mob/living/simple_animal/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/living/simple_animal/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/*
mob/living/simple_animal/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj || Proj.nodamage)
		return

	adjustBruteLoss(Proj.damage)
	return 0
*/

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M as mob)
	..()

	switch(M.a_intent)

		if(I_HELP)
			if (health > 0)
				M.visible_message("\blue [M] [response_help] \the [src]")

		if(I_DISARM)
			M.visible_message("\blue [M] [response_disarm] \the [src]")
			M.do_attack_animation(src)
			//TODO: Push the mob away or something

		if(I_GRAB)
			if (M == src)
				return
			if (!(status_flags & CANPUSH))
				return

			if (!attempt_grab(M))
				return

			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)

			M.put_in_active_hand(G)

			G.synch()
			G.affecting = src
			LAssailant = M

			M.visible_message("\red [M] has grabbed [src] passively!")
			M.do_attack_animation(src)

		if(I_HURT)
			apply_damage(harm_intent_damage, BRUTE, used_weapon = "Attack by [M.name]")
			M.visible_message("\red [M] [response_harm] \the [src]")
			M.do_attack_animation(src)

	return

/mob/living/simple_animal/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/weapon/reagent_containers) || istype(O, /obj/item/stack/medical) || istype(O,/obj/item/weapon/gripper/))
		..()

	else if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(istype(O, /obj/item/weapon/material/knife) || istype(O, /obj/item/weapon/material/knife/butch))
			harvest(user)
	else
		attacked_with_item(O, user)

//TODO: refactor mob attackby(), attacked_by(), and friends.
/mob/living/simple_animal/proc/attacked_with_item(var/obj/item/O, var/mob/user)
	if(!O.force)
		visible_message("<span class='notice'>[user] gently taps [src] with \the [O].</span>")
		return 0

	if(O.force > resistance)
		var/damage = O.force
		if (O.damtype == HALLOSS)
			damage = 0
		if(supernatural && istype(O,/obj/item/weapon/nullrod))
			damage *= 2
			purge = 3

		apply_damage(damage, O.damtype, used_weapon = "[O.name]")
	else
		usr << "<span class='danger'>This weapon is ineffective, it does no damage.</span>"

	visible_message("<span class='danger'>\The [src] has been attacked with the [O] by [user].</span>")
	user.do_attack_animation(src)


/mob/living/simple_animal/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed
	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(tally <= 0)
			tally = 1
		tally *= purge

	if (!nutrition)
		tally += 4

	return tally+config.animal_delay

/mob/living/simple_animal/Stat()
	..()

	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: [round((health / maxHealth) * 100)]%")

/mob/living/simple_animal/updatehealth()
	..()
	if (health <= 0)
		death()

/mob/living/simple_animal/death(gibbed, deathmessage = "dies!")
	walk_to(src,0)
	movement_target = null
	icon_state = icon_dead
	density = 0
	return ..(gibbed,deathmessage)

/mob/living/simple_animal/ex_act(severity)
	if(!blinded)
		flick("flash", flash)
	switch (severity)
		if (1.0)
			apply_damage(500, BRUTE)
			gib()
			return

		if (2.0)
			apply_damage(60, BRUTE)


		if(3.0)
			apply_damage(30, BRUTE)

/mob/living/simple_animal/proc/SA_attackable(target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(!L.stat && L.health >= 0)
			return (0)
	if (istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		if (M.occupant)
			return (0)
	if (istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		if(B.health > 0)
			return (0)
	return 1

/mob/living/simple_animal/say(var/message)
	var/verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)

	message = sanitize(message)

	..(message, null, verb)

/mob/living/simple_animal/get_speech_ending(verb, var/ending)
	return verb

/mob/living/simple_animal/put_in_hands(var/obj/item/W) // No hands.
	W.loc = get_turf(src)
	return 1

// Harvest an animal's delicious byproducts
/mob/living/simple_animal/proc/harvest(var/mob/user)
	var/actual_meat_amount = max(1,(meat_amount/2))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.name = "[src.name] [meat.name]"
		if(issmall(src))
			user.visible_message("<span class='danger'>[user] chops up \the [src]!</span>")
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(src)
		else
			user.visible_message("<span class='danger'>[user] butchers \the [src] messily!</span>")
			gib()


//Code to handle finding and nomming nearby food items
/mob/living/simple_animal/proc/handle_foodscanning()
	if (client || !hunger_enabled || !autoseek_food)
		return 0

	//Feeding, chasing food, FOOOOODDDD
	if(!stat && !resting && !buckled)

		turns_since_scan++
		if(turns_since_scan >= scan_interval)
			turns_since_scan = 0
			if((movement_target) && (!(isturf(movement_target.loc) || ishuman(movement_target.loc))) || (foodtarget && !can_eat() ))
				movement_target = null
				foodtarget = 0
				stop_automated_movement = 0
			if( !movement_target || !(movement_target.loc in oview(src, 7)) )
				walk_to(src,0)
				movement_target = null
				foodtarget = 0
				stop_automated_movement = 0
				if (can_eat())
					for(var/obj/item/weapon/reagent_containers/food/snacks/S in oview(src,7))
						if(isturf(S.loc) || ishuman(S.loc))
							movement_target = S
							foodtarget = 1
							break

					//Look for food in people's hand
					if (!movement_target && beg_for_food)
						var/obj/item/weapon/reagent_containers/food/snacks/F = null
						for(var/mob/living/carbon/human/H in oview(src,scan_range))
							if(istype(H.l_hand, /obj/item/weapon/reagent_containers/food/snacks))
								F = H.l_hand

							if(istype(H.r_hand, /obj/item/weapon/reagent_containers/food/snacks))
								F = H.r_hand

							if (F)
								movement_target = F
								foodtarget = 1
								break

			if(movement_target)
				scan_interval = min_scan_interval
				stop_automated_movement = 1

				if (istype(movement_target.loc, /turf))
					walk_to(src,movement_target,0, seek_move_delay)//Stand ontop of food
				else
					walk_to(src,movement_target.loc,1, seek_move_delay)//Don't stand ontop of people



				if(movement_target)		//Not redundant due to sleeps, Item can be gone in 6 decisecomds
					if (movement_target.loc.x < src.x)
						set_dir(WEST)
					else if (movement_target.loc.x > src.x)
						set_dir(EAST)
					else if (movement_target.loc.y < src.y)
						set_dir(SOUTH)
					else if (movement_target.loc.y > src.y)
						set_dir(NORTH)
					else
						set_dir(SOUTH)

					if(isturf(movement_target.loc) && Adjacent(get_turf(movement_target), src))
						UnarmedAttack(movement_target)
						if (get_turf(movement_target) == src.loc)
							set_dir(pick(1,2,4,8,1,1))//Face a random direction when eating, but mostly upwards
					else if(ishuman(movement_target.loc) && Adjacent(src, get_turf(movement_target)) && prob(15))
						beg(movement_target, movement_target.loc)
			else
				scan_interval = max(min_scan_interval, min(scan_interval+1, max_scan_interval))//If nothing is happening, ian's scanning frequency slows down to save processing


//For picking up small animals
/mob/living/simple_animal/MouseDrop(atom/over_object)
	if (holder_type)//we need a defined holder type in order for picking up to work
		var/mob/living/carbon/H = over_object
		if(!istype(H) || !Adjacent(H))
			return ..()

		get_scooped(H, usr)
		return
	return ..()


/mob/living/simple_animal/handle_fire()
	return
/mob/living/simple_animal/update_fire()
	return
/mob/living/simple_animal/IgniteMob()
	return
/mob/living/simple_animal/ExtinguishMob()
	return
