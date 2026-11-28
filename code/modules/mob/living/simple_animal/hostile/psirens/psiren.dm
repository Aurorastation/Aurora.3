/// Psiren "Lasher"
/mob/living/simple_animal/hostile/psiren
	name = "psiren lasher"
	desc = "A strange, squid-like xenofauna. Its eye is full of malevolence."
	icon = 'icons/mob/npc/psirens.dmi'
	icon_state = "psiren_lasher"
	icon_living = "psiren_lasher"
	icon_dead = "psiren_lasher_dead"
	blood_type = COLOR_AMBER
	blood_overlay_icon = 'icons/mob/npc/blood_overlay.dmi'
	health = 65
	maxhealth = 65
	melee_damage_lower = 8
	melee_damage_upper = 8
	armor_penetration = 40
	attack_flags = DAMAGE_FLAG_EDGE|DAMAGE_FLAG_PSIONIC
	destroy_surroundings = FALSE
	break_stuff_probability = 0
	attacktext = "lashes"
	attack_sound = 'sound/effects/creatures/vannatusk_attack.ogg'
	organ_names = list("head", "eye", "beak", "tentacles")
	faction = "psiren"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4
	tameable = FALSE
	flying = TRUE
	pass_flags = PASSTABLE|PASSRAILING
	emote_hear = list("emits a rhythmic ping")
	emote_sounds = list(
		'sound/effects/creatures/vannatusk_sound.ogg',
		'sound/effects/creatures/vannatusk_sound_2.ogg',
	)
	speak_chance = 5
	attack_emote = "menaces"
	psi_pingable = TRUE
	meat_amount = 1
	meat_type = /obj/item/reagent_containers/food/snacks/psiren_body_meat
	butchering_products = list(/obj/item/reagent_containers/food/snacks/psiren_tentacle_meat = 1)

	attack_vis_effect = ATTACK_EFFECT_DISARM
	smart_ranged = FALSE

	/// Messages used by the psiren for its psychic damage effects.
	var/list/cursed_messages = list("DRINK DEEPLY OF THE FINAL NIGHT.",
		"YOUR LOVED ONES WILL NEVER KNOW OF YOUR JOY AGAIN.",
		"LEAVE THIS PLACE THROUGH THE NEAREST AIRLOCK.",
		"DEATH IS BUT THE FIRST DANCE IN ETERNITY.",
		"YOU DESERVE ALL OF YOUR SUFFERING.",
		"THE STARS HAVE FORGOTTEN YOUR NAME.",
		"YOUR BONES REMEMBER CRIMES YOU NEVER COMMITTED.",
		"EVERY GOD YOU HAVE EVER PRAYED TO IS DEAD.",
		"THE UNIVERSE REGRETS YOUR CREATION.",
		"YOU HAVE ALREADY FAILED.",
		"YOU WILL NEVER WAKE UP FROM THIS.",
		"YOUR SCREAMS ARRIVE BEFORE YOU MAKE THEM.",
		"YOU WERE WARNED.",
		"THE RIVERS RUN COLD WITH MEMORY.",
		"THE LEMURIAN SEA HUNGERS.",
		"THE LEMURIAN SEA HAS BECOME YOUR TOMB.",
		"THERE IS A DRUMBEAT BELOW REALITY.",
		"THE SUNSET LASTS FOREVER HERE.",
		"YOU CANNOT HIDE INSIDE YOUR OWN HEAD.",
		"I KNOW WHAT YOU DREAM ABOUT.",
		"I AM WEARING YOUR VOICE.",
		"YOU INVITED ME IN",
		"THE SCC SENT YOU HERE AS A FEAST FOR GIBBERING MOUTHS. YOUR LEADERS SENT YOU HERE TO DIE.",
		"YOUR MEMORY FURNISHES A REPAST FOR THE MATRIARCH.",
		"THE NIGHT SHEDS A TEAR TO TELL YOU OF FEAR, OF SORROW, OF PAIN.",
		"THE SCC HAS ALREADY VOIDED YOUR CONTRACT, THEY KNEW YOU WOULD DIE HERE.",
		"I SAW YOU WHEN YOU THOUGHT YOU WERE ALONE.",
		"THE BLOOD WILL NEVER WASH FROM YOUR HANDS.",
		"YOU ARE GUILTY OF YOUR FOREFATHERS SINS.",
		"YOUR MISSION FAILED BEFORE IT BEGAN, THE PHORON YOU SEEK WAS NEVER REAL. YOUR NATION WILL DROWN FOR ITS WANT. IT'S ALL YOUR FAULT.")

	/// How much damage the psiren's attacks deal directly to the victim's morale on a successful hit.
	var/psi_damage = -0.1

	/// How much extra psychic damage is dealt per point of psi-sensitivity.
	var/psi_sensitivity_multiplier = -0.05

	/// The chance per successful hit of triggering an ADPI message on the target.
	var/adpi_chance = 5

	/// Whether this psiren actively seeks out psionically sensitive players and smashes obstacles to reach them.
	var/hunt_psionics = FALSE
	/// Whether this psiren can still perform its one-time psionic jump from space through an exterior window.
	var/can_window_jump = FALSE
	/// Minimum damage dealt when smashing ship obstacles while hunting psionics.
	var/smash_damage = 12
	/// Weakref to the current psionically sensitive player this psiren is pathing toward while idle.
	var/datum/weakref/psi_hunt_target
	/// Weakrefs of living mobs that have attacked any psiren, shared telepathically so all psirens retaliate even if the attacker is psi-deaf.
	var/static/list/provoked_by = list()
	/// Weakrefs of players who have already received the one-time psionic hunt warning.
	var/static/list/psi_hunt_warned = list()

