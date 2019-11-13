/obj/structure/simple_door
	name = "door"
	density = 1
	anchored = 1

	icon = 'icons/obj/doors/material_doors.dmi'
	icon_state = "metal"

	var/material/material
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/oreAmount = 7
	var/datum/lock/lock
	var/initial_lock_value //for mapping purposes. Basically if this value is set, it sets the lock to this value.
	var/health = 100
	var/maxhealth = 100

/obj/structure/simple_door/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	TemperatureAct(exposed_temperature)

/obj/structure/simple_door/proc/TemperatureAct(temperature)
	health -= material.combustion_effect(get_turf(src),temperature, 0.3)
	CheckHealth()

/obj/structure/simple_door/New(var/newloc, var/material_name, var/locked)
	..()
	if(!material_name)
		material_name = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(material_name)
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

/obj/structure/simple_door/examine(mob/user)
	..(user)
	if(lock)
		to_chat(user, "<span class='notice'>It appears to have a lock.</span>")

/obj/structure/simple_door/get_material()
	return material

/obj/structure/simple_door/CollidedWith(atom/user)
	..()
	if(!state)
		return TryToSwitchState(user)
	return

/obj/structure/simple_door/attack_ai(mob/user as mob) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user,src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/simple_door/attack_hand(mob/user as mob)
	return TryToSwitchState(user)

/obj/structure/simple_door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 0
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
			else
				SwitchState(user)
	else if(istype(user, /obj/mecha))
		SwitchState()

/obj/structure/simple_door/proc/SwitchState(mob/user)
	if(state)
		Close()
	else
		Open(user)

/obj/structure/simple_door/proc/Open(mob/user)

	if(lock && lock.isLocked())
		if(user)
			to_chat(user, "<span class='warning'>\The [src] is locked!</span>")
		return

	isSwitchingStates = 1
	playsound(loc, material.dooropen_noise, 100, 1)
	flick("[material.door_icon_base]opening",src)
	sleep(10)
	density = 0
	opacity = 0
	state = 1
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/simple_door/proc/Close()
	isSwitchingStates = 1
	playsound(loc, material.dooropen_noise, 100, 1)
	flick("[material.door_icon_base]closing",src)
	sleep(10)
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

/obj/structure/simple_door/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/key) && lock)
		var/obj/item/key/K = W
		if(!lock.toggle(W))
			to_chat(user, "<span class='warning'>\The [K] does not fit in the lock!</span>")
		return

	if(lock && lock.pick_lock(W,user))
		return

	if(istype(W,/obj/item/material/lock_construct))
		if(lock)
			to_chat(user, "<span class='warning'>\The [src] already has a lock.</span>")
		else
			var/obj/item/material/lock_construct/L = W
			lock = L.create_lock(src,user)
		return

	else if(istype(W,/obj/item))
		var/obj/item/I = W
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(I.damtype == BRUTE || I.damtype == BURN)
			if(I.force < 10)
				user.visible_message("<span class='danger'>\The [user] hits \the [src] with \the [I] with no visible effect.</span>")
			else
				user.do_attack_animation(src)
				animate_shake()
				user.visible_message("<span class='danger'>\The [user] forcefully strikes \the [src] with \the [I]!</span>")
				playsound(src.loc, material.hitsound, 100, 1)
				src.health -= W.force * 1
				CheckHealth()

	else
		attack_hand(user)
	return

/obj/structure/simple_door/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	CheckHealth()
	return

/obj/structure/simple_door/proc/CheckHealth()
	if(health <= 0)
		Dismantle(1)

/obj/structure/simple_door/proc/Dismantle(devastated = 0)
	material.place_dismantled_product(get_turf(src))
	qdel(src)

/obj/structure/simple_door/ex_act(severity = 1)
	switch(severity)
		if(1)
			Dismantle(1)
		if(2)
			if(prob(20))
				Dismantle(1)
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
		L.apply_effect(round(material.radioactivity/3),IRRADIATE,0)

/obj/structure/simple_door/iron/New(var/newloc,var/material_name, var/complexity)
	..(newloc, "iron", complexity)

/obj/structure/simple_door/silver/New(var/newloc,var/material_name, var/complexity)
	..(newloc, "silver", complexity)

/obj/structure/simple_door/gold/New(var/newloc,var/material_name, var/complexity)
	..(newloc, "gold", complexity)

/obj/structure/simple_door/uranium/New(var/newloc,var/material_name, var/complexity)
	..(newloc, "uranium", complexity)

/obj/structure/simple_door/sandstone/New(var/newloc,var/material_name, var/complexity)
	..(newloc, "sandstone", complexity)

/obj/structure/simple_door/phoron/New(var/newloc,var/material_name, var/complexity)
	..(newloc, "phoron", complexity)

/obj/structure/simple_door/diamond/New(var/newloc,var/material_name, var/complexity)
	..(newloc, "diamond", complexity)

/obj/structure/simple_door/wood/New(var/newloc,var/material_name)
	..(newloc, "wood")

/obj/structure/simple_door/resin/New(var/newloc,var/material_name)
	..(newloc, "resin")
