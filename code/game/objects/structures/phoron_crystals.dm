/obj/structure/phoron_crystal
	name = "phoron crystal cluster"
	desc = "A cluster of hardened phoron crystals."
	icon = 'icons/obj/phoron_crystals.dmi'
	icon_state = "phoron_crystals"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_CABLE_LAYER
	var/state = 0
	var/health = 100
	var/mine_rate = 1 // how fast you can mine it

/obj/structure/phoron_crystal/examine(mob/user)
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
	to_chat(user, state)

/obj/structure/phoron_crystal/proc/take_damage(var/damage)
	health -= damage
	if(health <= 0)
		visible_message(SPAN_WARNING("\The [src] collapses into smaller crystals!"))
		harvest()

/obj/structure/phoron_crystal/attack_hand(mob/user)
	if(HULK in user.mutations)
		user.visible_message(SPAN_WARNING("\The [user] smashes \the [src] apart!"), SPAN_WARNING("You smash \the [src] apart!"))
		harvest()
		return
	return ..()

/obj/structure/phoron_crystal/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/gun/energy/plasmacutter))
		mine_crystal(user, 30 / W.toolspeed, W.usesound)

	else if(istype(W, /obj/item/melee/energy))
		var/obj/item/melee/energy/WT = W
		if(WT.active)
			mine_crystal(user, 30 / W.toolspeed, W.usesound)
		else
			to_chat(user, SPAN_NOTICE("You need to activate \the [W] to do that!"))
			return

	else if(istype(W, /obj/item/melee/energy/blade))
		mine_crystal(user, 30 / W.toolspeed, W.usesound)

	else if(istype(W, /obj/item/pickaxe))
		var/obj/item/pickaxe/P = W
		mine_crystal(user, P.digspeed, W.usesound)

	else if(W.force > 5)
		user.do_attack_animation(src)
		playsound(get_turf(src), 'sound/weapons/smash.ogg', 50)
		visible_message(SPAN_WARNING("\The [user] smashes \the [W] into \the [src]."))
		take_damage(W.force * 4)

/obj/structure/phoron_crystal/proc/mine_crystal(var/mob/user, var/time_to_dig, var/use_sound)
	if(!user)
		return
	if(!time_to_dig)
		time_to_dig = 50

	if(do_after(user, time_to_dig * mine_rate, act_target = src))
		if(!src)
			return
		harvest()
		if(use_sound)
			playsound(get_turf(src), use_sound, 30, TRUE)

/obj/structure/phoron_crystal/proc/harvest()
	new /obj/item/ore/phoron/impure(get_turf(src))
	qdel(src)

/obj/structure/phoron_crystal/ex_act(severity)
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
		else
	if(health <= 0)
		harvest()
	return

/obj/structure/phoron_crystal/attack_generic(var/mob/user, var/damage, var/attack_message = "smashes apart", var/wallbreaker)
	if(!damage || !wallbreaker)
		return FALSE
	user.do_attack_animation(src)
	visible_message(SPAN_WARNING("\The [user] [attack_message] \the [src]!"))
	harvest()
	return TRUE

/obj/structure/phoron_crystal/proc/become_dense()
	var/health_mod = health / initial(health)
	var/obj/structure/phoron_crystal/dense/P = new /obj/structure/phoron_crystal/dense(get_turf(src))
	P.health *= health_mod
	qdel(src)

/obj/structure/phoron_crystal/dense
	name = "dense phoron crystal cluster"
	desc = "A dense cluster of hardened phoron crystals."
	icon_state = "dense_phoron_crystals"
	density = TRUE
	health = 200
	mine_rate = 2

/obj/structure/phoron_crystal/dense/harvest()
	new /obj/item/ore/phoron/impure(get_turf(src))
	new /obj/item/ore/phoron/impure(get_turf(src))
	new /obj/item/ore/phoron/impure(get_turf(src))
	qdel(src)
