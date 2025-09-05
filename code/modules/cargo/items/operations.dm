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
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 2

/singleton/cargo_item/camera
	category = "operations"
	name = "camera"
	supplier = "nanotrasen"
	description = "A polaroid camera. 10 photos left."
	price = 45
	items = list(
		/obj/item/device/camera
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/cargotraintrolley
	category = "operations"
	name = "cargo train trolley"
	supplier = "orion"
	description = "A cargo trolley for carrying cargo, NOT people."
	price = 800
	items = list(
		/obj/vehicle/train/cargo/trolley
	)
	access = ACCESS_CARGO
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
	access = ACCESS_CARGO
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
	access = 0
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
		/obj/item/device/eftpos
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/emptyspraybottle
	category = "operations"
	name = "empty spray bottle"
	supplier = "blam"
	description = "A empty spray bottle."
	price = 5
	items = list(
		/obj/item/reagent_containers/spray
	)
	access = 0
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
		/obj/machinery/photocopier/faxmachine
	)
	access = 0
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/filmcartridge
	category = "operations"
	name = "film cartridge"
	supplier = "nanotrasen"
	description = "A camera film cartridge. Insert it into a camera to reload it."
	price = 8
	items = list(
		/obj/item/device/camera_film
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/flare
	category = "operations"
	name = "flare"
	supplier = "hephaestus"
	description = "Good for illuminating dark areas or burning someones face off."
	price = 8
	items = list(
		/obj/item/device/flashlight/flare
	)
	access = 0
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
	access = 0
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
	access = 0
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
	access = 0
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
	access = 0
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
	access = 0
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
	access = 0
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
	access = 0
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
		/obj/machinery/photocopier
	)
	access = 0
	container_type = "box"
	groupable = FALSE
	spawn_amount = 1

/singleton/cargo_item/poster19
	category = "operations"
	name = "rolled-up poster - No. 19"
	supplier = "orion"
	description = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface."
	price = 3.50
	items = list(
		/obj/item/contraband/poster
	)
	access = 0
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
	access = ACCESS_SECURITY
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/space_bike
	category = "operations"
	name = "space-bike"
	supplier = "zharkov"
	description = "Space wheelies! Woo!"
	price = 800
	items = list(
		/obj/vehicle/bike
	)
	access = 0
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
	access = 0
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
	access = 0
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
	access = 0
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
	access = 0
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
	access = 0
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
	access = 0
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
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/greenpaint
	category = "operations"
	name = "green paint"
	supplier = "orion"
	description = "Green paint, a aesthetic replacement for grass."
	price = 10
	items = list(
		/obj/item/reagent_containers/glass/paint/green
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/battlemonstersresupplycanister
	category = "operations"
	name = "battlemonsters resupply canister"
	supplier = "nanotrasen"
	description = "A vending machine restock cart."
	price = 2250
	items = list(
		/obj/item/device/vending_refill/battlemonsters
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/boozeresupplycanister
	category = "operations"
	name = "booze resupply canister"
	supplier = "orion"
	description = "A vending machine restock cart."
	price = 4500
	items = list(
		/obj/item/device/vending_refill/booze
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/zorasodaresupplycanister
	category = "operations"
	name = "zora soda resupply canister"
	supplier = "zora"
	description = "A vending machine restock cart."
	price = 1255
	items = list(
		/obj/item/device/vending_refill/zora
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/toolsresupplycanister
	category = "operations"
	name = "tools resupply canister"
	supplier = "hephaestus"
	description = "A vending machine restock cart."
	price = 2450
	items = list(
		/obj/item/device/vending_refill/tools
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/smokesresupplycanister
	category = "operations"
	name = "smokes resupply canister"
	supplier = "getmore"
	description = "A vending machine restock cart."
	price = 2250
	items = list(
		/obj/item/device/vending_refill/smokes
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/snacksresupplycanister
	category = "operations"
	name = "snacks resupply canister"
	supplier = "getmore"
	description = "A vending machine restock cart."
	price = 1255
	items = list(
		/obj/item/device/vending_refill/snack
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/robotoolsresupplycanister
	category = "operations"
	name = "robo-tools resupply canister"
	supplier = "blam"
	description = "A vending machine restock cart."
	price = 2500
	items = list(
		/obj/item/device/vending_refill/robo
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/securityresupplycanister
	category = "operations"
	name = "security resupply canister"
	supplier = "blam"
	description = "A vending machine restock cart."
	price = 4500
	items = list(
		/obj/item/device/vending_refill/robust
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/medsresupplycanister
	category = "operations"
	name = "meds resupply canister"
	supplier = "zeng_hu"
	description = "A vending machine restock cart."
	price = 5500
	items = list(
		/obj/item/device/vending_refill/meds
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/hydroresupplycanister
	category = "operations"
	name = "hydro resupply canister"
	supplier = "nanotrasen"
	description = "A vending machine restock cart."
	price = 2500
	items = list(
		/obj/item/device/vending_refill/hydro
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/coffeeresupplycanister
	category = "operations"
	name = "coffee resupply canister"
	supplier = "getmore"
	description = "A vending machine restock cart."
	price = 1350
	items = list(
		/obj/item/device/vending_refill/coffee
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/colaresupplycanister
	category = "operations"
	name = "cola resupply canister"
	supplier = "idris"
	description = "A vending machine restock cart."
	price = 1250
	items = list(
		/obj/item/device/vending_refill/cola
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1

/singleton/cargo_item/cutleryresupplycanister
	category = "operations"
	name = "cutlery resupply canister"
	supplier = "nanotrasen"
	description = "A vending machine restock cart."
	price = 850
	items = list(
		/obj/item/device/vending_refill/cutlery
	)
	access = 0
	container_type = "crate"
	groupable = TRUE
	spawn_amount = 1
