/**
 * PvE wave mode which places hostile simple mobs near the crew without popping
 * them into existence on anyone's screen. Spawned mobs share a faction and are
 * immediately given the nearest player as an AI-holder target.
 */
/datum/mob_onslaught_spawn_protection
	var/mob/living/carbon/human/player
	var/area/spawn_area
	var/expires_at = 0
	var/applied_godmode = FALSE

/datum/mob_onslaught_spawn_protection/New(mob/living/carbon/human/new_player)
	player = new_player
	spawn_area = get_area(new_player)
	applied_godmode = !(player.status_flags & GODMODE)
	player.status_flags |= GODMODE

/datum/mob_onslaught_spawn_protection/Destroy()
	revoke()
	player = null
	spawn_area = null
	return ..()

/datum/mob_onslaught_spawn_protection/proc/process_protection(grace_period)
	if(QDELETED(player))
		return FALSE
	if(!expires_at && get_area(player) != spawn_area)
		expires_at = world.time + grace_period
		to_chat(player, SPAN_NOTICE(SPAN_BOLD("You have left the arrival area. Your Mob Onslaught spawn protection will expire in two minutes.")))
	if(expires_at && world.time >= expires_at)
		to_chat(player, SPAN_WARNING(SPAN_BOLD("Your Mob Onslaught spawn protection has expired.")))
		return FALSE
	player.status_flags |= GODMODE
	return TRUE

/datum/mob_onslaught_spawn_protection/proc/revoke()
	if(player && applied_godmode)
		player.status_flags &= ~GODMODE
	applied_godmode = FALSE

/datum/game_mode/mob_onslaught
	name = "Mob Onslaught"
	config_tag = "mob_onslaught"
	round_description = "Hostile creatures are converging on the station. Stay alert and protect one another."
	extended_round_description = "A 30-minute PvE survival mode. Waves of increasingly dangerous hostile mobs appear near active crew, always outside the current view of every living player."
	required_players = 1
	required_enemies = 0
	votable = TRUE
	probability = 0
	allow_overmap_hazards = FALSE
	allow_away_sites = FALSE
	announce_roundstart_sensor_report = FALSE
	instant_respawn = TRUE
	canon_type = /singleton/canonicity/non_canon_event
	player_traits = list(TRAIT_DEAFNESS_IMMUNITY)

	/// Delay before the first wave gives the crew time to equip themselves.
	var/grace_period = 5 MINUTES
	/// The round ends through the ticker's normal completion path after this duration.
	var/mode_duration = 30 MINUTES
	var/round_end_time = INFINITY
	var/round_end_requested = FALSE
	/// Initial time between successful waves.
	var/base_wave_delay = 2 MINUTES
	/// Lower bound reached as the mode escalates.
	var/minimum_wave_delay = 30 SECONDS
	/// Retry delay when no hidden spawn turf is presently available.
	var/failed_wave_retry_delay = 30 SECONDS
	var/next_wave = INFINITY
	var/wave_number = 0
	/// Each successive wave multiplies its player-scaled size by this amount.
	var/wave_growth_base = 2
	/// Maximum number of living Onslaught mobs allowed per eligible player.
	var/mob_cap_per_player = 20
	var/min_spawn_distance = 5
	var/max_spawn_distance = 14
	/// Wave ambushes appear close enough to immediately threaten players who have not mustered.
	var/player_ambush_min_distance = 2
	var/player_ambush_max_distance = 5
	/// One-time uncapped infestation distributed around the ship when the grace period ends.
	var/ship_infestation_size = 30
	var/ship_infestation_spawned = FALSE
	var/total_spawned = 0
	var/mobs_defeated = 0
	var/list/mob/living/simple_animal/hostile/active_wave_mobs = list()
	var/list/mob/living/simple_animal/hostile/uncapped_ship_mobs = list()
	var/list/safe_zone_turfs_by_z = list()
	var/spawn_protection_grace_period = 2 MINUTES
	var/list/datum/mob_onslaught_spawn_protection/spawn_protections = list()
	/// Saved character IDs and names which each player has already lost this round.
	var/list/used_character_ids_by_ckey = list()
	var/list/used_character_names_by_ckey = list()

/datum/game_mode/mob_onslaught/pre_setup()
	round_description = "Hostile creatures are converging on the [SSatlas.current_map.station_type]. Stay alert and protect one another."
	. = ..()
	disable_overmap_content()
	return .

