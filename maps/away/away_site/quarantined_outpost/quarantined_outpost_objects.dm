// Global lists used in this ruin

/// List of ruin creatures that exists.
GLOBAL_LIST_EMPTY(quarantined_outpost_creatures)

/// List of ruin canisters. (will be) Used in multiple systems.
GLOBAL_LIST_EMPTY(quarantined_outpost_canisters)

/// List of landmarkslocations for various things (randomly spawning creatures, canisters, etc...)

/// List of the things '/obj/machinery/computer/terminal/mob_tracker' required to track.
GLOBAL_LIST_EMPTY(trackables_pool)

#define BREAK_WALL_COOLDOWN 5 SECONDS
#define BREAK_EXTRACTOR_COOLDOWN 10 SECONDS

/*######################################
				RUIN STUFF
######################################*/

//---- Bluespace portal
// WIP, its functions will be completed at PART 2(tm)
/obj/structure/bluespace_portal_device
	name = "\improper Unknown Machine"
	desc = "A contraption of dubious purpose. Its screens and indicators are blank, standing lifeless."
	icon = 'icons/obj/structure/bluespace_portal.dmi'
	icon_state = "bluespace_tap"
	pixel_x = -32
	pixel_y = -32

/*######################################
			RUIN CREATURES
######################################*/

/**
 * Revivable mobs
 *
 * * Unless their corpse is set on fire by either a flamethrower, a lit flare or any other means, the mob will reive after 3 minutes.
 * * Additionally this mob yells at its target if soundblock is set.
 */
/mob/living/simple_animal/hostile/revivable
	name = "abomination"
	desc = "Its ominous presence is enough to make even the calmest soul shudder. It seems agitated and you probably shouldn't get close to it."
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "abomination"
	icon_living = "abomination"
	icon_dead = "abomination_dead"
	tameable = FALSE
	blood_type = "#490d0d"

	maxHealth = 300
	health = 300
	speed = 6

	melee_damage_lower = 30
	melee_damage_upper = 30
	armor_penetration = 15

	/// Used on deleting revive timer if the mob is burning while being dead.
	var/revive_timer
	/// The amount of time it takes for this mob to revive. 3 minutes by default.
	var/revival_countdown = 3 MINUTES
	/// Did we yell at our unfortunate victim the moment we spot them? This prevents yell spams.
	var/recently_yelled = FALSE
	/// The mob will yell at its targets with the sound path set here. Leave as null to disable.
	var/mob_soundblock_yell = "/singleton/sound_category/bear_loud"
	/// Changes the mobs description after death if set.
	var/desc_after_death = "One might wonder if the evolution ever had a hand in its creation. Whatever it was, it's now dead, hopefully..."

/mob/living/simple_animal/hostile/revivable/death()
	. = ..()
	if(desc_after_death)
		desc = desc_after_death
	playsound(loc, 'sound/effects/creatures/siro_shriek.ogg', 60, 1)
	START_PROCESSING(SSprocessing, src)

// Checks every process cycle if our mob is burning and adds a timer for 'revive()' proc.
// If the mob was burned before time ran out, we stop the timer and processing.
/mob/living/simple_animal/hostile/revivable/process()
	var/turf/T = get_turf(src)
	var/obj/item/device/flashlight/flare/F = locate(/obj/item/device/flashlight/flare) in T
	if(F?.on)
		src.IgniteMob(2)
		F.fuel = 0
		F.turn_off() // one flare per mob, otherwise this would make flamethrower mechanic obsolete
		playsound(loc, 'sound/items/flare.ogg', 60, 1)

	if(on_fire || QDELETED(src)) // mob is burning or ceased to exist, cancel the revive
		if(revive_timer)
			deltimer(revive_timer)
			revive_timer = null
			playsound(loc, 'sound/effects/creatures/siro_shriek.ogg', 60, 1)
			src.visible_message((SPAN_DANGER("\improper [src] trembles and lets out a final, sharp shriek as its corpse is consumed by the flames!")))
		STOP_PROCESSING(SSprocessing, src)
		return

	if(!revive_timer) // if our timer is already running don't start new timers
		revive_timer = addtimer(CALLBACK(src, PROC_REF(revive)), revival_countdown, TIMER_STOPPABLE)

/mob/living/simple_animal/hostile/revivable/revive()
	. = ..()
	update_icon()
	desc = initial(desc)
	src.visible_message((SPAN_DANGER("\improper [src] abruptly rises with a deafening shriek!")))
	playsound(loc, 'sound/effects/creatures/siro_shriek.ogg', 60, 1)
	revive_timer = null // timer served its purpose for one loop, getting it ready if our mob dies again
	STOP_PROCESSING(SSprocessing, src) // we are revived and no longer need to check if we were burning

/mob/living/simple_animal/hostile/revivable/update_fire()

	CutOverlays(image("icon" = 'icons/mob/burning/burning_generic.dmi', "icon_state" = "lower"))

	if(on_fire)
		AddOverlays(image("icon" = 'icons/mob/burning/burning_generic.dmi', "icon_state" = "lower"))

/mob/living/simple_animal/hostile/revivable/AttackTarget()
	. = ..()
	if(mob_soundblock_yell)
		if(last_found_target && !recently_yelled)
			playsound(loc, text2path(mob_soundblock_yell), 60)
			recently_yelled = TRUE

/mob/living/simple_animal/hostile/revivable/LoseTarget()
	. = ..()
	if(recently_yelled)
		recently_yelled = FALSE

// ---- Husked creature

/mob/living/simple_animal/hostile/revivable/husked_creature
	name = "husked creature"
	desc = "This eerie figure is unusually pale, its body parts are difficult to discern. The blade that the creature has as an arm looks sharp and menacing."
	icon = 'icons/mob/npc/human.dmi'
	icon_state = "the_thing"
	icon_living = "the_thing"
	icon_dead = "the_thing_dead"
	faction = "abominations"
	maxHealth = 250
	health = 250
	speed = 6

/mob/living/simple_animal/hostile/revivable/husked_creature/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "the_thing_chitin"
		icon_living = "the_thing_chitin"
		icon_dead = "the_thing_chitin_dead"

		maxHealth = 350 // chitinous armor
		health = 350
		speed = 7 // armor heavy

