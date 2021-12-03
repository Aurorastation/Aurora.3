/obj/structure/bed/stool/chair/office/wheelchair
	name = "wheelchair"
	icon_state = "wheelchair_padded_preview"
	base_icon = "wheelchair"
	anchored = FALSE
	buckle_movable = TRUE
	material_alteration = MATERIAL_ALTERATION_DESC
	held_item = /obj/item/material/stool/chair/wheelchair
	withdraw_verb = "fold"

	can_dismantle = FALSE

	var/bloodiness

	slowdown = 0

/obj/structure/bed/stool/chair/office/wheelchair/New(var/newloc) // Colorable wheelchairs? 
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH)

/obj/structure/bed/stool/chair/office/wheelchair/set_dir()
	. = ..()
	if(buckled)
		buckled.set_dir(dir)

/obj/structure/bed/stool/chair/office/wheelchair/relaymove(mob/user, direction)
	// Redundant check?
	if(user.stat || user.stunned || user.weakened || user.paralysis || user.lying || user.restrained())
		if(user==pulling)
			pulling = null
			user.pulledby = null
			to_chat(user, SPAN_WARNING("You've lost your grip!"))
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
		to_chat(user, SPAN_WARNING("You cannot go there."))
		return
	if(pulling && buckled && (buckled == user))
		to_chat(user, SPAN_WARNING("You cannot drive while being pushed."))
		return

	// Let's roll
	driving = TRUE
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
	driving = FALSE

/obj/structure/bed/stool/chair/office/wheelchair/attack_hand(mob/living/user as mob)
	if(pulling)
		MouseDrop()
	else
		user_unbuckle(user)
	return

/obj/structure/bed/stool/chair/office/wheelchair/CtrlClick(var/mob/user)
	if(in_range(src, user))
		if(!ishuman(user))	return
		if(user == buckled)
			to_chat(user, SPAN_WARNING("You realize you are unable to push the wheelchair you sit in."))
			return
		if(!pulling)
			pulling = user
			user.pulledby = src
			if(user.pulling)
				user.stop_pulling()
			user.set_dir(get_dir(user, src))
			to_chat(user, "You grip \the [name]'s handles.")
		else
			to_chat(user, "You let go of \the [name]'s handles.")
			pulling.pulledby = null
			pulling = null
		return

/obj/structure/bed/stool/chair/office/wheelchair/proc/create_track()
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

/obj/structure/bed/stool/chair/office/wheelchair/buckle(mob/M as mob, mob/user as mob)
	if(M == pulling)
		pulling = null
		usr.pulledby = null
	..()

/obj/item/material/stool/chair/wheelchair
	name = "wheelchair"
	desc = "A folded wheelchair that can be carried around."
	icon_state = "wheelchair_item_preview"
	item_state = "wheelchair"
	base_icon = "wheelchair"
	w_class = ITEMSIZE_HUGE // Can't be put in backpacks. Oh well.
	origin_type = /obj/structure/bed/stool/chair/office/wheelchair
	deploy_verb = "deploy"

/obj/item/material/stool/chair/wheelchair/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH)

