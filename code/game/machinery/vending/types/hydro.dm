/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor."
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	icon_state = "nutri"
	deny_time = 6
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/fertilizer/ez, 6, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/fertilizer/l4z, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/fertilizer/rh, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/plantspray/pests, 20, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/syringe, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/bag/plants, 5, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/bottle/ammonia, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/bottle/diethylamine, 5, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/glass/bottle/mutagen, 2, FALSE)
		)
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	randomize_qty = FALSE
	light_color = COLOR_BABY_BLUE

/obj/machinery/vending/hydroseeds
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection on the station!;Also certain mushroom varieties available, more for experts! Get certified today!"
	icon_state = SEED_NOUN_SEEDS
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/seeds/ambrosiavulgarisseed, 3, 70),
			VENDOR_PRODUCT(/obj/item/seeds/appleseed, 3, 50),
			VENDOR_PRODUCT(/obj/item/seeds/bananaseed, 3, 60),
			VENDOR_PRODUCT(/obj/item/seeds/berryseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/blizzard, 3, 60),
			VENDOR_PRODUCT(/obj/item/seeds/blueberryseed, 3, 30),
			VENDOR_PRODUCT(/obj/item/seeds/cabbageseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/carrotseed, 3, 20),
			VENDOR_PRODUCT(/obj/item/seeds/chantermycelium, 3, 20),
			VENDOR_PRODUCT(/obj/item/seeds/cherryseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/chiliseed, 3, 50),
			VENDOR_PRODUCT(/obj/item/seeds/cocoapodseed, 3, 50),
			VENDOR_PRODUCT(/obj/item/seeds/cornseed, 3, 30),
			VENDOR_PRODUCT(/obj/item/seeds/replicapod, 3, 200),
			VENDOR_PRODUCT(/obj/item/seeds/earthenroot, 2, 70),
			VENDOR_PRODUCT(/obj/item/seeds/eggplantseed, 3, 30),
			VENDOR_PRODUCT(/obj/item/seeds/garlicseed, 3, 30),
			VENDOR_PRODUCT(/obj/item/seeds/grapeseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/grassseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/greengrapeseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/harebell, 3, 10),
			VENDOR_PRODUCT(/obj/item/seeds/lemonseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/limeseed, 3, 50),
			VENDOR_PRODUCT(/obj/item/seeds/mtearseed, 3, 60),
			VENDOR_PRODUCT(/obj/item/seeds/nifberries, 2, 70),
			VENDOR_PRODUCT(/obj/item/seeds/onionseed, 3, 30),
			VENDOR_PRODUCT(/obj/item/seeds/orangeseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/peanutseed, 3, 30),
			VENDOR_PRODUCT(/obj/item/seeds/peppercornseed, 3, 30),
			VENDOR_PRODUCT(/obj/item/seeds/plastiseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/plumpmycelium, 3, 20),
			VENDOR_PRODUCT(/obj/item/seeds/poppyseed, 3, 10),
			VENDOR_PRODUCT(/obj/item/seeds/potatoseed, 3, 30),
			VENDOR_PRODUCT(/obj/item/seeds/pumpkinseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/riceseed, 3, 20),
			VENDOR_PRODUCT(/obj/item/seeds/reishimycelium, 3, 30),
			VENDOR_PRODUCT(/obj/item/seeds/shandseed, 3, 60),
			VENDOR_PRODUCT(/obj/item/seeds/soyaseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/sugarcaneseed, 3, 20),
			VENDOR_PRODUCT(/obj/item/seeds/sunflowerseed, 3, 20),
			VENDOR_PRODUCT(/obj/item/seeds/sugartree, 2, 40),
			VENDOR_PRODUCT(/obj/item/seeds/tobaccoseed, 3, 40),
			VENDOR_PRODUCT(/obj/item/seeds/tomatoseed, 3, 30),
			VENDOR_PRODUCT(/obj/item/seeds/towermycelium, 3, 20),
			VENDOR_PRODUCT(/obj/item/seeds/watermelonseed, 3, 30),
			VENDOR_PRODUCT(/obj/item/seeds/wheatseed, 3, 20),
			VENDOR_PRODUCT(/obj/item/seeds/whitebeetseed, 3, 20),
			VENDOR_PRODUCT(/obj/item/seeds/dynseed, 3, 80),
			VENDOR_PRODUCT(/obj/item/seeds/wulumunushaseed, 2, 90)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/seeds/amanitamycelium, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/seeds/glowshroom, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/seeds/libertymycelium, 3, FALSE),
			VENDOR_PRODUCT(/obj/item/seeds/nettleseed, 3, FALSE)

		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/seeds/ambrosiadeusseed, 3, FALSE)
		)
	)
	restock_items = TRUE
	randomize_qty = FALSE
	light_color = COLOR_BABY_BLUE

/obj/item/vending_refill/hydro
	name = "hydro resupply canister"
	charges = 23

/obj/item/vending_refill/seeds
	name = "resupply canister"
	charges = 175
