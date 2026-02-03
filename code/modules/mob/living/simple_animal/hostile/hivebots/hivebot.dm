/mob/living/simple_animal/hostile/hivebot
	name = "Hivebot"
	desc = "A primitive in design, hovering robot, with some menacing looking blades jutting out from it. It bears no manufacturer markings of any kind."
	icon = 'icons/mob/npc/hivebot.dmi'
	icon_state = "hivebot"
	blood_type = COLOR_OIL
	blood_overlay_icon = 'icons/mob/npc/blood_overlay_hivebot.dmi'
	health = 15
	maxHealth = 15
	melee_damage_lower = 10
	melee_damage_upper = 10
	armor_penetration = 40
	attack_flags = DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE
	break_stuff_probability = 25
	attacktext = "slashed"
	attack_sound = /singleton/sound_category/hivebot_melee
	projectilesound = 'sound/weapons/gunshot/gunshot_suppressed.ogg'
	projectiletype = /obj/projectile/bullet/pistol/hivebotspike
	organ_names = list("head", "core", "side thruster", "bottom thruster")
	faction = "hivebot"
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
	smart_melee = FALSE
	pass_flags = PASSTABLE|PASSRAILING
	emote_hear = list("emits a harsh noise")
	emote_sounds = list(
		'sound/effects/creatures/hivebot/hivebot-bark-001.ogg',
		'sound/effects/creatures/hivebot/hivebot-bark-003.ogg',
		'sound/effects/creatures/hivebot/hivebot-bark-005.ogg',
	)
	speak_chance = 5
	attack_emote = "focuses on"
	psi_pingable = FALSE
	sample_data = null

	/**
	 * The hivebot beacon that we are liked to (and likely generated us)
	 */
	var/mob/living/simple_animal/hostile/hivebotbeacon/linked_parent = null

/mob/living/simple_animal/hostile/hivebot/Initialize(mapload,mob/living/simple_animal/hostile/hivebot/hivebotbeacon)
	. = ..()

	if(hivebotbeacon)
		linked_parent = hivebotbeacon

	if(!mapload)
		spark(get_turf(src), 2, GLOB.alldirs)

/mob/living/simple_animal/hostile/hivebot/Destroy()
	if(linked_parent)
		linked_parent.linked_bots -= src
		linked_parent = null

	. = ..()

/mob/living/simple_animal/hostile/hivebot/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_METAL

/mob/living/simple_animal/hostile/hivebot/update_icon()
	..()
	if(resting || stat == DEAD)
		blood_overlay_icon = 'icons/mob/npc/blood_overlay.dmi'
	else
		blood_overlay_icon = initial(blood_overlay_icon)
	handle_blood(TRUE)

/mob/living/simple_animal/hostile/hivebot/get_blood_overlay_name()
	if(stance == HOSTILE_STANCE_IDLE)
		return "blood_overlay"
	else
		return "blood_overlay_armed"

/mob/living/simple_animal/hostile/hivebot/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	if(istype(hitting_projectile, /obj/projectile/bullet/pistol/hivebotspike) || istype(hitting_projectile, /obj/projectile/beam/hivebot))
		return BULLET_ACT_BLOCK
	else
		return ..()

/mob/living/simple_animal/hostile/hivebot/death()
	..(null,"blows apart!")

	var/turf/current_turf = get_turf(src)
	if(!current_turf)
		qdel(src)
		return

	var/robot_gib_type = /obj/effect/decal/cleanable/blood/gibs/robot
	var/atom/turf_gibs = locate(robot_gib_type) in current_turf
	if(turf_gibs) // we only want to spawn gibs here if there aren't any already
		return

	var/list/gib_types = typesof(robot_gib_type)
	var/selected_gib_type = pick(gib_types)
	new selected_gib_type(current_turf)

	spark(current_turf, 1, GLOB.alldirs)

	qdel(src)

/mob/living/simple_animal/hostile/hivebot/think()
	. =..()
	if(stance == HOSTILE_STANCE_IDLE)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]_armed"

