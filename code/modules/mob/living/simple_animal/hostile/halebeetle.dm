#define BEARMODE_INDOORS 1
#define BEARMODE_SPACE 2

//Space bears!
/mob/living/simple_animal/hostile/halebeetle
	name = "Hale Beetle"
	desc = "It's just standing there..."
	icon_state = "halebeetle"
	icon_living = "halebeetle"
	icon_dead = "halebeetle_dead"
	icon_gib = "bear_gib"
	//speak = list("RAWR!","Rawr!","GRR!","Growl!") Bears don't talk.
	speak_emote = list(".../tktk/...", ".../tzz/...", "...zzmun...", "...hhel...")
	emote_hear = list("whispers","giggles quietly")
	emote_see = list("stares ominously", "moves forward one step, raising a scythe-like blade", "reflects light in its vacant eyes", "opens its mandibles", "leaks an acidic odor")
	speak_chance = 10
	turns_per_move = 10
	see_in_dark = 6
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat
	meat_amount = 5
	organ_names = list("chestplate", "lower abdomen", "left scythe", "right scythe", "right legs", "right legs", "head")
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"
	stop_automated_movement_when_pulled = 0
	maxHealth = 80
	melee_damage_lower = 10
	melee_damage_upper = 18
	armor_penetration = 30 //Standard armor probably doesn't help against a bear, does it?
	attack_flags = DAM_EDGE|DAM_SHARP
	resist_mod = 4
	break_stuff_probability = 80
	mob_size = 17
	butchering_products = list(/obj/item/device/flashlight/slime = 2)
	var/safety //used to prevent infinite loops
	var/turns_since_hit = 0//If the bear chases someone too long without hitting them, it will try to change to another nearby target instead

	attacktext = null//This allows custom attacking emotes


	var/bearmode
	//Bears in space, or other low-pressure environments are stronger. Higher health, faster movement, longer aggression before being tired

	var/anger
	//An angry bear will immediately attack anyone it sees without warning
	//Anger decreases at 1 point per minute
	//Any amount of anger causes instant aggro, quantity of it is only a duration

	var/health_last_tick = 0

	faction = "russian"


/mob/living/simple_animal/hostile/halebeetle/proc/set_stance(var/input)
	var/previous = stance
	stance = input
	if (stance != previous)
		stance_step = 0

/mob/living/simple_animal/hostile/halebeetle/think()
	. =..()
	safety = 0
	if (stat != CONSCIOUS)
		return

	if (life_tick % 5 == 0)
		update_bearmode()

	//This covers cases where the bear is damaged by things it can't detect.
	//Most notably, security bots, beepsky kept murdering them without resistance
	if (health < health_last_tick && stance != HOSTILE_STANCE_TIRED)
		anger++
		instant_aggro()

	if (life_tick % 30 == 0)//A point of anger wears off per minute
		anger = max(0, anger-1)

	switch(stance)
		if(HOSTILE_STANCE_TIRED)
			stop_automated_movement = 1
			stance_step++
			if(stance_step >= 15) //rests for 10 ticks
				if(target_mob && (target_mob in ListTargets(10)))
					set_stance(HOSTILE_STANCE_ATTACK) //If the mob he was chasing is still nearby, resume the attack, otherwise go idle.
				else
					set_stance(HOSTILE_STANCE_IDLE)

		if(HOSTILE_STANCE_ALERT)
			stop_automated_movement = 1
			var/found_mob = 0
			if(target_mob && (target_mob in ListTargets(10)) && !(SA_attackable(target_mob)))
				found_mob = 1
			else
				LoseTarget()

			if(target_mob)
				found_mob = 1


			if (found_mob)
				stance_step = max(0, stance_step) //If we have not seen a mob in a while, the stance_step will be negative, we need to reset it to 0 as soon as we see a mob again.
				stance_step++
				set_dir(get_dir(src,target_mob))	//Keep staring at the mob
				if(stance_step in list(1,4,7)) //every 3 ticks
					var/action = pick( list( "tilts its head at [target_mob]", "stares ominously at [target_mob]", "raises a scythelike blade and opens its mandibles towards [target_mob]", "closely watches [target_mob]" ) )
					if(action)
						custom_emote(VISIBLE_MESSAGE,action)
			else
				stance_step--

			if (anger && found_mob)
				instant_aggro()//If we're angry and someone is nearby, skip waiting and charge them

			if(stance_step <= -20*bearmode) //If we have not found a mob for 20-ish ticks, revert to idle mode
				set_stance(HOSTILE_STANCE_IDLE)
				stop_automated_movement = 0
			if(stance_step >= 12)   //If this mob just refuses to get out of our territory, then we attack
				anger += 3
				set_stance(HOSTILE_STANCE_ATTACK)


		if(HOSTILE_STANCE_ATTACKING)
			turns_since_hit++
			stance_step++
			if(stance_step >= (16+(anger*2))*bearmode)	//attacks a while, then it gets tired and needs to rest. An angry bear will chase longer
				tire_out()
				return

			//If we're having no luck attacking our current target
			if (target_mob && !Adjacent(target_mob) && turns_since_hit > 3)
				LoseTarget()
			else
				set_dir(get_dir(src,target_mob))

	health_last_tick = health