// ---- Abomination
/mob/living/simple_animal/hostile/revivable/abomination
	name = "abomination"
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "abomination"
	icon_living = "abomination"
	icon_dead = "abomination_dead"
	faction = "abominations"


	/// If true, will split into lesser creatures if someone approaches to the corpse. Has a chance to be set to true in Init.
	var/trap_split = FALSE
	/// Makes the mob appear in disguise. If the mob attacks someone or gets attacked, the disguise is blown.
	/// If true, it will adjust mobs attack reactions and make them pacifist until it reaches someone. Has a chance to be set to True in Init.
	var/mob_in_disguise = FALSE
	/// Used to store `talk_to_prey()` cooldown.
	var/last_time_spoken
	/// Used in `talk_to_prey()`.
	var/language = LANGUAGE_TCB
	/// Used for disabling some abilities for horde and a few other subtypes.
	var/disguise_disabled = FALSE
	/// If true, the mob will start with disguise.
	var/starts_disguised = FALSE
	bypass_blood_overlay = TRUE

/mob/living/simple_animal/hostile/revivable/abomination/Initialize()
	. = ..()
	if(disguise_disabled)
		if(prob(7))
			trap_split = TRUE
		return
	if(prob(40))
		trap_split = TRUE
	if(prob(20) || starts_disguised)
		mob_in_disguise = TRUE
		maxHealth = 400 // the mob in disguise makes it easy target for a few bullets. This should even the odds.
		health = 400
		speed = 15
		melee_damage_upper = 60 // punishment for clueless preys.
		mob_soundblock_yell = null // letting us skip the yell check in parent `AttackTarget()` proc
		destroy_surroundings = FALSE // we don't punch stufff around when we're in disguise!
		new /obj/effect/landmark/corpse/quarantined_outpost(get_turf(src)) // janky way to steal identity, but it works...
		addtimer(CALLBACK(src, PROC_REF(copy_appearance)), 1 SECONDS)

/mob/living/simple_animal/hostile/revivable/abomination/proc/copy_appearance()
	for(var/mob/living/carbon/human/H in range(2, src))
		if(H && !H.client) // safety check, so we don't accidentally delete players if the mob happen to spawn near them for some reason.
			H.lying = FALSE
			H.update_icon()
			appearance = H.appearance
			name = "Unknown"
			desc = "The way they move is rather rigid and limping. Their blank eyes are locked on you, the monotonous expression is making your skin crawl. Who is this person?"
			qdel(H)

/mob/living/simple_animal/hostile/revivable/abomination/process()
	. = ..()
	if(trap_split && src.stat == DEAD && locate(/mob/living/carbon) in range(2, src))
		deltimer(revive_timer) // the mob shouldn't revive when the trap is engaged
		revive_timer = null
		trap_split_start()

/mob/living/simple_animal/hostile/revivable/abomination/proc/trap_split_start()
	STOP_PROCESSING(SSprocessing, src)
	src.visible_message((SPAN_DANGER("\improper [src]'s corpse begins to vibrate. Uh... Oh...")))
	animate(src, pixel_x = pixel_x + pick(-2, -1, 1, 2), pixel_y = pixel_y + pick(-3, -2, 2, 3), time = 1 DECISECONDS, loop = 50, easing = JUMP_EASING)
	animate(pixel_x = 0, pixel_y = 0, time = 1 DECISECONDS, easing = JUMP_EASING)
	sleep(2 SECONDS)
	playsound(get_turf(src), 'sound/effects/lingabsorbs.ogg', 50, 1) // takes 3 seconds
	sleep(3 SECONDS)
	var/lesser_creature_amount = rand(1, 3)
	for(var/i in 1 to lesser_creature_amount)
		new /mob/living/simple_animal/hostile/giant_spider/lesser_abomination/(get_turf(src))
	new /obj/effect/gibspawner/generic(get_turf(src))
	playsound(loc, 'sound/effects/splat.ogg', 50, 1)
	qdel(src)

/mob/living/simple_animal/hostile/revivable/abomination/AttackTarget()
	. = ..()
	if(mob_in_disguise && ismob(last_found_target) && prob(25) && world.time > last_time_spoken + 10 SECONDS)
		last_time_spoken = world.time
		talk_to_prey()

/mob/living/simple_animal/hostile/revivable/abomination/proc/talk_to_prey()
	var/list/mimic_sentences = list(
		"Who... are you...?",
		"It... hurts...",
		"Who... is there...?",
		"H-help... me...",
		"I... have been... l-looking for you...",
		"It's... grim...",
		"I can... show it to y-you...",
		"I know... a way... o-out...",
		"AAaargh!"
	)
	var/chosen_sentence = pick(mimic_sentences)
	langchat_speech("[chosen_sentence]", get_hearers_in_view(7, src), skip_language_check = TRUE)
	for(var/mob/living/L in get_hearers_in_view(7, src))
		L.hear_say("[chosen_sentence]", "says", GLOB.all_languages[language], speaker = src)

/mob/living/simple_animal/hostile/revivable/abomination/on_attack_mob(var/mob/hit_mob, var/obj/item/organ/external/limb)
	. = ..()
	if(mob_in_disguise && isliving(hit_mob)) // we hit a mob? Disguise is gone
		disregard_the_disguise()

/mob/living/simple_animal/hostile/revivable/abomination/apply_damage(damage = 0, damagetype = DAMAGE_BRUTE, def_zone, blocked, used_weapon, damage_flags = 0, armor_pen, silent = FALSE)
	. = ..()
	if(mob_in_disguise && damage) // we were hit? Disguise is gone
		disregard_the_disguise()

/mob/living/simple_animal/hostile/revivable/abomination/proc/disregard_the_disguise()
	mob_in_disguise = FALSE
	speed = initial(speed)
	melee_damage_upper = initial(melee_damage_upper)
	destroy_surroundings = TRUE
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "abomination"
	UpdateOverlays()
	CutOverlays()
	name = initial(name)
	desc = initial(desc)
	new /obj/effect/gibspawner/generic(get_turf(src))
	src.visible_message((SPAN_DANGER("Suddenly, [src] twists and reveals a monstrosity...")))
	playsound(loc, 'sound/effects/splat.ogg', 50, 1)
	playsound(loc, 'sound/effects/creatures/siro_shriek.ogg', 60, 1)

/mob/living/simple_animal/hostile/revivable/abomination/disguised
	starts_disguised = TRUE

