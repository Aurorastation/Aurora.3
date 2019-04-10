#define SANDBAG_BLOCK_ITEMS_CHANCE 90

/obj/structure/window/sandbag
	name = "sandbag"
	desc = "A barricade made of sandbags."
	icon = 'icons/adhomai/sandbag.dmi'
	icon_state = "sandbag"
	layer = MOB_LAYER + 0.01 //just above mobs
	anchored = TRUE
	climbable = TRUE

/obj/structure/window/sandbag/attack_hand(var/mob/user as mob)
	return

/obj/structure/window/sandbag/ex_act(severity)
	switch(severity)
		if (1.0)
			qdel(src)
			return
		if (2.0)
			qdel(src)
			return
		else
			if (prob(50))
				return ex_act(2.0)
	return

/obj/structure/window/sandbag/New(location, var/mob/creator)
	loc = location
	flags |= ON_BORDER

	if (creator && ismob(creator))
		dir = creator.dir
	else
		var/ndir = creator
		dir = ndir

	set_dir(dir)

	switch (dir)
		if (NORTH)
			layer = MOB_LAYER - 0.01
			pixel_y = FALSE
		if (SOUTH)
			layer = MOB_LAYER + 0.01
			pixel_y = FALSE
		if (EAST)
			layer = MOB_LAYER - 0.05
			pixel_x = FALSE
		if (WEST)
			layer = MOB_LAYER - 0.05
			pixel_x = FALSE

//incomplete sandbag structures
/obj/structure/window/sandbag/incomplete
	name = "incomplete sandbag"
	icon_state = "sandbag_33%"
	var/progress = FALSE
	var/maxProgress = 5


/obj/structure/window/sandbag/incomplete/ex_act(severity)
	qdel(src)

/obj/structure/window/sandbag/incomplete/attackby(obj/O as obj, mob/user as mob)
	user.dir = get_dir(user, src)
	if (istype(O, /obj/item/weapon/sandbag))
		var/obj/item/weapon/sandbag/sandbag = O
		progress += (sandbag.sand_amount + 1)
		if (progress >= maxProgress/2)
			icon_state = "sandbag_66%"
			if (progress >= maxProgress)
				icon_state = "sandbag"
				new/obj/structure/window/sandbag(loc, dir)
				qdel(src)
		visible_message("<span class='danger'>[user] adds a bag to [src].</span>")
		qdel(O)
	else
		return

/obj/structure/window/sandbag/set_dir(direction)
	dir = direction

// sandbag window overrides

/obj/structure/window/sandbag/attackby(obj/O as obj, mob/user as mob)
	return FALSE

/obj/structure/window/sandbag/take_damage(var/damage = FALSE, var/sound_effect = TRUE)
	return FALSE

/obj/structure/window/sandbag/apply_silicate(var/amount)
	return FALSE

/obj/structure/window/sandbag/updateSilicate()
	return FALSE

/obj/structure/window/sandbag/shatter(var/display_message = TRUE)
	return FALSE

/obj/structure/window/sandbag/bullet_act(var/obj/item/projectile/Proj)
	return FALSE

/obj/structure/window/sandbag/ex_act(severity)
	switch(severity)
		if (1.0)
			qdel(src)
			return
		if (2.0)
			qdel(src)
			return
		if (3.0)
			if (prob(50))
				qdel(src)

/obj/structure/window/sandbag/is_full_window()
	return FALSE

/obj/structure/window/hitby(AM as mob|obj)
	return FALSE // don't move

/obj/structure/window/sandbag/attack_generic(var/mob/user, var/damage)
	return FALSE

/obj/structure/window/sandbag/rotate()
	return

/obj/structure/window/sandbag/revrotate()
	return

/obj/structure/window/sandbag/is_fulltile()
	return FALSE

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/sandbag/update_icon()
	return

/obj/structure/window/sandbag/fire_act(temperature)
	return

/obj/item/weapon/sandbag
	name = "sandbag"
	icon_state = "sandbag-item"
	icon = 'icons/adhomai/sandbag.dmi'
	w_class = TRUE
	var/sand_amount = FALSE

/obj/structure/window/sandbag/incomplete/check_cover(obj/item/projectile/P, turf/from)
	return prob(..() * round(progress/maxProgress))

// how much do we cover mobs behind full sandbags?
/obj/structure/window/sandbag/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = get_turf(src)
	if (!cover)
		return FALSE
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return FALSE
	// can't hit legs or feet when they're behind a sandbag
	if (list("r_leg", "l_leg", "r_foot", "l_foot").Find(P.def_zone))
		return TRUE

	var/base_chance = SANDBAG_BLOCK_ITEMS_CHANCE
	var/extra_chance = 0

	if (ismob(P.original)) // what the firer clicked
		var/mob/m = P.original
		if (m.lying)
			extra_chance += 30

	var/chance = base_chance + extra_chance

	chance = min(chance, 98)

	if (prob(chance))
		return TRUE
	else
		return FALSE

// what is our chance of deflecting bullets regardless (compounded by check_cover)
/proc/bullet_deflection_chance(obj/item/projectile/proj)
	var/base = 100
	if (!istype(proj))
		return base
	return base - min(15, proj.accuracy) // > scoped kars have 143 accuracy

// procedure for both incomplete and complete sandbags
/obj/structure/window/sandbag/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)

	if (istype(mover, /obj/effect/effect/smoke))
		return TRUE

	else if (!istype(mover, /obj/item))
		if (get_dir(loc, target) & dir)
			return FALSE
		else
			return TRUE
	else
		if (istype(mover, /obj/item/projectile))
			var/obj/item/projectile/proj = mover
			proj.throw_source = proj.starting
/*			if (proj.throw_source == get_turf(src) || get_step(proj.throw_source, proj.dir) == get_turf(src) || proj.firer && (get_step(proj.firer, proj.firer.dir) == get_turf(src) || proj.firer.loc == get_turf(src)))
				return TRUE*/

		if (!mover.throw_source)
			if (get_dir(loc, target) & dir)
				return FALSE
			else
				return TRUE
		else
			switch (get_dir(mover.throw_source, get_turf(src)))
				if (NORTH, NORTHEAST)
					if (dir == EAST || dir == WEST || dir == NORTH)
						return TRUE
				if (SOUTH, SOUTHEAST)
					if (dir == EAST || dir == WEST || dir == SOUTH)
						return TRUE
				if (EAST)
					if (dir != WEST)
						return TRUE
				if (WEST)
					if (dir != EAST)
						return TRUE

			if (check_cover(mover, mover.throw_source) && prob(bullet_deflection_chance(mover)))
				visible_message("<span class = 'warning'>[mover] hits the sandbag!</span>")
				if (istype(mover, /obj/item/projectile))
					var/obj/item/projectile/B = mover
					B.damage = 0 // make sure we can't hurt people after hitting a sandbag
					B.invisibility = 101
					B.loc = null
					qdel(B) // because somehow we were still passing the sandbag
				return FALSE
			else
				return TRUE

