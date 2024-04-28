/obj/item/paper_bundle
	name = "paper bundle"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	throwforce = 0
	w_class = ITEMSIZE_SMALL
	throw_range = 2
	throw_speed = 1
	layer = ABOVE_OBJ_LAYER
	attack_verb = list("bapped")
	var/page = 1    // current page
	var/list/pages = list()  // Ordered list of pages as they are to be displayed. Can be different order than src.contents.
	var/amount = 0 // How many sheet
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/paper_bundle/attackby(obj/item/attacking_item, mob/user)
	..()

	if (istype(attacking_item, /obj/item/paper/carbon))
		var/obj/item/paper/carbon/C = attacking_item
		if (!C.iscopy && !C.copied)
			to_chat(user, "<span class='notice'>Take off the carbon copy first.</span>")
			add_fingerprint(user)
			return
	// adding sheets
	if(istype(attacking_item, /obj/item/paper) || istype(attacking_item, /obj/item/photo))
		insert_sheet_at(user, pages.len+1, attacking_item)
		amount++
		attack_self(usr) //Update the browsed page.

	// burning
	else if(istype(attacking_item, /obj/item/flame))
		burnpaper(attacking_item, user)

	// merging bundles
	else if(istype(attacking_item, /obj/item/paper_bundle))
		for(var/obj/O in attacking_item)
			O.forceMove(src)
			O.add_fingerprint(usr)
			pages.Add(O)
			amount++

		to_chat(user, "<span class='notice'>You add \the [attacking_item.name] to [(src.name == "paper bundle") ? "the paper bundle" : src.name].</span>")
		attack_self(usr) //Update the browsed page.
		qdel(attacking_item)
	else
		if(istype(attacking_item, /obj/item/tape_roll))
			return 0
		// if(istype(attacking_item, /obj/item/pen))
			// usr << browse("", "window=[name]") // TODO: actually does nothing, either fix it so you can write directly to the bundle screen or actually prevent the window from opening until you're done
		var/obj/P = pages[page]
		P.attackby(attacking_item, user)

	update_icon()
	add_fingerprint(usr)
	return

/obj/item/paper_bundle/proc/insert_sheet_at(mob/user, var/index, obj/item/sheet)
	if(istype(sheet, /obj/item/paper))
		to_chat(user, "<span class='notice'>You add [(sheet.name == "paper") ? "the paper" : sheet.name] to [(src.name == "paper bundle") ? "the paper bundle" : src.name].</span>")
	else if(istype(sheet, /obj/item/photo))
		to_chat(user, "<span class='notice'>You add [(sheet.name == "photo") ? "the photo" : sheet.name] to [(src.name == "paper bundle") ? "the paper bundle" : src.name].</span>")

	user.drop_from_inventory(sheet,src)

	pages.Insert(index, sheet)

	if(index <= page)
		page++

/obj/item/paper_bundle/proc/burnpaper(obj/item/flame/P, mob/user)
	var/class = "warning"

	if(P.lit && !user.restrained())
		if(istype(P, /obj/item/flame/lighter/zippo))
			class = "rose>"

		user.visible_message("<span class='[class]'>[user] holds \the [P] up to \the [src], it looks like [user.get_pronoun("he")]'s trying to burn it!</span>", \
		"<span class='[class]'>You hold \the [P] up to \the [src], burning it slowly.</span>")

		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P && P.lit)
				user.visible_message("<span class='[class]'>[user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
				"<span class='[class]'>You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")
				new /obj/effect/decal/cleanable/ash(src.loc)
				qdel(src)

			else
				to_chat(user, "<span class='warning'>You must hold \the [P] steady to burn \the [src].</span>")

/obj/item/paper_bundle/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(is_adjacent)
		src.show_content(user)
	else
		. += "<span class='notice'>It is too far away.</span>"

/obj/item/paper_bundle/proc/show_content(mob/user as mob)
	var/dat
	var/obj/item/W = pages[page]

	// first
	if(page == 1)
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'>Front</DIV>"
		dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref[src];remove=1'>Remove [(istype(W, /obj/item/paper)) ? "paper" : "photo"]</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"
	// last
	else if(page == pages.len)
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref[src];remove=1'>Remove [(istype(W, /obj/item/paper)) ? "paper" : "photo"]</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'>Back</DIV><BR><HR>"
	// middle pages
	else
		dat+= "<DIV STYLE='float:left; text-align:left; width:33.33333%'><A href='?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:center; width:33.33333%'><A href='?src=\ref[src];remove=1'>Remove [(istype(W, /obj/item/paper)) ? "paper" : "photo"]</A></DIV>"
		dat+= "<DIV STYLE='float:left; text-align:right; width:33.33333%'><A href='?src=\ref[src];next_page=1'>Next Page</A></DIV><BR><HR>"

	if(istype(pages[page], /obj/item/paper))
		var/obj/item/paper/P = W
		dat += P.get_content(user, P.can_read(user))

		var/datum/browser/paper_win
		if(istype(pages[page], /obj/item/paper/business_card))
			paper_win = new(user, name, null, 525, 300, null, TRUE)
		else
			paper_win = new(user, name, null, 450, 500, null, TRUE)
		paper_win.set_content(dat)
		paper_win.add_stylesheet("paper_languages", 'html/browser/paper_languages.css')
		paper_win.open()

	else if(istype(pages[page], /obj/item/photo))
		var/obj/item/photo/P = W
		send_rsc(user, P.img, "tmp_photo.png")

		dat += "<html><head><title>[P.name]</title></head>" \
		+ "<body style='overflow:hidden'>" \
		+ "<div> <img src='tmp_photo.png' width = '180'" \
		+ "[P.scribble ? "<div> Written on the back:<br><i>[P.scribble]</i>" : null]" \
		+ "</body></html>"

		show_browser(user, dat, "window=[name]")

