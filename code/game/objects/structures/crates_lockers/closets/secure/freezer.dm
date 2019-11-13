/obj/structure/closet/secure_closet/freezer

/obj/structure/closet/secure_closet/freezer/update_icon()
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

/obj/structure/closet/secure_closet/freezer/kitchen
	name = "kitchen cabinet"
	req_access = list(access_kitchen)

	fill()
		for(var/i = 0, i < 2, i++)
			new /obj/item/reagent_containers/food/condiment/flour(src)
		new /obj/item/reagent_containers/food/condiment/sugar(src)
		new /obj/item/reagent_containers/food/condiment/spacespice(src)

/obj/structure/closet/secure_closet/freezer/kitchen/mining
	req_access = list()

/obj/structure/closet/secure_closet/freezer/meat
	name = "meat fridge"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"


	fill()
		..()
		for(var/i = 0, i < 8, i++)
			new /obj/item/reagent_containers/food/snacks/meat/monkey(src)

/obj/structure/closet/secure_closet/freezer/fridge
	name = "refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"


	fill()
		..()
		for(var/i = 0, i < 5, i++)
			new /obj/item/reagent_containers/food/drinks/milk(src)
		for(var/i = 0, i < 2, i++)
			new /obj/item/reagent_containers/food/drinks/soymilk(src)
		for(var/i = 0, i < 2, i++)
			new /obj/item/storage/fancy/egg_box(src)


/obj/structure/closet/secure_closet/freezer/money
	name = "freezer"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_broken = "fridgebroken"
	icon_off = "fridge1"
	req_access = list(access_heads_vault)

	fill()
		..()
		for(var/i = 0, i < rand(15,25), i++)
			new /obj/random/spacecash(src)

		for(var/i = 0, i < rand(6,9), i++)
			new /obj/random/coin(src)