/**
 * Psirens have a unique ability to telepathically retaliate against anyone who tries to examine them.
 * It only works if the psiren is alive, and the target isn't mindshielded.
 */
/mob/living/simple_animal/hostile/psiren/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	// If the victim has any psi-protection, we give them a completely normal examine proc.
	if (stat == DEAD || user.is_psi_blocked(src, FALSE))
		return ..()

	// Otherwise HIJACK IT.
	return list(FONT_HUGE(SPAN_CULT(pick(cursed_messages))))

/// Protection from the ranged attacks of other psirens.
/mob/living/simple_animal/hostile/psiren/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	var/mob/shooter = astype(hitting_projectile?.firer, /mob)
	if (!shooter || shooter.faction != "psiren")
		. = ..()
		if(. == BULLET_ACT_HIT)
			record_provocation(hitting_projectile?.firer)
		return .

	return BULLET_ACT_BLOCK

/mob/living/simple_animal/hostile/psiren/handle_attack_by(mob/user)
	record_provocation(user)
	return ..()

/mob/living/simple_animal/hostile/psiren/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(isobj(hitting_atom))
		record_provocation(throwingdatum?.thrower?.resolve())
	return ..()

/mob/living/simple_animal/hostile/psiren/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	record_provocation(user)
	return ..()

/mob/living/simple_animal/hostile/psiren/attack_hand(mob/living/carbon/human/M)
	record_provocation(M)
	return ..()

/mob/living/simple_animal/hostile/psiren/proc/record_provocation(atom/attacker)
	if(!isliving(attacker) || QDELETED(attacker))
		return
	provoked_by |= WEAKREF(attacker)
	if(islist(targets))
		targets |= attacker

/mob/living/simple_animal/hostile/psiren/proc/is_psi_deaf(mob/living/L)
	return L.is_psi_blocked(src, TRUE) || L.check_psi_sensitivity() <= -1

/mob/living/simple_animal/hostile/psiren/validator_living(mob/living/L, atom/current)
	if(is_psi_deaf(L) && !(WEAKREF(L) in provoked_by))
		return FALSE
	return ..()

/// Psiren melee attacks deal psychic damage, just like their ranged attacks.
/mob/living/simple_animal/hostile/psiren/on_attack_mob(mob/hit_mob, obj/item/organ/external/limb)
	. = ..()
	try_deal_psychic_damage(hit_mob, src, psi_damage, psi_sensitivity_multiplier, adpi_chance)