/mob/living/simple_animal/hostile/hivebot/Allow_Spacemove(var/check_drift = 0)
	return TRUE

/mob/living/simple_animal/hostile/hivebot/AirflowCanMove(n)
	return FALSE

/mob/living/simple_animal/hostile/hivebot/emp_act(severity)
	. = ..()

	LoseTarget()
	change_stance(HOSTILE_STANCE_TIRED)
	addtimer(CALLBACK(src, PROC_REF(wakeup)), 50)
	visible_message(SPAN_DANGER("[src] suffers a teleportation malfunction!"))
	playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
	var/turf/random_turf = get_turf(pick(orange(src,7)))
	do_teleport(src, random_turf)

/mob/living/simple_animal/hostile/hivebot/proc/wakeup()
	change_stance(HOSTILE_STANCE_IDLE)


/*############
	SUBTYPES
############*/

/**
 * # Hivebot Guardian
 */
/mob/living/simple_animal/hostile/hivebot/guardian
	health = 80
	maxHealth = 45
	melee_damage_lower = 20
	melee_damage_upper = 20
	wander = 0
	icon_state = "hivebotguardian"
	desc = "A primitive in design, hovering robot, with some menacing looking blades jutting out from it. It bears no manufacturer markings of any kind. This one seems to be of a larger design."
	mob_bump_flag = HEAVY
	mob_swap_flags = ~HEAVY
	mob_push_flags = 0

/mob/living/simple_animal/hostile/hivebot/guardian/Initialize(mapload,mob/living/simple_animal/hostile/hivebot/hivebotbeacon)
	.=..()
	if(hivebotbeacon && linked_parent)
		linked_parent.guard_amt++

/mob/living/simple_animal/hostile/hivebot/guardian/Destroy()
	.=..()
	if(linked_parent)
		linked_parent.guard_amt--

/mob/living/simple_animal/hostile/hivebot/guardian/think()
	. =..()
	if(stance != HOSTILE_STANCE_IDLE)
		wander = 1

/**
 * # Hivebot Bomber
 */
/mob/living/simple_animal/hostile/hivebot/bomber
	desc = "A primitive in design, hovering robot, with some menacing looking blades jutting out from it. It bears no manufacturer markings of any kind. This one appears round in design and moves slower than its brethren."
	health = 100
	maxHealth = 100
	icon_state = "hivebotbomber"
	organ_names = list("head", "core", "bottom thruster")
	attacktext = "bumped"
	speed = 8
	var/has_exploded = FALSE

/mob/living/simple_animal/hostile/hivebot/bomber/AttackingTarget()
	..()
	LoseTarget()
	change_stance(HOSTILE_STANCE_TIRED)
	stop_automated_movement = 1
	wander = 0
	if(!has_exploded)
		playsound(src.loc, 'sound/items/countdown.ogg', 125, 1)
		has_exploded = TRUE
		addtimer(CALLBACK(src, PROC_REF(burst)), 20)

/mob/living/simple_animal/hostile/hivebot/bomber/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	if(istype(hitting_projectile, /obj/projectile/bullet/pistol/hivebotspike) || istype(hitting_projectile, /obj/projectile/beam/hivebot))
		return BULLET_ACT_BLOCK
	else if(!has_exploded)
		. = ..()
		if(. != BULLET_ACT_HIT)
			return .

		has_exploded = TRUE
		burst()

/mob/living/simple_animal/hostile/hivebot/bomber/proc/burst()
	fragem(src,10,30,2,3,5,1,FALSE)
	src.gib()

/**
 * # Hivebot Ranged
 */
/mob/living/simple_animal/hostile/hivebot/range
	name = "Hivebot"
	desc = "A primitive in design, hovering robot, with a simple looking launcher sticking out of it. It bears no manufacturer markings of any kind."
	icon_state = "hivebotranged"
	ranged = 1

