/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	icon_state = "snack"
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/candy, 6, 15),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/dry_ramen, 6, 20),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/chips, 6, 17),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/sosjerky, 6, 20),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/no_raisin, 6, 12),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/spacetwinkie, 6, 15),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/cheesiehonkers, 6, 15),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/tastybread, 6, 18),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cookiesnack, 6, 20),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/gum, 4, 15),
			VENDOR_PRODUCT(/obj/item/clothing/mask/chewable/candy/lolli, 8, 2),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/admints, 4, 12),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/skrellsnacks, 3, 40),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/meatsnack, 2, 22),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/maps, 2, 23),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/nathisnack, 2, 24),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/koisbar_clean, 4, 60),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/candy/koko, 5, 40),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/tuna, 2, 23),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/diona_bites, 3, 40),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/ricetub, 2, 40),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/riceball, 4, 15),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/seaweed, 5, 20)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/syndicake, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/koisbar, 4, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/cookie, 6, FALSE)
		)
	)
	light_color = COLOR_BABY_BLUE

/obj/item/vending_refill/snack
	name = "snacks resupply canister"
	charges = 38