//Causes the bear to find and start attacking the nearest target.
//This will overwrite any existing target if a different one is closer
//If there are no other suitable targets, targeting will not be changed
/mob/living/simple_animal/hostile/halebeetle/FindTarget()

	var/turf/here = get_turf(src)
	var/mob/nearest_target = null
	var/nearest_dist = 99999
	var/mob/nearest_downed_target = null
	var/nearest_downed_dist = 99999

	for(var/atom/A in ListTargets(10))

		if(A == src || A == target_mob)//We're only interested in alternatives to our current target
			continue


		var/dist = get_dist(here, get_turf(A)) < nearest_dist
		if(isliving(A))
			var/mob/living/L = A
			if(L.faction == src.faction && !attack_same)
				continue
			else if(L in friends)
				continue
			else

				if(!L.client)
					continue

				if(L.stat == CONSCIOUS)
					if (dist < nearest_dist)
						nearest_target = L
						nearest_dist = dist

				else if (L.stat != DEAD)//Unconscious people are lower priority, only targeted if nobody nearby is standing
					if (dist < nearest_downed_dist)
						nearest_downed_target = L
						nearest_downed_dist = dist


		if(istype(A, /obj/machinery/bot))
			var/obj/machinery/bot/B = A
			if (B.health > 0)
				if (dist < nearest_dist)
					nearest_target = B
					nearest_dist = dist

	if (nearest_target && safety < 2)
		target_mob = nearest_target
		FoundTarget()
		return nearest_target
	else if (nearest_downed_target && safety < 2)
		target_mob = nearest_downed_target
		FoundTarget()
		return nearest_downed_target

	return target_mob
	//If neither of the above is true, dont change the target

