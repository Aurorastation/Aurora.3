/obj/structure/reagent_crystal
	name = "chemical crystal cluster"
	desc = "A cluster of hardened chemical crystals."
	icon = 'icons/obj/crystals.dmi'
	icon_state = "scattered"
	anchored = TRUE
	density = FALSE
	var/singleton/reagent/reagent_id
	var/state = 0
	var/health = 100
	var/mine_rate = 1 // how fast you can mine it

	var/obj/machinery/power/crystal_agitator/creator // used to re-add dense turfs to agitation list when destroyed

/obj/structure/reagent_crystal/Initialize(mapload, var/reagent_i = null, var/our_creator = null)
	. = ..()
	if(!reagent_i)
		var/list/chems = list(/singleton/reagent/acetone, /singleton/reagent/aluminum, /singleton/reagent/ammonia, /singleton/reagent/carbon, /singleton/reagent/copper, /singleton/reagent/iron, /singleton/reagent/lithium, /singleton/reagent/mercury, /singleton/reagent/potassium, /singleton/reagent/radium, /singleton/reagent/sodium)
		reagent_i = pick(chems)
	reagent_id = reagent_i
	name = replacetext(name, "chemical", lowertext(initial(reagent_id.name)))
	desc = replacetext(desc, "chemical", lowertext(initial(reagent_id.name)))
	var/mutable_appearance/crystal_overlay = mutable_appearance(icon, "[initial(icon_state)]-overlay")
	crystal_overlay.color = initial(reagent_id.color)
	add_overlay(crystal_overlay)
	if(our_creator)
		creator = our_creator

/obj/structure/reagent_crystal/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	var/state
	var/current_damage = health / initial(health)
	switch(current_damage)
		if(0 to 0.2)
			state = SPAN_DANGER("The crystal is barely holding together!")
		if(0.2 to 0.4)
			state = SPAN_WARNING("The crystal has various cracks visible!")
		if(0.4 to 0.8)
			state = SPAN_WARNING("The crystal has scratches and deeper grooves on its surface.")
		if(0.8 to 1)
			state = SPAN_NOTICE("The crystal looks structurally sound.")
	. += state

/obj/structure/reagent_crystal/proc/take_damage(var/damage)
	health -= damage
	if(health <= 0)
		visible_message(SPAN_WARNING("\The [src] collapses into smaller crystals!"))
		harvest()

/obj/structure/reagent_crystal/attack_hand(mob/user)
	if((user.mutations & HULK))
		user.visible_message(SPAN_WARNING("\The [user] smashes \the [src] apart!"), SPAN_WARNING("You smash \the [src] apart!"))
		harvest()
		return
	return ..()

/obj/structure/reagent_crystal/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/gun/energy/plasmacutter))
		mine_crystal(user, 30 / attacking_item.toolspeed, attacking_item.usesound)

	else if(istype(attacking_item, /obj/item/melee/energy))
		var/obj/item/melee/energy/WT = attacking_item
		if(WT.active)
			mine_crystal(user, 30 / attacking_item.toolspeed, attacking_item.usesound)
		else
			to_chat(user, SPAN_NOTICE("You need to activate \the [attacking_item] to do that!"))
			return

	else if(istype(attacking_item, /obj/item/melee/energy/blade))
		mine_crystal(user, 30 / attacking_item.toolspeed, attacking_item.usesound)

	else if(istype(attacking_item, /obj/item/pickaxe))
		var/obj/item/pickaxe/P = attacking_item
		mine_crystal(user, P.digspeed, attacking_item.usesound)

	else if(attacking_item.force > 5)
		user.do_attack_animation(src)
		playsound(get_turf(src), 'sound/weapons/smash.ogg', 50)
		visible_message(SPAN_WARNING("\The [user] smashes \the [attacking_item] into \the [src]."))
		take_damage(attacking_item.force * 4)

/obj/structure/reagent_crystal/proc/mine_crystal(var/mob/user, var/time_to_dig, var/use_sound)
	if(!user)
		return
	if(!time_to_dig)
		time_to_dig = 50

	if(do_after(user, time_to_dig * mine_rate, src))
		if(!src)
			return
		harvest()
		if(use_sound)
			playsound(get_turf(src), use_sound, 30, TRUE)

/obj/structure/reagent_crystal/proc/harvest()
	new /obj/item/reagent_crystal(get_turf(src), reagent_id, 5)
	qdel(src)

/obj/structure/reagent_crystal/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(30))
				harvest()
				return
			else
				health -= rand(60,180)
		if(3.0)
			if(prob(5))
				harvest()
				return
			else
				health -= rand(40,80)

	if(health <= 0)
		harvest()
	return

/obj/structure/reagent_crystal/attack_generic(var/mob/user, var/damage, var/attack_message = "smashes apart", var/wallbreaker)
	if(!damage || !wallbreaker)
		return FALSE
	user.do_attack_animation(src)
	visible_message(SPAN_WARNING("\The [user] [attack_message] \the [src]!"))
	harvest()
	return TRUE

/obj/structure/reagent_crystal/proc/become_dense()
	var/health_mod = health / initial(health)
	var/obj/structure/reagent_crystal/dense/P = new /obj/structure/reagent_crystal/dense(get_turf(src), reagent_id, creator)
	P.health *= health_mod
	if(creator)
		creator.agitation_turfs -= get_turf(src)
	qdel(src)

/obj/structure/reagent_crystal/dense
	name = "dense chemical crystal cluster"
	desc = "A dense cluster of hardened chemical crystals."
	icon_state = "dense"
	health = 200
	mine_rate = 2

/obj/structure/reagent_crystal/dense/harvest()
	var/turf/our_turf = get_turf(src)
	for(var/i = 0 to 2)
		new /obj/item/reagent_crystal(our_turf, reagent_id, 5)
	if(creator)
		creator.agitation_turfs += our_turf
	qdel(src)

/obj/item/reagent_crystal
	name = "crystal"
	desc = "A clear, pointy crystal. It looks rough, unprocessed."
	icon = 'icons/obj/crystals.dmi'
	icon_state = "crystal"

/obj/item/reagent_crystal/Initialize(mapload, reagent_i, amount)
	. = ..()
	create_reagents(max(5, amount))
	reagents.add_reagent(reagent_i, amount)
	var/singleton/reagent/R = GET_SINGLETON(reagent_i)
	name = "[lowertext(R.name)] crystal"
	desc = "A [lowertext(R.name)] crystal. It looks rough, unprocessed."
	desc_info = "This crystal can be ground to obtain the chemical material locked within."
	color = reagents.get_color()

/obj/item/storage/bag/crystal
	name = "crystal satchel"
	desc = "This big boy can store a vast amount of crystals."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	max_storage_space = 100
	can_hold = list(/obj/item/reagent_crystal)
