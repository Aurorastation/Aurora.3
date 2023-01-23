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
	attack_flags = DAM_SHARP|DAM_EDGE
	break_stuff_probability = 25
	attacktext = "slashed"
	projectilesound = 'sound/weapons/bladeslice.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol/hivebotspike
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
	see_in_dark = 8
	pass_flags = PASSTABLE|PASSRAILING
	attack_emote = "focuses on"
	var/mob/living/simple_animal/hostile/hivebotbeacon/linked_parent = null
	psi_pingable = FALSE

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

/mob/living/simple_animal/hostile/hivebot/guardian/think()
	. =..()
	if(stance != HOSTILE_STANCE_IDLE)
		wander = 1

/mob/living/simple_animal/hostile/hivebot/guardian/Destroy()
	.=..()
	if(linked_parent)
		linked_parent.guard_amt--

/mob/living/simple_animal/hostile/hivebot/bomber
	desc = "A primitive in design, hovering robot, with some menacing looking blades jutting out from it. It bears no manufacturer markings of any kind. This one appears round in design and moves slower than its brethren."
	health = 100
	maxHealth = 100
	icon_state = "hivebotbomber"
	organ_names = list("head", "core", "bottom thruster")
	attacktext = "bumped"
	move_to_delay = 8
	var/has_exploded = FALSE

/mob/living/simple_animal/hostile/hivebot/bomber/AttackingTarget()
	..()
	LoseTarget()
	stance = HOSTILE_STANCE_TIRED
	stop_automated_movement = 1
	wander = 0
	if(!has_exploded)
		playsound(src.loc, 'sound/items/countdown.ogg', 125, 1)
		has_exploded = TRUE
		addtimer(CALLBACK(src, PROC_REF(burst)), 20)

/mob/living/simple_animal/hostile/hivebot/bomber/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/bullet/pistol/hivebotspike) || istype(Proj, /obj/item/projectile/beam/hivebot))
		Proj.no_attack_log = 1
		return PROJECTILE_CONTINUE
	else if(!has_exploded)
		has_exploded = TRUE
		burst()

/mob/living/simple_animal/hostile/hivebot/bomber/proc/burst()
	fragem(src,10,30,2,3,5,1,FALSE)
	src.gib()

/mob/living/simple_animal/hostile/hivebot/range
	name = "Hivebot"
	desc = "A primitive in design, hovering robot, with a simple looking launcher sticking out of it. It bears no manufacturer markings of any kind."
	icon_state = "hivebotranged"
	ranged = 1

/mob/living/simple_animal/hostile/hivebot/range/rapid
	projectiletype = /obj/item/projectile/bullet/pistol/hivebotspike/needle
	rapid = 1

//Creates a reference to its parent beacon on init.
/mob/living/simple_animal/hostile/hivebot/Initialize(mapload,mob/living/simple_animal/hostile/hivebot/hivebotbeacon)
	if(hivebotbeacon)
		linked_parent = hivebotbeacon
	.=..()
	if(!mapload)
		new /obj/effect/effect/smoke(src.loc,30)
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)

/mob/living/simple_animal/hostile/hivebot/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj, /obj/item/projectile/bullet/pistol/hivebotspike) || istype(Proj, /obj/item/projectile/beam/hivebot))
		Proj.no_attack_log = 1
		return PROJECTILE_CONTINUE
	else
		return ..(Proj)

/mob/living/simple_animal/hostile/hivebot/death()
	..(null,"blows apart!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 1, alldirs)
	qdel(src)

/mob/living/simple_animal/hostile/hivebot/Destroy()
	. = ..()
	if(linked_parent)
		linked_parent.linked_bots -= src

/mob/living/simple_animal/hostile/hivebot/think()
	. =..()
	if(stance == HOSTILE_STANCE_IDLE)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]_armed"

/mob/living/simple_animal/hostile/hivebot/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/hivebot/AirflowCanMove(n)
	return 0

/mob/living/simple_animal/hostile/hivebot/emp_act(severity)
	LoseTarget()
	stance = HOSTILE_STANCE_TIRED
	addtimer(CALLBACK(src, PROC_REF(wakeup)), 50)
	visible_message(SPAN_DANGER("[src] suffers a teleportation malfunction!"))
	playsound(src.loc, 'sound/effects/teleport.ogg', 25, 1)
	var/turf/random_turf = get_turf(pick(orange(src,7)))
	do_teleport(src, random_turf)

/mob/living/simple_animal/hostile/hivebot/proc/wakeup()
	stance = HOSTILE_STANCE_IDLE
