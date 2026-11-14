// General Polaris AI profiles. Individual mobs may select a more specialized
// profile by overriding ai_holder_type.

/datum/ai_holder/hostile
	hostile = TRUE

/datum/ai_holder/retaliate
	hostile = TRUE
	retaliate = TRUE

/datum/ai_holder/simple_animal
	hostile = TRUE
	retaliate = TRUE
	cooperative = TRUE
	wander = TRUE
	base_wander_delay = 4
	can_flee = FALSE

/datum/ai_holder/simple_animal/attune_to_holder()
	. = ..()
	if(!istype(holder, /mob/living/simple_animal))
		return
	var/mob/living/simple_animal/simple_holder = holder
	wander = simple_holder.wander
	speak_chance = simple_holder.speak_chance
	vision_range = simple_holder.scan_range
	base_wander_delay = 1
	if(say_list)
		if(length(simple_holder.speak))
			say_list.speak = simple_holder.speak.Copy()
		if(length(simple_holder.emote_see))
			say_list.emote_see = simple_holder.emote_see.Copy()
		if(length(simple_holder.emote_hear))
			say_list.emote_hear = simple_holder.emote_hear.Copy()

/datum/ai_holder/simple_animal/handle_strategicals()
	if(istype(holder, /mob/living/simple_animal))
		var/mob/living/simple_animal/simple_holder = holder
		wander = simple_holder.wander
		if(simple_holder.can_nap)
			if(simple_holder.resting)
				if(prob(1))
					simple_holder.fall_asleep()
			else if(!simple_holder.stat || prob(0.5))
				simple_holder.wake_up()
		if(simple_holder.nutrition < simple_holder.max_nutrition / 3 && isturf(simple_holder.loc))
			simple_holder.handle_eating()
	return ..()

/datum/ai_holder/simple_animal/passive
	hostile = FALSE
	retaliate = FALSE
	cooperative = FALSE
	can_flee = TRUE
	violent_breakthrough = FALSE

/datum/ai_holder/simple_animal/hostile
	hostile = TRUE
	retaliate = TRUE
	cooperative = TRUE
	can_flee = FALSE

/datum/ai_holder/simple_animal/hostile/attune_to_holder()
	. = ..()
	var/mob/living/simple_animal/hostile/hostile_holder = holder
	vision_range = max(10, vision_range)
	pointblank = hostile_holder.ranged
	can_breakthrough = hostile_holder.destroy_surroundings
	violent_breakthrough = hostile_holder.destroy_surroundings
	firing_lanes = hostile_holder.smart_ranged
	conserve_ammo = hostile_holder.smart_ranged
	if(hostile_holder.ranged)
		pointblank = TRUE

/datum/ai_holder/simple_animal/event
	base_wander_delay = 8

/datum/ai_holder/simple_animal/bear
	hostile = TRUE
	retaliate = TRUE
	cooperative = TRUE
	can_flee = FALSE
	mauling = TRUE
	threaten = TRUE
	threaten_delay = null

// Bear warning and exhaustion are maintained by the bear's bespoke extension;
// the holder still owns acquisition, pursuit, fighting, and target memory.
/datum/ai_holder/simple_animal/bear/handle_alert()
	if(!target || !can_attack(target))
		lose_target()

/datum/ai_holder/simple_animal/retaliate
	hostile = FALSE
	retaliate = TRUE
	cooperative = TRUE
	can_flee = FALSE

/datum/ai_holder/simple_animal/guard
	returns_home = TRUE

/datum/ai_holder/simple_animal/guard/give_chase
	home_low_priority = TRUE

/datum/ai_holder/simple_animal/demolishing
	can_demolish = TRUE

/datum/ai_holder/simple_animal/demolishing/xray
	ignore_opacity = TRUE

/datum/ai_holder/simple_animal/inert
	hostile = FALSE
	retaliate = FALSE
	cooperative = FALSE
	can_flee = FALSE
	wander = FALSE
	violent_breakthrough = FALSE

