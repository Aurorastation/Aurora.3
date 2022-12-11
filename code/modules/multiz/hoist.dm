///////////////////////////
// Dost thou even hoist? //
///////////////////////////

#define NORMAL_LAYER 3

/obj/item/hoist_kit
	name = "hoist kit"
	desc = "A setup kit for a hoist that can be used to lift things. The hoist will deploy in the direction you're facing."
	icon = 'icons/obj/hoists.dmi'
	icon_state = "hoist_case"

/obj/item/hoist_kit/attack_self(mob/user)
	new /obj/structure/hoist (get_turf(user), user.dir)
	user.visible_message(SPAN_WARNING("[user] deploys the hoist kit!"), SPAN_NOTICE("You deploy the hoist kit!"), SPAN_NOTICE("You hear the sound of parts snapping into place."))
	qdel(src)

/obj/effect/hoist_hook
	name = "hoist clamp"
	desc = "A clamp used to lift people or things."
	desc_info = "To use the hook, click drag the object you want to it to attach it.\nTo remove an object from the hook, click drag the hook to a nearby turf."
	icon = 'icons/obj/hoists.dmi'
	icon_state = "hoist_hook"
	var/obj/structure/hoist/source_hoist
	can_buckle = TRUE
	anchored = TRUE

/obj/effect/hoist_hook/attack_hand(mob/living/user)
	if (use_check_and_message(user, USE_DISALLOW_SILICONS))
		return
	if(source_hoist && source_hoist.hoistee)
		source_hoist.check_consistency()
		source_hoist.hoistee.forceMove(get_turf(src))
		user.visible_message(SPAN_DANGER("[user] detaches \the [source_hoist.hoistee] from the hoist clamp."), SPAN_DANGER("You detach \the [source_hoist.hoistee] from the hoist clamp."), SPAN_DANGER("You hear something unclamp."))
		source_hoist.release_hoistee()

/obj/effect/hoist_hook/MouseDrop_T(atom/movable/AM,mob/user)
	if (use_check_and_message(user, USE_DISALLOW_SILICONS))
		return

	if (!AM.simulated || AM.anchored)
		to_chat(user, SPAN_NOTICE("You can't do that."))
		return
	if (source_hoist.hoistee)
		to_chat(user, SPAN_NOTICE("\The [source_hoist.hoistee] is already attached to \the [src]!"))
		return
	source_hoist.attach_hoistee(AM, user)
	user.visible_message(SPAN_DANGER("[user] attaches \the [AM] to \the [src]."), SPAN_DANGER("You attach \the [AM] to \the [src]."), SPAN_DANGER("You hear something clamp into place."))

/obj/structure/hoist/proc/attach_hoistee(atom/movable/AM, mob/user)
	if (user && AM.loc == user)
		user.drop_from_inventory(AM)
	if (get_turf(AM) != get_turf(source_hook))
		AM.forceMove(get_turf(source_hook))
	hoistee = AM
	if(ismob(AM))
		source_hook.buckle(AM)
		if(issilicon(AM))
			AM.anchored = TRUE
	source_hook.layer = AM.layer + 0.1

