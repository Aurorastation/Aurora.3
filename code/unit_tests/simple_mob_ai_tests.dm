/mob/living/simple_animal/hostile/unit_test_ai
	name = "AI test hostile"
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	melee_damage_lower = 5
	melee_damage_upper = 5
	wander = FALSE

/mob/living/simple_animal/unit_test_ai_target
	name = "AI test target"
	icon_state = "mouse_brown"
	icon_living = "mouse_brown"
	icon_dead = "mouse_brown_dead"
	wander = FALSE

/mob/living/simple_animal/hostile/unit_test_ai_tactical
	name = "AI tactical test hostile"
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	ai_holder_type = /datum/ai_holder/simple_animal/humanoid/hostile
	melee_damage_lower = 5
	melee_damage_upper = 5
	wander = FALSE

/datum/ai_holder/simple_animal/hostile/unit_test_callbacks
	var/acquired = FALSE
	var/lost = FALSE
	var/attacked = FALSE

/datum/ai_holder/simple_animal/hostile/unit_test_callbacks/on_target_acquired(atom/new_target, atom/old_target)
	acquired = new_target

/datum/ai_holder/simple_animal/hostile/unit_test_callbacks/on_target_lost(atom/old_target)
	lost = old_target

/datum/ai_holder/simple_animal/hostile/unit_test_callbacks/post_melee_attack(atom/the_target)
	attacked = the_target

/mob/living/simple_animal/hostile/unit_test_ai_callbacks
	name = "AI callback test hostile"
	icon_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	ai_holder_type = /datum/ai_holder/simple_animal/hostile/unit_test_callbacks
	melee_damage_lower = 1
	melee_damage_upper = 1
	wander = FALSE

/mob/living/simple_animal/hostile/giant_spider/bombardier/unit_test_ai
	var/shots_fired = 0

/mob/living/simple_animal/hostile/giant_spider/bombardier/unit_test_ai/Shoot(var/target, var/start, var/mob/user, var/bullet = 0)
	shots_fired++

/datum/unit_test/simple_mob_ai
	name = "SIMPLE MOBS: Polaris AI holder integration"
	groups = list("generic", "simple mob ai")

/datum/unit_test/simple_mob_ai/start_test()
	var/turf/hostile_turf = locate(71, 155, 1)
	var/turf/target_turf = get_step(hostile_turf, NORTH)
	if(!hostile_turf || !target_turf)
		return TEST_FAIL("Could not locate adjacent turfs for the AI integration test.")

	var/mob/living/simple_animal/hostile/unit_test_ai/hostile_mob = new(hostile_turf)
	var/mob/living/simple_animal/unit_test_ai_target/target_mob = new(target_turf)

	if(!istype(hostile_mob.ai_holder, /datum/ai_holder/simple_animal/hostile))
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Hostile simple mob did not receive a hostile AI holder.")
	if(!istype(target_mob.ai_holder, /datum/ai_holder/simple_animal/passive))
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Passive simple mob did not receive a passive AI holder.")

	hostile_mob.ai_holder.find_target(list(target_mob))
	if(hostile_mob.ai_holder.target != target_mob)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Hostile AI failed to acquire a valid adjacent target.")
	if(!hostile_mob.is_fast_processing)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Hostile AI did not promote itself to fast processing after acquiring a target.")

	var/old_health = target_mob.health
	hostile_mob.ai_holder.engage_target()
	if(target_mob.health >= old_health)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Hostile AI failed to execute its simple mob melee interface.")

	target_mob.ai_holder.react_to_attack(hostile_mob)
	if(target_mob.ai_holder.stance != AI_STANCE_FLEE || target_mob.ai_holder.target != hostile_mob)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Passive AI did not acquire and flee from its attacker through the holder.")

	qdel(hostile_mob)
	qdel(target_mob)
	return TEST_PASS("Polaris AI holders acquire, attack, and flee through Aurora simple mob interfaces.")

/datum/unit_test/simple_mob_ai_tactics
	name = "SIMPLE MOBS: Polaris AI tactics and memory"
	groups = list("generic", "simple mob ai")