/datum/game_mode/mob_onslaught/post_setup()
	. = ..()
	next_wave = round_duration_in_ticks + grace_period
	round_end_time = round_duration_in_ticks + mode_duration
	cache_safe_zone_turfs()
	var/armed_lockers = arm_departmental_lockers()
	addtimer(CALLBACK(src, PROC_REF(announce_initial_threat)), 10 SECONDS)
	log_and_message_admins("Mob Onslaught: supplied [armed_lockers] departmental lockers with randomized melee weapons and firearms.")

/datum/game_mode/mob_onslaught/proc/announce_initial_threat()
	if(SSticker.mode != src || SSticker.current_state != GAME_STATE_PLAYING)
		return
	command_announcement.Announce("Long Range Sensors are detect- hold on... What the fuck? Multiple bluespace signatures detected approaching the [SSatlas.current_map.station_name]! Authorizing experimental weaponry-warp procedure! Grab weapons from your lockers and muster in the Central Ring, this is not a drill! The bluespace flux is estimated to last about thirty minutes, hitting in five!", "BS-LR Threat Detection - Intern Manned", new_sound = 'sound/ai/announcements/security_level.ogg')
	addtimer(CALLBACK(src, PROC_REF(raise_red_alert)), 3 SECONDS)

/datum/game_mode/mob_onslaught/proc/raise_red_alert()
	if(SSticker.mode != src || SSticker.current_state != GAME_STATE_PLAYING)
		return
	set_security_level(SEC_LEVEL_RED)

/// Away content and hazards are built before game-mode selection. Remove those
/// preloaded overmap entries, while retaining the Horizon, its shuttles, and planets.
/datum/game_mode/mob_onslaught/proc/disable_overmap_content()
	var/hazards_removed = 0
	var/list/registered_hazards = overmap_event_handler.hazards.Copy()
	for(var/obj/effect/overmap/event/hazard as anything in registered_hazards)
		hazards_removed++
		qdel(hazard)

	var/away_objects_removed = 0
	var/list/registered_overmap_objects = SSovermap.processing.Copy()
	for(var/obj/effect/overmap/visitable/visitable as anything in registered_overmap_objects)
		if(!is_loaded_away_visitable(visitable))
			continue
		away_objects_removed++
		qdel(visitable)

	log_and_message_admins("Mob Onslaught: disabled overmap hazards and removed [hazards_removed] hazard entries plus [away_objects_removed] away-site/offship entries.")

/datum/game_mode/mob_onslaught/proc/is_loaded_away_visitable(obj/effect/overmap/visitable/visitable)
	if(!visitable)
		return FALSE
	for(var/zlevel in visitable.map_z)
		var/datum/map_template/template = GLOB.map_templates["[zlevel]"]
		if(istype(template, /datum/map_template/ruin/away_site))
			return TRUE
	return FALSE

/datum/game_mode/mob_onslaught/process()
	..()
	process_spawn_protections()
	if(round_end_requested)
		return
	if(round_duration_in_ticks >= round_end_time)
		round_end_requested = TRUE
		next_wave = INFINITY
		command_announcement.Announce("I-Is it over? Holy moly, it's over! WE DID IT! WOOOOOOOOOOOOOOOOO YEAHHHHH BABYYYYYYYYYY!", "BS-LR Threat Detection - Intern Manned")
		// process() runs inside the ticker's game tick, so defer the forced tick to
		// avoid recursively entering it. This preserves normal completion, cleanup,
		// round-end hooks, and the configured automatic restart delay.
		addtimer(CALLBACK(src, PROC_REF(end_timed_round)), 1)
		return
	if(GLOB.evacuation_controller.round_over() || round_duration_in_ticks < next_wave)
		return

	if(!ship_infestation_spawned)
		ship_infestation_spawned = TRUE
		var/infestation_spawned = spawn_ship_infestation()
		log_and_message_admins("Mob Onslaught: seeded [infestation_spawned] uncapped hostile mobs throughout the ship after the grace period.")

	var/next_wave_number = wave_number + 1
	var/spawned = spawn_wave(next_wave_number)
	if(!spawned)
		next_wave = round_duration_in_ticks + failed_wave_retry_delay
		return

	wave_number = next_wave_number
	var/current_delay = max(minimum_wave_delay, base_wave_delay - ((wave_number - 1) * 10 SECONDS))
	next_wave = round_duration_in_ticks + current_delay
	announce_next_wave_radio()
	log_and_message_admins("Mob Onslaught: spawned [spawned] hostile mobs for wave [wave_number]. [length(active_wave_mobs)] remain active.")

