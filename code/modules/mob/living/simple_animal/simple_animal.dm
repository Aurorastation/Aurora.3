/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/npc/animal.dmi'
	health = 20
	maxHealth = 20

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	var/show_stat_health = 1	//does the percentage health show in the stat panel for the mob

	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib = null	//We only try to show a gibbing animation if this exists.
	var/blood_type = "#A10808" //Blood colour for impact visuals.

	var/list/speak = list()
	var/speak_chance = 0
	var/list/emote_hear = list()	//Hearable emotes
	var/list/emote_see = list()		//Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps
	var/list/emote_sounds = list()
	var/sound_time = TRUE

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
	var/response_harm   = "hurts"
	var/harm_intent_damage = 5

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

	//Seeking/Moving behaviour vars
	var/min_scan_interval = 1//Minimum and maximum number of procs between a scan
	var/max_scan_interval = 15
	var/scan_interval = 5//current scan interval, clamped between min and max
	//It gradually increases up to max when its left alone, to save performance

	var/seek_speed = 2//How many tiles per second the animal will move towards something
	var/seek_move_delay
	var/scan_range = 6//How far around the animal will look for something

	var/kitchen_tag = "animal" //Used for cooking with animals

	//brushing
	var/canbrush = FALSE //can we brush this beautiful creature?
	var/brush = /obj/item/haircomb //What can we brush it with? Use a rag for things with scales/carapaces/etc

	//Napping
	var/can_nap = 0
	var/icon_rest = null

	var/tameable = TRUE //if you can tame it, used by the dociler for now

	var/flying = FALSE //if they can fly, which stops them from falling down and allows z-space travel

	var/has_udder = FALSE
	var/datum/reagents/udder = null
	var/milk_type = "milk"

	var/list/butchering_products	//if anything else is created when butchering this creature, like bones and leather


/mob/living/simple_animal/proc/update_nutrition_stats()
	nutrition_step = mob_size * 0.03 * metabolic_factor
	bite_factor = mob_size * 0.3
	max_nutrition *= 1 + (nutrition_step*4)//Max nutrition scales faster than costs, so bigger creatures eat less often

/mob/living/simple_animal/Initialize()
	. = ..()
	seek_move_delay = (1 / seek_speed) * 10	//number of ds between moves
	turns_since_scan = rand(min_scan_interval, max_scan_interval)//Randomise this at the start so animals don't sync up
	health = maxHealth
	verbs -= /mob/verb/observe
	health = maxHealth
	if (mob_size)
		update_nutrition_stats()
		reagents = new/datum/reagents(stomach_size_mult*mob_size, src)
	else
		reagents = new/datum/reagents(20, src)
	nutrition = max_nutrition

	if(has_udder)
		udder = new(50)
		udder.my_atom = src

/mob/living/simple_animal/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != DEAD && hunger_enabled)
			src.adjustNutritionLoss(nutrition_step)

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

	if (stat == DEAD)
		to_chat(user, "<span class='danger'>It looks dead.</span>")
	if (health < maxHealth * 0.5)
		to_chat(user, "<span class='danger'>It looks badly wounded.</span>")
	else if (health < maxHealth)
		to_chat(user, "<span class='warning'>It looks wounded.</span>")


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

	//Movement
	turns_since_move++

	//Atmos
	var/atmos_suitable = 1

	if(isturf(loc))
		var/turf/T = loc

		var/datum/gas_mixture/Environment = T.return_air()

		if(Environment)
			if (abs(Environment.temperature - bodytemperature) > 40)
				bodytemperature += ((Environment.temperature - bodytemperature) / 5)

			if(min_oxy && Environment.gas["oxygen"] < min_oxy)
				atmos_suitable = 0
			else if(max_oxy && Environment.gas["oxygen"] > max_oxy)
				atmos_suitable = 0
			else if(min_tox && Environment.gas["phoron"] < min_tox)
				atmos_suitable = 0
			else if(max_tox && Environment.gas["phoron"] > max_tox)
				atmos_suitable = 0
			else if(min_n2 && Environment.gas["nitrogen"] < min_n2)
				atmos_suitable = 0
			else if(max_n2 && Environment.gas["nitrogen"] > max_n2)
				atmos_suitable = 0
			else if(min_co2 && Environment.gas["carbon_dioxide"] < min_co2)
				atmos_suitable = 0
			else if(max_co2 && Environment.gas["carbon_dioxide"] > max_co2)
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

	if(has_udder)
		if(stat == CONSCIOUS)
			if(udder && prob(5))
				udder.add_reagent(milk_type, rand(5, 10))

	return 1

