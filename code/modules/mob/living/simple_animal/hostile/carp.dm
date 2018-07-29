

/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	speak_chance = 0
	turns_per_move = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat
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

	flying = TRUE

/mob/living/simple_animal/hostile/carp/Allow_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space carp!	//original comments do not steal

/mob/living/simple_animal/hostile/carp/FindTarget()
	if(!faction) //No faction, no reason to attack anybody.
		return null

	var/atom/T = null
	var/lowest_health = INFINITY // Max you can get
	stop_automated_movement = 0

	for(var/atom/A in targets)

		if(A == src)
			continue

		var/atom/F = Found(A)
		if(F)
			T = F
			break

		if(isliving(A))
			var/mob/living/L = A
			if((L.faction == src.faction) && !attack_same)
				continue
			if(L in friends)
				continue

			if(!L.stat && (L.health < lowest_health))
				lowest_health = L.health
				T = L
				break

		else if(istype(A, /obj/mecha)) // Our line of sight stuff was already done in ListTargets().
			var/obj/mecha/M = A
			if (M.occupant)
				T = M
				break

		if(istype(A, /obj/machinery/bot))
			var/obj/machinery/bot/B = A
			if (B.health > 0)
				T = B
				break

		if(istype(A, /obj/effect/energy_field))
			T = A
			break

	if (T != target_mob)
		target_mob = T
		FoundTarget()
		custom_emote(1,"nashes at [target_mob]")
	if(!isnull(T))
		stance = HOSTILE_STANCE_ATTACK
	return T

/mob/living/simple_animal/hostile/carp/MoveToTarget()
	stop_automated_movement = 1
	if(istype(target_mob, /obj/effect/energy_field) && !QDELETED(target_mob) && (target_mob in targets))
		stance = HOSTILE_STANCE_ATTACKING
		walk_to(src, target_mob, 1, move_to_delay)
		return 1
	if(QDELETED(target_mob) || SA_attackable(target_mob))
		LoseTarget()
	if(target_mob in targets)
		if(ranged)
			if(get_dist(src, target_mob) <= 6)
				OpenFire(target_mob)
			else
				walk_to(src, target_mob, 1, move_to_delay)
		else
			stance = HOSTILE_STANCE_ATTACKING
			walk_to(src, target_mob, 1, move_to_delay)

/mob/living/simple_animal/hostile/carp/AttackTarget()

	stop_automated_movement = 1
	if(istype(target_mob, /obj/effect/energy_field) && !QDELETED(target_mob) && (get_dist(src, target_mob) <= 1))
		AttackingTarget()
		return 1
	if(QDELETED(target_mob) || SA_attackable(target_mob))
		LoseTarget()
		return 0
	if(!(target_mob in targets))
		LoseTarget()
		return 0
	if(next_move >= world.time)
		return 0
	if(get_dist(src, target_mob) <= 1)	//Attacking
		AttackingTarget()
		attacked_times += 1
		return 1

/mob/living/simple_animal/hostile/carp/AttackingTarget()
	setClickCooldown(attack_delay)
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		if(prob(15))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")
		L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return L
	if(istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return M
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return B
	if(istype(target_mob, /obj/effect/energy_field))
		var/obj/effect/energy_field/e = target_mob
		e.Stress(rand(2,4))
		visible_message("<span class='danger'>\the [src] has attacked [e]!</span>")

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
	icon = 'icons/mob/spaceshark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	meat_amount = 5

	pixel_x = -16

	maxHealth = 100
	health = 100

	mob_size = 15

	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 25
