ABSTRACT_TYPE(/mob/living/simple_animal/hostile)
	faction = "hostile"
	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior

	/**
	 * This is (generally?) set by `/FindTarget()` when a target to attack is found
	 *
	 * **The only way you should ever set this is by calling `set_last_found_target()`**,
	 * **and the only way you should ever clear this is by calling `unset_last_found_target()`**
	 *
	 * Despite being typed as an atom, this can ever be only a /mob, /turf or /obj
	 */
	var/atom/last_found_target

	var/belongs_to_station = FALSE
	var/attack_same = 0
	var/ranged = 0
	var/rapid = 0
	var/ranged_attack_range = 6
	var/projectiletype
	var/projectilesound
	var/casingtype
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
	var/obj/effect/landmark/mob_waypoint/target_waypoint = null // The waypoint mobs that are spawned by mapped in spawners move to

	// Vars to help find targets
	var/list/targets = list()
	var/attacked_times = 0
	var/list/target_type_validator_map = list()
	var/list/tolerated_types = list()
	var/attack_emote = "stares menacingly at"

	var/smart_melee = TRUE   // This makes melee mobs try to stay two tiles away from their target in combat, lunging in to attack only
	var/smart_ranged = FALSE // This makes ranged mob check for friendly fire and obstacles
	var/hostile_nameable = FALSE //If we can rename this hostile mob. Mostly to prevent repeat checks with guard dogs and hostile/retaliate farm animals

	var/is_fast_processing = FALSE

	// actions measured in deciseconds
	var/hostile_time_between_attacks = 10
	var/hostile_last_attack = 0

/mob/living/simple_animal/hostile/Initialize()
	. = ..()
	setup_target_type_validators()

/mob/living/simple_animal/hostile/Destroy()
	friends = null
	last_found_target = null
	targets = null
	target_type_validator_map = null
	return ..()


/mob/living/simple_animal/hostile/proc/setup_target_type_validators()
	target_type_validator_map[/mob/living] = CALLBACK(src, PROC_REF(validator_living))
	target_type_validator_map[/obj/machinery/bot] = CALLBACK(src, PROC_REF(validator_bot))
	target_type_validator_map[/obj/machinery/porta_turret] = CALLBACK(src, PROC_REF(validator_turret))

/mob/living/simple_animal/hostile/can_name(var/mob/living/M)
	if(!hostile_nameable)
		to_chat(M, SPAN_WARNING("\The [src] cannot be renamed."))
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/proc/FindTarget()
	if(!faction) //No faction, no reason to attack anybody.
		return null

	var/atom/T = null
	var/target_range = INFINITY
	for (var/atom/A in targets)
		if(A == src || QDELING(A)) //Avoid targeting ourself, and targets that are being GC'd
			continue
		if(ismob(A)) //Don't target mobs with keys that have logged out.
			var/mob/M = A
			if(M.key && !M.client)
				continue
		if(isliving(A))
			var/mob/living/M = A
			if(M.paralysis)
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
			var/range_to_atom = get_dist(src, A)
			if(range_to_atom < target_range)
				T = A
				target_range = range_to_atom

	stop_automated_movement = 0

	if (T != last_found_target)
		set_last_found_target(T)
		FoundTarget()
		if(isliving(T))
			visible_message(SPAN_WARNING("\The [src] [attack_emote] [T]."))
			if(istype(T, /mob/living/simple_animal/hostile))
				var/mob/living/simple_animal/hostile/H = T
				H.being_targeted(src)
	if(!isnull(T))
		change_stance(HOSTILE_STANCE_ATTACK)
	return T

// This proc is used when one hostile mob targets another hostile mob.
/mob/living/simple_animal/hostile/proc/being_targeted(var/mob/living/simple_animal/hostile/H)
	if(!H || last_found_target == H)
		return
	set_last_found_target(H)
	FoundTarget()
	change_stance(HOSTILE_STANCE_ATTACKING)
	visible_message(SPAN_WARNING("\The [src] gets taunted by \the [H] and begins to retaliate!"))

/mob/living/simple_animal/hostile/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	if (ismob(hitting_projectile.firer) && last_found_target != hitting_projectile.firer)
		set_last_found_target(hitting_projectile.firer)
		change_stance(HOSTILE_STANCE_ATTACK)

/mob/living/simple_animal/hostile/handle_attack_by(var/mob/user)
	..()
	if(last_found_target != user)
		set_last_found_target(user)
		change_stance(HOSTILE_STANCE_ATTACK)

/mob/living/simple_animal/hostile/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	..()
	if(isobj(hitting_atom))
		if((last_found_target != throwingdatum?.thrower?.resolve()) && ismob(throwingdatum?.thrower?.resolve()))
			var/atom/tmp_target_mob = throwingdatum.thrower.resolve()
			if(!QDELETED(tmp_target_mob))
				set_last_found_target(tmp_target_mob)
			change_stance(HOSTILE_STANCE_ATTACK)