/mob/living/simple_animal/think()
	..()
	if(!stop_automated_movement && wander && !anchored)
		if(isturf(loc) && !resting && !buckled && canmove)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			if(turns_since_move >= turns_per_move && !(stop_automated_movement_when_pulled && pulledby))	 //Some animals don't move when pulled
				var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I mention fuck BYOND
				moving_to = pick(cardinal)
				set_dir(moving_to)			//How about we turn them the direction they are moving, yay.
				Move(get_step(src,moving_to))
				turns_since_move = 0

	//Speaking
	if(speak_chance && rand(0,200) < speak_chance)
		if(LAZYLEN(speak))
			if(LAZYLEN(emote_hear) || LAZYLEN(emote_see))
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
						visible_emote("[pick(emote_see)].",0)
					else
						audible_emote("[pick(emote_hear)].",0)
			else
				say(pick(speak))
		else
			if(!(emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				visible_emote("[pick(emote_see)].",0)
			if((emote_hear && emote_hear.len) && !(emote_see && emote_see.len))
				audible_emote("[pick(emote_hear)].",0)
			if((emote_hear && emote_hear.len) && (emote_see && emote_see.len))
				var/length = emote_hear.len + emote_see.len
				var/pick = rand(1,length)
				if(pick <= emote_see.len)
					visible_emote("[pick(emote_see)].",0)
				else
					audible_emote("[pick(emote_hear)].",0)
		speak_audio()

	if (can_nap)
		if (resting)
			if (prob(1))
				fall_asleep()
		else
			if (!stat || prob(0.5))
				wake_up()

	if(nutrition < max_nutrition / 3 && isturf(loc))	//If we're hungry enough (and not being held/in a bag), we'll check our tile for food.
		handle_eating()

/mob/living/simple_animal/proc/handle_supernatural()
	if(purge)
		purge -= 1

/mob/living/simple_animal/proc/handle_eating()
	var/list/food_choices = list()
	for(var/obj/item/reagent_containers/food/snacks/S in get_turf(src))
		food_choices += S
	if(food_choices.len) //Only when sufficiently hungry
		UnarmedAttack(pick(food_choices))

//Simple reagent processing for simple animals
//This allows animals to digest food, and only food
//Most drugs, poisons etc, are designed to work on carbons and affect many values a simple animal doesnt have
/mob/living/simple_animal/proc/process_food()
	if (hunger_enabled)
		if (nutrition)
			adjustNutritionLoss(nutrition_step)//Bigger animals get hungry faster
		else
			if (prob(3))
				to_chat(src, "You feel hungry...")


		if (!reagents || !reagents.total_volume)
			return

		for(var/datum/reagent/current in reagents.reagent_list)
			var/removed = min(current.metabolism*digest_factor, current.volume)
			if (istype(current, /datum/reagent/nutriment))//If its food, it feeds us
				var/datum/reagent/nutriment/N = current
				adjustNutritionLoss(-removed*N.nutriment_factor)
				var/heal_amount = removed*N.regen_factor
				if (getBruteLoss() > 0)
					var/n = min(heal_amount, getBruteLoss())
					adjustBruteLoss(-n)
					heal_amount -= n
				if (getFireLoss() && heal_amount)
					var/n = min(heal_amount, getFireLoss())
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
	..(icon_gib, 1)

/mob/living/simple_animal/emote(var/act, var/type, var/desc)
	if(act)
		..(act, type, desc)

//This is called when an animal 'speaks'. It does nothing here, but descendants should override it to add audio
/mob/living/simple_animal/proc/speak_audio()
	return

/mob/living/simple_animal/proc/visible_emote(var/act_desc, var/log_emote=1)
	custom_emote(1, act_desc, log_emote)

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
				M.visible_message("<span class='notice'>[M] [response_help] \the [src]</span>")
				poke()

		if(I_DISARM)
			M.visible_message("<span class='notice'>[M] [response_disarm] \the [src]</span>")
			M.do_attack_animation(src)
			poke(1)
			//TODO: Push the mob away or something

		if(I_GRAB)
			if (M == src)
				return
			if (!(status_flags & CANPUSH))
				return

			if (!attempt_grab(M))
				return

			var/obj/item/grab/G = new /obj/item/grab(M, src)

			M.put_in_active_hand(G)

			G.synch()
			G.affecting = src
			LAssailant = WEAKREF(M)

			M.visible_message("<span class='warning'>[M] has grabbed [src] passively!</span>")
			M.do_attack_animation(src)
			poke(1)

		if(I_HURT)
			unarmed_harm_attack(M)

	return

/mob/living/simple_animal/proc/unarmed_harm_attack(var/mob/living/carbon/human/user)
	apply_damage(harm_intent_damage, BRUTE, used_weapon = "Attack by [user.name]")
	user.visible_message(SPAN_WARNING("[user] [response_harm] \the [src]!"))
	user.do_attack_animation(src)
	poke(TRUE)

/mob/living/simple_animal/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/reagent_containers/glass/rag)) //You can't milk an udder with a rag.
		attacked_with_item(O, user)
		return
	if(has_udder)
		var/obj/item/reagent_containers/glass/G = O
		if(stat == CONSCIOUS && istype(G) && G.is_open_container())
			if(udder.total_volume <= 0)
				to_chat(user, "<span class='warning'>The udder is dry.</span>")
				return
			if(G.reagents.total_volume >= G.volume)
				to_chat(user, "<span class='warning'>The [O] is full.</span>")
				return
			user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>")
			udder.trans_id_to(G, milk_type , rand(5,10))
			return

	if(istype(O, /obj/item/reagent_containers) || istype(O, /obj/item/stack/medical) || istype(O,/obj/item/gripper/))
		..()
		poke()

	else if(meat_type && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(istype(O, /obj/item/material/knife) || istype(O, /obj/item/material/kitchen/utensil/knife)|| istype(O, /obj/item/material/hatchet))
			harvest(user)
	else
		attacked_with_item(O, user)

//TODO: refactor mob attackby(), attacked_by(), and friends.
/mob/living/simple_animal/proc/attacked_with_item(obj/item/O, mob/user)
	if(istype(O, /obj/item/trap/animal))
		O.attack(src, user)
		return
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(O, brush) && canbrush) //Brushing animals
		visible_message(span("notice", "[user] gently brushes [src] with \the [O]."))
		if(prob(15) && !istype(src, /mob/living/simple_animal/hostile)) //Aggressive animals don't purr before biting your face off.
			visible_message(span("notice", "[src] [speak_emote.len ? pick(speak_emote) : "rumbles"].")) //purring
		return
	if(!O.force)
		visible_message("<span class='notice'>[user] gently taps [src] with \the [O].</span>")
		poke()
		return 0

	if(O.force > resistance)
		var/damage = O.force
		if (O.damtype == PAIN)
			damage = 0
		if(supernatural && istype(O,/obj/item/nullrod))
			damage *= 2
			purge = 3

		apply_damage(damage, O.damtype, used_weapon = "[O.name]")
		poke(1)
	else
		to_chat(usr, "<span class='danger'>This weapon is ineffective, it does no damage.</span>")
		poke()

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