/datum/ai_holder/simple_animal/inert/astar
	use_astar = TRUE

/datum/ai_holder/simple_animal/ranged

/datum/ai_holder/simple_animal/ranged/careful
	conserve_ammo = TRUE

/datum/ai_holder/simple_animal/ranged/pointblank
	pointblank = TRUE

/datum/ai_holder/simple_animal/ranged/kiting
	pointblank = TRUE
	var/run_if_this_close = 4
	var/moonwalk = TRUE

/datum/ai_holder/simple_animal/ranged/kiting/on_engagement(atom/the_target)
	if(the_target && get_dist(holder, the_target) < run_if_this_close && world.time >= next_movement)
		var/turf/step_away = get_step_away(holder, target, run_if_this_close)
		if(step_away && holder.AIMove(step_away) == AI_MOVEMENT_SUCCESS)
			next_movement = world.time + holder.AIMovementDelay()
			if(moonwalk)
				holder.face_atom(target)

/datum/ai_holder/simple_animal/ranged/kiting/threatening
	threaten = TRUE
	threaten_delay = 1 SECOND
	threaten_timeout = 30 SECONDS
	conserve_ammo = TRUE

/datum/ai_holder/simple_animal/ranged/kiting/threatening/event
	base_wander_delay = 8

/datum/ai_holder/simple_animal/ranged/kiting/no_moonwalk
	moonwalk = FALSE

/datum/ai_holder/simple_animal/ranged/aggressive
	pointblank = TRUE
	var/aggressive_distance = 1

/datum/ai_holder/simple_animal/ranged/aggressive/on_engagement(atom/the_target)
	if(get_dist(holder, the_target) > aggressive_distance)
		holder.AIMove(get_step_towards(holder, the_target))
		holder.face_atom(the_target)

/datum/ai_holder/simple_animal/ranged/robust

/datum/ai_holder/simple_animal/ranged/robust/on_engagement(atom/the_target)
	holder.AIMove(get_step(holder, pick(GLOB.cardinals)))
	holder.face_atom(the_target)

/datum/ai_holder/simple_animal/intentional

/datum/ai_holder/simple_animal/restrained
	violent_breakthrough = FALSE
	conserve_ammo = TRUE

/datum/ai_holder/simple_animal/destructive
	destructive = TRUE
	can_demolish = TRUE

/datum/ai_holder/simple_animal/melee

/datum/ai_holder/simple_animal/melee/evasive

/datum/ai_holder/simple_animal/melee/evasive/post_melee_attack(atom/the_target)
	if(the_target && holder.Adjacent(the_target) && world.time >= next_movement)
		var/turf/side_step = get_step(holder, pick(GLOB.alldirs))
		if(side_step && holder.AIMove(side_step) == AI_MOVEMENT_SUCCESS)
			next_movement = world.time + holder.AIMovementDelay()
			holder.face_atom(the_target)

/datum/ai_holder/simple_animal/melee/hit_and_run
	can_flee = TRUE

/datum/ai_holder/simple_animal/melee/hit_and_run/special_flee_check()
	return holder.AIShouldSpecialFlee(target)

/datum/ai_holder/simple_animal/humanoid
	intelligence_level = AI_INTELLIGENCE_SMART
	hostile = TRUE
	retaliate = TRUE
	threaten = TRUE
	firing_lanes = TRUE
	conserve_ammo = TRUE
	cooperative = TRUE
	returns_home = TRUE
	home_low_priority = TRUE
	use_astar = TRUE

/datum/ai_holder/simple_animal/humanoid/hostile
	var/run_if_this_close = 4

/datum/ai_holder/simple_animal/humanoid/hostile/post_melee_attack(atom/the_target)
	holder.AIMove(get_step(holder, pick(GLOB.alldirs)))
	holder.face_atom(the_target)