/mob/living/simple_animal/hostile/halebeetle/SA_attackable(target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if((L.stat != DEAD))
			return (0)
	if (istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		if(B.health > 0)
			return (0)
	return 1


/mob/living/simple_animal/hostile/halebeetle/proc/tire_out()
	custom_emote(VISIBLE_MESSAGE, "is worn out and needs to rest." )
	set_stance(HOSTILE_STANCE_TIRED)
	speak_audio()
	stance_step = 0
	walk(src, 0) //This stops the bear's walking

/mob/living/simple_animal/hostile/halebeetle/spatial/tire_out()
	..()
	spawn(5)
		teleport()//Bluespace bears teleport away to rest

/mob/living/simple_animal/hostile/halebeetle/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/healthbefore = health
	..()
	spawn(1)
		if (health < healthbefore)//Hurting the bear makes it mad
			target_mob = user
			anger++
			instant_aggro(1)


/mob/living/simple_animal/hostile/halebeetle/attack_hand(mob/living/carbon/human/M as mob)
	var/healthbefore = health
	..()
	spawn(1)
		if (health < healthbefore)//Hurting the bear makes it mad
			target_mob = M
			anger++
			instant_aggro(1)


/mob/living/simple_animal/hostile/halebeetle/ex_act(var/severity = 2.0)
	var/healthbefore = health
	..()
	spawn(1)
		if (health < healthbefore)
			instant_aggro()


/mob/living/simple_animal/hostile/halebeetle/FoundTarget()
	if(target_mob)
		turns_since_hit = 0
		custom_emote(VISIBLE_MESSAGE,"stares alertly at [target_mob]")
		speak_audio()

		//If we're idle, move up to alert.
		//But don't drop down to alert if we're already in combat
		if (stance == HOSTILE_STANCE_IDLE)
			set_stance(HOSTILE_STANCE_ALERT)
		else if (stance == HOSTILE_STANCE_ATTACKING && !safety)
			MoveToTarget()

		safety++

/mob/living/simple_animal/hostile/halebeetle/LoseTarget()
	//If we're still angry, try to find someone else to attack
	if (anger)
		FindTarget()

	if (!anger || !target_mob)
		//If the anger has subsided, then give up the chase and let them go
		//But we'll get mad again soon if they don't go.
		if (stance > HOSTILE_STANCE_ALERT)//If we're currently above alert
			set_stance(HOSTILE_STANCE_ALERT)//Drop to alert and cease attacking
		target_mob = null
		walk(src, 0)

/mob/living/simple_animal/hostile/halebeetle/AttackingTarget()
	var/targetname = target_mob.name
	if(..())
		turns_since_hit = 0
		custom_emote(VISIBLE_MESSAGE, pick( list("crushes [targetname] in its mandibles","slashes at [targetname]", "bites [targetname]", "mauls [targetname]", "tears into [targetname]", "rends [targetname]") ) )
		if (prob(15))



/mob/living/simple_animal/hostile/halebeetle/proc/update_bearmode()
	turns_per_move = initial(turns_per_move)
	if (anger >= 3)
		turns_per_move -= 1


	var/former = bearmode
	bearmode = BEARMODE_INDOORS
	if(always_space_mode || loc && istype(loc,/turf/space))
		bearmode = BEARMODE_SPACE
	else
		if(istype(loc,/turf))
			var/turf/T = loc
			var/datum/gas_mixture/environment = T.return_air()
			if (environment.return_pressure() <= 80)
				bearmode = BEARMODE_SPACE

	if (bearmode != former)
		var/healthpercent
		if (bearmode == BEARMODE_SPACE)
			custom_emote(VISIBLE_MESSAGE, "looks bright, energised and aggressive!" )
			healthpercent = health / maxHealth
			maxHealth = initial(maxHealth) * 1.5
			health = maxHealth * healthpercent
			melee_damage_lower = initial(melee_damage_lower)*1.2
			melee_damage_upper = initial(melee_damage_upper)*1.2
			turns_per_move -= 2

		else
			custom_emote(VISIBLE_MESSAGE, "looks darker and more subdued." )
			healthpercent = health / maxHealth
			maxHealth = initial(maxHealth)
			health = maxHealth * healthpercent
			melee_damage_lower = initial(melee_damage_lower)
			melee_damage_upper = initial(melee_damage_upper)


	update_icon()


/mob/living/simple_animal/hostile/halebeetle/update_icon()
	if (stat == DEAD)
		icon_state = "halebeetle_dead"
	else if (bearmode == BEARMODE_INDOORS)
		icon_state = "bearfloor"
	else
		icon_state = "halebeetle"



#undef BEARMODE_INDOORS
#undef BEARMODE_SPACE
