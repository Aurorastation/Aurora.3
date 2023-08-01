/obj/structure/flora/tree
	name = "tree"
	desc = "A tree."
	density = TRUE
	layer = 9
	pixel_x = -16
	var/max_chop_health = 180
	var/chop_health = 180 //15 hits with steel hatchet, 5 with wielded fireaxe
	var/fall_force = 60
	var/list/contained_objects = list()	//If it has anything except wood. Fruit, pinecones, animals, etc.
	var/stumptype = /obj/structure/flora/stump //stump to make when chopped
	var/static/list/fall_forbid = list(/obj/structure/flora, /obj/effect, /obj/structure/bonfire, /obj/structure/pit)

/obj/structure/flora/tree/proc/update_desc()
	desc = initial(desc)
	switch(chop_health / max_chop_health)
		if(0 to 0.25)
			desc = " It looks like it's about to fall!"
		if(0.26 to 0.5)
			desc += " Just a bit more work and it'll fall!"
		if(0.51 to 0.75)
			desc += " It's been chopped at a few times."
		if(0.76 to 0.95)
			desc += " Looks like someone just started cutting it down."

/obj/structure/flora/tree/attackby(obj/item/I, mob/user)
	if(I.can_woodcut())
		if(cutting)
			return
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		cutting = TRUE
		if(istype(I, /obj/item/material/twohanded/chainsaw))
			var/obj/item/material/twohanded/chainsaw/C = I
			if(C.powered)
				user.visible_message(SPAN_NOTICE("\The [user] begins cutting down \the [src]..."), SPAN_NOTICE("You start cutting down \the [src]..."))
				playsound(get_turf(user), 'sound/weapons/saw/chainsawhit.ogg', 60, 1)
				shake_animation()
				if(do_after(user, 50))
					timber(user)
			else
				to_chat(user, SPAN_WARNING("Try turning \the [C] on first!"))
				cutting = FALSE
				return
		else if(do_after(user, I.w_class * 5)) //Small windup
			user.do_attack_animation(src)
			shake_animation()
			playsound(get_turf(src), 'sound/effects/woodcutting.ogg', 50, 1)
			chop_health -= I.force
			update_desc()
			if(prob(20))
				user.visible_message(SPAN_NOTICE("\The [user] chops at \the [src]."), SPAN_NOTICE("You chop at \the [src]."), SPAN_NOTICE("You hear someone chopping wood."))
			if(prob(I.force/3))
				var/list/valid_turfs = list()
				for(var/turf/T in circle_range(src, 1))
					if(T.contains_dense_objects())
						continue
					valid_turfs += T
				if(!valid_turfs.len)
					valid_turfs += get_turf(src)
				var/obj/item/stack/material/wood/branch/B = new(pick(valid_turfs))
				B.amount = 1
				visible_message(SPAN_NOTICE("\The [B] falls from \the [src]."))

			if(chop_health <= 0)
				timber(user)
		cutting = FALSE
		return
	..()

/obj/structure/flora/tree/proc/timber(mob/user)
	var/turf/fall_loc //Where we will fall

	//We prefer to fall directly away from the user if possible
	var/turf/pref_loc = get_cardinal_step_away(src, user)
	if(!pref_loc.contains_dense_objects(TRUE))
		fall_loc = pref_loc

	//Otherwise, we fall elsewhere
	else
		var/list/fall_spots = list()
		for(var/turf/T in orange(1, src))
			if(locate(user) in T.contents) //Won't fall on woodcutter
				continue
			if(T.contains_dense_objects(TRUE)) //Let's avoid dense objects but not mobs
				continue
			fall_spots += T

		if(!fall_spots.len)
			fall_loc = get_turf(src)
		else
			fall_loc = pick(fall_spots)
	playsound(get_turf(src), 'sound/species/diona/gestalt_grow.ogg', 50)
	for(var/atom/A in fall_loc.contents)
		if(is_type_in_list(A, fall_forbid))
			continue
		if(isliving(A))
			var/mob/living/L = A
			visible_message(SPAN_WARNING("\The [src] crushes \the [L] under its weight!"))
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				var/obj/item/organ/external/affected = pick(H.organs)
				affected.take_damage(fall_force)
			else
				if(L.mob_size <= fall_force / 5)
					L.gib()
				else
					L.health -= fall_force
					if(L.health <= 0)
						L.gib()

		if(isobj(A) && !istype(A, /obj/item/stack) && A != src)
			var/obj/O = A
			if(prob(fall_force * 0.75))
				visible_message(SPAN_WARNING("\The [src] crushes \the [O] under its weight!"))
				qdel(A)
	new /obj/structure/flora/stump/log(fall_loc)
	var/obj/item/stack/material/wood/branch/B = new(fall_loc)
	B.amount = rand(5, 8)
	new stumptype(get_turf(src))
	qdel(src)

/obj/structure/flora/stump
	name = "stump"
	desc = "Nature's chair."
	icon = 'icons/obj/wood.dmi'
	icon_state = "tree_stump"
	density = FALSE
	anchored = TRUE

/obj/structure/flora/stump/can_dig()
	return TRUE

/obj/structure/flora/stump/log
	name = "big log"
	desc = "A sideways tree, but dead. Chop this into useable logs!"
	anchored = FALSE
	icon_state = "timber"

/obj/structure/flora/stump/log/attackby(obj/item/I, mob/user)
	if(I.can_woodcut())
		if(cutting)
			return
		cutting = TRUE
		var/chopsound = istype(I, /obj/item/material/twohanded/chainsaw) ? 'sound/weapons/saw/chainsawhit.ogg' : 'sound/effects/woodcutting.ogg'
		playsound(get_turf(user), chopsound, 50, 1)
		user.visible_message(SPAN_NOTICE("\The [user] begins chopping \the [src] into log sections."), SPAN_NOTICE("You begin chopping \the [src] into log sections."))
		var/chopspeed = 1
		if(istype(I, /obj/item/material/twohanded))
			var/obj/item/material/twohanded/W = I
			chopspeed = W.wielded ? 2 : 1
		if(do_after(user, 100 / chopspeed))
			user.visible_message(SPAN_NOTICE("\The [user] chops \the [src] into log sections."), SPAN_NOTICE("You chop \the [src] into log sections."))
			var/obj/item/stack/material/wood/log/L = new(get_turf(src))
			L.amount = rand(5, 8)
			qdel(src)
		cutting = FALSE
	else
		..()
