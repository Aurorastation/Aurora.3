/obj/structure/railing
	name = "railing"
	desc = "A simple bar railing designed to protect against careless trespass."
	icon = 'icons/obj/railing.dmi'
	icon_state = "railing0-1"
	density = TRUE
	throwpass = TRUE
	climbable = TRUE
	layer = OBJ_LAYER
	anchored = FALSE
	obj_flags = OBJ_FLAG_ROTATABLE

	var/broken = FALSE
	var/health = 70
	var/maxhealth = 70
	var/neighbor_status = 0

/obj/structure/railing/mapped
	color = COLOR_GUNMETAL
	anchored = TRUE

/obj/structure/railing/mapped/Initialize()
	. = ..()
	color = COLOR_GUNMETAL // They're not painted!

/obj/structure/railing/mapped/no_density
	density = FALSE

/obj/structure/railing/mapped/no_density/Initialize()
	. = ..()
	update_icon()

/obj/structure/railing/New(var/newloc, var/material_key = DEFAULT_WALL_MATERIAL)
	material = material_key // Converted to datum in initialize().
	..(newloc)

/obj/structure/railing/process()
	if(!material || !material.radioactivity)
		return
	for(var/mob/living/L in range(1,src))
		L.apply_damage(round(material.radioactivity / 20), IRRADIATE)

/obj/structure/railing/Initialize()
	. = ..()

	if(!isnull(material) && !istype(material))
		material = SSmaterials.get_material_by_name(material)
	if(!istype(material))
		return INITIALIZE_HINT_QDEL

	name = "[material.display_name] [initial(name)]"
	desc = "A simple [material.display_name] railing designed to protect against careless trespass."
	maxhealth = round(material.integrity / 5)
	health = maxhealth
	color = material.icon_colour

	if(material.products_need_process())
		START_PROCESSING(SSprocessing, src)
	if(anchored)
		update_icon(FALSE)

/obj/structure/railing/Destroy()
	anchored = FALSE
	broken = TRUE
	for(var/thing in range(1, src))
		var/turf/T = thing
		for(var/obj/structure/railing/R in T.contents)
			R.update_icon()
	return ..()

/obj/structure/railing/examine(mob/user)
	..()
	to_chat(user, FONT_SMALL(SPAN_NOTICE("\The [src] is <b>[density ? "closed" : "open"]</b> to passage.")))
	to_chat(user, FONT_SMALL(SPAN_NOTICE("\The [src] is <b>[anchored ? "" : "not"] screwed</b> to the floor.")))

/obj/structure/railing/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item/projectile))
		return TRUE
	if(!istype(mover) || mover.checkpass(PASSTABLE))
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/railing/examine(mob/user)
	..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				to_chat(user, SPAN_WARNING("It looks severely damaged!"))
			if(0.25 to 0.5)
				to_chat(user, SPAN_WARNING("It looks damaged!"))
			if(0.5 to 1.0)
				to_chat(user, SPAN_NOTICE("It has a few scrapes and dents."))

/obj/structure/railing/proc/take_damage(amount)
	health -= amount
	if(health <= 0)
		visible_message(SPAN_WARNING("\The [src] [material.destruction_desc]!"))
		playsound(get_turf(src), 'sound/effects/grillehit.ogg', 50, TRUE)
		material.place_shard(get_turf(src))
		qdel(src)

