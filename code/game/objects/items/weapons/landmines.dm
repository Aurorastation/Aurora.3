/obj/item/landmine
	name = "land mine"
	desc = "An anti-personnel explosive device used for area denial."
	icon = 'icons/obj/grenade.dmi'
	icon_state = "landmine"
	throwforce = 0
	var/deployed = FALSE
	var/deactivated = FALSE // add wire to re-activate

/obj/item/landmine/update_icon()
	..()
	if(!deployed)
		icon_state = "[icon_state]"
	else
		icon_state = "[icon_state]_on"

/obj/item/landmine/verb/hide_under()
	set src in oview(1)
	set name = "Hide"
	set category = "Object"

	if(use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	layer = TURF_LAYER + 0.2
	to_chat(usr, "<span class='notice'>You hide \the [src].</span>")


/obj/item/landmine/attack_self(mob/user)
	..()
	if(deactivated)
		to_chat(user, SPAN_WARNING("\The [src] is deactivated and needs specific rewiring!"))
		return
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

			deployed = TRUE
			user.drop_from_inventory(src)
			update_icon()
			anchored = TRUE

/obj/item/landmine/proc/trigger(mob/living/L)
	spark(src, 3, alldirs)
	if(ishuman(L))
		L.Weaken(2)
	explosion(loc, 0, 2, 2, 3)
	qdel(src)

/obj/item/landmine/Crossed(AM as mob|obj)
	if(deployed)
		if(isliving(AM))
			var/mob/living/L = AM
			if(L.mob_size >= 5)
				L.visible_message(
					"<span class='danger'>[L] steps on \the [src].</span>",
					"<span class='danger'>You step on \the [src]!</span>",
					"<span class='danger'>You hear a mechanical click!</span>"
					)
				trigger(L)
	..()

/obj/item/landmine/attack_hand(mob/user as mob)
	if(deployed && !use_check(user, USE_DISALLOW_SILICONS))
		user.visible_message(
				"<span class='danger'>[user] triggers \the [src].</span>",
				"<span class='danger'>You trigger \the [src]!</span>",
				"<span class='danger'>You hear a mechanical click!</span>"
				)
		trigger(user)
	else
		..()

/obj/item/landmine/attackby(obj/item/I, mob/user)
	..()
	if(deactivated && istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		if(C.use(1))
			to_chat(user, SPAN_NOTICE("You start carefully start rewiring \the [src]."))
			if(do_after(user, 100, TRUE, src))
				to_chat(user, SPAN_NOTICE("You successfully rewire \the [src], priming it for use."))
				deactivated = FALSE
			return
		else
			to_chat(user, SPAN_WARNING("There's not enough cable to finish the task."))
			return
	else if(deployed && istype(I, /obj/item/wirecutters))
		var/obj/item/wirecutters/W = I
		user.visible_message(SPAN_WARNING("\The [user] starts snipping some wires in \the [src] with \the [W]..."), \
							SPAN_NOTICE("You start snipping some wires in \the [src] with \the [W]..."))
		if(do_after(user, 150, TRUE, src))
			if(prob(W.bomb_defusal_chance))
				to_chat(user, SPAN_NOTICE("You successfully defuse \the [src], though it's missing some essential wiring now."))
				deactivated = TRUE
				anchored = FALSE
				deployed = FALSE
				update_icon()
				return
		to_chat(user, FONT_LARGE(SPAN_DANGER("You slip, snipping the wrong wire!")))
		trigger(user)
	else if(I.force > 10 && deployed)
		trigger(user)

/obj/item/landmine/bullet_act()
	if(deployed)
		trigger()

/obj/item/landmine/ex_act(var/severity = 2.0)
	if(deployed)
		trigger()

//landmines that do more than explode

/obj/item/landmine/frag
	var/num_fragments = 15
	var/fragment_damage = 10
	var/damage_step = 2
	var/explosion_size = 3
	var/spread_range = 7

/obj/item/landmine/frag/trigger(mob/living/L)
	spark(src, 3, alldirs)
	fragem(src,num_fragments,num_fragments,explosion_size,explosion_size+1,fragment_damage,damage_step,1)
	qdel(src)

/obj/item/landmine/radiation
	icon_state = "radlandmine"

/obj/item/landmine/radiation/trigger(mob/living/L)
	spark(src, 3, alldirs)
	if(L)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.apply_radiation(50)
	qdel(src)

/obj/item/landmine/phoron
	icon_state = "phoronlandmine"

/obj/item/landmine/phoron/trigger(mob/living/L)
	spark(src, 3, alldirs)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("phoron", 30)

			target.hotspot_expose(1000, CELL_VOLUME)

	qdel(src)

/obj/item/landmine/n2o
	icon_state = "phoronlandmine"

/obj/item/landmine/n2o/trigger(mob/living/L)
	spark(src, 3, alldirs)
	for (var/turf/simulated/floor/target in range(1,src))
		if(!target.blocks_air)
			target.assume_gas("sleeping_agent", 30)

	qdel(src)

/obj/item/landmine/emp
	icon_state = "emplandmine"

/obj/item/landmine/emp/trigger(mob/living/L)
	spark(src, 3, alldirs)
	empulse(src.loc, 2, 4)
	qdel(src)
