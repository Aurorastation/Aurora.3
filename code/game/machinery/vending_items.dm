/obj/item/device/vending_refill
	name = "resupply canister"
	var/vend_id = "generic"

	icon = 'icons/obj/assemblies/electronic_setups.dmi'
	icon_state = "setup_medium-open"
	item_state = "restock_unit"
	desc = "A vending machine restock cart."
	force = 7
	throwforce = 10
	throw_speed = 1
	throw_range = 7
	w_class = ITEMSIZE_NORMAL
	var/charges = 0

/obj/item/device/vending_refill/examine(mob/user)
	..()
	if(charges > 0)
		to_chat(user, "It can restock [charges] item(s).")
	else
		to_chat(user, "It's empty!")

/obj/item/device/vending_refill/proc/restock_inventory(var/obj/machinery/vending/vendor)
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

/obj/item/device/vending_refill/booze
	name = "booze resupply canister"
	vend_id = "booze"
	charges = 100 //holy shit that's a lot of booze

/obj/item/device/vending_refill/tools
	name = "tools resupply canister"
	vend_id = "tools"
	charges = 25

/obj/item/device/vending_refill/coffee
	name = "coffee resupply canister"
	vend_id = "coffee"
	charges = 38

/obj/item/device/vending_refill/snack
	name = "snacks resupply canister"
	vend_id = "snacks"
	charges = 38

/obj/item/device/vending_refill/cola
	name = "cola resupply canister"
	vend_id = "cola"
	charges = 50

/obj/item/device/vending_refill/smokes
	name = "smokes resupply canister"
	vend_id = "smokes"
	charges = 25

/obj/item/device/vending_refill/meds
	name = "meds resupply canister"
	vend_id = "meds"
	charges = 38

/obj/item/device/vending_refill/robust
	name = "security resupply canister"
	vend_id = "security"
	charges = 25

/obj/item/device/vending_refill/hydro
	name = "hydro resupply canister"
	vend_id = "hydro"
	charges = 23

/obj/item/device/vending_refill/seeds
	name = "resupply canister"
	vend_id = SEED_NOUN_SEEDS
	charges = 175

/obj/item/device/vending_refill/cutlery
	name = "cutlery resupply canister"
	vend_id = "cutlery"
	charges = 50

/obj/item/device/vending_refill/robo
	name = "robo-tools resupply canister"
	vend_id = "robo-tools"
	charges = 38

/obj/item/device/vending_refill/zora
	name = "Zo'ra Soda resupply canister"
	vend_id = "zora"
	charges = 40

/obj/item/device/vending_refill/battlemonsters
	name = "Battlemonsters resupply canister"
	vend_id = "battlemonsters"
	charges = 40