// Lesser Abomination
/mob/living/simple_animal/hostile/giant_spider/lesser_abomination
	name = "lesser abomination"
	desc = "An agile, chitinous creature."
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "lesser_ling"
	icon_living = "lesser_ling"
	tameable = FALSE
	faction = "abominations"

	maxHealth = 50
	health = 50

	speed = 2

	melee_damage_lower = 5
	melee_damage_upper = 10
	armor_penetration = 5
	venom_per_bite = 1
	venom_type = /singleton/reagent/soporific // sweet, horrible dreams for its undoubting victims

/mob/living/simple_animal/hostile/giant_spider/lesser_abomination/Initialize()
	. = ..()
	playsound(loc, 'sound/effects/creatures/siro_shriek.ogg', 40, 1)

/mob/living/simple_animal/hostile/giant_spider/lesser_abomination/death()
	. = ..()
	new /obj/effect/gibspawner/generic(get_turf(src))
	qdel(src)

// ---- Ruin specific mobs, don't spawn these outside of the ruin. Use the parent types instead!

// Husked creature
/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost
	break_stuff_probability = 0 // to avoid the ruin looking like a road roller went over it. Mobs should still be able to destroy whatever is blocking their way to their target

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/Initialize()
	. = ..()
	GLOB.quarantined_outpost_creatures += src
	GLOB.trackables_pool += src

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/Destroy()
	GLOB.quarantined_outpost_creatures -= src
	GLOB.trackables_pool -= src
	return ..()

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/death()
	. = ..()
	GLOB.quarantined_outpost_creatures -= src
	GLOB.trackables_pool -= src

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/revive()
	. = ..()
	GLOB.quarantined_outpost_creatures += src
	GLOB.trackables_pool += src

// Abomination
/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost
	/// Used for 'talk_to_prey()' stuff.
	accent = ACCENT_SOL
	break_stuff_probability = 0

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/Initialize()
	. = ..()
	GLOB.quarantined_outpost_creatures += src
	GLOB.trackables_pool += src

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/Destroy()
	GLOB.quarantined_outpost_creatures -= src
	GLOB.trackables_pool -= src
	return ..()

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/death()
	. = ..()
	GLOB.quarantined_outpost_creatures -= src
	GLOB.trackables_pool -= src

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/revive()
	. = ..()
	GLOB.quarantined_outpost_creatures += src
	GLOB.trackables_pool += src

// Abomination, disguiseless
/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/disguiseless
	disguise_disabled = TRUE

// ---- special types used in horde spawner (shamelessly copied and adjusted from phoron_deposit_objects.dm)
// contains two mobs with same procs defined under them.

// Husked Creature - Horde edition

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/horde
	var/tmp/breaking_wall = FALSE
	break_stuff_probability = 100
	maxHealth = 200
	health = 200

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/horde/Move(NewLoc)
	if(breaking_wall)
		return FALSE // we're breaking something and we need to stand still

	var/turf/target_turf = NewLoc
	var/obj/machinery/door/firedoor/F = locate(/obj/machinery/door/firedoor) in target_turf
	var/obj/structure/quarantined_outpost_extractor/EX = locate(/obj/structure/quarantined_outpost_extractor) in target_turf

	if(istype(target_turf, /turf/simulated/wall) || EX || (F && F.density))
		breaking_wall = TRUE
		INVOKE_ASYNC(src, PROC_REF(destroy_obstacle), target_turf, F, EX)

		return FALSE
	return ..()

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/horde/proc/destroy_obstacle(turf/target_turf, obj/F, obj/EX)
	if(istype(target_turf, /turf/simulated/wall))
		visible_message(SPAN_DANGER("\the [src] is attempting to break down \the [target_turf]!"))
		playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
		sleep(BREAK_WALL_COOLDOWN)
		if(istype(target_turf, /turf/simulated/wall) && !QDELETED(src) && stat != DEAD && get_dist(src, target_turf) == 1) // we check again
			visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down the [target_turf]!"))
			playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
			target_turf.ex_act(2)
			new /obj/effect/decal/cleanable/floor_damage/broken6(target_turf)
		breaking_wall = FALSE
		return

	if(F) // ---- firedoor
		visible_message(SPAN_DANGER("\the [src] is attempting to break down the [F]!"))
		playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
		sleep(BREAK_WALL_COOLDOWN)
		if(!QDELETED(F) && !QDELETED(src) && stat != DEAD && get_dist(src, target_turf) == 1) // check again if conditions are still valid after sleep
			qdel(F)
			visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down \the [F]!"))
			playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
		breaking_wall = FALSE
		return

	if(EX)
		visible_message(SPAN_DANGER("\the [src] is attempting to break down the [EX]!"))
		playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
		sleep(BREAK_EXTRACTOR_COOLDOWN)
		if(!QDELETED(EX) && !QDELETED(src) && stat != DEAD && get_dist(src, target_turf) == 1)
			qdel(EX)
			visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down \the [EX]!"))
			playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
		breaking_wall = FALSE

// Abomination - Horde edition

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/horde
	var/tmp/breaking_wall = FALSE
	break_stuff_probability = 100
	disguise_disabled = TRUE
	maxHealth = 250
	health = 250

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/horde/Move(NewLoc)
	if(breaking_wall)
		return FALSE // we're breaking something and we need to stand still

	var/turf/target_turf = NewLoc
	var/obj/machinery/door/firedoor/F = locate(/obj/machinery/door/firedoor) in target_turf
	var/obj/structure/quarantined_outpost_extractor/EX = locate(/obj/structure/quarantined_outpost_extractor) in target_turf

	if(istype(target_turf, /turf/simulated/wall) || EX || (F && F.density))
		breaking_wall = TRUE
		INVOKE_ASYNC(src, PROC_REF(destroy_obstacle), target_turf, F, EX)

		return FALSE
	return ..()

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/horde/proc/destroy_obstacle(turf/target_turf, obj/F, obj/EX)
	if(istype(target_turf, /turf/simulated/wall))
		visible_message(SPAN_DANGER("\the [src] is attempting to break down \the [target_turf]!"))
		playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
		sleep(BREAK_WALL_COOLDOWN)
		if(istype(target_turf, /turf/simulated/wall) && !QDELETED(src) && stat != DEAD && get_dist(src, target_turf) == 1) // we check again
			visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down the [target_turf]!"))
			playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
			target_turf.ex_act(2)
			new /obj/effect/decal/cleanable/floor_damage/broken6(target_turf)
		breaking_wall = FALSE
		return

	if(F) // ---- firedoor
		visible_message(SPAN_DANGER("\the [src] is attempting to break down the [F]!"))
		playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
		sleep(BREAK_WALL_COOLDOWN)
		if(!QDELETED(F) && !QDELETED(src) && stat != DEAD && get_dist(src, target_turf) == 1) // check again if conditions are still valid after sleep
			qdel(F)
			visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down \the [F]!"))
			playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
		breaking_wall = FALSE
		return

	if(EX)
		visible_message(SPAN_DANGER("\the [src] is attempting to break down the [EX]!"))
		playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
		sleep(BREAK_EXTRACTOR_COOLDOWN)
		if(!QDELETED(EX) && !QDELETED(src) && stat != DEAD && get_dist(src, target_turf) == 1)
			qdel(EX)
			visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down \the [EX]!"))
			playsound(target_turf, 'sound/effects/meteorimpact.ogg', 50, 1)
		breaking_wall = FALSE

