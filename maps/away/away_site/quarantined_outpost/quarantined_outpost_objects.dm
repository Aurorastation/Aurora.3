// Global lists used in this ruin
/// List of ruin creatures that exists.
GLOBAL_LIST_EMPTY(quarantined_outpost_creatures)

#define BREAK_WALL_COOLDOWN 5 SECONDS
#define BREAK_EXTRACTOR_COOLDOWN 10 SECONDS

/**
 * Storytelling Holograms
 * Compatible to use in any maps. Ported and adapted from Paradise Station.
 *
 * How does it work?
 * * Once a player crosses a '/obj/abstract/player_detector', it activates any holopads in perimeter of 7 tiles.
 * * Hologram repeats the things written in 'list/things_to_say' in a loop.
 * * Detector object deletes every detector of its kind in a 3 tiles radius to avoid signal spam.
 */
/obj/structure/environmental_storytelling_holopad
	name = "holopad"
	desc = "It's a floor-mounted device for projecting holographic images."
	icon = 'icons/obj/holopad.dmi'
	icon_state = "holopad0"
	anchored = TRUE
	layer = ABOVE_TILE_LAYER
	/// Have we been activated? If we have, we do not activate again.
	var/activated = FALSE
	/// Tied effect to kill when we die.
	var/obj/effect/overlay/our_holo
	/// Name of who we are speaking as.
	var/speaking_name = "placeholder"
	/// Appearance of the hologram.
	var/mob/holo_icon
	/// List of things to say.
	var/list/things_to_say = list("Hi future coders.", "Welcome to real lore hologram hours.", "People should have fun with these!")
	/// The sounds our hologram makes when it speaks. Use singleton sound categories. Null by default.
	var/list/soundblock = "/singleton/sound_category/hivebot_wail" //change this
	/// How long do we sleep between messages? 5 seconds by default.
	var/loop_sleep_time = 5 SECONDS
	/// Seconds integer. If set, the hologram will wait the set amount of seconds before making its speech. This applied only once and is null by default.
	var/sleep_before_speak = 5 SECONDS
	/// Should the hologram turn off once it's done its speech? True by default.
	var/turn_off_after_speech = TRUE

/obj/structure/environmental_storytelling_holopad/Destroy()
	QDEL_NULL(our_holo)
	return ..()

/obj/structure/environmental_storytelling_holopad/proc/start_message()
	if(activated)
		return

	activated = TRUE
	holo_icon = new /mob/abstract(src)
	holo_icon.set_invisibility(0)
	holo_icon.icon = icon('icons/mob/AI.dmi', "schlorrgo")
	icon_state = "holopad2"
	update_icon()
	var/obj/effect/overlay/hologram = new(get_turf(src))
	our_holo = hologram
	hologram.appearance = holo_icon.appearance
	hologram.alpha = 100
	hologram.color = rgb(214, 217, 221)
	hologram.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	hologram.layer = FLY_LAYER
	hologram.anchored = TRUE
	hologram.set_light(2, 1, rgb(214, 217, 221))
	hologram.pixel_y = 16
	hologram.name = speaking_name
	var/sound_to_play // apparently this is useless, remove after confirming it
	if(!sound_to_play && soundblock)
		sound_to_play = text2path(soundblock)
	var/datum/asset/spritesheet/S = get_asset_datum(/datum/asset/spritesheet/chat)
	var/datum/accent/a = SSrecords.accents[ACCENT_SOL]
	var/final_icon = "accent-[a.tag_icon]"
	for(var/I in things_to_say)
		if(sleep_before_speak)
			sleep(sleep_before_speak)
			sleep_before_speak = null
		hologram.langchat_speech("[I]", get_hearers_in_view(7, src), skip_language_check = TRUE)
		to_chat(get_hearers_in_view(7, src), "[{"<span onclick="window.location.href='byond://?src=[REF(src)];accent_tag=[url_encode(SSrecords.accents[ACCENT_SOL])]'">[S.icon_tag(final_icon)]</span>"} + " "]<span class='game say'><span class='name'>[speaking_name]</span> says, <span class='message'><span class='body'>\"[I]\"</span></span></span>")
		if(soundblock)
			playsound(loc, soundblock, 100, FALSE, 7)
		sleep(loop_sleep_time)
	if(turn_off_after_speech)
		QDEL_NULL(our_holo)
		icon_state = "holopad0"

