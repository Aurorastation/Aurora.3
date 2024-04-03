/obj/structure/barricade
	icon = 'icons/obj/barricades.dmi'
	climbable = TRUE
	anchored = TRUE
	density = TRUE
	throwpass = TRUE //You can throw objects over this, despite its density.
	atom_flags = ATOM_FLAG_CHECKS_BORDER

	var/stack_type //The type of stack the barricade dropped when disassembled if any.
	var/stack_amount = 5 //The amount of stack dropped when disassembled at full health
	var/destroyed_stack_amount //to specify a non-zero amount of stack to drop when destroyed
	var/health = 100 //Pretty tough. Changes sprites at 300 and 150
	var/maxhealth = 100 //Basic code functions

	///Used for calculating some stuff related to maxhealth as it constantly changes due to e.g. barbed wire. set to 100 to avoid possible divisions by zero
	var/starting_maxhealth = 100

	var/force_level_absorption = 5 //How much force an item needs to even damage it at all.
	var/barricade_hitsound
	var/barricade_type = "barricade" //"metal", "plasteel", etc.
	var/can_change_dmg_state = TRUE
	var/damage_state = BARRICADE_DMG_NONE
	var/closed = FALSE
	var/can_wire = FALSE
	var/is_wired = FALSE
	var/metallic = TRUE

/obj/structure/barricade/Initialize(mapload, mob/user)
	. = ..()
	update_icon()
	starting_maxhealth = maxhealth

/obj/structure/barricade/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += SPAN_INFO("It is recommended to stand flush to a barricade or one tile away for maximum efficiency.")
	if(is_wired)
		. += SPAN_INFO("There is a length of wire strewn across the top of this barricade.")
	switch(damage_state)
		if(BARRICADE_DMG_NONE)
			. += SPAN_INFO("It appears to be in good shape.")
		if(BARRICADE_DMG_SLIGHT)
			. += SPAN_WARNING("It's slightly damaged, but still very functional.")
		if(BARRICADE_DMG_MODERATE)
			. += SPAN_WARNING("It's quite beat up, but it's holding together.")
		if(BARRICADE_DMG_HEAVY)
			. += SPAN_WARNING("It's crumbling apart, just a few more blows will tear it apart!")

/obj/structure/barricade/update_icon()
	overlays.Cut()
	if(!closed)
		if(can_change_dmg_state)
			icon_state = "[barricade_type]_[damage_state]"
		else
			icon_state = "[barricade_type]"
		switch(dir)
			if(SOUTH)
				layer = ABOVE_HUMAN_LAYER
			if(NORTH)
				layer = initial(layer) - 0.01
			else
				reset_plane_and_layer()
		if(!anchored)
			reset_plane_and_layer()
	else
		if(can_change_dmg_state)
			icon_state = "[barricade_type]_closed_[damage_state]"
		else
			icon_state = "[barricade_type]_closed"
		layer = OBJ_LAYER

	if(is_wired)
		if(!closed)
			overlays += image('icons/obj/barricades.dmi', icon_state = "[src.barricade_type]_wire")
		else
			overlays += image('icons/obj/barricades.dmi', icon_state = "[src.barricade_type]_closed_wire")

	..()

/obj/structure/barricade/proc/handle_barrier_chance()
	if(!anchored)
		return FALSE
	return prob(max(30,(100.0*health)/maxhealth))

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return TRUE
	if(istype(mover, /obj/item/projectile))
		return (check_cover(mover,target))
	if (get_dir(loc, target) == dir)
		return !density
	else
		return TRUE

/obj/structure/barricade/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = get_turf(src)
	if(!cover)
		return TRUE
	if (get_dist(P.starting, loc) <= 1)
		return TRUE
	var/chance = handle_barrier_chance()
	if(chance)
		bullet_act(P)
		return FALSE
	return TRUE

/obj/structure/barricade/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return TRUE
	if (get_dir(loc, target) == dir)
		return !density
	else
		return TRUE