/*######################################
		HORDE LOGIC (partially copied over from `phoron_deposit_objects.dm`)
######################################*/

/obj/structure/quarantined_outpost_extractor
	name = "HPMER Mk. I"
	desc = "A peculiar machine. Its alloy construction appears slightly less corroded than its surroundings."
	desc_extended = "\
	Also known as the 'High-Pressure Matter Extraction Rig', it's renowned as one of the loudest non-explosive contraptions ever created. Due to its \
	high operating pressure, this machine can generate vibrations at volumes far beyond what one would expect from a device of this size. This one is particularly \
	a relic. \
	"
	icon = 'icons/obj/kinetic_harvester.dmi'
	icon_state = "off"
	anchored = TRUE
	density = TRUE

	var/obj/effect/fauna_spawner/organized/quarantined_outpost/spawner
	var/obj/effect/map_effect/interval/screen_shaker/quarantined_outpost/shaker_effect

	var/list/connector_locations_list = list()
	var/working = FALSE

	/// Amount of canisters filled by the machine. Once it reaches 5 the operation stops.
	var/canisters_filled = 0

/obj/structure/quarantined_outpost_extractor/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/quarantined_outpost_extractor/LateInitialize()
	spawner = locate(/obj/effect/fauna_spawner/organized/quarantined_outpost) in get_turf(src)
	var/obj/effect/landmark/quarantined_outpost/canister_spawn/CS
	var/obj/structure/quarantined_outpost/fluff_connector/connector
	var/obj/effect/landmark/quarantined_outpost/creature/creature_spawn
	var/list/ruin_creatures = list(
		/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost,
		/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost
	)
	var/chosen_ruin_creature
	var/list/possible_locations = list()
	var/turf/T = get_turf(src)

	for(CS in GLOB.landmarks_list) // canister locations
		if(CS.z == T.z)
			possible_locations += get_turf(CS)
	for(var/i in 1 to 5) // only 5 canisters needed for this map
		new /obj/structure/quarantined_outpost/fluff_canister(pick_n_take(possible_locations))
	possible_locations.Cut()

	for(connector in world) // getting connector locations
		if(connector.z == T.z)
			connector_locations_list += get_turf(connector)

	for(creature_spawn in GLOB.landmarks_list) // non-horde ruin creatures
		if(creature_spawn.z == T.z)
			possible_locations += get_turf(creature_spawn)
	for(var/i in 1 to rand(20, 25)) // 20-25 creatures
		chosen_ruin_creature = pick(ruin_creatures)
		new chosen_ruin_creature(pick_n_take(possible_locations))


/obj/structure/quarantined_outpost_extractor/Destroy() // game over man, it's game over...
	qdel(spawner)
	qdel(shaker_effect)
	return ..()

/obj/structure/quarantined_outpost_extractor/proc/start_extraction()
	icon_state = "on"
	for(var/mob/M in range(50, src))
		if(M.client)
			to_chat(M, SPAN_DANGER("After a long mechanical hiss, the machine starts up with a jolt. Heavy thumps and the grind of hydraulics fill the air. \
			Through the noise, you catch something else: a faint sound outside the windows, echoing from deep within the abyss. The air grows tense as the screeches draw closer. \
			You have a <i>really bad</i> feeling about this..."))
			playsound(M, 'sound/mecha/powerup.ogg', 50, FALSE)
			spawn(4 SECONDS) // I put my hopes that this thing captures the ref variable that started the process...
				playsound(M, 'sound/music/quarantined_outpost.ogg', 30, FALSE)

	sleep(40 SECONDS) // just before the beat begins, this HAS to be done with style
	shaker_effect = new /obj/effect/map_effect/interval/screen_shaker/quarantined_outpost(get_turf(src))
	activate_fauna_spawners(src.z)
	working = TRUE
	INVOKE_ASYNC(src, PROC_REF(process_mini_game))

	// ---- core function of the horde mini-game
/obj/structure/quarantined_outpost_extractor/proc/process_mini_game()
	var/obj/structure/quarantined_outpost/fluff_canister/canister
	while(working && src)
		for(var/turf/connector_turf in connector_locations_list)
			canister = locate(/obj/structure/quarantined_outpost/fluff_canister) in connector_turf
			if(canister && canister.connected)
				canister.percentage = min(canister.percentage + 10, 100) // make sure it doesn't exceed 100 while we add 10% each time
				canister.update_icon()
				if(canister.percentage == 100)
					canister.toggle_fastening()
					canisters_filled++

		if(canisters_filled == 5) // mission successful, shutting down the monster magnet
			working = FALSE
			spawner.stop_spawning()
			qdel(shaker_effect)
			icon_state = "off"
			for(var/mob/M in view(7, src))
				playsound(M, 'sound/mecha/mech-shutdown.ogg', 50, FALSE)
				to_chat(M, SPAN_DANGER("\The [src]'s hydraulics beginning to slow down, the machine releases a long hiss for one last time."))
			return

		// it takes 2 minutes to completely fill a canister. There is a total of 5 canister and 2 connector ports. Event takes 6 minutes at best.
		sleep(12 SECONDS)

