

/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	desc_extended = "This specimen is a native to the Romanovich Cloud, and possesses a shimmering appearance to its scales. Much like other Cloud-faring creatures, this primarily thrives off of a \
	diet consisting of raw ores and rock."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_rest = "carp_rest"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/fish/carpmeat
	butchering_products = list(/obj/item/reagent_containers/food/snacks/fish/roe = 1)
	organ_names = list("head", "chest", "tail", "left flipper", "right flipper")
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 4
	maxHealth = 25
	health = 25
	mob_size = 10

	blood_overlay_icon = 'icons/mob/npc/blood_overlay_carp.dmi'
	harm_intent_damage = 4
	melee_damage_lower = 15
	melee_damage_upper = 15
	armor_penetration = 5
	attack_flags = DAMAGE_FLAG_EDGE
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	//Space carp aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	break_stuff_probability = 15

	faction = "carp"
	attack_emote = "nashes at"

	flying = TRUE
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	smart_melee = FALSE

/mob/living/simple_animal/hostile/carp/update_icon()
	..()
	if(resting || stat == DEAD)
		blood_overlay_icon = 'icons/mob/npc/blood_overlay.dmi'
	else
		blood_overlay_icon = initial(blood_overlay_icon)
	handle_blood(TRUE)

/mob/living/simple_animal/hostile/carp/Allow_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/carp/MoveToTarget()
	stop_automated_movement = 1
	if(istype(target_mob, /obj/effect/energy_field) && !QDELETED(target_mob) && (target_mob in targets))
		change_stance(HOSTILE_STANCE_ATTACKING)
		walk_to(src, target_mob, 1, move_to_delay)
		return 1
	..()

/mob/living/simple_animal/hostile/carp/AttackTarget()
	stop_automated_movement = 1
	if(istype(target_mob, /obj/effect/energy_field) && !QDELETED(target_mob) && (get_dist(src, target_mob) <= 1))
		AttackingTarget()
		attacked_times += 1
		return 1
	return ..()

/mob/living/simple_animal/hostile/carp/AttackingTarget()
	. = ..()
	if(.)
		return
	if(istype(target_mob, /obj/effect/energy_field))
		var/obj/effect/energy_field/e = target_mob
		e.Stress(rand(1,2))
		visible_message("<span class='danger'>\the [src] bites \the [e]!</span>")
		src.do_attack_animation(e)
		return e

/mob/living/simple_animal/hostile/carp/DestroySurroundings(var/bypass_prob = FALSE)
	if(stance != HOSTILE_STANCE_ATTACKING || ON_ATTACK_COOLDOWN(src))
		return FALSE

	return ..()

/mob/living/simple_animal/hostile/carp/russian
	name = "Ivan the carp"
	desc = "A feared space carp, nicknamed as Ivan by the old spacemen of Tau Ceti."
	icon_state = "carp_russian"
	icon_living = "carp_russian"
	icon_dead = "carp_russian_dead"
	maxHealth = 50 //stronk
	health = 50

/mob/living/simple_animal/hostile/carp/russian/FindTarget()
	. = ..()
	if(.)
		custom_emote(VISIBLE_MESSAGE,"spots a filthy capitalist!")

/mob/living/simple_animal/hostile/carp/asteroid
	icon_state = "carp_asteroid"
	icon_living = "carp_asteroid"
	icon_dead = "carp_asteroid_dead"
	icon_rest = "carp_asteroid_rest"

/mob/living/simple_animal/hostile/carp/shark
	name = "space shark"
	desc = "The bigger, angrier cousin of the space carp."
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	icon_rest = "shark_rest"
	meat_amount = 5

	maxHealth = 100
	health = 100

	mob_size = 15

	melee_damage_lower = 20
	melee_damage_upper = 25

/mob/living/simple_animal/hostile/carp/shark/reaver
	name = "reaver"
	desc = "A whirl of talons, kept precariously balanced by its oversized whip-like tail. Its violent tendencies overshadow any other behavioral patterns it possesses."
	icon = 'icons/mob/npc/large_space_xenofauna.dmi'
	icon_state = "reaver"
	icon_living = "reaver"
	icon_dead = "reaver"
	meat_amount = 5

	maxHealth = 100
	health = 100

	mob_size = 15

	melee_damage_lower = 30
	melee_damage_upper = 30

