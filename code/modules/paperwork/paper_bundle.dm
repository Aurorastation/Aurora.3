/obj/item/paper_bundle
	name = "paper bundle"
	gender = NEUTER
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper"
	item_state = "paper"
	throwforce = 0
	w_class = 2
	throw_range = 2
	throw_speed = 1
	layer = 4
	attack_verb = list("bapped")
	var/page = 1    // current page
	var/list/pages = list()  // Ordered list of pages as they are to be displayed. Can be different order than src.contents.
	var/amount = 0 // How many sheet
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

/obj/item/paper_bundle/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if (istype(W, /obj/item/paper/carbon))
		var/obj/item/paper/carbon/C = W
		if (!C.iscopy && !C.copied)
			to_chat(user, "<span class='notice'>Take off the carbon copy first.</span>")
			add_fingerprint(user)
			return
	// adding sheets
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo))
		insert_sheet_at(user, pages.len+1, W)
		amount++
		attack_self(usr) //Update the browsed page.

	// burning
	else if(istype(W, /obj/item/flame))
		burnpaper(W, user)

	// merging bundles
	else if(istype(W, /obj/item/paper_bundle))
		for(var/obj/O in W)
			O.forceMove(src)
			O.add_fingerprint(usr)
			pages.Add(O)
			amount++

		to_chat(user, "<span class='notice'>You add \the [W.name] to [(src.name == "paper bundle") ? "the paper bundle" : src.name].</span>")
		attack_self(usr) //Update the browsed page.
		qdel(W)
	else
		if(istype(W, /obj/item/tape_roll))
			return 0
		// if(istype(W, /obj/item/pen))
			// usr << browse("", "window=[name]") // TODO: actually does nothing, either fix it so you can write directly to the bundle screen or actually prevent the window from opening until you're done
		var/obj/P = pages[page]
		P.attackby(W, user)

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

		user.visible_message("<span class='[class]'>[user] holds \the [P] up to \the [src], it looks like \he's trying to burn it!</span>", \
		"<span class='[class]'>You hold \the [P] up to \the [src], burning it slowly.</span>")

		spawn(20)
			if(get_dist(src, user) < 2 && user.get_active_hand() == P && P.lit)
				user.visible_message("<span class='[class]'>[user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>", \
				"<span class='[class]'>You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap.</span>")
				new /obj/effect/decal/cleanable/ash(src.loc)
				qdel(src)

			else
				to_chat(user, "<span class='warning'>You must hold \the [P] steady to burn \the [src].</span>")

/obj/item/paper_bundle/examine(mob/user)
	if(..(user, 1))
		src.show_content(user)
	else
		to_chat(user, "<span class='notice'>It is too far away.</span>")
	return

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
		if(!(istype(usr, /mob/living/carbon/human) || istype(usr, /mob/abstract/observer) || istype(usr, /mob/living/silicon)))
			dat+= "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[stars(P.info)][P.stamps]</BODY></HTML>"
		else
			dat+= "<HTML><HEAD><TITLE>[P.name]</TITLE></HEAD><BODY>[P.info][P.stamps]</BODY></HTML>"
		user << browse(dat, "window=[name]")
	else if(istype(pages[page], /obj/item/photo))
		var/obj/item/photo/P = W
		to_chat(user, browse_rsc(P.img, "tmp_photo.png"))
		user << browse(dat + "<html><head><title>[P.name]</title></head>" + "<body style='overflow:hidden'>" + "<div> <img src='tmp_photo.png' width = '180'" + "[P.scribble ? "<div> Written on the back:<br><i>[P.scribble]</i>" : null]" + "</body></html>", "window=[name]")

/obj/item/paper_bundle/attack_self(mob/user as mob)
	src.show_content(user)
	add_fingerprint(usr)
	update_icon()
	return

/obj/item/paper_bundle/Topic(href, href_list)
	..()
	var/obj/item/in_hand = null
	if((src in usr.contents) || (istype(src.loc, /obj/item/folder) && (src.loc in usr.contents)))
		in_hand = usr.get_active_hand()
	else if(isrobot(usr) && istype(usr.get_active_hand(), /obj/item/gripper/paperwork))
		var/obj/item/gripper/paperwork/PW = usr.get_active_hand()
		if(!(src in PW.contents) && !(istype(src.loc, /obj/item/folder) || !(src.loc in PW.contents)))
			return // paper bundle isn't in the gripper
	else
		to_chat(usr, "<span class='notice'>You need to hold it in hands!</span>")
		return

	usr.set_machine(src)

	if(href_list["next_page"])
		if(in_hand && (istype(in_hand, /obj/item/paper) || istype(in_hand, /obj/item/photo)))
			insert_sheet_at(usr, page+1, in_hand)
		else if(page != pages.len)
			page++
			playsound(src.loc, "pageturn", 50, 1)
	if(href_list["prev_page"])
		if(in_hand && (istype(in_hand, /obj/item/paper) || istype(in_hand, /obj/item/photo)))
			insert_sheet_at(usr, page, in_hand)
		else if(page > 1)
			page--
			playsound(src.loc, "pageturn", 50, 1)
	if(href_list["remove"])
		var/obj/item/W = pages[page]
		usr.put_in_hands(W)
		pages.Remove(pages[page])

		to_chat(usr, "<span class='notice'>You remove the [W.name] from the bundle.</span>")

		if(pages.len <= 1)
			var/obj/item/paper/P = src[1]
			usr.put_in_hands(P)
			qdel(src)
			return

		if(page > pages.len)
			page = pages.len

		update_icon()

	if (istype(src.loc, /mob) ||istype(src.loc.loc, /mob))
		src.attack_self(usr)
		updateUsrDialog()

/obj/item/paper_bundle/verb/rename()
	set name = "Rename bundle"
	set category = "Object"
	set src in usr

	var/n_name = sanitizeSafe(input(usr, "What would you like to label the bundle?", "Bundle Labelling", null)  as text, MAX_NAME_LEN)
	if((loc == usr || loc.loc && loc.loc == usr) && usr.stat == 0)
		if(n_name)
			name = "[initial(name)] ([n_name])"
		else
			name = initial(name)
	add_fingerprint(usr)
	return


/obj/item/paper_bundle/verb/remove_all()
	set name = "Loose bundle"
	set category = "Object"
	set src in usr

	to_chat(usr, "<span class='notice'>You loosen the bundle.</span>")
	for(var/obj/O in src)
		O.forceMove(usr.loc)
		O.layer = initial(O.layer)
		O.add_fingerprint(usr)
	qdel(src)
	return


/obj/item/paper_bundle/update_icon()
	var/obj/item/paper/P = pages[1]
	icon_state = P.icon_state
	copy_overlays(P.overlays, TRUE)
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
