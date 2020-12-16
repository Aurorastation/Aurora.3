/**
 *  Datum used to hold information about a product in a vending machine
 */
/datum/data/vending_product
	var/product_name = "generic" // Display name for the product
	var/product_path = null
	var/category = CAT_NORMAL
	var/icon/product_icon
	var/icon/icon_state

/datum/data/vending_product/New(var/path, var/stock = 1, var/cat = CAT_NORMAL)
	..()
	product_path = path
	var/atom/A = new path(null)

	product_name = initial(A.name)
	category = cat

	if(istype(A, /obj/item/seeds))
		// thanks seeds for being overlays defined at runtime
		var/obj/item/seeds/S = A
		product_icon = S.update_appearance(TRUE)
		product_name = S.name
	else
		product_icon = new /icon(A.icon, A.icon_state)
	icon_state = product_icon
	QDEL_NULL(A)
