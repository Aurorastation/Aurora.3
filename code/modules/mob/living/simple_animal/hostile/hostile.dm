/mob/living/simple_animal/hostile
	faction = "hostile"
	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior
	var/mob/living/target_mob
	var/belongs_to_station = FALSE
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
	attacktext = "hits"
	var/destroy_surroundings = 1
	a_intent = I_HURT
	hunger_enabled = 0//Until automated eating mechanics are enabled, disable hunger for hostile mobs
	var/shuttletarget = null
	var/enroute = 0

	// Vars to help find targets
	var/list/targets = list()
	var/attacked_times = 0
	var/list/target_type_validator_map = list()
	var/list/tolerated_types = list()
	var/attack_emote = "stares menacingly at"

	var/smart_melee = TRUE   // This makes melee mobs try to stay two tiles away from their target in combat, lunging in to attack only
	var/smart_ranged = FALSE // This makes ranged mob check for friendly fire and obstacles
	var/hostile_nameable = FALSE //If we can rename this hostile mob. Mostly to prevent repeat checks with guard dogs and hostile/retaliate farm animals

/mob/living/simple_animal/hostile/Initialize()
	. = ..()
	setup_target_type_validators()

/mob/living/simple_animal/hostile/proc/setup_target_type_validators()
	target_type_validator_map[/mob/living] = CALLBACK(src, PROC_REF(validator_living))
	target_type_validator_map[/obj/machinery/bot] = CALLBACK(src, PROC_REF(validator_bot))
	target_type_validator_map[/obj/machinery/porta_turret] = CALLBACK(src, PROC_REF(validator_turret))

/mob/living/simple_animal/hostile/Destroy()
	friends = null
	target_mob = null
	targets = null
	return ..()

/mob/living/simple_animal/hostile/can_name(var/mob/living/M)
	if(!hostile_nameable)
		to_chat(M, SPAN_WARNING("\The [src] cannot be renamed."))
		return FALSE
	return ..()