/obj/structure/railing/proc/NeighborsCheck(var/UpdateNeighbors = 1)
	neighbor_status = 0
	var/Rturn = turn(src.dir, -90)
	var/Lturn = turn(src.dir, 90)

	for(var/obj/structure/railing/R in get_turf(src))
		if((R.dir == Lturn) && R.anchored)
			neighbor_status |= 32
			if(UpdateNeighbors)
				R.update_icon(0)
		if((R.dir == Rturn) && R.anchored)
			neighbor_status |= 2
			if(UpdateNeighbors)
				R.update_icon(0)
	for(var/obj/structure/railing/R in get_step(src, Lturn))
		if((R.dir == src.dir) && R.anchored)
			neighbor_status |= 16
			if(UpdateNeighbors)
				R.update_icon(0)
	for(var/obj/structure/railing/R in get_step(src, Rturn))
		if((R.dir == src.dir) && R.anchored)
			neighbor_status |= 1
			if (UpdateNeighbors)
				R.update_icon(0)
	for(var/obj/structure/railing/R in get_step(src, (Lturn + src.dir)))
		if((R.dir == Rturn) && R.anchored)
			neighbor_status |= 64
			if (UpdateNeighbors)
				R.update_icon(0)
	for(var/obj/structure/railing/R in get_step(src, (Rturn + src.dir)))
		if((R.dir == Lturn) && R.anchored)
			neighbor_status |= 4
			if (UpdateNeighbors)
				R.update_icon(0)

/obj/structure/railing/update_icon(var/update_neighbors = TRUE)
	NeighborsCheck(update_neighbors)
	overlays.Cut()
	if(!neighbor_status || !anchored)
		icon_state = "railing0-[density]"
	else
		icon_state = "railing1-[density]"
		if(neighbor_status & 32)
			overlays += image(icon, "corneroverlay[density]")
		if((neighbor_status & 16) || !(neighbor_status & 32) || (neighbor_status & 64))
			overlays += image(icon, "frontoverlay_l[density]")
		if(!(neighbor_status & 2) || (neighbor_status & 1) || (neighbor_status & 4))
			overlays += image(icon, "frontoverlay_r[density]")
			if(neighbor_status & 4)
				var/pix_offset_x = 0
				var/pix_offset_y = 0
				switch(dir)
					if(NORTH)
						pix_offset_x = 32
					if(SOUTH)
						pix_offset_x = -32
					if(EAST)
						pix_offset_y = -32
					if(WEST)
						pix_offset_y = 32
				overlays += image(icon, "mcorneroverlay[density]", pixel_x = pix_offset_x, pixel_y = pix_offset_y)

/obj/structure/railing/verb/flip() // This will help push railing to remote places, such as open space turfs
	set name = "Flip Railing"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return FALSE

	if(anchored)
		to_chat(usr, SPAN_WARNING("It is fastened to the floor and cannot be flipped."))
		return FALSE

	if(turf_is_crowded(TRUE))
		to_chat(usr, SPAN_WARNING("You can't flip \the [src] - something is in the way."))
		return FALSE

	forceMove(get_step(src, src.dir))
	set_dir(turn(dir, 180))
	update_icon()

/obj/structure/railing/CheckExit(var/atom/movable/O, var/turf/target)
	if(get_dir(O.loc, target) == dir)
		if(!density)
			return TRUE
		return FALSE
	return TRUE

