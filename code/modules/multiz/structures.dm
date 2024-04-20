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

/obj/structure/ladder/attackby(obj/item/attacking_item, mob/user)
	if(LAZYLEN(destroy_tools))
		if(is_type_in_list(attacking_item, destroy_tools))
			user.visible_message("<b>[user]</b> starts breaking down \the [src] with \the [attacking_item]!", SPAN_NOTICE("You start breaking down \the [src] with \the [attacking_item]."))
			if(do_after(user, 10 SECONDS, src, DO_REPAIR_CONSTRUCT))
				user.visible_message("<b>[user]</b> breaks down \the [src] with \the [attacking_item]!", SPAN_NOTICE("You break down \the [src] with \the [attacking_item]."))
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

/obj/structure/ladder/away //a ladder that just looks like it's going down
	icon_state = "ladderawaydown"

/**
 * #Stairs
 *
 * Stairs allow you to traverse up and down between Z-levels
 *
 * They _MUST_ follow this bound rules:
 *
 * -If facing NORTH: `bound_height` to 64 and `bound_y` to -32
 *
 * -If facing SOUTH: `bound_height` to 64
 *
 * -If facing EAST: `bound_width` to 64 and `bound_x` to -32
 *
 * -If facing WEST: `bound_width` to 64
 *
 * No other bounds should be set on them except the ones described above
 *
 * A subtype must be defined, and those bounds set in code. DO NOT SET IT ON THE MAP ITSELF!
 *
 * Note that stairs facing left/right may need the stairs_lower structure if they're not placed against walls
 */
/obj/structure/stairs
	name = "stairs"
	desc = "Stairs leading to another floor. Not too useful if the gravity goes out."
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs_3d"
	layer = RUNE_LAYER
	density = FALSE
	opacity = FALSE
	anchored = TRUE

	can_astar_pass = CANASTARPASS_ALWAYS_PROC

/obj/structure/stairs/Initialize()
	. = ..()
	for(var/turf/turf in locs)
		var/turf/simulated/open/above = GetAbove(turf)
		if(!above)
			log_asset("Stair created without z-level above: ([loc.x], [loc.y], [loc.z])")
			return INITIALIZE_HINT_QDEL
		if(!istype(above))
			above.ChangeToOpenturf()

/obj/structure/stairs/CheckExit(atom/movable/mover, turf/target)
	if(get_dir(loc, target) == dir && upperStep(mover.loc))
		return FALSE

	var/obj/structure/stairs/staircase = locate() in target
	var/target_dir = get_dir(mover, target)
	if(!staircase && (target_dir != dir && target_dir != GLOB.reverse_dir[dir]))
		INVOKE_ASYNC(src, PROC_REF(mob_fall), mover)

	return ..()

/obj/structure/stairs/CollidedWith(atom/movable/moving_atom)
	// This is hackish but whatever.
	var/turf/target = get_step(GetAbove(moving_atom), dir)
	if(!target)
		return
	if(target.z > (z + 1)) //Prevents wheelchair fuckery. Basically, you teleport twice because both the wheelchair + your mob collide with the stairs.
		return
	if(target.Enter(moving_atom, src) && moving_atom.dir == dir)
		moving_atom.forceMove(target)
		if(isliving(moving_atom))
			var/mob/living/living_mob = moving_atom
			if(living_mob.pulling)
				living_mob.pulling.forceMove(target)
			for(var/obj/item/grab/grab in living_mob)
				if(grab.affecting)
					grab.affecting.forceMove(target)
			if(ishuman(living_mob))
				playsound(src, 'sound/effects/stairs_step.ogg', 50)
				playsound(target, 'sound/effects/stairs_step.ogg', 50)

/obj/structure/stairs/proc/upperStep(var/turf/T)
	return (T == loc)

/obj/structure/stairs/CanPass(obj/mover, turf/source, height, airflow)
	if(airflow)
		return TRUE

	// Disallow stepping onto the elevated part of the stairs.
	if(isliving(mover) && z == mover.z && mover.loc != loc && get_step(mover, get_dir(mover, src)) == loc)
		return FALSE

	return !density

/obj/structure/stairs/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	return FALSE //I do not want to deal with stairs and the snowflake passcode, they can be unmovable walls for all I care here

/obj/structure/stairs/proc/mob_fall(mob/living/L)
	if(isopenturf(L.loc) || get_turf(L) == get_turf(src) || !ishuman(L))
		return

	L.Weaken(2)
	if(L.lying)
		L.visible_message(
			SPAN_ALERT("\The [L] steps off of [src] and faceplants onto [L.loc]."),
			SPAN_DANGER("You step off [src] and faceplant onto [L.loc]."),
			SPAN_ALERT("You hear a thump.")
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

/// Snowflake railing object for 64x64 stairs.
/obj/structure/stairs_railing
	name = "railing"
	desc = "A railing for stairs."
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs_railing"
	anchored = TRUE
	density = TRUE

/obj/structure/stairs_railing/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item/projectile))
		return TRUE
	if(!istype(mover) || mover.checkpass(PASSRAILING))
		return TRUE
	if(mover.throwing)
		return TRUE
	if(get_dir(loc, target) == dir)
		return !density
	return TRUE

