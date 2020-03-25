/obj/item/stack/wrapping_paper
	name = "wrapping paper"
	desc = "You can use this to wrap items in."
	icon = 'icons/obj/stacks/wrap.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/stacks/lefthand_wrap.dmi',
		slot_r_hand_str = 'icons/mob/items/stacks/righthand_wrap.dmi',
		)
	icon_state = "wrap_paper"
	singular_name = "square unit"
	amount = 20.0
	drop_sound = 'sound/items/drop/wrapper.ogg'

/obj/item/stack/wrapping_paper/attackby(obj/item/W, mob/user)
	..()
	if (!isturf(loc))
		to_chat(user, span("warning", "The paper must be set down for you to wrap a gift!"))
		return
	if (W.w_class < 4)
		var/a_used = 2 * (src.w_class - 1)
		if (src.amount < a_used)
			to_chat(user, span("warning", "You need more paper!"))
			return
		else
			if(istype(W, /obj/item/smallDelivery) || istype(W, /obj/item/gift)) //No gift wrapping gifts!
				return

			src.amount -= a_used
			user.drop_item()
			var/obj/item/gift/G = new /obj/item/gift(src.loc)
			G.size = W.w_class
			G.w_class = G.size + 1
			G.icon_state = text("gift[]", G.size)
			G.gift = W
			W.forceMove(G)
			G.add_fingerprint(user)
			W.add_fingerprint(user)
			src.add_fingerprint(user)
		if (src.amount <= 0)
			new /obj/item/c_tube(src.loc)
			qdel(src)
			return

	else
		to_chat(user, span("warning", "This object is far too large to wrap!"))
	return



/obj/item/stack/wrapping_paper/examine(mob/user)
	if(..(user, 1))
		to_chat(user, "There [amount == 1 ? "is" : "are"] about [amount] [singular_name]\s of paper left!")

/obj/item/stack/wrapping_paper/attack(mob/target as mob, mob/user as mob)
	if (!istype(target, /mob/living/carbon/human)) return
	var/mob/living/carbon/human/H = target

	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket) || H.stat)
		if (src.amount > 2)
			var/obj/effect/spresent/present = new /obj/effect/spresent (H.loc)
			src.amount -= 2

			if (H.client)
				H.client.perspective = EYE_PERSPECTIVE
				H.client.eye = present

			H.forceMove(present)

			H.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been wrapped with [src.name]  by [user.name] ([user.ckey])</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to wrap [H.name] ([H.ckey])</font>")
			msg_admin_attack("[key_name_admin(user)] used [src] to wrap [key_name_admin(H)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(H))

		else
			to_chat(user, "<span class='warning'>You need more paper.</span>")
	else
		to_chat(user, "They are moving around too much. A straightjacket would help.")

/obj/item/stack/packageWrap
	name = "package wrapper"
	icon = 'icons/obj/stacks/wrap.dmi'
	icon_state = "deliveryPaper"
	desc = "A roll of paper used to enclose an object for delivery."
	w_class = 3.0
	amount = 25.0
	var/wrapping_tag = "Sorting Office"
	drop_sound = 'sound/items/drop/wrapper.ogg'

/obj/item/stack/packageWrap/afterattack(var/obj/target as obj, mob/user as mob, proximity)
	if(!proximity) return
	if(!istype(target))	//this really shouldn't be necessary (but it is).	-Pete
		return
	if(istype(target, /obj/item/smallDelivery) || istype(target,/obj/structure/bigDelivery) \
	|| istype(target, /obj/item/gift) || istype(target, /obj/item/evidencebag))
		return
	if(target.anchored)
		return
	if(target in user)
		return
	if(user in target) //no wrapping closets that you are inside - it's not physically possible
		return

	user.attack_log += text("\[[time_stamp()]\] <font color='blue'>Has used [src.name] on \ref[target]</font>")


	if (istype(target, /obj/item) && !(istype(target, /obj/item/storage) && !istype(target,/obj/item/storage/box)))
		var/obj/item/O = target
		if (src.amount > 1)
			var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(get_turf(O.loc))	//Aaannd wrap it up!
			if(!istype(O.loc, /turf))
				if(user.client)
					user.client.screen -= O
			P.wrapped = O
			O.forceMove(P)
			P.w_class = O.w_class
			var/i = round(O.w_class)
			if(i in list(1,2,3,4,5))
				P.icon_state = "deliverycrate[i]"
				switch(i)
					if(1) P.name = "tiny parcel"
					if(3) P.name = "normal-sized parcel"
					if(4) P.name = "large parcel"
					if(5) P.name = "huge parcel"
			if(i < 1)
				P.icon_state = "deliverycrate1"
				P.name = "tiny parcel"
			if(i > 5)
				P.icon_state = "deliverycrate5"
				P.name = "huge parcel"
			P.sortTag = wrapping_tag
			P.add_fingerprint(usr)
			O.add_fingerprint(usr)
			src.add_fingerprint(usr)
			src.amount -= 1
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
			"You hear someone taping paper around a small object.")
			playsound(loc, 'sound/items/package_wrap.ogg', 50, 1)
	else if (istype(target, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/O = target
		if (src.amount > 3 && !O.opened)
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
			P.icon_state = "deliverycrate"
			P.wrapped = O
			P.sortTag = wrapping_tag
			O.forceMove(P)
			src.amount -= 3
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
			"You hear someone taping paper around a large object.")
			playsound(loc, 'sound/items/package_wrap.ogg', 50, 1)
		else if(src.amount < 3)
			to_chat(user, "<span class='warning'>You need more paper.</span>")
	else if (istype (target, /obj/structure/closet))
		var/obj/structure/closet/O = target
		if (src.amount > 3 && !O.opened)
			var/obj/structure/bigDelivery/P = new /obj/structure/bigDelivery(get_turf(O.loc))
			P.wrapped = O
			O.welded = 1
			P.sortTag = wrapping_tag
			O.forceMove(P)
			src.amount -= 3
			user.visible_message("\The [user] wraps \a [target] with \a [src].",\
			"<span class='notice'>You wrap \the [target], leaving [amount] units of paper on \the [src].</span>",\
			"You hear someone taping paper around a large object.")
			playsound(loc, 'sound/items/package_wrap.ogg', 50, 1)
		else if(src.amount < 3)
			to_chat(user, "<span class='warning'>You need more paper.</span>")
	else
		to_chat(user, "<span class='notice'>The object you are trying to wrap is unsuitable for the sorting machinery!</span>")
	if (src.amount <= 0)
		new /obj/item/c_tube( src.loc )
		qdel(src)
		return
	return

/obj/item/stack/packageWrap/examine(mob/user)
	if(..(user, 0))
		to_chat(user, "<span class='notice'>There are [amount] units of package wrap left!</span>")

	return

/obj/item/c_tube
	name = "cardboard tube"
	desc = "A tube... of cardboard."
	icon = 'icons/obj/stacks/wrap.dmi'
	icon_state = "c_tube"
	throwforce = 1
	w_class = 2.0
	throw_speed = 4
	throw_range = 5