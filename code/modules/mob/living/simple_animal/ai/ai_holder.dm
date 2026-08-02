/**
 * Datum-based mob AI adapted from Polaris.
 *
 * The mob remains the body and exposes small interface procs; this datum owns
 * targeting, memory, stance selection, pathing decisions, and cooperation.
 * Processing uses Aurora's normal and fast mob AI subsystems.
 */
/datum/ai_holder
	/// Optional mode owner which can direct idle movement.
	var/datum/game_mode/mode_ai_owner
	/// Requests priority handling when the mode provides an idle destination.
	var/mode_ai_high_priority = FALSE
	var/mob/living/holder
	var/stance = AI_STANCE_IDLE
	var/intelligence_level = AI_INTELLIGENCE_NORMAL
	var/autopilot = FALSE
	var/busy = FALSE
	var/last_strategic = 0
	var/strategic_interval = 2 SECONDS

	// Targeting and memory.
	var/hostile = FALSE
	var/retaliate = FALSE
	var/mauling = FALSE
	var/ignore_incapacitated = FALSE
	var/handle_corpse = FALSE
	var/destructive = FALSE
	var/atom/target
	var/atom/preferred_target
	var/turf/target_last_seen_turf
	var/vision_range = 10
	var/respect_alpha = TRUE
	var/alpha_vision_threshold = 35
	var/ignore_opacity = FALSE
	var/lose_target_time = 0
	var/lose_target_timeout = 5 SECONDS
	var/list/attackers = list()
	var/last_target_time = 0
	var/last_conflict_time = 0

	// Combat.
	var/firing_lanes = TRUE
	var/conserve_ammo = FALSE
	var/pointblank = FALSE
	var/stand_ground = FALSE
	var/can_breakthrough = TRUE
	var/violent_breakthrough = TRUE
	var/can_demolish = FALSE
	/// Instantly removes blocking airlocks, windoors, and railings before normal obstacle handling.
	var/instant_door_destruction = FALSE
	var/failed_breakthroughs = 0

	// Movement.
	var/turf/destination
	var/min_distance_to_destination = 1
	var/turf/home_turf
	var/returns_home = FALSE
	var/home_low_priority = FALSE
	var/max_home_distance = 3
	var/wander = FALSE
	var/wander_when_pulled = FALSE
	var/wander_delay = 0
	var/base_wander_delay = 2
	var/next_movement = 0
	/// Use A* temporarily while in a combat stance, without paying its cost while idle.
	var/combat_use_astar = TRUE
	/// Use A* in every stance, including idle movement and following.
	var/use_astar = FALSE
	var/list/path = list()
	var/list/obstacles = list()
	var/failed_steps = 0

	// Following and cooperation.
	var/atom/movable/leader
	var/follow_distance = 1
	var/follow_until_time = 0
	var/cooperative = FALSE
	var/list/faction_friends = list()
	var/last_help_request = 0
	var/help_cooldown = 5 SECONDS
	var/call_distance = 14
	var/call_players = FALSE
	var/called_player_message = "needs help!"

	// Fleeing.
	var/can_flee = TRUE
	var/flee_when_dying = TRUE
	var/dying_threshold = 0.3
	var/flee_when_outmatched = FALSE
	var/outmatched_threshold = 200

	// Communication.
	var/threaten = FALSE
	var/threatening = FALSE
	var/threaten_delay = 3 SECONDS
	var/threaten_timeout = 1 MINUTE
	var/last_threaten_time = 0
	var/speak_chance = 0
	var/datum/ai_say_list/say_list
	var/say_list_type = /datum/ai_say_list

	// Disabled behavior.
	var/respect_confusion = TRUE

	// Debugging.
	var/debug_ai = AI_LOG_OFF
	var/stance_coloring = FALSE
	var/path_display = FALSE
	var/last_turf_display = FALSE
	var/image/path_overlay
	var/image/last_turf_overlay

/datum/ai_holder/New(mob/living/new_holder)
	ASSERT(istype(new_holder))
	holder = new_holder
	home_turf = get_turf(holder)
	say_list = new say_list_type
	path_overlay = image('icons/effects/effects.dmi', icon_state = "electricity")
	path_overlay.color = "#ff0000"
	last_turf_overlay = image('icons/effects/effects.dmi', icon_state = "electricity")
	last_turf_overlay.color = "#00ff00"
	attune_to_holder()
	return ..()