/datum/ai_holder/simple_animal/humanoid/hostile/post_ranged_attack(atom/the_target)
	var/turf/side_step = get_step(holder, pick(GLOB.alldirs))
	if(side_step && holder.AICheckFire(the_target, TRUE))
		holder.AIMove(side_step)
		holder.face_atom(the_target)
	if(get_dist(holder, the_target) < run_if_this_close)
		holder.AIMove(get_step_away(holder, the_target))
		holder.face_atom(the_target)

/datum/ai_holder/simple_animal/humanoid/pirate
	say_list_type = /datum/ai_say_list/pirate

/datum/ai_holder/simple_animal/humanoid/pirate/hostile

/datum/ai_holder/simple_animal/humanoid/mercenary
	say_list_type = /datum/ai_say_list/mercenary

/datum/ai_holder/simple_animal/humanoid/mercenary/hostile

/datum/ai_holder/simple_animal/humanoid/android
	say_list_type = /datum/ai_say_list/android_scientist

/datum/ai_holder/simple_animal/humanoid/android/hostile

/datum/ai_holder/simple_animal/hivebot
	hostile = TRUE
	retaliate = TRUE
	cooperative = TRUE
	say_list_type = /datum/ai_say_list/hivebot

/datum/ai_holder/simple_animal/hivebot/ranged
	pointblank = TRUE
	conserve_ammo = TRUE

/datum/ai_holder/simple_animal/slime
	hostile = FALSE
	retaliate = FALSE
	cooperative = TRUE
	can_flee = TRUE
	violent_breakthrough = FALSE

/datum/ai_holder/simple_animal/xenobio_slime
	hostile = TRUE
	retaliate = TRUE
	cooperative = TRUE
	firing_lanes = TRUE
	mauling = TRUE
	vision_range = 7
	speak_chance = 2
	var/rabid = FALSE
	var/discipline = 0
	var/resentment = 0
	var/obedience = 0
	var/always_stun = FALSE
	var/last_discipline_decay = 0
	var/discipline_decay_time = 5 SECONDS
	var/list/grudges = list()

/datum/ai_holder/simple_animal/xenobio_slime/attune_to_holder()
	. = ..()
	rabid = holder.AISlimeGetRabid(rabid)
	discipline = holder.AISlimeGetDiscipline(discipline)
	holder.AISlimeSetRabid(rabid)
	holder.AISlimeSetDiscipline(discipline)

/datum/ai_holder/simple_animal/xenobio_slime/Destroy()
	grudges.Cut()
	return ..()

/datum/ai_holder/simple_animal/xenobio_slime/sapphire
	always_stun = TRUE
	intelligence_level = AI_INTELLIGENCE_SMART

/datum/ai_holder/simple_animal/xenobio_slime/light_pink
	discipline = 10
	obedience = 10

/datum/ai_holder/simple_animal/xenobio_slime/red/adjust_discipline(amount, silent = FALSE)
	if(amount > 0 && !rabid)
		holder.AIContextSpeak("Grrr...")
		enrage()

/datum/ai_holder/simple_animal/xenobio_slime/passive/New()
	. = ..()
	pacify()

/datum/ai_holder/simple_animal/xenobio_slime/proc/is_justified_to_discipline()
	if(!can_act() || rabid)
		return rabid
	if(!target || !can_attack(target, FALSE))
		return FALSE
	return TRUE

/datum/ai_holder/simple_animal/xenobio_slime/proc/can_command(mob/living/commander)
	if(rabid)
		return FALSE
	if(holder.AISlimeCanCommand(commander))
		return TRUE
	if(holder.AIIsAlly(commander))
		return TRUE
	return discipline > resentment && obedience >= 5

/datum/ai_holder/simple_animal/xenobio_slime/proc/adjust_discipline(amount, silent = FALSE)
	if(amount > 0)
		if(rabid)
			return
		var/justified = is_justified_to_discipline()
		remove_target(FALSE)
		if(justified)
			obedience++
			if(!silent)
				holder.AIContextSpeak(pick("Fine...", "Okay...", "Sorry...", "I yield..."))
		else
			if(prob(resentment * 20))
				enrage()
			else if(!silent)
				holder.AIContextSpeak(pick("Why...?", "Cruel...", "Stop...", "No..."))
			resentment++
	discipline = clamp(discipline + amount, 0, 10)
	holder.AISlimeSetDiscipline(discipline)
	holder.AIUpdateSlimeMood()