/obj/structure/stairs_railing/CheckExit(var/atom/movable/O, var/turf/target)
	if(istype(O) && CanPass(O, target))
		return TRUE
	if(get_dir(O.loc, target) == dir)
		if(!density)
			return TRUE
		return FALSE
	return TRUE

/obj/structure/stairs_lower
	name = "stairs"
	desc = "Stairs leading to another floor. Not too useful if the gravity goes out."
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs_lower"
	anchored = TRUE
	density = FALSE

/obj/structure/stairs_lower/stairs_upper
	icon_state = "stairs_upper"

/// These stairs are used for fake depth. They don't go up z-levels.
/obj/structure/platform_stairs
	name = "stairs"
	desc = "An archaic form of locomotion along the Z-axis."
	density = FALSE
	anchored = TRUE
	icon = 'icons/obj/structure/stairs.dmi'
	icon_state = "np_stair"

/obj/structure/platform_stairs/south_north_solo
	icon_state = "p_stair_sn_solo_cap"

/obj/structure/platform_stairs/full
	icon_state = "p_stair_full"

/obj/structure/platform_stairs/full/east_west_cap
	icon_state = "p_stair_ew_full_cap"

/obj/structure/platform_stairs/full/east_west_cap/half
	icon_state = "p_stair_ew_half_cap"

/obj/structure/platform_stairs/full/south_north_cap
	icon_state = "p_stair_sn_full_cap"

/obj/structure/platform_stairs/full/south_north_cap/half
	icon_state = "p_stair_sn_half_cap"

/obj/structure/platform
	name = "platform"
	desc = "An archaic method of preventing travel along the X and Y axes if you are on a lower point on the Z-axis."
	icon = 'icons/obj/structure/platforms.dmi'
	icon_state = "platform"
	density = TRUE
	anchored = TRUE
	atom_flags = ATOM_FLAG_CHECKS_BORDER|ATOM_FLAG_ALWAYS_ALLOW_PICKUP
	climbable = TRUE
	color = COLOR_TILED

/obj/structure/platform/dark
	icon_state = "platform_dark"
	color = COLOR_DARK_GUNMETAL

/obj/structure/platform/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(istype(mover, /obj/item/projectile))
		return TRUE
	if(!istype(mover) || mover.checkpass(PASSRAILING))
		return TRUE
	if(mover.throwing)
		return TRUE
	if(get_dir(mover, target) == GLOB.reverse_dir[dir])
		return FALSE
	if(height && (mover.dir == dir))
		return FALSE
	return TRUE

/obj/structure/platform/CheckExit(var/atom/movable/O, var/turf/target)
	if(istype(O) && CanPass(O, target))
		return TRUE
	if(get_dir(O, target) == GLOB.reverse_dir[dir])
		return FALSE
	return TRUE

/obj/structure/platform/do_climb(mob/living/user)
	if(user.Adjacent(src) && !user.incapacitated())
		/// Custom climbing code because normal climb code doesn't support the tile-shifting that platforms do.
		/// If the user is on the same turf as the platform, we're trying to go past it, so we need to use reverse_dir.
		/// Otherwise, use our own turf.
		var/same_turf = get_turf(user) == get_turf(src)
		var/turf/next_turf = get_step(src, same_turf ? GLOB.reverse_dir[dir] : 0)
		if(istype(next_turf) && !next_turf.density && can_climb(user))
			var/climb_text = same_turf ? "over" : "down"
			LAZYADD(climbers, user)
			user.visible_message(SPAN_NOTICE("[user] starts climbing [climb_text] \the [src]..."), SPAN_NOTICE("You start climbing [climb_text] \the [src]..."))
			if(do_after(user, 1 SECOND) && can_climb(user, TRUE))
				user.visible_message(SPAN_NOTICE("[user] climbs [climb_text] \the [src]."), SPAN_NOTICE("You climb [climb_text] \the [src]."))
				user.forceMove(next_turf)
				LAZYREMOVE(climbers, user)

/obj/structure/platform/ledge
	icon_state = "ledge"

/obj/structure/platform/ledge/dark
	icon_state = "ledge_dark"
	color = COLOR_DARK_GUNMETAL

/obj/structure/platform/cutout
	icon_state = "platform_cutout"
	density = 0

/obj/structure/platform/cutout/dark
	icon_state = "platform_cutout_dark"
	color = COLOR_DARK_GUNMETAL

/obj/structure/platform/cutout/CanPass()
	return TRUE

/// No special CanPass for this one.
/obj/structure/platform_deco
	name = "platform"
	desc = "This is a platform."
	anchored = TRUE
	icon = 'icons/obj/structure/platforms.dmi'
	icon_state = "platform_deco"
	color = COLOR_TILED

/obj/structure/platform_deco/dark
	icon_state = "platform_deco_dark"
	color = COLOR_DARK_GUNMETAL

/obj/structure/platform_deco/ledge
	icon_state = "ledge_deco"

/obj/structure/platform_deco/ledge/dark
	icon_state = "ledge_deco_dark"
	color = COLOR_DARK_GUNMETAL
