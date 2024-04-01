//Dummy object for holding items in vehicles.
//Prevents items from being interacted with.
/datum/vehicle_dummy_load
	var/name = "dummy load"
	var/actual_load

/obj/vehicle
	name = "vehicle"
	icon = 'icons/obj/vehicles.dmi'
	layer = MECH_BASE_LAYER
	density = 1
	anchored = 1
	animate_movement=1
	light_range = 3

	buckle_movable = 1
	buckle_lying = 0

	var/buckling_sound = 'sound/effects/metal_close.ogg'

	var/attack_log = null
	var/on = 0
	var/health = 0	//do not forget to set health for your vehicle!
	var/maxhealth = 0
	var/fire_dam_coeff = 1.0
	var/brute_dam_coeff = 1.0
	var/open = 0	//Maint panel
	var/locked = 1
	var/stat = 0
	var/emagged = 0
	var/powered = 0		//set if vehicle is powered and should use fuel when moving
	var/move_delay = 1	//set this to limit the speed of the vehicle

	var/obj/item/cell/cell
	var/charge_use = 5	//set this to adjust the amount of power the vehicle uses per move

	var/atom/movable/load		//all vehicles can take a load, since they should all be a least drivable
	var/load_item_visible = 1	//set if the loaded item should be overlayed on the vehicle sprite
	var/load_offset_x = 0		//pixel_x offset for item overlay
	var/load_offset_y = 0		//pixel_y offset for item overlay
	var/mob_offset_y = 0		//pixel_y offset for mob overlay
	var/flying = FALSE
	var/organic = FALSE
	var/corpse = null

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/Initialize()
	. = ..()
	setup_vehicle()

/obj/vehicle/proc/setup_vehicle()
	LAZYADD(can_buckle, /mob/living)

/obj/vehicle/Move()
	if(world.time > l_move_time + move_delay)
		var/old_loc = get_turf(src)
		if(on && powered && cell.charge < charge_use  && !organic)
			turn_off()

		var/init_anc = anchored
		anchored = 0
		if(!..())
			anchored = init_anc
			return 0

		set_dir(get_dir(old_loc, loc))
		anchored = init_anc

		if(on && powered && !organic)
			cell.use(charge_use)

		//Dummy loads do not have to be moved as they are just an overlay
		//See load_object() proc in cargo_trains.dm for an example
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc)
			load.set_dir(dir)

		return 1
	else
		return 0

/obj/vehicle/proc/create_vehicle_overlay()
	return

/obj/vehicle/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/device/hand_labeler))
		return
	if(attacking_item.isscrewdriver() && !organic)
		if(!locked)
			open = !open
			update_icon()
			to_chat(user, "<span class='notice'>Maintenance panel is now [open ? "opened" : "closed"].</span>")
	else if(attacking_item.iscrowbar() && cell && open && !organic)
		remove_cell(user)

	else if(istype(attacking_item, /obj/item/cell) && !cell && open && !organic)
		insert_cell(attacking_item, user)
	else if(attacking_item.iswelder() && !organic)
		var/obj/item/weldingtool/T = attacking_item
		if(T.welding)
			if(health < maxhealth)
				if(open)
					health = min(maxhealth, health+10)
					user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
					user.visible_message("<span class='warning'>[user] repairs [src]!</span>","<span class='notice'>You repair [src]!</span>")
				else
					to_chat(user, "<span class='notice'>Unable to repair with the maintenance panel closed.</span>")
			else
				to_chat(user, "<span class='notice'>[src] does not need a repair.</span>")
		else
			to_chat(user, "<span class='notice'>Unable to repair while [src] is off.</span>")
	else if(hasvar(attacking_item,"force") && hasvar(attacking_item,"damtype"))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(attacking_item.damtype)
			if("fire")
				health -= attacking_item.force * fire_dam_coeff
			if("brute")
				health -= attacking_item.force * brute_dam_coeff
		..()
		healthcheck()
	else
		..()

