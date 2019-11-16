#define BEARMODE_INDOORS 1
#define BEARMODE_SPACE 2

//Space bears!
/mob/living/simple_animal/hostile/bear
	name = "space bear"
	desc = "You should walk away, quickly!"
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	icon_gib = "bear_gib"
	//speak = list("RAWR!","Rawr!","GRR!","Growl!") Bears don't talk.
	speak_emote = list("growls", "roars")
	emote_hear = list("grumbles","grawls")
	emote_see = list("stares ferociously", "stomps")
	speak_chance = 10
	turns_per_move = 10
	see_in_dark = 6
	meat_type = /obj/item/reagent_containers/food/snacks/bearmeat
	meat_amount = 5
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"
	stop_automated_movement_when_pulled = 0
	maxHealth = 80
	melee_damage_lower = 10
	melee_damage_upper = 18
	break_stuff_probability = 80
	mob_size = 17
	butchering_products = list(/obj/item/clothing/head/bearpelt = 1)
	var/safety //used to prevent infinite loops
	var/turns_since_hit = 0//If the bear chases someone too long without hitting them, it will try to change to another nearby target instead

	attacktext = null//This allows custom attacking emotes

	var/quiet_sounds = list('sound/effects/creatures/bear_quiet_1.ogg',
	'sound/effects/creatures/bear_quiet_2.ogg',
	'sound/effects/creatures/bear_quiet_3.ogg',
	'sound/effects/creatures/bear_quiet_4.ogg',
	'sound/effects/creatures/bear_quiet_5.ogg',
	'sound/effects/creatures/bear_quiet_6.ogg')
	var/loud_sounds = list('sound/effects/creatures/bear_loud_1.ogg',
	'sound/effects/creatures/bear_loud_2.ogg',
	'sound/effects/creatures/bear_loud_3.ogg',
	'sound/effects/creatures/bear_loud_4.ogg')
	var/bearmode
	//Bears in space, or other low-pressure environments are stronger. Higher health, faster movement, longer aggression before being tired

	var/anger
	//An angry bear will immediately attack anyone it sees without warning
	//Anger decreases at 1 point per minute
	//Any amount of anger causes instant aggro, quantity of it is only a duration

	var/health_last_tick = 0

	//Space bears aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	var/stance_step = 0

	faction = "russian"

	var/always_space_mode = FALSE	// If true, bear will always be in BEARMODE_SPACE, regardless of surroundings.


//SPACE BEARS! SQUEEEEEEEE~     OW! FUCK! IT BIT MY HAND OFF!!
/mob/living/simple_animal/hostile/bear/Hudson
	name = "Hudson"
	desc = ""
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "pokes"

/mob/living/simple_animal/hostile/bear/Initialize()
	. = ..()
	emote_sounds = quiet_sounds
	update_bearmode()

/mob/living/simple_animal/hostile/bear/proc/set_stance(var/input)
	var/previous = stance
	stance = input
	if (stance != previous)
		stance_step = 0

/mob/living/simple_animal/hostile/bear/think()
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
				if(target_mob && target_mob in ListTargets(10))
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
					var/action = pick( list( "growls at [target_mob]", "stares angrily at [target_mob]", "prepares to attack [target_mob]", "closely watches [target_mob]" ) )
					if(action)
						custom_emote(1,action)
						speak_audio()
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
				growl_loud()

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
/mob/living/simple_animal/hostile/bear/FindTarget()

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

		else if(istype(A, /obj/mecha))
			var/obj/mecha/M = A
			if (M.occupant)
				if (dist < nearest_dist)
					nearest_target = M
					nearest_dist = dist

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

