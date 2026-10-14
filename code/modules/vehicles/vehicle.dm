//Dummy object for holding items in vehicles.
//Prevents items from being interacted with.
#define VEHICLE_REPAIR_NONE 0
#define VEHICLE_REPAIR_NEEDS_STEEL 1
#define VEHICLE_REPAIR_NEEDS_HAMMER 2
#define VEHICLE_REPAIR_NEEDS_WELDER 3
#define VEHICLE_REPAIR_STEEL_COST 2

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
	should_use_health = TRUE

	var/buckling_sound = 'sound/effects/metal_close.ogg'

	var/attack_log = null
	var/on = 0
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
	/// If TRUE, riders cannot mount while prone and are ejected if they become prone.
	var/eject_prone_riders = TRUE
	/// Tracks the steps needed to make a broken mechanical vehicle operational again.
	var/repair_stage = VEHICLE_REPAIR_NONE

	light_system = DIRECTIONAL_LIGHT

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/Initialize()
	. = ..()
	setup_vehicle()

/obj/vehicle/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/vehicle/proc/setup_vehicle()
	LAZYADD(can_buckle, /mob/living)

/obj/vehicle/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(!organic)
		. += "Repair ordinary damage with a lit welder while the maintenance panel is open."
		. += "A broken vehicle must first be fitted with [VEHICLE_REPAIR_STEEL_COST] steel sheets, then hammered into shape, and finally welded back together."

/obj/vehicle/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(!(stat & BROKEN))
		return
	switch(repair_stage)
		if(VEHICLE_REPAIR_NEEDS_STEEL)
			. += SPAN_DANGER("\The [src] is broken down. Its damaged frame needs new steel plating.")
		if(VEHICLE_REPAIR_NEEDS_HAMMER)
			. += SPAN_DANGER("\The [src] is broken down. Its new plating needs to be hammered into shape.")
		if(VEHICLE_REPAIR_NEEDS_WELDER)
			. += SPAN_DANGER("\The [src] is broken down. Its new plating needs to be welded in place.")

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
	if(handle_broken_repair(attacking_item, user))
		return
	if(istype(attacking_item, /obj/item/hand_labeler))
		return
	if(attacking_item.tool_behaviour == TOOL_SCREWDRIVER && !organic)
		if(!locked)
			open = !open
			update_icon()
			to_chat(user, SPAN_NOTICE("Maintenance panel is now [open ? "opened" : "closed"]."))
	else if(attacking_item.tool_behaviour == TOOL_CROWBAR && cell && open && !organic)
		remove_cell(user)

	else if(istype(attacking_item, /obj/item/cell) && !cell && open && !organic)
		insert_cell(attacking_item, user)
	else if(attacking_item.tool_behaviour == TOOL_WELDER && !organic)
		var/obj/item/weldingtool/T = attacking_item
		if(T.welding)
			if(health < maxhealth)
				if(open)
					add_health(10)
					user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
					user.visible_message(SPAN_WARNING("[user] repairs [src]!"),
											SPAN_NOTICE("<span class='notice'>You repair [src]!"))
				else
					to_chat(user, SPAN_NOTICE("Unable to repair with the maintenance panel closed."))
			else
				to_chat(user, SPAN_NOTICE("[src] does not need a repair."))
		else
			to_chat(user, SPAN_NOTICE("Unable to repair while [src] is off."))
	else if(hasvar(attacking_item,"force") && hasvar(attacking_item,"damtype"))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		switch(attacking_item.damtype)
			if(DAMAGE_BURN)
				add_damage(attacking_item.force * fire_dam_coeff)
			if(DAMAGE_BRUTE)
				add_damage(attacking_item.force * brute_dam_coeff)
		..()
	else
		..()

/obj/vehicle/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .
	add_damage(hitting_projectile.get_structure_damage())
	if (prob(20) && !organic)
		spark(src, 5, GLOB.alldirs)

/obj/vehicle/ex_act(severity)
	switch(severity)
		if(1.0)
			explode()
		if(2.0)
			add_damage(rand(5,10)*fire_dam_coeff)
			add_damage(rand(10,20)*brute_dam_coeff)
		if(3.0)
			if (prob(50))
				add_damage(rand(1,5)*fire_dam_coeff)
				add_damage(rand(1,5)*brute_dam_coeff)

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
	pulse2.set_dir(pick(GLOB.cardinals))

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
		return FALSE
	if(powered && cell?.charge < charge_use && !organic)
		return FALSE
	on = TRUE
	set_light_on(on)
	update_icon()
	return TRUE

