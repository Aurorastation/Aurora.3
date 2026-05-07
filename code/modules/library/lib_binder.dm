/*
 * Book Binder
 */
/obj/machinery/bookbinder
	name = "book binder"
	desc = "A machine that takes paper and binds them into books. Fascinating!"
	icon = 'icons/obj/library.dmi'
	icon_state = "binder"
	anchored = TRUE
	density = TRUE
	var/binding = FALSE

/obj/machinery/bookbinder/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paper))
		var/obj/item/paper/paper = attacking_item
		if(!anchored)
			to_chat(user, SPAN_WARNING("\The [src] must be secured to the floor first!"))
			return
		if(binding)
			to_chat(user, SPAN_WARNING("You must wait for \the [src] to finish its current operation!"))
			return
		var/turf/work_turf = get_turf(src)
		user.drop_from_inventory(paper, src)
		user.visible_message(
			SPAN_NOTICE("\The [user] loads some paper into \the [src]."),
			SPAN_NOTICE("You load some paper into \the [src]."))
		visible_message(SPAN_NOTICE("\The [src] begins to hum as it warms up its printing drums."))
		playsound(work_turf, 'sound/items/bureaucracy/binder.ogg', 75, 1)
		binding = TRUE
		sleep(rand(20 SECONDS, 40 SECONDS))
		binding = FALSE
		if(!anchored)
			visible_message(SPAN_WARNING("\The [src] buzzes and flashes an error light."))
			paper.forceMove(work_turf)
			return
		visible_message(SPAN_NOTICE("\The [src] whirs as it prints and binds a new book."))
		playsound(work_turf, 'sound/items/bureaucracy/print.ogg', 75, 1)
		var/obj/item/book/bound_book = new(work_turf)
		bound_book.dat = paper.info
		bound_book.name = "blank book"
		bound_book.icon_state = "book[rand(1,7)]"
		bound_book.item_state = icon_state
		qdel(paper)
		return

	if(attacking_item.tool_behaviour == TOOL_WRENCH)
		attacking_item.play_tool_sound(get_turf(src), 75)
		if(anchored)
			user.visible_message(
				SPAN_NOTICE("\The [user] unsecures \the [src] from the floor."),
				SPAN_NOTICE("You unsecure \the [src] from the floor."),
				SPAN_WARNING("You hear a ratcheting noise."))
		else
			user.visible_message(
				SPAN_NOTICE("\The [user] secures \the [src] to the floor."),
				SPAN_NOTICE("You secure \the [src] to the floor."),
				SPAN_WARNING("You hear a ratcheting noise."))
		anchored = !anchored
