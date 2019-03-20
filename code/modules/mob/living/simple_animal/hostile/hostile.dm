/mob/living/simple_animal/hostile
	faction = "hostile"
	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior
	var/mob/living/target_mob
	var/attack_same = 0
	var/ranged = 0
	var/rapid = 0
	var/projectiletype
	var/projectilesound
	var/casingtype
	var/move_to_delay = 4 //delay for the automated movement.
	var/attack_delay = DEFAULT_ATTACK_COOLDOWN
	var/list/friends = list()
	var/break_stuff_probability = 10
	stop_automated_movement_when_pulled = 0
	var/destroy_surroundings = 1
	a_intent = I_HURT
	hunger_enabled = 0//Until automated eating mechanics are enabled, disable hunger for hostile mobs
	var/shuttletarget = null
	var/enroute = 0

	// Vars to help find targets
	var/list/targets = list()
	var/attacked_times = 0
	var/list/target_type_validator_map = list()
	var/attack_emote = "stares menacingly at"

	var/smart = FALSE // This makes ranged mob check for friendly fire and obstacles

/mob/living/simple_animal/hostile/Initialize()
	. = ..()
	target_type_validator_map[/mob/living] = CALLBACK(src, .proc/validator_living)
	target_type_validator_map[/obj/mecha] = CALLBACK(src, .proc/validator_mecha)
	target_type_validator_map[/obj/machinery/bot] = CALLBACK(src, .proc/validator_bot)

/mob/living/simple_animal/hostile/Destroy()
	friends = null
	target_mob = null
	targets = null
	return ..()

/mob/living/simple_animal/hostile/proc/FindTarget()
	if(!faction) //No faction, no reason to attack anybody.
		return null

	var/atom/T = null
	for (var/atom/A in targets)
		if(A == src)
			continue
		var/datum/callback/cb = null
		for (var/type in target_type_validator_map)
			if (istype(A, type))
				cb = target_type_validator_map[type]
				break

		if (!cb)
			continue
		else if (!istype(cb) || cb.Invoke(A, T))
			T = A

	stop_automated_movement = 0

	if (T != target_mob)
		target_mob = T
		FoundTarget()
	if(!isnull(T))
		stance = HOSTILE_STANCE_ATTACK
	if(isliving(T))
		custom_emote(1,"[attack_emote] [T]")
	return T

/mob/living/simple_animal/hostile/bullet_act(var/obj/item/projectile/P, var/def_zone)
	..()
	if (ismob(P.firer) && target_mob != P.firer)
		target_mob = P.firer
		stance = HOSTILE_STANCE_ATTACK

/mob/living/simple_animal/hostile/attackby(var/obj/item/O, var/mob/user)
	..()
	if(target_mob != user)
		target_mob = user
		stance = HOSTILE_STANCE_ATTACK

mob/living/simple_animal/hostile/hitby(atom/movable/AM as mob|obj,var/speed = THROWFORCE_SPEED_DIVISOR)//Standardization and logging -Sieve
	..()
	if(istype(AM,/obj/))
		var/obj/O = AM
		if((target_mob != O.thrower) && ismob(O.thrower))
			target_mob = O.thrower
			stance = HOSTILE_STANCE_ATTACK

/mob/living/simple_animal/hostile/attack_generic(var/mob/user, var/damage, var/attack_message)
	..()
	if(target_mob != user)
		target_mob = user
		stance = HOSTILE_STANCE_ATTACK

/mob/living/simple_animal/hostile/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(target_mob != M)
		target_mob = M
		stance = HOSTILE_STANCE_ATTACK

//This proc is called after a target is acquired
/mob/living/simple_animal/hostile/proc/FoundTarget()
	return

/mob/living/simple_animal/hostile/proc/Found(var/atom/A)
	return

/mob/living/simple_animal/hostile/proc/see_target()
	return (target_mob in view(7, src)) ? (TRUE) : (FALSE)

/mob/living/simple_animal/hostile/proc/MoveToTarget()
	stop_automated_movement = 1
	if(QDELETED(target_mob) || SA_attackable(target_mob))
		LoseTarget()
	if(!see_target())
		LoseTarget()
	if(target_mob in targets)
		if(ranged)
			if(get_dist(src, target_mob) <= 6)
				walk(src, 0) // We gotta stop moving if we are in range
				OpenFire(target_mob)
			else
				walk_to(src, target_mob, 6, move_to_delay)
		else
			stance = HOSTILE_STANCE_ATTACKING
			walk_to(src, target_mob, 1, move_to_delay)

/mob/living/simple_animal/hostile/proc/AttackTarget()

	stop_automated_movement = 1
	if(QDELETED(target_mob) || SA_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in targets))
		LoseTarget()
		return 0
	if(!see_target())
		LoseTarget()
	if(get_dist(src, target_mob) <= 1)	//Attacking
		AttackingTarget()
		attacked_times += 1
		return 1
	else
		return 0

