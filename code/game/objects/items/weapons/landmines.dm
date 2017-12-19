/obj/item/weapon/landmine
	name = "land mine"
	desc = "An anti-personnel explosive device used for area denial."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "landmine"
	throwforce = 0
	w_class = 3
	var/deployed = 0

/obj/item/weapon/landmine/update_icon()
	..()

	if(!deployed)
		icon_state = "[icon_state]"
	else
		icon_state = "[icon_state]_on"

/obj/item/weapon/landmine/verb/hide_under()
	set src in oview(1)
	set name = "Hide"
	set category = "Object"

	if(use_check(user, USE_DISALLOW_SILICONS))
		return

	layer = TURF_LAYER+0.2
	usr << "<span class='notice'>You hide \the [src].</span>"


/obj/item/weapon/landmine/attack_self(mob/user as mob)
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

/obj/item/weapon/landmine/proc/trigger(mob/living/L)
	spark(src, 3, alldirs)
	if(ishuman(L))
		L.Weaken(2)
	explosion(loc, 0, 1, 2, 3)
	qdel(src)

/obj/item/weapon/landmine/Crossed(AM as mob|obj)
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

/obj/item/weapon/landmine/attack_hand(mob/user as mob)
	if(deployed && !use_check(user, USE_DISALLOW_SILICONS))
		user.visible_message(
				"<span class='danger'>[user] triggers \the [src].</span>",
				"<span class='danger'>You trigger \the [src]!</span>",
				"<span class='danger'>You hear a mechanical click!</span>"
				)
		trigger(user)
	else
		..()

/obj/item/weapon/landmine/attackby(var/obj/item/I, var/mob/user)
	..()
	if(I.force > 10 && deployed)
		trigger(user)

/obj/item/weapon/landmine/bullet_act()
	if(deployed)
		trigger()

/obj/item/weapon/landmine/ex_act()
	if(deployed)
		trigger()

//landmines that do more than explode

/obj/item/weapon/landmine/frag
	name = "fragmentation land mine"
	var/num_fragments = 15
	var/fragment_damage = 10
	var/damage_step = 2
	var/explosion_size = 3
	var/spread_range = 7

/obj/item/weapon/landmine/frag/trigger(mob/living/L)
	spark(src, 3, alldirs)
	fragem(src,num_fragments,num_fragments,explosion_size,explosion_size+1,fragment_damage,damage_step,1)
	qdel(src)

/obj/item/weapon/landmine/radiation
	icon_state = "radlandmine"

/obj/item/weapon/landmine/radiation/trigger(mob/living/L)
	spark(src, 3, alldirs)
	if(L)
		if(ishuman(L))
			L.apply_radiation(50)
	qdel(src)

/obj/item/weapon/landmine/phoron
	icon_state = "phoronlandmine"

/obj/item/weapon/landmine/phoron/trigger(mob/living/L)
	spark(src, 3, alldirs)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("phoron", 30)

			target.hotspot_expose(1000, CELL_VOLUME)

	qdel(src)

/obj/item/weapon/landmine/n2o
	icon_state = "phoronlandmine"

/obj/item/weapon/landmine/n2o/trigger(mob/living/L)
	spark(src, 3, alldirs)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("sleeping_agent", 30)

	qdel(src)

/obj/item/weapon/landmine/emp
	icon_state = "emplandmine"

/obj/item/weapon/landmine/emp/trigger(mob/living/L)
	spark(src, 3, alldirs)
	empulse(src.loc, 2, 4)
	qdel(src)