/mob/living/simple_animal/hostile/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	..()
	if(last_found_target != user)
		set_last_found_target(user)
		change_stance(HOSTILE_STANCE_ATTACK)

/mob/living/simple_animal/hostile/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if(last_found_target != M)
		set_last_found_target(M)
		change_stance(HOSTILE_STANCE_ATTACK)

//This proc is called after a target is acquired
/mob/living/simple_animal/hostile/proc/FoundTarget()
	return

/mob/living/simple_animal/hostile/proc/see_target(atom/target)
	SHOULD_NOT_SLEEP(TRUE)

	if(!target)
		stack_trace("see_target() called with null target!")
		return FALSE

	return is_in_sight(src, target)

/mob/living/simple_animal/hostile/proc/MoveToTarget()
	stop_automated_movement = 1

	//If the target doesn't exist, is not attackable or we can't see it, lose it and bail
	if(QDELETED(last_found_target) || SA_attackable(last_found_target) || !see_target(last_found_target))
		LoseTarget()
		return

	if(last_found_target in targets)
		if(ranged)
			if(get_dist(src, last_found_target) <= ranged_attack_range)
				GLOB.move_manager.stop_looping(src)
				OpenFire(last_found_target)
			else
				GLOB.move_manager.move_to(src, last_found_target, 6, speed)
		else
			change_stance(HOSTILE_STANCE_ATTACKING)
			GLOB.move_manager.move_to(src, last_found_target, 1, speed)

/**
 * Attack the mob set in `target_mob`
 *
 * If the attack cannot be performed, return FALSE, otherwise return TRUE
 *
 * "Cannot be performed" means that the mob isn't attackable, not that eg. it parried the attack, whatever
 * happens to the attack itself isn't our concern, if we can reach and wack it is
 */
/mob/living/simple_animal/hostile/proc/AttackTarget()
	. = FALSE //We return FALSE by default
	stop_automated_movement = 1
	if(QDELETED(last_found_target) || SA_attackable(last_found_target) || !see_target(last_found_target))
		LoseTarget()
		return

	if(ismob(last_found_target)) //target_mob is not in fact always a mob
		var/mob/mob_target = last_found_target
		if(mob_target.key && !mob_target.client)
			LoseTarget()
			return

	if(!(last_found_target in targets))
		LoseTarget()
		return

	if(ON_ATTACK_COOLDOWN(src))
		return

	if(get_dist(src, last_found_target) <= 1)	//Attacking
		AttackingTarget()
		attacked_times += 1
		hostile_last_attack = world.time
		return TRUE //We have attacked, so return TRUE

/mob/living/simple_animal/hostile/proc/on_attack_mob(var/mob/hit_mob, var/obj/item/organ/external/limb)
	if(isliving(hit_mob) && istype(limb))
		limb.add_autopsy_data("Mauling by [src.name]")

/mob/living/simple_animal/hostile/proc/AttackingTarget()
	if(QDELETED(last_found_target) || !see_target(last_found_target) || !Adjacent(last_found_target))
		LoseTarget()
		return

	if(!canmove)
		return

	setClickCooldown(attack_delay)

	for(var/grab in grabbed_by)
		var/obj/item/grab/G = grab
		if(G.state >= GRAB_NECK)
			visible_message(SPAN_WARNING("\The [G.assailant] restrains \the [src] from attacking!"))
			resist_grab()
			return
	var/atom/target
	if(isliving(last_found_target))
		var/mob/living/L = last_found_target
		if(L.paralysis)
			return
		on_attack_mob(L, L.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext, environment_smash, armor_penetration, attack_flags, damage_type))
		target = L
	else if(istype(last_found_target, /obj/machinery/bot))
		var/obj/machinery/bot/B = last_found_target
		B.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext)
		target = B
	else if(istype(last_found_target, /obj/machinery/porta_turret))
		var/obj/machinery/porta_turret/T = last_found_target
		if(!T.raising && !T.raised)
			return
		face_atom(T)
		src.do_attack_animation(T)
		T.take_damage(max(melee_damage_lower, melee_damage_upper) / 2)
		visible_message(SPAN_DANGER("\The [src] [attacktext] \the [T]!"))
		return T // no need to take a step back here
	if(loc && attack_sound)
		playsound(loc, attack_sound, 50, 1, 1)
	if(target)
		face_atom(target)
		if(!ranged && smart_melee)
			addtimer(CALLBACK(src, PROC_REF(PostAttack), target), 1.2 SECONDS)
		return target

/mob/living/simple_animal/hostile/proc/PostAttack(var/atom/target)
	if(QDELETED(target))
		return

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
	change_stance(HOSTILE_STANCE_IDLE)
	unset_last_found_target()
	GLOB.move_manager.stop_looping(src)
	LostTarget()

