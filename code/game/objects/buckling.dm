/obj
	var/can_buckle = 0
	var/can_buckle_bags = 0
	var/buckle_movable = 0
	var/buckle_dir = 0
	var/buckle_lying = -1 //bed-like behavior, forces mob.lying = buckle_lying if != -1
	var/buckle_require_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
	var/mob/living/buckled_mob = null
	var/obj/structure/closet/body_bag/buckled_bag = null

/obj/attack_hand(mob/living/user)
	. = ..()
	if(can_buckle && buckled_mob)
		user_unbuckle_mob(user)
	else if(can_buckle && buckled_bag)
		user_unbuckle_bag(user)

/obj/MouseDrop_T(atom/A, mob/living/user)
	. = ..()
	if(can_buckle && istype(A, /mob/living))
		user_buckle_mob(A, user)
	else if (can_buckle_bags && istype(A, /obj/structure/closet/body_bag))
		user_buckle_bag(A, user)

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
	if(!M.can_be_buckled)
		to_chat(user, SPAN_WARNING("\The [M] can't be buckled!"))
		return
	if(M == buckled_mob)
		return
	if(istype(M, /mob/living/carbon/slime))
		to_chat(user, SPAN_WARNING("\The [M] is too squishy to buckle in."))
		return
	if(buckled_mob || buckled_bag)
		to_chat(user, SPAN_WARNING("\The [buckled_mob ? buckled_mob.name : buckled_bag.name] is already there, unbuckle [buckled_mob ? "them" : "it"] first!."))
		return

	add_fingerprint(user)
	unbuckle_mob()//this is now just for safety, buckling someone into an occupied chair will fail, instead of removing the occupant
	unbuckle_bag()

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

/obj/proc/buckle_bag(obj/structure/closet/body_bag/B)
	if(!can_buckle || !istype(B) || B.buckled)
		return 0

	if ((B.loc != loc) && !(density && get_dist(src, B) <= 1))
		return 0

	if (B.loc != loc)
		B.forceMove(loc)
	B.buckled = src
	buckled_bag = B
	B.anchored = TRUE
	B.opened = FALSE
	post_buckle_bag(B)
	return 1

/obj/proc/unbuckle_bag()
	if(buckled_bag && buckled_bag.buckled == src)
		. = buckled_bag
		buckled_bag.buckled = null
		buckled_bag.anchored = initial(buckled_bag.anchored)
		buckled_bag = null

		post_buckle_bag(.)

/obj/proc/post_buckle_bag(obj/structure/closet/body_bag/B)
	return

/obj/proc/user_buckle_bag(obj/structure/closet/body_bag/B, mob/user)
	if(!ROUND_IS_STARTED)
		to_chat(user, SPAN_WARNING("You can't buckle anything in before the game starts."))
	if(!user.Adjacent(B) || user.restrained() || user.stat || istype(user, /mob/living/silicon/pai))
		to_chat(user, SPAN_WARNING("COMPLICATED STUFF"))
		return
	if(!B.can_be_buckled)
		to_chat(user, SPAN_WARNING("\The [B] can't be buckled!"))
		return
	if(B == buckled_bag)
		to_chat(user, SPAN_WARNING("ALREADY BUCKLED"))
		return
	if(buckled_mob || buckled_bag)
		to_chat(user, SPAN_WARNING("\The [buckled_mob ? buckled_mob.name : buckled_bag.name] is already there, unbuckle [buckled_mob ? "them" : "it"] first!."))
		return

	add_fingerprint(user)
	unbuckle_mob()//this is now just for safety, buckling someone into an occupied chair will fail, instead of removing the occupant
	unbuckle_bag()

	if(buckle_bag(B))
		user.visible_message(\
			SPAN_DANGER("\The [B.name] is buckled to [src] by [user.name]."),\
			SPAN_NOTICE("You buckled \the [B.name] to [src]."),\
			SPAN_NOTICE("You hear metal clanking.</span>"))

/obj/proc/user_unbuckle_bag(mob/user)
	var/obj/structure/closet/body_bag/B = unbuckle_bag()
	if(B)
		user.visible_message(\
			"<b>[user.name]</b> unbuckles \the [B.name].",\
			SPAN_NOTICE("You unbuckled \the [B.name]."),\
			SPAN_NOTICE("You hear metal clanking."))
		add_fingerprint(user)
	return B