/// Runs a proc when a player steps on it. Useful for mapping!
/obj/effect/player_detector
	name = "player detector"

/obj/effect/player_detector/Initialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)

	AddElement(/datum/element/connect_loc, loc_connections)
	RegisterSignal(src, COMSIG_ATOM_ENTERED, PROC_REF(on_entered))

/obj/effect/player_detector/proc/on_entered(datum/source, atom/movable/entered) // --------------- CHECK EFFECT/STEP_TRIGGER !!!!!! and replace it with it please
	SIGNAL_HANDLER

/*######################################
				RUIN STUFF
######################################*/

//---- Lights

/obj/machinery/light/small/decayed/quarantined_outpost

/obj/machinery/light/small/decayed/quarantined_outpost/Initialize()
	. = ..()
	stat |= POWEROFF

// Used in some rooms in the ruin, triggered to be turned on introductions
/obj/machinery/light/small/decayed/quarantined_outpost/group_1

/obj/machinery/light/small/decayed/quarantined_outpost/group_2

/obj/machinery/light/small/decayed/quarantined_outpost/group_3

//---- Main player detector

/obj/effect/player_detector/quarantined_outpost
	name = "main player detector"
	var/started = FALSE

/obj/effect/player_detector/quarantined_outpost/main
	name = "main player detector"

/obj/effect/player_detector/quarantined_outpost/main/on_entered(datum/source, atom/movable/entered)
	. = ..()
	if(ishuman(entered) || isrobot(entered))
		for(var/obj/structure/environmental_storytelling_holopad/H in range(3, src.loc))
			INVOKE_ASYNC(H, TYPE_PROC_REF(/obj/structure/environmental_storytelling_holopad, start_message))
		for(var/obj/effect/player_detector/quarantined_outpost/D in range(7, loc))
			//if(D.started)
				//continue
			qdel(D)
		qdel(src)
	return

//---- Reactor room stuff

/obj/effect/player_detector/quarantined_outpost/briefer
	name = "briefer player detector"

/obj/effect/player_detector/quarantined_outpost/briefer/on_entered(datum/source, atom/movable/entered)
	. = ..()
	if(ishuman(entered) || isrobot(entered))
		INVOKE_ASYNC(src, PROC_REF(dramatic_lights))
	return

/obj/effect/player_detector/quarantined_outpost/briefer/proc/dramatic_lights()
	if(started)
		return
	started = TRUE
	for(var/obj/effect/player_detector/quarantined_outpost/D in range(7, loc))
		if(D.started)
			continue
		qdel(D)
	var/target_list
	var/I = 1

	loop_again:
	sleep(2 SECONDS)
	// note for self, put your group lights here
	for(var/obj/machinery/light/small/decayed/quarantined_outpost/O in target_list)
		O.stat &= ~POWEROFF
		O.update()
	I++
	playsound(loc, 'sound/effects/light_heavy_on.ogg', 50)
	if(I <= 3)
		goto loop_again
	sleep(2 SECONDS)
	for(var/obj/structure/environmental_storytelling_holopad/reactor/H in range(3, src.loc))
		H.start_message()
	qdel(src)

/obj/structure/environmental_storytelling_holopad/reactor
	speaking_name = "Strom's #1 Fan"
	things_to_say = list("Hey gamers.", "Today we'll talk about why Sol is the best origin.", "Thank you for coming to my Ted Talk!")

//---- Bluespace portal

/obj/structure/bluespace_portal_device
	name = "\improper Unknown Machine"
	desc = "A contraption of dubious purpose. Its screens and indicators are blank, standing lifeless."
	icon = 'icons/obj/structure/bluespace_portal.dmi'
	icon_state = "bluespace_tap"
	pixel_x = -32
	pixel_y = -32

/obj/structure/filler
	name = "invisible wall"
	desc = "I cast barrier!"
	density = TRUE
	anchored = TRUE
	invisibility = 101

/obj/structure/filler/ex_act()
	return

/obj/structure/decor/ladder
	name = "ladder"
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder01"

/obj/structure/decor/ladder/up
	icon_state = "ladder10"

/*######################################
			RUIN CREATURES
######################################*/

