/obj/structure/closet/secure_closet/cabinet
	icon_state = "cabinet"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	door_anim_time = 0 // no animation

/obj/structure/closet/secure_closet/cabinet/bar
	name = "booze closet"
	req_access = list(access_bar)
	storage_capacity = 45 //such a big closet deserves a little more capacity

/obj/structure/closet/secure_closet/cabinet/bar/fill()
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