/obj/structure/barricade/attack_robot(mob/user)
	return attack_hand(user)

/obj/structure/barricade/attack_hand(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/shredding = H.species.can_shred(H)
		if(shredding)
			var/datum/unarmed_attack/UA = H.default_attack
			if((UA.damage + UA.armor_penetration) > force_level_absorption)
				var/attack_verb = pick("mangles", "slices", "slashes", "shreds")
				attack_generic(user, UA.damage, attack_verb)

/obj/structure/barricade/attack_generic(mob/user, damage, attack_verb, wallbreaker)
	if(!damage)
		return FALSE
	if(!isliving(user))
		return
	var/mob/living/L = user
	L.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	visible_message(SPAN_DANGER("[L] [attack_verb] the [src]!"))
	if(barricade_hitsound)
		playsound(src, barricade_hitsound, 50, 1)
	if(is_wired)
		visible_message(SPAN_DANGER("\The [src]'s barbed wire slices into [L]!"))
		L.apply_damage(rand(5, 10), DAMAGE_BRUTE, pick(BP_R_HAND, BP_L_HAND), "barbed wire", DAMAGE_FLAG_SHARP|DAMAGE_FLAG_EDGE, 25)
	L.do_attack_animation(src)
	take_damage(damage)

/obj/structure/barricade/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/stack/barbed_wire))
		var/obj/item/stack/barbed_wire/B = attacking_item
		if(can_wire)
			user.visible_message(SPAN_NOTICE("[user] starts setting up [attacking_item.name] on [src]."),
			SPAN_NOTICE("You start setting up [attacking_item.name] on [src]."))
			if(do_after(user, 20, src, DO_REPAIR_CONSTRUCT) && can_wire)
				// Make sure there's still enough wire in the stack
				if(!B.use(1))
					return

				playsound(src.loc, 'sound/effects/barbed_wire_movement.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] sets up [attacking_item.name] on [src]."),
				SPAN_NOTICE("You set up [attacking_item.name] on [src]."))

				maxhealth += 50
				update_health(-50)
				can_wire = FALSE
				is_wired = TRUE
				climbable = FALSE
				update_icon()
		return

	if(attacking_item.iswirecutter())
		if(is_wired)
			user.visible_message(SPAN_NOTICE("[user] begin removing the barbed wire on [src]."),
			SPAN_NOTICE("You begin removing the barbed wire on [src]."))
			if(do_after(user, 20, src, DO_REPAIR_CONSTRUCT))
				if(!is_wired)
					return

				playsound(src.loc, 'sound/items/Wirecutter.ogg', 25, 1)
				user.visible_message(SPAN_NOTICE("[user] removes the barbed wire on [src]."),
				SPAN_NOTICE("You remove the barbed wire on [src]."))
				maxhealth -= 50
				update_health(50)
				can_wire = TRUE
				is_wired = FALSE
				climbable = TRUE
				update_icon()
				new /obj/item/stack/barbed_wire(loc)
		return

	if((attacking_item.force + attacking_item.armor_penetration) > force_level_absorption)
		..()
		if(barricade_hitsound)
			playsound(src, barricade_hitsound, 25, 1)
		hit_barricade(attacking_item, user)

/obj/structure/barricade/bullet_act(obj/item/projectile/P)
	bullet_ping(P)
	var/damage_to_take = P.damage * P.anti_materiel_potential
	take_damage(damage_to_take)
	return TRUE

/obj/structure/barricade/proc/barricade_deconstruct(deconstruct)
	if(deconstruct && is_wired)
		new /obj/item/stack/barbed_wire(loc)
	if(stack_type)
		var/stack_amt
		if(!deconstruct && destroyed_stack_amount)
			stack_amt = destroyed_stack_amount
		else
			stack_amt = round(stack_amount * (health/starting_maxhealth)) //Get an amount of sheets back equivalent to remaining health. Obviously, fully destroyed means 0

		if(stack_amt)
			new stack_type (loc, stack_amt)
	qdel(src)