/mob/living/simple_animal/hostile/carp/shark/reaver/death(gibbed)
	..()
	if(!gibbed)
		gibs(src.loc)
		qdel(src)
		return

/mob/living/simple_animal/hostile/carp/shark/reaver/eel
	name = "spectral eel"
	desc = "An uncanny mimic of a grinning face is the most unique trait of this otherwise dark-scaled, highly carnivorous beast. It moves slowly, creeping along at a foreboding pace."
	icon_state = "eel"
	icon_living = "eel"
	icon_dead = "eel"
	meat_amount = 5

	maxHealth = 150
	health = 150

	speed = 6

	melee_damage_lower = 20
	melee_damage_upper = 20
	armor_penetration = 10
	var/image/eye_overlay

/mob/living/simple_animal/hostile/carp/shark/reaver/eel/Initialize()
	. = ..()
	eye_overlay = image(icon, "eel_eyeglow", layer = EFFECTS_ABOVE_LIGHTING_LAYER)
	eye_overlay.appearance_flags = KEEP_APART
	add_overlay(eye_overlay)
	set_light(MINIMUM_USEFUL_LIGHT_RANGE, 2, LIGHT_COLOR_TUNGSTEN)

/mob/living/simple_animal/hostile/carp/shark/reaver/eel/death()
	. = ..()
	cut_overlays()
	set_light(0)

/mob/living/simple_animal/hostile/carp/bloater
	name = "bloater"
	desc = "A fat, mineral-devouring creature frequently herded for mining expeditions. Its actual ability to dig is less valuable than its volatile nature, however."
	icon = 'icons/mob/npc/large_space_xenofauna.dmi'
	icon_state = "bloater"
	icon_living = "bloater"
	icon_dead = "bloater"
	meat_amount = 5

	maxHealth = 50
	health = 50

	mob_size = 5

	melee_damage_lower = 15
	melee_damage_upper = 15

	var/has_exploded = FALSE

/mob/living/simple_animal/hostile/carp/bloater/AttackingTarget()
	..()
	LoseTarget()
	change_stance(HOSTILE_STANCE_TIRED)
	stop_automated_movement = 1
	wander = 0
	if(!has_exploded)
		icon_state = "bloater_bloating"
		icon_living = "bloater_bloating"
		has_exploded = TRUE
		addtimer(CALLBACK(src, PROC_REF(explode)), 5)

/mob/living/simple_animal/hostile/carp/bloater/bullet_act(var/obj/item/projectile/Proj)
	if(!has_exploded)
		has_exploded = TRUE
		explode()

/mob/living/simple_animal/hostile/carp/bloater/death(gibbed)
	..()
	if(!gibbed)
		explode(src.loc)
		qdel(src)
		return

/mob/living/simple_animal/hostile/carp/bloater/proc/explode()
	explosion(src, -1, 1, 2)
	src.gib()

/mob/living/simple_animal/hostile/carp/old
	icon_state = "carp_old"
	icon_living = "carp_old"
	icon_dead = "carp_old_dead"
	icon_gib = "carp_old_gib"
	icon_rest = "carp_old"

/mob/living/simple_animal/hostile/carp/shark/old
	icon = 'icons/mob/npc/spaceshark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	icon_rest = "shark"
	pixel_x = -16

/mob/living/simple_animal/hostile/gnat
	name = "gnat"
	desc = "A small, obnoxious looking specimen. This is a renowned wire-chewing menace in the Romanovich Cloud, similarly insufferable as an Earth insect."
	desc_extended = "This specimen is a native to the Romanovich Cloud, and possesses a shimmering appearance to its scales. Much like other Cloud-faring creatures, this primarily thrives off of a \
	diet consisting of raw ores and rock."
	icon_state = "gnat"
	icon_living = "gnat"
	icon_dead = "gnat_dead"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/fish/carpmeat
	organ_names = list("head", "chest", "tail", "left flipper", "right flipper")
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 2
	maxHealth = 5
	health = 5
	mob_size = 2
	density = FALSE
	destroy_surroundings = FALSE

	blood_overlay_icon = 'icons/mob/npc/blood_overlay_carp.dmi'
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "carp"
	attack_emote = "nashes at"

	flying = TRUE
	see_invisible = SEE_INVISIBLE_NOLIGHTING
