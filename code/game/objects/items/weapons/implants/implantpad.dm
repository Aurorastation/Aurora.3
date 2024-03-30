/obj/item/implantpad
	name = "implantpad"
	desc = "A device used to modify implants."
	icon = 'icons/obj/item/implants.dmi'
	icon_state = "implantpad-0"
	item_state = "electronic"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	var/obj/item/implantcase/case = null
	var/broadcasting = null
	var/listening = TRUE

/obj/item/implantpad/update_icon()
	cut_overlays()
	icon_state = "implantpad-[case ? "1" : "0"]"
	if(case?.imp)
		var/obj/item/implant/caseimplant = case.imp
		var/implant_overlay_icon_state = "implantstorage_[caseimplant.implant_icon]"
		var/mutable_appearance/implant_case_implant_overlay = mutable_appearance(icon, implant_overlay_icon_state)
		add_overlay(implant_case_implant_overlay)


/obj/item/implantpad/attack_hand(mob/user)
	if(case && (user.l_hand == src || user.r_hand == src))
		user.put_in_active_hand(case)

		case.add_fingerprint(user)
		case = null

		add_fingerprint(user)
		update_icon()
		return
	return ..()

/obj/item/implantpad/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/implantcase))
		if(!case)
			user.drop_from_inventory(attacking_item, src)
			case = attacking_item
			update_icon()
		else
			to_chat(user, SPAN_WARNING("\The [src] already has an implant case attached to it!"))
	..()

/obj/item/implantpad/attack_self(mob/user)
	if(case?.imp)
		case.imp.interact(user)
	else
		to_chat(user, SPAN_WARNING("There's no implant loaded in \the [src]!"))

/obj/item/implantpad/Topic(href, href_list)
	..()
	if (usr.stat)
		return
	if ((usr.contents.Find(src)) || ((in_range(src, usr) && istype(src.loc, /turf))))
		usr.set_machine(src)

		if (istype(src.loc, /mob))
			attack_self(src.loc)
		else
			for(var/mob/M in viewers(1, src))
				if (M.client)
					src.attack_self(M)
		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=implantpad")
