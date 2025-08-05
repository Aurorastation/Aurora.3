/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	icon = 'icons/turf/smooth/wall_preview.dmi'
	icon_state = "wall"
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	pass_flags_self = PASSCLOSEDTURF
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	canSmoothWith = list(
		/turf/simulated/wall,
		/turf/simulated/wall/r_wall,
		/turf/simulated/wall/shuttle/scc_space_ship,
		/turf/unsimulated/wall/steel, // Centcomm wall.
		/turf/unsimulated/wall/darkshuttlewall, // Centcomm wall.
		/turf/unsimulated/wall/riveted, // Centcomm wall.
		/obj/structure/window_frame,
		/obj/structure/window_frame/unanchored,
		/obj/structure/window_frame/empty,
		/obj/machinery/door,
		/obj/machinery/door/airlock
	)

	explosion_resistance = 10

	var/damage = 0
	var/damage_overlay = 0
	var/global/damage_overlays[16]
	var/active
	var/can_open = 0
	var/material/material
	var/material/reinf_material
	var/last_state
	var/construction_stage
	var/hitsound = 'sound/weapons/Genhit.ogg'
	var/use_set_icon_state

	var/under_turf = /turf/simulated/floor/plating

	var/tmp/list/image/reinforcement_images
	var/tmp/image/damage_image
	var/tmp/image/fake_wall_image
	var/tmp/cached_adjacency

	/// A lazylist of humans leaning on this wall.
	var/list/hiding_humans

	smoothing_flags = SMOOTH_MORE | SMOOTH_NO_CLEAR_ICON | SMOOTH_UNDERLAYS

	pathing_pass_method = TURF_PATHING_PASS_NO //Literally a wall, until we implement bots that can wallwarp, we might aswell save the processing


/turf/simulated/wall/condition_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(!damage)
		. += SPAN_NOTICE("It looks fully intact.")
	else
		// Total damage is based of base material integrity and optionally, if reinforced, reinforcement material integrity on top
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity

		var/relative_damage = damage / integrity

		if(relative_damage <= 0.25)
			. += SPAN_NOTICE("It looks slightly damaged.")
		else if(relative_damage <= 0.5)
			. += SPAN_WARNING("It looks damaged.")
		else if(relative_damage <= 0.75)
			. += SPAN_WARNING("It looks moderately damaged.")
		else if(relative_damage <= 0.9)
			. += SPAN_DANGER("It looks heavily damaged.")
		else
			. += SPAN_DANGER("It looks critically damaged and on the verge of structural collapse.")

/turf/simulated/wall/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(locate(/obj/effect/overlay/wallrot) in src)
		. += "Wall rot fungus makes walls highly susceptible to damage- pushing on it now might make it break apart."
		. += "It can be removed cleanly with a welding tool, or scraped off for processing with a bladed item like wirecutters."

/turf/simulated/wall/assembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can build a wall by using metal sheets and making a girder, then adding more material."

/turf/simulated/wall/disassembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Plating can be removed from a wall by use of a <b>welder</b>."

/turf/simulated/wall/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(locate(/obj/effect/overlay/wallrot) in src)
		. += SPAN_WARNING("There is fungus growing on [src].")

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate(mapload)
	if (mapload)
		return 		// Don't hide stuff during mapload.
	for(var/obj/O in src)
		O.hide(1)

/turf/simulated/wall/Initialize(mapload, var/materialtype, var/rmaterialtype)
	. = ..()
	if(!use_set_icon_state)
		icon_state = "blank"
	if(!materialtype)
		materialtype = DEFAULT_WALL_MATERIAL
	material = SSmaterials.get_material_by_name(materialtype)
	if(!isnull(rmaterialtype))
		reinf_material = SSmaterials.get_material_by_name(rmaterialtype)
	update_material()
	hitsound = material.hitsound

	if (material.radioactivity || (reinf_material && reinf_material.radioactivity))
		START_PROCESSING(SSprocessing, src)

/turf/simulated/wall/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	dismantle_wall(null, null, TRUE, TRUE)
	LAZYNULL(hiding_humans)
	return ..()

/turf/simulated/wall/process()
	// Calling parent will kill processing
	if(!radiate())
		STOP_PROCESSING(SSprocessing, src)