/mob/living/simple_animal/hostile/bear/SA_attackable(target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if((L.stat != DEAD))
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


/mob/living/simple_animal/hostile/bear/proc/tire_out()
	custom_emote(1, "is worn out and needs to rest." )
	set_stance(HOSTILE_STANCE_TIRED)
	speak_audio()
	stance_step = 0
	walk(src, 0) //This stops the bear's walking

/mob/living/simple_animal/hostile/bear/spatial/tire_out()
	..()
	spawn(5)
		teleport()//Bluespace bears teleport away to rest

/mob/living/simple_animal/hostile/bear/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/healthbefore = health
	..()
	spawn(1)
		if (health < healthbefore)//Hurting the bear makes it mad
			target_mob = user
			anger++
			instant_aggro(1)


/mob/living/simple_animal/hostile/bear/attack_hand(mob/living/carbon/human/M as mob)
	var/healthbefore = health
	..()
	spawn(1)
		if (health < healthbefore)//Hurting the bear makes it mad
			target_mob = M
			anger++
			instant_aggro(1)


/mob/living/simple_animal/hostile/bear/bullet_act(obj/item/projectile/P, def_zone)//Teleport around when shot, so its harder to burst it down with a carbine
	var/healthbefore = health
	..()
	spawn(1)
		if (health < healthbefore)
			instant_aggro()

/mob/living/simple_animal/hostile/bear/ex_act(var/severity = 2.0)
	var/healthbefore = health
	..()
	spawn(1)
		if (health < healthbefore)
			instant_aggro()


/mob/living/simple_animal/hostile/bear/Allow_Spacemove(var/check_drift = 0)
	inertia_dir = 0
	return 1	//No drifting in space for space bears!
	//Fixed this, it wasnt working

/mob/living/simple_animal/hostile/bear/FoundTarget()
	if(target_mob)
		turns_since_hit = 0
		custom_emote(1,"stares alertly at [target_mob]")
		speak_audio()

		//If we're idle, move up to alert.
		//But don't drop down to alert if we're already in combat
		if (stance == HOSTILE_STANCE_IDLE)
			set_stance(HOSTILE_STANCE_ALERT)
		else if (stance == HOSTILE_STANCE_ATTACKING && !safety)
			MoveToTarget()

		safety++

/mob/living/simple_animal/hostile/bear/LoseTarget()
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

/mob/living/simple_animal/hostile/bear/AttackingTarget()
	var/targetname = target_mob.name
	if(..())
		turns_since_hit = 0
		custom_emote(1, pick( list("crushes [targetname] in its arms","slashes at [targetname]", "bites [targetname]", "mauls [targetname]", "tears into [targetname]", "rends [targetname]") ) )
		if (prob(15))
			growl_loud()
		else if (prob(10))
			growl_soft()


/mob/living/simple_animal/hostile/bear/proc/update_bearmode()
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
			custom_emote(1, "looks bright, energised and aggressive!" )
			healthpercent = health / maxHealth
			maxHealth = initial(maxHealth) * 1.5
			health = maxHealth * healthpercent
			melee_damage_lower = initial(melee_damage_lower)*1.2
			melee_damage_upper = initial(melee_damage_upper)*1.2
			turns_per_move -= 2
			growl_loud()
		else
			custom_emote(1, "looks darker and more subdued." )
			healthpercent = health / maxHealth
			maxHealth = initial(maxHealth)
			health = maxHealth * healthpercent
			melee_damage_lower = initial(melee_damage_lower)
			melee_damage_upper = initial(melee_damage_upper)
			growl_soft()

	update_icons()


/mob/living/simple_animal/hostile/bear/update_icons()
	if (stat == DEAD)
		icon_state = "bear_dead"
	else if (bearmode == BEARMODE_INDOORS)
		icon_state = "bearfloor"
	else
		icon_state = "bear"


/mob/living/simple_animal/hostile/bear/speak_audio()
	if (anger > 5 || (anger && prob(25)))
		growl_loud()
	else
		growl_soft()


//Plays a random selection of six sounds, at a low volume
//This is triggered randomly periodically by the bear
/mob/living/simple_animal/hostile/bear/proc/growl_soft()
	var/sound = pick(quiet_sounds)
	playsound(src, sound, 50, 1,3, usepressure = 0)


//Plays a loud sound from a selection of four
//Played when bear is attacking or dies
/mob/living/simple_animal/hostile/bear/proc/growl_loud()
	var/sound = pick(loud_sounds)
	playsound(src, sound, 85, 1, 5, usepressure = 0)

//A special bear subclass which is more powerful and has the ability to teleport around to seek out prey.
//It dislikes other bears and refuses to cooperate with them. If two of them see each other, one or both will teleport away
//Therefore the crew never has to fight more than one at a time
/mob/living/simple_animal/hostile/bear/spatial
	name = "bluespace bear"
	desc = "*bzzt*..Rawr!!"
	maxHealth = 130
	turns_per_move = 7
	break_stuff_probability = 100//Constantly smashing everything nearby
	speak_chance = 15
	var/idletime
	var/focus_time//How long we've focused on this target
	var/teleport_delay = 60
	var/tactical_delay = 3//Procs between shortrange teleports
	var/datum/effect_system/sparks/spark_system
	always_space_mode = TRUE

/mob/living/simple_animal/hostile/bear/spatial/Initialize()
	. = ..()
	spark_system = bind_spark(src, 5)

/mob/living/simple_animal/hostile/bear/spatial/Destroy()
	QDEL_NULL(spark_system)
	return ..()

//Called when we want to bypass ticks and attack immediately. For example in response to being shot
//This calls several procs and some duplicated code from the parent class to immediately put us in an assault state and lash out
/mob/living/simple_animal/hostile/bear/proc/instant_aggro(var/forcechange = 0)//Set force to 1, if a specific target was designated just before calling this
	if (stance < HOSTILE_STANCE_ATTACK)
		growl_loud()
		if(!target_mob)
			FindTarget()

		if(target_mob)
			growl_loud()
			if(destroy_surroundings)
				DestroySurroundings()
			MoveToTarget()
			AttackTarget()//When first aggroed, this causes the bear to instantly lash out and counter any melee attacker nearby
		else
			set_stance(HOSTILE_STANCE_ALERT)
	else if (forcechange)
		MoveToTarget()

/mob/living/simple_animal/hostile/bear/spatial/think()
	..()
	if (stat != CONSCIOUS)
		return

	var/time_to_go = 0

	//If they've sat around too long without finding a mob to target, then they'll teleport elsewhere to seek prey
	if (stance == HOSTILE_STANCE_IDLE)
		idletime++
		if (idletime >= teleport_delay)
			time_to_go = 1
	else
		idletime = 0

	//Randomly make shortrange teleports in the vicinity of the target
	if ((stance == HOSTILE_STANCE_ATTACKING)&& target_mob)
		focus_time++
		if (focus_time % tactical_delay == 0)
			teleport_tactical(target_mob)

	//Teleport away from other bears
	for (var/mob/living/simple_animal/hostile/bear/bear in view(world.view, get_turf(src)))
		if (bear != src && bear.stat != DEAD)
			time_to_go = 1

	if (time_to_go)
		idletime = 0
		stance = HOSTILE_STANCE_IDLE
		teleport()
		growl_soft()

//Used to move to a new part of the station when it sees another bear, or it hasnt found any prey
/mob/living/simple_animal/hostile/bear/spatial/proc/teleport()
	if (stat == CONSCIOUS)
		var/area/A = random_station_area(TRUE) //Don't teleport to areas with players in them.
		var/turf/target = A.random_space()

		teleport_to(target)

//Used, with some luck, to reposition near the target. Hiding behind glass is a bad idea
//Picks a random tile in the target's area and teleports there. Might be closer, might be farther away
//Who knows, it's unpredictable. But definitely dangerous.
//This allows the target to escape as often as it allows the bear to attack
/mob/living/simple_animal/hostile/bear/spatial/proc/teleport_tactical()
	if (target_mob && stat == CONSCIOUS)
		var/area/A =  get_area(target_mob)
		if (A)
			var/turf/target = A.random_space()
			if (target)
				teleport_to(target)
				return 1
	return 0

/mob/living/simple_animal/hostile/bear/spatial/proc/teleport_to(var/turf/target)
	if (stat != CONSCIOUS)
		return

	spark(src.loc, 5)
	forceMove(target)
	spark_system.queue()

/mob/living/simple_animal/hostile/bear/spatial/bullet_act(obj/item/projectile/P, def_zone)//Teleport around when shot, so its harder to burst it down with a carbine
	..(P, def_zone)
	if (prob(P.damage*1.5))//Bear has a good chance of teleporting when shot, making it harder to burst down
		teleport_tactical()

/mob/living/simple_animal/hostile/bear/spatial/FoundTarget()
	..()
	focus_time = 0

#undef BEARMODE_INDOORS
#undef BEARMODE_SPACE