/datum/game_mode/mob_onslaught/proc/announce_next_wave_radio()
	GLOB.global_announcer.autosay(pick(get_next_wave_radio_lines()), "Intern", "Common", ACCENT_CETI)

/datum/game_mode/mob_onslaught/proc/get_next_wave_radio_lines()
	return list(
		"N-next wave! They're coming through now!",
		"Next wave! Get ready, get ready!",
		"Uh, next wave! More signatures just appeared!",
		"Next wave incoming! Please tell me you're all in the Ring!",
		"They're back! Next wave!",
		"More bluespace contacts! That's the next wave!",
		"Next wave, people! Brace yourselves!",
		"Oh no, here comes the next wave!"
	)

/datum/game_mode/mob_onslaught/handle_latejoin(mob/living/carbon/human/character)
	. = ..()
	if(!istype(character) || QDELETED(character))
		return
	var/datum/mob_onslaught_spawn_protection/protection = new(character)
	spawn_protections += protection
	to_chat(character, SPAN_GOOD(SPAN_BOLD("Mob Onslaught spawn protection is active. You are invulnerable while you remain in this arrival area; after leaving, it will last for another two minutes.")))

/datum/game_mode/mob_onslaught/handle_mob_death(mob/dead_mob)
	if(!ishuman(dead_mob) || !dead_mob.ckey)
		return
	var/player_ckey = dead_mob.ckey
	if(dead_mob.character_id)
		var/list/used_ids = used_character_ids_by_ckey[player_ckey]
		if(!islist(used_ids))
			used_ids = list()
			used_character_ids_by_ckey[player_ckey] = used_ids
		used_ids |= dead_mob.character_id
	var/character_name = lowertext(dead_mob.real_name)
	if(character_name)
		var/list/used_names = used_character_names_by_ckey[player_ckey]
		if(!islist(used_names))
			used_names = list()
			used_character_names_by_ckey[player_ckey] = used_names
		used_names |= character_name

/datum/game_mode/mob_onslaught/can_spawn_character(mob/abstract/new_player/player, feedback = TRUE)
	if(!player?.client)
		return FALSE
	var/player_ckey = player.client.ckey
	var/character_id = player.client.prefs.current_character
	var/character_name = lowertext(player.client.prefs.real_name)
	var/list/used_ids = used_character_ids_by_ckey[player_ckey]
	var/list/used_names = used_character_names_by_ckey[player_ckey]
	if((character_id && islist(used_ids) && (character_id in used_ids)) || (character_name && islist(used_names) && (character_name in used_names)))
		if(feedback)
			to_chat(player, SPAN_DANGER("That character has already died during this Mob Onslaught round. Select a different character before respawning."))
		return FALSE
	return TRUE

/datum/game_mode/mob_onslaught/proc/process_spawn_protections()
	for(var/datum/mob_onslaught_spawn_protection/protection as anything in spawn_protections)
		if(protection.process_protection(spawn_protection_grace_period))
			continue
		spawn_protections -= protection
		qdel(protection)

/datum/game_mode/mob_onslaught/proc/end_timed_round()
	if(SSticker.mode != src || SSticker.current_state != GAME_STATE_PLAYING)
		return
	SSticker.game_tick(TRUE)

/datum/game_mode/mob_onslaught/proc/arm_departmental_lockers()
	. = 0
	for(var/area/station_area as anything in GLOB.the_station_areas)
		for(var/obj/structure/closet/secure_closet/locker in station_area)
			if(!is_departmental_locker(locker))
				continue
			if(supply_locker(locker))
				.++

/datum/game_mode/mob_onslaught/proc/is_departmental_locker(obj/structure/closet/secure_closet/locker)
	if(!locker || !findtext(lowertext(locker.name), "locker"))
		return FALSE
	var/area/locker_area = get_area(locker)
	if(!locker_area || !is_station_level(locker.z) || !is_station_area(locker_area))
		return FALSE
	return locker_area.department && locker_area.department != LOC_PUBLIC && locker_area.department != LOC_MAINTENANCE

