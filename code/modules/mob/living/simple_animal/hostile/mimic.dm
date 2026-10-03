//
// Abstract Class
//

/datum/ai_holder/simple_animal/hostile/mimic

/datum/ai_holder/simple_animal/hostile/mimic/on_target_acquired(atom/new_target, atom/old_target)
	holder.AIAudibleEmote("growls at [new_target]")

/datum/ai_holder/simple_animal/hostile/mimic/crate

/datum/ai_holder/simple_animal/hostile/mimic/crate/on_target_acquired(atom/new_target, atom/old_target)
	. = ..()
	var/mob/living/simple_animal/hostile/mimic/crate/crate = holder
	crate.trigger()

/datum/ai_holder/simple_animal/hostile/mimic/crate/on_target_lost(atom/old_target)
	var/mob/living/simple_animal/hostile/mimic/crate/crate = holder
	crate.icon_state = initial(crate.icon_state)

/datum/ai_holder/simple_animal/hostile/mimic/crate/post_melee_attack(atom/the_target)
	. = ..()
	var/mob/living/simple_animal/hostile/mimic/crate/crate = holder
	crate.icon_state = initial(crate.icon_state)
	if(isliving(the_target) && prob(15))
		var/mob/living/living_target = the_target
		living_target.Weaken(2)
		living_target.visible_message(SPAN_DANGER("\the [crate] knocks down \the [living_target]!"))

/datum/ai_holder/simple_animal/hostile/mimic/copy

/datum/ai_holder/simple_animal/hostile/mimic/copy/post_melee_attack(atom/the_target)
	. = ..()
	var/mob/living/simple_animal/hostile/mimic/copy/copy_mimic = holder
	if(copy_mimic.knockdown_people && isliving(the_target) && prob(15))
		var/mob/living/living_target = the_target
		living_target.Weaken(1)
		living_target.visible_message(SPAN_DANGER("\the [copy_mimic] knocks down \the [living_target]!"))

/mob/living/simple_animal/hostile/mimic
	ai_holder_type = /datum/ai_holder/simple_animal/hostile/mimic
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/containers/crate.dmi'
	icon_state = "crate_preview"
	icon_living = "crate_preview"

	meat_type = /obj/item/reagent_containers/food/snacks/fish/carpmeat
	organ_names = list("lid", "body")
	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"
	speed = 4
	maxhealth = 250
	health = 250

	harm_intent_damage = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = "attacks"
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

	faction = "mimic"
	speed = 8

	tameable = FALSE
	sample_data = null

/mob/living/simple_animal/hostile/mimic/death()
	..()
	qdel(src)

//
// Crate Mimic
//


// Aggro when you try to open them. Will also pickup loot when spawns and drop it when dies.
/mob/living/simple_animal/hostile/mimic/crate
	ai_holder_type = /datum/ai_holder/simple_animal/hostile/mimic/crate

	attacktext = "bites"

	stop_automated_movement = 1
	wander = 0
	var/attempt_open = 0

// Pickup loot
/mob/living/simple_animal/hostile/mimic/crate/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		I.forceMove(src)

/mob/living/simple_animal/hostile/mimic/crate/DestroySurroundings()
	..()

/mob/living/simple_animal/hostile/mimic/crate/get_targets()
	return ..(attempt_open ? world.view : 1)

/mob/living/simple_animal/hostile/mimic/crate/proc/trigger()
	if(!attempt_open)
		visible_message("<b>[src]</b> starts to move!")
		attempt_open = 1

/mob/living/simple_animal/hostile/mimic/crate/adjustBruteLoss(var/damage)
	trigger()
	..(damage)

/mob/living/simple_animal/hostile/mimic/crate/death()

	var/obj/structure/closet/crate/C = new(get_turf(src))
	// Put loot in crate
	for(var/obj/O in src)
		O.forceMove(C)
	..()

//
// Copy Mimic
//

GLOBAL_LIST_INIT(protected_objects, list(/obj/structure/table, /obj/structure/cable, /obj/structure/window, /obj/projectile/animate))

/mob/living/simple_animal/hostile/mimic/copy
	ai_holder_type = /datum/ai_holder/simple_animal/hostile/mimic/copy

	health = 100
	maxhealth = 100
	var/mob/living/creator = null // the creator
	var/destroy_objects = 0
	var/knockdown_people = 0

/mob/living/simple_animal/hostile/mimic/copy/Initialize(mapload, obj/copy, mob/living/creator)
	. = ..(mapload)
	CopyObject(copy, creator)

/mob/living/simple_animal/hostile/mimic/copy/death()

	for(var/atom/movable/M in src)
		M.forceMove(get_turf(src))
	..()

/mob/living/simple_animal/hostile/mimic/copy/get_targets()
	return ..() - creator

/mob/living/simple_animal/hostile/mimic/copy/proc/CopyObject(var/obj/O, var/mob/living/creator)

	if((istype(O, /obj/item) || istype(O, /obj/structure)) && !is_type_in_list(O, GLOB.protected_objects))

		O.forceMove(src)
		appearance = O
		icon_living = icon_state

		if(istype(O, /obj/structure))
			health = (anchored * 50) + 50
			destroy_objects = 1
			if(O.density && O.anchored)
				knockdown_people = 1
				melee_damage_lower *= 2
				melee_damage_upper *= 2
		else if(istype(O, /obj/item))
			var/obj/item/I = O
			health = 15 * I.w_class
			melee_damage_lower = 2 + I.force
			melee_damage_upper = 2 + I.force
			speed = 2 * I.w_class

		maxhealth = health
		if(creator)
			src.creator = creator
			faction = "[REF(creator)]" // very unique
		return 1
	return

/mob/living/simple_animal/hostile/mimic/copy/DestroySurroundings()
	if(destroy_objects)
		..()