// ---- Fluff objects used in extraction/horde mini-game

/obj/structure/quarantined_outpost/fluff_connector
	name = "connector port"
	desc = "Doesn't seem to be designed for regular atmospheric components."
	icon = 'icons/atmos/connector.dmi'
	icon_state = "connector-fuel"
	anchored = TRUE

/obj/structure/quarantined_outpost/fluff_canister
	name = "NEMORA labelled canister"
	desc = "A fuel canister with an unique connector port."
	icon = 'icons/obj/atmos.dmi'
	icon_state = "brown"
	density = TRUE
	anchored = FALSE

	var/connected = FALSE
	var/percentage = 0

/obj/structure/quarantined_outpost/fluff_canister/Initialize()
	. = ..()
	GLOB.quarantined_outpost_canisters += src
	GLOB.trackables_pool += src
	update_icon()

/obj/structure/quarantined_outpost/fluff_canister/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		. += "[icon2html(src, user)] The pressure indicator on \the [src] reads: [percentage]% full!"

/obj/structure/quarantined_outpost/fluff_canister/Destroy()
	GLOB.quarantined_outpost_canisters -= src
	GLOB.trackables_pool -= src
	return ..()

/obj/structure/quarantined_outpost/fluff_canister/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		if(!locate(/obj/structure/quarantined_outpost/fluff_connector) in get_turf(src))
			to_chat(user, SPAN_WARNING("There is no suitable port to secure \the [src]."))
			return TRUE
		if(percentage == 100)
			to_chat(user, SPAN_WARNING("\The [src] is already full! You can't connect this here."))
			return TRUE
		toggle_fastening(user)
		return TRUE

	if(istype(attacking_item, /obj/item/device/analyzer) && Adjacent(user))
		to_chat(user, "[icon2html(src, user)] The pressure indicator on \the [src] reads: [percentage]% full!")
		return TRUE
	return ..()

/obj/structure/quarantined_outpost/fluff_canister/proc/toggle_fastening(mob/user)
	connected = !connected
	anchored = !anchored
	if(user)
		to_chat(user, SPAN_NOTICE("You [connected ? "secure" : "unsecure"] \the [src]."))
	else
		visible_message(SPAN_NOTICE("\The [src] unfastens itself as the percentage indicator reached [percentage]%!"))
	playsound(get_turf(src), 'sound/items/wrench.ogg', 50)
	update_icon()

/obj/structure/quarantined_outpost/fluff_canister/update_icon()
	ClearOverlays()
	set_light(FALSE)

	if(connected)
		AddOverlays("can-connector")
	switch(percentage)
		if(0 to 10)
			var/mutable_appearance/indicator_overlay = mutable_appearance(icon, "can-o0", plane = ABOVE_LIGHTING_PLANE)
			AddOverlays(indicator_overlay)
			set_light(1.4, 1, COLOR_RED_LIGHT)
		if(11 to 30)
			var/mutable_appearance/indicator_overlay = mutable_appearance(icon, "can-o1", plane = ABOVE_LIGHTING_PLANE)
			AddOverlays(indicator_overlay)
			set_light(1.4, 1, COLOR_RED_LIGHT)
		if(31 to 99)
			var/mutable_appearance/indicator_overlay = mutable_appearance(icon, "can-o2", plane = ABOVE_LIGHTING_PLANE)
			AddOverlays(indicator_overlay)
			set_light(1.4, 1, COLOR_YELLOW)
		if(100)
			var/mutable_appearance/indicator_overlay = mutable_appearance(icon, "can-o3", plane = ABOVE_LIGHTING_PLANE)
			AddOverlays(indicator_overlay)
			set_light(1.4, 1, COLOR_BRIGHT_GREEN)

/obj/effect/map_effect/interval/screen_shaker/quarantined_outpost
	interval_lower_bound = 10 SECOND
	interval_upper_bound = 30 SECONDS

	shake_radius = 14
	shake_strength = 2
	play_rumble_sound = TRUE

/// Used for location information, some are randomly choosen throughout the map to spawn certain things.
/obj/effect/landmark/quarantined_outpost
	name = "base type"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "mob_spawn"

/obj/effect/landmark/quarantined_outpost/canister_spawn
	name = "possible canister location"
	icon_state = "object_spawn"

/obj/effect/landmark/quarantined_outpost/creature
	name = "possible creature location"

/*######################################
				CONSOLES
######################################*/

/**
 * Tracker Consoles
 * Used for tracking mobs and objects that exists in the same Z level as the console is.
 * How to use it?
 * * Define a subtype of this and put the types you need to have tracked in `types_to_track` list.
 * * Add your mobs/objects to `GLOB.trackables_pool`. For example, see: `/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost`
 */
/obj/machinery/computer/terminal/mob_tracker
	name = "tracking terminal"
	icon_screen = "command"
	icon_keyboard = "atmos_key"
	icon_keyboard_emis = "atmos_key_mask"

	/// Lists of type paths used to check tagging mobs to track. Put your types here.
	var/list/types_to_track

	/// Leave as null if you wish to use default theme.
	var/tgui_theme

	/// Last time we have used the console's refresh function.
	var/cooldown_until
	var/cooldown = 3 MINUTE

	/// If true, the console won't display the scan readings. Useful for cases if this object needs a conditional use.
	var/disabled = FALSE
	/// The text that'll be displayed in disabled console screen.
	var/no_data_description

	/// Local assoc list of area names, each key assigned a number, the amount of mobs present in the associated area.
	var/list/areas_with_mobs
	var/list/areas_with_objects

/obj/machinery/computer/terminal/mob_tracker/proc/categorize_trackables(mob/user)
	playsound(get_turf(src), /singleton/sound_category/keyboard_sound, 30, TRUE)
	if(cooldown_until > world.time)
		to_chat(user, SPAN_WARNING("Terminal declines your input. Scanners are still preparing for the queries, you may try again in [time2text(cooldown_until - world.time, "mm:ss")] seconds."))
		return

	// this cleans the lists for every requested refresh
	LAZYNULL(areas_with_mobs)
	LAZYNULL(areas_with_objects)

	for(var/I in GLOB.trackables_pool) // actual categorizing starts here
		var/turf/T = get_turf(I)
		if(!T || T.z != src.z || !is_type_in_list(I, types_to_track)) // validity check
			continue

		var/area_name = get_area(T)
		if(ismob(I)) // ---- mobs are categorized here
			LAZYOR(areas_with_mobs, area_name) // if we don't have the area name present in the list, we create a new one
			areas_with_mobs[area_name]++
		else // ---- anything else categorized here
			LAZYOR(areas_with_objects, area_name)
			areas_with_objects[area_name]++
	cooldown_until = world.time + cooldown

