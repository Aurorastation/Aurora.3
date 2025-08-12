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
	faction = "abominations"

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
	var/mob_soundblock_yell
	/// Changes the mobs description after death if set.
	var/desc_after_death = "One might wonder if the evolution ever had a hand in its creation. Whatever it was, it's now dead, hopefully..."
	/// Where the mob stores its original desc. Leave this null.
	var/original_desc

/mob/living/simple_animal/hostile/revivable/death()
	. = ..()
	if(desc_after_death)
		if(!original_desc)
			original_desc = desc
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
	desc = original_desc
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

// Abomination
/mob/living/simple_animal/hostile/revivable/abomination
	name = "abomination"
	desc = "Its ominous presence is enough to make even the calmest soul shudder. It seems agitated and you probably shouldn't get close to it."
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "abomination"
	icon_living = "abomination"
	icon_dead = "abomination_dead"

	mob_soundblock_yell = "/singleton/sound_category/bear_loud"
	desc_after_death = "One might wonder if the evolution ever had a hand in its creation. Whatever it was, it's now dead, hopefully..."

	/// If set True, will split into lesser creatures if someone approaches the corpse. Has a chance to be set to True in Init.
	var/trap_split = FALSE
	/// Has a chance to be set to True in Init, makes the mob appear in disguise. If the mob attacks to someone or gets attacked, the disguise is blown.
	var/mob_in_disguise = FALSE
	/// Used to store `talk_to_prey()` cooldown.
	var/last_time_spoken
	bypass_blood_overlay = TRUE

/mob/living/simple_animal/hostile/revivable/abomination/Initialize()
	. = ..()
	if(prob(100))
		trap_split = TRUE
	//if(prob(30))
	mob_in_disguise = TRUE

	maxHealth = 400 // the mob in disguise makes it easy target for a few bullets. This should even the odds.
	health = 400
	speed = 15
	melee_damage_upper = 60 // punishment for clueless preys.
		//icon_state = ""
	mob_soundblock_yell = null // letting us skip the check in `AttackTarget()`
	break_stuff_probability = 0 // we don't punch stufff around when we're in disguise!
	destroy_surroundings = 0
	new /obj/effect/landmark/corpse/quarantined_outpost(get_turf(src))
	addtimer(CALLBACK(src, PROC_REF(copy_appearance)), 1 SECONDS)

/mob/living/simple_animal/hostile/revivable/abomination/proc/copy_appearance()
	var/mob/living/carbon/human/H = locate() in range(2, src)
	if(H)
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
	break_stuff_probability = 10
	destroy_surroundings = 1
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

/obj/effect/landmark/corpse/quarantined_outpost
	outfit = list(
		/obj/outfit/admin/sol_private,
		/obj/outfit/admin/generic,
		/obj/outfit/admin/generic/engineer,
		/obj/outfit/admin/generic/security,
		/obj/outfit/admin/generic/medical
	)

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
