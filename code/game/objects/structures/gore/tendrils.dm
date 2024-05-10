#define NODERANGE 3

/obj/structure/gore/tendrils
	name = "bloody tendrils"
	desc = "Bloody, pulsating tendrils."
	icon_state = "tendril"
	maxHealth = 40
	pass_flags = PASSTABLE | PASSMOB | PASSTRACE | PASSRAILING
	var/being_destroyed = FALSE
	var/is_node = FALSE
	var/obj/structure/gore/tendrils/node/linked_node = null
	var/list/dirs_left
	var/grow_speed = 5 SECONDS
	var/last_grow = 0

/obj/structure/gore/tendrils/node
	name = "flesh sac"
	desc = "Clumped up flesh, pulsating in rhythm with the tendrils that surround it."
	icon_state = "tendril_node"
	density = TRUE
	maxHealth = 150
	light_range = NODERANGE
	light_color = LIGHT_COLOR_EMERGENCY
	is_node = TRUE
	grow_speed = 3 SECONDS
	var/node_range = NODERANGE

/obj/structure/gore/tendrils/node/CanPass(atom/movable/mover, turf/target, height, air_group)
	. = ..()
	if(!.)
		if(istype(mover, /mob/living/simple_animal/hostile/morph))
			return TRUE
		if(ishuman(mover))
			var/mob/living/carbon/human/H = mover
			if(H.mind.antag_datums[MODE_CHANGELING])
				return TRUE

/obj/structure/gore/tendrils/Destroy()
	var/turf/T = get_turf(src)
	T.movement_cost = initial(T.movement_cost)
	STOP_PROCESSING(SSprocessing, src)
	being_destroyed = TRUE
	update_neighbours()
	return ..()

/obj/structure/gore/tendrils/Initialize(pos, node)
	. = ..()
	if(istype(loc, /turf/space) || isopenturf(loc))
		return INITIALIZE_HINT_QDEL

	var/turf/T = get_turf(src)
	T.movement_cost += 2
	if(!is_node)
		linked_node = node
		update_sprite()
		update_neighbours()
	else
		linked_node = src
		new /obj/structure/gore/tendrils(loc, linked_node)

	new /obj/effect/decal/cleanable/blood/no_dry(loc)
	START_PROCESSING(SSprocessing, src)
	dirs_left = GLOB.cardinal.Copy()

/obj/structure/gore/tendrils/proc/update_neighbours(turf/U)
	if(!U)
		U = loc
	if(istype(U))
		for(var/dirn in GLOB.cardinal)
			var/turf/T = get_step(U, dirn)
			if(!istype(T))
				continue
			var/obj/structure/gore/tendrils/GT = locate() in T
			if(GT)
				GT.update_sprite()

/obj/structure/gore/tendrils/proc/update_sprite()
	var/my_dir = 0
	for(var/check_dir in GLOB.cardinal)
		var/turf/check = get_step(src, check_dir)
		if(!istype(check))
			continue
		var/obj/structure/gore/tendrils/GT = locate() in check
		if(GT && !GT.being_destroyed)
			my_dir |= check_dir

	if(my_dir == 15) //weeds in all four directions
		icon_state = "tendril[rand(0, 15)]"
	else if(my_dir == 0) //no weeds in any direction
		icon_state = "tendril"
	else
		icon_state = "tendril_dir[my_dir]"

/obj/structure/gore/tendrils/node/update_sprite()
	for(var/obj/structure/gore/tendrils/GT in loc)
		if(GT == src)
			continue
		GT.update_sprite()

/obj/structure/gore/tendrils/process()
	if(last_grow + grow_speed > world.time)
		return
	last_grow = world.time
	var/turf/U = get_turf(src)

	if(istype(U, /turf/space) || isopenturf(U))
		qdel(src)
		return PROCESS_KILL

	if(!length(dirs_left) || !linked_node || get_dist(linked_node, U) > linked_node.node_range)
		return PROCESS_KILL

	var/D = pick(dirs_left)
	var/turf/T = get_step(U, D)

	if(!T.Enter(src)) //Uses the pass_flags to make sure we can go under tables and things, but not walls and windows
		return
	if(!isturf(T) || T.is_hole || T.is_space() || locate(/obj/structure/gore/tendrils, T))
		dirs_left -= D
		return

	dirs_left -= D
	new /obj/structure/gore/tendrils(T, linked_node)

/obj/structure/gore/tendrils/ex_act(severity)
	switch(severity)
		if(1.0)
			health = 0
		if(2.0)
			health -= maxHealth / 2
		if(3.0)
			health -= maxHealth / 5
	healthcheck()

/obj/structure/gore/tendrils/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		health -= 5
		healthcheck()

#undef NODERANGE
