/obj
	var/can_buckle = 0
	var/buckle_movable = 0
	var/buckle_dir = 0
	var/buckle_lying = -1 //bed-like behavior, forces mob.lying = buckle_lying if != -1
	var/buckle_require_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
	var/mob/living/buckled_mob = null

/obj/attack_hand(mob/living/user)
	. = ..()
	if(can_buckle && buckled_mob)
		user_unbuckle_mob(user)

/obj/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(can_buckle && istype(M))
		user_buckle_mob(M, user)

//Cleanup

/obj/Destroy()
	unbuckle_mob()
	return ..()


/obj/proc/buckle_mob(mob/living/M)
	if(!can_buckle || !istype(M) || M.buckled || M.pinned.len || (buckle_require_restraints && !M.restrained()))
		return 0

	if ((M.loc != loc) && !(density && get_dist(src, M) <= 1))
		return 0

	if (M.loc != loc)
		M.forceMove(loc)
	M.buckled = src
	M.facing_dir = null
	M.set_dir(buckle_dir ? buckle_dir : dir)
	M.update_canmove()
	buckled_mob = M
	post_buckle_mob(M)
	return 1

/obj/proc/unbuckle_mob()
	if(buckled_mob && buckled_mob.buckled == src)
		. = buckled_mob
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.update_canmove()
		buckled_mob = null

		post_buckle_mob(.)

/obj/proc/post_buckle_mob(mob/living/M)
	return

/obj/proc/user_buckle_mob(mob/living/M, mob/user)
	if(!ROUND_IS_STARTED)
		to_chat(user, SPAN_WARNING("You can't buckle anyone in before the game starts."))
	if(!user.Adjacent(M) || user.restrained() || user.stat || istype(user, /mob/living/silicon/pai))
		return
	if(!M.can_buckle)
		to_chat(user, SPAN_WARNING("\The [M] can't be buckled!"))
		return
	if(M == buckled_mob)
		return
	if(istype(M, /mob/living/carbon/slime))
		to_chat(user, SPAN_WARNING("\The [M] is too squishy to buckle in."))
		return
	if(buckled_mob)
		to_chat(user, SPAN_WARNING("\The [buckled_mob.name] is already there, unbuckle them first!."))
		return

	add_fingerprint(user)
	unbuckle_mob()//this is now just for safety, buckling someone into an occupied chair will fail, instead of removing the occupant

	if(buckle_mob(M))
		if(M == user)
			M.visible_message(\
				"<b>[M.name]</b> buckles themselves to [src].",\
				"<span class='notice'>You buckle yourself to [src].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		else
			M.visible_message(\
				"<span class='danger'>[M.name] is buckled to [src] by [user.name]!</span>",\
				"<span class='danger'>You are buckled to [src] by [user.name]!</span>",\
				"<span class='notice'>You hear metal clanking.</span>")

/obj/proc/user_unbuckle_mob(mob/user)
	var/mob/living/M = unbuckle_mob()
	if(M)
		if(M != user)
			M.visible_message(\
				"<b>[user.name]</b> unbuckles [M.name].", \
				"<span class='notice'>You were unbuckled from [src] by [user.name].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		else
			M.visible_message(\
				"<b>[M.name]</b> unbuckles themselves.",\
				"<span class='notice'>You unbuckle yourself from [src].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		add_fingerprint(user)
	return M