/datum/ai_holder/Destroy()
	target = null
	lose_target_position()
	forget_path()
	faction_friends.Cut()
	leader = null
	holder = null
	home_turf = null
	QDEL_NULL(say_list)
	path_overlay = null
	last_turf_overlay = null
	return ..()

/// Pull body-specific defaults into the otherwise mob-agnostic holder.
/datum/ai_holder/proc/attune_to_holder()
	return

/datum/ai_holder/proc/set_busy(value = FALSE)
	busy = value

/datum/ai_holder/proc/go_sleep()
	if(stance == AI_STANCE_SLEEP)
		return
	forget_everything()
	set_stance(AI_STANCE_SLEEP)

/datum/ai_holder/proc/go_wake()
	if(stance != AI_STANCE_SLEEP || !should_wake())
		return FALSE
	set_stance(AI_STANCE_IDLE)
	return TRUE

/datum/ai_holder/proc/should_wake()
	return holder && holder.stat == CONSCIOUS && (!holder.client || autopilot)

/datum/ai_holder/proc/forget_everything()
	lose_follow()
	remove_target(FALSE)
	attackers.Cut()

/datum/ai_holder/proc/set_stance(new_stance)
	if(!holder || (holder.client && !autopilot) || stance == new_stance)
		return FALSE

	stance = new_stance
	ai_log_output("stance -> [new_stance]", AI_LOG_INFO)
	holder.AISetLegacyStance(new_stance)
	if(stance_coloring)
		stance_color()

	if(!holder.thinking_enabled)
		return TRUE

	if(new_stance == AI_STANCE_SLEEP)
		MOB_STOP_THINKING(holder)
	else if(new_stance == AI_STANCE_IDLE || new_stance == AI_STANCE_SPECIAL)
		MOB_SHIFT_TO_NORMAL_THINKING(holder)
	else
		MOB_SHIFT_TO_FAST_THINKING(holder)
	return TRUE

/datum/ai_holder/proc/think()
	if(QDELETED(holder))
		qdel(src)
		return
	if(busy || (holder.client && !autopilot) || !holder.AICanThink())
		return

	if(stance != AI_STANCE_DISABLED && is_disabled())
		set_stance(AI_STANCE_DISABLED)

	if(target && can_see_target(target))
		track_target_position()

	handle_tactics()
	if(world.time >= last_strategic + strategic_interval)
		last_strategic = world.time
		handle_strategicals()

/// Cheap decisions which need combat-speed processing.
/datum/ai_holder/proc/handle_tactics()
	handle_special_tactic()
	if(stance in AI_STANCES_COMBAT && escape_confinement())
		return
	switch(stance)
		if(AI_STANCE_ALERT)
			handle_alert()
		if(AI_STANCE_APPROACH)
			walk_to_target()
		if(AI_STANCE_FIGHT)
			engage_target()
		if(AI_STANCE_BLINDFIGHT)
			engage_unseen_target()
		if(AI_STANCE_REPOSITION, AI_STANCE_MOVE)
			walk_to_destination()
		if(AI_STANCE_FOLLOW)
			walk_to_leader()
		if(AI_STANCE_FLEE)
			flee_from_target()
		if(AI_STANCE_DISABLED)
			if(!is_disabled())
				set_stance(AI_STANCE_IDLE)
			else
				handle_disabled()

/// More expensive decisions made on the normal AI tick.
/datum/ai_holder/proc/handle_strategicals()
	handle_special_strategical()
	if(lose_target_time && world.time >= lose_target_time + lose_target_timeout)
		remove_target()

	if(stance in AI_STANCES_COMBAT)
		request_help()

	switch(stance)
		if(AI_STANCE_IDLE)
			handle_idle_speaking()
			if(hostile && find_target())
				return
			if(move_to_mode_destination())
				return
			if(should_go_home())
				go_home()
			else if(leader)
				set_stance(AI_STANCE_FOLLOW)
			else if(should_wander())
				handle_wander_movement()
		if(AI_STANCE_APPROACH)
			if(target && uses_astar())
				calculate_path(target, closest_distance(target))
		if(AI_STANCE_MOVE)
			if(hostile)
				find_target()
		if(AI_STANCE_FOLLOW)
			if(hostile && find_target())
				return
			if(leader && use_astar)
				calculate_path(leader, follow_distance)

