/obj/item/weapon/vending_refill
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

/obj/item/weapon/vending_refill/examine(mob/user)
	..()
	if(charges > 0)
		to_chat(user, "It can restock [charges] item(s).")
	else
		to_chat(user, "It's empty!")

/obj/item/weapon/vending_refill/proc/restock_inventory(var/obj/machinery/vending/vendor)
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

/obj/item/weapon/vending_refill/booze
	name = "booze resupply canister"
	vend_id = "booze"
	charges = 123 //default-stock: 246

/obj/item/weapon/vending_refill/tools
	name = "tools resupply canister"
	vend_id = "tools"
	charges = 28 //default-stock: 62, 48

/obj/item/weapon/vending_refill/coffee
	name = "coffee resupply canister"
	vend_id = "coffee"
	charges = 52 //default-stock: 105

/obj/item/weapon/vending_refill/snack
	name = "snacks resupply canister"
	vend_id = "snacks"
	charges = 35 //default-stock: 71

/obj/item/weapon/vending_refill/cola
	name = "cola resupply canister"
	vend_id = "cola"
	charges = 53 //default-stock: 106

/obj/item/weapon/vending_refill/pda
	name = "pdas resupply canister"
	vend_id = "pdas"
	charges = 36 //default-stock: 73

/obj/item/weapon/vending_refill/smokes
	name = "smokes resupply canister"
	vend_id = "smokes"
	charges = 34 //default-stock: 68

/obj/item/weapon/vending_refill/meds
	name = "meds resupply canister"
	vend_id = "meds"
	charges = 33 //default-stock: 66 (NanoMed plus)

/obj/item/weapon/vending_refill/robust
	name = "security resupply canister"
	vend_id = "security"
	charges = 20 //default-stock: 41

/obj/item/weapon/vending_refill/hydro
	name = "hydro resupply canister"
	vend_id = "hydro"
	charges = 30 //default-stock: 61

/obj/item/weapon/vending_refill/seeds
	name = "resupply canister"
	vend_id = "seeds"
	charges = 74 //default-stock: 148

/obj/item/weapon/vending_refill/cutlery
	name = "cutlery resupply canister"
	vend_id = "cutlery"
	charges = 35 //default-stock: 71

/obj/item/weapon/vending_refill/robo
	name = "robo-tools resupply canister"
	vend_id = "robo-tools"
	charges = 32 //default-stock: 64

/obj/item/weapon/vending_refill/zora
	name = "Zo'ra Soda resupply canister"
	vend_id = "zora"
	charges = 17 //default-stock: 35

/obj/item/weapon/vending_refill/battlemonsters
	name = "Battlemonsters resupply canister"
	vend_id = "battlemonsters"
	charges = 24 //default-stock: 48