/obj/machinery/computer/terminal/mob_tracker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MobTracker", capitalize_first_letters(name))
		ui.open()

/obj/machinery/computer/terminal/mob_tracker/ui_data(mob/user)
	var/list/data = list()

	data["areas_containing_mobs"] = areas_with_mobs
	data["areas_containing_objects"] = areas_with_objects
	data["tgui_theme"] = tgui_theme
	data["disabled"] = disabled
	data["no_data_description"] = no_data_description

	return data

/obj/machinery/computer/terminal/mob_tracker/ui_act(action, params)
	. = ..()
	if(.)
		return
	if(action)
		categorize_trackables(usr)

/obj/machinery/computer/terminal/mob_tracker/attack_hand(mob/user)
	if(..())
		return
	ui_interact(user)

/// If this object is present in the same Z level as `/obj/machinery/computer/terminal/mob_tracker`, trackers will be dependant on this machine to stay active in order to work.
/obj/machinery/mob_tracker/server_relay
	name = "server relay"
	desc = "An enclosed server machinery."
	icon = 'icons/obj/machinery/research.dmi'
	icon_state = "server-off"
	density = TRUE
	anchored = TRUE
	idle_power_usage = 300
	active_power_usage = 300

	var/active = FALSE
	var/busy = FALSE

/obj/machinery/mob_tracker/server_relay/mechanics_hints()
	. += ..()
	. += "You may use a <b>multitool</b> on this [src] to attempt activating it. It must be powered first."

/obj/machinery/mob_tracker/server_relay/Initialize()
	. = ..()
	power_change()
	update_icon()

/obj/machinery/mob_tracker/server_relay/power_change()
	..()
	update_icon()
	if(stat & NOPOWER)
		set_light(0)
		active = FALSE
		post_activation()

/obj/machinery/mob_tracker/server_relay/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/device/multitool))
		if(stat & NOPOWER)
			to_chat(user, SPAN_NOTICE("\The [src] is not powered, completely unresponsive to your inputs."))
			return

		if(busy || active)
			to_chat(user, SPAN_WARNING("\The [src] is already receiving inputs!"))
			return
		busy = TRUE

		visible_message(SPAN_NOTICE("\The [user] starts tinkering with \the [src]..."))
		to_chat(user, SPAN_NOTICE("You start pulsing \the [src] with \the [attacking_item], this should take a while..."))
		playsound(get_turf(src), /singleton/sound_category/electrical_hum, 30, TRUE)
		if(do_after(user, 15 SECONDS))
			to_chat(user, SPAN_NOTICE("With the last impulse, \the [src] comes to life!"))
			playsound(get_turf(src), /singleton/sound_category/electrical_spark, 30, TRUE)
			active = TRUE
			update_icon()
			post_activation()
		busy = FALSE
		return

	return ..()

/obj/machinery/mob_tracker/server_relay/proc/post_activation()
	for(var/obj/machinery/computer/terminal/mob_tracker/MT in world)
		if(MT.z == src.z)
			MT.disabled = !active

/obj/machinery/mob_tracker/server_relay/update_icon()
	if(stat & NOPOWER)
		icon_state = "server-nopower"
	else if(active)
		icon_state = "server-on"
		set_light(2, 1.3, COLOR_GREEN)
	else
		icon_state = initial(icon_state)
		set_light(2, 1.3, COLOR_MAROON)

// ---- Ruin specific consoles

/obj/machinery/computer/terminal/mob_tracker/quarantined_outpost
	name = "obsolete terminal"
	types_to_track = list(
		/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost,
		/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost,
		/obj/structure/quarantined_outpost/fluff_canister
	)

	tgui_theme = "sol"
	disabled = TRUE
	no_data_description = "ERR:0xDEAD UNABLE TO LINK WITH SENSORS RELAY"

/obj/machinery/computer/terminal/quarantined_outpost/extraction
	name = "extraction terminal"
	icon_screen = "forensic"
	icon_keyboard = "atmos_key"
	icon_keyboard_emis = "atmos_key_mask"

	var/used = FALSE

/obj/machinery/computer/terminal/quarantined_outpost/extraction/attack_hand(mob/user)
	if(used)
		to_chat(user, SPAN_WARNING("You cannot interact with \the [src] right now."))
		return
	used = TRUE
	if(LAZYLEN(GLOB.quarantined_outpost_creatures)) // extraction isn't allowed without clearing the ruin
		to_chat(user, SPAN_WARNING("\The [src] doesn't notice your input. The notice on the screen informs you about a present lockdown and quarantine protocols."))
		playsound(get_turf(src), /singleton/sound_category/keyboard_sound, 30, TRUE)
		used = FALSE
		return
	if(tgui_alert(user, "As you stand before \the [src] a wave doubt washes over you. This machine hasn't been maintained for a long time. This may be the only chance you have got.", "Irreversible Action!", list("Confirm", "I changed my mind")) != "Confirm")
		used = FALSE
		return

	var/obj/structure/quarantined_outpost_extractor/EX = locate(/obj/structure/quarantined_outpost_extractor) in world
	EX.start_extraction()

/*######################################
				MISC
######################################*/

/// A mapping tool. Has a chance to cut a cable and pry the flooring of the tile this landmark is placed upon.
/obj/effect/landmark/maybe_cut_cable
	name = "cut cable helper"
	icon_state = "x"

/obj/effect/landmark/maybe_cut_cable/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/maybe_cut_cable/LateInitialize()
	if(prob(25))
		var/turf/simulated/floor/T = get_turf(src)
		var/obj/structure/cable/C = locate(/obj/structure/cable) in T
		if(C)
			new/obj/item/stack/cable_coil(T, 1, C.color)
			qdel(C)
			if(T.flooring && T.flooring.flags & TURF_REMOVE_CROWBAR)
				T.make_plating(1)
	qdel(src)