/datum/game_mode/mob_onslaught/proc/supply_locker(obj/structure/closet/secure_closet/locker)
	if(!locker)
		return FALSE
	var/melee_type = pick(get_locker_melee_pool())
	var/list/projectile_loadout = pick(get_locker_projectile_loadouts())
	var/projectile_type = projectile_loadout?["weapon"]
	var/magazine_type = projectile_loadout?["magazine"]
	var/energy_type = pick(get_locker_energy_pool())
	if(!melee_type || !projectile_type || !magazine_type || !energy_type)
		return FALSE
	new melee_type(locker)
	new projectile_type(locker)
	new magazine_type(locker)
	new magazine_type(locker)
	new energy_type(locker)
	return TRUE

/datum/game_mode/mob_onslaught/proc/get_locker_melee_pool()
	// Every entry is mapped on the SCCV Horizon or an Odyssey scenario map.
	return list(
		/obj/item/material/hatchet,
		/obj/item/material/hatchet/butch,
		/obj/item/material/hatchet/lumber,
		/obj/item/material/hatchet/machete/steel,
		/obj/item/material/knife,
		/obj/item/material/knife/bayonet,
		/obj/item/material/knife/tacknife,
		/obj/item/material/knife/trench,
		/obj/item/material/twohanded/fireaxe,
		/obj/item/material/twohanded/pike/pitchfork,
		/obj/item/material/twohanded/spear/steel,
		/obj/item/melee/baton/loaded,
		/obj/item/melee/classic_baton,
		/obj/item/melee/energy/axe,
		/obj/item/melee/energy/sword/green,
		/obj/item/melee/energy/sword/knife,
		/obj/item/melee/energy/sword/red,
		/obj/item/melee/telebaton
	)

/datum/game_mode/mob_onslaught/proc/get_locker_projectile_loadouts()
	// Every weapon and its lethal spare magazine are mapped on Horizon or an Odyssey scenario map.
	return list(
		list("weapon" = /obj/item/gun/projectile/automatic/rifle/carbine, "magazine" = /obj/item/ammo_magazine/a556/carbine),
		list("weapon" = /obj/item/gun/projectile/automatic/wt550/lethal, "magazine" = /obj/item/ammo_magazine/mc9mmt),
		list("weapon" = /obj/item/gun/projectile/automatic/x9, "magazine" = /obj/item/ammo_magazine/c45m/auto),
		list("weapon" = /obj/item/gun/projectile/pistol, "magazine" = /obj/item/ammo_magazine/mc9mm),
		list("weapon" = /obj/item/gun/projectile/pistol/sol, "magazine" = /obj/item/ammo_magazine/mc9mm),
		list("weapon" = /obj/item/gun/projectile/sec/lethal, "magazine" = /obj/item/ammo_magazine/c45m)
	)

/datum/game_mode/mob_onslaught/proc/get_locker_energy_pool()
	// Mapped, charged energy weapons only; utility-gun variants are omitted.
	return list(
		/obj/item/gun/energy/blaster,
		/obj/item/gun/energy/blaster/carbine,
		/obj/item/gun/energy/blaster/revolver,
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/laser/shotgun,
		/obj/item/gun/energy/pistol,
		/obj/item/gun/energy/repeater/pistol,
		/obj/item/gun/energy/rifle,
		/obj/item/gun/energy/rifle/laser
	)

/datum/game_mode/mob_onslaught/proc/spawn_wave(wave_index)
	prune_active_mobs()
	var/list/mob/living/players = get_eligible_players()
	if(!length(players))
		return 0

	var/active_cap = get_active_mob_cap(length(players))
	var/available_slots = active_cap - length(active_wave_mobs)
	var/list/regular_pool = get_regular_mob_pool(wave_index)
	var/list/boss_pool = get_boss_mob_pool(wave_index)
	var/spawned_count = 0
	if(available_slots > 0)
		var/desired_count = get_desired_wave_size(length(players), wave_index)
		desired_count = min(desired_count, active_cap, available_slots)
		var/list/spawn_turfs = get_hidden_spawn_turfs(players)
		if(!length(spawn_turfs))
			log_and_message_admins("Mob Onslaught: wave [wave_index] could not find a valid turf hidden from every living player.")
		else
			for(var/index = 1 to desired_count)
				if(!length(spawn_turfs))
					break
				var/turf/spawn_turf = pick(spawn_turfs)
				spawn_turfs -= spawn_turf
				var/mob_type
				if(index == 1 && length(boss_pool) && !(wave_index % 5))
					mob_type = pick(boss_pool)
				else
					mob_type = pick(regular_pool)

				var/is_boss = index == 1 && length(boss_pool) && !(wave_index % 5)
				var/mob/living/nearest_player = get_nearest_player(spawn_turf, players)
				var/mob/living/simple_animal/hostile/spawned_mob = spawn_wave_mob(mob_type, spawn_turf, nearest_player, is_boss)
				if(spawned_mob)
					spawned_count++
					if(is_boss)
						command_announcement.Announce("Aw fucksicles, there's a big one warping in! Keep an eye out for it and put it six feet under, fellas!", "BS-LR Threat Detection - Intern Manned")

	spawned_count += spawn_player_ambushes(players, regular_pool, wave_index)

	return spawned_count

