/obj/structure/bed/chair/wheelchair
	name = "wheelchair"
	desc = "You sit in this. Either by will or force."
	icon_state = "wheelchair"
	anchored = 0
	buckle_movable = 1

	var/driving = 0
	var/mob/living/pulling = null
	var/bloodiness

	slowdown = 0

/obj/structure/bed/chair/wheelchair/update_icon()
	cut_overlays()
	add_overlay(image(icon = 'icons/obj/furniture.dmi', icon_state = "w_overlay", layer = FLY_LAYER))

/obj/structure/bed/chair/wheelchair/set_dir()
	. = ..()
	if(buckled)
		buckled.set_dir(dir)

/obj/structure/bed/chair/wheelchair/attackby(obj/item/W as obj, mob/user as mob)
	if(W.iswrench() || istype(W,/obj/item/stack) || W.iswirecutter())
		return
	..()

/obj/structure/bed/chair/wheelchair/relaymove(mob/user, direction)
	// Redundant check?
	if(user.stat || user.stunned || user.weakened || user.paralysis || user.lying || user.restrained())
		if(user==pulling)
			pulling = null
			user.pulledby = null
			to_chat(user, "<span class='warning'>You lost your grip!</span>")
		return
	if(buckled && pulling && user == buckled)
		if(pulling.stat || pulling.stunned || pulling.weakened || pulling.paralysis || pulling.lying || pulling.restrained())
			pulling.pulledby = null
			pulling = null
	if(user.pulling && (user == pulling))
		pulling = null
		user.pulledby = null
		return
	if(propelled)
		return
	if(pulling && (get_dist(src, pulling) > 1))
		pulling = null
		user.pulledby = null
		if(user==pulling)
			return
	if(pulling && (get_dir(src.loc, pulling.loc) == direction))
		to_chat(user, "<span class='warning'>You cannot go there.</span>")
		return
	if(pulling && buckled && (buckled == user))
		to_chat(user, "<span class='warning'>You cannot drive while being pushed.</span>")
		return

	// Let's roll
	driving = 1
	var/turf/T = null
	//--1---Move occupant---1--//
	if(buckled)
		buckled.buckled_to = null
		step(buckled, direction)
		buckled.buckled_to = src
	//--2----Move driver----2--//
	if(pulling)
		T = pulling.loc
		if(get_dist(src, pulling) >= 1)
			step(pulling, get_dir(pulling.loc, src.loc))
	//--3--Move wheelchair--3--//
	step(src, direction)
	if(buckled) // Make sure it stays beneath the occupant
		Move(buckled.loc)
	set_dir(direction)
	if(pulling) // Driver
		if(pulling.loc == src.loc) // We moved onto the wheelchair? Revert!
			pulling.forceMove(T)
		else
			spawn(0)
			if(get_dist(src, pulling) > 1) // We are too far away? Losing control.
				pulling = null
				user.pulledby = null
			pulling.set_dir(get_dir(pulling, src)) // When everything is right, face the wheelchair
	if(bloodiness)
		create_track()
	driving = 0

/obj/structure/bed/chair/wheelchair/Move()
	. = ..()
	playsound(src, 'sound/effects/roll.ogg', 75, 1)
	if(buckled)
		var/mob/living/occupant = buckled
		if(!driving)
			occupant.buckled_to = null
			occupant.Move(src.loc)
			occupant.buckled_to = src
			if (occupant && (src.loc != occupant.loc))
				if (propelled)
					for (var/mob/O in src.loc)
						if (O != occupant)
							Collide(O)
				else
					unbuckle()
			if (pulling && (get_dist(src, pulling) > 1))
				pulling.pulledby = null
				to_chat(pulling, "<span class='warning'>You lost your grip!</span>")
				pulling = null
		else
			if (occupant && (src.loc != occupant.loc))
				src.forceMove(occupant.loc) // Failsafe to make sure the wheelchair stays beneath the occupant after driving

/obj/structure/bed/chair/wheelchair/attack_hand(mob/living/user as mob)
	if (pulling)
		MouseDrop(usr)
	else
		user_unbuckle(user)
	return