/datum/ai_holder/simple_animal/xenobio_slime/handle_special_strategical()
	if(discipline > 0 && world.time >= last_discipline_decay + discipline_decay_time)
		if(!prob(75 + obedience * 5))
			adjust_discipline(-1, TRUE)
		last_discipline_decay = world.time

/datum/ai_holder/simple_animal/xenobio_slime/handle_special_tactic()
	if(evolve_and_reproduce())
		return
	nom()

/datum/ai_holder/simple_animal/xenobio_slime/list_targets()
	. = list()
	if(holder.AISlimeShouldHunt())
		. = ..()
	if(!leader && !rabid)
		for(var/atom/movable/possible_food in view(vision_range, holder))
			if(holder.AIIsSlimeFood(possible_food))
				. |= possible_food

/datum/ai_holder/simple_animal/xenobio_slime/proc/evolve_and_reproduce()
	if(!holder.AISlimeReadyToGrow())
		return FALSE
	if(holder.AISlimeIsAdult())
		return holder.AISlimeReproduce()
	return holder.AISlimeEvolve()

/datum/ai_holder/simple_animal/xenobio_slime/proc/nom()
	if(!target || ismob(target) || !holder.Adjacent(target) || !holder.AIIsSlimeFood(target))
		return
	if(holder.AISlimeConsume(target))
		remove_target(FALSE)

/datum/ai_holder/simple_animal/xenobio_slime/request_help(atom/attacker = target)
	if(attacker && !ismob(attacker))
		return
	return ..()

/datum/ai_holder/simple_animal/xenobio_slime/closest_distance(atom/the_target)
	if(isliving(the_target))
		var/mob/living/living_target = the_target
		if(living_target.stat != CONSCIOUS || holder.AISlimeCanConsume(living_target))
			return holder.AIMeleeRange()
	return ..()

/datum/ai_holder/simple_animal/xenobio_slime/can_attack(atom/the_target, vision_required = TRUE)
	if(holder.AIIsSlimeFood(the_target))
		return !vision_required || can_see_target(the_target)
	if(discipline && !rabid)
		return FALSE
	if(the_target in grudges)
		return TRUE
	return ..()

/datum/ai_holder/simple_animal/xenobio_slime/react_to_attack(atom/attacker)
	if(attacker)
		grudges |= attacker
	return ..()

/datum/ai_holder/simple_animal/xenobio_slime/proc/enrage()
	if(holder.AISlimeIsHarmless())
		return
	rabid = TRUE
	hostile = TRUE
	retaliate = TRUE
	holder.AISlimeSetRabid(TRUE)
	holder.AIUpdateSlimeMood()
	holder.visible_message(SPAN_DANGER("\The [holder] enrages!"))

/datum/ai_holder/simple_animal/xenobio_slime/proc/pacify()
	remove_target(FALSE)
	rabid = FALSE
	hostile = FALSE
	retaliate = FALSE
	cooperative = FALSE
	holder.a_intent = I_HELP
	holder.AISlimeSetRabid(FALSE)
	holder.AIUpdateSlimeMood()

/datum/ai_holder/simple_animal/xenobio_slime/pre_melee_attack(atom/the_target)
	if(!isliving(the_target))
		return
	var/mob/living/living_target = the_target
	if(!living_target.lying && (always_stun || prob(30)))
		holder.a_intent = I_DISARM
	else if(living_target.lying && holder.AISlimeCanConsume(living_target))
		holder.a_intent = I_GRAB
	else
		holder.a_intent = I_HURT

