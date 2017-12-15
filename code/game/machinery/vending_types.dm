
/*
 * Vending machine types
 */

/*

/obj/machinery/vending/[vendors name here]   // --vending machine template   :)
	name = ""
	desc = ""
	icon = ''
	icon_state = ""
	vend_delay = 15
	products = list()
	contraband = list()
	premium = list()

*/

/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"        //////////////18 drink entities below, plus the glasses, in case someone wants to edit the number of bottles
	icon_deny = "boozeomat-deny"
	products = list(
		/obj/item/weapon/reagent_containers/food/drinks/bottle/gin = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/fireball = 2,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/champagne = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/rum = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/wine = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/whitewine = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/victorygin = 2,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/boukha = 2,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer = 6,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale = 6,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice = 4,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice = 4,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice = 4,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/lemonjuice = 4,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/cream = 4,
		/obj/item/weapon/reagent_containers/food/drinks/cans/tonic = 8,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/cola = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/space_up = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/space_mountain_wind = 5,
		/obj/item/weapon/reagent_containers/food/drinks/cans/sodawater = 15,
		/obj/item/weapon/reagent_containers/food/drinks/flask/barflask = 2,
		/obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask = 2,
		/obj/item/weapon/reagent_containers/food/drinks/drinkingglass = 30,
		/obj/item/weapon/reagent_containers/food/drinks/ice = 9,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/melonliquor = 2,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/bluecuracao = 2,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe = 2,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/grenadine = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/chartreusegreen = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/chartreuseyellow =5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/bitters = 6,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/mintsyrup = 5,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/cremewhite = 4,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/brandy = 4,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/guinnes = 4,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/drambuie = 4,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/cremeyvette = 4,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/small/xuizijuice = 8,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/sarezhiwine = 2
	)
	contraband = list(
		/obj/item/weapon/reagent_containers/food/drinks/tea = 10
	)
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	product_slogans = "I hope nobody asks me for a bloody cup o' tea...;Alcohol is humanity's friend. Would you abandon a friend?;Quite delighted to serve you!;Is nobody thirsty on this station?"
	product_ads = "Drink up!;Booze is good for you!;Alcohol is humanity's best friend.;Quite delighted to serve you!;Care for a nice, cold beer?;Nothing cures you like booze!;Have a sip!;Have a drink!;Have a beer!;Beer is good for you!;Only the finest alcohol!;Best quality booze since 2053!;Award-winning wine!;Maximum alcohol!;Man loves beer.;A toast for progress!"
	req_access = list(access_bar)

/obj/machinery/vending/assist
	products = list(
		/obj/item/device/assembly/prox_sensor = 5,
		/obj/item/device/assembly/igniter = 3,
		/obj/item/device/assembly/signaler = 4,
		/obj/item/weapon/wirecutters = 1,
		/obj/item/weapon/cartridge/signal = 4
	)
	contraband = list(
		/obj/item/device/flashlight = 5,
		/obj/item/device/assembly/timer = 2
	)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"

/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	vend_delay = 34
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_power_usage = 85000 //85 kJ to heat a 250 mL cup of coffee
	products = list(
		/obj/item/weapon/reagent_containers/food/drinks/coffee = 25,
		/obj/item/weapon/reagent_containers/food/drinks/tea = 25,
		/obj/item/weapon/reagent_containers/food/drinks/h_chocolate = 25
	)
	contraband = list(
		/obj/item/weapon/reagent_containers/food/drinks/ice = 10
	)
	prices = list(
		/obj/item/weapon/reagent_containers/food/drinks/coffee = 20,
		/obj/item/weapon/reagent_containers/food/drinks/tea = 20,
		/obj/item/weapon/reagent_containers/food/drinks/h_chocolate = 22
	)


