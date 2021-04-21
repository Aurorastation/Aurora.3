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

/obj/structure/closet/secure_closet/bar/fill()
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