/datum/unit_test/simple_mob_ai_tactics/start_test()
	var/turf/hostile_turf = locate(71, 155, 1)
	var/turf/target_turf = get_step(hostile_turf, NORTH)
	if(!hostile_turf || !target_turf)
		return TEST_FAIL("Could not locate adjacent turfs for the AI tactics test.")

	var/mob/living/simple_animal/hostile/unit_test_ai_tactical/hostile_mob = new(hostile_turf)
	var/mob/living/simple_animal/unit_test_ai_target/target_mob = new(target_turf)
	hostile_mob.ai_holder.find_target(list(target_mob))
	if(hostile_mob.ai_holder.stance != AI_STANCE_ALERT)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Threatening tactical AI did not enter its warning stance.")

	hostile_mob.ai_holder.threaten_target()
	if(!hostile_mob.ai_holder.threatening)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Threatening tactical AI did not issue its initial warning.")

	hostile_mob.ai_holder.last_threaten_time = world.time - hostile_mob.ai_holder.threaten_delay
	hostile_mob.ai_holder.threaten_target()
	if(hostile_mob.ai_holder.stance != AI_STANCE_FIGHT)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Threatening tactical AI did not escalate after its warning expired.")

	target_mob.invisibility = INVISIBILITY_MAXIMUM
	hostile_mob.ai_holder.lose_target()
	if(hostile_mob.ai_holder.stance != AI_STANCE_BLINDFIGHT || !hostile_mob.ai_holder.target_last_seen_turf)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Tactical AI did not retain and pursue a target's last-seen position.")

	target_mob.confused = 2
	if(!target_mob.ai_holder.is_disabled())
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("AI holder did not recognize confusion as a disabled state.")

	qdel(hostile_mob)
	qdel(target_mob)
	return TEST_PASS("Threat escalation, target memory, and disabled-state handling are active.")

/datum/unit_test/simple_mob_ai_cooperation
	name = "SIMPLE MOBS: Polaris AI cooperation"
	groups = list("generic", "simple mob ai")

/datum/unit_test/simple_mob_ai_cooperation/start_test()
	var/turf/caller_turf = locate(71, 155, 1)
	var/turf/helper_turf = get_step(caller_turf, EAST)
	var/turf/target_turf = get_step(caller_turf, NORTH)
	if(!caller_turf || !helper_turf || !target_turf)
		return TEST_FAIL("Could not locate turfs for the AI cooperation test.")

	var/mob/living/simple_animal/hostile/unit_test_ai/caller_mob = new(caller_turf)
	var/mob/living/simple_animal/hostile/unit_test_ai/helper = new(helper_turf)
	var/mob/living/simple_animal/unit_test_ai_target/target_mob = new(target_turf)
	caller_mob.ai_holder.give_target(target_mob, TRUE)
	helper.ai_holder.help_requested(caller_mob, target_mob)
	if(helper.ai_holder.target != target_mob)
		qdel(caller_mob)
		qdel(helper)
		qdel(target_mob)
		return TEST_FAIL("Cooperative AI did not accept a nearby ally's valid target.")

	qdel(caller_mob)
	qdel(helper)
	qdel(target_mob)
	return TEST_PASS("Cooperative holders share nearby threats.")

/datum/unit_test/simple_mob_ai_callbacks
	name = "SIMPLE MOBS: holder target and combat callbacks"
	groups = list("generic", "simple mob ai")

/datum/unit_test/simple_mob_ai_callbacks/start_test()
	var/turf/hostile_turf = locate(71, 155, 1)
	var/turf/target_turf = get_step(hostile_turf, NORTH)
	if(!hostile_turf || !target_turf)
		return TEST_FAIL("Could not locate adjacent turfs for the AI callback test.")

	var/mob/living/simple_animal/hostile/unit_test_ai_callbacks/hostile_mob = new(hostile_turf)
	var/mob/living/simple_animal/unit_test_ai_target/target_mob = new(target_turf)
	var/datum/ai_holder/simple_animal/hostile/unit_test_callbacks/callback_ai = hostile_mob.ai_holder
	callback_ai.give_target(target_mob, TRUE)
	if(callback_ai.acquired != target_mob)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Holder acquisition callback did not receive the new target.")
	callback_ai.engage_target()
	if(callback_ai.attacked != target_mob)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Holder post-melee callback did not receive the attacked target.")
	callback_ai.remove_target(FALSE)
	if(callback_ai.lost != target_mob)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Holder loss callback did not receive the removed target.")

	qdel(hostile_mob)
	qdel(target_mob)
	return TEST_PASS("Target acquisition, loss, and post-attack extensions are holder-owned.")

/datum/unit_test/simple_mob_ai_profiles
	name = "SIMPLE MOBS: Polaris AI profile assignments"
	groups = list("generic", "simple mob ai")

