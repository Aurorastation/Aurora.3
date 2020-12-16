/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor."
	icon_state = "sec"
	deny_time = 16
	req_access = list(access_security)
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/handcuffs, 8, FALSE),
			VENDOR_PRODUCT(/obj/item/grenade/chem_grenade/teargas, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/device/flash, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/spray/pepper, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/evidence, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/device/holowarrant, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/device/flashlight/maglight, 5, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/donut, 2, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/clothing/glasses/sunglasses, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/grenade/flashbang, 4, FALSE)
		)
	)
	restock_blacklist = list(
		/obj/item/storage/box/fancy/donut,
		/obj/item/storage/box/evidence,
		/obj/item/device/flash,
		/obj/item/reagent_containers/spray/pepper
		)
	restock_items = TRUE
	randomize_qty = FALSE
	light_color = COLOR_BABY_BLUE
	exclusive_screen = FALSE

/obj/item/vending_refill/robust
	name = "security resupply canister"
	charges = 25
