#define DEFAULT_SHELF_CAPACITY 3 // Default capacity of the shelf
#define DEFAULT_SHELF_USE_DELAY 1 SECONDS // Default interaction delay of the shelf
#define DEFAULT_SHELF_VERTICAL_OFFSET 10 // Vertical pixel offset of shelving-related things. Set to 10 by default due to this leaving more of the crate on-screen to be clicked.

/obj/structure/crate_shelf
	name = "crate shelf"
	desc = "It's a shelf! For storing crates!"
	icon = 'icons/obj/structure/crate_shelf.dmi'
	icon_state = "shelf_base"
	var/shelf_stack = "shelf_stack"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

	var/capacity = DEFAULT_SHELF_CAPACITY
	var/use_delay = DEFAULT_SHELF_USE_DELAY
	var/list/shelf_contents

	var/manipulating = FALSE

	var/obj/item/stack/dismantle_mat = /obj/item/stack/rods
	build_amt = 10

// For testing only.
/obj/structure/crate_shelf/tall
	capacity = 12

/obj/structure/crate_shelf/mechanics_hints()
	. = list()
	. += ..()
	. += "Drag a crate on to the shelf, to put it on it."
	. += "Drag a crate from the shelf to the ground to remove it."

/obj/structure/crate_shelf/Initialize(mapload)
	. = ..()
	LAZYSETLEN(shelf_contents, capacity)
	update_icon()
	return mapload ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_NORMAL

/obj/structure/crate_shelf/LateInitialize()
	. = ..()
	var/next_free
	for(var/obj/I in loc)
		if (!istype(I, /obj/structure/closet/crate))
			continue
		next_free = LAZYFIND(shelf_contents, null)
		if(!next_free)
			continue
		put_in(I, next_free)


/obj/structure/crate_shelf/update_icon()
	ClearOverlays()
	var/stack_layer // This is used to generate the sprite layering of the shelf pieces.
	var/stack_offset // This is used to generate the vertical offset of the shelf pieces.
	for(var/i in 1 to (capacity - 1))
		stack_layer  = BELOW_OBJ_LAYER + (0.02 * i) - 0.01 // Make each shelf piece render above the last, but below the crate that should be on it.
		stack_offset = DEFAULT_SHELF_VERTICAL_OFFSET * i // Make each shelf piece physically above the last.
		var/image/I = image(icon, icon_state = shelf_stack, layer = stack_layer, pixel_y = stack_offset)
		AddOverlays(I)

/obj/structure/crate_shelf/Destroy()
	LAZYCLEARLIST(shelf_contents)
	return ..()

/obj/structure/crate_shelf/attackby(obj/item/attacking_item, mob/user, params)
	. = ..()
	if(attacking_item.iswrench())
		dismantle(attacking_item, user)

/obj/structure/crate_shelf/dismantle(obj/item/W, mob/user)
	// if(!LAZYLEN(shelf_contents))
	var/empty = TRUE
	for(var/c in shelf_contents)
		if(c != null)
			empty = FALSE
	if(!empty)
		to_chat(user, SPAN_NOTICE("Remove any crates from \the [src] before dismantling it."))
		return
	if(manipulating)
		return
	manipulating = TRUE
	user.visible_message("<b>[user]</b> begins dismantling \the [src].",
						SPAN_NOTICE("You begin dismantling \the [src]."))
	if(!W.use_tool(src, user, 2 SECONDS, volume = 50))
		manipulating = FALSE
		return
	user.visible_message("\The [user] dismantles \the [src].",
						SPAN_NOTICE("You dismantle \the [src]."))
	new dismantle_mat(src.loc, 10)
	qdel(src)