/**
 * Revivable mobs
 *
 * * Unless their corpse is set on fire either by a flamethrower, a lit flare or any other means, the mob will reive after 5 minutes.
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
	/// The amount of time it takes for this mob to revive. 5 minutes by default.
	var/revival_countdown = 15 SECONDS
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

/mob/living/simple_animal/hostile/revivable/process() // we check every process cycle if our mob is burning, if not we revive it
	if(locate(/obj/item/device/flashlight/flare) in get_turf(src))
		for(var/obj/item/device/flashlight/flare/F in get_turf(src))
			if(F.on)
				src.IgniteMob(2)

	if(on_fire || QDELETED(src))
		if(revive_timer)
			deltimer(revive_timer)
			revive_timer = null
			playsound(loc, 'sound/effects/creatures/siro_shriek.ogg', 60, 1)
			src.visible_message((SPAN_DANGER("\improper [src] trembles and lets out a final, sharp shriek as its corpse is consumed by the flames!")))
		STOP_PROCESSING(SSprocessing, src)
		return

	if(!revive_timer) // if our timer is already running don't start new timers
		revive_timer = addtimer(CALLBACK(src, PROC_REF(revive)), revival_countdown, TIMER_STOPPABLE)
	return

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

// Husked creature
/mob/living/simple_animal/hostile/revivable/husked_creature
	name = "husked creature"
	desc = "This eerie figure is unusually pale, its body parts difficult to discern. The blade that the creature has as an arm looks sharp and menacing."
	icon = 'icons/mob/npc/human.dmi'
	icon_state = "the_thing_1"
	icon_living = "the_thing_1"
	icon_dead = ""
	faction = "abominations"
	maxHealth = 250
	health = 250
	speed = 6

/mob/living/simple_animal/hostile/revivable/husked_creature/Initialize()
	. = ..()
	if(prob(50))
		icon_state = "the_thing_2"
		icon_living = "the_thing_2"

		maxHealth = 350 // chitinous armor
		health = 350
		speed = 7 // armor heavy

// Abomination
/mob/living/simple_animal/hostile/revivable/abomination
	name = "abomination"
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "abomination"
	icon_living = "abomination"
	icon_dead = "abomination_dead"
	faction = "abominations"


	/// If true, will split into lesser creatures if someone approaches to the corpse. Has a chance to be set to true in Init.
	var/trap_split = FALSE
	/// Makes the mob appear in disguise. If the mob attacks to someone or gets attacked, the disguise is blown.
	/// If true, it will adjust mobs attack reactions and make them pacifist until it reaches someone. Has a chance to be set to True in Init.
	var/mob_in_disguise = FALSE
	/// Used to store `talk_to_prey()` cooldown.
	var/last_time_spoken
	/// Used for disabling some abilities for horde subtype.
	var/horde = FALSE
	bypass_blood_overlay = TRUE

/mob/living/simple_animal/hostile/revivable/abomination/Initialize()
	. = ..()
	if(horde)
		if(prob(7))
			trap_split = TRUE
		return
	if(prob(40))
		trap_split = TRUE
	if(prob(30))
		mob_in_disguise = TRUE
		maxHealth = 400 // the mob in disguise makes it easy target for a few bullets. This should even the odds.
		health = 400
		speed = 15
		melee_damage_upper = 60 // punishment for clueless preys.
		mob_soundblock_yell = null // letting us skip the check in `AttackTarget()`
		break_stuff_probability = 0 // we don't punch stufff around when we're in disguise!
		destroy_surroundings = FALSE
		new /obj/effect/landmark/corpse/quarantined_outpost(get_turf(src)) // janky way to steal identity, but it works...
		addtimer(CALLBACK(src, PROC_REF(copy_appearance)), 1 SECONDS)

/mob/living/simple_animal/hostile/revivable/abomination/proc/copy_appearance()
	for(var/mob/living/carbon/human/H in range(2, src))
		if(H && !H.client) // safety check, so we don't accidentally delete players if the mob happen to spawn near for some reason.
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
	src.visible_message((SPAN_DANGER("\improper [src]'s corpse begins to vibrate. Uh oh...")))
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
	if(mob_in_disguise && ismob(last_found_target) && prob(25) && world.time > last_time_spoken + 5 SECONDS)
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
	var/datum/asset/spritesheet/S = get_asset_datum(/datum/asset/spritesheet/chat)
	var/datum/accent/a = SSrecords.accents[ACCENT_SOL]
	var/final_icon = "accent-[a.tag_icon]"
	langchat_speech("[chosen_sentence]", get_hearers_in_view(7, src), skip_language_check = TRUE)
	to_chat(get_hearers_in_view(7, src), "[{"<span onclick="window.location.href='byond://?src=[REF(src)];accent_tag=[url_encode(SSrecords.accents[ACCENT_SOL])]'">[S.icon_tag(final_icon)]</span>"} + " "]<span class='game say'><span class='name'>[src.name]</span> says, <span class='message'><span class='body'>\"[chosen_sentence]\"</span></span></span>")

/mob/living/simple_animal/hostile/revivable/abomination/on_attack_mob(var/mob/hit_mob, var/obj/item/organ/external/limb)
	. = ..()
	if(mob_in_disguise && isliving(hit_mob))
		disregard_the_disguise()

/mob/living/simple_animal/hostile/revivable/abomination/apply_damage(damage = 0, damagetype = DAMAGE_BRUTE, def_zone, blocked, used_weapon, damage_flags = 0, armor_pen, silent = FALSE)
	. = ..()
	if(mob_in_disguise && damage)
		disregard_the_disguise()

/mob/living/simple_animal/hostile/revivable/abomination/proc/disregard_the_disguise()
	mob_in_disguise = FALSE
	speed = initial(speed)
	melee_damage_upper = initial(melee_damage_upper)
	break_stuff_probability = initial(break_stuff_probability)
	destroy_surroundings = TRUE
	speed = initial(speed)
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

// Lesser Abomination
/mob/living/simple_animal/hostile/giant_spider/lesser_abomination
	name = "lesser abomination"
	desc = "An agile, chitinous creature."
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "lesser_ling"
	tameable = FALSE

	maxHealth = 100
	health = 100

	speed = 2

	melee_damage_lower = 5
	melee_damage_upper = 10
	armor_penetration = 5
	poison_per_bite = 1
	poison_type = /singleton/reagent/soporific // sweet, horrible dreams for its undoubting victims

/mob/living/simple_animal/hostile/giant_spider/lesser_abomination/Initialize()
	. = ..()
	playsound(loc, 'sound/effects/creatures/siro_shriek.ogg', 40, 1)

/mob/living/simple_animal/hostile/giant_spider/lesser_abomination/death()
	. = ..()
	new /obj/effect/gibspawner/generic(get_turf(src))
	qdel()

// ---- Ruin specific mobs, don't spawn these outside of the ruin. Use the parent types instead!

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/Initialize()
	. = ..()
	GLOB.quarantined_outpost_creatures += src

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/Destroy()
	GLOB.quarantined_outpost_creatures -= src
	return ..()

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/Initialize()
	. = ..()
	GLOB.quarantined_outpost_creatures += src

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/Destroy()
	GLOB.quarantined_outpost_creatures -= src
	return ..()

// ---- special types used in horde spawner (shamelessly copied and adjusted from phoron_deposit_objects.dm)

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/horde
	var/tmp/breaking_wall = FALSE

/mob/living/simple_animal/hostile/revivable/husked_creature/quarantined_outpost/horde/Move(NewLoc)
	if(breaking_wall)
		return FALSE // we're breaking something and we need to stand still

	var/turf/target_turf = NewLoc
	var/obj/structure/quarantined_outpost_extractor/EX = locate(/obj/structure/quarantined_outpost_extractor) in target_turf
	if(istype(target_turf, /turf/simulated/wall) || EX)
		breaking_wall = TRUE
		spawn(0)

			if(EX && !QDELETED(EX)) // ---- is it an extractor
				visible_message(SPAN_DANGER("\the [src] is attempting to break down the [EX]!"))
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)
				sleep(BREAK_EXTRACTOR_COOLDOWN)
				if(!QDELETED(EX) && !QDELETED(src) && get_dist(src, target_turf) == 1) // check again if conditions are still valid after sleep
					qdel(EX)
					visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down \the [EX]!"))
					playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)

				breaking_wall = FALSE

			if(istype(target_turf, /turf/simulated/wall)) // ---- is it a wall
				visible_message(SPAN_DANGER("\the [src] is attempting to break down \the [target_turf]!"))
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)
				sleep(BREAK_WALL_COOLDOWN)
				if(istype(target_turf, /turf/simulated/wall) && !QDELETED(src) && get_dist(src, target_turf) == 1) // we check again
					visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down the [target_turf]!"))
					playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)
					target_turf.ChangeTurf(/turf/simulated/floor/exoplanet/asteroid/ash/rocky)
					new /obj/effect/decal/cleanable/floor_damage/broken6(target_turf)

				breaking_wall = FALSE
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/horde
	horde = TRUE
	var/tmp/breaking_wall = FALSE

/mob/living/simple_animal/hostile/revivable/abomination/quarantined_outpost/horde/Move(NewLoc)
	if(breaking_wall)
		return FALSE // we're breaking something and we need to stand still

	var/turf/target_turf = NewLoc
	var/obj/structure/quarantined_outpost_extractor/EX = locate(/obj/structure/quarantined_outpost_extractor) in target_turf
	if(istype(target_turf, /turf/simulated/wall) || EX)
		breaking_wall = TRUE
		spawn(0)

			if(EX && !QDELETED(EX)) // ---- is it an extractor
				visible_message(SPAN_DANGER("\the [src] is attempting to break down the [EX]!"))
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)
				sleep(BREAK_EXTRACTOR_COOLDOWN)
				if(!QDELETED(EX) && !QDELETED(src) && get_dist(src, target_turf) == 1) // check again if conditions are still valid after sleep
					qdel(EX)
					visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down \the [EX]!"))
					playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)

				breaking_wall = FALSE

			if(istype(target_turf, /turf/simulated/wall)) // ---- is it a wall
				visible_message(SPAN_DANGER("\the [src] is attempting to break down \the [target_turf]!"))
				playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)
				sleep(BREAK_WALL_COOLDOWN)
				if(istype(target_turf, /turf/simulated/wall) && !QDELETED(src) && get_dist(src, target_turf) == 1) // we check again
					visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down the [target_turf]!"))
					playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)
					target_turf.ChangeTurf(/turf/simulated/floor/exoplanet/asteroid/ash/rocky)
					new /obj/effect/decal/cleanable/floor_damage/broken6(target_turf)

				breaking_wall = FALSE
		return FALSE
	return ..()

/*######################################
		HORDE LOGIC (partially copied over from `phoron_deposit_objects.dm`)
######################################*/

