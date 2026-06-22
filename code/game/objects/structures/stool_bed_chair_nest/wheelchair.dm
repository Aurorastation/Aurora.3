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
	slowdown = 0.5

	var/bloodiness

/obj/structure/bed/stool/chair/office/wheelchair/New(var/newloc) // Colorable wheelchairs?
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH)

/obj/structure/bed/stool/chair/office/wheelchair/set_dir()
	. = ..()
	if(buckled)
		buckled.set_dir(dir)

/obj/structure/bed/stool/chair/office/wheelchair/relaymove(mob/living/user, direction)
	. = ..()

	if(propelled)
		return
	if(LAZYLEN(grabbed_by) && buckled && (buckled == user))
		to_chat(user, SPAN_WARNING("You cannot drive while being pushed."))
		return

	// previously this section had a "let's roll" comment
	// fuck you, nothing rolls about this shitcode
	driving = TRUE
	user.set_glide_size(glide_size)
	astype(buckled, /mob/living)?.set_glide_size(glide_size) //FUCK YOU WHEELCHAIRS

	// move occupant
	if(buckled)
		buckled.buckled_to = null
		step(buckled, direction)
		buckled.buckled_to = src // what the fuck?


	// move driver
	if(LAZYLEN(grabbed_by))
		for(var/obj/item/grab/G as anything in grabbed_by)
			var/turf/next_driver_step = get_step(G.grabber, get_dir(G.grabber, loc))
			if(get_dist(src, G.grabber) <= 1)
				if(next_driver_step != get_step(src, direction)) //don't overlap turfs
					step(G.grabber, get_dir(G.grabber, loc))
			else
				qdel(G)

	// move wheelchair
	step(src, direction)
	if(buckled) // Make sure it stays beneath the occupant
		Move(buckled.loc)

	set_dir(direction)

	if(bloodiness)
		create_track()

	driving = FALSE

/obj/structure/bed/stool/chair/office/wheelchair/attack_hand(mob/living/user as mob)
	. = ..()
	if(LAZYLEN(grabbed_by))
		MouseDrop()
	else
		user_unbuckle(user)
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

/obj/structure/bed/stool/chair/office/wheelchair/generate_strings()
	return

/obj/item/material/stool/chair/wheelchair
	name = "wheelchair"
	desc = "A folded wheelchair that can be carried around."
	icon_state = "wheelchair_item_preview"
	item_state = "wheelchair"
	base_icon = "wheelchair"
	w_class = WEIGHT_CLASS_HUGE // Can't be put in backpacks. Oh well.
	origin_type = /obj/structure/bed/stool/chair/office/wheelchair
	deploy_verb = "deploy"

/obj/item/material/stool/chair/wheelchair/New(var/newloc)
	..(newloc, MATERIAL_STEEL, MATERIAL_CLOTH)

