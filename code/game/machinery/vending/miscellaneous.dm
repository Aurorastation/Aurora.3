/**
 *	Toximate 3000
 *	Battlemonsters vendor
 *	GwokBuzz vendor
 *	Lavatory Essentials
 *		Low Supply
 */

/obj/machinery/vending/phoronresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"
	vend_id = "bomba"
	icon_state = "generic"
	icon_vend = "generic-vend"
	products = list(
		/obj/item/clothing/under/rank/scientist = 6,
		/obj/item/clothing/suit/hazmat = 6,
		/obj/item/clothing/head/hazmat = 6,
		/obj/item/device/transfer_valve = 6,
		/obj/item/device/assembly/timer = 6,
		/obj/item/device/assembly/signaler = 6,
		/obj/item/device/assembly/igniter = 6
	)
	contraband = list(
		/obj/item/device/assembly/prox_sensor = 4,
		/obj/item/device/assembly/infra = 4,
		/obj/item/device/assembly/mousetrap = 4,
		/obj/item/device/assembly/voice = 4
	)
	premium = list(
		/obj/item/clothing/head/collectable/petehat = 1
	)
	restock_items = TRUE
	random_itemcount = 0
	light_color = COLOR_BLUE_GRAY
	manufacturer = "scc"

/obj/machinery/vending/battlemonsters
	name = "\improper Battlemonsters vendor"
	desc = "A good place to dump all your rent money."
	icon_state = "battlemonsters"
	icon_vend = "battlemonsters-vend"
	vend_id = "battlemonsters"
	products = list(
		/obj/item/book/manual/wiki/battlemonsters = 10,
		/obj/item/battle_monsters/wrapped/basic = 20,
		/obj/item/battle_monsters/wrapped = 20,
		/obj/item/battle_monsters/wrapped/pro = 20,
		/obj/item/battle_monsters/wrapped/species = 10, //Human monsters
		/obj/item/battle_monsters/wrapped/species/lizard = 10, //Reptile Monsters
		/obj/item/battle_monsters/wrapped/species/cat = 10, //Feline Monsters
		/obj/item/battle_monsters/wrapped/species/ant = 10, //Ant Monsters
		/obj/item/battle_monsters/wrapped/rare = 10
	)
	prices = list(
		/obj/item/book/manual/wiki/battlemonsters = 15.00,
		/obj/item/battle_monsters/wrapped = 25.00,
		/obj/item/battle_monsters/wrapped/pro = 20.00,
		/obj/item/battle_monsters/wrapped/species = 15.00,
		/obj/item/battle_monsters/wrapped/species/lizard = 15.00,
		/obj/item/battle_monsters/wrapped/species/cat = 15.00,
		/obj/item/battle_monsters/wrapped/species/ant = 15.00,
		/obj/item/battle_monsters/wrapped/rare = 35.00
	)
	contraband = list(
		/obj/item/battle_monsters/wrapped/legendary = 5
	)
	premium = list(
		/obj/item/coin/battlemonsters = 10
	)
	restock_items = FALSE
	random_itemcount = FALSE
	light_color = COLOR_BABY_BLUE

/obj/item/device/vending_refill/battlemonsters
	name = "Battlemonsters resupply canister"
	vend_id = "battlemonsters"
	charges = 40


/obj/machinery/vending/overloaders
	name = "GwokBuzz Vendor"
	desc = "An entertainment software machine supplied by Gwok Software, a member of the Gwok Group."
	desc_extended = "Previously the realm of amateur programmers and niche companies, the Gwok Group acquired and amalgamated a number of popular Port Verdant overloader brands in order to capitalize on the growing industry. Seeing untapped markets abroad, the corporation has begun exporting to nations with free IPC populations."
	icon_state = "synth"
	icon_vend = "synth-vend"
	product_slogans = "GwokBuzz, to take the edge off!;Try our new Rainbow Essence flavour!;Safe and sanctioned by the authorities!"
	vend_id = "overloaders"
	products = list(
		/obj/item/storage/overloader/classic = 5,
		/obj/item/storage/overloader/tranquil = 5,
		/obj/item/storage/overloader/rainbow = 5,
		/obj/item/storage/overloader/screenshaker = 5
	)
	prices = list(
		/obj/item/storage/overloader/classic = 50.00,
		/obj/item/storage/overloader/tranquil = 60.00,
		/obj/item/storage/overloader/rainbow = 60.00,
		/obj/item/storage/overloader/screenshaker = 60.00,
		/obj/item/storage/overloader/jitterbug = 85.00
	)
	contraband = list(
		/obj/item/storage/overloader/rainbow = 2
	)
	premium = list(
		/obj/item/storage/overloader/jitterbug = 5
	)
	light_color = LIGHT_COLOR_CYAN

/obj/machinery/vending/overloaders/low_supply
	products = list(
		/obj/item/storage/overloader/classic = 2,
		/obj/item/storage/overloader/rainbow = 1,
		/obj/item/storage/overloader/screenshaker = 1
	)

/obj/machinery/vending/lavatory
	name = "Lavatory Essentials"
	desc = "Vends things that make you less reviled in the work-place!"
	icon_state = "lavatory"
	icon_vend = "lavatory-vend"
	icon_deny = "lavatory-deny"
	product_ads = "Take a shower you hippie.;Get a haircut, hippie!;Reeking of Vaurca taint? Take a shower!;You reek! Freshen up!;Hey, you dropped something!;Cleansing the world, one person at a time!"
	prices = list(
		/obj/item/soap = 3.50,
		/obj/item/mirror = 7.00,
		/obj/item/haircomb/random = 7.00,
		/obj/item/towel/random = 8.50,
		/obj/item/reagent_containers/spray/cleaner/deodorant = 5.00,
		/obj/item/reagent_containers/toothpaste = 7.00,
		/obj/item/reagent_containers/toothbrush = 3.50,
		/obj/item/reagent_containers/food/drinks/flask/vacuumflask/mouthwash = 5.00
	)
	products = list(
		/obj/item/soap = 12,
		/obj/item/mirror = 8,
		/obj/item/haircomb/random = 8,
		/obj/item/towel/random = 6,
		/obj/item/reagent_containers/spray/cleaner/deodorant = 5,
		/obj/item/reagent_containers/toothpaste = 5,
		/obj/item/reagent_containers/toothbrush = 12,
		/obj/item/reagent_containers/food/drinks/flask/vacuumflask/mouthwash = 5
	)
	premium = list(
		/obj/item/grenade/chem_grenade/metalfoam = 0
	)
	contraband = list(
		/obj/item/inflatable_duck = 1
	)

/obj/machinery/vending/lavatory/low_supply
	products = list(
		/obj/item/soap = 4,
		/obj/item/mirror = 2,
		/obj/item/haircomb/random = 3,
		/obj/item/towel/random = 4,
		/obj/item/reagent_containers/spray/cleaner/deodorant = 2,
		/obj/item/reagent_containers/toothpaste = 3,
		/obj/item/reagent_containers/toothbrush = 6,
		/obj/item/reagent_containers/food/drinks/flask/vacuumflask/mouthwash = 2
	)
