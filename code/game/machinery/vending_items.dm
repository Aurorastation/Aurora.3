/obj/item/vending_refill
	name = "resupply canister"
	var/vend_id = "generic"

	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup_medium-open"
	item_state = "RPED"
	desc = "A vending machine restock cart."
	force = 7
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = 3
	var/charges = 0

/obj/item/vending_refill/Initialize(amt = -1)
	..()
	name = "\improper [vend_id] restocking unit"
	if(isnum(amt) && amt > -1)
		charges[1] = amt

/obj/item/vending_refill/examine(mob/user)
	..()
	if(charges[1] > 0)
		to_chat(user, "It can restock [charges[1]+charges[2]+charges[3]] item(s).")
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

//can refill most vendors from completely depleted once.

/obj/item/vending_refill/booze
	name = "resupply canister"
	vend_id = "booze"
	charges = 200 //holy shit that's a lot of booze

/obj/item/vending_refill/tools
	name = "resupply canister"
	vend_id = "tools"
	charges = 50

/obj/item/vending_refill/coffee
	name = "resupply canister"
	vend_id = "coffee"
	charges = 75

/obj/item/vending_refill/snack
	name = "resupply canister"
	vend_id = "snacks"
	charges = 75

/obj/item/vending_refill/cola
	name = "resupply canister"
	vend_id = "cola"
	charges = 100

/obj/item/vending_refill/pda
	name = "resupply canister"
	vend_id = "pdas"
	charges = 75

/obj/item/vending_refill/smokes
	name = "resupply canister"
	vend_id = "smokes"
	charges = 50

/obj/item/vending_refill/meds
	name = "resupply canister"
	vend_id = "meds"
	charges = 75

/obj/item/vending_refill/robust
	name = "resupply canister"
	vend_id = "security"
	charges = 50

/obj/item/vending_refill/hydro
	name = "resupply canister"
	vend_id = "hydro"
	charges = 45

/obj/item/vending_refill/seeds
	name = "resupply canister"
	vend_id = "seeds"
	charges = 350

/obj/item/vending_refill/cutlery
	name = "resupply canister"
	vend_id = "cutlery"
	charges = 100

/obj/item/vending_refill/robo
	name = "resupply canister"
	vend_id = "robo-tools"
	charges = 75

/obj/item/vending_refill/vend
	name = "resupply canister"
	vend_id = "restocking unit"
	charges = 24