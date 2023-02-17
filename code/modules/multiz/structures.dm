//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/obj/structure/ladder
	name = "ladder"
	desc = "A ladder. You can climb it up and down."
	icon_state = "ladder01"
	icon = 'icons/obj/structures.dmi'
	density = 0
	opacity = 0
	anchored = 1

	var/allowed_directions = DOWN
	var/obj/structure/ladder/target_up
	var/obj/structure/ladder/target_down
	var/base_icon = "ladder"

	var/const/climb_time = 2 SECONDS
	var/list/climbsounds = list('sound/effects/ladder1.ogg','sound/effects/ladder2.ogg','sound/effects/ladder3.ogg','sound/effects/ladder4.ogg')
	var/climb_sound_vol = 50
	var/climb_sound_vary = FALSE

	var/list/destroy_tools

/obj/structure/ladder/mining
	icon = 'icons/obj/mining.dmi'
	climbsounds = list('sound/effects/stonedoor_openclose.ogg')
	climb_sound_vol = 30
	climb_sound_vary = TRUE
	destroy_tools = list(/obj/item/pickaxe, /obj/item/gun/energy/plasmacutter)

/obj/structure/ladder/Initialize()
	. = ..()
	// the upper will connect to the lower
	if(allowed_directions & DOWN) //we only want to do the top one, as it will initialize the ones before it.
		for(var/obj/structure/ladder/L in GetBelow(src))
			if(L.allowed_directions & UP)
				target_down = L
				L.target_up = src

				L.update_icon()
				break

	AddComponent(/datum/component/turf_hand)

	update_icon()

/obj/structure/ladder/Destroy()
	if(target_down)
		target_down.target_up = null
		target_down = null
	if(target_up)
		target_up.target_down = null
		target_up = null
	return ..()

/obj/structure/ladder/attackby(obj/item/C, mob/user)
	if(LAZYLEN(destroy_tools))
		if(is_type_in_list(C, destroy_tools))
			user.visible_message("<b>[user]</b> starts breaking down \the [src] with \the [C]!", SPAN_NOTICE("You start breaking down \the [src] with \the [C]."))
			if(do_after(user, 10 SECONDS, TRUE))
				user.visible_message("<b>[user]</b> breaks down \the [src] with \the [C]!", SPAN_NOTICE("You break down \the [src] with \the [C]."))
				qdel(src)
			return
	attack_hand(user)

/obj/structure/ladder/attack_robot(mob/user)
	attack_hand(user)

/obj/structure/ladder/attack_hand(var/mob/M)
	if(!M.may_climb_ladders(src))
		return

	var/obj/structure/ladder/target_ladder = getTargetLadder(M)
	if(!target_ladder)
		return

	var/obj/item/grab/G = M.l_hand
	if (!istype(G))
		G = M.r_hand

	if(!M.Move(get_turf(src)))
		to_chat(M, "<span class='notice'>You fail to reach \the [src].</span>")
		return

	if (istype(G))
		G.affecting.forceMove(get_turf(src))

	var/direction = target_ladder == target_up ? "up" : "down"

	M.visible_message("<span class='notice'>\The [M] begins climbing [direction] \the [src]!</span>",
	"You begin climbing [direction] \the [src]!",
	"You hear the grunting and clanging of a metal ladder being used.")

	target_ladder.audible_message("<span class='notice'>You hear something coming [direction] \the [src]</span>")

	if(do_after(M, istype(G) ? (climb_time*2) : climb_time))
		climbLadder(M, target_ladder)

/obj/structure/ladder/attack_ghost(var/mob/M)
	var/target_ladder = getTargetLadder(M)
	if(target_ladder)
		M.forceMove(get_turf(target_ladder))

/obj/structure/ladder/proc/getTargetLadder(var/mob/M)
	if((!target_up && !target_down) || (target_up && !istype(target_up.loc, /turf) || (target_down && !istype(target_down.loc,/turf))))
		to_chat(M, "<span class='notice'>\The [src] is incomplete and can't be climbed.</span>")
		return
	if(target_down && target_up)
		var/direction = alert(M,"Do you want to go up or down?", "Ladder", "Up", "Down", "Cancel")

		if(direction == "Cancel")
			return

		if(!M.may_climb_ladders(src))
			return

		switch(direction)
			if("Up")
				return target_up
			if("Down")
				return target_down
	else
		return target_down || target_up

/mob/proc/may_climb_ladders(var/ladder)
	if(!Adjacent(ladder))
		to_chat(src, "<span class='warning'>You need to be next to \the [ladder] to start climbing.</span>")
		return FALSE
	if(incapacitated())
		to_chat(src, "<span class='warning'>You are physically unable to climb \the [ladder].</span>")
		return FALSE
	return TRUE

/mob/living/silicon/may_climb_ladders(ladder)
	to_chat(src, "<span class='warning'>You're too heavy to climb [ladder]!</span>")
	return FALSE

/mob/living/silicon/robot/drone/may_climb_ladders(ladder)
	if(!Adjacent(ladder))
		to_chat(src, "<span class='warning'>You need to be next to \the [ladder] to start climbing.</span>")
		return FALSE
	if(incapacitated())
		to_chat(src, "<span class='warning'>You are physically unable to climb \the [ladder].</span>")
		return FALSE
	return TRUE

