/mob/living/simple_animal/hostile/phoron_worm
	name = "goliath black trident worm"
	desc = "An utterly tremendous, disgustingly bloated worm which relishes in the consumption of phoron."
	icon = 'icons/mob/npc/phoron_worm.dmi'
	icon_state = "worm"
	icon_living = "worm"
	icon_dead = "worm_burrow"
	speak_emote = list("hisses")
	emote_hear = list("hisses")
	emote_see = list("hisses ferociously")
	turns_per_move = 5
	speak_chance = 5
	meat_type = /obj/item/reagent_containers/food/snacks/xenomeat
	organ_names = list("head", "rear segment", "central segment")
	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	maxHealth = 850
	health = 850
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	resist_mod = 2
	mob_size = 30
	environment_smash = 2
	attacktext = "chomped"
	attack_sound = 'sound/weapons/bite.ogg'

	faction = "worm"

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	see_invisible = SEE_INVISIBLE_NOLIGHTING

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	tameable = FALSE

	universal_understand = TRUE

	var/burrowing = FALSE

/mob/living/simple_animal/hostile/phoron_worm/death()
	..(null,"collapses under its own weight!")
	var/turf/T = get_turf(src)
	new /obj/effect/gibspawner/xeno(T)
	for(var/thing in contents)
		var/atom/movable/A = thing
		A.forceMove(T)
		A.throw_at_random(FALSE, 3, 1)
	qdel(src)

/mob/living/simple_animal/hostile/phoron_worm/update_icon()
	..()
	if(burrowing)
		icon_state = "worm_rest"

/mob/living/simple_animal/hostile/phoron_worm/UnarmedAttack(var/atom/A, var/proximity)
	if(burrowing)
		return

	if(istype(A, /obj/item/stack/material))
		var/obj/item/stack/material/P = A
		if(P.material.name == MATERIAL_PHORON)
			visible_message(SPAN_WARNING("\The [src] starts consuming \the [P]..."), SPAN_NOTICE("You start consuming \the [P]."))
			if(!do_after(src, 1 SECOND, P))
				return
			var/self_msg = "You consume \the [P][health < maxHealth ? ", healing yourself" : ""]."
			adjustBruteLoss(-5 * P.amount)
			visible_message(SPAN_WARNING("\The [src] consumes \the [P]!"), SPAN_NOTICE(self_msg))
			P.amount /= 2
			if(P.amount < 1)
				qdel(P)
			P.amount = round(P.amount)
			P.forceMove(src)
			return
	..()

/mob/living/simple_animal/hostile/phoron_worm/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(burrowing)
			if(istype(NewLoc, /turf/simulated/floor))
				var/turf/simulated/floor/F = NewLoc
				F.break_tile()

/mob/living/simple_animal/hostile/phoron_worm/verb/toggle_burrow()
	set name = "Toggle Burrowing"
	set desc = "Hide or not under the earth."
	set category = "Abilities"

	if(health <= 0 )
		return

	if(last_special > world.time)
		to_chat(src, SPAN_WARNING ("You must wait a little while before you can use this ability again!"))
		return

	if(burrowing)
		unburrow()
	else
		burrow()

	last_special = world.time + 10 SECONDS

	return

/mob/living/simple_animal/hostile/phoron_worm/proc/burrow()
	if(burrowing)
		return
	burrowing = TRUE
	mouse_opacity = FALSE
	speed = -1
	update_icon()
	pass_flags = PASSTABLE | PASSMOB
	layer = TURF_DETAIL_LAYER
	density = FALSE
	visible_message(SPAN_DANGER("\The [src] burrows into the ground!"))

/mob/living/simple_animal/hostile/phoron_worm/proc/unburrow()
	if(!burrowing)
		return
	burrowing = FALSE
	mouse_opacity = TRUE
	speed = initial(speed)
	update_icon()
	pass_flags = initial(pass_flags)
	layer = initial(layer)
	density = TRUE
	visible_message(SPAN_DANGER("\The [src] emerges from the ground!"))
	if(mob_size > 15)
		for(var/mob/living/M in orange(1,src))
			if(M != src)
				M.apply_damage(50, DAMAGE_BRUTE)
				M.apply_effect(6, STUN, blocked)
				M.throw_at(get_random_turf_in_range(get_turf(src), 1), 2)

/mob/living/simple_animal/hostile/phoron_worm/small
	name = "black trident worm"
	desc = "An utterly tremendous, disgustingly bloated worm which relishes in the consumption of phoron."
	icon = 'icons/mob/npc/small_phoron_worm.dmi'
	maxHealth = 80
	health = 80
	melee_damage_lower = 15
	melee_damage_upper = 15
	resist_mod = 1
	mob_size = 15
	environment_smash = 1
