//Dummy object for holding items in vehicles.
//Prevents items from being interacted with.
/datum/vehicle_dummy_load
	var/name = "dummy load"
	var/actual_load

/obj/vehicle
	name = "vehicle"
	icon = 'icons/obj/vehicles.dmi'
	layer = MOB_LAYER + 0.1 //so it sits above objects including mobs
	density = 1
	anchored = 1
	animate_movement=1
	light_range = 3

	can_buckle = 1
	buckle_movable = 1
	buckle_lying = 0

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

	var/obj/item/weapon/cell/cell
	var/charge_use = 5	//set this to adjust the amount of power the vehicle uses per move
	var/mechanical = TRUE // If false, doesn't care for things like cells, engines, EMP, keys, etc.

	var/atom/movable/load		//all vehicles can take a load, since they should all be a least drivable
	var/load_item_visible = 1	//set if the loaded item should be overlayed on the vehicle sprite
	var/load_offset_x = 0		//pixel_x offset for item overlay
	var/load_offset_y = 0		//pixel_y offset for item overlay
	var/mob_offset_y = 0		//pixel_y offset for mob overlay
	var/datum/riding/riding_datum = null

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/New()
	..()
	//spawn the cell you want in each vehicle

/obj/vehicle/Destroy()
	qdel(riding_datum)
	return ..()

//BUCKLE HOOKS

/obj/vehicle/buckle_mob(mob/living/M, forced = FALSE, check_loc = TRUE)
	. = ..()
	M.update_water()
	if(riding_datum)
		riding_datum.ridden = src
		riding_datum.handle_vehicle_offsets()

/obj/vehicle/unbuckle_mob(mob/living/buckled_mob, force = FALSE)
	. = ..(buckled_mob, force)
	buckled_mob.update_water()
	if(riding_datum)
		riding_datum.restore_position(buckled_mob)
		riding_datum.handle_vehicle_offsets() // So the person in back goes to the front.

/obj/vehicle/set_dir(newdir)
	..(newdir)
	if(riding_datum)
		riding_datum.handle_vehicle_offsets()

//MOVEMENT
/obj/vehicle/relaymove(mob/user, direction)
	if(riding_datum)
		riding_datum.handle_ride(user, direction)


/obj/vehicle/Moved()
	. = ..()
	if(riding_datum)
		riding_datum.handle_vehicle_layer()
		riding_datum.handle_vehicle_offsets()


/obj/vehicle/Move()
	if(world.time > l_move_time + move_delay)
		var/old_loc = get_turf(src)
		if(mechanical && on && powered && cell.charge < charge_use)
			turn_off()

		var/init_anc = anchored
		anchored = 0
		if(!..())
			anchored = init_anc
			return 0

		set_dir(get_dir(old_loc, loc))
		anchored = init_anc

		if(mechanical && on && powered)
			cell.use(charge_use)

		//Dummy loads do not have to be moved as they are just an overlay
		//See load_object() proc in cargo_trains.dm for an example
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc)
			load.set_dir(dir)

		return 1
	else
		return 0

/obj/vehicle/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/hand_labeler))
		return
	if(mechanical)
		if(istype(W, /obj/item/weapon/screwdriver))
			if(!locked)
				open = !open
				update_icon()
				user << "<span class='notice'>Maintenance panel is now [open ? "opened" : "closed"].</span>"
		else if(istype(W, /obj/item/weapon/crowbar) && cell && open)
			remove_cell(user)

		else if(istype(W, /obj/item/weapon/cell) && !cell && open)
			insert_cell(W, user)
		else if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/T = W
			if(T.welding)
				if(health < maxhealth)
					if(open)
						health = min(maxhealth, health+10)
						user.visible_message("<font color='red'>[user] repairs [src]!</font>","<font color='blue'> You repair [src]!</font>")
					else
						to_chat(user, "<span class='notice'>Unable to repair with the maintenance panel closed.</span>")
			else
				to_chat(user, "<span class='notice'>[src] does not need a repair.</span>")
		else
			to_chat(user,"<span class='notice'>Unable to repair while [src] is off.</span>")

	else if(hasvar(W,"force") && hasvar(W,"damtype"))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(W.damtype)
			if("fire")
				health -= W.force * fire_dam_coeff
			if("brute")
				health -= W.force * brute_dam_coeff
		..()
		healthcheck()
	else
		..()

/obj/vehicle/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	..()

	if (prob(20))
		spark(src, 5, alldirs)

	healthcheck()