/mob/abstract/observer/may_climb_ladders(var/ladder)
	return TRUE

/obj/structure/ladder/proc/climbLadder(var/mob/M, var/target_ladder)
	if(!target_ladder)
		return
	var/turf/T = get_turf(target_ladder)
	var/turf/LAD = get_turf(src)
	var/direction = UP
	if(istype(target_ladder, target_down))
		direction = DOWN
	if(!LAD.CanZPass(M, direction))
		to_chat(M, "<span class='notice'>\The [LAD.GetZPassBlocker()] is blocking \the [src].</span>")
		return FALSE
	if(!T.CanZPass(M, direction))
		to_chat(M, "<span class='notice'>\The [T.GetZPassBlocker()] is blocking \the [src].</span>")
		return FALSE
	for(var/atom/A in T)
		if(!isliving(A))
			if(!A.CanPass(M, M.loc, 1.5, 0))
				to_chat(M, "<span class='notice'>\The [A] is blocking \the [src].</span>")
				return FALSE
	playsound(src, pick(climbsounds), climb_sound_vol, climb_sound_vary)
	playsound(target_ladder, pick(climbsounds), climb_sound_vol, climb_sound_vary)
	var/obj/item/grab/G = M.l_hand
	if (!istype(G))
		G = M.r_hand
	if (istype(G))
		G.affecting.forceMove(T)
	return M.forceMove(T)

/obj/structure/ladder/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

/obj/structure/ladder/update_icon()
	icon_state = "[base_icon][!!(allowed_directions & UP)][!!(allowed_directions & DOWN)]"

/obj/structure/ladder/up
	allowed_directions = UP
	icon_state = "ladder10"

/obj/structure/ladder/up/mining
	icon = 'icons/obj/mining.dmi'
	climbsounds = list('sound/effects/stonedoor_openclose.ogg')
	climb_sound_vol = 30
	climb_sound_vary = TRUE
	destroy_tools = list(/obj/item/pickaxe, /obj/item/gun/energy/plasmacutter)

/obj/structure/ladder/updown
	allowed_directions = UP|DOWN
	icon_state = "ladder11"

// Stairs
/obj/structure/ladder/away //a ladder that just looks like it's going down
	icon_state = "ladderawaydown"

/obj/structure/stairs
	name = "stairs"
	desc = "Stairs leading to another floor. Not too useful if the gravity goes out."
	icon = 'icons/obj/stairs.dmi'
	icon_state = "solid"
	layer = TURF_LAYER
	density = FALSE
	opacity = FALSE
	anchored = TRUE

/obj/structure/stairs/Initialize()
	. = ..()
	for(var/turf/turf in locs)
		var/turf/simulated/open/above = GetAbove(turf)
		if(!above)
			warning("Stair created without z-level above: ([loc.x], [loc.y], [loc.z])")
			return qdel(src)
		if(!istype(above))
			above.ChangeToOpenturf()

/obj/structure/stairs/CheckExit(atom/movable/mover, turf/target)
	if(get_dir(loc, target) == dir && upperStep(mover.loc))
		return FALSE

	var/obj/structure/stairs/staircase = locate() in target
	var/target_dir = get_dir(mover, target)
	if(!staircase && (target_dir != dir && target_dir != reverse_dir[dir]))
		INVOKE_ASYNC(src, PROC_REF(mob_fall), mover)

	return ..()

/obj/structure/stairs/CollidedWith(atom/movable/A)
	// This is hackish but whatever.
	var/turf/target = get_step(GetAbove(A), dir)
	if(target.Enter(A, src))
		A.forceMove(target)
		if(isliving(A))
			var/mob/living/L = A
			if(L.pulling)
				L.pulling.forceMove(target)
			if(ishuman(A))
				playsound(src, 'sound/effects/stairs_step.ogg', 50)
				playsound(target, 'sound/effects/stairs_step.ogg', 50)

/obj/structure/stairs/proc/upperStep(var/turf/T)
	return (T == loc)

/obj/structure/stairs/CanPass(obj/mover, turf/source, height, airflow)
	if (airflow)
		return TRUE

	// Disallow stepping onto the elevated part of the stairs.
	if (isliving(mover) && z == mover.z && mover.loc != loc && get_step(mover, get_dir(mover, src)) == loc)
		return FALSE

	return !density

/obj/structure/stairs/proc/mob_fall(mob/living/L)
	if(isopenturf(L.loc) || get_turf(L) == get_turf(src) || !ishuman(L))
		return

	L.Weaken(2)
	if (L.lying)
		L.visible_message(
			"<span class='alert'>\The [L] steps off of [src] and faceplants onto [L.loc].</span>",
			"<span class='danger'>You step off [src] and faceplant onto [L.loc].</span>",
			"<span class='alert'>You hear a thump.</span>"
		)

/obj/structure/stairs/north
	dir = NORTH
	bound_height = 64
	bound_y = -32
	pixel_y = -32

/obj/structure/stairs/south
	dir = SOUTH
	bound_height = 64

/obj/structure/stairs/east
	dir = EAST
	bound_width = 64
	bound_x = -32
	pixel_x = -32

/obj/structure/stairs/west
	dir = WEST
	bound_width = 64
