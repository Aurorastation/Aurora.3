/**
 *  Datum used to hold information about a product in a vending machine
 */
/datum/data/vending_product
	var/product_name = "generic" // Display name for the product
	var/product_path = null
	var/category = CAT_NORMAL
	var/stock_amount = 0
	var/product_price = 0  // Price to buy one
	var/icon/product_icon
	var/icon/icon_state

/datum/data/vending_product/New(var/path, var/price = 0, var/stock = 1, var/cat = CAT_NORMAL)
	..()

	product_path = path
	var/atom/A = new path(null)

	product_name = initial(A.name)
	product_price = price
	stock_amount = stock
	category = cat

	if(istype(A, /obj/item/seeds))
		// thanks seeds for being overlays defined at runtime
		var/obj/item/seeds/S = A
		product_icon = S.update_appearance(TRUE)
	else
		product_icon = new /icon(A.icon, A.icon_state)
	icon_state = product_icon
	QDEL_NULL(A)

/obj/item/vending_refill
	name = "resupply canister"
	var/vend_id = "generic"

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
		to_chat(user, "It can restock [charges] item(s).")
	else
		to_chat(user, "It's empty!")

/obj/item/vending_refill/proc/restock_inventory(var/obj/machinery/vending/vendor)
	if(vendor)
		for(var/datum/data/vending_product/product in vendor.product_records)
			if(product.amount < product.max_amount)
				var/expense = product.max_amount - product.amount
				if(charges < expense)
					expense = charges
				product.amount += expense
				charges -= expense
				if(!charges)
					break

//can refill most vendors from half depleted once.

/obj/item/vending_refill/booze
	name = "booze resupply canister"
	vend_id = "booze"
	charges = 100 //holy shit that's a lot of booze

/obj/item/vending_refill/tools
	name = "tools resupply canister"
	vend_id = "tools"
	charges = 25

/obj/item/vending_refill/coffee
	name = "coffee resupply canister"
	vend_id = "coffee"
	charges = 38

/obj/item/vending_refill/snack
	name = "snacks resupply canister"
	vend_id = "snacks"
	charges = 38

/obj/item/vending_refill/cola
	name = "cola resupply canister"
	vend_id = "cola"
	charges = 50

/obj/item/vending_refill/smokes
	name = "smokes resupply canister"
	vend_id = "smokes"
	charges = 25

/obj/item/vending_refill/meds
	name = "meds resupply canister"
	vend_id = "meds"
	charges = 38

/obj/item/vending_refill/robust
	name = "security resupply canister"
	vend_id = "security"
	charges = 25

/obj/item/vending_refill/hydro
	name = "hydro resupply canister"
	vend_id = "hydro"
	charges = 23

/obj/item/vending_refill/seeds
	name = "resupply canister"
	vend_id = SEED_NOUN_SEEDS
	charges = 175

/obj/item/vending_refill/cutlery
	name = "cutlery resupply canister"
	vend_id = "cutlery"
	charges = 50

/obj/item/vending_refill/robo
	name = "robo-tools resupply canister"
	vend_id = "robo-tools"
	charges = 38

/obj/item/vending_refill/zora
	name = "Zo'ra Soda resupply canister"
	vend_id = "zora"
	charges = 40

/obj/item/vending_refill/battlemonsters
	name = "Battlemonsters resupply canister"
	vend_id = "battlemonsters"
	charges = 40
