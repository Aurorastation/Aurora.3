/*
*   Vending products are defined with the VENDOR_PRODUCT macro:
*       VENDOR_PRODUCT(typepath_to_item, item stock, price)
*       Place `FALSE` in the price field to make the item free
*/

/obj/machinery/vending/vendors
	name = "Omni-Vendor"
	desc = "The mother of all vendors, from which vending itself comes!"
	icon_state = "engivend"
	deny_time = 6
	req_access = list(access_janitor)
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/vending_refill/booze, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/vending_refill/tools, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/vending_refill/coffee, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/vending_refill/snack, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/vending_refill/cola, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/vending_refill/smokes, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/vending_refill/meds, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/vending_refill/robust, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/vending_refill/hydro, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/vending_refill/cutlery, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/vending_refill/robo, 1, FALSE),
			VENDOR_PRODUCT(/obj/item/vending_refill/battlemonsters, 1, FALSE)
		)
	)
	randomize_qty = FALSE
	light_color = COLOR_GOLD

/obj/item/vending_refill
	name = "resupply canister"

	icon = 'icons/obj/assemblies/electronic_setups.dmi'
	icon_state = "setup_medium-open"
	item_state = "restock_unit"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_device.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_device.dmi',
		)
	desc = "A vending machine restock cart."
	force = 7
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = ITEMSIZE_NORMAL
	var/charges = 0

/obj/item/vending_refill/examine(mob/user)
	..()
	if(charges > 0)
		to_chat(user, SPAN_INFO("It can restock items [charges] [charges > 1 ? "times" : "time"]."))
	else
		to_chat(user, SPAN_WARNING("It's empty!"))

/obj/item/vending_refill/proc/restock_inventory(var/obj/machinery/vending/vendor)
	if(!istype(vendor))
		return
	for(var/datum/data/vending_product/product in vendor.product_records)
		var/expense = vendor.get_initial_stock(product) - vendor.get_stock(product)
		if(expense > 0)
			expense = min(charges, expense)
			vendor.product_records[product][VENDOR_STOCK] += expense
			charges -= expense
			if(!charges)
				break

//can refill most vendors from half depleted once.
