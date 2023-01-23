/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	desc_info = "You can deconstruct this by welding it, and then wrenching the girder.<br>\
	You can build a wall by using metal sheets and making a girder, then adding more material."
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "generic"
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	canSmoothWith = list(
		/turf/simulated/wall,
		/turf/simulated/wall/r_wall,
		/obj/structure/window/full/reinforced,
		/obj/structure/window/full/phoron/reinforced,
		/obj/structure/window/full/reinforced/polarized,
		/obj/structure/window_frame,
		/obj/structure/window_frame/unanchored,
		/obj/structure/window_frame/empty
		)

	var/damage = 0
	var/damage_overlay = 0
	var/global/damage_overlays[16]
	var/active
	var/can_open = 0
	var/material/material
	var/material/reinf_material
	var/last_state
	var/construction_stage
	var/hitsound = 'sound/weapons/genhit.ogg'
	var/use_set_icon_state

	var/under_turf = /turf/simulated/floor/plating

	var/tmp/list/image/reinforcement_images
	var/tmp/image/damage_image
	var/tmp/image/fake_wall_image
	var/tmp/cached_adjacency

	smooth = SMOOTH_TRUE | SMOOTH_NO_CLEAR_ICON

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
	return ..()

/turf/simulated/wall/process()
	// Calling parent will kill processing
	if(!radiate())
		STOP_PROCESSING(SSprocessing, src)

/turf/simulated/wall/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!opacity && istype(mover) && mover.checkpass(PASSGLASS))
		return TRUE
	return ..()

/turf/simulated/wall/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj,/obj/item/projectile/beam))
		burn(2500)
	else if(istype(Proj,/obj/item/projectile/ion))
		burn(500)
	
	bullet_ping(Proj)

	var/proj_damage = Proj.get_structure_damage()
	var/damage = proj_damage

	//cap the amount of damage, so that things like emitters can't destroy walls in one hit.
	if(Proj.anti_materiel_potential > 1)
		damage = min(proj_damage, 100)

	Proj.on_hit(src)

	take_damage(damage)

/turf/simulated/wall/hitby(AM as mob|obj, var/speed = THROWFORCE_SPEED_DIVISOR)
	..()
	if(isliving(AM))
		var/mob/living/M = AM
		M.turf_collision(src, speed)
		return

	var/tforce = AM:throwforce * (speed/THROWFORCE_SPEED_DIVISOR)
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
		plant.update_neighbors()

/turf/simulated/wall/ChangeTurf(var/newtype)
	clear_plants()
	..(newtype)

//Appearance
/turf/simulated/wall/examine(mob/user)
	. = ..(user)

	if(!damage)
		to_chat(user, SPAN_NOTICE("It looks fully intact."))
	else
		var/dam = damage / material.integrity
		if(dam <= 0.3)
			to_chat(user, SPAN_WARNING("It looks slightly damaged."))
		else if(dam <= 0.6)
			to_chat(user, SPAN_WARNING("It looks moderately damaged."))
		else
			to_chat(user, SPAN_DANGER("It looks heavily damaged."))

	if(locate(/obj/effect/overlay/wallrot) in src)
		to_chat(user, SPAN_WARNING("There is fungus growing on [src]."))

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

/turf/simulated/wall/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume) //Doesn't fucking work because walls don't interact with air :[
	burn(exposed_temperature)

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	if(adj_temp > material.melting_point)
		take_damage(log(RAND_F(0.9, 1.1) * (adj_temp - material.melting_point)))

	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated, var/explode, var/no_product, var/no_change = FALSE)
	if (!no_change)	// No change is TRUE when this is called by destroy.
		playsound(src, 'sound/items/welder.ogg', 100, 1)

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

	clear_plants()
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
		else
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

	for(var/mob/living/L in range(3,src))
		L.apply_damage(total_radiation, IRRADIATE, damage_flags = DAM_DISPERSED)
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