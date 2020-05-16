#define NODERANGE 3

/obj/structure/alien/weeds
	name = "weeds"
	desc = "Weird purple weeds."
	icon_state = "weeds"
	anchored = 1
	density = 0
	health = 15
	var/obj/structure/alien/weeds/node/linked_node = null
	var/list/dirs_left

/obj/structure/alien/weeds/node
	icon_state = "weednode"
	name = "purple sac"
	desc = "Weird purple octopus-like thing."
	light_range = NODERANGE
	var/node_range = NODERANGE

/obj/structure/alien/weeds/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/alien/weeds/Initialize(pos, node)
	. = ..()
	if(istype(loc, /turf/space))
		return INITIALIZE_HINT_QDEL
	linked_node = node
	if(icon_state == "weeds")icon_state = pick("weeds", "weeds1", "weeds2")

	START_PROCESSING(SSprocessing, src)

	dirs_left = cardinal.Copy()

/obj/structure/alien/weeds/process()
	var/turf/U = get_turf(src)

	if (istype(U, /turf/space))
		qdel(src)
		return PROCESS_KILL

	if (!dirs_left.len || !linked_node || get_dist(linked_node, src) > linked_node.node_range)
		return PROCESS_KILL

	for (var/D in dirs_left)
		var/turf/T = get_step(src, D)

		if (!isturf(T) || T.is_hole || T.is_space() || locate(/obj/structure/alien/weeds, T))
			dirs_left -= D
			continue

		if (T.density)
			continue

		var/spawn_new = TRUE
		for (var/aa in T)
			var/atom/A = aa
			if (istype(/obj/structure/alien/weeds, A))
				dirs_left -= D
				spawn_new = FALSE
				break

			else if (A.density)
				spawn_new = FALSE

		if (spawn_new)
			new /obj/structure/alien/weeds(T, linked_node)


/obj/structure/alien/weeds/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(5))
				qdel(src)
	return

/obj/structure/alien/weeds/attackby(var/obj/item/W, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	visible_message("<span class='danger'>\The [src] have been attacked with \the [W][(user ? " by [user]." : ".")]</span>")

	var/damage = W.force / 4.0

	if(W.iswelder())
		var/obj/item/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)

	health -= damage
	healthcheck()


/obj/structure/alien/weeds/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		health -= 5
		healthcheck()

#undef NODERANGE