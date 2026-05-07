/*
 * Library Scanner
 */
/obj/machinery/libraryscanner
	name = "book scanner"
	desc = "A machine that scans books for upload to the library database."
	icon = 'icons/obj/library.dmi'
	icon_state = "bigscanner"
	var/insert_animation = "bigscanner1"
	anchored = TRUE
	density = TRUE
	var/obj/item/book/cache // Last scanned book

/obj/machinery/libraryscanner/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/book))
		if(!anchored)
			to_chat(user, SPAN_WARNING("\The [src] must be secured to the floor first!"))
			return
		user.drop_from_inventory(attacking_item, src)
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

/obj/machinery/libraryscanner/attack_hand(var/mob/user)
	. = ..()
	if(.)
		return TRUE
	ui_interact(user)

/obj/machinery/libraryscanner/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LibraryScanner", "Book Scanner", 400, 250)
		ui.open()

/obj/machinery/libraryscanner/ui_data(mob/user)
	var/list/data = list()
	data["has_book"] = !!cache
	data["book_title"] = cache ? cache.name : null
	data["book_author"] = cache ? cache.author : null
	data["is_anchored"] = anchored
	return data

/obj/machinery/libraryscanner/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	add_fingerprint(usr)
	switch(action)
		if("scan")
			flick(insert_animation, src)
			playsound(loc, 'sound/items/bureaucracy/scan.ogg', 75, 1)
			for(var/obj/item/book/book in contents)
				cache = book
				break
			. = TRUE
		if("clear")
			cache = null
			. = TRUE
		if("eject")
			for(var/obj/item/book/book in contents)
				book.forceMove(src.loc)
			cache = null
			. = TRUE