/datum/game_mode/mob_onslaught/proc/spawn_player_ambushes(list/mob/living/players, list/regular_pool, wave_index)
	if(wave_index <= 0 || !length(regular_pool))
		return 0
	for(var/mob/living/player as anything in players)
		if(QDELETED(player) || player.stat == DEAD || is_safe_zone(player))
			continue
		var/list/spawn_turfs = get_player_ambush_turfs(player)
		var/player_spawned = 0
		var/turf/sound_turf
		for(var/index = 1 to wave_index)
			if(!length(spawn_turfs))
				break
			var/turf/spawn_turf = pick(spawn_turfs)
			spawn_turfs -= spawn_turf
			var/mob/living/simple_animal/hostile/spawned_mob = spawn_wave_mob(pick(regular_pool), spawn_turf, player, FALSE, FALSE, TRUE)
			if(!spawned_mob)
				continue
			new /obj/effect/temp_visual/phase(spawn_turf, spawned_mob.dir)
			sound_turf ||= spawn_turf
			player_spawned++
			.++
		if(player_spawned)
			playsound(sound_turf, 'sound/effects/phasein.ogg', 40, TRUE)
		if(player_spawned < wave_index)
			log_and_message_admins("Mob Onslaught: player ambush for [key_name(player)] spawned [player_spawned] of [wave_index] requested uncapped mobs due to limited nearby valid turfs.")

/datum/game_mode/mob_onslaught/proc/get_player_ambush_turfs(mob/living/player)
	. = list()
	var/turf/player_turf = get_turf(player)
	if(!player_turf)
		return
	for(var/turf/simulated/floor/candidate as anything in RANGE_TURFS(player_ambush_max_distance, player_turf))
		if(get_dist(candidate, player_turf) < player_ambush_min_distance || !is_valid_spawn_turf(candidate, list()))
			continue
		. += candidate

/datum/game_mode/mob_onslaught/proc/get_desired_wave_size(player_count, wave_index)
	if(player_count <= 0 || wave_index <= 0)
		return 0
	return max(1, n_ceil(player_count * (wave_growth_base ** (wave_index - 1))))

/datum/game_mode/mob_onslaught/proc/get_active_mob_cap(player_count)
	return max(0, player_count * mob_cap_per_player)

/datum/game_mode/mob_onslaught/proc/spawn_ship_infestation()
	var/list/mob/living/players = get_eligible_players()
	var/list/area_spawn_turfs = list()
	for(var/area/station_area as anything in GLOB.the_station_areas)
		if(is_safe_zone(station_area))
			continue
		var/list/valid_area_turfs = list()
		for(var/turf/simulated/floor/candidate in station_area)
			if(is_valid_spawn_turf(candidate, players))
				valid_area_turfs += candidate
		if(length(valid_area_turfs))
			area_spawn_turfs += pick(valid_area_turfs)

	area_spawn_turfs = shuffle(area_spawn_turfs)
	var/list/regular_pool = get_regular_mob_pool(1)
	var/spawn_count = min(ship_infestation_size, length(area_spawn_turfs))
	for(var/index = 1 to spawn_count)
		var/turf/spawn_turf = area_spawn_turfs[index]
		if(spawn_wave_mob(pick(regular_pool), spawn_turf, null, FALSE, FALSE, FALSE))
			.++