/obj/structure/railing/attackby(var/obj/item/W, var/mob/user)
	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/grab) && user.Adjacent(src))
		var/obj/item/grab/G = W
		if(ishuman(G.affecting))
			var/obj/occupied = turf_is_crowded(TRUE)
			if(occupied)
				to_chat(user, SPAN_WARNING("There's \a [occupied] in the way!"))
				return

			if(G.state >= GRAB_NECK)
				if(user.a_intent == I_HURT)
					visible_message(SPAN_DANGER("[G.assailant] slams [G.affecting]'s face against \the [src]!"))
					playsound(get_turf(src), 'sound/effects/grillehit.ogg', 50, TRUE)
					if(prob(30))
						G.affecting.Weaken(5)
					G.affecting.apply_damage(15, BRUTE, BP_HEAD)
				else
					G.affecting.forceMove(get_step(src, get_dir(user, src)))
					G.affecting.Weaken(5)
					visible_message(SPAN_WARNING("[G.assailant] throws \the [G.affecting] over \the [src]!"))
				qdel(G)
			else
				to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
			return

	// Dismantle
	if(W.iswrench())
		if(!anchored)
			playsound(get_turf(src), W.usesound, 50, TRUE)
			user.visible_message(SPAN_NOTICE("\The [user] starts dismantling \the [src]..."), SPAN_NOTICE("You start dismantling \the [src]..."))
			if(do_after(user, 20, src))
				if(anchored)
					return
				user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."), SPAN_NOTICE("You dismantle \the [src]."))
				material.place_sheet(get_turf(src), 2)
				qdel(src)
			return
	// Wrench Open
		else
			playsound(get_turf(src), W.usesound, 50, TRUE)
			if(density)
				user.visible_message(SPAN_NOTICE("\The [user] wrenches \the [src] open."), SPAN_NOTICE("You wrench \the [src] open."))
				density = FALSE
			else
				user.visible_message(SPAN_NOTICE("\The [user] wrenches \the [src] closed."), SPAN_NOTICE("You wrench \the [src] closed."))
				density = TRUE
			update_icon()
			return
	// Repair
	if(W.iswelder())
		var/obj/item/weldingtool/F = W
		if(F.isOn())
			if(health >= maxhealth)
				to_chat(user, SPAN_WARNING("\The [src] does not need repairs."))
				return
			playsound(get_turf(src), W.usesound, 50, TRUE)
			if(do_after(user, 20, src))
				if(health >= maxhealth)
					return
				user.visible_message(SPAN_NOTICE("\The [user] repairs some damage to \the [src]."), SPAN_NOTICE("You repair some damage to \the [src]."))
				health = min(health + (maxhealth / 5), maxhealth)
			return

	// Install
	if(W.isscrewdriver())
		if(!density)
			to_chat(user, SPAN_NOTICE("You need to wrench \the [src] from back into place first."))
			return
		user.visible_message(anchored ? "<span class='notice'>\The [user] begins unscrewing \the [src].</span>" : "<span class='notice'>\The [user] begins fastening \the [src].</span>" )
		playsound(get_turf(src), W.usesound, 75, TRUE)
		if(do_after(user, 10, src) && density)
			to_chat(user, (anchored ? "<span class='notice'>You have unfastened \the [src] from the floor.</span>" : "<span class='notice'>You have fastened \the [src] to the floor.</span>"))
			anchored = !anchored
			update_icon()
		return

	if(W.force && (W.damtype == BURN || W.damtype == BRUTE))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		visible_message(SPAN_WARNING("\The [src] has been [LAZYLEN(W.attack_verb) ? pick(W.attack_verb) : "attacked"] with \the [W] by \the [user]!"))
		take_damage(W.force)
		return
	. = ..()

/obj/structure/railing/ex_act(severity)
	qdel(src)

/obj/structure/railing/can_climb(var/mob/living/user, post_climb_check=0)
	. = ..()
	if(. && get_turf(user) == get_turf(src))
		if(turf_is_crowded(TRUE))
			to_chat(user, SPAN_WARNING("You can't climb there, the way is blocked."))
			return FALSE

/obj/structure/railing/do_climb(mob/living/user)
	if(!can_climb(user))
		return

	user.visible_message(SPAN_WARNING("\The [user] starts climbing over \the [src]!"))
	LAZYADD(climbers, user)

	if(!do_after(user, 50))
		LAZYREMOVE(climbers, user)
		return

	if(!can_climb(user, post_climb_check = TRUE))
		LAZYREMOVE(climbers, user)
		return

	var/climb_dir = get_dir(user, src)
	if(get_turf(src) == get_turf(user))
		climb_dir = src.dir
	user.forceMove(get_step(src, climb_dir))
	user.visible_message(SPAN_WARNING("\The [user] climbs over \the [src]!"))
	LAZYREMOVE(climbers, user)

	if(!anchored || material.is_brittle())
		take_damage(maxhealth) // Fatboy