/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	products = list(
		/obj/item/weapon/reagent_containers/food/snacks/candy = 6,
		/obj/item/weapon/reagent_containers/food/drinks/dry_ramen = 6,
		/obj/item/weapon/reagent_containers/food/snacks/chips =6,
		/obj/item/weapon/reagent_containers/food/snacks/sosjerky = 6,
		/obj/item/weapon/reagent_containers/food/snacks/no_raisin = 6,
		/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie = 6,
		/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers = 6,
		/obj/item/weapon/reagent_containers/food/snacks/tastybread = 6,
		/obj/item/weapon/reagent_containers/food/snacks/skrellsnacks = 3,
		/obj/item/weapon/reagent_containers/food/snacks/meatsnack = 2,
		/obj/item/weapon/reagent_containers/food/snacks/maps = 2,
		/obj/item/weapon/reagent_containers/food/snacks/nathisnack = 2,
		/obj/item/weapon/reagent_containers/food/snacks/koisbar = 4
	)
	contraband = list(
		/obj/item/weapon/reagent_containers/food/snacks/syndicake = 6
	)
	prices = list(
		/obj/item/weapon/reagent_containers/food/snacks/candy = 15,
		/obj/item/weapon/reagent_containers/food/drinks/dry_ramen = 20,
		/obj/item/weapon/reagent_containers/food/snacks/chips = 17,
		/obj/item/weapon/reagent_containers/food/snacks/sosjerky = 20,
		/obj/item/weapon/reagent_containers/food/snacks/no_raisin = 12,
		/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie = 15,
		/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers = 15,
		/obj/item/weapon/reagent_containers/food/snacks/tastybread = 18,
		/obj/item/weapon/reagent_containers/food/snacks/skrellsnacks = 40,
		/obj/item/weapon/reagent_containers/food/snacks/meatsnack = 22,
		/obj/item/weapon/reagent_containers/food/snacks/maps = 23,
		/obj/item/weapon/reagent_containers/food/snacks/nathisnack = 24,
		/obj/item/weapon/reagent_containers/food/snacks/koisbar = 60
	)


