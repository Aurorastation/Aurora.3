/singleton/cargo_item/cargotraintrolley
	category = "operations"
	name = "cargo train trolley"
	supplier = "orion"
	description = "A cargo trolley for carrying cargo, NOT people."
	price = 800
	items = list(
		/obj/vehicle/train/cargo/trolley
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/cargotraintug
	category = "operations"
	name = "cargo train tug"
	supplier = "orion"
	description = "A ridable electric car designed for pulling cargo trolleys."
	price = 350
	items = list(
		/obj/vehicle/train/cargo/engine
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/space_bike
	category = "operations"
	name = "space-bike"
	supplier = "hephaestus"
	description = "Space wheelies! Woo!"
	price = 800
	items = list(
		/obj/vehicle/bike
	)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/snowmobile
	category = "operations"
	name = "snowmobile"
	supplier = "zharkov"
	description = "A vehicle adapted to travel on snow."
	price = 800
	items = list(
		/obj/vehicle/bike/snow
	)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/cargosled
	category = "operations"
	name = "cargo sled"
	supplier = "zharkov"
	description = "A cargo sled that can be hitched to a snowmobile. Suitable for cargo."
	price = 400
	items = list(
		/obj/vehicle/train/cargo/trolley/sled
	)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/monowheel
	category = "operations"
	name = "monowheel"
	supplier = "zharkov"
	description = "A one-wheeled vehicle, fairly popular with Little Adhomai's greasers."
	price = 900
	items = list(
		/obj/vehicle/bike/monowheel
	)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/battlemonstersresupplycanister
	category = "operations"
	name = "battlemonsters resupply canister"
	supplier = "nanotrasen"
	description = "A vending machine restock cart for refilling battlemonsters vending machines."
	price = 2250
	items = list(
		/obj/item/vending_refill/battlemonsters
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/boozeresupplycanister
	category = "operations"
	name = "booze resupply canister"
	supplier = "orion"
	description = "A vending machine restock cart for refilling booze vending machines."
	price = 4500
	items = list(
		/obj/item/vending_refill/booze
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/zorasodaresupplycanister
	category = "operations"
	name = "zora soda resupply canister"
	supplier = "zora"
	description = "A vending machine restock cart for refilling zora soda vending machines."
	price = 1255
	items = list(
		/obj/item/vending_refill/zora
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/toolsresupplycanister
	category = "operations"
	name = "tools resupply canister"
	supplier = "hephaestus"
	description = "A vending machine restock cart for refilling tools vending machines."
	price = 2450
	items = list(
		/obj/item/vending_refill/tools
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/smokesresupplycanister
	category = "operations"
	name = "smokes resupply canister"
	supplier = "getmore"
	description = "A vending machine restock cart for refilling smokes vending machines."
	price = 2250
	items = list(
		/obj/item/vending_refill/smokes
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/snacksresupplycanister
	category = "operations"
	name = "snacks resupply canister"
	supplier = "getmore"
	description = "A vending machine restock cart for refilling snacks vending machines."
	price = 1255
	items = list(
		/obj/item/vending_refill/snack
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/robotoolsresupplycanister
	category = "operations"
	name = "robo-tools resupply canister"
	supplier = "blam"
	description = "A vending machine restock cart for refilling robo-tools vending machines."
	price = 2500
	items = list(
		/obj/item/vending_refill/robo
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/securityresupplycanister
	category = "operations"
	name = "security resupply canister"
	supplier = "blam"
	description = "A vending machine restock cart for refilling security vending machines."
	price = 4500
	items = list(
		/obj/item/vending_refill/robust
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/medsresupplycanister
	category = "operations"
	name = "meds resupply canister"
	supplier = "zeng_hu"
	description = "A vending machine restock cart for refilling meds vending machines."
	price = 5500
	items = list(
		/obj/item/vending_refill/meds
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hydroresupplycanister
	category = "operations"
	name = "hydro resupply canister"
	supplier = "nanotrasen"
	description = "A vending machine restock cart for refilling hydro vending machines."
	price = 2500
	items = list(
		/obj/item/vending_refill/hydro
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/coffeeresupplycanister
	category = "operations"
	name = "coffee resupply canister"
	supplier = "getmore"
	description = "A vending machine restock cart for refilling coffee vending machines."
	price = 1350
	items = list(
		/obj/item/vending_refill/coffee
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/colaresupplycanister
	category = "operations"
	name = "cola resupply canister"
	supplier = "idris"
	description = "A vending machine restock cart for refilling cola vending machines."
	price = 1250
	items = list(
		/obj/item/vending_refill/cola
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/cutleryresupplycanister
	category = "operations"
	name = "cutlery resupply canister"
	supplier = "nanotrasen"
	description = "A vending machine restock cart for refilling cutlery vending machines."
	price = 850
	items = list(
		/obj/item/vending_refill/cutlery
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/toximateresupplycanister
	category = "operations"
	name = "Toximate resupply canister"
	supplier = "orion"
	description = "A vending machine restock cart for refilling Toximate vending machines."
	price = 3000
	items = list(
		/obj/item/vending_refill/bomba
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/frontiervendresupplycanister
	category = "operations"
	name = "FrontierVend resupply canister"
	supplier = "orion"
	description = "A vending machine restock cart for refilling FrontierVend vending machines."
	price = 1255
	items = list(
		/obj/item/vending_refill/frontiervend
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/encryptionresupplycanister
	category = "operations"
	name = "encryption key resupply canister"
	supplier = "orion"
	description = "A vending machine restock cart for refilling encryption key vending machines."
	price = 5000
	items = list(
		/obj/item/vending_refill/encryption
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/gamesresupplycanister
	category = "operations"
	name = "games resupply canister"
	supplier = "getmore"
	description = "A vending machine restock cart for refilling games vending machines."
	price = 2000
	items = list(
		/obj/item/vending_refill/games
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/idrisdelightsresupplycanister
	category = "operations"
	name = "Idris Delights resupply canister"
	supplier = "idris"
	description = "A vending machine restock cart for refilling Idris Delights vending machines."
	price = 1500
	items = list(
		/obj/item/vending_refill/idris_delights
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/lavatoryresupplycanister
	category = "operations"
	name = "lavatory supplies resupply canister"
	supplier = "getmore"
	description = "A vending machine restock cart for refilling lavatory supplies vending machines."
	price = 1200
	items = list(
		/obj/item/vending_refill/lavatory
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/mreresupplycanister
	category = "operations"
	name = "MRE resupply canister"
	supplier = "orion"
	description = "A vending machine restock cart for refilling MRE vending machines."
	price = 2500
	items = list(
		/obj/item/vending_refill/mre
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/overloaderresupplycanister
	category = "operations"
	name = "overloader resupply canister"
	supplier = "getmore"
	description = "A vending machine restock cart for refilling overloader vending machines."
	price = 2500
	items = list(
		/obj/item/vending_refill/overloaders
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/quickmealsresupplycanister
	category = "operations"
	name = "quick meals resupply canister"
	supplier = "getmore"
	description = "A vending machine restock cart for refilling quick meals vending machines."
	price = 1750
	items = list(
		/obj/item/vending_refill/quick_meals
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/ramenresupplycanister
	category = "operations"
	name = "ramen resupply canister"
	supplier = "getmore"
	description = "A vending machine restock cart for refilling ramen vending machines."
	price = 1500
	items = list(
		/obj/item/vending_refill/ramen
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pharmacyresupplycanister
	category = "operations"
	name = "pharmacy resupply canister"
	supplier = "nanotrasen"
	description = "A vending machine restock cart for refilling pharmacy vending machines."
	price = 3500
	items = list(
		/obj/item/vending_refill/wallpharm
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/wardroberesupplycanister
	category = "operations"
	name = "wardrobe resupply canister"
	supplier = "idris"
	description = "A vending machine restock cart for refilling wardrobe vending machines."
	price = 1000
	items = list(
		/obj/item/vending_refill/wardrobe
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/cigarette_restock
	category = "operations"
	name = "commissary cigarette restock"
	supplier = "getmore"
	description = "A box full of cigarette stock for the commissary."
	price = 240
	items = list(
		/obj/item/storage/box/fancy/commissary_restock
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/rollable_restock
	category = "operations"
	name = "commissary tobacco leaves restock"
	supplier = "getmore"
	description = "A box full of tobacco leaves stock for the commissary."
	price = 100
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/rollable
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/chewable_restock
	category = "operations"
	name = "commissary chewing tobacco restock"
	supplier = "getmore"
	description = "A box full of chewing tobacco stock for the commissary."
	price = 240
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/chewable
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/smoking_accessory_restock
	category = "operations"
	name = "commissary smoking accessories restock"
	supplier = "getmore"
	description = "A box full of smoking accessories stock for the commissary."
	price = 140
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/smoking_accessory
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/electric_cig_restock
	category = "operations"
	name = "commissary electronic cigarette restock"
	supplier = "getmore"
	description = "A box full of electronic cigarette stock for the commissary."
	price = 80
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/electronic_cig
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/snack_restock
	category = "operations"
	name = "commissary snack restock"
	supplier = "getmore"
	description = "A box full of snack stock for the commissary."
	price = 100
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/food
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/xeno_restock
	category = "operations"
	name = "commissary xeno snack restock"
	supplier = "getmore"
	description = "A box full of xeno snack stock for the commissary."
	price = 60
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/food/xeno
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/candy_restock
	category = "operations"
	name = "commissary candy restock"
	supplier = "getmore"
	description = "A box full of candy stock for the commissary."
	price = 65
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/food/candy
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/microwave_restock
	category = "operations"
	name = "commissary microwave meal restock"
	supplier = "getmore"
	description = "A box full of microwave meal stock for the commissary."
	price = 220
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/food/microwave
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/drink_restock
	category = "operations"
	name = "commissary drink restock"
	supplier = "getmore"
	description = "A box full of drink stock for the commissary."
	price = 150
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/drink
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/cheap_booze_restock
	category = "operations"
	name = "commissary beer restock"
	supplier = "getmore"
	description = "A box full of beer stock for the commissary."
	price = 100
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/drink/booze_cheap
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/toys_restock
	category = "operations"
	name = "commissary toy restock"
	supplier = "getmore"
	description = "A box full of toy stock for the commissary."
	price = 110
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/toy
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/dice_cards_restock
	category = "operations"
	name = "commissary dice and card restock"
	supplier = "getmore"
	description = "A box full of dice and card stock for the commissary."
	price = 120
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/toy/cards_dice
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/toy_mech_restock
	category = "operations"
	name = "commissary toy mech restock"
	supplier = "getmore"
	description = "A box full of toy mech stock for the commissary."
	price = 200
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/toy/mech
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/comic_restock
	category = "operations"
	name = "commissary comic restock"
	supplier = "getmore"
	description = "A box full of comic stock for the commissary."
	price = 25
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/toy/comic
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/nka_comic_restock
	category = "operations"
	name = "commissary az'marian comic series restock"
	supplier = "getmore"
	description = "A box full of az'marian comic series stock for the commissary."
	price = 50
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/toy/comic/nka
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/music_restock
	category = "operations"
	name = "commissary music restock"
	supplier = "getmore"
	description = "A box full of music stock for the commissary."
	price = 50
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/music
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/tea_restock
	category = "operations"
	name = "commissary tea restock"
	supplier = "getmore"
	description = "A box full of tea stock for the commissary."
	// Bulk commissary orders are at a discount, so cheaper per tin of tea than regularly ordering tea
	price = 75
	items = list(
		/obj/item/storage/box/fancy/commissary_restock/tea
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/opsvoidsuit
	category = "operations"
	name = "operations voidsuit"
	supplier = "orion"
	description = "A special suit that protects against hazardous, low pressure environments. Standard issue for Orion personnel doing EVA deliveries."
	price = 800
	items = list(
		/obj/item/clothing/suit/space/void/ops
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/opsvoidsuithelmet
	category = "operations"
	name = "operations voidsuit helmet"
	supplier = "orion"
	description = "A special helmet designed for work in a hazardous, low pressure environment. Standard issue for Orion personnel doing EVA deliveries."
	price = 500
	items = list(
		/obj/item/clothing/head/helmet/space/void/ops
	)
	access = list(/datum/access/cargo::id)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
