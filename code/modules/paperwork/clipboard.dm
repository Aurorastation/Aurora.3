/obj/item/clipboard
	name = "clipboard"
	desc = "When other writing surfaces are unavailable."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "clipboard"
	item_state = "clipboard"
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 10
	var/obj/item/pen/haspen		//The stored pen.
	var/obj/item/toppaper	//The topmost piece of paper.
	var/list/r_contents = list()
	var/ui_open = FALSE
	slot_flags = SLOT_BELT

/obj/item/clipboard/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "You can store a pen in this."

/obj/item/clipboard/Initialize()
	. = ..()
	update_icon()

/obj/item/clipboard/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(ishuman(user))
		var/mob/M = user
		if(!(istype(over, /atom/movable/screen) ))
			return ..()

		if(!M.restrained() && !M.stat)
			switch(over.name)
				if("right hand")
					M.u_equip(src)
					M.equip_to_slot_if_possible(src, slot_r_hand)
				if("left hand")
					M.u_equip(src)
					M.equip_to_slot_if_possible(src, slot_l_hand)

			add_fingerprint(M)
			return

/obj/item/clipboard/update_icon()
	ClearOverlays()
	var/list/to_add = list()
	if(toppaper)
		to_add += toppaper.icon_state
		// The overlay list is a special internal format.
		// We need to copy it into a normal list before we can give it to SSoverlay.
		to_add += toppaper.overlays.Copy()
	if(haspen)
		to_add += "clipboard_pen"
	to_add += "clipboard_over"
	AddOverlays(to_add)

/obj/item/clipboard/attackby(obj/item/attacking_item, mob/user)

	if(istype(attacking_item, /obj/item/paper) || istype(attacking_item, /obj/item/photo))
		user.drop_from_inventory(attacking_item, src)
		if(istype(attacking_item, /obj/item/paper))
			toppaper = attacking_item
		r_contents = reverselist(contents)
		to_chat(user, SPAN_NOTICE("You clip the [attacking_item] onto \the [src]."))

	else if(istype(toppaper) && attacking_item.ispen())
		toppaper.attackby(attacking_item, user)

	else if(attacking_item.ispen())
		add_pen(user)

	if(ui_open)
		attack_self(user)

	update_icon()

	return

/obj/item/clipboard/attack_self(mob/user as mob)
	var/dat = ""
	if(haspen)
		dat += "<A href='byond://?src=[REF(src)];pen=1'>Remove Pen</A><BR><HR>"
	else
		dat += "<A href='byond://?src=[REF(src)];addpen=1'>Add Pen</A><BR><HR>"

	//The topmost paper. I don't think there's any way to organise contents in byond, so this is what we're stuck with.	-Pete
	//i'm leaving this here because it's funny - wildkins

	if(toppaper)
		var/obj/item/paper/P = toppaper
		dat += "<A href='byond://?src=[REF(src)];write=[REF(P)]'>Write</A> <A href='byond://?src=[REF(src)];remove=[REF(P)]'>Remove</A> <A href='byond://?src=[REF(src)];rename=[REF(P)]'>Rename</A> - <A href='byond://?src=[REF(src)];read=[REF(P)]'>[P.name]</A><BR><HR>"

	for(var/obj/item/paper/P in r_contents) // now this is podracing
		if(P==toppaper)
			continue
		dat += "<A href='byond://?src=[REF(src)];write=[REF(P)]'>Write</A> <A href='byond://?src=[REF(src)];remove=[REF(P)]'>Remove</A> <A href='byond://?src=[REF(src)];rename=[REF(P)]'>Rename</A> - <A href='byond://?src=[REF(src)];read=[REF(P)]'>[P.name]</A><BR>"
	for(var/obj/item/photo/Ph in r_contents)
		dat += "<A href='byond://?src=[REF(src)];remove=[REF(Ph)]'>Remove</A> <A href='byond://?src=[REF(src)];rename=[REF(Ph)]'>Rename</A> - <A href='byond://?src=[REF(src)];look=[REF(Ph)]'>[Ph.name]</A><BR>"

	user << browse(HTML_SKELETON_TITLE("Clipboard", dat), "window=clipboard")
	if(!ui_open)
		ui_open = TRUE
	onclose(user, "clipboard")
	add_fingerprint(user)
	return

/obj/item/clipboard/proc/add_pen(mob/user)
	if(!haspen)
		var/obj/item/pen/W = user.get_active_hand()
		if(W.ispen())
			user.drop_from_inventory(W,src)
			haspen = W
			to_chat(user, SPAN_NOTICE("You slot the pen into \the [src]."))
	else
		to_chat(user, SPAN_NOTICE("This clipboard already has a pen!"))

/obj/item/clipboard/Topic(href, href_list)
	..()
	if((usr.stat || usr.restrained()))
		return

	if(src.loc == usr)

		if(href_list["pen"])
			if(istype(haspen) && (haspen.loc == src))
				haspen.forceMove(usr.loc)
				usr.put_in_hands(haspen)
				haspen = null

		else if(href_list["addpen"])
			add_pen(usr)

		else if(href_list["write"])
			var/obj/item/P = locate(href_list["write"])

			if(P && (P.loc == src) && istype(P, /obj/item/paper))

				var/obj/item/I = usr.get_active_hand()

				if(I.ispen())
					P.attackby(I, usr)
				else if (haspen)
					P.attackby(haspen, usr)

		else if(href_list["remove"])
			var/obj/item/P = locate(href_list["remove"])

			if(P && (P.loc == src) && (istype(P, /obj/item/paper) || istype(P, /obj/item/photo)) )

				r_contents -= P
				P.forceMove(usr.loc)
				usr.put_in_hands(P)
				if(P == toppaper)
					toppaper = null
					var/obj/item/paper/newtop = locate(/obj/item/paper) in src
					if(newtop && (newtop != P))
						toppaper = newtop
					else
						toppaper = null

		else if(href_list["rename"])
			var/obj/item/O = locate(href_list["rename"])

			if(O && (O.loc == src))
				if(istype(O, /obj/item/paper))
					var/obj/item/paper/to_rename = O
					to_rename.rename()

				else if(istype(O, /obj/item/photo))
					var/obj/item/photo/to_rename = O
					to_rename.rename()

		else if(href_list["read"])
			var/obj/item/paper/P = locate(href_list["read"])
			if(istype(P) && (P.loc == src))
				P.show_content(usr)

		else if(href_list["look"])
			var/obj/item/photo/P = locate(href_list["look"])
			if(P && (P.loc == src) && istype(P, /obj/item/photo) )
				P.show(usr)

		else if(href_list["top"]) // currently unused
			var/obj/item/P = locate(href_list["top"])
			if(P && (P.loc == src) && istype(P, /obj/item/paper) )
				toppaper = P
				to_chat(usr, SPAN_NOTICE("You move [P.name] to the top."))

		//Update everything
		attack_self(usr)
		update_icon()
	return
