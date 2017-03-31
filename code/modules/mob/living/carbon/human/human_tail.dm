var/list/human_tail_cache = list()

/mob/living/carbon/human/proc/coil_up()
	set name = "Coil Up"
	set category = "IC"
	set desc = "Retract your tail around yourself."
	if(stat || paralysis || !tail_trail)
		return
	src.visible_message("<span class='notice'>\The [src] coils up!</span>")
	tail_trail.update_moved(src)
	sleep(-1)
	if(istype(src.loc, /turf))
		tail_trail.update_moved(src.loc)

/mob/living/carbon/human
	var/obj/effect/tail/underlay/tail_trail // Tail ref for critters that drag tails behind them.

/obj/effect/tail
	icon = null
	icon_state = ""
	simulated = 0
	anchored = 1
	density = 0
	opacity = 0
	w_class = 5

	var/base_colour = "#000000"
	var/markings_colour = "#000000"
	var/mob/living/carbon/human/owner
	var/moved_from
	var/tail_type

/obj/effect/tail/Crossed(var/atom/movable/crossing)
	. = ..()
	if(crossing == owner || loc == owner.loc || prob(30))
		return .
	if(istype(crossing, /mob/living))
		var/mob/living/M = crossing
		var/damage_taken
		if(istype(crossing, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = crossing
			if(istype(H.shoes, /obj/item/clothing/shoes/magboots) && (H.shoes.item_flags & NOSLIP))
				damage_taken = rand(5,8)
		if(!damage_taken)
			damage_taken = rand(1,3)
		if(prob(50))
			M.visible_message("<span class='danger'>\The [M] trips over \the [owner]'s tail!</span>")
			M.Weaken(rand(5,8))
		else
			M.visible_message("<span class='danger'>\The [M] treads on \the [owner]'s tail!</span>")
		owner << "<span class='danger'>Your tail is being brutalized!</span>"
		owner.apply_damage(damage_taken, BRUTE, "groin")
	else if(istype(crossing, /obj/vehicle) || istype(crossing, /obj/mecha))
		crossing.visible_message("<span class='danger'>\The [crossing] runs over \the [owner]'s tail!</span>")
		owner << "<span class='danger'>Your tail is being brutalized!</span>"
		owner.apply_damage(rand(5,8), BRUTE, "groin")
	return .

/obj/effect/tail/Destroy()
	owner = null
	return ..()

/obj/effect/tail/underlay/Destroy()
	for(var/obj/effect/tail/segment in segments)
		qdel(segment)
	segments.Cut()
	return ..()

/obj/effect/tail/New(var/mob/living/carbon/human/newowner)
	owner = newowner
	if(!istype(owner))
		owner = null
		qdel(src)
		return
	..(get_turf(owner))

/obj/effect/tail/proc/sync_to_owner()
	name = "[owner]'\s [initial(name)]"
	base_colour = rgb(owner.r_skin, owner.g_skin, owner.b_skin)
	markings_colour = rgb(owner.r_hair, owner.g_hair, owner.b_hair)
	update_icon(1)

/obj/effect/tail/attack_generic(var/mob/user, var/damage, var/attack_message)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(owner.loc == loc) return
	return owner.attack_generic(user, damage, attack_message)

/obj/effect/tail/attackby(var/obj/item/thing, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(owner.loc == loc) return
	return owner.attack_hand(user, thing)

/obj/effect/tail/attack_hand(var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(owner.loc == loc) return
	return owner.attack_hand(user)

/obj/effect/tail/bullet_act(var/obj/item/projectile/proj)
	if(owner.loc == loc) return
	return owner.bullet_act(proj)

/obj/effect/tail/fire_act(var/datum/gas_mixture/air, var/exposed_temperature, var/exposed_volume)
	if(owner.loc == loc) return
	return owner.fire_act(air, exposed_temperature, exposed_volume)

/obj/effect/tail/ex_act(var/severity)
	if(owner.loc == loc) return
	return owner.ex_act(severity) // Damage to the tail should damage the mob in general.

/obj/effect/tail/emp_act(var/severity)
	if(loc == owner.loc)
		return
	return owner.ex_act(severity)

/obj/effect/tail/update_icon(var/force_override)
	overlays.Cut()
	// Build base.
	var/cache_key = "[owner.species.name]-[tail_type]-[base_colour]"
	if(!human_tail_cache[cache_key] || force_override)
		var/icon/I = icon(icon=owner.species.icobase, icon_state=tail_type)
		I.Blend(base_colour, ICON_ADD)
		human_tail_cache[cache_key] = I
	overlays += human_tail_cache[cache_key]
	// Build markings.
	cache_key = "[owner.species.name]-[tail_type]_markings-[markings_colour]"
	if(!human_tail_cache[cache_key] || force_override)
		var/icon/I = icon(icon=owner.species.icobase, icon_state="[tail_type]_markings")
		I.Blend(markings_colour, ICON_ADD)
		human_tail_cache[cache_key] = I
	overlays += human_tail_cache[cache_key]

/obj/effect/tail/underlay
	name = "coils"
	var/list/segments = list()

/obj/effect/tail/underlay/New()
	..()
	layer = owner.layer - 0.01
	if(owner && segments)
		for(var/i = 1 to owner.species.tail_length)
			var/obj/effect/tail/trailing/segment= new (owner, (i == owner.species.tail_length))
			segment.layer = (owner.layer - (0.01 * (i+1)))
			segments += segment

/obj/effect/tail/underlay/sync_to_owner()
	..()
	for(var/obj/effect/tail/trailing/segment in segments)
		segment.owner = owner
		segment.sync_to_owner()

/obj/effect/tail/trailing
	name = "tail"
	var/terminating
	animate_movement = SYNC_STEPS

/obj/effect/tail/trailing/New(var/newloc, var/term)
	terminating = term
	..(newloc)

/obj/effect/tail/trailing/update_icon()
	if(reverse_dir[moved_from] == dir)
		tail_type = "tail_straight[terminating ? "_end" : ""]"
	else
		// Way, way too tired to work this shit out.
		// TODO bug GN or Psi about bit magic.
		if(dir == NORTH)
			if(moved_from == WEST)
				tail_type = "tail_bent_1[terminating ? "_end" : ""]"
			else if(moved_from == EAST)
				tail_type = "tail_bent_2[terminating ? "_end" : ""]"
		else if(dir == SOUTH)
			if(moved_from == WEST)
				tail_type = "tail_bent_1[terminating ? "_end" : ""]"
			else if(moved_from == EAST)
				tail_type = "tail_bent_2[terminating ? "_end" : ""]"
		else if(dir == EAST)
			if(moved_from == NORTH)
				tail_type = "tail_bent_1[terminating ? "_end" : ""]"
			else if(moved_from == SOUTH)
				tail_type = "tail_bent_2[terminating ? "_end" : ""]"
		else if(dir == WEST)
			if(moved_from == NORTH)
				tail_type = "tail_bent_1[terminating ? "_end" : ""]"
			else if(moved_from == SOUTH)
				tail_type = "tail_bent_2[terminating ? "_end" : ""]"
	..()

/obj/effect/tail/proc/update_moved(var/turf/newloc, var/turf/predecessor)
	if(!newloc || newloc == owner || !istype(owner.loc, /turf))
		forceMove(owner)
		return
	if(src.loc == owner)
		forceMove(get_turf(owner))
	var/turf/oldloc = src.loc
	if(!istype(oldloc))
		forceMove(owner)
		return
	if(newloc == oldloc)
		return
	forceMove(newloc)
	if(predecessor)
		moved_from = get_dir(newloc, oldloc)
		dir = get_dir(newloc, predecessor)
	if(dir in cornerdirs)
		forceMove(owner)
		return
	update_icon()

/obj/effect/tail/trailing/update_moved(var/turf/newloc, var/turf/predecessor)
	..(newloc, predecessor)
	if(loc == owner || owner.loc == loc)
		invisibility = 101
	else
		invisibility = 0

/obj/effect/tail/underlay/update_moved(var/turf/newloc, var/turf/predecessor)
	var/oldloc = src.loc
	..(newloc, predecessor)
	if(loc == owner)
		for(var/obj/effect/tail/T in segments)
			T.update_moved(owner)
	else
		var/obj/effect/lastsegment = src
		for(var/obj/effect/tail/segment in segments)
			var/segmentloc = segment.loc
			segment.update_moved(oldloc, get_turf(lastsegment))
			oldloc = segmentloc
			lastsegment = segment

	// Do this here instead of update_icon() because we have to wait for all the other segments to have moved.
	dir = owner.dir
	tail_type = "tail_underlay"
	for(var/obj/effect/tail/trailing/segment in segments)
		if(get_turf(segment) != newloc)
			return
	tail_type = "tail_underlay_static"
	update_icon()

/mob/living/carbon/human/Move()
	. = ..()
	if(. && species.tail_stance)
		if(!tail_trail) tail_trail = new(src)
		var/turf/T = get_turf(src)
		if(istype(T))
			tail_trail.update_moved(T)
		else
			tail_trail.update_moved(src)

/mob/living/carbon/human/forceMove()
	. = ..()
	if(species.tail_stance)
		if(!tail_trail) tail_trail = new(src)
		var/turf/T = get_turf(src)
		if(istype(T))
			tail_trail.update_moved(T)
		else
			tail_trail.update_moved(src)