/mob/living/simple_animal/cat/proc/handle_movement_target()
	//if our target is neither inside a turf or inside a human(???), stop
	if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
		movement_target = null
		stop_automated_movement = 0
	//if we have no target or our current one is out of sight/too far away
	if( !movement_target || !(movement_target.loc in oview(src, 4)) )
		movement_target = null
		stop_automated_movement = 0

	if(movement_target)
		stop_automated_movement = 1
		walk_to(src, movement_target, 0, DS2TICKS(seek_move_delay))

/mob/living/simple_animal/Stat()
	..()

	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: [round((health / maxHealth) * 100)]%")
		stat(null, "Nutrition: [nutrition]/[max_nutrition]")

/mob/living/simple_animal/updatehealth()
	..()
	if (health <= 0)
		death()

/mob/living/simple_animal/death(gibbed, deathmessage = "dies!")
	walk_to(src,0)
	movement_target = null
	icon_state = icon_dead
	density = 0
	if (isopenturf(loc))
		ADD_FALLING_ATOM(src)
	return ..(gibbed,deathmessage)

/mob/living/simple_animal/ex_act(severity)
	if(!blinded)
		flick("flash", flash)

	var/damage
	switch (severity)
		if (1.0)
			damage = 500
			if(!prob(getarmor(null, "bomb")))
				gib()

		if (2.0)
			damage = 120

		if(3.0)
			damage = 30

	adjustBruteLoss(damage * BLOCKED_MULT(getarmor(null, "bomb")))