/mob/living/simple_animal/hostile/proc/LostTarget()
	return

/mob/living/simple_animal/hostile/proc/get_targets(dist = world.view)
	return get_hearers_in_LOS(dist, src)

/mob/living/simple_animal/hostile/death()
	..()
	GLOB.move_manager.stop_looping(src)
	LoseTarget() //Ensure we always stop chasing upon death

/mob/living/simple_animal/hostile/think()
	..()

	if(stop_thinking)
		return

	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			targets = get_targets(10)
			FindTarget()
			if(destroy_surroundings && !last_found_target)
				DestroySurroundings()

		if(HOSTILE_STANCE_ATTACK)
			if(destroy_surroundings)
				DestroySurroundings(TRUE)
			MoveToTarget()

		if(HOSTILE_STANCE_ATTACKING)
			if(!AttackTarget() && destroy_surroundings)	//hit a window OR a mob, not both at once
				DestroySurroundings(TRUE)
			if(attacked_times >= rand(0, 4))
				targets = get_targets(10)
				FindTarget()
				attacked_times = 0

/mob/living/simple_animal/hostile/proc/change_stance(var/new_stance)
	if(new_stance == stance)
		return FALSE

	stance = new_stance
	switch(stance)
		if(HOSTILE_STANCE_IDLE)
			MOB_SHIFT_TO_NORMAL_THINKING(src)
		if(HOSTILE_STANCE_ALERT)
			MOB_SHIFT_TO_FAST_THINKING(src)
		if(HOSTILE_STANCE_ATTACK)
			MOB_SHIFT_TO_FAST_THINKING(src)
		if(HOSTILE_STANCE_ATTACKING)
			MOB_SHIFT_TO_FAST_THINKING(src)
		if(HOSTILE_STANCE_TIRED)
			MOB_SHIFT_TO_NORMAL_THINKING(src)

	return TRUE

/**
 * Handles the logic of firing at a target for the hostile mob
 *
 * * target - The atom to fire at
 * * ignore_visibility - Whether or not to ignore the visibility check
 */
/mob/living/simple_animal/hostile/proc/OpenFire(atom/target, ignore_visibility = FALSE)
	set waitfor = FALSE

	if(QDELETED(target))
		LoseTarget()
		return

	if(!ignore_visibility && !see_target(target))
		LoseTarget()
		return

	// This code checks if we are not going to hit our target
	if(smart_ranged && !check_fire(target))
		return
	if(ON_ATTACK_COOLDOWN(src))
		return
	visible_message(SPAN_DANGER("[capitalize_first_letters(src.name)] fires at \the [target]!"))
	hostile_last_attack = world.time

	if(rapid)
		var/datum/callback/shoot_cb = CALLBACK(src, PROC_REF(shoot_wrapper), target, loc, src)
		addtimer(shoot_cb, 1)
		addtimer(shoot_cb, 4)
		addtimer(shoot_cb, 6)
	else
		shoot_wrapper(target, loc, src)

	change_stance(HOSTILE_STANCE_IDLE)
	unset_last_found_target()

/mob/living/simple_animal/hostile/proc/check_fire(atom/target)
	if(!target)
		return FALSE

	var/target_hit = FALSE
	var/flags = ispath(projectiletype, /obj/projectile/beam) ? PASSTABLE|PASSGLASS|PASSGRILLE : PASSTABLE
	for(var/V in check_trajectory(target, src, pass_flags=flags))
		if(V == target)
			target_hit = TRUE
		if(ismob(V))
			var/mob/M = V
			if((M.faction == faction) || (M in friends))
				return FALSE
		if(validator_e_field(V, null))
			target_hit = TRUE

	return target_hit

/mob/living/simple_animal/hostile/proc/shoot_wrapper(atom/target, location, user)
	Shoot(target, location, user)
	if(casingtype)
		new casingtype(loc)
		playsound(src, /singleton/sound_category/casing_drop_sound, 50, TRUE)

/mob/living/simple_animal/hostile/proc/Shoot(var/target, var/start, var/mob/user, var/bullet = 0)
	if(target == start)
		return

	// var/def_zone = get_exposed_defense_zone(target)

	fire_projectile(/obj/projectile, target, projectilesound, firer = user)