/mob/living/simple_animal/hostile/proc/AttackingTarget()
	setClickCooldown(attack_delay)
	if(!Adjacent(target_mob))
		return
	if(!see_target())
		LoseTarget()
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return L
	if(istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return M
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return B

/mob/living/simple_animal/hostile/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	walk(src, 0)
	LostTarget()

/mob/living/simple_animal/hostile/proc/LostTarget()
	return

/mob/living/simple_animal/hostile/proc/ListTargets(var/dist = 7)
	var/list/L = view(src, dist)

	for (var/obj/mecha/M in mechas_list)
		if (M.z == src.z && get_dist(src, M) <= dist)
			L += M

	return L

/mob/living/simple_animal/hostile/death()
	..()
	walk(src, 0)

/mob/living/simple_animal/hostile/think()
	..()
	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			targets = ListTargets(10)
			target_mob = FindTarget()
			if(destroy_surroundings && isnull(target_mob))
				DestroySurroundings()

		if(HOSTILE_STANCE_ATTACK)
			if(destroy_surroundings)
				DestroySurroundings(TRUE)
			MoveToTarget()

		if(HOSTILE_STANCE_ATTACKING)
			if(!AttackTarget() && destroy_surroundings)	//hit a window OR a mob, not both at once
				DestroySurroundings(TRUE)
			if(attacked_times >= rand(0, 4))
				targets = ListTargets(10)
				target_mob = FindTarget()
				attacked_times = 0


/mob/living/simple_animal/hostile/proc/OpenFire(target_mob)
	if(!see_target())
		LoseTarget()
	var/target = target_mob
	// This code checks if we are not going to hit our target
	if(smart && !check_fire(target_mob))
		return
	visible_message("<span class='warning'> <b>[src]</b> fires at [target]!</span>")

	if(rapid)
		var/datum/callback/shoot_cb = CALLBACK(src, .proc/shoot_wrapper, target, loc, src)
		addtimer(shoot_cb, 1)
		addtimer(shoot_cb, 4)
		addtimer(shoot_cb, 6)

	else
		Shoot(target, src.loc, src)
		if(casingtype)
			new casingtype(loc)

	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	return

/mob/living/simple_animal/hostile/proc/check_fire(target_mob)
	if(!target_mob)
		return FALSE

	var/target_hit = FALSE

	for(var/mob/M in check_trajectory(target_mob, src, pass_flags=PASSTABLE))
		if(M == target_mob)
			target_hit = TRUE
		if((M.faction == faction) || (M in friends))
			return FALSE

	return target_hit

/mob/living/simple_animal/hostile/proc/shoot_wrapper(target, location, user)
	Shoot(target, location, user)
	if (casingtype)
		new casingtype(loc)

/mob/living/simple_animal/hostile/proc/Shoot(var/target, var/start, var/mob/user, var/bullet = 0)
	if(target == start)
		return

	var/obj/item/projectile/A = new projectiletype(user.loc)
	playsound(user, projectilesound, 100, 1)
	if(!A)	return
	var/def_zone = get_exposed_defense_zone(target)
	A.launch_projectile(target, def_zone)

/mob/living/simple_animal/hostile/proc/DestroySurroundings(var/bypass_prob = FALSE)
	if(prob(break_stuff_probability) || bypass_prob) //bypass_prob is used to make mob destroy things in the way to our target
		for(var/dir in cardinal) // North, South, East, West
			for(var/obj/structure/window/obstacle in get_step(src, dir))
				if(obstacle.dir == reverse_dir[dir]) // So that windows get smashed in the right order
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return 1
			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, dir))
			if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille))
				obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
				return 1
	return 0

/mob/living/simple_animal/hostile/RangedAttack(atom/A, params) //Player firing
	if(ranged)
		setClickCooldown(attack_delay)
		target_mob = A
		OpenFire(A)
	..()


/mob/living/simple_animal/hostile/proc/check_horde()
	return 0
	if(emergency_shuttle.shuttle.location)
		if(!enroute && !target_mob)	//The shuttle docked, all monsters rush for the escape hallway
			if(!shuttletarget && escape_list.len) //Make sure we didn't already assign it a target, and that there are targets to pick
				shuttletarget = pick(escape_list) //Pick a shuttle target
			enroute = 1
			stop_automated_movement = 1
			spawn()
				if(!src.stat)
					horde()

		if(get_dist(src, shuttletarget) <= 2)		//The monster reached the escape hallway
			enroute = 0
			stop_automated_movement = 0

/mob/living/simple_animal/hostile/proc/horde()
	var/turf/T = get_step_to(src, shuttletarget)
	for(var/atom/A in T)
		if(istype(A,/obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/D = A
			D.open(1)
		else if(istype(A,/obj/structure/simple_door))
			var/obj/structure/simple_door/D = A
			if(D.density)
				D.Open()
		else if(istype(A,/obj/structure/cult/pylon))
			A.attack_generic(src, rand(melee_damage_lower, melee_damage_upper))
		else if(istype(A, /obj/structure/window) || istype(A, /obj/structure/closet) || istype(A, /obj/structure/table) || istype(A, /obj/structure/grille))
			A.attack_generic(src, rand(melee_damage_lower, melee_damage_upper))
	Move(T)
	target_mob = FindTarget()
	if(!target_mob || enroute)
		spawn(10)
			if(!src.stat)
				horde()

//////////////////////////////
///////VALIDATOR PROCS////////
//////////////////////////////

/mob/living/simple_animal/hostile/proc/validator_living(var/mob/living/L, var/atom/current)
	if((L.faction == src.faction) && !attack_same)
		return FALSE
	if(L in friends)
		return FALSE
	if(!L.stat)
		var/current_health = INFINITY
		if (isliving(current))
			var/mob/living/M = current
			current_health = M.health
		if(L.health < current_health)
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/proc/validator_mecha(var/obj/mecha/M, var/atom/current)
	if(isliving(current)) // We prefer mobs over anything else
		return FALSE
	if (M.occupant)
		return TRUE
	else
		return FALSE

/mob/living/simple_animal/hostile/proc/validator_bot(var/obj/machinery/bot/B, var/atom/current)
	if(isliving(current)) // We prefer mobs over anything else
		return FALSE
	if (B.health > 0)
		return TRUE
	else
		return FALSE
