/**
 *	Omni-Restocker
 */


/obj/structure/machinery/vending/vendors
	name = "Omni-Restocker"
	desc = "The mother of all vendors, from which vending itself comes!"
	icon_state = "engivend"
	icon_vend = "engivend-vend"
	vend_id = "admin"
	persistent_stock = FALSE
	req_access = list(/datum/access/janitor::id)
	products = list(
		/obj/item/vending_refill/actor = 2,
		/obj/item/vending_refill/booze = 2,
		/obj/item/vending_refill/bomba = 2,
		/obj/item/vending_refill/tools = 2,
		/obj/item/vending_refill/coffee = 2,
		/obj/item/vending_refill/snack = 2,
		/obj/item/vending_refill/cola = 2,
		/obj/item/vending_refill/zora = 2,
		/obj/item/vending_refill/frontiervend = 2,
		/obj/item/vending_refill/smokes = 2,
		/obj/item/vending_refill/meds = 2,
		/obj/item/vending_refill/robust = 2,
		/obj/item/vending_refill/hydro = 2,
		/obj/item/vending_refill/cutlery = 2,
		/obj/item/vending_refill/robo = 2,
		/obj/item/vending_refill/battlemonsters = 2,
		/obj/item/vending_refill/encryption = 2,
		/obj/item/vending_refill/ert = 2,
		/obj/item/vending_refill/games = 2,
		/obj/item/vending_refill/generic_clothing = 2,
		/obj/item/vending_refill/idris_delights = 2,
		/obj/item/vending_refill/lavatory = 2,
		/obj/item/vending_refill/mre = 2,
		/obj/item/vending_refill/overloaders = 2,
		/obj/item/vending_refill/quick_meals = 2,
		/obj/item/vending_refill/ramen = 2,
		/obj/item/vending_refill/wallpharm = 2,
		/obj/item/vending_refill/wardrobe = 2
	)
	random_itemcount = 0
	light_color = COLOR_GOLD
	light_mask = "engivend-light-mask"

/obj/structure/machinery/vending/vendors/low_supply
	products = list(
		/obj/item/vending_refill/tools = 1,
		/obj/item/vending_refill/coffee = 1,
		/obj/item/vending_refill/meds = 1,
		/obj/item/vending_refill/robust = 1,
		/obj/item/vending_refill/hydro = 1,
		/obj/item/vending_refill/cutlery = 1,
		/obj/item/vending_refill/robo = 1,
		/obj/item/vending_refill/battlemonsters = 1,
		/obj/item/vending_refill/encryption = 1
	)

// Restock packs for Horizon vendors not covered by the department-specific packs.
/obj/item/vending_refill/vendors
	name = "Omni-Restocker resupply canister"
	vend_id = "admin"
	charges = 50

/obj/item/vending_refill/actor
	name = "actor supplies resupply canister"
	vend_id = "actor"
	charges = 50

/obj/item/vending_refill/bomba
	name = "Toximate resupply canister"
	vend_id = "bomba"
	charges = 50

/obj/item/vending_refill/ert
	name = "emergency security resupply canister"
	vend_id = "ert"
	charges = 50

/obj/item/vending_refill/games
	name = "games resupply canister"
	vend_id = "games"
	charges = 50

/obj/item/vending_refill/generic_clothing
	name = "generic clothing resupply canister"
	vend_id = "generic_clothing"
	charges = 60

/obj/item/vending_refill/idris_delights
	name = "Idris Delights resupply canister"
	vend_id = "idris_delights"
	charges = 50

/obj/item/vending_refill/lavatory
	name = "lavatory supplies resupply canister"
	vend_id = "lavatory"
	charges = 50

/obj/item/vending_refill/mre
	name = "MRE resupply canister"
	vend_id = "mre"
	charges = 50

/obj/item/vending_refill/overloaders
	name = "overloader resupply canister"
	vend_id = "overloaders"
	charges = 25

/obj/item/vending_refill/quick_meals
	name = "quick meals resupply canister"
	vend_id = "quick-meals"
	charges = 45

/obj/item/vending_refill/ramen
	name = "ramen resupply canister"
	vend_id = "ramen"
	charges = 30

/obj/item/vending_refill/wallpharm
	name = "pharmacy resupply canister"
	vend_id = "wallpharm"
	charges = 40

/obj/item/vending_refill/wardrobe
	name = "wardrobe resupply canister"
	vend_id = "wardrobe"
	charges = 60