/obj/structure/barricade/ex_act(severity, direction, cause_data)
	for(var/obj/structure/barricade/B in get_step(src,dir)) //discourage double-stacking barricades by removing health from opposing barricade
		if(B.dir == reverse_direction(dir))
			INVOKE_ASYNC(B, TYPE_PROC_REF(/atom, ex_act), severity, direction)
	update_health(round(severity))

// This proc is called whenever the cade is moved, so I thought it was appropriate,
// especially since the barricade's direction needs to be handled when moving
// diagonally.
/obj/structure/barricade/Move()
	. = ..()
	if (dir & EAST)
		set_dir(EAST)
	else if(dir & WEST)
		set_dir(WEST)
	update_icon()

/obj/structure/barricade/set_dir(ndir)
	. = ..()
	update_icon()

/obj/structure/barricade/proc/hit_barricade(var/obj/item/I, var/mob/user)
	if(!isliving(user))
		return
	var/mob/living/L = user
	L.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/message = pick(I.attack_verb)
	visible_message(SPAN_DANGER("[L] has [message] the [src]!"))
	L.do_attack_animation(src)
	take_damage(I.force)

/obj/structure/barricade/proc/take_damage(var/damage)
	for(var/obj/structure/barricade/B in get_step(src,dir)) //discourage double-stacking barricades by removing health from opposing barricade
		if(B.dir == reverse_direction(dir))
			B.update_health(damage)
	update_health(damage)

/obj/structure/barricade/proc/update_health(damage, nomessage)
	health -= damage
	health = Clamp(health, 0, maxhealth)

	if(!health)
		if(!nomessage)
			visible_message(SPAN_DANGER("[src] falls apart!"))
		barricade_deconstruct()
		return

	update_damage_state()
	update_icon()

/obj/structure/barricade/proc/update_damage_state()
	var/health_percent = round(health/maxhealth * 100)
	switch(health_percent)
		if(0 to 25) damage_state = BARRICADE_DMG_HEAVY
		if(25 to 50) damage_state = BARRICADE_DMG_MODERATE
		if(50 to 75) damage_state = BARRICADE_DMG_SLIGHT
		if(75 to INFINITY) damage_state = BARRICADE_DMG_NONE

/obj/structure/barricade/proc/weld_cade(obj/item/weldingtool/WT, mob/user)
	if(!metallic)
		return FALSE

	if(!(WT.use(2, user)))
		return FALSE

	user.visible_message(SPAN_NOTICE("[user] begins repairing damage to [src]."),
	SPAN_NOTICE("You begin repairing the damage to [src]."))

	if(WT.use_tool(src, user, 7 SECONDS, volume = 40))
		user.visible_message(SPAN_NOTICE("[user] repairs some damage on [src]."),
		SPAN_NOTICE("You repair \the [src]."))
		update_health(-200)

	return TRUE

/obj/structure/barricade/verb/count_rotate()
	set name = "Rotate Barricade Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	rotate(usr, 1)

/obj/structure/barricade/verb/clock_rotate()
	set name = "Rotate Barricade Clockwise"
	set category = "Object"
	set src in oview(1)

	rotate(usr, -1)

/obj/structure/barricade/rotate(var/mob/user, var/rotation_dir = -1)//-1 for clockwise, 1 for counter clockwise
	if(world.time <= user.next_move || !ishuman(user) || use_check_and_message(user))
		return

	if(anchored)
		to_chat(usr, SPAN_WARNING("\The [src] is fastened to the floor, you can't rotate it!"))
		return

	user.next_move = world.time + 3	//slight spam prevention? you don't want every metal cade to turn into a doorway
	set_dir(turn(dir, 90 * rotation_dir))
	update_icon()

/obj/structure/barricade/AltClick(mob/user)
	rotate(user)