/datum/game_mode/mob_onslaught/proc/spawn_wave_mob(mob_type, turf/spawn_turf, mob/living/target_player, is_boss = FALSE, counts_toward_cap = TRUE, receives_mode_orders = TRUE)
	if(!ispath(mob_type, /mob/living/simple_animal/hostile) || !spawn_turf)
		return
	var/mob/living/simple_animal/hostile/spawned_mob = new mob_type(spawn_turf)
	spawned_mob.faction = "mob_onslaught"
	if(counts_toward_cap)
		active_wave_mobs += spawned_mob
	else
		uncapped_ship_mobs += spawned_mob
	total_spawned++
	if(spawned_mob.ai_holder)
		spawned_mob.ai_holder.instant_door_destruction = TRUE
		if(receives_mode_orders)
			spawned_mob.ai_holder.mode_ai_owner = src
			spawned_mob.ai_holder.mode_ai_high_priority = is_boss
			spawned_mob.ai_holder.use_astar = TRUE
	if(receives_mode_orders && target_player)
		spawned_mob.ai_holder?.give_target(target_player, TRUE)
	return spawned_mob

/datum/game_mode/mob_onslaught/proc/cache_safe_zone_turfs()
	safe_zone_turfs_by_z = list()
	var/list/safe_zone_area_types = list(
		/area/horizon/hallway/primary/deck_1/central,
		/area/horizon/hallway/primary/deck_2/central
	)
	for(var/safe_zone_area_type in safe_zone_area_types)
		var/area/safe_zone_area = locate(safe_zone_area_type)
		if(!safe_zone_area)
			continue
		for(var/turf/simulated/floor/safe_turf in safe_zone_area)
			if(safe_turf.density || safe_turf.is_hole)
				continue
			var/z_key = "[safe_turf.z]"
			LAZYADD(safe_zone_turfs_by_z[z_key], safe_turf)

/datum/game_mode/mob_onslaught/proc/is_safe_zone(atom/target)
	var/area/target_area = get_area(target)
	return istype(target_area, /area/horizon/hallway/primary/deck_1/central) || istype(target_area, /area/horizon/hallway/primary/deck_2/central)

/datum/game_mode/mob_onslaught/get_ai_idle_destination(mob/living/ai_actor, high_priority = FALSE)
	if(!ai_actor || ai_actor.stat == DEAD || is_safe_zone(ai_actor))
		return
	var/list/safe_turfs = safe_zone_turfs_by_z["[ai_actor.z]"]
	if(!length(safe_turfs))
		return
	if(!high_priority)
		return pick(safe_turfs)
	var/turf/closest_safe_turf
	var/closest_distance = INFINITY
	for(var/turf/safe_turf as anything in safe_turfs)
		var/distance = get_dist(ai_actor, safe_turf)
		if(distance < closest_distance)
			closest_safe_turf = safe_turf
			closest_distance = distance
	return closest_safe_turf

/datum/game_mode/mob_onslaught/proc/get_eligible_players()
	. = list()
	for(var/mob/living/player in GLOB.player_list)
		if(!player.client || player.stat == DEAD)
			continue
		var/turf/player_turf = get_turf(player)
		if(!player_turf || !is_station_level(player_turf.z) || !is_station_area(get_area(player_turf)))
			continue
		. += player

/datum/game_mode/mob_onslaught/proc/get_hidden_spawn_turfs(list/mob/living/players)
	. = list()
	for(var/mob/living/player as anything in players)
		var/turf/player_turf = get_turf(player)
		if(!player_turf)
			continue
		for(var/turf/simulated/floor/candidate as anything in RANGE_TURFS(max_spawn_distance, player_turf))
			if(get_dist(candidate, player_turf) < min_spawn_distance || !is_valid_spawn_turf(candidate, players))
				continue
			. |= candidate

/datum/game_mode/mob_onslaught/proc/is_valid_spawn_turf(turf/candidate, list/mob/living/players)
	if(!istype(candidate, /turf/simulated/floor) || isspaceturf(candidate) || candidate.density || candidate.is_hole || is_safe_zone(candidate) || !is_station_level(candidate.z) || !is_station_area(get_area(candidate)))
		return FALSE
	for(var/atom/movable/occupant in candidate)
		if(occupant.density || isliving(occupant))
			return FALSE
	for(var/mob/living/player as anything in players)
		var/atom/view_center = player
		var/view_range = world.view
		if(player.client)
			view_center = player.client.eye
			view_range = player.client.view
		if(view_center && (candidate in view(view_range, view_center)))
			return FALSE
	return TRUE

/datum/game_mode/mob_onslaught/proc/get_nearest_player(turf/origin, list/mob/living/players)
	var/mob/living/nearest
	var/nearest_distance = INFINITY
	for(var/mob/living/player as anything in players)
		if(player.z != origin.z)
			continue
		var/distance = get_dist(origin, player)
		if(distance < nearest_distance)
			nearest = player
			nearest_distance = distance
	return nearest