/// Extension points retained from Polaris for profiles with extra decisions.
/datum/ai_holder/proc/handle_special_tactic()
	return

/datum/ai_holder/proc/handle_special_strategical()
	return

/datum/ai_holder/proc/list_targets()
	var/list/possible_targets = holder.AIListTargets(vision_range, ignore_opacity)
	for(var/atom/movable/machine in range(vision_range, holder))
		if(!istype(machine, /obj/structure/machinery/porta_turret) && !istype(machine, /obj/effect/blob))
			continue
		if(ignore_opacity || can_see_target(machine))
			possible_targets |= machine
	return possible_targets

/datum/ai_holder/proc/find_target(list/possible_targets)
	if(!hostile)
		return
	if(!islist(possible_targets))
		possible_targets = list_targets()

	var/list/valid_targets = list()
	for(var/atom/candidate as anything in possible_targets)
		if(can_attack(candidate))
			valid_targets += candidate

	var/atom/new_target = pick_target(valid_targets)
	if(new_target)
		give_target(new_target)
	return new_target

/datum/ai_holder/proc/pick_target(list/targets)
	return holder.AIPickTarget(targets, target, preferred_target)

/datum/ai_holder/proc/target_filter_distance(list/targets)
	if(!target)
		return targets
	var/target_distance = get_dist(holder, target)
	var/list/better_targets = list()
	for(var/atom/candidate as anything in targets)
		if(get_dist(holder, candidate) < target_distance)
			better_targets += candidate
	return better_targets

/datum/ai_holder/proc/target_filter_closest(list/targets)
	var/closest_distance = INFINITY
	var/list/closest_targets = list()
	for(var/atom/candidate as anything in targets)
		var/candidate_distance = get_dist(holder, candidate)
		if(candidate_distance < closest_distance)
			closest_distance = candidate_distance
			closest_targets = list(candidate)
		else if(candidate_distance == closest_distance)
			closest_targets += candidate
	return closest_targets

/datum/ai_holder/proc/give_target(atom/new_target, urgent = FALSE)
	if(QDELETED(new_target) || new_target == holder)
		return FALSE
	if(target == new_target)
		return TRUE

	var/atom/old_target = target
	target = new_target
	lose_target_time = 0
	track_target_position()
	holder.AITargetChanged(old_target, new_target)
	if(target != new_target)
		return FALSE
	last_target_time = world.time
	on_target_acquired(new_target, old_target)
	if(target != new_target)
		return TRUE
	emit_context(say_list?.say_got_target, new_target)

	if(!urgent && should_threaten(new_target))
		set_stance(AI_STANCE_ALERT)
	else
		set_stance(within_range(target) ? AI_STANCE_FIGHT : AI_STANCE_APPROACH)
	return TRUE

/datum/ai_holder/proc/lose_target()
	if(!target)
		return remove_target()

	if(can_attack(target, FALSE) && target_last_seen_turf && intelligence_level >= AI_INTELLIGENCE_NORMAL)
		var/atom/old_target = target
		target = null
		lose_target_time = world.time
		holder.AITargetChanged(old_target, null, FALSE)
		set_stance(AI_STANCE_BLINDFIGHT)
		return TRUE
	return remove_target()

/datum/ai_holder/proc/remove_target(find_replacement = TRUE)
	stand_down()
	clear_target()
	if(find_replacement && hostile)
		return find_target()
	return TRUE

/// Clears target state without dialogue or replacement acquisition. Safe for
/// lifecycle paths such as Life() and Initialize() which must never sleep.
/datum/ai_holder/proc/clear_target()
	var/atom/old_target = target
	threatening = FALSE
	target = null
	lose_target_time = 0
	lose_target_position()
	forget_path()
	destination = null
	if(holder)
		holder.AITargetChanged(old_target, null)
		if(old_target)
			on_target_lost(old_target)
		set_stance(AI_STANCE_IDLE)
	return TRUE

/// Special-profile callbacks for final target acquisition and loss.
/datum/ai_holder/proc/on_target_acquired(atom/new_target, atom/old_target)
	return

/datum/ai_holder/proc/on_target_lost(atom/old_target)
	return

/datum/ai_holder/proc/can_attack(atom/the_target, vision_required = TRUE)
	return target_status(the_target, vision_required) == AI_TARGET_VALID