/obj/structure/bed/chair/wheelchair/CtrlClick(var/mob/user)
	if(in_range(src, user))
		if(!ishuman(user))	return
		if(user == buckled)
			to_chat(user, "<span class='warning'>You realize you are unable to push the wheelchair you sit in.</span>")
			return
		if(!pulling)
			pulling = user
			user.pulledby = src
			if(user.pulling)
				user.stop_pulling()
			user.set_dir(get_dir(user, src))
			to_chat(user, "You grip \the [name]'s handles.")
		else
			to_chat(usr, "You let go of \the [name]'s handles.")
			pulling.pulledby = null
			pulling = null
		return

/obj/structure/bed/chair/wheelchair/Collide(atom/A)
	. = ..()
	if(!buckled)
		return

	if(propelled || (pulling && (pulling.a_intent == I_HURT)))
		var/mob/living/occupant = unbuckle()

		if (pulling && (pulling.a_intent == I_HURT))
			occupant.throw_at(A, 3, 3, pulling)
		else if (propelled)
			occupant.throw_at(A, 3, propelled)

		var/def_zone = ran_zone()
		occupant.throw_at(A, 3, propelled)
		occupant.apply_effect(6, STUN)
		occupant.apply_effect(6, WEAKEN)
		occupant.apply_effect(6, STUTTER)
		occupant.apply_damage(10, BRUTE, def_zone)
		playsound(src.loc, "punch", 50, 1, -1)
		if(isliving(A))
			var/mob/living/victim = A
			def_zone = ran_zone()
			victim.apply_effect(6, STUN)
			victim.apply_effect(6, WEAKEN)
			victim.apply_effect(6, STUTTER)
			victim.apply_damage(10, BRUTE, def_zone)
		if(pulling)
			occupant.visible_message("<span class='danger'>[pulling] has thrusted \the [name] into \the [A], throwing \the [occupant] out of it!</span>")

			pulling.attack_log += "\[[time_stamp()]\]<span class='warning'> Crashed [occupant.name]'s ([occupant.ckey]) [name] into \a [A]</span>"
			occupant.attack_log += "\[[time_stamp()]\]<font color='orange'> Thrusted into \a [A] by [pulling.name] ([pulling.ckey]) with \the [name]</font>"
			msg_admin_attack("[pulling.name] ([pulling.ckey]) has thrusted [occupant.name]'s ([occupant.ckey]) [name] into \a [A] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[pulling.x];Y=[pulling.y];Z=[pulling.z]'>JMP</a>)",ckey=key_name(pulling),ckey_target=key_name(occupant))
		else
			occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/bed/chair/wheelchair/proc/create_track()
	var/obj/effect/decal/cleanable/blood/tracks/B = new(loc)
	var/newdir = get_dir(get_step(loc, dir), loc)
	if(newdir == dir)
		B.set_dir(newdir)
	else
		newdir = newdir | dir
		if(newdir == 3)
			newdir = 1
		else if(newdir == 12)
			newdir = 4
		B.set_dir(newdir)
	bloodiness--

/obj/structure/bed/chair/wheelchair/buckle(mob/M as mob, mob/user as mob)
	if(M == pulling)
		pulling = null
		usr.pulledby = null
	..()

/obj/item/wheelchair
	name = "wheelchair"
	desc = "A folded wheelchair that can be carried around."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "wheelchair_folded"
	item_state = "wheelchair"
	w_class = ITEMSIZE_HUGE // Can't be put in backpacks. Oh well.

/obj/item/wheelchair/attack_self(mob/user)
	var/obj/structure/bed/chair/wheelchair/R = new /obj/structure/bed/chair/wheelchair(user.loc)
	R.add_fingerprint(user)
	R.name = src.name
	R.desc = src.desc
	R.color = src.color
	qdel(src)

/obj/structure/bed/chair/wheelchair/MouseDrop(over_object, src_location, over_location)
	..()
	if(!ishuman(usr))
		return FALSE
	if(buckled)
		return FALSE
	if(!usr.Adjacent(src))
		return FALSE
	visible_message(SPAN_NOTICE("[usr] collapses [src]."))
	var/obj/item/wheelchair/R = new(get_turf(src))
	R.name = src.name
	R.desc = src.desc
	R.color = src.color
	usr.put_in_hands(R)
	qdel(src)

