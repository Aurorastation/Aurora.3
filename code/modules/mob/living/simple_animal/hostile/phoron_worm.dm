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

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0

	tameable = FALSE

	var/burrowing = FALSE

/mob/living/simple_animal/hostile/phoron_worm/death()
	..(null,"collapses under its own weight!")
	var/turf/T = get_turf(src)
	new /obj/effect/gibspawner/xeno(T)
	qdel(src)

/mob/living/simple_animal/hostile/phoron_worm/update_icon()
	..()
	if(burrowing)
		icon_state = "worm_rest"

/mob/living/simple_animal/hostile/phoron_worm/UnarmedAttack(var/atom/A, var/proximity)
	if(burrowing)
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

	if(!health)
		return

	if(last_special > world.time)
		to_chat(src, "<span class='warning'>You must wait a little while before you can use this ability again!</span>")
		return

	if(burrowing)
		unburrow()
	else
		burrow()

	last_special = world.time + 100

	return

/mob/living/simple_animal/hostile/phoron_worm/proc/burrow()
	if(burrowing)
		return
	burrowing = TRUE
	mouse_opacity = FALSE
	speed = -1
	update_icon()
	pass_flags = PASSTABLE | PASSMOB
	layer = ON_TURF_LAYER
	visible_message("<span class='danger'>\The [src] burrows into the ground!</span>")

/mob/living/simple_animal/hostile/phoron_worm/proc/unburrow()
	if(!burrowing)
		return
	burrowing = FALSE
	mouse_opacity = TRUE
	speed = initial(speed)
	update_icon()
	pass_flags = initial(pass_flags)
	layer = initial(layer)
	visible_message("<span class='danger'>\The [src] emerges from the ground!</span>")

/mob/living/simple_animal/hostile/phoron_worm/verb/eat_phoron()
	set name = "Consume Phoron"
	set desc = "Consume phoron on the tile you are standing on."
	set category = "Abilities"

	if(burrowing)
		return

	var/obj/item/stack/material/P = locate() in get_turf(src)
	if(P.material.name == MATERIAL_PHORON)
		adjustBruteLoss(-5*P.amount)
		visible_message("<span class='danger'>\The [src] consumes \the [P]!</span>")
		qdel(P)