/obj/vehicle/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	..()

	if (prob(20) && !organic)
		spark(src, 5, GLOB.alldirs)

	healthcheck()

/obj/vehicle/ex_act(severity)
	switch(severity)
		if(1.0)
			explode()
			return
		if(2.0)
			health -= rand(5,10)*fire_dam_coeff
			health -= rand(10,20)*brute_dam_coeff
			healthcheck()
			return
		if(3.0)
			if (prob(50))
				health -= rand(1,5)*fire_dam_coeff
				health -= rand(1,5)*brute_dam_coeff
				healthcheck()
				return
	return

/obj/vehicle/emp_act(severity)
	. = ..()

	if(organic)
		return

	var/was_on = on
	stat |= EMPED
	var/obj/effect/overlay/pulse2 = new /obj/effect/overlay(src.loc)
	pulse2.icon = 'icons/effects/effects.dmi'
	pulse2.icon_state = "empdisable"
	pulse2.name = "emp sparks"
	pulse2.anchored = 1
	pulse2.set_dir(pick(GLOB.cardinal))

	QDEL_IN(pulse2, 10)
	if(on)
		turn_off()

	addtimer(CALLBACK(src, PROC_REF(post_emp), was_on), severity * 300)

/obj/vehicle/proc/post_emp(was_on)
	if(organic)
		return
	stat &= ~EMPED
	if(was_on)
		turn_on()

/obj/vehicle/attack_ai(mob/user as mob)
	return

// For downstream compatibility (in particular Paradise)
/obj/vehicle/proc/handle_rotation()
	return

//-------------------------------------------
// Vehicle procs
//-------------------------------------------
/obj/vehicle/proc/turn_on()
	if(stat)
		return 0
	if(powered && cell.charge < charge_use && !organic)
		return 0
	on = 1
	set_light(initial(light_range))
	update_icon()
	return 1

/obj/vehicle/proc/turn_off()
	on = 0
	set_light(0)
	update_icon()

/obj/vehicle/emag_act(var/remaining_charges, mob/user as mob)
	if(organic)
		return FALSE
	if(!emagged)
		emagged = 1
		if(locked)
			locked = 0
			to_chat(user, "<span class='warning'>You bypass \the [src]'s controls.</span>")
		return 1

/obj/vehicle/proc/explode()
	var/turf/Tsec = get_turf(src)
	if(organic)
		visible_message(SPAN_WARNING("\The [src] dies!"))
		var/body = new corpse(Tsec)
		if(isliving(body))
			var/mob/living/M = body
			M.death()
	else
		visible_message(SPAN_WARNING("\The [src] blows apart!"))

		new /obj/item/stack/rods(Tsec)
		new /obj/item/stack/rods(Tsec)
		new /obj/item/stack/cable_coil/cut(Tsec)

		if(cell)
			cell.forceMove(Tsec)
			cell.update_icon()
			cell = null

		//stuns people who are thrown off a train that has been blown up


		new /obj/effect/gibspawner/robot(Tsec)
		new /obj/effect/decal/cleanable/blood/oil(src.loc)

	if(istype(load, /mob/living))
		var/mob/living/M = load
		M.apply_effects(5, 5)
	unload()
	qdel(src)

/obj/vehicle/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/vehicle/proc/powercheck()
	if(!cell && !powered)
		return

	if(!cell && powered)
		turn_off()
		return

	if(cell.charge < charge_use)
		turn_off()
		return

	if(cell && powered)
		turn_on()
		return

/obj/vehicle/proc/insert_cell(var/obj/item/cell/C, var/mob/living/carbon/human/H)
	if(cell)
		return
	if(!istype(C))
		return

	H.drop_from_inventory(C,src)
	cell = C
	powercheck()
	to_chat(usr, "<span class='notice'>You install [C] in [src].</span>")