/obj/structure/crate_shelf/proc/relay_container_resist_act(mob/living/user, obj/structure/closet/crate)
	to_chat(user, SPAN_NOTICE("You begin attempting to knock [crate] out of [src]."))
	visible_message(SPAN_DANGER("\The [crate] begins to shake violently!"), SPAN_DANGER("You hear the sound of metal thrashing around nearby."), intent_message = THUNK_SOUND)
	crate.shake_animation()
	// var/breakout_time = 1

	// user.next_move = world.time + 100
	// user.last_special = world.time + 100

	// var/time = 6 * breakout_time * 2

	// var/datum/progressbar/bar
	// if (user.client && user.client.prefs.toggles_secondary & PROGRESS_BARS)
	// 	bar = new(user, time, src)

	// crate.breakout = 1
	// for(var/i in 1 to time) //minutes * 6 * 5seconds * 2
	// 	playsound(loc, 'sound/effects/grillehit.ogg', 100, 1)
	// 	crate.shake_animation()
	// 	intent_message(THUNK_SOUND)

	// 	if (bar)
	// 		bar.update(i)

	// 	if(!do_after(user, 50, do_flags = DO_DEFAULT & ~DO_SHOW_PROGRESS)) //5 seconds
	// 		crate.breakout = 0
	// 		qdel(bar)
	// 		return

	// 	if(!user || user.stat || user.loc != src)
	// 		crate.breakout = 0
	// 		qdel(bar)
	// 		return

	// 	if(!crate.req_breakout())
	// 		crate.breakout = 0
	// 		qdel(bar)
	// 		return

	// crate.breakout = 0
	// playsound(loc, 'sound/effects/grillehit.ogg', 100, 1)
	// crate.shake_animation()
	// qdel(bar)


	if(do_after(user, 20 SECONDS, target = crate))
		if(!user || user.stat != CONSCIOUS || user.loc != crate || crate.loc != src)
			return // If the user is in a strange condition, return early.
		crate.shake_animation()
		visible_message(SPAN_WARNING("\The [crate] falls off the [src]!"), SPAN_NOTICE("You hear a thud."), intent_message = THUNK_SOUND)
		crate.forceMove(loc) // Drop the crate onto the shelf,
		step_rand(crate, 1) // Then try to push it somewhere.
		crate.layer = initial(crate.layer) // Reset the crate back to having the default layer, otherwise we might get strange interactions.
		crate.pixel_y = initial(crate.pixel_y) // Reset the crate back to having no offset, otherwise it will be floating.
		shelf_contents[shelf_contents.Find(crate)] = null // Remove the reference to the crate from the list.
		handle_visuals()


/obj/structure/crate_shelf/proc/handle_visuals()
	vis_contents = contents // It really do be that shrimple.
	return

/obj/structure/crate_shelf/proc/load(obj/structure/closet/crate/crate, mob/user)
	// Check if the shelf has an empty spot, notify the player if not.
	var/next_free = LAZYFIND(shelf_contents, null)
	if(!next_free)
		to_chat(user, SPAN_NOTICE("The shelf is full."))
		balloon_alert(user, "shelf full!")
		return FALSE
	visible_message("\The [user] starts to put \the [crate] on \the [src].")
	if(do_after(user, use_delay, target = crate))
		if(shelf_contents[next_free] != null)
			// Something has been added to the shelf while we were waiting, abort!
			visible_message("\The [user] stops putting \the [crate] on \the [src].")
			to_chat(user, SPAN_NOTICE("Something else was added to the shelf first."))
			return FALSE
		if(crate.opened) // If the crate is open, try to close it.
			if(!crate.close())
				visible_message("\The [user] stops putting \the [crate] on \the [src].")
				to_chat(user, SPAN_NOTICE("The crate couldn't be closed."))
				return FALSE // If we fail to close it, don't load it into the shelf.
		put_in(crate, next_free)
		visible_message("\The [user] puts \the [crate] on \the [src].")
		return TRUE
	visible_message("\The [user] stops putting \the [crate] on \the [src].")
	return FALSE // If the do_after() is interrupted, return FALSE!

/obj/structure/crate_shelf/proc/put_in(obj/structure/closet/crate/crate, var/next_free)
	LAZYSET(shelf_contents, next_free, crate)
	crate.forceMove(src) // Insert the crate into the shelf.
	crate.pixel_y = DEFAULT_SHELF_VERTICAL_OFFSET * (next_free - 1) // Adjust the vertical offset of the crate to look like it's on the shelf.
	crate.layer = BELOW_OBJ_LAYER + 0.02 * (next_free - 1) // Adjust the layer of the crate to look like it's in the shelf.
	handle_visuals()

/obj/structure/crate_shelf/proc/unload(obj/structure/closet/crate/crate, mob/user, turf/unload_turf)
	if(!unload_turf)
		unload_turf = get_turf(user) // If a turf somehow isn't passed into the proc, put it at the user's feet.
	if(!unload_turf.Enter(crate)) // If moving the crate from the shelf to the desired turf would bump, don't do it! Thanks Kapu1178 for the help here. - Generic DM
		to_chat(user, SPAN_NOTICE("There is no room for the crate."))
		return FALSE
	visible_message("\The [user] starts unloading \the [crate] from \the [src].")
	if(do_after(user, use_delay, target = crate))
		if(!LAZYFIND(shelf_contents, crate))
			visible_message("\The [user] stops unloading \the [crate] from \the [src].")
			to_chat(user, SPAN_NOTICE("The crate can't be moved."))
			return FALSE // If something has happened to the crate while we were waiting, abort!
		crate.layer = initial(crate.layer) // Reset the crate back to having the default layer, otherwise we might get strange interactions.
		crate.pixel_y = initial(crate.pixel_y) // Reset the crate back to having no offset, otherwise it will be floating.
		crate.forceMove(unload_turf)
		shelf_contents[shelf_contents.Find(crate)] = null // We do this instead of removing it from the list to preserve the order of the shelf.
		handle_visuals()
		visible_message("\The [user] unloads \the [crate] from \the [src].")
		return TRUE
	visible_message("\The [user] stops unloading \the [crate] from \the [src].")
	return FALSE  // If the do_after() is interrupted, return FALSE!