/obj/structure/quarantined_outpost_extractor
	name = "HPMER Mk. I"
	desc = "A peculiar machine. Its alloy construction appears slightly less corroded than its surroundings."
	desc_extended = "\
	Also known as the 'High-Pressure Matter Extraction Rig', it's renowned as one of the loudest non-explosive contraptions ever created. Due to its \
	high operating pressure, this machine can generate vibrations at volumes far beyond what one would expect from a device of this size. This is practically \
	a relic. \
	"
	icon = 'icons/obj/kinetic_harvester.dmi'
	icon_state = "off"
	anchored = TRUE
	density = TRUE
	var/obj/effect/fauna_spawner/organized/quarantined_outpost/spawner
	var/obj/effect/map_effect/interval/screen_shaker/quarantined_outpost/shaker_effect

/obj/structure/quarantined_outpost_extractor/Initialize()
	. = ..()
	spawner = locate(/obj/effect/fauna_spawner/organized/quarantined_outpost) in get_turf(src)

/obj/structure/quarantined_outpost_extractor/Destroy() // game over man, it's game over...
	qdel(spawner)
	qdel(shaker_effect)
	return ..()

/obj/structure/quarantined_outpost_extractor/proc/begin_extraction()
	icon_state = "on"
	for(var/mob/M in range(50, src))
		if(M.client)
			to_chat(M, SPAN_DANGER("After a long mechanical hiss, the machine starts up with a jolt. Heavy thumps and the grind of hydraulics fill the air. \
			Through the noise, you catch something else: a faint sound outside the windows, echoing from deep within the abyss. The air grows tense as the screeches draw closer. \
			You have a <i>really bad</i> feeling about this..."))
			playsound(M, 'sound/mecha/powerup.ogg', 50, FALSE)
			sleep(4 SECONDS)
			playsound(M, 'sound/music/quarantined_outpost.ogg', 25, FALSE)
			sleep(38 SECONDS) // just before the beat begins, this HAS to be done with style
			shaker_effect = new /obj/effect/map_effect/interval/screen_shaker/quarantined_outpost(get_turf(src))
			activate_fauna_spawners(src.z)