/obj/effect/hoist_hook/MouseDrop(atom/dest)
	..()
	if(!dest.Adjacent(usr)) return // carried over from the default proc

	if(use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	if (!source_hoist.hoistee)
		return
	if (!isturf(dest))
		return
	if (!dest.Adjacent(source_hoist.hoistee))
		return

	source_hoist.check_consistency()

	var/turf/desturf = dest
	source_hoist.hoistee.forceMove(desturf)
	usr.visible_message(SPAN_DANGER("[usr] detaches \the [source_hoist.hoistee] from the hoist clamp."), SPAN_DANGER("You detach \the [source_hoist.hoistee] from the hoist clamp."), SPAN_DANGER("You hear something unclamp."))
	source_hoist.release_hoistee()

// This will handle mobs unbuckling themselves.
/obj/effect/hoist_hook/unbuckle()
	. = ..()
	if (. && !QDELETED(source_hoist))
		var/mob/M = .
		source_hoist.hoistee = null
		ADD_FALLING_ATOM(M)	// fuck you, you fall now!

/obj/structure/hoist
	icon = 'icons/obj/hoists.dmi'
	icon_state = "hoist_base"
	desc_info = "To use the hook, click drag the object you want to it to attach it.\nTo remove an object from the hook, click drag the hook to a nearby turf."
	var/broken = 0
	density = TRUE
	anchored = TRUE
	name = "hoist"
	desc = "A manual hoist, uses a clamp and pulley to hoist things."
	var/atom/movable/hoistee
	var/movedir = UP
	var/obj/effect/hoist_hook/source_hook

/obj/structure/hoist/Initialize(mapload, ndir)
	. = ..()
	dir = ndir
	var/turf/newloc = get_step(src, dir)
	source_hook = new(newloc)
	source_hook.source_hoist = src

/obj/structure/hoist/Destroy()
	if(hoistee)
		release_hoistee()
	QDEL_NULL(src.source_hook)
	return ..()

/obj/effect/hoist_hook/Destroy()
	source_hoist = null
	return ..()

/obj/structure/hoist/proc/check_consistency()
	if(hoistee && (hoistee.z != source_hook.z))
		release_hoistee()

/obj/structure/hoist/proc/release_hoistee()
	if(ismob(hoistee))
		source_hook.unbuckle(hoistee)
	hoistee.anchored = initial(hoistee.anchored)
	hoistee = null
	layer = NORMAL_LAYER

/obj/structure/hoist/proc/break_hoist()
	if(broken)
		return
	broken = TRUE
	desc += " It looks broken, and the clamp has retracted back into the hoist. Seems like you'd have to re-deploy it to get it to work again."
	if(hoistee)
		release_hoistee()
	QDEL_NULL(source_hook)

/obj/structure/hoist/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
			else
				collapse_kit()
			return
		if(3.0)
			if(prob(50) && !broken)
				break_hoist()
			return

/obj/effect/hoist_hook/ex_act(severity)
	switch(severity)
		if(1.0)
			source_hoist.break_hoist()
			return
		if(2.0)
			if(prob(50))
				source_hoist.break_hoist()
			return
		if(3.0)
			if(prob(25))
				source_hoist.break_hoist()
			return


/obj/structure/hoist/attack_hand(mob/living/user)
	if (!ishuman(user) || use_check_and_message(user, USE_DISALLOW_SILICONS))
		return

	if(broken)
		to_chat(user, SPAN_WARNING("The hoist is broken!"))
		return

	if (!can_move_dir(movedir)) // If you can't...
		movedir = movedir == UP ? DOWN : UP // switch directions!
		to_chat(user, SPAN_NOTICE("You switch the direction of the pulley."))
		return

	var/movtext = movedir == UP ? "raise" : "lower"
	var/size

	if(hoistee)
		check_consistency()
		if (ismob(hoistee))
			var/mob/M = hoistee
			size = M.mob_size
		else if (isobj(hoistee))
			var/obj/O = hoistee
			size = O.w_class

	if(size) // defined size means we're hoisting and it'll take time
		user.visible_message(SPAN_NOTICE("[user] begins to [movtext] \the [hoistee]!"), SPAN_NOTICE("You begin to [movtext] \the [hoistee]!"), SPAN_NOTICE("You hear the sound of a crank."))

	if (do_after(user, (1 SECONDS) * size / 4, act_target = src))
		. = move_dir(movedir)

	if(.)
		if(hoistee)
			user.visible_message(SPAN_NOTICE("[user] [movtext]s \the [hoistee]!"), SPAN_NOTICE("You [movtext] \the [hoistee]!"), SPAN_NOTICE("You hear the sound of a crank."))
		else
			user.visible_message(SPAN_NOTICE("[user] [movtext]s the clamp."), SPAN_NOTICE("You [movtext] the clamp."), SPAN_NOTICE("You hear the sound of a crank."))

/obj/structure/hoist/proc/collapse_kit()
	new /obj/item/hoist_kit(get_turf(src))
	qdel(src)

/obj/structure/hoist/verb/collapse_hoist()
	set name = "Collapse Hoist"
	set category = "Object"
	set src in range(1)

	if(use_check_and_message(usr, USE_DISALLOW_SILICONS))
		return

	if (hoistee)
		to_chat(usr, SPAN_NOTICE("You cannot collapse the hoist with \the [hoistee] attached!"))
		return

	collapse_kit()

/obj/structure/hoist/proc/can_move_dir(direction)
	var/turf/dest = direction == UP ? GetAbove(source_hook) : GetBelow(source_hook)
	switch(direction)
		if (UP)
			if (!isopenturf(dest)) // can't move into a solid tile
				return FALSE
			if (source_hook in get_step(src, dir)) // you don't get to move above the hoist
				return FALSE
		if (DOWN)
			if (!isopenturf(get_turf(source_hook))) // can't move down through a solid tile
				return FALSE
			var/obj/structure/lattice/L = locate(/obj/structure/lattice, get_turf(source_hook))
			if(istype(L) && L.anchored) // if there's a lattice anchored to our turf, we can't go down
				return FALSE
	return !!dest

/obj/structure/hoist/proc/move_dir(direction)
	if (!can_move_dir(direction))
		return FALSE
	var/turf/move_dest = direction == UP ? GetAbove(source_hook) : GetBelow(source_hook)
	source_hook.forceMove(move_dest)
	if (hoistee)
		hoistee.hoist_act(move_dest)
	return TRUE

/atom/movable/proc/hoist_act(turf/dest)
	forceMove(dest)
	return TRUE

#undef NORMAL_LAYER
