// Combat hooks, unseen-target behavior, and obstacle handling.

/datum/ai_holder/proc/melee_attack(atom/the_target)
	pre_melee_attack(the_target)
	var/result = holder.AIMeleeAttack(the_target)
	if(result == AI_ATTACK_SUCCESS)
		post_melee_attack(the_target)
	return result

/datum/ai_holder/proc/ranged_attack(atom/the_target)
	pre_ranged_attack(the_target)
	var/result = holder.AIRangedAttack(the_target)
	if(result == AI_ATTACK_SUCCESS)
		post_ranged_attack(the_target)
	return result

/datum/ai_holder/proc/special_attack(atom/the_target)
	pre_special_attack(the_target)
	var/result = holder.AISpecialAttack(the_target)
	if(result == AI_ATTACK_SUCCESS)
		post_special_attack(the_target)
	return result

/datum/ai_holder/proc/on_engagement(atom/the_target)
	return

/datum/ai_holder/proc/pre_melee_attack(atom/the_target)
	return

/datum/ai_holder/proc/post_melee_attack(atom/the_target)
	return

/datum/ai_holder/proc/pre_ranged_attack(atom/the_target)
	return

/datum/ai_holder/proc/post_ranged_attack(atom/the_target)
	return

/datum/ai_holder/proc/pre_special_attack(atom/the_target)
	return

/datum/ai_holder/proc/post_special_attack(atom/the_target)
	return

/datum/ai_holder/proc/engage_unseen_enemy()
	return engage_unseen_target()

/datum/ai_holder/proc/shoot_near_turf(turf/targeted_turf)
	if(!targeted_turf || get_dist(holder, targeted_turf) > max_range(targeted_turf))
		return AI_ATTACK_FAILED
	var/turf/actual_target = pick(RANGE_TURFS(2, targeted_turf))
	on_engagement(actual_target)
	if(firing_lanes && !holder.AICheckFire(actual_target, conserve_ammo))
		var/turf/random_step = get_step(holder, pick(GLOB.cardinals))
		holder.AIMove(random_step)
		holder.face_atom(actual_target)
		return AI_ATTACK_FAILED
	return ranged_attack(actual_target)

/datum/ai_holder/proc/melee_on_tile(turf/targeted_turf)
	if(!targeted_turf)
		return AI_ATTACK_FAILED
	for(var/mob/living/possible_target in targeted_turf)
		if(!holder.AIIsAlly(possible_target))
			return melee_attack(possible_target)
	targeted_turf.visible_message(SPAN_WARNING("\The [holder] attacks empty space around \the [targeted_turf]."))
	return AI_ATTACK_FAILED

/datum/ai_holder/proc/find_escape_route()
	var/list/closest_routes = list()
	var/closest_distance = vision_range + 1
	for(var/atom/route in view(vision_range, holder))
		if(!istype(route, /obj/structure/machinery/door) && !istype(route, /obj/structure/stairs) && !istype(route, /obj/structure/ladder))
			continue
		if(REVERSE_DIR(holder.dir) & get_dir(holder, route))
			continue
		if(istype(route, /obj/structure/machinery/door))
			var/obj/structure/machinery/door/door = route
			if(door.glass || (door.density && intelligence_level < AI_INTELLIGENCE_SMART))
				continue
		if(istype(route, /obj/structure/ladder) && intelligence_level < AI_INTELLIGENCE_SMART)
			continue
		var/route_distance = get_dist(holder, route)
		if(route_distance < closest_distance)
			closest_routes = list(route)
			closest_distance = route_distance
		else if(route_distance == closest_distance)
			closest_routes += route
	return length(closest_routes) ? pick(closest_routes) : null

/datum/ai_holder/proc/breakthrough(atom/towards)
	var/direction = get_dir(holder, towards)
	if(instant_door_destruction && destroy_blocking_door(direction))
		return TRUE
	if(!can_breakthrough || !isturf(holder.loc))
		return FALSE
	if(destroy_surroundings(direction, FALSE))
		return TRUE
	if(can_violently_breakthrough())
		return destroy_surroundings(direction, TRUE)
	return FALSE

/datum/ai_holder/proc/destroy_blocking_door(direction)
	if(!holder || !direction || !isturf(holder.loc))
		return FALSE
	var/turf/holder_turf = get_turf(holder)
	var/turf/problem_turf = get_step(holder, direction)
	if(!problem_turf)
		return FALSE
	for(var/obj/structure/machinery/door/airlock/airlock in problem_turf)
		if(!airlock.density)
			continue
		destroy_door(airlock)
		return TRUE
	// Windoors are directional border objects and may block either the turf being
	// left or the turf being entered.
	for(var/obj/structure/machinery/door/window/windoor in holder_turf)
		if(windoor.density && !windoor.CheckExit(holder, problem_turf))
			destroy_door(windoor)
			return TRUE
	for(var/obj/structure/machinery/door/window/windoor in problem_turf)
		if(windoor.density && !windoor.CanPass(holder, problem_turf))
			destroy_door(windoor)
			return TRUE
	// Railings are directional border objects, just like windoors. A railing on
	// either side of the link can be the object preventing this movement.
	for(var/obj/structure/railing/railing in holder_turf)
		if(railing.density && !railing.CheckExit(holder, problem_turf))
			destroy_barrier(railing)
			return TRUE
	for(var/obj/structure/railing/railing in problem_turf)
		if(railing.density && !railing.CanPass(holder, holder_turf))
			destroy_barrier(railing)
			return TRUE
	return FALSE

/datum/ai_holder/proc/destroy_door(obj/structure/machinery/door/door)
	if(istype(door, /obj/structure/machinery/door/airlock))
		var/turf/door_turf = get_turf(door)
		if(door_turf)
			playsound(door_turf, 'sound/weapons/heavysmash.ogg', 75, TRUE)
			// Match maintenance-drone breakups: scattered robot debris and a
			// shower of electrical sparks, with an extra short spark burst.
			new /obj/effect/gibspawner/robot(door_turf)
			spark(door_turf, 1, GLOB.alldirs)
	return destroy_barrier(door)

/datum/ai_holder/proc/destroy_barrier(obj/structure/barrier)
	if(!holder || !barrier || QDELETED(barrier))
		return FALSE
	holder.face_atom(barrier)
	holder.do_attack_animation(barrier)
	holder.visible_message(SPAN_DANGER("\The [holder] tears through \the [barrier]!"))
	qdel(barrier)
	return TRUE

/datum/ai_holder/proc/destroy_surroundings(direction, violent = TRUE)
	if(!direction)
		direction = pick(GLOB.cardinals)
	return holder.AIBreakObstacles(get_step(holder, direction), violent, can_demolish)

/datum/ai_holder/proc/can_violently_breakthrough()
	return violent_breakthrough