/obj/machinery/atmospherics/portables_connector/quarantined_outpost
	name = "connector port"
	desc = "Doesn't seem to be designed for regular atmospheric components."
	icon_state = "map_connector-fuel"
	icon_connect_type = "-fuel"

/obj/machinery/atmospherics/portables_connector/quarantined_outpost/attackby(obj/item/attacking_item, mob/user) // no interacting with this subtype
	if(attacking_item.iswrench())
		to_chat(user, SPAN_WARNING("You struggle, but \the [src] is fastened too firmly to detach it."))
	return

/obj/machinery/portable_atmospherics/canister/quarantined_outpost
	name = "NEMORA labelled canister"
	desc = "A fuel canister with an unique connector port."
	icon_state = "brown"
	canister_color = "brown"
	density = TRUE

	var/percentage = 0

/obj/machinery/portable_atmospherics/canister/quarantined_outpost/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(distance <= 1)
		. += "[icon2html(src, user)] This canister is [percentage]% full!"

/obj/machinery/portable_atmospherics/canister/quarantined_outpost/check_change()
	var/old_flag = update_flag
	update_flag = 0
	if(holding)
		update_flag |= 1
	if(connected_port)
		update_flag |= 2

	if(percentage < 10)
		update_flag |= 4
	else if(percentage < 25)
		update_flag |= 8
	else if(percentage < 100)
		update_flag |= 16
	else
		update_flag |= 32

	if(update_flag == old_flag)
		return 1
	else
		return 0