/datum/game_mode/mob_onslaught/proc/get_regular_mob_pool(wave_index)
	. = list(
		/mob/living/simple_animal/hostile/scarybat,
		/mob/living/simple_animal/hostile/carp,
		/mob/living/simple_animal/hostile/carp/asteroid,
		/mob/living/simple_animal/hostile/gnat,
		/mob/living/simple_animal/hostile/harron,
		/mob/living/simple_animal/hostile/hivebot,
		/mob/living/simple_animal/hostile/rogue_drone,
		/mob/living/simple_animal/hostile/viscerator,
		/mob/living/simple_animal/hostile/shrieker
	)
	if(wave_index >= 3)
		. += list(
			/mob/living/simple_animal/hostile/carp/shark,
			/mob/living/simple_animal/hostile/creature,
			/mob/living/simple_animal/hostile/giant_spider/hunter,
			/mob/living/simple_animal/hostile/giant_spider/bombardier,
			/mob/living/simple_animal/hostile/giant_spider/nurse,
			/mob/living/simple_animal/hostile/mimic/crate,
			/mob/living/simple_animal/hostile/psiren,
			/mob/living/simple_animal/hostile/wind_devil,
			/mob/living/simple_animal/hostile/wriggler
		)
	if(wave_index >= 6)
		. += list(
			/mob/living/simple_animal/hostile/bear,
			/mob/living/simple_animal/hostile/carp/shark/reaver,
			/mob/living/simple_animal/hostile/carp/shark/reaver/eel,
			/mob/living/simple_animal/hostile/giant_spider,
			/mob/living/simple_animal/hostile/giant_spider/emp,
			/mob/living/simple_animal/hostile/hivebot/guardian,
			/mob/living/simple_animal/hostile/hivebot/range/rapid,
			/mob/living/simple_animal/hostile/morph,
			/mob/living/simple_animal/hostile/phoron_worm/small,
			/mob/living/simple_animal/hostile/psiren/ranged
		)

/datum/game_mode/mob_onslaught/proc/get_boss_mob_pool(wave_index)
	. = list(
		/mob/living/simple_animal/hostile/bear,
		/mob/living/simple_animal/hostile/bear/spatial,
		/mob/living/simple_animal/hostile/carp/shark/reaver/eel,
		/mob/living/simple_animal/hostile/giant_spider,
		/mob/living/simple_animal/hostile/giant_spider/nurse/spider_queen,
		/mob/living/simple_animal/hostile/phoron_worm
	)
	if(wave_index >= 10)
		. += list(
			/mob/living/simple_animal/hostile/vannatusk,
			/mob/living/simple_animal/hostile/biglizard,
			/mob/living/simple_animal/hostile/psiren/matriarch
		)

/datum/game_mode/mob_onslaught/proc/prune_active_mobs()
	for(var/mob/living/simple_animal/hostile/spawned_mob as anything in active_wave_mobs)
		if(QDELETED(spawned_mob))
			active_wave_mobs -= spawned_mob
		else if(spawned_mob.stat == DEAD)
			mobs_defeated++
			active_wave_mobs -= spawned_mob
	for(var/mob/living/simple_animal/hostile/spawned_mob as anything in uncapped_ship_mobs)
		if(QDELETED(spawned_mob))
			uncapped_ship_mobs -= spawned_mob
		else if(spawned_mob.stat == DEAD)
			mobs_defeated++
			uncapped_ship_mobs -= spawned_mob

/datum/game_mode/mob_onslaught/declare_completion()
	. = ..()
	to_world(SPAN_NOTICE("The crew endured [wave_number] waves of the Mob Onslaught, defeating [mobs_defeated] of [total_spawned] spawned hostiles."))

/datum/game_mode/mob_onslaught/cleanup()
	QDEL_LIST(spawn_protections)
	for(var/mob/living/simple_animal/hostile/spawned_mob as anything in active_wave_mobs)
		if(!QDELETED(spawned_mob))
			qdel(spawned_mob)
	active_wave_mobs.Cut()
	for(var/mob/living/simple_animal/hostile/spawned_mob as anything in uncapped_ship_mobs)
		if(!QDELETED(spawned_mob))
			qdel(spawned_mob)
	uncapped_ship_mobs.Cut()
	return ..()