/turf/simulated/wall/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!opacity && istype(mover) && mover.pass_flags & PASSGLASS)
		return TRUE
	return ..()

/turf/simulated/wall/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	if(istype(hitting_projectile,/obj/projectile/beam))
		burn(2500)
	else if(istype(hitting_projectile,/obj/projectile/ion))
		burn(500)

	bullet_ping(hitting_projectile)
	create_bullethole(hitting_projectile)

	var/proj_damage = hitting_projectile.get_structure_damage()
	var/damage = proj_damage

	//cap the amount of damage, so that things like emitters can't destroy walls in one hit.
	if(hitting_projectile.anti_materiel_potential > 1)
		damage = min(proj_damage, 100)

	take_damage(damage)

/turf/simulated/wall/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	..()
	if(isliving(hitting_atom))
		var/mob/living/M = hitting_atom
		M.turf_collision(src, throwingdatum.speed)
		return

	if(isobj(hitting_atom))
		var/obj/O = hitting_atom
		var/tforce = O.throwforce * (throwingdatum.speed/THROWFORCE_SPEED_DIVISOR)
		playsound(src, hitsound, tforce >= 15? 60 : 25, TRUE)
		if(tforce >= 15)
			take_damage(tforce)

/turf/simulated/wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		qdel(WR)
	for(var/obj/effect/plant/plant in range(src, 1))
		if(!plant.floor) //shrooms drop to the floor
			plant.floor = 1
			plant.update_icon()
			plant.pixel_x = 0
			plant.pixel_y = 0
		INVOKE_ASYNC(src, TYPE_PROC_REF(/obj/effect/plant, update_neighbors))

/turf/simulated/wall/ChangeTurf(path, tell_universe = TRUE, force_lighting_update = FALSE, ignore_override = FALSE, mapload = FALSE)
	SEND_SIGNAL(src, COMSIG_ATOM_DECONSTRUCTED)
	clear_plants()
	clear_bulletholes()
	return ..()

//Damage

/turf/simulated/wall/melt(var/do_message = TRUE)
	if(!can_melt())
		return

	new /obj/effect/overlay/burnt_wall(get_turf(src), name, material, reinf_material)
	src.ChangeTurf(under_turf)

	if(do_message)
		visible_message(SPAN_DANGER("\The [src] spontaneously combusts!")) //!!OH SHIT!!

/turf/simulated/wall/proc/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()
	return

/turf/simulated/wall/proc/update_damage()
	var/cap = material.integrity
	if(reinf_material)
		cap += reinf_material.integrity

	if(locate(/obj/effect/overlay/wallrot) in src)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()
	else
		update_icon()

	return

/turf/simulated/wall/fire_act(exposed_temperature, exposed_volume) //Doesn't fucking work because walls don't interact with air :[
	. = ..()
	burn(exposed_temperature)

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	if(adj_temp > material.melting_point)
		take_damage(log(RAND_F(0.9, 1.1) * (adj_temp - material.melting_point)))

	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated, var/explode, var/no_product, var/no_change = FALSE)
	if (!no_change)	// No change is TRUE when this is called by destroy.
		playsound(src, 'sound/items/Welder.ogg', 100, 1)

	if(!no_product)
		if(reinf_material)
			reinf_material.place_dismantled_girder(src, reinf_material)
		else
			material.place_dismantled_girder(src)
		material.place_dismantled_product(src,devastated)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.forceMove(src)

	INVOKE_ASYNC(src, PROC_REF(clear_plants))
	clear_bulletholes()
	material = SSmaterials.get_material_by_name("placeholder")
	reinf_material = null

	if (!no_change)
		ChangeTurf(under_turf)

/turf/simulated/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			src.ChangeTurf(baseturf)
			return
		if(2.0)
			if(prob(75))
				take_damage(rand(150, 250))
			else
				dismantle_wall(1,1)
		if(3.0)
			take_damage(rand(0, 250))

	return

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(locate(/obj/effect/overlay/wallrot) in src)
		return
	var/number_rots = rand(2,3)
	for(var/i=0, i<number_rots, i++)
		new/obj/effect/overlay/wallrot(src)