/mob/living/simple_animal/hostile/proc/DestroySurroundings(var/bypass_prob = FALSE)
	if(ON_ATTACK_COOLDOWN(src))
		return FALSE

	if(prob(break_stuff_probability) || bypass_prob) //bypass_prob is used to make mob destroy things in the way to our target
		for(var/card_dir in GLOB.cardinals) // North, South, East, West
			var/turf/target_turf = get_step(src, card_dir)
			var/obj/found_obj = null

			found_obj = locate(/obj/effect/energy_field) in target_turf
			if(found_obj && !found_obj.invisibility && found_obj.density)
				var/obj/effect/energy_field/e = found_obj
				e.Stress(rand(0.5, 1.5))
				visible_message(SPAN_DANGER("[capitalize_first_letters(src.name)] [attacktext] \the [e]!"))
				src.do_attack_animation(e)
				set_last_found_target(e)
				change_stance(HOSTILE_STANCE_ATTACKING)
				hostile_last_attack = world.time
				return TRUE

			found_obj = locate(/obj/structure/window) in target_turf
			if(found_obj)
				if((found_obj.atom_flags & ATOM_FLAG_CHECKS_BORDER) && found_obj.dir != REVERSE_DIR(card_dir))
					continue
				found_obj.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext, TRUE)
				hostile_last_attack = world.time
				return TRUE

			found_obj = locate(/obj/structure/window_frame) in target_turf
			if(found_obj)
				found_obj.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext, TRUE)
				hostile_last_attack = world.time
				return TRUE

			found_obj = locate(/obj/structure/closet) in target_turf
			if(found_obj)
				found_obj.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext, TRUE)
				hostile_last_attack = world.time
				return TRUE

			found_obj = locate(/obj/structure/table) in target_turf
			if(found_obj)
				var/obj/structure/table/table = found_obj
				if(!table.breakable)
					continue
				found_obj.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext, TRUE)
				hostile_last_attack = world.time
				return TRUE

			found_obj = locate(/obj/structure/grille) in target_turf
			if(found_obj)
				found_obj.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext, TRUE)
				hostile_last_attack = world.time
				return TRUE

			found_obj = locate(/obj/structure/girder) in target_turf
			if(found_obj)
				found_obj.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext, TRUE)
				hostile_last_attack = world.time
				return TRUE

			found_obj = null
			for (var/obj/structure/barricade/B in target_turf)
				found_obj = B
				break
			if(found_obj)
				found_obj.attack_generic(src, rand(melee_damage_lower, melee_damage_upper), attacktext, TRUE)
				hostile_last_attack = world.time
				return TRUE
		return FALSE

/mob/living/simple_animal/hostile/RangedAttack(atom/A, params) //Player firing
	if(ranged)
		setClickCooldown(attack_delay)
		set_last_found_target(A)
		OpenFire(A)
		return
	else
		var/turf/turf_attacking = get_step(src, get_compass_dir(src, A))
		if(turf_attacking)
			var/mob/living/target = locate() in turf_attacking
			if(target && Adjacent(target))
				return UnarmedAttack(target, TRUE)
	return ..()

/mob/living/simple_animal/hostile/proc/check_horde()
	if(GLOB.evacuation_controller.is_prepared())
		if(!enroute && !last_found_target)	//The shuttle docked, all monsters rush for the escape hallway
			if(!shuttletarget && GLOB.escape_list.len) //Make sure we didn't already assign it a target, and that there are targets to pick
				shuttletarget = pick(GLOB.escape_list) //Pick a shuttle target
			enroute = 1
			stop_automated_movement = 1
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
	var/atom/target = FindTarget()
	if(istype(target) && !QDELETED(target))
		set_last_found_target(target)
	if(!last_found_target || enroute)
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


/*######################################
	START LAST_FOUND_TARGET HANDLING
######################################*/

/**
 * Sets the last found target for this hostile mob
 *
 * * target - The atom to set as the last found target, only a turf object or mob is allowed
 *
 * Returns TRUE if the target was set successfully, FALSE otherwise
 */
/mob/living/simple_animal/hostile/proc/set_last_found_target(atom/target)
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(QDELETED(target))
		return FALSE

	if(!is_type_in_list(target, list(/turf, /mob, /obj)))
		stack_trace("WARNING: set_last_found_target() was called with an invalid target!")
		return FALSE

	//No need to do anything if the target is the same as the last one
	if(target == last_found_target)
		return FALSE

	//Clean up the previous target if it wasn't done already
	if(last_found_target)
		unset_last_found_target()

	last_found_target = target
	RegisterSignal(last_found_target, COMSIG_QDELETING, PROC_REF(on_last_found_target_deleted))
	return TRUE

/**
 * Unsets the last found target for this hostile mob
 *
 * Basically, the reverse of `set_last_found_target()`
 *
 * Returns TRUE if the last found target was unset successfully, FALSE otherwise
 */
/mob/living/simple_animal/hostile/proc/unset_last_found_target()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!last_found_target)
		return FALSE

	UnregisterSignal(last_found_target, COMSIG_QDELETING)

	last_found_target = null
	return TRUE


/mob/living/simple_animal/hostile/proc/on_last_found_target_deleted()
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)
	last_found_target = null

/*######################################
	END LAST_FOUND_TARGET HANDLING
######################################*/
