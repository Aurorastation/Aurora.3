/obj
	var/list/can_buckle = list()
	var/buckle_movable = 0
	var/buckle_dir = 0
	var/buckle_lying = -1 //bed-like behavior, forces mob.lying = buckle_lying if != -1
	var/buckle_require_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
	var/atom/movable/buckled = null

/obj/attack_hand(mob/living/user)
	. = ..()
	if(buckled)
		user_unbuckle(user)

/obj/MouseDrop_T(atom/movable/MA, mob/living/user)
	. = ..()
	if(is_type_in_list(MA, can_buckle))
		user_buckle(MA, user)

//Cleanup

/obj/Destroy()
	unbuckle()
	return ..()


/obj/proc/buckle(atom/movable/MA)
	if ((MA.loc != loc) && !(density && get_dist(src, MA) <= 1))
		return 0
	if (MA.loc != loc)
		MA.forceMove(loc)
	if (is_type_in_list(MA, can_buckle))
		if(!(MA.can_be_buckled) || MA.buckled_to)
			return 0
		MA.buckled_to = src
		buckled = MA
		if(istype(MA, /mob/living))
			var/mob/living/M = MA
			if(M.pinned.len || (buckle_require_restraints && !M.restrained()))
				return 0
			M.set_dir(buckle_dir ? buckle_dir : dir)
			M.facing_dir = null
			M.update_canmove()
		else
			MA.anchored = TRUE	
	else
		return 0
	post_buckle(MA)
	MA.layer = src.layer + 1
	return 1

/obj/proc/unbuckle()
	var/atom/movable/MA = buckled
	if(MA && MA.buckled_to == src)
		. = MA
		MA.buckled_to = null
		MA.anchored = initial(MA.anchored)
		buckled = null
		if(istype(MA, /mob/living))
			var/mob/living/M = MA
			M.update_canmove()
		post_buckle(.)

/obj/proc/post_buckle(atom/movable/MA)
	return

/obj/proc/user_buckle(atom/movable/MA, mob/user)
	if(!ROUND_IS_STARTED)
		to_chat(user, SPAN_WARNING("You can't buckle anything in before the game starts."))
	if(!user.Adjacent(MA) || user.restrained() || user.stat || istype(user, /mob/living/silicon/pai))
		return
	if(!MA.can_be_buckled)
		to_chat(user, SPAN_WARNING("\The [MA] can't be buckled_to!"))
		return
	if(MA == buckled)
		return
	if(istype(MA, /mob/living/carbon/slime))
		to_chat(user, SPAN_WARNING("\The [MA] is too squishy to buckle in."))
		return
	if(buckled)
		to_chat(user, SPAN_WARNING("\The [buckled.name] is already there, unbuckle [istype(buckled, /mob/living) ? "them" : "it"] first!."))
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
				"<span class='danger'>[MA.name] is buckled_to to [src] by [user.name]!</span>",\
				"<span class='danger'>You are buckled_to to [src] by [user.name]!</span>",\
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
