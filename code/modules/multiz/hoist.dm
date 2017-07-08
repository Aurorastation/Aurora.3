///////////////////////////
// Dost thou even hoist? //
///////////////////////////

/obj/item/hoist_kit
	name = "hoist kit"
	desc = "A setup kit for a hoist that can be used to lift things. The hoist will deploy in the direction you're facing."
	icon = 'icons/obj/hoists.dmi'
	icon_state = "hoist_case"

/obj/item/hoist_kit/attack_self(mob/user)
	new /obj/structure/hoist (get_turf(user), user.dir)
	user.visible_message(span("warning", "[user] deploys the hoist kit!"), span("notice", "You deploy the hoist kit!"), span("notice", "You hear the sound of parts snapping into place."))
	qdel(src)

/obj/effect/hoist_hook
	name = "hoist clamp"
	desc = "A clamp used to lift people or things."
	icon = 'icons/obj/hoists.dmi'
	icon_state = "hoist_hook"
	var/obj/structure/hoist/source_hoist
	anchored = 1

/obj/effect/hoist_hook/MouseDrop_T(atom/movable/AM,mob/user)
	if(!istype(AM))
		log_debug("AAAAAAA")
		return
	if (!AM.simulated || AM.anchored || source_hoist.hoistee || !Adjacent(AM))
		return
	source_hoist.attach_hoistee(AM)
	user.visible_message(span("danger", "[user] attaches \the [AM] to the hoist clamp."), span("danger", "You attach \the [AM] to the hoist clamp."), span("danger", "You hear something clamp into place."))

/obj/structure/hoist/proc/attach_hoistee(atom/movable/AM)
	if (get_turf(AM) != get_turf(src))
		AM.forceMove(get_turf(src))
	hoistee = AM
	if(istype(AM, mob))
		var/mob/M = AM
		M.captured = 0
		M.update_canmove()
	else
		AM.anchored = 0

/obj/effect/hoist_hook/MouseDrop(atom/dest)
	if(!usr || !dest) return
	if(!Adjacent(usr) || !dest.Adjacent(usr)) return // carried over from the default proc

	INVOKE_ASYNC(dest, /atom/.proc/MouseDrop_T, src, usr) // thanks lohikode

	if (!source_hoist.hoistee)
		return
	if (!isturf(dest))
		return
	if (!dest.Adjacent(source_hoist.hoistee))
		return

	var/turf/desturf = dest
	source_hoist.hoistee.forceMove(desturf)
	usr.visible_message(span("danger", "[user] detaches \the [source_hoist.hoistee] from the hoist clamp."), span("danger", "You detach \the [source_hoist.hoistee] from the hoist clamp."), span("danger", "You hear something unclamp."))
	source_hoist.release_hoistee()

/obj/structure/hoist
	icon = 'icons/obj/hoists.dmi'
	icon_state = "hoist_base"
	var/broken = 0
	density = 1
	anchored = 1
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

/obj/structure/hoist/proc/release_hoistee()
	if(istype(hoistee, mob))
		hoistee.captured = 0
		hoistee.update_canmove()
	else
		hoistee.anchored = 0
	hoistee = null

/obj/structure/hoist/proc/break_hoist()
	if(broken)
		return
	broken = 1
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
				visible_message("\The [src] shakes violently, and neatly collapses as its damage sensors go off.")
				collapse_kit()
			return
		if(3.0)
			if(prob(50))
				if(!broken)
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
	if(broken)
		to_chat(user, span("warning", "The hoist is broken!"))
		return
	var/can = can_move_dir(movedir)
	var/movtext = movedir == UP ? "raise" : "lower"
	if (!can) // If you can't...
		movedir = movedir == UP ? DOWN : UP // switch directions!
		to_chat(user, span("notice", "You switch the direction of the pulley."))
		return

	if (!hoistee)
		user.visible_message(span("notice", "[user] begins to [movtext] the clamp."), span("notice", "You begin to [movtext] the clamp."), span("notice", "You hear the sound of a crank."))
		move_dir(movedir, 0)
		return

	var/size
	if (ismob(hoistee))
		var/mob/M = hoistee
		size = M.mob_size
	else if (isobj(hoistee))
		var/obj/O = hoistee
		size = O.w_class

	user.visible_message(span("notice", "[user] begins to [movtext] \the [hoistee]!"), span("notice", "You begin to [movtext] \the [hoistee]!"), span("notice", "You hear the sound of a crank."))
	if (do_after(user, (1 SECONDS) * size / 4, act_target = src))
		move_dir(movedir, 1)

/obj/structure/hoist/proc/collapse_kit()
	new /obj/item/hoist_kit(get_turf(src))
	qdel(src)

/obj/structure/hoist/verb/collapse_hoist()
	set name = "Collapse Hoist"
	set category = "Object"
	set src = view(1)

	if (isobserver(usr) || usr.incapacitated())
		return
	if (!usr.IsAdvancedToolUser()) // thanks nanacode
		to_chat(usr, span("notice", "You stare cluelessly at \the [src]."))
		return

	if (hoistee)
		to_chat(usr, span("notice", "You cannot collapse the hoist with \the [hoistee] attached!"))
		return
	collapse_kit()

/obj/structure/hoist/proc/can_move_dir(direction)
	var/turf/dest = direction == UP ? GetAbove(source_hook) : GetBelow(source_hook)
	switch(direction)
		if (UP)
			if (!istype(dest, /turf/simulated/open)) // can't move into a solid tile
				return 0
			if (source_hook in get_step(src, dir)) // you don't get to move above the hoist
				return 0
		if (DOWN)
			if (!istype(get_turf(source_hook), /turf/simulated/open)) // can't move down through a solid tile
				return 0
	if (!dest) // can't move if there's nothing to move to
		return 0
	return 1 // i thought i could trust myself to write something as simple as this, guess i was wrong

/obj/structure/hoist/proc/move_dir(direction, ishoisting)
	var/can = can_move_dir(direction)
	if (!can)
		return 0
	var/turf/move_dest = direction == UP ? GetAbove(source_hook) : GetBelow(source_hook)
	source_hook.forceMove(move_dest)
	if (!ishoisting)
		return 1
	hoistee.forceMove(move_dest)
	return 1
