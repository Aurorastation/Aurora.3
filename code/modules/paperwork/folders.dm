/obj/item/folder
	name = "folder"
	desc = "Holds loose sheets of paper and is a bureaucrat's best friend."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "folder"
	w_class = ITEMSIZE_SMALL
	drop_sound = 'sound/items/drop/paper.ogg'
	pickup_sound = 'sound/items/pickup/paper.ogg'

	var/can_write = FALSE

/obj/item/folder/blue
	desc = "A blue folder."
	icon_state = "folder_blue"

/obj/item/folder/sec
	desc = "A gold and blue folder, specifically designed for the Internal Security Department."
	icon_state = "folder_blue_gold"

/obj/item/folder/red
	desc = "A red folder."
	icon_state = "folder_red"

/obj/item/folder/yellow
	desc = "A yellow folder."
	icon_state = "folder_yellow"

/obj/item/folder/white
	desc = "A white folder."
	icon_state = "folder_white"

/obj/item/folder/purple
	desc = "A purple folder, specifically designed for the Research Division facilities of the company."
	icon_state = "folder_purple"

/obj/item/folder/update_icon()
	cut_overlays()
	if(contents.len)
		add_overlay("folder_paper")
	return

/obj/item/folder/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/paper) || istype(W, /obj/item/photo) || istype(W, /obj/item/paper_bundle) || istype(W, /obj/item/sample))
		user.drop_from_inventory(W,src)
		to_chat(user, "<span class='notice'>You put the [W] into \the [src].</span>")
		update_icon()
	else if(W.ispen())
		var/n_name = sanitizeSafe(input(usr, "What would you like to label the folder?", "Folder Labelling", null)  as text, MAX_NAME_LEN)
		if(Adjacent(user) && user.stat == 0)
			name = "folder[(n_name ? text("- '[n_name]'") : null)]"
	return

/obj/item/folder/attack_self(mob/user as mob)
	var/dat = "<title>[name]</title>"

	for(var/obj/item/paper/P in src)
		dat += "[can_write ? "<A href='?src=\ref[src];write=\ref[P]'>Write</A> " : ""]<A href='?src=\ref[src];remove=\ref[P]'>Remove</A> <A href='?src=\ref[src];rename=\ref[P]'>Rename</A> - <A href='?src=\ref[src];read=\ref[P]'>[P.name]</A><BR>"
	for(var/obj/item/photo/Ph in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Ph]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Ph]'>Rename</A> - <A href='?src=\ref[src];look=\ref[Ph]'>[Ph.name]</A><BR>"
	for(var/obj/item/paper_bundle/Pb in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Pb]'>Remove</A> <A href='?src=\ref[src];rename=\ref[Pb]'>Rename</A> - <A href='?src=\ref[src];browse=\ref[Pb]'>[Pb.name]</A><BR>"
	for(var/obj/item/sample/Pf in src)
		dat += "<A href='?src=\ref[src];remove=\ref[Pf]'>Remove</A> - [Pf.name]<BR>"
	user << browse(dat, "window=folder")
	onclose(user, "folder")
	add_fingerprint(usr)
	return

/obj/item/folder/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()))
		return

	if(loc_check(usr))

		if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])
			if(P && (P.loc == src) && istype(P))
				P.forceMove(usr.loc)
				usr.put_in_hands(P)
				handle_post_remove()
		else if(href_list["write"])
			var/obj/item/paper/paper = locate(href_list["write"])
			if(!istype(paper) || paper.loc != src)
				return
			var/obj/item/pen = usr.get_inactive_hand()
			if(!pen || !pen.ispen())
				pen = usr.get_active_hand()
			if(pen?.ispen())
				paper.attackby(pen, usr)
		else if(href_list["read"])
			var/obj/item/paper/P = locate(href_list["read"])
			if(P && (P.loc == src) && istype(P))
				P.show_content(usr)
		else if(href_list["look"])
			var/obj/item/photo/P = locate(href_list["look"])
			if(P && (P.loc == src) && istype(P))
				P.show(usr)
		else if(href_list["browse"])
			var/obj/item/paper_bundle/P = locate(href_list["browse"])
			if(P && (P.loc == src) && istype(P))
				P.attack_self(usr)
				onclose(usr, "[P.name]")
		else if(href_list["rename"])
			var/obj/item/O = locate(href_list["rename"])

			if(O && (O.loc == src))
				if(istype(O, /obj/item/paper))
					var/obj/item/paper/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/photo))
					var/obj/item/photo/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/paper_bundle))
					var/obj/item/paper_bundle/to_rename = O
					to_rename.rename()

		//Update everything
		attack_self(usr)
		update_icon()
	return

/obj/item/folder/proc/loc_check(var/atom/A)
	if(loc == A)
		return TRUE
	return FALSE

/obj/item/folder/proc/handle_post_remove()
	return

/obj/item/folder/blue/nka/Initialize()
	. = ..()
	for (var/I = 1 to 5)
		new /obj/item/paper/nka_pledge(src)

/obj/item/folder/filled/Initialize()
	. = ..()
	for (var/I = 1 to 10)
		new /obj/item/paper(src)

/obj/item/folder/embedded
	name = "index"
	can_write = TRUE

/obj/item/folder/embedded/loc_check(var/atom/A)
	if(loc.loc.Adjacent(A))
		return TRUE
	return FALSE

/obj/item/folder/embedded/handle_post_remove()
	if(!length(contents))
		qdel(src)