/obj/item/paper_bundle/attack_self(mob/user as mob)
	src.show_content(user)
	add_fingerprint(usr)
	update_icon()
	return

/obj/item/paper_bundle/proc/gripper_check(var/mob/user)
	var/obj/item/gripper/paperwork/PW = user.get_active_hand()
	if(istype(PW))
		if(loc == PW || (istype(loc, /obj/item/folder) && (loc.loc == PW)))
			return TRUE
	return FALSE

/obj/item/paper_bundle/proc/hand_check(var/mob/user)
	if(loc == user)
		return TRUE
	var/obj/item/folder/F = loc
	if(istype(F) && F.loc_check(user))
		return TRUE

/obj/item/paper_bundle/Topic(href, href_list)
	..()

	var/in_hand = FALSE
	if(isrobot(usr))
		in_hand = gripper_check(usr)
	else
		in_hand = hand_check(usr)

	if(!in_hand)
		to_chat(usr, SPAN_WARNING("You need to hold it in hands!"))
		return

	usr.set_machine(src)

	if(href_list["next_page"])
		if(page != length(pages))
			var/obj/P = pages[page]
			page++
			var/obj/A = pages[page]
			playsound(src.loc, /singleton/sound_category/page_sound, 50, 1)
			if(A.type != P.type)
				show_browser(usr, null, "window=[name]")
	if(href_list["prev_page"])
		if(page > 1)
			var/obj/P = pages[page]
			page--
			var/obj/A = pages[page]
			playsound(src.loc, /singleton/sound_category/page_sound, 50, 1)
			if(A.type != P.type)
				show_browser(usr, null, "window=[name]")
	if(href_list["remove"])
		var/obj/item/W = pages[page]
		usr.put_in_hands(W)
		pages.Remove(pages[page])

		to_chat(usr, SPAN_NOTICE("You remove the [W.name] from the bundle."))


		if(pages.len <= 1)
			var/obj/item/paper/P = src[1]
			if(istype(loc, /obj/item/gripper)) //Hacky but without it there's a ghost icon with grippers and it all spills on the floor.
				var/obj/item/gripper/G = loc
				G.drop(get_turf(src), usr, FALSE)
				G.grip_item(P, usr, FALSE)
			else
				usr.put_in_hands(P)
			usr.unset_machine(src)
			show_browser(usr, null, "window=[name]")
			qdel(src)
			return

		if(page > pages.len)
			page = pages.len

		update_icon()

	var/atom/surface_atom = recursive_loc_turf_check(src, 3, usr)
	if(surface_atom == usr || surface_atom.Adjacent(usr))
		attack_self(usr)

/obj/item/paper_bundle/verb/rename()
	set name = "Rename bundle"
	set category = "Object"
	set src in usr

	if(use_check_and_message(usr, USE_ALLOW_NON_ADJACENT))
		return

	var/n_name = sanitizeSafe(input(usr, "What would you like to label the bundle?", "Bundle Labelling", null)  as text, MAX_NAME_LEN)

	if(use_check_and_message(usr, USE_ALLOW_NON_ADJACENT))
		return

	var/mob/M = recursive_loc_turf_check(src, 3, usr)
	if(M == usr)
		if(n_name)
			name = "[initial(name)] ([n_name])"
		else
			name = initial(name)
		add_fingerprint(usr)


/obj/item/paper_bundle/verb/remove_all()
	set name = "Loose bundle"
	set category = "Object"
	set src in usr

	to_chat(usr, "<span class='notice'>You loosen the bundle.</span>")
	for(var/obj/O in src)
		O.forceMove(usr.loc)
		O.reset_plane_and_layer()
		O.add_fingerprint(usr)
	qdel(src)
	return


/obj/item/paper_bundle/update_icon()
	var/obj/item/paper/P = pages[1]
	icon_state = P.icon_state
	copy_overlays(P, TRUE)
	underlays = 0
	var/i = 0
	var/photo
	for(var/obj/O in src)
		if(istype(O, /obj/item/paper))
			var/image/img = image('icons/obj/bureaucracy.dmi', O.icon_state)
			img.pixel_x -= min(1*i, 2)
			img.pixel_y -= min(1*i, 2)
			pixel_x = min(0.5*i, 1)
			pixel_y = min(  1*i, 2)
			underlays += img
			i++
		else if(istype(O, /obj/item/photo))
			var/obj/item/photo/Ph = O
			photo = 1
			add_overlay(Ph.tiny)
	if(i>1)
		desc = "[i] papers clipped to each other."
	else
		desc = "A single sheet of paper."
	if(photo)
		desc += "\nThere is a photo attached to it."
	add_overlay("clip")
