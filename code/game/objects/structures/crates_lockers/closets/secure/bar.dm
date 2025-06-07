/obj/structure/closet/secure_closet/cabinet
	icon_state = "cabinet"
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	door_anim_angle = 160
	door_anim_squish = 0.22
	door_hinge_x_alt = 7.5
	double_doors = TRUE

/obj/structure/closet/secure_closet/cabinet/bar
	name = "booze closet"
	req_access = list(ACCESS_BAR)
	storage_capacity = 45 //such a big closet deserves a little more capacity

/obj/structure/closet/secure_closet/cabinet/bar/fill()
	new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)
	new /obj/item/reagent_containers/food/drinks/bottle/small/beer(src)

/obj/structure/closet/secure_closet/cabinet/beer
	name = "beer closet"
	desc = "A cabinet stacked end-to-end with six packs of beer."
	req_access = null
	storage_capacity = 45

/obj/structure/closet/secure_closet/cabinet/beer/fill()
	new /obj/item/storage/box/fancy/yoke/beer(src)
	new /obj/item/storage/box/fancy/yoke/ebisu(src)
	new /obj/item/storage/box/fancy/yoke/shimauma(src)
	new /obj/item/storage/box/fancy/yoke/moonlabor(src)
	new /obj/item/storage/box/fancy/yoke/earthmover(src)
	new /obj/item/storage/box/fancy/yoke/whistlingforest(src)
	new /obj/item/storage/box/fancy/yoke/threetowns(src)

/obj/structure/closet/secure_closet/cabinet/beer/horizon
	req_access = list(ACCESS_BAR)