/obj/machinery/portable_atmospherics/canister/quarantined_outpost/attackby(obj/item/attacking_item, mob/user) // this needs to be overriden to get rid of unwanted functions
	if(attacking_item.iswrench())
		if(connected_port)
			disconnect()
			to_chat(user, SPAN_NOTICE("You disconnect \the [src] from the port."))
			attacking_item.play_tool_sound(get_turf(src), 50)
			update_icon()
			SStgui.update_uis(src)
			return TRUE
		else
			var/obj/machinery/atmospherics/portables_connector/quarantined_outpost/possible_port = locate(/obj/machinery/atmospherics/portables_connector/quarantined_outpost/) in get_turf(src)
			if(possible_port)
				if(connect(possible_port))
					to_chat(user, SPAN_NOTICE("You connect \the [src] to the port."))
					attacking_item.play_tool_sound(get_turf(src), 50)
					update_icon()
					SStgui.update_uis(src)
					return TRUE
				else
					to_chat(user, SPAN_NOTICE("\The [src] failed to connect to the port."))
					return TRUE
			else
				to_chat(user, SPAN_NOTICE("Nothing happens."))
				return TRUE

/obj/machinery/portable_atmospherics/canister/quarantined_outpost/attack_hand() // we don't want the UI to appear in this frankenstein
	return

/obj/effect/map_effect/interval/screen_shaker/quarantined_outpost
	interval_lower_bound = 10 SECOND
	interval_upper_bound = 30 SECONDS

	shake_radius = 14
	shake_strength = 2
	play_rumble_sound = TRUE

/*######################################
				MISC
######################################*/

/obj/structure/fluff/

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
	<br><b>To:</b> Engineering Desk - Main Deck
	<br><b>Subject:</b> Immediate Action Required, Quarantine Protocols
	<br><br>Current security issues necessitate the quarantine measures, which are now to be enacted.
	<br><br>Ongoing situation intervenes the automated systems and it has to be enforced manually. Personnels who aren't occupied with highest priority tasks
	are required to perform EVA and toggle the locking systems in Auxiliary Power Compartment. Attending personnels will be let back inside once the situation
	settles down, estimatedly in two hours. Prepare in consideration of a long duration EVA duty.
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
	var/static/list/possible_techs = list(
		TECH_MATERIAL, TECH_ENGINEERING, TECH_POWER, TECH_BIO,
		TECH_COMBAT, TECH_MAGNET, TECH_DATA, TECH_ARCANE
	) // illegals, phoron and bluespace isn't included for this instance, given this ruin is a pre-war solarian ruin, two of these things weren't discovered at the time

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