/obj/vehicle/proc/turn_off()
	on = FALSE
	set_light_on(on)
	update_icon()

/obj/vehicle/emag_act(var/remaining_charges, mob/user as mob)
	if(organic)
		return FALSE
	if(!emagged)
		emagged = 1
		if(locked)
			locked = 0
			to_chat(user, SPAN_WARNING("You bypass \the [src]'s controls."))
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

/obj/vehicle/on_death(damage, damage_flags, damage_type, armor_penetration, obj/weapon)
	if(organic)
		explode()
		return
	if(stat & BROKEN)
		return
	stat |= BROKEN
	repair_stage = VEHICLE_REPAIR_NEEDS_STEEL
	turn_off()
	visible_message(SPAN_DANGER("\The [src] breaks down!"))
	if(ismob(load))
		unload(load)
	spark(src, 3, GLOB.alldirs)

/// Handles the staged repair process for a broken mechanical vehicle.
/obj/vehicle/proc/handle_broken_repair(obj/item/attacking_item, mob/user)
	if(!(stat & BROKEN) || organic)
		return FALSE

	var/obj/item/stack/material/repair_material
	if(istype(attacking_item, /obj/item/stack/material))
		var/obj/item/stack/material/candidate_material = attacking_item
		if(candidate_material.material?.type == MATERIAL_STEEL)
			repair_material = candidate_material

	var/is_hammer = attacking_item.tool_behaviour == TOOL_HAMMER && user.a_intent != I_HURT
	var/is_welder = attacking_item.tool_behaviour == TOOL_WELDER
	if(!repair_material && !is_hammer && !is_welder)
		return FALSE

	switch(repair_stage)
		if(VEHICLE_REPAIR_NEEDS_STEEL)
			if(!repair_material)
				to_chat(user, SPAN_WARNING("You need to fit steel sheets over \the [src]'s damaged frame first."))
				return TRUE
			if(repair_material.get_amount() < VEHICLE_REPAIR_STEEL_COST)
				to_chat(user, SPAN_WARNING("You need [VEHICLE_REPAIR_STEEL_COST] steel sheets to repair \the [src]."))
				return TRUE
			user.visible_message(SPAN_NOTICE("[user] begins fitting new plating to \the [src]."), SPAN_NOTICE("You begin fitting new plating to \the [src]."))
			if(do_after(user, 2 SECONDS, src) && (stat & BROKEN) && repair_stage == VEHICLE_REPAIR_NEEDS_STEEL && repair_material.use(VEHICLE_REPAIR_STEEL_COST))
				repair_stage = VEHICLE_REPAIR_NEEDS_HAMMER
				user.visible_message(SPAN_NOTICE("[user] fits new plating to \the [src]."), SPAN_NOTICE("You fit new plating to \the [src]. It needs to be hammered into shape."))
			return TRUE

		if(VEHICLE_REPAIR_NEEDS_HAMMER)
			if(!is_hammer)
				to_chat(user, SPAN_WARNING("\The [src]'s new plating needs to be hammered into shape."))
				return TRUE
			user.visible_message(SPAN_NOTICE("[user] begins hammering \the [src]'s new plating into shape."), SPAN_NOTICE("You begin hammering \the [src]'s new plating into shape."))
			if(attacking_item.use_tool(src, user, 2 SECONDS, volume = 50) && (stat & BROKEN) && repair_stage == VEHICLE_REPAIR_NEEDS_HAMMER)
				repair_stage = VEHICLE_REPAIR_NEEDS_WELDER
				user.visible_message(SPAN_NOTICE("[user] finishes shaping \the [src]'s new plating."), SPAN_NOTICE("You finish shaping \the [src]'s new plating. It needs to be welded in place."))
			return TRUE

		if(VEHICLE_REPAIR_NEEDS_WELDER)
			if(!is_welder)
				to_chat(user, SPAN_WARNING("\The [src]'s new plating needs to be welded in place."))
				return TRUE
			var/obj/item/weldingtool/welder = attacking_item
			if(!welder.welding)
				to_chat(user, SPAN_WARNING("You need to light \the [welder] first."))
				return TRUE
			user.visible_message(SPAN_NOTICE("[user] begins welding \the [src]'s new plating into place."), SPAN_NOTICE("You begin welding \the [src]'s new plating into place."))
			if(attacking_item.use_tool(src, user, 2 SECONDS, volume = 50) && (stat & BROKEN) && repair_stage == VEHICLE_REPAIR_NEEDS_WELDER)
				set_health(maxhealth * 0.25)
				stat &= ~BROKEN
				repair_stage = VEHICLE_REPAIR_NONE
				update_icon()
				user.visible_message(SPAN_NOTICE("[user] restores \the [src] to working order."), SPAN_NOTICE("You restore \the [src] to working order. It could still use further repairs."))
			return TRUE

	return FALSE

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
	to_chat(usr, SPAN_NOTICE("You install [C] in [src]."))

