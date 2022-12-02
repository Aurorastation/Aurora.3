/obj
	var/list/can_buckle
	var/buckle_movable = 0
	var/buckle_dir = 0
	var/buckle_lying = -1 //bed-like behavior, forces mob.lying = buckle_lying if != -1
	var/buckle_require_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
	var/atom/movable/buckled = null
	var/buckle_delay = 0 //How much extra time to buckle someone to this object.

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


/obj/proc/buckle(atom/movable/MA, mob/user)
	if ((MA.loc != loc) && !(density && get_dist(src, MA) <= 1))
		return 0
	if (MA.loc != loc)
		MA.forceMove(loc)
	if (is_type_in_list(MA, can_buckle))
		if(!(MA.can_be_buckled) || MA.buckled_to)
			return 0
		if(user)
			if(MA != user)
				if(isliving(MA))
					var/mob/living/L = MA
					if(!L.lying)
						if(!do_mob(user, L, 3 SECONDS))
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
	MA.layer = src.layer + 0.1
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
	if(buckle_delay)
		if(MA == user)
			MA.visible_message(\
				"<b>[MA.name]</b> starts buckling themselves to [src].",\
				SPAN_NOTICE("You start buckling yourself to [src]."),\
				SPAN_NOTICE("You hear metal clanking."))
		else if(isliving(MA))
			MA.visible_message(\
				SPAN_DANGER("[MA.name] is starting to be buckled to [src] by [user.name]!"),\
				SPAN_DANGER("You are starting to be buckled to [src] by [user.name]!"),\
				SPAN_NOTICE("You hear metal clanking."))
		else
			MA.visible_message(\
				SPAN_DANGER("\The [MA] is starting to be buckled to [src] by [user.name]!"),\
				SPAN_NOTICE("You hear metal clanking."))
				
		if(!do_after(user, buckle_delay, src))
			return
	if(buckle(MA, user))
		if(MA == user)
			MA.visible_message(\
				"<b>[MA.name]</b> buckles themselves to [src].",\
				SPAN_NOTICE("You buckle yourself to [src]."),\
				SPAN_NOTICE("You hear metal clanking."))
		else if(isliving(MA))
			MA.visible_message(\
				SPAN_DANGER("[MA.name] is buckled to [src] by [user.name]!"),\
				SPAN_DANGER("You are buckled to [src] by [user.name]!"),\
				SPAN_NOTICE("You hear metal clanking."))
		else
			MA.visible_message(\
				SPAN_DANGER("\The [MA] is buckled to [src] by [user.name]!"),\
				SPAN_NOTICE("You hear metal clanking."))

/obj/proc/user_unbuckle(mob/user)
	var/atom/movable/MA = unbuckle()
	if(MA)
		if(MA == user)
			MA.visible_message(\
				"<b>[MA.name]</b> unbuckles themselves.",\
				SPAN_NOTICE("You unbuckle yourself from [src]."),\
				SPAN_NOTICE("You hear metal clanking."))
		else if(isliving(MA))
			MA.visible_message(\
				"<b>[user.name]</b> unbuckles [MA.name].", \
				SPAN_NOTICE("You were unbuckled from [src] by [user.name]."),\
				SPAN_NOTICE("You hear metal clanking."))
		else
			MA.visible_message(\
				"<b>[MA.name]</b> unbuckles themselves.",\
				SPAN_NOTICE("You hear metal clanking."))
		add_fingerprint(user)
	return MA
