

/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	icon_rest = "carp_rest"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = 4
	maxHealth = 25
	health = 25
	mob_size = 10

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
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

/mob/living/simple_animal/hostile/carp/Initialize()
	. = ..()
	target_type_validator_map[/obj/effect/energy_field] = CALLBACK(src, .proc/validator_e_field)

/mob/living/simple_animal/hostile/carp/Allow_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/carp/MoveToTarget()
	stop_automated_movement = 1
	if(istype(target_mob, /obj/effect/energy_field) && !QDELETED(target_mob) && (target_mob in targets))
		stance = HOSTILE_STANCE_ATTACKING
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
	if(prob(break_stuff_probability) || bypass_prob)
		for(var/dir in cardinal) // North, South, East, West
			var/obj/effect/energy_field/e = locate(/obj/effect/energy_field, get_step(src, dir))
			if(e)
				e.Stress(rand(1,2))
				visible_message("<span class='danger'>\the [src] bites \the [e]!</span>")
				src.do_attack_animation(e)
				target_mob = e
				stance = HOSTILE_STANCE_ATTACKING
				return 1
			for(var/obj/structure/window/obstacle in get_step(src, dir))
				if(obstacle.dir == reverse_dir[dir]) // So that windows get smashed in the right order
					obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
					return 1
			var/obj/structure/obstacle = locate(/obj/structure, get_step(src, dir))
			if(istype(obstacle, /obj/structure/window) || istype(obstacle, /obj/structure/closet) || istype(obstacle, /obj/structure/table) || istype(obstacle, /obj/structure/grille))
				obstacle.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
				return 1
	return 0

/mob/living/simple_animal/hostile/carp/proc/validator_e_field(var/obj/effect/energy_field/E, var/atom/current)
	if(isliving(current)) // We prefer mobs over anything else
		return FALSE
	if(get_dist(src, E) < get_dist(src, current))
		return TRUE
	else
		return FALSE

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
        custom_emote(1,"spots a filthy capitalist!")

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

	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 25

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