/datum/unit_test/simple_mob_ai_profiles/start_test()
	var/turf/spawn_turf = locate(71, 155, 1)
	if(!spawn_turf)
		return TEST_FAIL("Could not locate a turf for the AI profile test.")

	var/mob/living/simple_animal/hostile/pirate/pirate = new(spawn_turf)
	var/mob/living/simple_animal/slime/slime = new(spawn_turf)
	var/mob/living/simple_animal/hostile/hivebot/range/hivebot = new(spawn_turf)
	var/mob/living/simple_animal/hostile/commanded/bear/commanded_bear = new(spawn_turf)
	if(!istype(pirate.ai_holder, /datum/ai_holder/simple_animal/humanoid/pirate/hostile))
		qdel(pirate)
		qdel(slime)
		qdel(hivebot)
		qdel(commanded_bear)
		return TEST_FAIL("Pirates did not receive the humanoid tactical profile.")
	if(!istype(slime.ai_holder, /datum/ai_holder/simple_animal/slime))
		qdel(pirate)
		qdel(slime)
		qdel(hivebot)
		qdel(commanded_bear)
		return TEST_FAIL("Pet slimes did not receive the compatible slime profile.")
	if(!istype(hivebot.ai_holder, /datum/ai_holder/simple_animal/hivebot/ranged))
		qdel(pirate)
		qdel(slime)
		qdel(hivebot)
		qdel(commanded_bear)
		return TEST_FAIL("Ranged hivebots did not receive their ranged cooperative profile.")
	commanded_bear.change_stance(COMMANDED_MISC)
	if(commanded_bear.stance != COMMANDED_MISC || commanded_bear.ai_holder.stance != AI_STANCE_SPECIAL)
		qdel(pirate)
		qdel(slime)
		qdel(hivebot)
		qdel(commanded_bear)
		return TEST_FAIL("Commanded mob special stances were not preserved by the AI holder.")

	qdel(pirate)
	qdel(slime)
	qdel(hivebot)
	qdel(commanded_bear)
	return TEST_PASS("Specialized Aurora simple mobs receive their intended Polaris profiles.")

/datum/unit_test/simple_mob_ai_special_profiles
	name = "SIMPLE MOBS: migrated special AI profile coverage"
	groups = list("generic", "simple mob ai")

/datum/unit_test/simple_mob_ai_special_profiles/start_test()
	var/turf/spawn_turf = locate(71, 155, 1)
	if(!spawn_turf)
		return TEST_FAIL("Could not locate a turf for the special AI profile coverage test.")

	var/list/profile_pairs = list(
		list(/mob/living/simple_animal/bee, /datum/ai_holder/simple_animal/passive/bee),
		list(/mob/living/simple_animal/cosmozoan, /datum/ai_holder/simple_animal/passive/cosmozoan),
		list(/mob/living/simple_animal/parrot, /datum/ai_holder/simple_animal/passive/parrot),
		list(/mob/living/simple_animal/hostile/bear, /datum/ai_holder/simple_animal/bear),
		list(/mob/living/simple_animal/hostile/bear/spatial, /datum/ai_holder/simple_animal/bear/spatial),
		list(/mob/living/simple_animal/hostile/giant_spider/nurse, /datum/ai_holder/simple_animal/giant_spider/nurse),
		list(/mob/living/simple_animal/hostile/retaliate/goat, /datum/ai_holder/simple_animal/retaliate/goat),
		list(/mob/living/simple_animal/chicken, /datum/ai_holder/simple_animal/passive/chicken),
		list(/mob/living/simple_animal/hostile/hivebot/guardian, /datum/ai_holder/simple_animal/hivebot/guardian),
		list(/mob/living/simple_animal/hostile/hivebot/bomber, /datum/ai_holder/simple_animal/hivebot/bomber),
		list(/mob/living/simple_animal/hostile/hivebotbeacon, /datum/ai_holder/simple_animal/hivebot/beacon),
		list(/mob/living/simple_animal/hostile/retaliate/hivebotharvester, /datum/ai_holder/simple_animal/retaliate/hivebot_harvester),
		list(/mob/living/simple_animal/hostile/retaliate/minedrone, /datum/ai_holder/simple_animal/retaliate/minedrone),
		list(/mob/living/simple_animal/hostile/greatworm, /datum/ai_holder/simple_animal/hostile/greatworm)
	)
	for(var/list/profile_pair as anything in profile_pairs)
		var/mob_path = profile_pair[1]
		var/holder_path = profile_pair[2]
		var/mob/living/simple_animal/test_mob = new mob_path(spawn_turf)
		if(!istype(test_mob.ai_holder, holder_path))
			var/failure = "[mob_path] received [test_mob.ai_holder?.type] instead of [holder_path]."
			qdel(test_mob)
			return TEST_FAIL(failure)
		qdel(test_mob)

	return TEST_PASS("Former think, Life, and target-hook special behaviors receive dedicated AI holders.")

/datum/unit_test/simple_mob_ai_specialized_hostility
	name = "SIMPLE MOBS: specialized Polaris profiles retain hostility"
	groups = list("generic", "simple mob ai")