/mob/living/simple_animal/proc/SA_attackable(target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(!L.stat)
			return (0)
	if (istype(target_mob, /obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		if(B.health > 0)
			return (0)
	if(istype(target_mob, /obj/machinery/porta_turret/))
		var/obj/machinery/porta_turret/T = target_mob
		if(T.health > 0)
			return (0)
	if(istype(target_mob, /obj/effect/energy_field))
		return (0)
	return 1

/mob/living/simple_animal/proc/make_noise(var/make_sound = TRUE)
	set name = "Make Sound"
	set category = "Abilities"

	if((usr && usr.stat == DEAD) || !make_sound)
		return

	if(usr && !sound_time)
		to_chat(usr, span("warning", "Ability on cooldown 2 seconds."))
		return

	playsound(src, pick(emote_sounds), 75, 1)
	if(client)
		sound_time = FALSE
		addtimer(CALLBACK(src, .proc/reset_sound_time), 2 SECONDS)

/mob/living/simple_animal/proc/reset_sound_time()
	sound_time = TRUE

/mob/living/simple_animal/say(var/message)
	var/verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)

	message = sanitize(message)
	if(emote_sounds.len)
		var/sound_chance = TRUE
		if(client) // we do not want people who assume direct control to spam
			sound_chance = prob(50)
		make_noise(sound_chance)

	..(message, null, verb)

/mob/living/simple_animal/get_speech_ending(verb, var/ending)
	return verb

/mob/living/simple_animal/put_in_hands(var/obj/item/W) // No hands.
	W.forceMove(get_turf(src))
	return 1

// Harvest an animal's delicious byproducts
/mob/living/simple_animal/proc/harvest(var/mob/user)
	var/actual_meat_amount = max(1,(meat_amount*0.75))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			new meat_type(get_turf(src))

		if(butchering_products)
			for(var/path in butchering_products)
				var/number = butchering_products[path]
				for(var/i in 1 to number)
					new path(get_turf(src))

		if(issmall(src))
			user.visible_message("<span class='danger'>[user] chops up \the [src]!</span>")
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(src)
		else
			user.visible_message("<span class='danger'>[user] butchers \the [src] messily!</span>")
			gib()

//For picking up small animals
/mob/living/simple_animal/MouseDrop(atom/over_object)
	if (holder_type)//we need a defined holder type in order for picking up to work
		var/mob/living/carbon/H = over_object
		if(!istype(H) || !Adjacent(H))
			return ..()

		get_scooped(H, usr)
		return
	return ..()


//I wanted to call this proc alert but it already exists.
//Basically makes the mob pay attention to the world, resets sleep timers, awakens it from a sleeping state sometimes
/mob/living/simple_animal/proc/poke(var/force_wake = 0)
	if (stat != DEAD)
		scan_interval = min_scan_interval
		if (force_wake || (!client && prob(30)))
			wake_up()

//Puts the mob to sleep
/mob/living/simple_animal/proc/fall_asleep()
	if (stat != DEAD)
		resting = 1
		stat = UNCONSCIOUS
		canmove = 0
		wander = 0
		walk_to(src,0)
		movement_target = null
		update_icons()

//Wakes the mob up from sleeping
/mob/living/simple_animal/proc/wake_up()
	if (stat != DEAD)
		stat = CONSCIOUS
		resting = 0
		canmove = 1
		wander = 1
		update_icons()

/mob/living/simple_animal/update_icons()
	if (stat == DEAD)
		icon_state = icon_dead
	else if ((stat == UNCONSCIOUS || resting) && icon_rest)
		icon_state = icon_rest
	else if (icon_living)
		icon_state = icon_living

/mob/living/simple_animal/lay_down()
	set name = "Rest"
	set category = "Abilities"

	if (resting)
		wake_up()
	else
		fall_asleep()

	to_chat(src, span("notice","You are now [resting ? "resting" : "getting up"]"))

	update_icons()

//Todo: add snowflakey shit to it.
/mob/living/simple_animal/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null, var/tesla_shock = 0, var/ground_zero)
	apply_damage(shock_damage, BURN)
	playsound(loc, "sparks", 50, 1, -1)
	spark(loc, 5, alldirs)
	visible_message("<span class='warning'>[src] was shocked by [source]!</span>", "<span class='danger'>You are shocked by [source]!</span>", "<span class='notice'>You hear an electrical crack.</span>")


/mob/living/simple_animal/can_fall()
	if (stat != DEAD && flying)
		return FALSE

	return ..()

/mob/living/simple_animal/can_ztravel()
	if (stat != DEAD && flying)
		return TRUE
	else
		return FALSE

/mob/living/simple_animal/CanAvoidGravity()
	if (stat != DEAD && flying)
		return TRUE
	else
		return FALSE

/mob/living/simple_animal/emp_act(severity)
	if(!isSynthetic())
		return

	switch(severity)
		if(1)
			adjustFireLoss(rand(20, 25))
		if(2)
			adjustFireLoss(rand(10, 15))
		if(3)
			adjustFireLoss(rand(5, 10))
		if(4)
			adjustFireLoss(rand(3, 5))

/mob/living/simple_animal/get_digestion_product()
	return "nutriment"

/mob/living/simple_animal/bullet_impact_visuals(var/obj/item/projectile/P, var/def_zone, var/damage)
	..()
	switch(get_bullet_impact_effect_type(def_zone))
		if(BULLET_IMPACT_MEAT)
			if(P.damtype == BRUTE)
				var/hit_dir = get_dir(P.starting, src)
				var/obj/effect/decal/cleanable/blood/B = blood_splatter(get_step(src, hit_dir), src, 1, hit_dir)
				B.icon_state = pick("dir_splatter_1","dir_splatter_2")
				B.basecolor = blood_type
				var/scale = min(1, round(mob_size / MOB_TINY, 0.1))
				var/matrix/M = new()
				B.transform = M.Scale(scale)
				B.update_icon()