/mob/living/simple_animal/hostile/psiren/Destroy()
	psi_hunt_target = null
	return ..()

/mob/living/simple_animal/hostile/psiren/Allow_Spacemove(var/check_drift = 0)
	return TRUE

/// Enables active pursuit of psionically sensitive players and obstacle smashing (used by wandering psiren events).
/mob/living/simple_animal/hostile/psiren/proc/enable_psi_hunt()
	hunt_psionics = TRUE
	can_window_jump = TRUE
	destroy_surroundings = TRUE
	environment_smash = max(environment_smash, 1)

/// Checks whether a turf is a suitable interior destination for a psionic window jump.
/mob/living/simple_animal/hostile/psiren/proc/is_valid_jump_turf(turf/candidate)
	if(!candidate || candidate.density || istype(candidate, /turf/space) || istype(candidate.loc, /area/space))
		return FALSE
	for(var/obj/blocking in candidate)
		if(!blocking.density)
			continue
		if(istype(blocking, /obj/structure/table) || istype(blocking, /obj/structure/railing))
			continue
		return FALSE
	return TRUE

/// Finds a suitable interior turf on the far side of an exterior window turf.
/mob/living/simple_animal/hostile/psiren/proc/find_window_jump_turf(turf/window_turf, dir_from_self)
	var/turf/direct_dest = get_step(window_turf, dir_from_self)
	if(is_valid_jump_turf(direct_dest))
		return direct_dest
	var/turf/second_dest = get_step(direct_dest, dir_from_self)
	if(is_valid_jump_turf(second_dest))
		return second_dest
	for(var/turf/nearby in orange(1, window_turf))
		if(is_valid_jump_turf(nearby))
			return nearby
	return null

/// Attempts a one-time psionic jump from space through an exterior window into an interior room.
/mob/living/simple_animal/hostile/psiren/proc/try_window_jump(turf/window_turf, dir_from_self)
	if(!can_window_jump || !istype(get_turf(src), /turf/space))
		return FALSE
	var/obj/structure/window/window_obj = locate() in window_turf
	if(!window_obj)
		return FALSE
	var/turf/jump_dest = find_window_jump_turf(window_turf, dir_from_self)
	if(!jump_dest)
		return FALSE

	can_window_jump = FALSE
	playsound(loc, 'sound/effects/psi/power_evoke.ogg', 50, TRUE)
	visible_message(SPAN_DANGER("\The [src] phases out in a shimmer of violet light!"), visible_message_flags = LOCAL_MESSAGE)
	forceMove(jump_dest)
	GLOB.move_manager.stop_looping(src)
	playsound(jump_dest, 'sound/effects/phasein.ogg', 50, TRUE)
	visible_message(SPAN_DANGER("\The [src] phases through \the [window_obj] into \the [jump_dest.loc]!"), visible_message_flags = LOCAL_MESSAGE)
	return TRUE

/// Returns the closest living player on the same z-level with high psionic sensitivity.
/mob/living/simple_animal/hostile/psiren/proc/find_psi_hunt_target()
	var/mob/living/best_target
	var/best_dist = INFINITY
	for(var/mob/living/candidate in GLOB.living_mob_list)
		if(!candidate.client || candidate.stat == DEAD)
			continue
		var/turf/candidate_turf = get_turf(candidate)
		if(!candidate_turf || candidate_turf.z != z)
			continue
		if(candidate.check_psi_sensitivity() < PSI_RANK_SENSITIVE)
			continue
		var/dist = get_dist(src, candidate_turf)
		if(dist < best_dist)
			best_dist = dist
			best_target = candidate
	return best_target

