/**
 *	NutriMax
 *		Low Supply
 *	NutriMax Xenobotany
 *		Low Supply
 *	HydroVend
 *		Low Supply
 *		Public Garden ($)
 *	GardenVend
 *	MegaSeed Servitor
 */

/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor."
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."
	icon_state = "nutri"
	icon_vend = "nutri-vend"
	vend_id = "hydro"
	products = list(
		/obj/item/reagent_containers/glass/fertilizer/ez = 6,
		/obj/item/reagent_containers/glass/fertilizer/l4z = 5,
		/obj/item/reagent_containers/glass/fertilizer/rh = 3,
		/obj/item/plantspray/pests = 20,
		/obj/item/reagent_containers/syringe = 5,
		/obj/item/storage/bag/plants = 5
	)
	premium = list(
		/obj/item/reagent_containers/glass/bottle/ammonia = 10,
		/obj/item/reagent_containers/glass/bottle/diethylamine = 5,
		/obj/random/horticulture_magazine = 4
	)
	contraband = list(
		/obj/item/reagent_containers/glass/bottle/mutagen = 2
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	random_itemcount = 0
	light_color = COLOR_BABY_BLUE

/obj/machinery/vending/hydronutrients/low_supply
	products = list(
		/obj/item/reagent_containers/glass/fertilizer/ez = 3,
		/obj/item/reagent_containers/glass/fertilizer/l4z = 4,
		/obj/item/reagent_containers/glass/fertilizer/rh = 1,
		/obj/item/plantspray/pests = 12,
		/obj/item/reagent_containers/syringe = 3,
		/obj/item/storage/bag/plants = 3
	)

/obj/machinery/vending/hydronutrients/xenobotany
	products = list(
		/obj/item/reagent_containers/glass/fertilizer/ez = 6,
		/obj/item/reagent_containers/glass/fertilizer/l4z = 6,
		/obj/item/reagent_containers/glass/fertilizer/rh = 3,
		/obj/item/plantspray/pests = 20,
		/obj/item/reagent_containers/syringe = 6,
		/obj/item/storage/bag/plants = 6,
		/obj/item/device/analyzer/plant_analyzer = 2,
		/obj/item/material/minihoe = 2,
		/obj/item/material/hatchet = 2,
		/obj/item/wirecutters/clippers = 2,
		/obj/item/reagent_containers/spray/plantbgone = 2,
		/obj/item/reagent_containers/glass/bottle/mutagen = 3
	)

/obj/machinery/vending/hydronutrients/xenobotany/low_supply
	products = list(
		/obj/item/reagent_containers/glass/fertilizer/ez = 3,
		/obj/item/reagent_containers/glass/fertilizer/l4z = 4,
		/obj/item/reagent_containers/glass/fertilizer/rh = 1,
		/obj/item/plantspray/pests = 12,
		/obj/item/reagent_containers/syringe = 4,
		/obj/item/storage/bag/plants = 2,
		/obj/item/device/analyzer/plant_analyzer = 1,
		/obj/item/material/minihoe = 1,
		/obj/item/material/hatchet = 1,
		/obj/item/wirecutters/clippers = 1,
		/obj/item/reagent_containers/spray/plantbgone = 1,
		/obj/item/reagent_containers/glass/bottle/mutagen = 2
	)

//Used specifically for more advanced setups, includes analyzers and tools inside the machine.
/obj/machinery/vending/hydronutrients/hydroponics
	name = "HydroVend"
	desc = "A one stop shop for all your hydroponics needs."

	products = list(
		/obj/item/reagent_containers/glass/fertilizer/ez = 6,
		/obj/item/reagent_containers/glass/fertilizer/l4z = 6,
		/obj/item/reagent_containers/glass/fertilizer/rh = 3,
		/obj/item/plantspray/pests = 10,
		/obj/item/reagent_containers/syringe = 6,
		/obj/item/storage/bag/plants = 6,
		/obj/item/device/analyzer/plant_analyzer = 2,
		/obj/item/material/minihoe = 2,
		/obj/item/material/hatchet = 2,
		/obj/item/wirecutters/clippers = 2,
		/obj/item/reagent_containers/spray/plantbgone = 2
	)
	premium = list(
		/obj/item/reagent_containers/glass/bottle/ammonia = 10,
		/obj/item/reagent_containers/glass/bottle/diethylamine = 5,
		/obj/random/horticulture_magazine = 4
	)
	contraband = list(
		/obj/item/reagent_containers/glass/bottle/mutagen = 2
	)

//Meant to replace garden vending machines in public spaces, has a price list for items. Nothing unreasonable.
/obj/machinery/vending/hydronutrients/gardenvend
	name = "GardenVend"
	desc = "A one stop shop for all your gardening needs."

	products = list(
		/obj/item/reagent_containers/glass/fertilizer/ez = 6,
		/obj/item/reagent_containers/glass/fertilizer/l4z = 6,
		/obj/item/reagent_containers/glass/fertilizer/rh = 3,
		/obj/item/plantspray/pests = 10,
		/obj/item/storage/bag/plants = 6,
		/obj/item/material/minihoe = 2,
		/obj/item/material/hatchet = 2,
		/obj/item/wirecutters/clippers = 2,
		/obj/item/reagent_containers/spray/plantbgone = 2
	)
	prices = list(
		/obj/item/reagent_containers/glass/fertilizer/ez = 10.00,
		/obj/item/reagent_containers/glass/fertilizer/l4z = 10.00,
		/obj/item/reagent_containers/glass/fertilizer/rh = 20.00,
		/obj/item/plantspray/pests = 7.50,
		/obj/item/storage/bag/plants = 10.00,
		/obj/item/material/minihoe = 15.00,
		/obj/item/material/hatchet = 15.00,
		/obj/item/wirecutters/clippers = 15.00,
		/obj/item/reagent_containers/spray/plantbgone = 35.00
	)

	premium = list(
		/obj/item/reagent_containers/glass/bottle/ammonia = 10,
		/obj/item/reagent_containers/glass/bottle/diethylamine = 5,
		/obj/random/horticulture_magazine = 4
	)
	contraband = list(
		/obj/item/reagent_containers/glass/bottle/mutagen = 2
	)

/obj/machinery/vending/hydronutrients/gardenvend/low_supply
	products = list(
		/obj/item/reagent_containers/glass/fertilizer/ez = 2,
		/obj/item/plantspray/pests = 3,
		/obj/item/storage/bag/plants = 1,
		/obj/item/material/minihoe = 1,
		/obj/item/material/hatchet = 1,
		/obj/item/wirecutters/clippers = 1,
		/obj/item/reagent_containers/spray/plantbgone = 1
	)

/obj/item/device/vending_refill/hydro
	name = "hydro resupply canister"
	vend_id = "hydro"
	charges = 23


/obj/machinery/vending/hydroseeds
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection on the station!;Also certain mushroom varieties available, more for experts! Get certified today!"
	product_ads = "We like plants!;Grow some crops!;Grow, baby, growww!;Aw h'yeah son!"
	icon_state = SEED_NOUN_SEEDS
	vend_id = SEED_NOUN_SEEDS
	products = list(
		/obj/item/seeds/aghrasshseed = 3,
		/obj/item/seeds/ambrosiavulgarisseed = 3,
		/obj/item/seeds/appleseed = 3,
		/obj/item/seeds/bananaseed = 3,
		/obj/item/seeds/bellpepperseed = 3,
		/obj/item/seeds/berryseed = 3,
		/obj/item/seeds/blackraspberryseed = 3,
		/obj/item/seeds/blizzard = 3,
		/obj/item/seeds/blueberryseed = 3,
		/obj/item/seeds/blueraspberryseed = 3,
		/obj/item/seeds/cabbageseed = 3,
		/obj/item/seeds/carrotseed = 3,
		/obj/item/seeds/chantermycelium = 3,
		/obj/item/seeds/cherryseed = 3,
		/obj/item/seeds/chiliseed = 3,
		/obj/item/seeds/cocoapodseed = 3,
		/obj/item/seeds/coffeeseed = 3,
		/obj/item/seeds/cornseed = 3,
		/obj/item/seeds/dynseed = 3,
		/obj/item/seeds/earthenroot = 2,
		/obj/item/seeds/eggplantseed = 3,
		/obj/item/seeds/eki = 3,
		/obj/item/seeds/garlicseed = 3,
		/obj/item/seeds/gukheseed = 3,
		/obj/item/seeds/grapeseed = 3,
		/obj/item/seeds/grassseed = 3,
		/obj/item/seeds/greengrapeseed = 3,
		/obj/item/seeds/guamiseed = 3,
		/obj/item/seeds/harebell = 3,
		/obj/item/seeds/lemonseed = 3,
		/obj/item/seeds/limeseed = 3,
		/obj/item/seeds/mtearseed = 3,
		/obj/item/seeds/mintseed = 3,
		/obj/item/seeds/dirtberries = 2,
		/obj/item/seeds/onionseed = 3,
		/obj/item/seeds/oracleseed = 3,
		/obj/item/seeds/orangeseed = 3,
		/obj/item/seeds/peanutseed = 3,
		/obj/item/seeds/peaseed = 3,
		/obj/item/seeds/peppercornseed = 3,
		/obj/item/seeds/plastiseed = 3,
		/obj/item/seeds/plumpmycelium = 3,
		/obj/item/seeds/poppyseed = 3,
		/obj/item/seeds/potatoseed = 3,
		/obj/item/seeds/pumpkinseed = 3,
		/obj/item/seeds/qlortseed = 3,
		/obj/item/seeds/clam/rasval = 3,
		/obj/item/seeds/raspberryseed = 3,
		/obj/item/seeds/replicapod = 3,
		/obj/item/seeds/reishimycelium = 3,
		/obj/item/seeds/riceseed = 3,
		/obj/item/seeds/richcoffeeseed = 3,
		/obj/item/seeds/sarezhiseed = 3,
		/obj/item/seeds/serkiflowerseed,
		/obj/item/seeds/shandseed = 3,
		/obj/item/seeds/soyaseed = 3,
		/obj/item/seeds/sthberryseed = 3,
		/obj/item/seeds/strawberryseed = 3,
		/obj/item/seeds/cranberryseed = 3,
		/obj/item/seeds/sugarcaneseed = 3,
		/obj/item/seeds/sunflowerseed = 3,
		/obj/item/seeds/sugartree = 2,
		/obj/item/seeds/teaseed = 3,
		/obj/item/seeds/tobaccoseed = 3,
		/obj/item/seeds/tomatoseed = 3,
		/obj/item/seeds/towermycelium = 3,
		/obj/item/seeds/vanilla = 3,
		/obj/item/seeds/watermelonseed = 3,
		/obj/item/seeds/wheatseed = 3,
		/obj/item/seeds/whitebeetseed = 3,
		/obj/item/seeds/wulumunushaseed = 2,
		/obj/item/seeds/xuiziseed = 3,
		/obj/item/seeds/ylpha = 3
	)

	contraband = list(
		/obj/item/seeds/amanitamycelium = 3,
		/obj/item/seeds/cocaseed = 3,
		/obj/item/seeds/glowshroom = 3,
		/obj/item/seeds/libertymycelium = 3,
		/obj/item/seeds/nettleseed = 3

	)
	premium = list(
		/obj/item/seeds/ambrosiadeusseed = 3
	)

	prices = list(
		/obj/item/seeds/ambrosiavulgarisseed = 12.00,
		/obj/item/seeds/appleseed = 6.00,
		/obj/item/seeds/bananaseed = 7.00,
		/obj/item/seeds/bellpepperseed = 5.00,
		/obj/item/seeds/berryseed = 5.00,
		/obj/item/seeds/blackraspberryseed = 5.00,
		/obj/item/seeds/blizzard = 9.00,
		/obj/item/seeds/blueberryseed = 4.00,
		/obj/item/seeds/blueraspberryseed = 5.00,
		/obj/item/seeds/cabbageseed = 5.00,
		/obj/item/seeds/carrotseed = 2.50,
		/obj/item/seeds/chantermycelium = 12.50,
		/obj/item/seeds/cherryseed = 5.00,
		/obj/item/seeds/chiliseed = 6.00,
		/obj/item/seeds/cocoapodseed = 6.00,
		/obj/item/seeds/coffeeseed = 12.00,
		/obj/item/seeds/cornseed = 4.00,
		/obj/item/seeds/dynseed = 8.50,
		/obj/item/seeds/earthenroot = 12.00,
		/obj/item/seeds/eggplantseed = 4.00,
		/obj/item/seeds/eki = 15.00,
		/obj/item/seeds/garlicseed = 4.00,
		/obj/item/seeds/grapeseed = 5.00,
		/obj/item/seeds/grassseed = 2.00,
		/obj/item/seeds/greengrapeseed = 5.00,
		/obj/item/seeds/guamiseed = 13.50,
		/obj/item/seeds/harebell = 1.50,
		/obj/item/seeds/lemonseed = 5.00,
		/obj/item/seeds/limeseed = 6.00,
		/obj/item/seeds/mtearseed = 7.00,
		/obj/item/seeds/mintseed = 6.00,
		/obj/item/seeds/dirtberries = 12.00,
		/obj/item/seeds/onionseed = 4.00,
		/obj/item/seeds/oracleseed = 11.00,
		/obj/item/seeds/orangeseed = 5.00,
		/obj/item/seeds/peanutseed = 4.00,
		/obj/item/seeds/peaseed = 5.00,
		/obj/item/seeds/peppercornseed = 4.00,
		/obj/item/seeds/plastiseed = 5.00,
		/obj/item/seeds/plumpmycelium = 2.50,
		/obj/item/seeds/poppyseed = 1.50,
		/obj/item/seeds/potatoseed = 4.00,
		/obj/item/seeds/pumpkinseed = 5.00,
		/obj/item/seeds/qlortseed = 12.00,
		/obj/item/seeds/clam/rasval = 18.00,
		/obj/item/seeds/raspberryseed = 5.00,
		/obj/item/seeds/reishimycelium = 15.00,
		/obj/item/seeds/replicapod = 35.00,
		/obj/item/seeds/riceseed = 2.50,
		/obj/item/seeds/richcoffeeseed = 25.00,
		/obj/item/seeds/shandseed = 7.00,
		/obj/item/seeds/soyaseed = 5.00,
		/obj/item/seeds/strawberryseed = 5.00,
		/obj/item/seeds/cranberryseed = 5.00,
		/obj/item/seeds/sugarcaneseed = 2.50,
		/obj/item/seeds/sunflowerseed = 2.50,
		/obj/item/seeds/sugartree = 5.00,
		/obj/item/seeds/teaseed = 4.00,
		/obj/item/seeds/tobaccoseed = 5.00,
		/obj/item/seeds/tomatoseed = 4.00,
		/obj/item/seeds/towermycelium = 7.50,
		/obj/item/seeds/vanilla = 12.00,
		/obj/item/seeds/watermelonseed = 4.00,
		/obj/item/seeds/wheatseed = 2.50,
		/obj/item/seeds/whitebeetseed = 2.50,
		/obj/item/seeds/wulumunushaseed = 15.00,
		/obj/item/seeds/ylpha = 16.00
	)
	restock_items = TRUE
	random_itemcount = 0
	light_color = COLOR_BABY_BLUE

/obj/item/device/vending_refill/seeds
	name = "resupply canister"
	vend_id = SEED_NOUN_SEEDS
	charges = 175


/**
 *  Populate hydroseeds product_records
 *
 *  This needs to be customized to fetch the actual names of the seeds, otherwise
 *  the machine would simply list "packet of seeds" times 20
 */
/obj/machinery/vending/hydroseeds/build_inventory()
	var/list/all_products = list(
		list(src.products, CAT_NORMAL),
		list(src.contraband, CAT_HIDDEN),
		list(src.premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/obj/item/seeds/S = new entry(src)
			var/name = S.name
			var/datum/data/vending_product/product = new/datum/data/vending_product(entry, name)

			product.price = (entry in src.prices) ? src.prices[entry] : 0
			product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			product.category = category

			src.product_records.Add(product)