/mob/living/simple_animal/hostile/hivebot/range/rapid
	projectiletype = /obj/projectile/bullet/pistol/hivebotspike/needle
	rapid = 1

/mob/living/simple_animal/hostile/hivebot/playable/
	name = "Hivebot destroyer"
	desc = "A primitive-yet-sturdy hovering robot, with some menacing looking blades jutting out from it. This one seems unusually aware of its surroundings."
	icon_state = "hivebotdestroyer"
	health = 350
	maxHealth = 350
	melee_damage_lower = 20
	melee_damage_upper = 30
	armor_penetration = 20
	attacktext = "eviscerated"
	projectiletype = null
	var/playable = TRUE
	speed = -2

/mob/living/simple_animal/hostile/hivebot/playable/Initialize(mapload)
	. = ..()
	add_language(LANGUAGE_HIVEBOT)
	var/number = rand(1000,9999)
	name = initial(name) + " ([number])"
	real_name = name
	if(playable && !ckey && !client)
		SSghostroles.add_spawn_atom("hivebotdestroyer", src)

/mob/living/simple_animal/hostile/hivebot/playable/Destroy()
	. = ..()
	SSghostroles.remove_spawn_atom("hivebotdestroyer", src)

/mob/living/simple_animal/hostile/hivebot/playable/ranged
	name = "Hivebot marksman"
	desc = "A primitive-yet-sturdy hovering robot, with some menacing looking blades jutting out from it. This one seems to be carefully surveying all activity."
	icon_state = "hivebotmarksman"
	health = 250
	maxHealth = 250
	melee_damage_lower = 10
	melee_damage_upper = 20
	armor_penetration = 20
	attacktext = "stabbed"
	ranged = 1
	projectiletype = /obj/projectile/bullet/pistol/medium
	speed = -3

/mob/living/simple_animal/hostile/hivebot/playable/ranged/Initialize(mapload)
	. = ..()
	add_language(LANGUAGE_HIVEBOT)
	var/number = rand(1000,9999)
	name = initial(name) + " ([number])"
	real_name = name
	if(playable && !ckey && !client)
		SSghostroles.add_spawn_atom("hivebotmarksman", src)

/mob/living/simple_animal/hostile/hivebot/playable/ranged/Destroy()
	. = ..()
	SSghostroles.remove_spawn_atom("hivebotmarksman", src)

/mob/living/simple_animal/hostile/hivebot/playable/overseer
	name = "Hivebot overseer"
	desc = "A primitive-yet-sturdy hovering robot, with some menacing looking blades jutting out from it. This one seems to be buzzing with unseen activity from within."
	icon_state = "hivebotoverseer"
	health = 300
	maxHealth = 300
	melee_damage_lower = 10
	melee_damage_upper = 10
	armor_penetration = 10
	attacktext = "slashed"
	ranged = -1
	projectiletype = /obj/projectile/bullet/pistol/

/mob/living/simple_animal/hostile/hivebot/playable/overseer/Initialize(mapload)
	. = ..()
	add_language(LANGUAGE_HIVEBOT)
	var/number = rand(1000,9999)
	name = initial(name) + " ([number])"
	real_name = name
	if(playable && !ckey && !client)
		SSghostroles.add_spawn_atom("hivebotoverseer", src)

/mob/living/simple_animal/hostile/hivebot/playable/overseer/Destroy()
	. = ..()
	SSghostroles.remove_spawn_atom("hivebotoverseer", src)

/mob/living/simple_animal/hostile/hivebot/playable/overseer/verb/build_bot()
	set name = "Assemble hivebot"
	set desc = "Assemble a hivebot."
	set category = "Hivebot"

	src.visible_message("\The [src] begins to construct a hivebot.", "You begin to construct a hivebot.", "You hear the sounds of fabrication...")
	if(!do_after(src, 12 SECONDS))
		return
	src.visible_message("\The [src] constructs a hivebot!", "You construct a hivebot!")
	new /mob/living/simple_animal/hostile/hivebot(get_turf(src))