/datum/ai_holder/proc/target_status(atom/the_target, vision_required = TRUE)
	if(QDELETED(the_target) || the_target == holder)
		return AI_TARGET_DEAD
	if(holder.AIIsAlly(the_target))
		return AI_TARGET_ALLY
	if(isliving(the_target))
		var/mob/living/living_target = the_target
		if(living_target.stat == DEAD && !handle_corpse)
			return AI_TARGET_DEAD
		if(living_target.stat == UNCONSCIOUS && !mauling)
			return AI_TARGET_INVINCIBLE
		if(living_target.incapacitated(INCAPACITATION_STUNNED) && ignore_incapacitated)
			return AI_TARGET_INVINCIBLE
	if(vision_required && !can_see_target(the_target))
		if(holder.see_invisible < the_target.invisibility || (respect_alpha && the_target.alpha <= alpha_vision_threshold))
			return AI_TARGET_INVISIBLE
		return AI_TARGET_NO_SIGHT
	if(!holder.AICanAttack(the_target))
		return AI_TARGET_INVINCIBLE
	return AI_TARGET_VALID

/datum/ai_holder/proc/can_see_target(atom/the_target, view_range = 0)
	if(QDELETED(the_target))
		return FALSE
	if(!view_range)
		view_range = vision_range
	if(holder.see_invisible < the_target.invisibility)
		return FALSE
	if(respect_alpha && the_target.alpha <= alpha_vision_threshold)
		return FALSE
	if(get_dist(holder, the_target) > view_range || holder.z != the_target.z)
		return FALSE
	if(ignore_opacity)
		return TRUE
	return is_in_sight(holder, the_target)

/datum/ai_holder/proc/track_target_position()
	if(target)
		if(last_turf_display && target_last_seen_turf)
			target_last_seen_turf.CutOverlays(last_turf_overlay)
		target_last_seen_turf = get_turf(target)
		if(last_turf_display && target_last_seen_turf)
			target_last_seen_turf.AddOverlays(last_turf_overlay)

/datum/ai_holder/proc/lose_target_position()
	if(last_turf_display && target_last_seen_turf)
		target_last_seen_turf.CutOverlays(last_turf_overlay)
	target_last_seen_turf = null

/datum/ai_holder/proc/react_to_attack(atom/attacker)
	if(QDELETED(attacker) || holder.stat == DEAD || (holder.client && !autopilot))
		return FALSE
	if(holder.AIIsAlly(attacker))
		return FALSE

	on_attacked(attacker)
	if(stance == AI_STANCE_SLEEP)
		go_wake()
	if(!hostile && !retaliate)
		if(!can_flee)
			return FALSE
		if(!give_target(attacker, TRUE))
			return FALSE
		set_stance(AI_STANCE_FLEE)
		return TRUE
	if(target && target != attacker)
		if(!retaliate || world.time < last_target_time + 3 SECONDS)
			return FALSE
	if(cooperative)
		request_help(attacker)
	return give_target(attacker, TRUE)

/datum/ai_holder/proc/on_attacked(atom/attacker)
	last_conflict_time = world.time
	add_attacker(attacker)

/datum/ai_holder/proc/check_attacker(atom/attacker)
	return attacker?.name in attackers

/datum/ai_holder/proc/add_attacker(atom/attacker)
	if(attacker)
		attackers |= attacker.name

/datum/ai_holder/proc/remove_attacker(atom/attacker)
	if(attacker)
		attackers -= attacker.name

/datum/ai_holder/proc/receive_taunt(atom/taunter, force_target_switch = FALSE)
	preferred_target = taunter
	if(force_target_switch)
		give_target(taunter, TRUE)

/datum/ai_holder/proc/lose_taunt()
	preferred_target = null

