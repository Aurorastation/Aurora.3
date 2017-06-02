///////////////////////////
// Dost thou even hoist? //
///////////////////////////

/obj/item/hoist_kit
	name = "Hoist Kit"
	desc = "A setup kit for a hoist that can be used to lift things. The hoist will deploy in the direction you're facing."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "case"

/obj/item/hoist_kit/attack_self(mob/user)
	new /obj/structure/hoist (get_turf(user), user.dir)
	user.visible_message(span("warning", "[user] deploys the hoist kit!"), span("notice", "You deploy the hoist kit!"), span("notice", "You hear the sound of parts snapping into place."))
	qdel(src)

/obj/effect/hoist_hook
	name = "Hoist Clamp"
	desc = "A clamp used to lift people or things."
	icon = 'icons/obj/structures.dmi'
	icon_state = "up"
	var/obj/structure/hoist/source_hoist
	can_buckle = 1
	anchored = 1

/obj/effect/hoist_hook/MouseDrop_T(atom/movable/M,mob/user)
	if(!istype(M, /atom/movable/)) // why this is even necessary, i don't know.
		return
	if (initial(anchored))
		return
	if (istype(M, /obj/structure/))
		return
	if (source_hoist.hoistee)
		return
	source_hoist.hoistee = M
	if (!Adjacent(M))
		return
	if (get_turf(M) != get_turf(src))
		M.Move(get_turf(src))
	if (istype(M, /mob/living/))
		user_buckle_mob(M, user)
	else
		M.anchored = 1
		user.visible_message(span("danger", "[user] attaches \the [M] to the hoist clamp."), span("danger", "You attach \the [M] to the hoist clamp."), span("danger", "You hear something clamp into place."))

/obj/effect/hoist_hook/MouseDrop(atom/dest)
	if(!usr || !dest) return
	if(!Adjacent(usr) || !dest.Adjacent(usr)) return // carried over from the default proc

	spawn(0)
		dest.MouseDrop_T(src,usr)

	if (!source_hoist.hoistee)
		return
	if (!istype(dest, /turf))
		return
	if (!dest.Adjacent(source_hoist.hoistee))
		return

	if (buckled_mob)
		unbuckle_mob()

	var/turf/desturf = dest
	source_hoist.hoistee.Move(desturf)

	source_hoist.hoistee.anchored = 0
	usr.visible_message(span("danger", "[user] detaches \the [source_hoist.hoistee] from the hoist clamp."), span("danger", "You detach \the [source_hoist.hoistee] from the hoist clamp."), span("danger", "You hear something unclamp."))
	source_hoist.hoistee = null

/* Switching with a different tactic, MouseDrop.
/obj/effect/hoist_hook/attack_hand(mob/living/user)
	if (!source_hoist.hoistee)
		return
	var/turf/simulated/open/opent = get_turf(source_hoist.hoistee)
	if (istype(opent))
		LAZYADD(opent.climbers, source_hoist.hoistee)
	if (buckled_mob)
		user_unbuckle_mob(user)
	source_hoist.hoistee.anchored = 0
	source_hoist.hoistee = null
	user.visible_message(span("warning", "[user] detaches \the [source_hoist.hoistee] from the hoist clamp."), span("notice", "You detach \the [source_hoist.hoistee] from the hoist clamp."), span("notice", "You hear something unclamp."))
*/

/obj/structure/hoist
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	anchored = 1
	name = "Hoist"
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

/obj/structure/hoist/attack_hand(mob/living/user)
	var/can = movedir == UP ? can_raise() : can_lower()
	var/movtext = movedir == UP ? "raise" : "lower"
	if (!can) // If you can't...
		movedir = movedir == UP ? DOWN : UP // switch directions!
		to_chat(user, span("notice", "You switch the direction of the pulley."))
		return

	if (!hoistee)
		user.visible_message(span("notice", "[user] begins to [movtext] the clamp."), span("notice", "You begin to [movtext] the clamp."), span("notice", "You hear the sound of a crank."))
		movedir == UP ? raise(0) : lower(0)
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
		movedir == UP ? raise(1) : lower(1)

/obj/structure/hoist/verb/collapse_hoist()
	set name = "Collapse Hoist"
	set category = "Object"
	set src = orange(1) // note: object-range, not the colour

	if (isobserver(usr))
		return
	if (!usr.IsAdvancedToolUser()) // thanks nanacode
		to_chat(usr, span("notice", "You stare cluelessly at \the [src]."))
		return

	if (hoistee)
		to_chat(usr, span("notice", "You cannot collapse the hoist with \the [hoistee] attached!"))
		return
	QDEL_NULL(src.source_hook)
	new /obj/item/hoist_kit(get_turf(src))
	qdel(src)

/obj/structure/hoist/proc/can_raise()
	var/turf/above = GetAbove(source_hook)
	if (!above) // can't move if there's nothing to move to
		return 0
	if (!istype(above, /turf/simulated/open)) // can't move into a solid tile
		return 0
	if (source_hook in get_step(src, dir)) // you don't get to move above the hoist
		return 0
	return 1

/obj/structure/hoist/proc/can_lower()
	var/turf/below = GetBelow(source_hook)
	if (!below) // can't move if there's nothing to move to
		return 0
	if (!istype(get_turf(source_hook), /turf/simulated/open)) // can't move down through a solid tile
		return 0
	return 1

/obj/structure/hoist/proc/raise(ishoisting)
	var/can = can_raise()
	var/turf/simulated/open/above = GetAbove(source_hook)
	if (!can)
		return 0
	source_hook.forceMove(above)
	if(!ishoisting)
		return 1
	hoistee.forceMove(above)
	return 1

/obj/structure/hoist/proc/lower(ishoisting)
	var/can = can_lower()
	var/turf/below = GetBelow(source_hook)
	if (!can) // no more magic disappearing acts
		return 0
	source_hook.forceMove(below)
	if (!ishoisting)
		return 1
	hoistee.forceMove(below)
	return 1