/datum/unit_test/simple_mob_ai_specialized_hostility/start_test()
	var/turf/hostile_turf = locate(71, 155, 1)
	var/turf/target_turf = get_step(hostile_turf, NORTH)
	if(!hostile_turf || !target_turf)
		return TEST_FAIL("Could not locate adjacent turfs for the specialized hostility test.")

	var/mob/living/simple_animal/unit_test_ai_target/target_mob = new(target_turf)
	var/list/specialists = list(
		new /mob/living/simple_animal/hostile/giant_spider/hunter(hostile_turf),
		new /mob/living/simple_animal/hostile/giant_spider/bombardier/unit_test_ai(hostile_turf),
		new /mob/living/simple_animal/hostile/icarus_drone(hostile_turf)
	)

	for(var/mob/living/simple_animal/hostile/specialist as anything in specialists)
		if(!specialist.ai_holder?.hostile)
			QDEL_LIST(specialists)
			qdel(target_mob)
			return TEST_FAIL("[specialist] received a tactical holder that was not hostile.")
		if(istype(specialist, /mob/living/simple_animal/hostile/icarus_drone))
			continue // Station drones deliberately reject neutral animals as targets.
		specialist.ai_holder.find_target(list(target_mob))
		if(specialist.ai_holder.target != target_mob)
			QDEL_LIST(specialists)
			qdel(target_mob)
			return TEST_FAIL("[specialist] failed to acquire a valid adjacent target.")
		if(istype(specialist, /mob/living/simple_animal/hostile/giant_spider/bombardier/unit_test_ai))
			var/mob/living/simple_animal/hostile/giant_spider/bombardier/unit_test_ai/bombardier = specialist
			if(bombardier.ai_holder.ranged_attack(target_mob) != AI_ATTACK_SUCCESS || bombardier.shots_fired != 1)
				QDEL_LIST(specialists)
				qdel(target_mob)
				return TEST_FAIL("Greimorian bombardier failed to dispatch its custom acid-spray ranged attack.")

	QDEL_LIST(specialists)
	qdel(target_mob)
	return TEST_PASS("Evasive, kiting, and threatening tactical profiles remain hostile, and Greimorians acquire targets.")

/datum/unit_test/xenobio_slime_ai
	name = "SIMPLE MOBS: xenobiology slime Polaris AI adapter"
	groups = list("generic", "simple mob ai")

/datum/unit_test/xenobio_slime_ai/start_test()
	var/turf/slime_turf = locate(71, 155, 1)
	var/turf/target_turf = get_step(slime_turf, NORTH)
	if(!slime_turf || !target_turf)
		return TEST_FAIL("Could not locate adjacent turfs for the xenobiology slime AI test.")

	var/mob/living/carbon/slime/slime = new(slime_turf)
	var/mob/living/simple_animal/unit_test_ai_target/food = new(target_turf)
	if(!istype(slime.ai_holder, /datum/ai_holder/simple_animal/xenobio_slime))
		qdel(slime)
		qdel(food)
		return TEST_FAIL("Xenobiology slime did not receive its Polaris AI holder.")

	slime.nutrition = 100
	slime.ai_holder.find_target(list(food))
	if(slime.ai_holder.target != food)
		qdel(slime)
		qdel(food)
		return TEST_FAIL("Hungry xenobiology slime failed to acquire an edible target.")

	food.lying = TRUE
	var/old_health = food.health
	slime.ai_holder.engage_target()
	if(slime.victim != food || food.health >= old_health || !slime.feeding_timer)
		qdel(slime)
		qdel(food)
		return TEST_FAIL("Xenobiology slime failed to begin timer-driven feeding through its AI combat interface.")

	slime.Feedstop()
	if(slime.victim || slime.feeding_timer || slime.anchored || !slime.canmove)
		qdel(slime)
		qdel(food)
		return TEST_FAIL("Stopping xenobiology slime feeding did not restore its movement state.")

	slime.amount_grown = 5
	if(!slime.AISlimeEvolve() || !slime.is_adult)
		qdel(slime)
		qdel(food)
		return TEST_FAIL("Xenobiology slime growth interface failed to evolve a ready baby.")

	var/mob/living/carbon/slime/light_pink_slime = new(slime_turf, "light pink")
	if(!istype(light_pink_slime.ai_holder, /datum/ai_holder/simple_animal/xenobio_slime/light_pink) || light_pink_slime.discipline != 10)
		qdel(slime)
		qdel(food)
		qdel(light_pink_slime)
		return TEST_FAIL("Light pink slime did not receive its obedient colour-specific AI profile.")

	slime.friends[food] = 3
	if(!slime.AISlimeCanCommand(food))
		qdel(slime)
		qdel(food)
		qdel(light_pink_slime)
		return TEST_FAIL("Xenobiology slime friendship was not exposed to the holder command interface.")

	qdel(slime)
	qdel(food)
	qdel(light_pink_slime)
	return TEST_PASS("Xenobiology slimes target, feed, grow, and select colour profiles through Polaris AI.")
