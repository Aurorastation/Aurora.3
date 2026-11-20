/singleton/cargo_item/autakhlimbs
	category = "operations"
	name = "autakh limbs"
	supplier = "hephaestus"
	description = "A box with various autakh limbs."
	price = 1000
	items = list(
		/obj/item/organ/external/hand/right/autakh/tool,
		/obj/item/organ/external/hand/right/autakh/tool/mining,
		/obj/item/organ/external/hand/right/autakh/medical
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 2

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

/singleton/cargo_item/coathanger
	category = "operations"
	name = "Coat Hanger"
	supplier = "nanotrasen"
	description = "To hang your coat."
	price = 12
	items = list(
		/obj/structure/coatrack
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/eftposscanner
	category = "operations"
	name = "EFTPOS scanner"
	supplier = "orion"
	description = "Swipe your ID card to make purchases electronically."
	price = 35
	items = list(
		/obj/item/eftpos
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/emptyspraybottle
	category = "operations"
	name = "empty spray bottle"
	supplier = "blam"
	description = "An empty spray bottle."
	price = 5
	items = list(
		/obj/item/reagent_containers/spray
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/faxmachine
	category = "operations"
	name = "fax machine"
	supplier = "nanotrasen"
	description = "Needed office equipment for any space based corporation to function."
	price = 300
	items = list(
		/obj/structure/machinery/photocopier/faxmachine
	)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/flare
	category = "operations"
	name = "flare"
	supplier = "hephaestus"
	description = "Good for illuminating dark areas or burning someones face off."
	price = 8
	items = list(
		/obj/item/flashlight/flare
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/formalwearcrate
	category = "operations"
	name = "formal wear crate"
	supplier = "nanotrasen"
	description = "Formalwear for the best occasions."
	price = 350
	items = list(
		/obj/item/clothing/head/bowler,
		/obj/item/clothing/head/that,
		/obj/item/clothing/under/suit_jacket,
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/red,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/suit_jacket/burgundy,
		/obj/item/clothing/shoes/sneakers/black,
		/obj/item/clothing/shoes/laceup,
		/obj/item/clothing/shoes/laceup/grey,
		/obj/item/clothing/suit/wcoat
	)
	container_type = "crate"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/giftwrappingpaper
	category = "operations"
	name = "gift wrapping paper"
	supplier = "orion"
	description = "You can use this to wrap items in."
	price = 8
	items = list(
		/obj/item/stack/wrapping_paper
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/janitorialresupplyset
	category = "operations"
	name = "janitorial resupply set"
	supplier = "blam"
	description = "A set of items to restock the janitors closet."
	price = 2000
	items = list(
		/obj/structure/cart/storage/janitorialcart,
		/obj/structure/mopbucket,
		/obj/item/mop,
		/obj/item/storage/bag/trash,
		/obj/item/reagent_containers/spray/cleaner,
		/obj/item/reagent_containers/glass/rag,
		/obj/item/clothing/suit/caution,
		/obj/item/clothing/suit/caution,
		/obj/item/clothing/suit/caution,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/soap/nanotrasen
	)
	container_type = "crate"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/loadbearingequipment
	category = "operations"
	name = "load bearing equipment"
	supplier = "orion"
	description = "Used to hold things when you don't have enough hands."
	price = 83
	items = list(
		/obj/item/clothing/accessory/storage
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/packagewrapper
	category = "operations"
	name = "package wrapper"
	supplier = "orion"
	description = "A roll of paper used to enclose an object for delivery."
	price = 8
	items = list(
		/obj/item/stack/packageWrap
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/pda
	category = "operations"
	name = "PDA"
	supplier = "nanotrasen"
	description = "The latest in portable microcomputer solutions from Thinktronic Systems, LTD."
	price = 90
	items = list(
		/obj/item/modular_computer/handheld/pda
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/photoalbum
	category = "operations"
	name = "Photo album"
	supplier = "nanotrasen"
	description = "A place to store fond memories you made in space."
	price = 45
	items = list(
		/obj/item/storage/photo_album
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/photocopier
	category = "operations"
	name = "photo copier"
	supplier = "nanotrasen"
	description = "When you're too lazy to write a copy yourself."
	price = 300
	items = list(
		/obj/structure/machinery/photocopier
	)
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/pkus_exosuit_parts
	category = "operations"
	name = "ADEPT P'kus-3 exosuit parts"
	supplier = "zharkov"
	description = "Unprepared P'kus-3 parts discounted through ADEPT, the Hadii Institute's joint exosuit program with the SCC. A machinist must still install the internal components."
	price = 3000
	items = list(
		/obj/item/mech_component/manipulators/pra_egg,
		/obj/item/mech_component/propulsion/pra_egg,
		/obj/item/mech_component/sensors/pra_egg,
		/obj/item/mech_component/chassis/pra_egg
	)
	access = list(/datum/access/robotics::id)
	container_type = "crate"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/pkus_exosuit_parts_heavy
	category = "operations"
	name = "ADEPT armored P'kus-3 exosuit parts"
	supplier = "zharkov"
	description = "Unprepared armored P'kus-3 parts discounted through ADEPT, the Hadii Institute's joint exosuit program with the SCC. A machinist must still install the internal components."
	price = 5000
	items = list(
		/obj/item/mech_component/manipulators/pra_egg/armored,
		/obj/item/mech_component/propulsion/pra_egg,
		/obj/item/mech_component/sensors/pra_egg/armored,
		/obj/item/mech_component/chassis/pra_egg/armored/nuclear
	)
	access = list(/datum/access/robotics::id)
	container_type = "crate"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/poster19
	category = "operations"
	name = "random poster"
	supplier = "orion"
	description = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	price = 3.50
	items = list(
		/obj/item/contraband/poster
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/shoulderholster
	category = "operations"
	name = "shoulder holster"
	supplier = "zavodskoi"
	description = "A handgun holster."
	price = 15
	items = list(
		/obj/item/clothing/accessory/holster
	)
	access = list(/datum/access/security::id)
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

/singleton/cargo_item/webbing
	category = "operations"
	name = "webbing"
	supplier = "nanotrasen"
	description = "Sturdy mess of synthcotton belts and buckles, ready to share your burden."
	price = 43
	items = list(
		/obj/item/clothing/accessory/storage/webbing
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/blackpaint
	category = "operations"
	name = "black paint"
	supplier = "hephaestus"
	description = "Black paint, the color of space."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/black
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/bluepaint
	category = "operations"
	name = "blue paint"
	supplier = "hephaestus"
	description = "Blue paint, for when you're on a mission from god."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/blue
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/whitepaint
	category = "operations"
	name = "white paint"
	supplier = "nanotrasen"
	description = "White paint, perfect for sterile boring lab environments."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/white
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/yellowpaint
	category = "operations"
	name = "yellow paint"
	supplier = "orion"
	description = "Yellow paint, for when you need to make eyes sore."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/yellow
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/purplepaint
	category = "operations"
	name = "purple paint"
	supplier = "orion"
	description = "Purple paint, it makes you feel like royalty."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/purple
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/redpaint
	category = "operations"
	name = "red paint"
	supplier = "orion"
	description = "Red paint, its not blood we promise."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/red
	)
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/greenpaint
	category = "operations"
	name = "green paint"
	supplier = "orion"
	description = "Green paint, an aesthetic replacement for grass."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/green
	)
	container_type = "crate"
	groupable = TRUE
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