/datum/ai_holder/simple_animal/xenobio_slime/on_hear_say(mob/living/speaker, message)
	if(!speaker?.client)
		return
	var/lower_message = lowertext(message)
	if(!findtext(lower_message, lowertext(holder.name)) && !findtext(lower_message, "slime"))
		return
	if(findtext(lower_message, "hello") || findtext(lower_message, "hi"))
		delayed_say(pick("Hello...", "Hi..."), speaker)
	if(findtext(lower_message, "follow"))
		if(can_command(speaker))
			delayed_say("Yes... I follow...", speaker)
			set_follow(speaker)
		else
			delayed_say("No...", speaker)
	if(findtext(lower_message, "squish"))
		if(can_command(speaker))
			delayed_say("Okay...", speaker)
			addtimer(CALLBACK(holder, TYPE_PROC_REF(/mob/living, AISlimeSquish)), rand(1 SECOND, 2 SECONDS), TIMER_DELETE_ME)
		else
			delayed_say("No...", speaker)
	if(findtext(lower_message, "stop") || findtext(lower_message, "halt"))
		if(can_command(speaker))
			delayed_say("Fine...", speaker)
			if(holder.AISlimeIsConsuming())
				holder.AISlimeStopConsumption()
			lose_follow()
			remove_target(FALSE)
		else
			delayed_say("No...", speaker)

/datum/ai_holder/simple_animal/xenobio_slime/can_violently_breakthrough()
	if(discipline && !rabid)
		return FALSE
	if(target && !ismob(target))
		return FALSE
	return ..()

// Aurora does not have Polaris' xenobiology discipline/evolution subsystem,
// but this keeps the complete tactical xeno profile available to compatible
// simple mobs.
/datum/ai_holder/simple_animal/xeno_alien
	hostile = TRUE
	retaliate = TRUE
	cooperative = TRUE
	intelligence_level = AI_INTELLIGENCE_NORMAL
	can_flee = FALSE
	can_breakthrough = TRUE
	violent_breakthrough = TRUE
	conserve_ammo = TRUE
	var/can_telegrab = FALSE
	var/grab_defense = 2
	var/grab_defense_radius = 4
	var/tele_range_min = 3
	var/tele_range_max = 7

/datum/ai_holder/simple_animal/xeno_alien/on_engagement(atom/the_target)
	if(holder.Adjacent(the_target))
		holder.AIMove(get_step(holder, pick(GLOB.alldirs)))
		holder.face_atom(the_target)

/datum/ai_holder/simple_animal/xeno_alien/pre_special_attack(atom/the_target)
	if(!isliving(the_target))
		return
	if(can_telegrab)
		var/nearby_threats = 0
		for(var/atom/candidate as anything in list_targets())
			if(get_dist(holder, candidate) <= grab_defense_radius && can_attack(candidate))
				nearby_threats++
		if(nearby_threats >= grab_defense)
			holder.a_intent = I_GRAB
			return
	var/target_distance = get_dist(holder, the_target)
	if(target_distance >= tele_range_min && target_distance <= tele_range_max)
		holder.a_intent = I_DISARM

/datum/ai_holder/simple_animal/xeno_alien/ranged
	pointblank = TRUE
	conserve_ammo = TRUE
	ignore_incapacitated = TRUE
	tele_range_min = 1
	var/run_if_this_close = 4
	var/max_distance = 6

/datum/ai_holder/simple_animal/xeno_alien/ranged/post_ranged_attack(atom/the_target)
	var/target_distance = get_dist(holder, the_target)
	if(target_distance < run_if_this_close)
		holder.AIMove(get_step_away(holder, the_target, run_if_this_close))
	else if(target_distance > max_distance)
		holder.AIMove(get_step_towards(holder, the_target))
	else if(prob(25))
		holder.AIMove(get_step(holder, pick(GLOB.alldirs)))
	holder.face_atom(the_target)

/datum/ai_holder/simple_animal/xeno_alien/empress
	can_demolish = TRUE
	destructive = TRUE
	ignore_incapacitated = TRUE
	can_telegrab = TRUE
	tele_range_min = 1
	tele_range_max = 5
