/obj/structure/closet/secure_closet/bar
	name = "booze closet"
	req_access = list(access_bar)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_broken"
	icon_off = "cabinetdetective_broken"
	storage_capacity = 45 //such a big closet deserves a little more capacity


	fill()
		new /obj/item/reagent_containers/food/drinks/bottle/small/beer( src )
		new /obj/item/reagent_containers/food/drinks/bottle/small/beer( src )
		new /obj/item/reagent_containers/food/drinks/bottle/small/beer( src )
		new /obj/item/reagent_containers/food/drinks/bottle/small/beer( src )
		new /obj/item/reagent_containers/food/drinks/bottle/small/beer( src )
		new /obj/item/reagent_containers/food/drinks/bottle/small/beer( src )
		new /obj/item/reagent_containers/food/drinks/bottle/small/beer( src )
		new /obj/item/reagent_containers/food/drinks/bottle/small/beer( src )
		new /obj/item/reagent_containers/food/drinks/bottle/small/beer( src )
		new /obj/item/reagent_containers/food/drinks/bottle/small/beer( src )

/obj/structure/closet/secure_closet/bar/attackby(obj/item/W as obj, mob/user as mob)
	if(opened)
		if(istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			if(large)
				MouseDrop_T(G.affecting, user)	//act like they were dragged onto the closet
			else
				to_chat(user, "<span class='notice'>The locker is too small to stuff [G.affecting] into!</span>")
		else if(isrobot(user))
			return
		else if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		if(W)
			user.drop_from_inventory(W,loc)
		else
			user.drop_item()
	else if(!opened)
		if(istype(W, /obj/item/melee/energy/blade))//Attempt to cut open locker if locked
			if(emag_act(INFINITY, user, "<span class='danger'>The locker has been sliced open by [user] with \an [W]</span>!", "<span class='danger'>You hear metal being sliced and sparks flying.</span>"))
				spark(src, 5)
				playsound(loc, 'sound/weapons/blade.ogg', 50, 1)
				playsound(loc, "sparks", 50, 1)
		else
			togglelock(user)//Attempt to lock locker if closed

/obj/structure/closet/secure_closet/bar/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened
