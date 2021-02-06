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
	if(can_buckle && (buckled_mob || buckled_bag))
		user_unbuckle(user)

/obj/MouseDrop_T(atom/movable/MA, mob/living/user)
	. = ..()
	if(can_buckle && (istype(MA, /mob/living) || istype(MA, /obj/structure/closet/body_bag)))
		user_buckle(MA, user)

//Cleanup

/obj/Destroy()
	unbuckle()
	return ..()


/obj/proc/buckle(atom/movable/MA)
	var/mob/living/M
	var/obj/structure/closet/body_bag/B
	if ((MA.loc != loc) && !(density && get_dist(src, MA) <= 1))
		return 0
	if (MA.loc != loc)
		MA.forceMove(loc)
	if (istype(MA, /mob/living))
		M = MA
		if(!can_buckle || M.buckled || M.pinned.len || (buckle_require_restraints && !M.restrained()))
			return 0
		M.buckled = src
		M.facing_dir = null
		M.set_dir(buckle_dir ? buckle_dir : dir)
		M.update_canmove()
		buckled_mob = M
	else if (istype(MA, /obj/structure/closet/body_bag))
		B = MA
		if(!can_buckle || B.buckled)
			return 0
		B.buckled = src
		buckled_bag = B
		B.anchored = TRUE
		B.opened = FALSE
	else
		return 0
	post_buckle(MA)
	return 1

/obj/proc/unbuckle()
	var/atom/movable/MA = buckled_mob ? buckled_mob : buckled_bag
	if(MA && MA.buckled == src)
		. = MA
		MA.buckled = null
		MA.anchored = initial(buckled_mob.anchored)
		buckled_mob = null
		buckled_bag = null
		if(MA == buckled_mob)
			buckled_mob.update_canmove()
		post_buckle(.)

/obj/proc/post_buckle(atom/movable/MA)
	return

/obj/proc/user_buckle(atom/movable/MA, mob/user)
	if(!ROUND_IS_STARTED)
		to_chat(user, SPAN_WARNING("You can't buckle anything in before the game starts."))
	if(!user.Adjacent(MA) || user.restrained() || user.stat || istype(user, /mob/living/silicon/pai))
		return
	if(!MA.can_be_buckled)
		to_chat(user, SPAN_WARNING("\The [MA] can't be buckled!"))
		return
	if(MA == buckled_mob)
		return
	if(istype(MA, /mob/living/carbon/slime))
		to_chat(user, SPAN_WARNING("\The [MA] is too squishy to buckle in."))
		return
	if(buckled_mob || buckled_bag)
		to_chat(user, SPAN_WARNING("\The [buckled_mob ? buckled_mob.name : buckled_bag.name] is already there, unbuckle [buckled_mob ? "them" : "it"] first!."))
		return

	add_fingerprint(user)
	unbuckle()//this is now just for safety, buckling someone into an occupied chair will fail, instead of removing the occupant

	if(buckle(MA))
		if(MA == user)
			MA.visible_message(\
				"<b>[MA.name]</b> buckles themselves to [src].",\
				"<span class='notice'>You buckle yourself to [src].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		else
			MA.visible_message(\
				"<span class='danger'>[MA.name] is buckled to [src] by [user.name]!</span>",\
				"<span class='danger'>You are buckled to [src] by [user.name]!</span>",\
				"<span class='notice'>You hear metal clanking.</span>")

/obj/proc/user_unbuckle(mob/user)
	var/atom/movable/MA = unbuckle()
	if(MA)
		if(MA != user)
			MA.visible_message(\
				"<b>[user.name]</b> unbuckles [MA.name].", \
				"<span class='notice'>You were unbuckled from [src] by [user.name].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		else
			MA.visible_message(\
				"<b>[MA.name]</b> unbuckles themselves.",\
				"<span class='notice'>You unbuckle yourself from [src].</span>",\
				"<span class='notice'>You hear metal clanking.</span>")
		add_fingerprint(user)
	return MA