/mob/living/simple_animal/hostile/proc/FindTarget()
	if(!faction) //No faction, no reason to attack anybody.
		return null

	var/atom/T = null
	for (var/atom/A in targets)
		if(A == src)
			continue
		if(!isturf(A.loc))
			A = A.loc
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
		visible_message(SPAN_WARNING("\The [src] [attack_emote] [T]."))
		if(istype(T, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/H = T
			H.being_targeted(src)
	return T

// This proc is used when one hostile mob targets another hostile mob.
/mob/living/simple_animal/hostile/proc/being_targeted(var/mob/living/simple_animal/hostile/H)
	if(!H || target_mob == H)
		return
	target_mob = H
	FoundTarget()
	stance = HOSTILE_STANCE_ATTACKING
	visible_message(SPAN_WARNING("\The [src] gets taunted by \the [H] and begins to retaliate!"))

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
	return check_los(src, target_mob)

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
			var/move_distance = smart_melee ? 2 : 1
			walk_to(src, target_mob, move_distance, move_to_delay)

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
	if(!ranged)
		step_to(src, target_mob, 1)
	if(get_dist(src, target_mob) <= 1)	//Attacking
		AttackingTarget()
		attacked_times += 1
		return 1
	else
		return 0

/mob/living/simple_animal/hostile/proc/on_attack_mob(var/mob/hit_mob)
	return

/mob/living/simple_animal/hostile/proc/AttackingTarget()
	setClickCooldown(attack_delay)
	if(!Adjacent(target_mob))
		return
	if(!canmove)
		return
	if(!see_target())
		LoseTarget()
	for(var/grab in grabbed_by)
		var/obj/item/grab/G = grab
		if(G.state >= GRAB_NECK)
			visible_message(SPAN_WARNING("\The [G.assailant] restrains \the [src] from attacking!"))
			resist_grab()
			return
	var/atom/target
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext, armor_penetration, attack_flags)
		on_attack_mob(L)
		target = L
	else if(istype(target_mob, /obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext)
		target = B
	else if(istype(target_mob, /obj/machinery/porta_turret))
		var/obj/machinery/porta_turret/T = target_mob
		if(!T.raising && !T.raised)
			return
		face_atom(T)
		src.do_attack_animation(T)
		T.take_damage(max(melee_damage_lower, melee_damage_upper) / 2)
		visible_message(SPAN_DANGER("\The [src] [attacktext] \the [T]!"))
		return T // no need to take a step back here
	if(target)
		face_atom(target)
		if(!ranged && smart_melee)
			addtimer(CALLBACK(src, PROC_REF(PostAttack), target), 0.6 SECONDS)
		return target

/mob/living/simple_animal/hostile/proc/PostAttack(var/atom/target)
	if(stat)
		return
	if(!isturf(loc)) // no teleporting out of lockers
		return
	for(var/grab in grabbed_by)
		var/obj/item/grab/G = grab
		if(G.state >= GRAB_AGGRESSIVE)
			return
	facing_dir = get_dir(src, target)
	if(ishuman(target))
		step_away(src, pick(RANGE_TURFS(2, target)))
	else
		step_away(src, target, 2)
	facing_dir = null

/mob/living/simple_animal/hostile/proc/LoseTarget()
	stance = HOSTILE_STANCE_IDLE
	target_mob = null
	walk(src, 0)
	LostTarget()

/mob/living/simple_animal/hostile/proc/LostTarget()
	return

/mob/living/simple_animal/hostile/proc/ListTargets(var/dist = 7)
	var/list/L = view(src, dist)
	return L

/mob/living/simple_animal/hostile/death()
	..()
	walk(src, 0)

/mob/living/simple_animal/hostile/think()
	..()

	if(stop_thinking)
		return

	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			targets = get_targets_in_LOS(10, src)
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
				targets = get_targets_in_LOS(10, src)
				target_mob = FindTarget()
				attacked_times = 0


/mob/living/simple_animal/hostile/proc/OpenFire(target_mob)
	if(!see_target())
		LoseTarget()
	var/target = target_mob
	// This code checks if we are not going to hit our target
	if(smart_ranged && !check_fire(target_mob))
		return
	visible_message(SPAN_DANGER("[capitalize_first_letters(src.name)] fires at \the [target]!"))

	if(rapid)
		var/datum/callback/shoot_cb = CALLBACK(src, PROC_REF(shoot_wrapper), target, loc, src)
		addtimer(shoot_cb, 1)
		addtimer(shoot_cb, 4)
		addtimer(shoot_cb, 6)
	else
		shoot_wrapper(target, loc, src)

	stance = HOSTILE_STANCE_IDLE
	target_mob = null

/mob/living/simple_animal/hostile/proc/check_fire(target_mob)
	if(!target_mob)
		return FALSE

	var/target_hit = FALSE
	var/flags = ispath(projectiletype, /obj/item/projectile/beam) ? PASSTABLE|PASSGLASS|PASSGRILLE : PASSTABLE
	for(var/V in check_trajectory(target_mob, src, pass_flags=flags))
		if(V == target_mob)
			target_hit = TRUE
		if(ismob(V))
			var/mob/M = V
			if((M.faction == faction) || (M in friends))
				return FALSE
		if(validator_e_field(V, null))
			target_hit = TRUE

	return target_hit

/mob/living/simple_animal/hostile/proc/shoot_wrapper(target, location, user)
	Shoot(target, location, user)
	if(casingtype)
		new casingtype(loc)
		playsound(src, /singleton/sound_category/casing_drop_sound, 50, TRUE)

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
			var/obj/effect/energy_field/e = locate(/obj/effect/energy_field, get_step(src, dir))
			if(e && !e.invisibility && e.density)
				e.Stress(rand(0.5, 1.5))
				visible_message(SPAN_DANGER("[capitalize_first_letters(src.name)] [attacktext] \the [e]!"))
				src.do_attack_animation(e)
				target_mob = e
				stance = HOSTILE_STANCE_ATTACKING
				return TRUE
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
	if(evacuation_controller.is_prepared())
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
	if(ismech(L))
		var/mob/living/heavy_vehicle/M = L
		if(!M.pilots?.len)
			return FALSE

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
	if(tolerated_types[L.type] == TRUE)
		return FALSE
	return FALSE

/mob/living/simple_animal/hostile/proc/validator_bot(var/obj/machinery/bot/B, var/atom/current)
	if(isliving(current)) // We prefer mobs over anything else
		return FALSE
	if (B.health > 0)
		return TRUE
	else
		return FALSE

/mob/living/simple_animal/hostile/proc/validator_turret(var/obj/machinery/porta_turret/T, var/atom/current)
	if(isliving(current)) // We prefer mobs over anything else
		return FALSE
	return !(T.health <= 0)

/mob/living/simple_animal/hostile/proc/validator_e_field(var/obj/effect/energy_field/E, var/atom/current)
	if(isliving(current)) // We prefer mobs over anything else
		return FALSE
	if(get_dist(src, E) < get_dist(src, current))
		return TRUE
	else
		return FALSE