/mob/living/simple_animal/hostile/psiren/think()
	. = ..()
	if(stop_thinking || stat || !hunt_psionics)
		return

	if(stance != HOSTILE_STANCE_IDLE || last_found_target)
		return

	var/mob/living/target = psi_hunt_target?.resolve()
	var/turf/target_turf = get_turf(target)
	if(QDELETED(target) || !target.client || target.stat == DEAD || !target_turf || target_turf.z != z || target.check_psi_sensitivity() < PSI_RANK_SENSITIVE)
		target = find_psi_hunt_target()
		psi_hunt_target = target ? WEAKREF(target) : null
		if(target && !(WEAKREF(target) in psi_hunt_warned))
			psi_hunt_warned |= WEAKREF(target)
			to_chat(target, SPAN_CULT("You feel a faint, otherworldly presence watching you from somewhere far beyond..."))

	if(!target)
		if(stop_automated_movement)
			stop_automated_movement = FALSE
			GLOB.move_manager.stop_looping(src)
		return

	stop_automated_movement = TRUE
	GLOB.move_manager.move_to(src, target, 1, speed)
	if(get_dist(src, target) > 1)
		DestroySurroundings(TRUE)

/mob/living/simple_animal/hostile/psiren/DestroySurroundings(bypass_prob = FALSE)
	if(!hunt_psionics)
		return ..()

	if(ON_ATTACK_COOLDOWN(src) || !isturf(loc))
		return FALSE

	if(!prob(break_stuff_probability) && !bypass_prob)
		return FALSE

	var/list/dirs_to_check = GLOB.cardinals.Copy()
	var/atom/priority_target = last_found_target || psi_hunt_target?.resolve()
	if(priority_target)
		var/target_dir = get_dir(src, priority_target)
		var/list/priority_dirs = list()
		for(var/card_dir in GLOB.cardinals)
			if(target_dir & card_dir)
				priority_dirs += card_dir
		dirs_to_check = priority_dirs + (dirs_to_check - priority_dirs)

	var/static/list/obstacle_types = list(
		/obj/structure/window,
		/obj/structure/window_frame,
		/obj/structure/grille,
		/obj/structure/machinery/door,
		/obj/structure/girder,
		/obj/structure/barricade,
		/obj/structure/closet,
		/obj/structure/table
	)

	var/damage_to_deal = max(rand(melee_damage_lower, melee_damage_upper), smash_damage)
	for(var/card_dir in dirs_to_check)
		var/turf/target_turf = get_step(src, card_dir)
		if(!target_turf)
			continue

		if(try_window_jump(target_turf, card_dir))
			return TRUE

		var/obj/effect/energy_field/energy_field = locate() in target_turf
		if(energy_field && !energy_field.invisibility && energy_field.density)
			energy_field.damage_field(rand(0.5, 1.5))
			visible_message(SPAN_DANGER("[capitalize_first_letters(src.name)] [attacktext] \the [energy_field]!"))
			do_attack_animation(energy_field)
			set_last_found_target(energy_field)
			change_stance(HOSTILE_STANCE_ATTACKING)
			hostile_last_attack = world.time
			return TRUE

		for(var/obstacle_type in obstacle_types)
			var/obj/found_obj = locate(obstacle_type) in target_turf
			if(!found_obj || !found_obj.density)
				continue
			if((found_obj.atom_flags & ATOM_FLAG_CHECKS_BORDER) && found_obj.dir != REVERSE_DIR(card_dir))
				continue
			if(istype(found_obj, /obj/structure/table))
				var/obj/structure/table/table = found_obj
				if(!table.maxhealth)
					continue
			found_obj.attack_generic(src, damage_to_deal, attacktext, environment_smash)
			hostile_last_attack = world.time
			return TRUE

	return FALSE

/// Psiren "Darter", a simple ranged attacker with weak damage, high penetration, and weak psychic damage.
/mob/living/simple_animal/hostile/psiren/ranged
	name = "psiren darter"
	icon_state = "psiren_darter"
	icon_living = "psiren_darter"
	icon_dead = "psiren_darter_dead"
	ranged = TRUE
	projectilesound = 'sound/weapons/wave.ogg'
	projectiletype = /obj/projectile/bullet/pistol/psiren

/// Smoke effect used for the Omen.
/datum/effect/effect/system/smoke_spread/psiren
	smoke_type = /obj/effect/smoke/psiren
	smoke_duration = 20 SECONDS

/// "Ink Cloud" colored smoke effect.
/obj/effect/smoke/psiren
	color = "#21093a"
	time_to_live = 20 SECONDS
