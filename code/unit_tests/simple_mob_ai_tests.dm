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
	var/turf/hostile_turf = locate(2, 2, 1)
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
	if(hostile_mob.ai_holder.uses_astar())
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("An idle normal mob enabled combat-only A* pathfinding.")

	hostile_mob.ai_holder.find_target(list(target_mob))
	if(hostile_mob.ai_holder.target != target_mob)
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("Hostile AI failed to acquire a valid adjacent target.")
	if(!hostile_mob.ai_holder.uses_astar())
		qdel(hostile_mob)
		qdel(target_mob)
		return TEST_FAIL("A normal mob did not enable A* pathfinding after entering combat.")
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
	var/turf/hostile_turf = locate(2, 2, 1)
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
	var/turf/caller_turf = locate(2, 2, 1)
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
	var/turf/hostile_turf = locate(2, 2, 1)
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
	var/turf/spawn_turf = locate(2, 2, 1)
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
	var/turf/spawn_turf = locate(2, 2, 1)
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
	var/turf/hostile_turf = locate(2, 2, 1)
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

/datum/unit_test/mob_onslaught
	name = "GAMEMODE: Mob Onslaught hidden wave integration"
	groups = list("generic", "simple mob ai")

/datum/unit_test/mob_onslaught/start_test()
	var/turf/spawn_turf = locate(10, 10, 1)
	var/turf/target_turf = get_step(spawn_turf, NORTH)
	if(!spawn_turf || !target_turf)
		return TEST_FAIL("Could not locate adjacent turfs for the Mob Onslaught test.")
	for(var/turf/test_turf in RANGE_TURFS(5, target_turf))
		test_turf.ChangeTurf(/turf/simulated/floor)

	var/datum/game_mode/mob_onslaught/mode = new
	if(mode.mode_duration != 30 MINUTES)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught is not configured for a 30-minute round.")
	if(mode.grace_period != 5 MINUTES)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught is not configured with a five-minute grace period.")
	if(mode.canon_type != /singleton/canonicity/non_canon_event)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught is not configured as a non-canon event.")
	if(!(TRAIT_DEAFNESS_IMMUNITY in mode.player_traits))
		qdel(mode)
		return TEST_FAIL("Mob Onslaught does not grant the generic deafness-immunity player trait.")
	if(mode.spawn_protection_grace_period != 2 MINUTES)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught latejoin protection does not use a two-minute post-departure grace period.")
	if(mode.get_desired_wave_size(1, 1) != 1 || mode.get_desired_wave_size(1, 5) != 16 || mode.get_desired_wave_size(3, 4) != 24)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught wave size does not scale exponentially from the active player count.")
	if(mode.get_active_mob_cap(1) != 20 || mode.get_active_mob_cap(5) != 100)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught does not allow twenty active hostile mobs per eligible player.")
	if(mode.ship_infestation_size != 30)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught does not configure the expected thirty-mob uncapped ship infestation.")
	if(length(mode.get_next_wave_radio_lines()) < 5)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught does not provide a varied pool of Intern next-wave radio messages.")
	if(mode.allow_overmap_hazards || mode.allow_away_sites || mode.announce_roundstart_sensor_report)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught does not disable its optional overmap content and roundstart sensor announcement.")
	var/mob/living/carbon/human/latejoiner = new(target_turf)
	mode.handle_latejoin(latejoiner)
	if(!(latejoiner.status_flags & GODMODE) || length(mode.spawn_protections) != 1)
		qdel(latejoiner)
		qdel(mode)
		return TEST_FAIL("A Mob Onslaught latejoiner did not receive mode-owned invulnerability.")
	var/datum/mob_onslaught_spawn_protection/protection = mode.spawn_protections[1]
	var/area/original_latejoin_area = get_area(target_turf)
	var/area/departure_area = new
	target_turf.change_area(original_latejoin_area, departure_area)
	mode.process_spawn_protections()
	if(!protection.expires_at || protection.expires_at != world.time + mode.spawn_protection_grace_period)
		target_turf.change_area(departure_area, original_latejoin_area)
		qdel(departure_area)
		qdel(latejoiner)
		qdel(mode)
		return TEST_FAIL("Leaving the latejoin area did not start the spawn-protection grace period.")
	protection.expires_at = world.time
	mode.process_spawn_protections()
	if((latejoiner.status_flags & GODMODE) || length(mode.spawn_protections))
		target_turf.change_area(departure_area, original_latejoin_area)
		qdel(departure_area)
		qdel(latejoiner)
		qdel(mode)
		return TEST_FAIL("Expired Mob Onslaught spawn protection did not revoke invulnerability.")
	target_turf.change_area(departure_area, original_latejoin_area)
	qdel(departure_area)
	qdel(latejoiner)
	var/obj/structure/closet/secure_closet/test_locker = new(spawn_turf)
	if(length(mode.get_locker_melee_pool()) < 15 || length(mode.get_locker_projectile_loadouts()) < 6 || length(mode.get_locker_energy_pool()) < 9)
		qdel(test_locker)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught weapon pools do not provide the expected expanded variety.")
	if(!mode.supply_locker(test_locker))
		qdel(test_locker)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught failed to supply a departmental locker.")
	var/melee_count = 0
	var/projectile_count = 0
	var/energy_count = 0
	var/magazine_count = 0
	var/obj/item/gun/projectile/projectile_weapon
	for(var/obj/item/locker_item in test_locker)
		if(is_type_in_list(locker_item, mode.get_locker_melee_pool()))
			melee_count++
		if(istype(locker_item, /obj/item/gun/projectile))
			projectile_count++
			projectile_weapon = locker_item
		if(istype(locker_item, /obj/item/gun/energy))
			energy_count++
		if(istype(locker_item, /obj/item/ammo_magazine))
			magazine_count++
	if(melee_count != 1 || projectile_count != 1 || energy_count != 1 || magazine_count != 2)
		qdel(test_locker)
		qdel(mode)
		return TEST_FAIL("A supplied locker did not receive one melee weapon, one projectile weapon, two spare magazines, and one energy weapon.")
	for(var/obj/item/ammo_magazine/spare_magazine in test_locker)
		if(!is_type_in_list(spare_magazine, projectile_weapon.allowed_magazines))
			qdel(test_locker)
			qdel(mode)
			return TEST_FAIL("A supplied locker received a spare magazine incompatible with its projectile weapon.")
	qdel(test_locker)
	var/mob/living/simple_animal/unit_test_ai_target/target_mob = new(target_turf)
	var/mob/living/simple_animal/hostile/spawned_mob = mode.spawn_wave_mob(/mob/living/simple_animal/hostile/scarybat, spawn_turf, target_mob)
	if(!spawned_mob || spawned_mob.faction != "mob_onslaught" || spawned_mob.ai_holder?.target != target_mob)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("A wave mob did not receive the shared faction and holder-owned player target.")
	if(!(spawned_mob in mode.active_wave_mobs) || mode.total_spawned != 1)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("The mode did not track its spawned hostile.")
	if(!spawned_mob.ai_holder?.instant_door_destruction || !spawned_mob.ai_holder.use_astar)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("A Mob Onslaught hostile was not configured to path through and destroy blocking doors.")
	var/list/test_path = spawned_mob.ai_holder.get_path(target_turf, 0, 10)
	if(length(test_path) && test_path[1] == spawn_turf)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("The AI holder retained its current turf as the first A* movement step.")
	var/obj/structure/machinery/door/window/test_windoor = new(spawn_turf)
	test_windoor.set_dir(get_dir(spawn_turf, target_turf))
	if(!spawned_mob.ai_holder.destroy_blocking_door(get_dir(spawn_turf, target_turf)) || !QDELETED(test_windoor))
		qdel(test_windoor)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("A Mob Onslaught hostile failed to destroy a blocking windoor.")
	var/obj/structure/machinery/door/airlock/test_airlock = new(target_turf)
	var/list/door_path = spawned_mob.ai_holder.get_path(target_turf, 0, 10)
	if(!length(door_path) || door_path[1] != target_turf)
		qdel(test_airlock)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("A Mob Onslaught hostile could not plan a path through a destructible airlock.")
	test_airlock.CollidedWith(spawned_mob)
	if(!QDELETED(test_airlock))
		qdel(test_airlock)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("A Mob Onslaught hostile failed to destroy an airlock it collided with.")
	var/obj/structure/railing/test_railing = new(spawn_turf)
	test_railing.set_dir(get_dir(spawn_turf, target_turf))
	var/list/railing_path = spawned_mob.ai_holder.get_path(target_turf, 0, 10)
	if(!length(railing_path) || railing_path[1] != target_turf)
		qdel(test_railing)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("A Mob Onslaught hostile standing on a railing could not plan a path through it.")
	if(!spawned_mob.ai_holder.destroy_blocking_door(get_dir(spawn_turf, target_turf)) || !QDELETED(test_railing))
		qdel(test_railing)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("A Mob Onslaught hostile failed to destroy a blocking railing.")
	if(spawned_mob.ai_holder?.mode_ai_owner != mode)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("A wave mob was not connected to Mob Onslaught's idle convergence rules.")
	var/mob/living/simple_animal/hostile/ambient_mob = mode.spawn_wave_mob(/mob/living/simple_animal/hostile/scarybat, spawn_turf, target_mob, FALSE, FALSE, FALSE)
	if(!ambient_mob || ambient_mob.ai_holder?.target || ambient_mob.ai_holder?.mode_ai_owner || ambient_mob.ai_holder?.use_astar || !(ambient_mob in mode.uncapped_ship_mobs))
		qdel(ambient_mob)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("An uncapped ship infestation mob received wave targeting or Central Ring convergence orders.")
	qdel(ambient_mob)
	mode.uncapped_ship_mobs -= ambient_mob
	var/list/ambush_turfs = RANGE_TURFS(5, target_turf)
	var/area/original_ambush_area = get_area(target_turf)
	var/area/horizon/ambush_area = new
	for(var/turf/ambush_turf as anything in ambush_turfs)
		ambush_turf.change_area(original_ambush_area, ambush_area)
	var/ambush_spawned = mode.spawn_player_ambushes(list(target_mob), list(/mob/living/simple_animal/hostile/scarybat), 2)
	if(ambush_spawned != 2 || length(mode.uncapped_ship_mobs) != 2)
		for(var/turf/ambush_turf as anything in ambush_turfs)
			ambush_turf.change_area(ambush_area, original_ambush_area)
		qdel(ambush_area)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("A player outside the Central Ring did not receive one uncapped ambush mob per wave number.")
	for(var/mob/living/simple_animal/hostile/ambush_mob as anything in mode.uncapped_ship_mobs)
		if(ambush_mob.ai_holder?.target != target_mob || (ambush_mob in mode.active_wave_mobs))
			for(var/turf/ambush_turf as anything in ambush_turfs)
				ambush_turf.change_area(ambush_area, original_ambush_area)
			qdel(ambush_area)
			qdel(spawned_mob)
			qdel(target_mob)
			qdel(mode)
			return TEST_FAIL("A player ambush mob counted toward the wave cap or lacked its assigned player target.")
		qdel(ambush_mob)
	mode.uncapped_ship_mobs.Cut()
	for(var/turf/ambush_turf as anything in ambush_turfs)
		ambush_turf.change_area(ambush_area, original_ambush_area)
	qdel(ambush_area)
	var/area/original_target_area = get_area(target_turf)
	var/area/horizon/hallway/primary/deck_1/central/safe_area = new
	target_turf.change_area(original_target_area, safe_area)
	if(!mode.is_safe_zone(target_turf))
		target_turf.change_area(safe_area, original_target_area)
		qdel(safe_area)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught could not identify the Central Ring safe zone.")
	if(mode.is_valid_spawn_turf(target_turf, list()))
		target_turf.change_area(safe_area, original_target_area)
		qdel(safe_area)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("The Central Ring was accepted as a Mob Onslaught spawn turf.")
	if(mode.spawn_player_ambushes(list(target_mob), list(/mob/living/simple_animal/hostile/scarybat), 2))
		target_turf.change_area(safe_area, original_target_area)
		qdel(safe_area)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("A player inside the Central Ring received an uncapped wave ambush.")
	if(!spawned_mob.ai_holder.can_attack(target_mob, FALSE))
		target_turf.change_area(safe_area, original_target_area)
		qdel(safe_area)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("The Central Ring incorrectly prevented an onslaught mob from attacking a target.")
	target_turf.change_area(safe_area, original_target_area)
	qdel(safe_area)
	var/target_health_before_carp = target_mob.health
	var/mob/living/simple_animal/hostile/carp/wave_carp = mode.spawn_wave_mob(/mob/living/simple_animal/hostile/carp, spawn_turf, target_mob)
	wave_carp.ai_holder.think()
	if(target_mob.health >= target_health_before_carp)
		qdel(wave_carp)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("A Mob Onslaught space carp did not attack its assigned adjacent player target.")
	qdel(wave_carp)

	var/list/early_pool = mode.get_regular_mob_pool(1)
	var/list/escalated_pool = mode.get_regular_mob_pool(6)
	if(length(early_pool) < 9 || length(escalated_pool) < 28)
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught does not provide the expected expanded non-humanoid mob variety.")
	if((/mob/living/simple_animal/hostile/faithless in escalated_pool) || (/mob/living/simple_animal/hostile/bear in early_pool) || !(/mob/living/simple_animal/hostile/bear in escalated_pool))
		qdel(spawned_mob)
		qdel(target_mob)
		qdel(mode)
		return TEST_FAIL("Mob Onslaught difficulty pools did not escalate at the configured wave.")
	var/list/explosive_mob_types = list(
		/mob/living/simple_animal/hostile/plasmageist,
		/mob/living/simple_animal/hostile/carp/bloater,
		/mob/living/simple_animal/hostile/hivebot/bomber,
		/mob/living/simple_animal/hostile/icarus_drone
	)
	var/list/late_boss_pool = mode.get_boss_mob_pool(10)
	for(var/explosive_mob_type in explosive_mob_types)
		if((explosive_mob_type in escalated_pool) || (explosive_mob_type in late_boss_pool))
			qdel(spawned_mob)
			qdel(target_mob)
			qdel(mode)
			return TEST_FAIL("Mob Onslaught includes an explosion-producing mob capable of deafening the crew.")

	var/list/hidden_turfs = mode.get_hidden_spawn_turfs(list(target_mob))
	for(var/turf/hidden_turf as anything in hidden_turfs)
		if(isspaceturf(hidden_turf) || !istype(hidden_turf, /turf/simulated/floor))
			qdel(spawned_mob)
			qdel(target_mob)
			qdel(mode)
			return TEST_FAIL("The hidden spawn selector returned a space or non-floor turf.")
		if(hidden_turf in view(world.view, target_mob))
			qdel(spawned_mob)
			qdel(target_mob)
			qdel(mode)
			return TEST_FAIL("The hidden spawn selector returned a turf visible to its player anchor.")

	qdel(spawned_mob)
	qdel(target_mob)
	qdel(mode)
	return TEST_PASS("Mob Onslaught disables optional overmap content, supplies lockers, protects latejoiners, keeps carp hostile, excludes Central Ring spawning without suppressing attacks, and spawns hostiles only on hidden non-space floor turfs.")

/datum/unit_test/xenobio_slime_ai
	name = "SIMPLE MOBS: xenobiology slime Polaris AI adapter"
	groups = list("generic", "simple mob ai")

/datum/unit_test/xenobio_slime_ai/start_test()
	var/turf/slime_turf = locate(2, 2, 1)
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