/datum/ai_holder/proc/engage_target()
	if(!target || !can_attack(target))
		lose_target()
		return
	if(should_flee())
		set_stance(AI_STANCE_FLEE)
		return
	if(instant_door_destruction && world.time >= next_movement && destroy_blocking_door(get_dir(holder, target)))
		next_movement = world.time + holder.AIMovementDelay()
		forget_path()
		return

	holder.face_atom(target)
	if(holder.AICheckSpecialAttack(target))
		on_engagement(target)
		if(special_attack(target) == AI_ATTACK_SUCCESS)
			return

	var/distance = get_dist(holder, target)
	if(distance <= holder.AIMeleeRange() && (!pointblank || !holder.AICheckRangedAttack(target)))
		on_engagement(target)
		melee_attack(target)
		return

	if(holder.AICheckRangedAttack(target) && distance <= max_range(target))
		if(!firing_lanes || test_projectile_safety(target))
			on_engagement(target)
			ranged_attack(target)
			return
		var/turf/reposition_turf = get_step(holder, pick(GLOB.cardinals))
		holder.AIMove(reposition_turf)
		holder.face_atom(target)

	if(!stand_ground)
		set_stance(AI_STANCE_APPROACH)

/datum/ai_holder/proc/test_projectile_safety(atom/the_target)
	return holder.AICheckFire(the_target, conserve_ammo)

/datum/ai_holder/proc/within_range(atom/the_target)
	if(get_dist(holder, the_target) <= holder.AIMeleeRange())
		return TRUE
	return holder.AICheckRangedAttack(the_target) && get_dist(holder, the_target) <= max_range(the_target)

/datum/ai_holder/proc/closest_distance(atom/the_target)
	if(holder.AICheckRangedAttack(the_target))
		return max(max_range(the_target) - 1, 1)
	return holder.AIMeleeRange()

/datum/ai_holder/proc/max_range(atom/the_target)
	return holder.AIRangedRange(the_target)

/datum/ai_holder/proc/walk_to_target()
	if(!target || !can_attack(target))
		lose_target()
		return
	if(within_range(target) || holder.AICheckSpecialAttack(target))
		forget_path()
		set_stance(AI_STANCE_FIGHT)
		return
	if(!stand_ground)
		walk_path(target, closest_distance(target))

/datum/ai_holder/proc/engage_unseen_target()
	if(world.time >= lose_target_time + lose_target_timeout || !target_last_seen_turf)
		remove_target()
		return
	if(hostile && find_target())
		return
	if(!holder.AICheckRangedAttack(target_last_seen_turf) || conserve_ammo)
		if(get_dist(holder, target_last_seen_turf) > 1)
			return give_destination(target_last_seen_turf, 1, TRUE)
		if(melee_on_tile(target_last_seen_turf) != AI_ATTACK_SUCCESS && intelligence_level >= AI_INTELLIGENCE_NORMAL)
			var/atom/escape_route = find_escape_route()
			if(escape_route)
				return give_destination(get_turf(escape_route), 0, TRUE)
			return find_target()
		return
	return shoot_near_turf(target_last_seen_turf)

/datum/ai_holder/proc/give_destination(turf/new_destination, min_distance = 1, combat = FALSE)
	if(!istype(new_destination))
		return FALSE
	destination = new_destination
	min_distance_to_destination = min_distance
	set_stance(combat ? AI_STANCE_REPOSITION : AI_STANCE_MOVE)
	return TRUE

/datum/ai_holder/proc/move_to_mode_destination()
	if(!mode_ai_owner || !holder || stance != AI_STANCE_IDLE)
		return FALSE
	var/turf/new_destination = mode_ai_owner.get_ai_idle_destination(holder, mode_ai_high_priority)
	if(!new_destination)
		return FALSE
	return give_destination(new_destination, 0)

/datum/ai_holder/proc/walk_to_destination()
	if(!destination)
		set_stance(stance == AI_STANCE_REPOSITION ? AI_STANCE_APPROACH : AI_STANCE_IDLE)
		return
	if(holder.z != destination.z || get_dist(holder, destination) <= min_distance_to_destination)
		check_use_ladder()
		destination = null
		forget_path()
		set_stance(stance == AI_STANCE_REPOSITION ? AI_STANCE_APPROACH : AI_STANCE_IDLE)
		return
	walk_path(destination, min_distance_to_destination)

