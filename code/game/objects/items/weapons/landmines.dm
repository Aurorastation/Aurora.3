	name = "land mine"
	desc = "An anti-personnel explosive device used for area denial."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "landmine"
	throwforce = 0
	w_class = 3
	var/deployed = 0

	..()

	if(!deployed)
		icon_state = "[icon_state]"
	else
		icon_state = "[icon_state]_on"

	set src in oview(1)
	set name = "Hide"
	set category = "Object"

	if(use_check(user, USE_DISALLOW_SILICONS))
		return

	layer = TURF_LAYER+0.2
	usr << "<span class='notice'>You hide \the [src].</span>"


	..()
	if(!deployed && !use_check(user, USE_DISALLOW_SILICONS))
		user.visible_message(
			"<span class='danger'>[user] starts to deploy \the [src].</span>",
			"<span class='danger'>You begin deploying \the [src]!</span>"
			)

		if (do_after(user, 60))
			user.visible_message(
				"<span class='danger'>[user] has deployed \the [src].</span>",
				"<span class='danger'>You have deployed \the [src]!</span>"
				)

			deployed = 1
			user.drop_from_inventory(src)
			update_icon()
			anchored = 1

	spark(src, 3, alldirs)
	if(ishuman(L))
		L.Weaken(2)
	explosion(loc, 0, 1, 2, 3)
	qdel(src)

	if(deployed && isliving(AM))
		var/mob/living/L = AM
		if(L.mob_size >= 5)
			L.visible_message(
				"<span class='danger'>[L] steps on \the [src].</span>",
				"<span class='danger'>You step on \the [src]!</span>",
				"<span class='danger'>You hear a mechanical click!</span>"
				)
			trigger(L)
	..()

	if(deployed && !use_check(user, USE_DISALLOW_SILICONS))
		user.visible_message(
				"<span class='danger'>[user] triggers \the [src].</span>",
				"<span class='danger'>You trigger \the [src]!</span>",
				"<span class='danger'>You hear a mechanical click!</span>"
				)
		trigger(user)
	else
		..()

	..()
	if(I.force > 10 && deployed)
		trigger(user)

	if(deployed)
		trigger()

	if(deployed)
		trigger()

//landmines that do more than explode

	name = "fragmentation land mine"
	var/num_fragments = 15
	var/fragment_damage = 10
	var/damage_step = 2
	var/explosion_size = 3
	var/spread_range = 7

	spark(src, 3, alldirs)
	fragem(src,num_fragments,num_fragments,explosion_size,explosion_size+1,fragment_damage,damage_step,1)
	qdel(src)

	icon_state = "radlandmine"

	spark(src, 3, alldirs)
	if(L)
		if(ishuman(L))
			L.apply_radiation(50)
	qdel(src)

	icon_state = "phoronlandmine"

	spark(src, 3, alldirs)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("phoron", 30)

			target.hotspot_expose(1000, CELL_VOLUME)

	qdel(src)

	icon_state = "phoronlandmine"

	spark(src, 3, alldirs)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("sleeping_agent", 30)

	qdel(src)

	icon_state = "emplandmine"

	spark(src, 3, alldirs)
	empulse(src.loc, 2, 4)
	qdel(src)