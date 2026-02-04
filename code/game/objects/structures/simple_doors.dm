/obj/structure/simple_door
	name = "door"
	density = 1
	anchored = 1

	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	build_amt = 10
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/oreAmount = 7
	var/datum/lock/lock
	var/initial_lock_value //for mapping purposes. Basically if this value is set, it sets the lock to this value.
	var/health = 100
	var/maxhealth = 100

/obj/structure/simple_door/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(lock)
		. += SPAN_NOTICE("It appears to have a lock.")

/obj/structure/simple_door/fire_act(exposed_temperature, exposed_volume)
	. = ..()

	TemperatureAct(exposed_temperature)

/obj/structure/simple_door/proc/TemperatureAct(temperature)
	health -= material.combustion_effect(get_turf(src),temperature, 0.3)
	CheckHealth()

/obj/structure/simple_door/New(var/newloc, var/material_name, var/locked)
	..()
	if(!material_name)
		material_name = DEFAULT_WALL_MATERIAL
	material = SSmaterials.get_material_by_name(material_name)
	if(!material)
		qdel(src)
		return
	icon_state = material.door_icon_base
	name = "[material.display_name] door"
	color = material.icon_colour

	maxhealth = max(1,round(material.integrity))
	health = maxhealth

	if(initial_lock_value)
		locked = initial_lock_value

	if(locked)
		lock = new(src,locked)

	if(material.opacity < 0.5)
		opacity = 0
	else
		opacity = 1
	if(material.products_need_process())
		START_PROCESSING(SSprocessing, src)
	update_nearby_tiles(need_rebuild=1)

/obj/structure/simple_door/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	update_nearby_tiles()
	qdel(lock)
	lock = null
	return ..()

/obj/structure/simple_door/CollidedWith(atom/bumped_atom)
	..()
	if(!state)
		return TryToSwitchState(bumped_atom)
	return

/obj/structure/simple_door/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user) && Adjacent(user)) //but cyborgs can
		return TryToSwitchState(user)

/obj/structure/simple_door/attack_hand(mob/user as mob)
	return TryToSwitchState(user)

/obj/structure/simple_door/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	if(istype(user, /mob/living/simple_animal/construct)) // don't know of any other attack_generic smart enough to open doors
		TryToSwitchState(user)
	return

/obj/structure/simple_door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group)
		return FALSE
	if(mover?.movement_type & PHASING)
		return TRUE
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/simple_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates) return
	if(ismob(user))
		var/mob/M = user
		if(!material.can_open_material_door(user))
			return
		if(world.time - user.last_bumped <= 60)
			return
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState(user)
			else if(istype(M, /mob/living/simple_animal/construct))
				SwitchState(M)

/obj/structure/simple_door/proc/SwitchState(mob/user)
	if(state)
		Close()
	else
		Open(user)

/obj/structure/simple_door/proc/Open(mob/user)

	if(lock && lock.isLocked())
		if(user)
			to_chat(user, SPAN_WARNING("\The [src] is locked!"))
		return

	isSwitchingStates = 1
	playsound(loc, material.dooropen_noise, 100, 1)
	flick("[material.door_icon_base]opening",src)
	addtimer(CALLBACK(src, PROC_REF(change_state_after_openclode), TRUE), 1 SECONDS)


/obj/structure/simple_door/proc/Close()
	isSwitchingStates = 1
	playsound(loc, material.dooropen_noise, 100, 1)
	flick("[material.door_icon_base]closing",src)
	addtimer(CALLBACK(src, PROC_REF(change_state_after_openclode), FALSE), 1 SECONDS)

/**
 * Complete the open/close of the door
 *
 * * to_open - Whether the door is to be set as open, if FALSE, it is to be set as closed instead
 */
/obj/structure/simple_door/proc/change_state_after_openclode(to_open = FALSE)
	if(to_open)
		density = 0
		opacity = 0
		state = 1
	else
		density = 1
		opacity = 1
		state = 0

	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/simple_door/update_icon()
	if(state)
		icon_state = "[material.door_icon_base]open"
	else
		icon_state = material.door_icon_base

/obj/structure/simple_door/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/key) && lock)
		var/obj/item/key/K = attacking_item
		if(!lock.toggle(attacking_item))
			to_chat(user, SPAN_WARNING("\The [K] does not fit in the lock!"))
		return

	if(lock && lock.pick_lock(attacking_item, user))
		return

	if(istype(attacking_item, /obj/item/material/lock_construct))
		if(lock)
			to_chat(user, SPAN_WARNING("\The [src] already has a lock."))
		else
			var/obj/item/material/lock_construct/L = attacking_item
			lock = L.create_lock(src,user)
		return

	else if(istype(attacking_item, /obj/item))
		var/obj/item/I = attacking_item
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(I.damtype == DAMAGE_BRUTE || I.damtype == DAMAGE_BURN)
			if(I.force < 10)
				user.visible_message(SPAN_DANGER("\The [user] hits \the [src] with \the [I] with no visible effect."))
			else
				user.do_attack_animation(src)
				shake_animation()
				user.visible_message(SPAN_DANGER("\The [user] forcefully strikes \the [src] with \the [I]!"))
				playsound(src.loc, material.hitsound, attacking_item.get_clamped_volume(), 1)
				src.health -= attacking_item.force * 1
				CheckHealth()

	else
		attack_hand(user)
	return

/obj/structure/simple_door/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	health -= hitting_projectile.damage
	bullet_ping(hitting_projectile)
	CheckHealth()

/obj/structure/simple_door/proc/CheckHealth()
	if(health <= 0)
		dismantle()

/obj/structure/simple_door/ex_act(severity = 1)
	switch(severity)
		if(1)
			dismantle()
		if(2)
			if(prob(20))
				dismantle()
			else
				health--
				CheckHealth()
		if(3)
			health -= 0.1
			CheckHealth()
	return

/obj/structure/simple_door/process()
	if(!material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_damage(round(material.radioactivity/3),DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

/obj/structure/simple_door/iron/New(var/newloc,var/material_name, var/complexity)
	..(newloc, MATERIAL_IRON, complexity)

/obj/structure/simple_door/silver/New(var/newloc,var/material_name, var/complexity)
	..(newloc, MATERIAL_SILVER, complexity)

/obj/structure/simple_door/gold/New(var/newloc,var/material_name, var/complexity)
	..(newloc, MATERIAL_GOLD, complexity)

/obj/structure/simple_door/uranium/New(var/newloc,var/material_name, var/complexity)
	..(newloc, MATERIAL_URANIUM, complexity)

/obj/structure/simple_door/sandstone/New(var/newloc,var/material_name, var/complexity)
	..(newloc, MATERIAL_SANDSTONE, complexity)

/obj/structure/simple_door/phoron/New(var/newloc,var/material_name, var/complexity)
	..(newloc, MATERIAL_PHORON, complexity)

/obj/structure/simple_door/diamond/New(var/newloc,var/material_name, var/complexity)
	..(newloc, MATERIAL_DIAMOND, complexity)

/obj/structure/simple_door/wood/New(var/newloc,var/material_name)
	..(newloc, MATERIAL_WOOD)

/obj/structure/simple_door/resin/New(var/newloc,var/material_name)
	..(newloc, MATERIAL_RESIN)

/obj/structure/simple_door/cult/New(var/newloc, var/material_name)
	..(newloc, MATERIAL_CULT)
	color = COLOR_CULT_DOOR // looks better than the standard cult colours