/turf/simulated/wall/proc/can_melt()
	if(material.flags & MATERIAL_UNMELTABLE)
		return 0
	return 1

/turf/simulated/wall/proc/thermitemelt(mob/user)
	if(!can_melt())
		return

	var/obj/effect/overlay/thermite/O = new /obj/effect/overlay/thermite(src)
	to_chat(user, SPAN_WARNING("The thermite starts melting through the wall."))

	QDEL_IN(O, 100)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, melt), FALSE), 100)

/turf/simulated/wall/proc/radiate()
	var/total_radiation = material.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0)
	if(!total_radiation)
		return

	SSradiation.radiate(src, total_radiation)
	return total_radiation

/turf/simulated/wall/proc/burn(temperature)
	if(material.combustion_effect(src, temperature, 0.7))
		spawn(2)
			new /obj/structure/girder(src)
			src.ChangeTurf(/turf/simulated/floor)
			for(var/turf/simulated/wall/W in range(3,src))
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
				D.ignite(temperature/4)

/turf/simulated/wall/is_wall()
	return TRUE

/turf/simulated/wall/mouse_drop_receive(atom/dropped, mob/user, params)
	if(!ismob(dropped))
		return

	var/mob/living/carbon/human/current_mob = dropped

	// wall leaning by androbetel
	if(!ishuman(current_mob))
		return

	if(current_mob != user)
		return

	var/mob/living/carbon/hiding_human = current_mob
	var/can_lean = TRUE

	if(istype(user.l_hand, /obj/item/grab) || istype(user.r_hand, /obj/item/grab))
		to_chat(user, SPAN_WARNING("You can't lean while grabbing someone!"))
		can_lean = FALSE
	if(current_mob.incapacitated())
		to_chat(user, SPAN_WARNING("You can't lean while incapacitated!"))
		can_lean = FALSE
	if(current_mob.resting)
		to_chat(user, SPAN_WARNING("You can't lean while resting!"))
		can_lean = FALSE
	if(current_mob.buckled_to)
		to_chat(user, SPAN_WARNING("You can't lean while buckled!"))
		can_lean = FALSE

	var/direction = get_dir(src, current_mob)
	var/shift_pixel_x = 0
	var/shift_pixel_y = 0

	if(!can_lean)
		return
	switch(direction)
		if(NORTH)
			shift_pixel_y = -10
		if(SOUTH)
			shift_pixel_y = 16
		if(WEST)
			shift_pixel_x = 10
		if(EAST)
			shift_pixel_x = -10
		else
			return

	for(var/mob/living/carbon/human/hiding in hiding_humans)
		if(hiding_humans[hiding] == direction)
			return

	LAZYADD(hiding_humans, current_mob)
	hiding_humans[current_mob] = direction
	hiding_human.Moved() //just to be safe
	hiding_human.set_dir(direction)
	animate(hiding_human, pixel_x = shift_pixel_x, pixel_y = shift_pixel_y, time = 1)
	if(direction == NORTH)
		hiding_human.add_filter("cutout", 1, alpha_mask_filter(icon = icon('icons/effects/effects.dmi', "cutout")))
	hiding_human.density = FALSE
	ADD_TRAIT(hiding_human, TRAIT_UNDENSE, TRAIT_SOURCE_WALL_LEANING)
	RegisterSignals(hiding_human, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_RESISTED), PROC_REF(unhide_human), hiding_human)
	..()

/turf/simulated/wall/proc/unhide_human(mob/living/carbon/human/to_unhide)
	SIGNAL_HANDLER
	if(!to_unhide)
		return

	to_unhide.density = FALSE
	to_unhide.pixel_x = initial(to_unhide.pixel_x)
	to_unhide.pixel_y = initial(to_unhide.pixel_y)
	to_unhide.layer = initial(to_unhide.layer)
	LAZYREMOVE(hiding_humans, to_unhide)
	UnregisterSignal(to_unhide, list(COMSIG_MOVABLE_MOVED, COMSIG_MOB_RESISTED))
	to_chat(to_unhide, SPAN_NOTICE("You stop leaning on the wall."))
	REMOVE_TRAIT(to_unhide, TRAIT_UNDENSE, TRAIT_SOURCE_WALL_LEANING)
	to_unhide.remove_filter("cutout")
