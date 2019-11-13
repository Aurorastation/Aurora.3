/obj/structure/closet/coffin
	name = "coffin"
	desc = "It's a burial receptacle for the dearly departed."
	icon_state = "coffin"
	icon_closed = "coffin"
	icon_opened = "coffin_open"

/obj/structure/closet/coffin/attackby(obj/item/W as obj, mob/user as mob)
	if(opened)
		if(istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			MouseDrop_T(G.affecting, user)      //act like they were dragged onto the closet
			return 0
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(!dropsafety(W))
			return
		if(W)
			user.drop_from_inventory(W,loc)
		else
			user.drop_item()
	else if(istype(W, /obj/item/stack/packageWrap))
		return
	else
		attack_hand(user)
	return

/obj/structure/closet/coffin/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened
