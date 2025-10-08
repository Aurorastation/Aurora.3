/**
 *	Omni-Restocker
 */


/obj/machinery/vending/vendors
	name = "Omni-Restocker"
	desc = "The mother of all vendors, from which vending itself comes!"
	icon_state = "engivend"
	icon_vend = "engivend-vend"
	vend_id = "admin"
	req_access = list(ACCESS_JANITOR)
	products = list(
		/obj/item/device/vending_refill/booze = 2,
		/obj/item/device/vending_refill/tools = 2,
		/obj/item/device/vending_refill/coffee = 2,
		/obj/item/device/vending_refill/snack = 2,
		/obj/item/device/vending_refill/cola = 2,
		/obj/item/device/vending_refill/zora = 2,
		/obj/item/device/vending_refill/frontiervend = 2,
		/obj/item/device/vending_refill/smokes = 2,
		/obj/item/device/vending_refill/meds = 2,
		/obj/item/device/vending_refill/robust = 2,
		/obj/item/device/vending_refill/hydro = 2,
		/obj/item/device/vending_refill/cutlery = 2,
		/obj/item/device/vending_refill/robo = 2,
		/obj/item/device/vending_refill/battlemonsters = 2,
		/obj/item/device/vending_refill/encryption = 2
	)
	random_itemcount = 0
	light_color = COLOR_GOLD
	light_mask = "engivend-light-mask"

/obj/machinery/vending/vendors/low_supply
	products = list(
		/obj/item/device/vending_refill/tools = 1,
		/obj/item/device/vending_refill/coffee = 1,
		/obj/item/device/vending_refill/meds = 1,
		/obj/item/device/vending_refill/robust = 1,
		/obj/item/device/vending_refill/hydro = 1,
		/obj/item/device/vending_refill/cutlery = 1,
		/obj/item/device/vending_refill/robo = 1,
		/obj/item/device/vending_refill/battlemonsters = 1,
		/obj/item/device/vending_refill/encryption = 1
	)