/datum/ai_holder/proc/walk_path(atom/goal, get_to = 1)
	if(!holder.AICanMove() || world.time < next_movement)
		return AI_MOVEMENT_ON_COOLDOWN

	var/turf/next_step
	if(uses_astar())
		if(!length(path))
			calculate_path(goal, get_to)
		if(length(path))
			next_step = path[1]
		else
			next_step = get_step_to(holder, goal, get_to)
	else
		next_step = get_step_to(holder, goal, get_to)

	if(!next_step)
		return AI_MOVEMENT_FAILED
	if(instant_door_destruction && destroy_blocking_door(get_dir(holder, next_step)))
		next_movement = world.time + holder.AIMovementDelay()
		forget_path()
		return AI_MOVEMENT_ON_COOLDOWN

	var/result = holder.AIMove(next_step)
	if(result == AI_MOVEMENT_SUCCESS)
		next_movement = world.time + holder.AIMovementDelay()
		if(length(path) && get_turf(holder) == next_step)
			path.Cut(1, 2)
		failed_steps = 0
		return result

	if(result == AI_MOVEMENT_FAILED)
		failed_steps++
		if(can_breakthrough || instant_door_destruction)
			if(!breakthrough(next_step))
				failed_breakthroughs++
			else
				failed_breakthroughs = 0
		if(failed_breakthroughs >= 5)
			give_up_movement()
			failed_breakthroughs = 0
		if(failed_steps >= 3)
			forget_path()
			failed_steps = 0
	return result

/datum/ai_holder/proc/calculate_path(atom/goal, get_to = 1)
	forget_path()
	if(!uses_astar() || !goal)
		return
	path = get_path(get_turf(goal), get_to, vision_range * 6)
	if(path_display)
		for(var/turf/path_turf in path)
			path_turf.AddOverlays(path_overlay)

/datum/ai_holder/proc/uses_astar()
	return use_astar || (combat_use_astar && (stance in AI_STANCES_COMBAT))

/datum/ai_holder/proc/get_path(turf/goal, get_to = 1, max_distance = world.view * 6)
	if(!goal)
		return
	var/turf/start_turf = get_turf(holder)
	var/adjacent_proc = instant_door_destruction ? /turf/proc/CardinalTurfsWithDestructibleBarriers : /turf/proc/CardinalTurfsWithAccess
	var/list/new_path = AStar(start_turf, goal, adjacent_proc, /turf/proc/Distance, max_nodes = 100, max_node_depth = max_distance, min_target_dist = get_to, id = holder.AIGetID(), exclude = obstacles)
	// Legacy AStar includes the starting turf, while walk_path expects its first
	// entry to be the next turf to enter.
	if(length(new_path) && new_path[1] == start_turf)
		new_path.Cut(1, 2)
	return new_path

/datum/ai_holder/proc/forget_path()
	if(path_display)
		for(var/turf/path_turf in path)
			path_turf.CutOverlays(path_overlay)
	path?.Cut()

/datum/ai_holder/proc/give_up_movement()
	forget_path()
	destination = null

/datum/ai_holder/proc/should_go_home()
	if(!returns_home || !home_turf || stance != AI_STANCE_IDLE)
		return FALSE
	if(get_dist(holder, home_turf) <= max_home_distance)
		return FALSE
	return !home_low_priority || (!leader && !target)

/datum/ai_holder/proc/go_home()
	lose_follow()
	give_destination(home_turf, max_home_distance)

/datum/ai_holder/proc/should_wander()
	return wander && stance == AI_STANCE_IDLE && !leader

/datum/ai_holder/proc/handle_wander_movement()
	if(!holder.AICanMove() || (!wander_when_pulled && (holder.pulledby || length(holder.grabbed_by))))
		return
	if(wander_delay-- > 0)
		return
	var/direction = pick(GLOB.cardinals)
	holder.face_atom(get_step(holder, direction))
	holder.AIMove(get_step(holder, direction))
	wander_delay = base_wander_delay

/datum/ai_holder/proc/check_use_ladder()
	if(!target || can_see_target(target) || intelligence_level < AI_INTELLIGENCE_SMART)
		return FALSE
	var/obj/structure/ladder/ladder = locate() in get_turf(holder)
	if(!ladder || !holder.may_climb_ladders(ladder))
		return FALSE
	var/obj/structure/ladder/target_ladder
	if(target.z > holder.z)
		target_ladder = ladder.target_up
	else if(target.z < holder.z)
		target_ladder = ladder.target_down
	else
		target_ladder = pick(ladder.target_up, ladder.target_down)
	if(!target_ladder)
		return FALSE
	ladder.climbLadder(holder, target_ladder)
	return TRUE

/datum/ai_holder/proc/set_leader(mob/living/new_leader)
	return set_follow(new_leader)