/**
 * Trapped vents
 * A mapping tool. Acts as a mob spawner if placed on top of a vent. When a player crosses near them, they'll get ambushed.
 *
 * Following circuimstances affects the chance of this trap triggering:
 * * If someone ran past it, it's guaranteed to be triggered without delay.
 * * If they were wise and slowly walked closer to it, it has a chance that it won't be triggered. But even if it was triggered in this circuimstances, it'll happen with a delay.
 * * If an obj/item crosses it instead, it has a low chance to trigger the trap.
 * * If the vent is welded shut, trap is disabled until it is unwelded again.
 *
 * Once the trap is triggered, it won't trigger again.
 */
/obj/effect/landmark/trapped_vent
	name = "trapped vent"
	icon = 'icons/effects/map_effects.dmi'
	icon_state = "rigged_vent"
	invisibility = INVISIBILITY_MAXIMUM // not abstract level, because this landmark needs to be detected by a range location check

	/// List of mob type paths that will be spawned on trigger. Put your types here.
	var/list/mobs_to_spawn

	var/min_spawn_amount = 1
	var/max_spawn_amount = 2

	var/datum/weakref/my_vent
	var/list/step_trigger_group = list()
	var/activated = FALSE

	/// Probability of the vent chosen as trapped after initialize.
	var/spawn_chance = 100

/obj/effect/landmark/trapped_vent/Initialize(mapload)
	. = ..()
	my_vent = WEAKREF(locate(/obj/machinery/atmospherics/unary/vent_pump) in get_turf(src))
	if(!my_vent)
		return INITIALIZE_HINT_QDEL // Object wasn't placed on a vent, abort!

	if(prob(spawn_chance))
		if(mapload) // make sure everything is loaded before we set the `step_trigger` group, so we'll avoid random objects triggering this while main initialize process
			addtimer(CALLBACK(src, PROC_REF(set_the_trap)), 3 MINUTE)
		else
			set_the_trap()
	else
		return INITIALIZE_HINT_QDEL

/obj/effect/landmark/trapped_vent/proc/set_the_trap()
	for(var/turf/I in range(1, src))
		step_trigger_group +=  new /obj/effect/step_trigger/trapped_vent(I)

/obj/effect/landmark/trapped_vent/proc/activate_trap(chance, immediate_spawn = FALSE)
	if(activated)
		return
	activated = TRUE
	var/obj/machinery/atmospherics/unary/vent_pump/vent = my_vent.resolve() // temporarily referencing because we need the vent's variables
	var/turf/T = get_turf(src)
	if(!vent || vent.welded) // trap was made invalid, no need to check for bypassers
		QDEL_LAZYLIST(step_trigger_group)
		return
	if(prob(chance))
		if(!immediate_spawn)
			for(var/mob/M in get_hearers_in_range(7, src))
				to_chat(M, SPAN_DANGER("You hear a subtle thud echoing inside the [vent], it's getting closer..."))
			playsound(T, 'sound/effects/clang.ogg', 50, FALSE)
			sleep(2 SECONDS)
		var/loop_amount = rand(min_spawn_amount, max_spawn_amount)
		for(var/I in 1 to loop_amount)
			var/chosen_mob = pick(mobs_to_spawn)
			new chosen_mob(T)
		playsound(T, 'sound/effects/clang.ogg', 100, FALSE)
		for(var/mob/M in get_hearers_in_range(7, src))
			to_chat(M, SPAN_DANGER("Something emerges, crawling out of \the [vent]!"))
		QDEL_LAZYLIST(step_trigger_group) // step_triggers served its purpose
	else
		activated = FALSE

/// Has a 20% chance to make set a trap.
/obj/effect/landmark/trapped_vent/maybe
	spawn_chance = 20

/obj/effect/landmark/trapped_vent/maybe/quarantined_outpost
	mobs_to_spawn = list(
		/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/disguiseless,
		/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost
	)

/obj/effect/step_trigger/trapped_vent
	players_only = TRUE
	var/obj/effect/landmark/trapped_vent/spawner_trap

/obj/effect/step_trigger/trapped_vent/Initialize()
	. = ..()
	spawner_trap = locate(/obj/effect/landmark/trapped_vent) in range(1, src)

/obj/effect/step_trigger/trapped_vent/Trigger(atom/A)
	if(isobj(A))
		spawner_trap.activate_trap(10)
		return
	var/mob/crossing_mob = A
	if(crossing_mob.m_intent == "walk")
		spawner_trap.activate_trap(20)
		return
	spawner_trap.activate_trap(100, TRUE)

/// Mainly used by abominations to copy human appearance.
/obj/effect/landmark/corpse/quarantined_outpost
	outfit = list(
		/obj/outfit/admin/sol_private,
		/obj/outfit/admin/generic,
		/obj/outfit/admin/generic/engineer,
		/obj/outfit/admin/generic/security,
		/obj/outfit/admin/generic/medical
	)

/obj/effect/landmark/corpse/husk
	name = "Decayed Corpse"
	corpseid = FALSE
	species = SPECIES_HUMAN

/obj/effect/landmark/corpse/husk/do_extra_customization(mob/living/carbon/human/M)
	M.ChangeToSkeleton()
	M.dir = pick(GLOB.cardinals)

/obj/effect/landmark/corpse/husk/engineer
	name = "Decayed Engineer"
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/engineering
	corpsesuit = /obj/item/clothing/suit/space/void/engineering
	corpseuniform = /obj/item/clothing/under/color/brown
	corpsegloves = /obj/item/clothing/gloves/yellow
	corpsebelt = /obj/item/storage/belt/utility/full
	corpseshoes = /obj/item/clothing/shoes/magboots
	corpseid = TRUE
	corpseidjob = "Facility Engineer"
	corpseidaccess = ACCESS_QUARANTINED_OUTPOST_ENGINEER
	corpseidicon = "dark"