/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "Cola_Machine"
	product_slogans = "Robust Softdrinks: More robust than a toolbox to the head!"
	product_ads = "Refreshing!;Hope you're thirsty!;Over 1 million drinks sold!;Thirsty? Why not cola?;Please, have a drink!;Drink up!;The best drinks in space."
	products = list(
		/obj/item/weapon/reagent_containers/food/drinks/cans/cola = 10,
		/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
		/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb = 10,
		/obj/item/weapon/reagent_containers/food/drinks/cans/starkist = 10,
		/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle = 10,
		/obj/item/weapon/reagent_containers/food/drinks/cans/space_up = 10,
		/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea = 10,
		/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice = 10,
		/obj/item/weapon/reagent_containers/food/drinks/cans/koispunch = 5
	)
	contraband = list(
		/obj/item/weapon/reagent_containers/food/drinks/cans/thirteenloko = 5,
		/obj/item/weapon/reagent_containers/food/snacks/liquidfood = 6
	)
	prices = list(
		/obj/item/weapon/reagent_containers/food/drinks/cans/cola = 15,
		/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind = 11,
		/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb = 16,
		/obj/item/weapon/reagent_containers/food/drinks/cans/starkist = 15,
		/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle = 12,
		/obj/item/weapon/reagent_containers/food/drinks/cans/space_up = 15,
		/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea = 13,
		/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice = 16,
		/obj/item/weapon/reagent_containers/food/drinks/cans/koispunch = 50
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

//This one's from bay12
/obj/machinery/vending/cart
	name = "PTech"
	desc = "Cartridges for PDAs."
	product_slogans = "Carts to go!"
	icon_state = "cart"
	icon_deny = "cart-deny"
	req_access = list(access_hop)
	products = list(
		/obj/item/weapon/cartridge/medical = 10,
		/obj/item/weapon/cartridge/engineering = 10,
		/obj/item/weapon/cartridge/security = 10,
		/obj/item/weapon/cartridge/janitor = 10,
		/obj/item/weapon/cartridge/signal/science = 10,
		/obj/item/device/pda/heads = 10,
		/obj/item/weapon/cartridge/captain = 3,
		/obj/item/weapon/cartridge/quartermaster = 10
	)


/obj/machinery/vending/cigarette
	name = "Cigarette machine" //OCD had to be uppercase to look nice with the new formating
	desc = "If you want to get cancer, might as well do it in style!"
	product_slogans = "Space cigs taste good like a cigarette should.;I'd rather toolbox than switch.;Smoke!;Don't believe the reports - smoke today!"
	product_ads = "Probably not bad for you!;Don't believe the scientists!;It's good for you!;Don't quit, buy more!;Smoke!;Nicotine heaven.;Best cigarettes since 2150.;Award-winning cigs."
	vend_delay = 34
	icon_state = "cigs"
	products = list(
		/obj/item/weapon/storage/fancy/cigarettes = 10,
		/obj/item/weapon/storage/box/matches = 10,
		/obj/item/weapon/flame/lighter/random = 4
	)
	contraband = list(
		/obj/item/weapon/flame/lighter/zippo = 4
	)
	premium = list(
		/obj/item/weapon/storage/fancy/cigar = 5,
		/obj/item/weapon/storage/fancy/cigarettes/killthroat = 5
	)
	prices = list(
		/obj/item/weapon/storage/fancy/cigarettes = 200,
		/obj/item/weapon/storage/box/matches = 12,
		/obj/item/weapon/flame/lighter/random = 12
	)


/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_deny = "med-deny"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(access_medical_equip)
	products = list(
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin = 4,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline = 4,
		/obj/item/weapon/reagent_containers/glass/bottle/stoxin = 4,
		/obj/item/weapon/reagent_containers/glass/bottle/toxin = 4,
		/obj/item/weapon/reagent_containers/syringe/antiviral = 4,
		/obj/item/weapon/reagent_containers/syringe = 12,
		/obj/item/device/healthanalyzer = 5,
		/obj/item/weapon/reagent_containers/glass/beaker = 4,
		/obj/item/weapon/reagent_containers/dropper = 2,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 3,
		/obj/item/stack/medical/splint = 2,
		/obj/item/weapon/reagent_containers/pill/antitox = 6
	)
	contraband = list(
		/obj/item/weapon/reagent_containers/pill/tox = 3,
		/obj/item/weapon/reagent_containers/pill/stox = 4
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.


//This one's from bay12
/obj/machinery/vending/phoronresearch
	name = "Toximate 3000"
	desc = "All the fine parts you need in one vending machine!"
	products = list(
		/obj/item/clothing/under/rank/scientist = 6,
		/obj/item/clothing/suit/bio_suit = 6,
		/obj/item/clothing/head/bio_hood = 6,
		/obj/item/device/transfer_valve = 6,
		/obj/item/device/assembly/timer = 6,
		/obj/item/device/assembly/signaler = 6,
		/obj/item/device/assembly/prox_sensor = 6,
		/obj/item/device/assembly/igniter = 6
	)

/obj/machinery/vending/wallmed1
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	req_access = list(access_medical)
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/weapon/reagent_containers/hypospray/autoinjector = 4,
		/obj/item/device/healthanalyzer = 1
	)
	contraband = list(
		/obj/item/weapon/reagent_containers/syringe/antitoxin = 4,
		/obj/item/weapon/reagent_containers/syringe/antiviral = 4,
		/obj/item/weapon/reagent_containers/pill/tox = 1
	)

/obj/machinery/vending/wallmed2
	name = "NanoMed"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	req_access = list(access_medical)
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(
		/obj/item/weapon/reagent_containers/hypospray/autoinjector = 5,
		/obj/item/weapon/reagent_containers/syringe/antitoxin = 3,
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment = 3,
		/obj/item/device/healthanalyzer = 3
	)
	contraband = list(
		/obj/item/weapon/reagent_containers/pill/tox = 3
	)

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_deny = "sec-deny"
	req_access = list(access_security)
	products = list(
		/obj/item/weapon/handcuffs = 8,
		/obj/item/weapon/grenade/chem_grenade/teargas = 4,
		/obj/item/device/flash = 5,
		/obj/item/weapon/reagent_containers/food/snacks/donut/normal = 12,
		/obj/item/weapon/storage/box/evidence = 6,
		/obj/item/device/holowarrant = 5
	)
	premium = list(
		/obj/item/weapon/storage/box/donut = 2
	)
	contraband = list(
		/obj/item/clothing/glasses/sunglasses = 2,
		/obj/item/weapon/grenade/flashbang = 4
	)

/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor."
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."
	icon_state = "nutri"
	icon_deny = "nutri-deny"
	products = list(
		/obj/item/weapon/reagent_containers/glass/fertilizer/ez = 6,
		/obj/item/weapon/reagent_containers/glass/fertilizer/l4z = 5,
		/obj/item/weapon/reagent_containers/glass/fertilizer/rh = 3,
		/obj/item/weapon/plantspray/pests = 20,
		/obj/item/weapon/reagent_containers/syringe = 5,
		/obj/item/weapon/storage/bag/plants = 5
	)
	premium = list(
		/obj/item/weapon/reagent_containers/glass/bottle/ammonia = 10,
		/obj/item/weapon/reagent_containers/glass/bottle/diethylamine = 5
	)
	contraband = list(
		/obj/item/weapon/reagent_containers/glass/bottle/mutagen = 2
	)

	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/hydroseeds
	name = "MegaSeed Servitor"
	desc = "When you need seeds fast!"
	product_slogans = "THIS'S WHERE TH' SEEDS LIVE! GIT YOU SOME!;Hands down the best seed selection on the station!;Also certain mushroom varieties available, more for experts! Get certified today!"
	product_ads = "We like plants!;Grow some crops!;Grow, baby, growww!;Aw h'yeah son!"
	icon_state = "seeds"

	products = list(
		/obj/item/seeds/bananaseed = 3,
		/obj/item/seeds/berryseed = 3,
		/obj/item/seeds/carrotseed = 3,
		/obj/item/seeds/chantermycelium = 3,
		/obj/item/seeds/chiliseed = 3,
		/obj/item/seeds/cornseed = 3,
		/obj/item/seeds/eggplantseed = 3,
		/obj/item/seeds/potatoseed = 3,
		/obj/item/seeds/replicapod = 3,
		/obj/item/seeds/soyaseed = 3,
		/obj/item/seeds/sunflowerseed = 3,
		/obj/item/seeds/tomatoseed = 3,
		/obj/item/seeds/towermycelium = 3,
		/obj/item/seeds/wheatseed = 3,
		/obj/item/seeds/appleseed = 3,
		/obj/item/seeds/poppyseed = 3,
		/obj/item/seeds/sugarcaneseed = 3,
		/obj/item/seeds/peanutseed = 3,
		/obj/item/seeds/whitebeetseed = 3,
		/obj/item/seeds/watermelonseed = 3,
		/obj/item/seeds/limeseed = 3,
		/obj/item/seeds/lemonseed = 3,
		/obj/item/seeds/orangeseed = 3,
		/obj/item/seeds/grassseed = 3,
		/obj/item/seeds/cocoapodseed = 3,
		/obj/item/seeds/plumpmycelium = 2,
		/obj/item/seeds/cabbageseed = 3,
		/obj/item/seeds/grapeseed = 3,
		/obj/item/seeds/pumpkinseed = 3,
		/obj/item/seeds/cherryseed = 3,
		/obj/item/seeds/plastiseed = 3,
		/obj/item/seeds/riceseed = 3,
		/obj/item/seeds/koisspore = 3
	)
	contraband = list(
		/obj/item/seeds/amanitamycelium = 2,
		/obj/item/seeds/glowshroom = 2,
		/obj/item/seeds/libertymycelium = 2,
		/obj/item/seeds/mtearseed = 2,
		/obj/item/seeds/nettleseed = 2,
		/obj/item/seeds/reishimycelium = 2,
		/obj/item/seeds/reishimycelium = 2,
		/obj/item/seeds/shandseed = 2,
		/obj/item/seeds/ambrosiavulgarisseed = 3
	)
	premium = list(
		/obj/item/toy/waterflower = 1
	)
	prices = list(
		/obj/item/seeds/bananaseed = 30,
		/obj/item/seeds/berryseed = 15,
		/obj/item/seeds/carrotseed = 15,
		/obj/item/seeds/chantermycelium = 5,
		/obj/item/seeds/chiliseed = 10,
		/obj/item/seeds/cornseed = 15,
		/obj/item/seeds/eggplantseed = 10,
		/obj/item/seeds/potatoseed = 10,
		/obj/item/seeds/replicapod = 175,
		/obj/item/seeds/soyaseed = 10,
		/obj/item/seeds/sunflowerseed = 5,
		/obj/item/seeds/tomatoseed = 15,
		/obj/item/seeds/towermycelium = 5,
		/obj/item/seeds/wheatseed = 5,
		/obj/item/seeds/appleseed = 15,
		/obj/item/seeds/poppyseed = 20,
		/obj/item/seeds/sugarcaneseed = 12,
		/obj/item/seeds/peanutseed = 25,
		/obj/item/seeds/whitebeetseed = 20,
		/obj/item/seeds/watermelonseed = 15,
		/obj/item/seeds/limeseed = 15,
		/obj/item/seeds/lemonseed = 15,
		/obj/item/seeds/orangeseed = 15,
		/obj/item/seeds/grassseed = 2,
		/obj/item/seeds/cocoapodseed = 25,
		/obj/item/seeds/plumpmycelium = 30,
		/obj/item/seeds/cabbageseed = 15,
		/obj/item/seeds/grapeseed = 15,
		/obj/item/seeds/pumpkinseed = 25,
		/obj/item/seeds/cherryseed = 25,
		/obj/item/seeds/plastiseed = 25,
		/obj/item/seeds/riceseed = 25,
		/obj/item/seeds/koisspore = 30
	)

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

/obj/machinery/vending/magivend
	name = "MagiVend"
	desc = "A magic vending machine."
	icon_state = "MagiVend"
	product_slogans = "Sling spells the proper way with MagiVend!;Be your own Houdini! Use MagiVend!"
	vend_delay = 15
	vend_reply = "Have an enchanted evening!"
	product_ads = "FJKLFJSD;AJKFLBJAKL;1234 LOONIES LOL!;>MFW;Kill them fuckers!;GET DAT FUKKEN DISK;HONK!;EI NATH;Destroy the station!;Admin conspiracies since forever!;Space-time bending hardware!"
	products = list(
		/obj/item/clothing/head/wizard = 1,
		/obj/item/clothing/suit/wizrobe = 1,
		/obj/item/clothing/head/wizard/red = 1,
		/obj/item/clothing/suit/wizrobe/red = 1,
		/obj/item/clothing/shoes/sandal = 1,
		/obj/item/weapon/staff = 2
	)
	contraband = list(
		/obj/item/weapon/reagent_containers/glass/bottle/wizarditis = 1
	)	//No one can get to the machine to hack it anyways; for the lulz - Microwave

/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	products = list(
		/obj/item/weapon/tray = 8,
		/obj/item/weapon/material/kitchen/utensil/fork = 6,
		/obj/item/weapon/material/kitchen/utensil/knife = 6,
		/obj/item/weapon/material/kitchen/utensil/spoon = 6,
		/obj/item/weapon/material/knife = 3,
		/obj/item/weapon/reagent_containers/food/drinks/drinkingglass = 8,
		/obj/item/clothing/suit/chef/classic = 2,
		/obj/item/weapon/material/kitchen/rollingpin = 2,
		/obj/item/weapon/reagent_containers/cooking_container/oven = 5,
		/obj/item/weapon/reagent_containers/cooking_container/fryer = 4,
		/obj/item/weapon/storage/toolbox/lunchbox/nt = 6
	)
	contraband = list(
		/obj/item/weapon/material/knife/butch = 2,
		/obj/item/weapon/storage/toolbox/lunchbox/syndicate = 2
	)

/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "An old sweet water vending machine,how did this end up here?"
	icon_state = "sovietsoda"
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(
		/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/soda = 30
	)
	//would a soviet vending machine really have a premium item? hmmm.
	premium = list(
		/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka = 5
	)
	contraband = list(
		/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/cola = 20
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.

/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_deny = "tool-deny"
	//req_access = list(access_maint_tunnels) //Maintenance access
	products = list(
		/obj/item/stack/cable_coil/random = 10,
		/obj/item/weapon/crowbar = 5,
		/obj/item/weapon/weldingtool = 3,
		/obj/item/weapon/wirecutters = 5,
		/obj/item/weapon/wrench = 5,
		/obj/item/device/analyzer = 5,
		/obj/item/device/t_scanner = 5,
		/obj/item/weapon/screwdriver = 5
	)
	contraband = list(
		/obj/item/weapon/weldingtool/hugetank = 2,
		/obj/item/clothing/gloves/fyellow = 2
	)
	premium = list(
		/obj/item/clothing/gloves/yellow = 1
	)

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_deny = "engivend-deny"
	req_access = list(access_engine_equip)
	products = list(
		/obj/item/clothing/glasses/meson = 2,
		/obj/item/device/multitool = 4,
		/obj/item/weapon/airlock_electronics = 10,
		/obj/item/weapon/module/power_control = 10,
		/obj/item/weapon/airalarm_electronics = 10,
		/obj/item/weapon/firealarm_electronics = 10,
		/obj/item/weapon/cell/high = 10
	)
	contraband = list(
		/obj/item/weapon/cell/potato = 3
	)
	premium = list(
		/obj/item/weapon/storage/belt/utility = 3
	)

/obj/machinery/vending/tacticool //Tried not to go overboard with the amount of fun security has access to.
	name = "Tactical Express"
	desc = "Everything you need to ensure corporate bureaucracy makes it another day."
	icon_state = "tact"
	icon_deny = "tact-deny"
	req_access = list(access_security)
	products = list(
		/obj/item/weapon/storage/box/shotgunammo = 2,
		/obj/item/weapon/storage/box/shotgunshells = 2,
		/obj/item/ammo_magazine/c45m = 6,
		/obj/item/weapon/grenade/chem_grenade/teargas = 6,
		/obj/item/ammo_magazine/mc9mmt = 2,
		/obj/item/clothing/mask/gas/tactical = 4,
		/obj/item/weapon/handcuffs/ziptie = 3
	)
	contraband = list(
		/obj/item/weapon/grenade/flashbang/clusterbang = 1 //this can only go well.
	)

/obj/machinery/vending/tacticool/ert //Slightly more !FUN!
	name = "Nanosecurity Plus"
	desc = "For when shit really goes down; the private contractor's personal armory."
	icon_state = "tact"
	icon_deny = "tact-deny"
	req_access = list(access_security)
	products = list(
		/obj/item/weapon/storage/box/shotgunammo = 2,
		/obj/item/weapon/storage/box/shotgunshells = 2,
		/obj/item/weapon/grenade/chem_grenade/gas = 6,
		/obj/item/clothing/mask/gas/tactical = 8,
		/obj/item/weapon/shield/riot/tact = 4,
		/obj/item/weapon/handcuffs/ziptie = 6,
		/obj/item/ammo_magazine/mc9mmt = 6,
		/obj/item/ammo_magazine/mc9mmt/rubber = 4,
		/obj/item/weapon/gun/projectile/automatic/x9 = 2,
		/obj/item/ammo_magazine/c45x = 6,
		/obj/item/ammo_magazine/a556 = 12,
		/obj/item/ammo_magazine/a556/ap = 4,
		/obj/item/weapon/material/hatchet/tacknife = 4
	)

//This one's from bay12
/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	icon_deny = "engi-deny"
	req_access = list(access_engine_equip)
	products = list(
		/obj/item/clothing/under/rank/chief_engineer = 4,
		/obj/item/clothing/under/rank/engineer = 4,
		/obj/item/clothing/shoes/orange = 4,
		/obj/item/clothing/head/hardhat = 4,
		/obj/item/weapon/storage/belt/utility = 4,
		/obj/item/clothing/glasses/meson = 4,
		/obj/item/clothing/gloves/yellow = 4,
		/obj/item/weapon/screwdriver = 12,
		/obj/item/weapon/crowbar = 12,
		/obj/item/weapon/wirecutters = 12,
		/obj/item/device/multitool = 12,
		/obj/item/weapon/wrench = 12,
		/obj/item/device/t_scanner = 12,
		/obj/item/stack/cable_coil/heavyduty = 8,
		/obj/item/weapon/cell = 8,
		/obj/item/weapon/weldingtool = 8,
		/obj/item/clothing/head/welding = 8,
		/obj/item/weapon/light/tube = 10,
		/obj/item/clothing/suit/fire = 4,
		/obj/item/weapon/stock_parts/scanning_module = 5,
		/obj/item/weapon/stock_parts/micro_laser = 5,
		/obj/item/weapon/stock_parts/matter_bin = 5,
		/obj/item/weapon/stock_parts/manipulator = 5,
		/obj/item/weapon/stock_parts/console_screen = 5
	)
	// There was an incorrect entry (cablecoil/power).  I improvised to cablecoil/heavyduty.
	// Another invalid entry, /obj/item/weapon/circuitry.  I don't even know what that would translate to, removed it.
	// The original products list wasn't finished.  The ones without given quantities became quantity 5.  -Sayu

//This one's from bay12
/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_deny = "robotics-deny"
	req_access = list(access_robotics)
	products = list(
		/obj/item/clothing/suit/storage/toggle/labcoat = 4,
		/obj/item/clothing/under/rank/roboticist = 4,
		/obj/item/stack/cable_coil = 4,
		/obj/item/device/flash = 4,
		/obj/item/weapon/cell/high = 12,
		/obj/item/device/assembly/prox_sensor = 3,
		/obj/item/device/assembly/signaler = 3,
		/obj/item/device/healthanalyzer = 3,
		/obj/item/weapon/scalpel = 2,
		/obj/item/weapon/circular_saw = 2,
		/obj/item/weapon/tank/anesthetic = 2,
		/obj/item/clothing/mask/breath/medical = 5,
		/obj/item/weapon/screwdriver = 5,
		/obj/item/weapon/crowbar = 5
	)
	//everything after the power cell had no amounts, I improvised.  -Sayu

//FOR ACTORS GUILD - mainly props that cannot be spawned otherwise
/obj/machinery/vending/props
	name = "prop dispenser"
	desc = "All the props an actor could need. Probably."
	icon_state = "Theater"
	products = list(
		/obj/structure/flora/pottedplant = 2,
		/obj/item/device/flashlight/lamp = 2,
		/obj/item/device/flashlight/lamp/green = 2,
		/obj/item/weapon/reagent_containers/food/drinks/jar = 1,
		/obj/item/weapon/nullrod = 1,
		/obj/item/toy/cultsword = 4,
		/obj/item/toy/katana = 2,
		/obj/item/weapon/phone = 3
	)

//FOR ACTORS GUILD - Containers
/obj/machinery/vending/containers
	name = "container dispenser"
	desc = "A container that dispenses containers."
	icon_state = "robotics"
	products = list(
		/obj/structure/closet/crate/freezer = 2,
		/obj/structure/closet = 3,
		/obj/structure/closet/crate = 3
	)
