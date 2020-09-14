/obj/item/implantpad
	name = "implantpad"
	desc = "A device used to modify implants."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantpad-0"
	item_state = "electronic"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	var/obj/item/implantcase/case = null
	var/broadcasting = null
	var/listening = TRUE

/obj/item/implantpad/update_icon()
	icon_state = "implantpad-[case ? "1" : "0"]"

/obj/item/implantpad/attack_hand(mob/user)
	if(src.case && (user.l_hand == src || user.r_hand == src))
		user.put_in_active_hand(case)

		src.case.add_fingerprint(user)
		src.case = null

		src.add_fingerprint(user)
		update_icon()
		return
	return ..()

/obj/item/implantpad/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/implantcase))
		if(!case)
			user.drop_from_inventory(C,src)
			src.case = C
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] already has an implant case inside it!"))
		return
	..()

/obj/item/implantpad/attack_self(mob/user)
	user.set_machine(src)
	var/dat = "<B>Implant Mini-Computer:</B><HR>"
	if (src.case)
		if(src.case.imp)
			if(istype(src.case.imp, /obj/item/implant))
				dat += src.case.imp.get_data()
				if(istype(src.case.imp, /obj/item/implant/tracking))
					dat += {"ID (1-100):
					<A href='byond://?src=\ref[src];tracking_id=-10'>-</A>
					<A href='byond://?src=\ref[src];tracking_id=-1'>-</A> [case.imp:id]
					<A href='byond://?src=\ref[src];tracking_id=1'>+</A>
					<A href='byond://?src=\ref[src];tracking_id=10'>+</A><BR>"}
		else
			dat += "The implant casing is empty."
	else
		dat += "Please insert an implant casing!"

	var/datum/browser/implantpad_win = new(user, "implantpad", capitalize_first_letters(name))
	implantpad_win.set_content(dat)
	implantpad_win.open()

/obj/item/implantpad/Topic(href, href_list)
	..()
	if (usr.stat)
		return
	if ((usr.contents.Find(src)) || ((in_range(src, usr) && istype(src.loc, /turf))))
		usr.set_machine(src)
		if (href_list["tracking_id"])
			var/obj/item/implant/tracking/T = src.case.imp
			T.id += text2num(href_list["tracking_id"])
			T.id = min(100, T.id)
			T.id = max(1, T.id)

		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=implantpad")