/obj/outfit/admin/sol_private
	name = "Solarian Army Personnel"

	uniform = list(
		/obj/item/clothing/under/rank/sol,
		/obj/item/clothing/under/rank/sol/army,
		/obj/item/clothing/under/rank/sol/army/grey

	)
	gloves = list(
		/obj/item/clothing/gloves/fingerless,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/gloves/black_leather
	)
	shoes = list(
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/workboots,
		/obj/item/clothing/shoes/workboots/dark,
		/obj/item/clothing/shoes/winter
	)
	accessory = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/clothing/accessory/storage/overalls,
		/obj/item/clothing/accessory/storage/pouches,
		/obj/item/clothing/accessory/storage/pouches/white,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/accessory/storage/webbingharness
	)
	belt = list(
		/obj/item/storage/belt/fannypack,
		/obj/item/storage/belt/utility,
		/obj/item/storage/belt/medical/paramedic,
		/obj/item/storage/belt/mining,
		/obj/item/storage/belt/security
	)
	back = list(
		/obj/item/storage/backpack/rucksack/tan,
		/obj/item/storage/backpack/rucksack/green,
		/obj/item/storage/backpack/rucksack/navy,
		/obj/item/storage/backpack/satchel,
		/obj/item/storage/backpack/satchel/leather,
		/obj/item/storage/backpack/messenger,
		/obj/item/storage/backpack/satchel/pocketbook
	)

/obj/structure/filler
	name = "invisible wall"
	desc = "I cast barrier!"
	density = TRUE
	anchored = TRUE
	invisibility = 101

/obj/structure/filler/ex_act()
	return

/obj/structure/decor/fluff_ladder
	name = "ladder"
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder01"

/obj/structure/decor/fluff_ladder/up
	icon_state = "ladder10"

/*######################################
				PAPERS
######################################*/

/obj/item/paper/fluff/quarantined_outpost/engineers_note
	name = "crumpled instructions"
	info = {"
	<center><img src = solflag.png><br>
	<h2>SSF Nemora</h2>
	<small><i>'Research Rooted in Discovery.'</i></small></center>
	<br><hr>
	<br><small><b>From:</b> Directorate Office - Facility Operations
	<br><b>To:</b> Engineering Desk - Main Floor
	<br><b>Subject:</b> Immediate Action Required, Quarantine Protocols
	<br><br>Current security issues necessitate the quarantine measures, which are now to be enacted.
	<br><br>Ongoing situation intervenes the automated systems and it has to be enforced manually. Personnels who aren't occupied with highest priority tasks
	are required to perform EVA and toggle the locking systems in Auxiliary Power Compartment. Attending personnels will be let back inside once the situation
	settles down, estimatedly in two hours. Prepare in consideration of a long duration EVA duty.
	"}

/obj/item/paper/fluff/quarantined_outpost/burnt_note
	name = "burnt note"
	info = {"
	\[whatever once was written here is now mostly unintelligible, claimed by a fire. Following is the only things you can discern.\]
	<br><br>
	...bring the equipment to... dispose of... if you see any, make sure they stay down... burn...
	"}

/obj/item/paper/fluff/quarantined_outpost/maintenance_log
	name = "maintenance log"
	info = {"
	...
	<br><br>
	- \[11 FEB 2274 - CYCLE 451 - ATKINSON\] Regular check-up, all green. Lately we allocate more and more processing space for the labs, even though these equipments
	weren't meant to pull off such an intense workload. We may be in the middle of damn nowhere, but hoping for miracles won't get you too far either. Put a ticket,
	get us some proper hardware and then maybe you will see less blinking red lights in the box that we have to pulse to reboot every now and then.
	"}

/obj/item/paper/fluff/quarantined_outpost/venusians_note
	name = "hastily written note"
	info = {"
	Babe, if you find this note pick whatever you can. Meet me at the hangar bay, we're leaving the first chance we get. Just today <i>two more</i> search and rescue teams
	went missing, and now medbay isn't accepting like, patients. More people are getting sick. Now we have a pilot too, that's the chance! I hope you change your mind, wholeheartedly.
	"}

/obj/item/paper/fluff/quarantined_outpost/cafeteria_note
	name = "crumpled notice"
	info = {"
	We have been holding the cafeteria for some time now. Keeping watch in turns, scare <i>them</i> away where we can. At first it seemed promising, we had plenty
	tables here to block the entry and enough food to feed an entire floor for months. It was a brief solace to know we won't starve while the sickness was getting inside our heads.
	<br><br>
	Comfort is a slow death, they say. We were ambushed. Most of us thought it was sickness bogging down our sanity, but those damnable things lurk in the ventilation.
	We lost three good men. If you be smart about it and move slowly around vents, the chances are they won't notice you. Welding them shut will keep you safe.
	You can also try thowing stuff near vents, might make <i>them</i> curious. Whatever you do, DON'T run pass them, unless you have a death wish...
	<br><br>
	We heard the rumours of a search-and-rescue team returned from the depths, claiming tunnels are connecting to some caverns in a junction, where <i>them</i> have no way
	of reaching for now. We are headed there.
	"}

/obj/item/folder/envelope/quarantined_outpost/research_note
	name = "Summarized Research Log - 'Experiment Site Nemora'"
	desc = "A small envelope with Solarian Alliance's emblem on the front. Right beneath it, 'CONFIDENTIAL' is written in bold text."

/obj/item/folder/envelope/quarantined_outpost/research_note/Initialize()
	. = ..()

	var/obj/item/paper/fluff/reward/research_note/R = new(src)
	R.update_icon()
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-sol"
	if(!R.stamped)
		R.stamped = new
	R.ico += "paper_stamp-sol"
	R.stamped += /obj/item/stamp
	R.AddOverlays(stampoverlay)
	R.stamps += "<hr><i>This paper has been stamped as \"TOP SECRET\".</i>"

/obj/item/paper/fluff/reward/research_note
	name = "research article"
	var/list/possible_techs = list(
		TECH_MATERIAL, TECH_ENGINEERING, TECH_POWER, TECH_BIO,
		TECH_COMBAT, TECH_MAGNET, TECH_DATA, TECH_ARCANE
	) // illegals, phoron and bluespace isn't included for this instance, given this ruin is a pre-war solarian relic, two of these things weren't discovered at the time!

/obj/item/paper/fluff/reward/research_note/Initialize()
	. = ..()

	origin_tech = list(pick(possible_techs) = 5)
	info = {"
	\[after briefly skimming its contents, this article presents [origin_tech[1]]-related findings. All sensitive sections are encrypted. Maybe a decrypting tool \
	could get you through it.\]"}

/obj/item/paper/fluff/reward/research_note/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can put this paper in a deconstructive analyzer to obtain research levels hidden in it!"

#undef BREAK_WALL_COOLDOWN
#undef BREAK_EXTRACTOR_COOLDOWN
