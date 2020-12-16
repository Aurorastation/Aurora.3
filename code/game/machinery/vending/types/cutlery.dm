/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	icon_state = "dinnerware"
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/material/kitchen/utensil/fork, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/material/kitchen/utensil/knife, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/material/kitchen/utensil/spoon, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/material/knife, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/material/hatchet/butch, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/drinkingglass, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/suit/chef/classic, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/material/kitchen/rollingpin, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/cooking_container/oven, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/cooking_container/fryer, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/cooking_container/skillet, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/cooking_container/saucepan, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/cooking_container/pot, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/cooking_container/plate, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/cooking_container/plate/bowl, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/ladle, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/toolbox/lunchbox/nt, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/rag, 8, FALSE),
			VENDOR_PRODUCT(/obj/item/tray, 12, FALSE),
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/storage/toolbox/lunchbox/syndicate, 2, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/storage/toolbox/lunchbox/nt/filled, 2, FALSE)
		)
	)
	restock_items = TRUE
	randomize_qty = FALSE
	light_color = COLOR_STEEL

/obj/machinery/vending/dinnerware/plastic
	name = "Utensil Vendor"
	desc = "A kitchen and restaurant utensil vendor."
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/material/kitchen/utensil/fork/plastic, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/material/kitchen/utensil/spoon/plastic, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/material/kitchen/utensil/knife/plastic, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/drinkingglass, 12, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/storage/toolbox/lunchbox/syndicate, 2, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/storage/toolbox/lunchbox/nt/filled, 2, FALSE)
		)
	)

/obj/item/vending_refill/cutlery
	name = "cutlery resupply canister"
	charges = 50