/obj/vehicle/proc/remove_cell(var/mob/living/carbon/human/H)
	if(!cell)
		return

	to_chat(usr, "<span class='notice'>You remove [cell] from [src].</span>")
	cell.forceMove(get_turf(H))
	H.put_in_hands(cell)
	cell = null
	powercheck()

/obj/vehicle/proc/RunOver(var/mob/living/carbon/human/H)
	return		//write specifics for different vehicles

//-------------------------------------------
// Loading/unloading procs
//
// Set specific item restriction checks in
// the vehicle load() definition before
// calling this parent proc.
//-------------------------------------------
/obj/vehicle/proc/load(var/atom/movable/C)
	//This loads objects onto the vehicle so they can still be interacted with.
	//Define allowed items for loading in specific vehicle definitions.
	if(!isturf(C.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(load || C.anchored)
		return 0

	// if a crate/closet, close before loading
	var/obj/structure/closet/closet = C
	if(istype(closet))
		closet.close()

	C.forceMove(loc)
	C.set_dir(dir)
	C.anchored = 1

	load = C

	C.layer = VEHICLE_LOAD_LAYER
	if(load_item_visible)
		C.pixel_x += load_offset_x
		if(ismob(C))
			C.pixel_y += mob_offset_y
		else
			if(istype(C, /obj/structure/closet/crate))
				C.pixel_y += load_offset_y
			else
				C.pixel_y += 10

	if(ismob(C))
		buckle(C, C)

	return 1

/obj/vehicle/buckle(var/atom/movable/C, mob/user)
	. = ..()
	if(. && buckling_sound)
		playsound(src, buckling_sound, 20)

/obj/vehicle/user_unbuckle(var/mob/user, var/direction)
	..()
	unload(user, direction)
	return

/obj/vehicle/proc/unload(var/mob/user, var/direction)
	if(!load)
		return

	var/turf/dest = null
	var/turf/v_turf = get_turf(src)

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == v_turf || dest.is_hole)
		var/list/options = new()
		var/list/safe_options = new()
		for(var/test_dir in GLOB.alldirs)
			var/turf/T = get_step_to(src, get_step(src, test_dir))
			if(istype(T) && load.Adjacent(T))
				options += T
				if(!T.is_hole)
					safe_options += T
		if(safe_options.len)
			dest = pick(safe_options)
		else if(!v_turf.is_hole)
			dest = v_turf
		else if(options.len) // No safe tiles to unload -- you're going to the shadow realm, jimbo
			dest = pick(options)

	if(!isturf(dest))
		dest = v_turf	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	load.forceMove(dest)
	load.set_dir(get_dir(loc, dest))
	load.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
	load.pixel_x = initial(load.pixel_x)
	load.pixel_y = initial(load.pixel_y)
	load.layer = initial(load.layer)

	if(ismob(load))
		unbuckle(user)

	load = null

	return 1

// This exists to stop a weird jumping motion when you disembark.
// It essentially makes disembarkation count as a movement.
// Yes, it's not the full calculation. But it's relatively close, and will make it seamless.
/obj/vehicle/post_buckle(var/mob/M)
	if (M.client)
		M.client.move_delay = M.movement_delay() + GLOB.config.walk_speed

//-------------------------------------------------------
// Stat update procs
//-------------------------------------------------------
/obj/vehicle/proc/update_stats()
	return

/obj/vehicle/attack_generic(var/mob/user, var/damage, var/attack_message)
	if(!damage)
		return
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	user.attack_log += text("\[[time_stamp()]\] <span class='warning'>attacked [src.name]</span>")
	user.do_attack_animation(src)
	src.health -= damage
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	spawn(1) healthcheck()
	return 1

/obj/vehicle/can_fall(turf/below, turf/simulated/open/dest = src.loc)
	if (flying)
		return FALSE

	if (LAZYLEN(dest.climbers) && (src in dest.climbers))
		return FALSE

	if (!dest.is_hole)
		return FALSE

	// See if something prevents us from falling.
	for(var/atom/A in below)
		if(!A.CanPass(src, dest))
			return FALSE

	return TRUE