/datum/ai_holder/proc/set_follow(mob/living/new_leader, follow_for = 0)
	if(!new_leader)
		lose_follow()
		return FALSE
	leader = new_leader
	follow_until_time = follow_for ? world.time + follow_for : 0
	set_stance(AI_STANCE_FOLLOW)
	return TRUE

/datum/ai_holder/proc/lose_follow()
	leader = null
	follow_until_time = 0
	give_up_movement()
	if(stance == AI_STANCE_FOLLOW)
		set_stance(AI_STANCE_IDLE)

/datum/ai_holder/proc/should_follow_leader()
	if(QDELETED(leader) || target)
		return FALSE
	if(follow_until_time && world.time > follow_until_time)
		lose_follow()
		return FALSE
	return get_dist(holder, leader) > follow_distance

/datum/ai_holder/proc/walk_to_leader()
	if(QDELETED(leader) || holder.z != leader.z)
		lose_follow()
		return
	if(follow_until_time && world.time > follow_until_time)
		lose_follow()
		return
	if(get_dist(holder, leader) <= follow_distance)
		give_up_movement()
		set_stance(AI_STANCE_IDLE)
		return
	walk_path(leader, follow_distance)

/datum/ai_holder/proc/build_faction_friends()
	faction_friends.Cut()
	for(var/mob/living/candidate in GLOB.living_mob_list)
		if(candidate != holder && candidate.ai_holder && holder.AIIsAlly(candidate))
			faction_friends |= candidate

/datum/ai_holder/proc/request_help(atom/attacker = target)
	if(!cooperative || !attacker || world.time < last_help_request + help_cooldown)
		return
	last_help_request = world.time
	build_faction_friends()
	for(var/mob/living/friend as anything in faction_friends)
		if(QDELETED(friend) || friend.z != holder.z || get_dist(holder, friend) > call_distance)
			continue
		if(friend.client && call_players)
			to_chat(friend, SPAN_DANGER("\The [holder] [called_player_message]"))
		else
			friend.ai_holder?.help_requested(holder, attacker)

/datum/ai_holder/proc/help_requested(mob/living/friend, atom/attacker)
	if(!cooperative || stance == AI_STANCE_SLEEP || (stance in AI_STANCES_COMBAT) || !can_act())
		return
	if(target || !holder.AIIsAlly(friend))
		return
	if(!attacker)
		attacker = friend.ai_holder?.target
	if(attacker && !can_attack(attacker, FALSE))
		return
	if(attacker && get_dist(holder, friend) <= vision_range && can_see_target(attacker))
		last_conflict_time = world.time
		give_target(attacker, TRUE)
		return
	if(attacker)
		add_attacker(attacker)
	set_follow(friend, 10 SECONDS)

/datum/ai_holder/proc/should_flee(force = FALSE)
	if(holder.AIShouldNeverFlee())
		return FALSE
	if(force)
		return TRUE
	if(!can_flee || !target)
		return FALSE
	if(special_flee_check())
		return TRUE
	if(!hostile && !retaliate)
		return TRUE
	if(flee_when_dying && holder.health / holder.maxhealth <= dying_threshold)
		return TRUE
	return flee_when_outmatched && holder.AIThreatLevel() >= outmatched_threshold

/datum/ai_holder/proc/special_flee_check()
	return holder.AIShouldSpecialFlee(target)

/datum/ai_holder/proc/flee_from_target()
	if(!target || !can_attack(target, FALSE) || (!should_flee() && (hostile || retaliate)))
		remove_target()
		return
	if(world.time < next_movement)
		return
	if(length(say_list?.say_retreat))
		delayed_say(pick(say_list.say_retreat), null)
	var/turf/escape_turf = get_step_away(holder, target, vision_range)
	if(escape_turf && holder.AIMove(escape_turf) == AI_MOVEMENT_SUCCESS)
		next_movement = world.time + holder.AIMovementDelay()

/mob/living/proc/set_AI_busy(value)
	ai_holder?.set_busy(value)

/mob/living/proc/is_AI_busy()
	return ai_holder?.busy || FALSE

/mob/living/proc/get_AI_stance()
	if(!ai_holder || (client && !ai_holder.autopilot))
		return null
	return ai_holder.stance

/mob/living/proc/has_AI()
	return !isnull(get_AI_stance())

/mob/living/proc/taunt(atom/taunter, force_target_switch = FALSE)
	ai_holder?.receive_taunt(taunter, force_target_switch)