/obj/vehicle/ex_act(severity)
	if(!mechanical)
		return

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
	var/was_on = on
	stat |= EMPED
	var/obj/effect/overlay/pulse2 = new /obj/effect/overlay(src.loc)
	pulse2.icon = 'icons/effects/effects.dmi'
	pulse2.icon_state = "empdisable"
	pulse2.name = "emp sparks"
	pulse2.anchored = 1
	pulse2.set_dir(pick(cardinal))

	QDEL_IN(pulse2, 10)
	if(on)
		turn_off()

	addtimer(CALLBACK(src, .proc/post_emp, was_on), severity * 300)

/obj/vehicle/proc/post_emp(was_on)
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
	if(!mechanical || stat)
		return FALSE
	if(powered && cell.charge < charge_use)
		return FALSE
	on = 1
	set_light(initial(light_range))
	update_icon()
	return TRUE

/obj/vehicle/proc/turn_off()
	if(!mechanical)
		return FALSE
	on = 0
	set_light(0)
	update_icon()

/obj/vehicle/emag_act(var/remaining_charges, mob/user as mob)
	if(!mechanical)
		return FALSE

	if(!emagged)
		emagged = 1
		if(locked)
			locked = 0
			to_chat(user, "<span class='warning'>You bypass [src]'s controls.</span>")
		return TRUE

/obj/vehicle/proc/explode()
	src.visible_message("<font color='red'><B>[src] blows apart!</B></font>", 1)
	var/turf/Tsec = get_turf(src)

	//stuns people who are thrown off a train that has been blown up
	if(istype(load, /mob/living))
		var/mob/living/M = load
		M.apply_effects(5, 5)

	unload()

	if(mechanical)
		new /obj/item/stack/rods(Tsec)
		new /obj/item/stack/rods(Tsec)
		new /obj/item/stack/cable_coil/cut(Tsec)
		new /obj/effect/gibspawner/robot(Tsec)
		new /obj/effect/decal/cleanable/blood/oil(src.loc)

		if(cell)
			cell.forceMove(Tsec)
			cell.update_icon()
			cell = null

	qdel(src)
/obj/vehicle/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/vehicle/proc/powercheck()
	if(!mechanical)
		return
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

/obj/vehicle/proc/insert_cell(var/obj/item/weapon/cell/C, var/mob/living/carbon/human/H)
	if(!mechanical)
		return
	if(cell)
		return
	if(!istype(C))
		return

	H.drop_from_inventory(C,src)
	cell = C
	powercheck()
	to_chat(usr, "<span class='notice'>You install [C] in [src].</span>")

/obj/vehicle/proc/remove_cell(var/mob/living/carbon/human/H)
	if(mechanical)
		return
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
/obj/vehicle/proc/load(var/atom/movable/C, var/mob/living/user)
	//This loads objects onto the vehicle so they can still be interacted with.
	//Define allowed items for loading in specific vehicle definitions.
	if(!isturf(C.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(load || C.anchored)
		return 0

	// if a create/closet, close before loading
	var/obj/structure/closet/crate = C
	if(istype(crate))
		crate.close()

	C.forceMove(loc)
	C.set_dir(dir)
	C.anchored = 1

	load = C

	if(load_item_visible)
		C.pixel_x += load_offset_x
		if(ismob(C))
			C.pixel_y += mob_offset_y
		else
			C.pixel_y += load_offset_y
		C.layer = layer + 0.1

	if(ismob(C))
		user_buckle_mob(C, user)

	return 1

/obj/vehicle/user_unbuckle_mob(var/mob/user)
	unload(user)
	return

/obj/vehicle/proc/unload(var/mob/user, var/direction)
	if(!load)
		return

	var/turf/dest = null

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			if(new_dir && load.Adjacent(new_dir))
				options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	load.forceMove(dest)
	load.set_dir(get_dir(loc, dest))
	load.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
	load.pixel_x = initial(load.pixel_x)
	load.pixel_y = initial(load.pixel_y)
	load.layer = initial(load.layer)

	if(ismob(load))
		unbuckle_mob(load)

	load = null

	return 1

// This exists to stop a weird jumping motion when you disembark.
// It essentially makes disembarkation count as a movement.
// Yes, it's not the full calculation. But it's relatively close, and will make it seamless.
/obj/vehicle/post_buckle_mob(var/mob/M)
	if (M.client)
		M.client.move_delay = M.movement_delay() + config.walk_speed

//-------------------------------------------------------
// Stat update procs
//-------------------------------------------------------
/obj/vehicle/proc/update_stats()
	return

/obj/vehicle/attack_generic(var/mob/user, var/damage, var/attack_message)
	if(!damage)
		return
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>")
	user.do_attack_animation(src)
	src.health -= damage
	if(mechanical && prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	spawn(1) healthcheck()
	return 1