/obj/vehicle/proc/remove_cell(var/mob/living/carbon/human/H)
	if(!cell)
		return

	to_chat(usr, SPAN_NOTICE("You remove [cell] from [src]."))
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
/**
 * Loads an /atom onto the vehicle
 *
 * * thing_to_load - The thing to load, an `/obj` or `/mob`
 *
 * Returns `TRUE` if the load was successful, `FALSE` otherwise
 */
/obj/vehicle/proc/load(var/atom/movable/thing_to_load)
	//This loads objects onto the vehicle so they can still be interacted with.
	//Define allowed items for loading in specific vehicle definitions.
	if(!isturf(thing_to_load.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return FALSE
	if(load || thing_to_load.anchored)
		return FALSE
	if(eject_prone_riders && isliving(thing_to_load))
		var/mob/living/rider = thing_to_load
		if(rider.lying)
			return FALSE

	// if a crate/closet, close before loading
	var/obj/structure/closet/closet = thing_to_load
	if(istype(closet))
		closet.close()

	thing_to_load.forceMove(loc)
	thing_to_load.set_dir(dir)
	thing_to_load.anchored = TRUE

	load = thing_to_load

	thing_to_load.layer = VEHICLE_LOAD_LAYER
	if(load_item_visible)
		thing_to_load.pixel_x += load_offset_x
		if(ismob(thing_to_load))
			thing_to_load.pixel_y += mob_offset_y
		else
			if(istype(thing_to_load, /obj/structure/closet/crate))
				thing_to_load.pixel_y += load_offset_y
			else
				thing_to_load.pixel_y += 10

	if(ismob(thing_to_load))
		buckle(thing_to_load, thing_to_load)
		if(eject_prone_riders)
			RegisterSignal(thing_to_load, COMSIG_MOB_LYING_DOWN, PROC_REF(eject_lying_rider))

	return TRUE

/// Ejects a rider when something causes them to fall prone.
/obj/vehicle/proc/eject_lying_rider(mob/living/rider)
	SIGNAL_HANDLER
	if(rider != load)
		return
	rider.visible_message(SPAN_WARNING("\The [rider] falls off \the [src]!"), SPAN_WARNING("You fall off \the [src]!"))
	unload(rider)

/obj/vehicle/buckle(atom/movable/buckling_atom, mob/user)
	. = ..()
	if(. && buckling_sound)
		playsound(src, buckling_sound, 20)

/obj/vehicle/user_unbuckle(mob/user)
	..()
	unload(user)
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

	if(eject_prone_riders && ismob(load))
		UnregisterSignal(load, COMSIG_MOB_LYING_DOWN)
	load.forceMove(dest)
	load.set_dir(get_dir(loc, dest))
	load.anchored = 0		//we can only load non-anchored items, so it makes sense to set this to false
	load.pixel_x = initial(load.pixel_x)
	load.pixel_y = initial(load.pixel_y)
	load.layer = initial(load.layer)

	if(ismob(load))
		unbuckle(user)
		if(ishuman(load))
			var/mob/living/carbon/human/H = load
			H.update_body()

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

/obj/vehicle/attack_generic(mob/user, damage, attack_message, environment_smash, armor_penetration, attack_flags, damage_type)
	if(!damage)
		return
	visible_message(SPAN_DANGER("[user] [attack_message] the [src]!"))
	user.attack_log += "\[[time_stamp()]\] <span class='warning'>attacked [src.name]</span>"
	user.do_attack_animation(src)
	add_damage(damage)
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(src.loc)
	return TRUE

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

#undef VEHICLE_REPAIR_NONE
#undef VEHICLE_REPAIR_NEEDS_STEEL
#undef VEHICLE_REPAIR_NEEDS_HAMMER
#undef VEHICLE_REPAIR_NEEDS_WELDER
#undef VEHICLE_REPAIR_STEEL_COST
