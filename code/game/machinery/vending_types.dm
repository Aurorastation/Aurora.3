
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

//RECURSION
/obj/machinery/vending/vendors
	name = "Omni-Vendor"
	desc = "The mother of all vendors, from which vending itself comes!"
	icon_state = "engivend"
	icon_vend = "engivend-vend"
	deny_time = 6
	vend_id = "admin"
	req_access = list(ACCESS_JANITOR)
	products = list(
		/obj/item/device/vending_refill/booze = 1,
		/obj/item/device/vending_refill/tools = 1,
		/obj/item/device/vending_refill/coffee = 1,
		/obj/item/device/vending_refill/snack = 1,
		/obj/item/device/vending_refill/cola = 1,
		/obj/item/device/vending_refill/smokes = 1,
		/obj/item/device/vending_refill/meds = 1,
		/obj/item/device/vending_refill/robust = 1,
		/obj/item/device/vending_refill/hydro = 1,
		/obj/item/device/vending_refill/cutlery = 1,
		/obj/item/device/vending_refill/robo = 1,
		/obj/item/device/vending_refill/battlemonsters = 1,
	)
	random_itemcount = 0
	light_color = COLOR_GOLD


/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"        //////////////18 drink entities below, plus the glasses, in case someone wants to edit the number of bottles
	icon_vend = "boozeomat-vend"
	deny_time = 16
	vend_id = "booze"
	products = list(
		/obj/item/reagent_containers/food/drinks/bottle/applejack = 5,
		/obj/item/reagent_containers/food/drinks/bottle/bitters = 6,
		/obj/item/reagent_containers/food/drinks/bottle/boukha = 2,
		/obj/item/reagent_containers/food/drinks/bottle/brandy = 4,
		/obj/item/reagent_containers/food/drinks/bottle/grenadine = 5,
		/obj/item/reagent_containers/food/drinks/bottle/tequila = 5,
		/obj/item/reagent_containers/food/drinks/bottle/rum = 5,
		/obj/item/reagent_containers/food/drinks/bottle/fernet = 3,
		/obj/item/reagent_containers/food/drinks/bottle/cognac = 5,
		/obj/item/reagent_containers/food/drinks/bottle/cremeyvette = 4,
		/obj/item/reagent_containers/food/drinks/bottle/wine = 5,
		/obj/item/reagent_containers/food/drinks/bottle/rose_wine = 5,
		/obj/item/reagent_containers/food/drinks/bottle/whitewine = 5,
		/obj/item/reagent_containers/food/drinks/bottle/skrellwineylpha = 5,
		/obj/item/reagent_containers/food/drinks/bottle/drambuie = 4,
		/obj/item/reagent_containers/food/drinks/bottle/melonliquor = 2,
		/obj/item/reagent_containers/food/drinks/bottle/gin = 5,
		/obj/item/reagent_containers/food/drinks/bottle/vermouth = 5,
		/obj/item/reagent_containers/food/drinks/bottle/chartreusegreen = 5,
		/obj/item/reagent_containers/food/drinks/bottle/guinness = 4,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe = 2,
		/obj/item/reagent_containers/food/drinks/bottle/bluecuracao = 2,
		/obj/item/reagent_containers/food/drinks/bottle/kahlua = 5,
		/obj/item/reagent_containers/food/drinks/bottle/triplesec = 5,
		/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine = 2,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 5,
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 5,
		/obj/item/reagent_containers/food/drinks/bottle/vodka/mushroom = 2,
		/obj/item/reagent_containers/food/drinks/bottle/pulque = 5,
		/obj/item/reagent_containers/food/drinks/bottle/fireball = 2,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey = 5,
		/obj/item/reagent_containers/food/drinks/bottle/victorygin = 2,
		/obj/item/reagent_containers/food/drinks/bottle/makgeolli = 2,
		/obj/item/reagent_containers/food/drinks/bottle/soju = 2,
		/obj/item/reagent_containers/food/drinks/bottle/sake = 1,
		/obj/item/reagent_containers/food/drinks/bottle/cremewhite = 4,
		/obj/item/reagent_containers/food/drinks/bottle/mintsyrup = 5,
		/obj/item/reagent_containers/food/drinks/bottle/nmshaan_liquor = 2,
		/obj/item/reagent_containers/food/drinks/bottle/chartreuseyellow =5,
		/obj/item/reagent_containers/food/drinks/bottle/messa_mead = 2,
		/obj/item/reagent_containers/food/drinks/bottle/small/ale = 6,
		/obj/item/reagent_containers/food/drinks/bottle/small/beer = 6,
		/obj/item/reagent_containers/food/drinks/bottle/small/skrellbeerdyn = 15,
		/obj/item/reagent_containers/food/drinks/bottle/small/xuizijuice = 8,
		/obj/item/reagent_containers/food/drinks/bottle/small/khlibnyz = 4,
		/obj/item/reagent_containers/food/drinks/bottle/cola = 5,
		/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind = 5,
		/obj/item/reagent_containers/food/drinks/bottle/space_up = 5,
		/obj/item/reagent_containers/food/drinks/bottle/hrozamal_soda = 2,
		/obj/item/reagent_containers/food/drinks/bottle/small/midynhr_water = 3,
		/obj/item/reagent_containers/food/drinks/bottle/dominian_wine = 2,
		/obj/item/reagent_containers/food/drinks/bottle/assunzione_wine = 2,
		/obj/item/reagent_containers/food/drinks/bottle/algae_wine = 3,
		/obj/item/reagent_containers/food/drinks/bottle/kvass = 3,
		/obj/item/reagent_containers/food/drinks/bottle/tarasun = 3,
		/obj/item/reagent_containers/food/drinks/bottle/valokki_wine = 3,
		/obj/item/reagent_containers/food/drinks/bottle/hooch = 1,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 6,
		/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 2,
		/obj/item/reagent_containers/food/drinks/cans/sodawater = 15,
		/obj/item/reagent_containers/food/drinks/cans/tonic = 8,
		/obj/item/reagent_containers/food/drinks/cans/threetowns = 6,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice = 8,
		/obj/item/reagent_containers/food/drinks/carton/applejuice = 4,
		/obj/item/reagent_containers/food/drinks/carton/cream = 4,
		/obj/item/reagent_containers/food/drinks/carton/dynjuice = 4,
		/obj/item/reagent_containers/food/drinks/carton/limejuice = 4,
		/obj/item/reagent_containers/food/drinks/carton/lemonjuice = 4,
		/obj/item/reagent_containers/food/drinks/carton/orangejuice = 4,
		/obj/item/reagent_containers/food/drinks/carton/tomatojuice = 4,
		/obj/item/reagent_containers/food/drinks/carton/cranberryjuice = 4,
		/obj/item/reagent_containers/food/drinks/carton/fatshouters = 2,
		/obj/item/reagent_containers/food/drinks/carton/mutthir = 2,
		/obj/item/reagent_containers/food/drinks/flask/barflask = 2,
		/obj/item/reagent_containers/food/drinks/flask/vacuumflask = 2,
		/obj/item/reagent_containers/food/drinks/ice = 9,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 30,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/pint = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/square = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/mug = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shake = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/goblet = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/wine = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/flute = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cognac = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/rocks = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cocktail = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shot = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/teacup = 10,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 4,
		/obj/item/reagent_containers/glass/beaker/pitcher = 4
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/tea = 10
	)
	premium = list(
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing = 2
	)
	vend_delay = 15
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	product_slogans = "I hope nobody asks me for a bloody cup o' tea...;Alcohol is humanity's friend. Would you abandon a friend?;Quite delighted to serve you!;Is nobody thirsty on this station?"
	product_ads = "Drink up!;Booze is good for you!;Alcohol is humanity's best friend.;Quite delighted to serve you!;Care for a nice, cold beer?;Nothing cures you like booze!;Have a sip!;Have a drink!;Have a beer!;Beer is good for you!;Only the finest alcohol!;Best quality booze since 2053!;Award-winning wine!;Maximum alcohol!;Man loves beer.;A toast for progress!"
	req_access = list(ACCESS_BAR)
	random_itemcount = 0
	vending_sound = 'sound/machines/vending/vending_cans.ogg'
	light_color = COLOR_PALE_BLUE_GRAY
	exclusive_screen = FALSE
	ui_size = 60

/obj/machinery/vending/boozeomat/ui_data(mob/user)
	var/list/data = ..()
	data["width_override"] = 900
	data["height_override"] = 600
	return data

/obj/machinery/vending/boozeomat/merchant
	// boozeomat variant used on the merchant station
	products = list(
		/obj/item/reagent_containers/food/drinks/drinkingglass = 12,
		/obj/item/reagent_containers/food/drinks/ice = 12,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey = 6,
		/obj/item/reagent_containers/food/drinks/bottle/tequila = 6,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 2,
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 6,
		/obj/item/reagent_containers/food/drinks/bottle/rum = 6,
		/obj/item/reagent_containers/food/drinks/bottle/wine = 6,
		/obj/item/reagent_containers/food/drinks/bottle/cognac = 6,
		/obj/item/reagent_containers/food/drinks/bottle/victorygin = 6,
		/obj/item/reagent_containers/food/drinks/bottle/boukha = 6,
		/obj/item/reagent_containers/food/drinks/bottle/small/beer = 12,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe = 6,
		/obj/item/reagent_containers/food/drinks/bottle/brandy = 6,
		/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine = 6)
	random_itemcount = 1
	req_access = list()
	restock_items = 1

/obj/machinery/vending/boozeomat/abandoned
	// badly stocked, with trash, junk, etc
	desc = "Used to hold bottles and drinks cold and nice in the past, now it is all dusty and barely functioning, if at all."
	products = list(
		/obj/item/reagent_containers/food/drinks/drinkingglass = 1,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shot = 5,
		/obj/item/reagent_containers/food/drinks/ice = 1,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey = 2,
		/obj/item/reagent_containers/food/drinks/bottle/tequila = 1,
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 2,
		/obj/item/reagent_containers/food/drinks/bottle/rum = 1,
		/obj/item/reagent_containers/food/drinks/bottle/wine = 1,
		/obj/item/reagent_containers/food/drinks/bottle/victorygin = 1,
		/obj/item/reagent_containers/food/drinks/bottle/small/beer = 2,
		/obj/item/reagent_containers/food/drinks/bottle = 6,
		/obj/random/junk = 7,
		/obj/item/material/shard = 3,
		/obj/item/broken_bottle = 5)
	random_itemcount = 1
	req_access = list()
	restock_items = 1
	use_power = 0

/obj/machinery/vending/assist
	vend_id = "tools"
	icon_state = "generic"
	icon_vend = "generic-vend"
	products = list(
		/obj/item/device/assembly/prox_sensor = 5,
		/obj/item/device/assembly/igniter = 3,
		/obj/item/device/assembly/signaler = 4,
		/obj/item/wirecutters = 1
	)
	contraband = list(
		/obj/item/device/flashlight = 5,
		/obj/item/device/assembly/timer = 2,
		/obj/item/device/assembly/infra = 2,
		/obj/item/device/assembly/voice = 2
	)
	premium = list(
		/obj/item/device/multitool/ = 2
	)
	product_ads = "Only the finest!;Have some tools.;The most robust equipment.;The finest gear in space!"
	restock_items = 1
	light_color = COLOR_GUNMETAL

/obj/machinery/vending/assist/synd
	name = "Parts vendor"
	desc = "Just a normal vending machine - nothing to see here."
	icon_state = "generic"
	icon_vend = "generic-vend"
	contraband = null
	random_itemcount = 0
	products = list(
		/obj/item/device/assembly/prox_sensor = 5,
		/obj/item/device/assembly/signaler = 4,
		/obj/item/device/assembly/infra = 4,
		/obj/item/device/assembly/prox_sensor = 4,
		/obj/item/handcuffs = 8,
		/obj/item/device/flash = 4,
		/obj/item/clothing/glasses/sunglasses = 4
	)


/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	product_ads = "Have a drink!;Drink up!;It's good for you!;Would you like a hot joe?;I'd kill for some coffee!;The best beans in the galaxy.;Only the finest brew for you.;Mmmm. Nothing like a coffee.;I like coffee, don't you?;Coffee helps you work!;Try some tea.;We hope you like the best!;Try our new chocolate!;Admin conspiracies"
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	vend_delay = 34
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vend_id = "coffee"
	products = list(
		/obj/item/reagent_containers/food/drinks/coffee = 25,
		/obj/item/reagent_containers/food/drinks/tea = 25,
		/obj/item/reagent_containers/food/drinks/greentea = 25,
		/obj/item/reagent_containers/food/drinks/chaitea = 25,
		/obj/item/reagent_containers/food/drinks/hotcider = 25,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 25,
		/obj/item/reagent_containers/food/snacks/donut/normal = 20
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/ice = 10,
		/obj/item/reagent_containers/food/drinks/carton/soymilk = 2
	)
	prices = list(
		/obj/item/reagent_containers/food/drinks/coffee = 20,
		/obj/item/reagent_containers/food/drinks/tea = 20,
		/obj/item/reagent_containers/food/drinks/greentea = 20,
		/obj/item/reagent_containers/food/drinks/chaitea = 25,
		/obj/item/reagent_containers/food/drinks/hotcider = 28,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 22,
		/obj/item/reagent_containers/food/snacks/donut/normal = 6
	)
	premium = list(
		/obj/item/reagent_containers/glass/beaker/teapot/ = 5
	)
	vending_sound = 'sound/machines/vending/vending_coffee.ogg'
	cooling_temperature = T0C + 57 //Optimal coffee temperature
	heating_temperature = T0C + 100 //ULTRA HOT COFFEE
	temperature_setting = -1
	light_color = COLOR_BROWN

/obj/machinery/vending/coffee/free
	name = "Free Hot Drinks machine"
	desc = "A vending machine which dispenses complimentary hot drinks."
	random_itemcount = 0
	products = list(
		/obj/item/reagent_containers/food/drinks/coffee = 12,
		/obj/item/reagent_containers/food/drinks/tea = 8,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 8,
		/obj/item/reagent_containers/food/snacks/donut/normal = 6
	)
	prices = list()

/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	icon_vend = "snack-vend"
	vend_id = "snacks"
	products = list(
		/obj/item/reagent_containers/food/snacks/candy = 6,
		/obj/item/reagent_containers/food/drinks/dry_ramen = 6,
		/obj/item/reagent_containers/food/snacks/chips =6,
		/obj/item/reagent_containers/food/snacks/sosjerky = 6,
		/obj/item/reagent_containers/food/snacks/no_raisin = 6,
		/obj/item/reagent_containers/food/snacks/spacetwinkie = 6,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers = 6,
		/obj/item/reagent_containers/food/snacks/tastybread = 6,
		/obj/item/storage/box/pineapple = 4,
		/obj/item/reagent_containers/food/snacks/chocolatebar = 6,
		/obj/item/reagent_containers/food/snacks/whitechocolate/wrapped = 6,
		/obj/item/storage/box/fancy/cookiesnack = 6,
		/obj/item/storage/box/fancy/gum = 4,
		/obj/item/storage/box/fancy/vkrexitaffy = 5,
		/obj/item/clothing/mask/chewable/candy/lolli = 8,
		/obj/item/storage/box/fancy/admints = 4,
		/obj/item/reagent_containers/food/snacks/skrellsnacks = 3,
		/obj/item/reagent_containers/food/snacks/meatsnack = 2,
		/obj/item/reagent_containers/food/snacks/maps = 2,
		/obj/item/reagent_containers/food/snacks/nathisnack = 2,
		/obj/item/reagent_containers/food/snacks/koisbar_clean = 4,
		/obj/item/reagent_containers/food/snacks/candy/koko = 5,
		/obj/item/reagent_containers/food/snacks/tuna = 2,
		/obj/item/reagent_containers/food/snacks/adhomian_can = 2,
		/obj/item/reagent_containers/food/snacks/ricetub = 2,
		/obj/item/reagent_containers/food/snacks/riceball = 4,
		/obj/item/reagent_containers/food/snacks/seaweed = 5,
		/obj/item/reagent_containers/food/drinks/jyalra = 5,
		/obj/item/reagent_containers/food/drinks/jyalra/cheese = 5,
		/obj/item/reagent_containers/food/drinks/jyalra/apple = 5,
		/obj/item/reagent_containers/food/drinks/jyalra/cherry = 5
	)
	contraband = list(
		/obj/item/reagent_containers/food/snacks/syndicake = 6,
		/obj/item/reagent_containers/food/snacks/koisbar = 4
	)
	premium = list(
		/obj/item/reagent_containers/food/snacks/cookie = 6,
		/obj/item/storage/box/fancy/food/pralinebox = 2
	)
	prices = list(
		/obj/item/reagent_containers/food/snacks/candy = 15,
		/obj/item/reagent_containers/food/drinks/dry_ramen = 20,
		/obj/item/reagent_containers/food/snacks/chips = 17,
		/obj/item/reagent_containers/food/snacks/sosjerky = 20,
		/obj/item/reagent_containers/food/snacks/no_raisin = 12,
		/obj/item/reagent_containers/food/snacks/spacetwinkie = 15,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers = 15,
		/obj/item/reagent_containers/food/snacks/tastybread = 18,
		/obj/item/storage/box/pineapple = 20,
		/obj/item/reagent_containers/food/snacks/chocolatebar = 12,
		/obj/item/reagent_containers/food/snacks/whitechocolate/wrapped = 12,
		/obj/item/storage/box/fancy/gum = 15,
		/obj/item/clothing/mask/chewable/candy/lolli = 2,
		/obj/item/storage/box/fancy/admints = 12,
		/obj/item/storage/box/fancy/cookiesnack = 20,
		/obj/item/storage/box/fancy/vkrexitaffy = 12,
		/obj/item/reagent_containers/food/snacks/skrellsnacks = 40,
		/obj/item/reagent_containers/food/snacks/meatsnack = 22,
		/obj/item/reagent_containers/food/snacks/maps = 23,
		/obj/item/reagent_containers/food/snacks/nathisnack = 24,
		/obj/item/reagent_containers/food/snacks/koisbar_clean = 60,
		/obj/item/reagent_containers/food/snacks/candy/koko = 40,
		/obj/item/reagent_containers/food/snacks/tuna = 23,
		/obj/item/reagent_containers/food/snacks/adhomian_can = 26,
		/obj/item/reagent_containers/food/snacks/ricetub = 40,
		/obj/item/reagent_containers/food/snacks/riceball = 15,
		/obj/item/reagent_containers/food/snacks/seaweed = 20,
		/obj/item/reagent_containers/food/drinks/jyalra = 38,
		/obj/item/reagent_containers/food/drinks/jyalra/cheese = 44,
		/obj/item/reagent_containers/food/drinks/jyalra/apple = 44,
		/obj/item/reagent_containers/food/drinks/jyalra/cherry = 44
	)
	light_color = COLOR_BABY_BLUE
	manufacturer = "nanotrasen"

/obj/machinery/vending/snack/konyang
	products = list(
		/obj/item/reagent_containers/food/snacks/candy = 6,
		/obj/item/reagent_containers/food/drinks/dry_ramen = 12,
		/obj/item/reagent_containers/food/snacks/chips =6,
		/obj/item/reagent_containers/food/snacks/sosjerky = 6,
		/obj/item/reagent_containers/food/snacks/no_raisin = 6,
		/obj/item/reagent_containers/food/snacks/spacetwinkie = 6,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers = 6,
		/obj/item/reagent_containers/food/snacks/tastybread = 12,
		/obj/item/storage/box/pineapple = 6,
		/obj/item/reagent_containers/food/snacks/chocolatebar = 6,
		/obj/item/storage/box/fancy/cookiesnack = 6,
		/obj/item/storage/box/fancy/gum = 4,
		/obj/item/clothing/mask/chewable/candy/lolli = 8,
		/obj/item/storage/box/fancy/admints = 4,
		/obj/item/reagent_containers/food/snacks/skrellsnacks = 3,
		/obj/item/reagent_containers/food/snacks/meatsnack = 2,
		/obj/item/reagent_containers/food/snacks/maps = 2,
		/obj/item/reagent_containers/food/snacks/tuna = 2,
		/obj/item/reagent_containers/food/snacks/ricetub = 4,
		/obj/item/reagent_containers/food/snacks/riceball = 8,
		/obj/item/reagent_containers/food/snacks/seaweed = 10,
	)
/obj/machinery/vending/cola
	name = "Idris Re-Fresh"
	desc = "A soft drink vendor provided by an Idris subsidiary."
	icon_state = "cola_machine"
	icon_vend = "cola_machine-vend"
	product_slogans = "Idris Re-Fresh: the more expensive the place, the more of us you'll seee!"
	product_ads = "Refreshing!;Hope you're thirsty!;Thirsty? Why not cola?;Please, have a drink!;Drink up!;The best drinks in space."
	vend_id = "cola"
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 10,
		/obj/item/reagent_containers/food/drinks/cans/diet_cola = 10,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 10,
		/obj/item/reagent_containers/food/drinks/cans/root_beer = 10,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 10,
		/obj/item/reagent_containers/food/drinks/waterbottle = 10,
		/obj/item/reagent_containers/food/drinks/cans/dyn = 10,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 10,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 10,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 10,
		/obj/item/reagent_containers/food/drinks/cans/peach_soda = 10,
		/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 10,
		/obj/item/reagent_containers/food/drinks/cans/hrozamal_soda = 10,
		/obj/item/reagent_containers/food/drinks/carton/small/milk = 10,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/choco = 10,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/strawberry = 10,
		/obj/item/reagent_containers/food/drinks/cans/melon_soda = 10
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 5,
		/obj/item/reagent_containers/food/drinks/cans/koispunch = 3
	)
	premium = list(
		/obj/item/reagent_containers/food/drinks/bottle/cola = 2,
		/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind = 2,
		/obj/item/reagent_containers/food/drinks/bottle/space_up = 2
	)
	prices = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 15,
		/obj/item/reagent_containers/food/drinks/cans/diet_cola = 15,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 11,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 16,
		/obj/item/reagent_containers/food/drinks/cans/root_beer = 13,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 15,
		/obj/item/reagent_containers/food/drinks/waterbottle = 12,
		/obj/item/reagent_containers/food/drinks/cans/dyn = 18,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 15,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 13,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 16,
		/obj/item/reagent_containers/food/drinks/cans/peach_soda = 16,
		/obj/item/reagent_containers/food/drinks/cans/koispunch = 50,
		/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 5,
		/obj/item/reagent_containers/food/drinks/cans/hrozamal_soda = 35,
		/obj/item/reagent_containers/food/drinks/carton/small/milk = 18,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/choco = 18,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/strawberry = 18,
		/obj/item/reagent_containers/food/drinks/cans/melon_soda = 16
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vending_sound = 'sound/machines/vending/vending_cans.ogg'
	temperature_setting = -1
	light_color = COLOR_GUNMETAL

/obj/machinery/vending/cola/konyang
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 10,
		/obj/item/reagent_containers/food/drinks/cans/diet_cola = 10,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 10,
		/obj/item/reagent_containers/food/drinks/waterbottle = 10,
		/obj/item/reagent_containers/food/drinks/cans/dyn = 5,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 10,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 10,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 10,
		/obj/item/reagent_containers/food/drinks/cans/peach_soda = 10,
		/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 5,
		/obj/item/reagent_containers/food/drinks/carton/small/milk = 10,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/choco = 10,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/strawberry = 10,
		/obj/item/reagent_containers/food/drinks/cans/melon_soda = 10
	)

/obj/machinery/vending/cigarette
	name = "cigarette machine" //OCD had to be uppercase to look nice with the new formating
	desc = "If you want to get cancer, might as well do it in style!"
	product_slogans = "Space cigs taste good like a cigarette should.;I'd rather toolbox than switch.;Smoke!;Don't believe the reports - smoke today!"
	product_ads = "Probably not bad for you!;Don't believe the scientists!;It's good for you!;Don't quit, buy more!;Smoke!;Nicotine heaven.;Best cigarettes since 2150.;Award-winning cigs."
	vend_delay = 24
	icon_state = "cigs"
	icon_vend = "cigs-vend"
	vend_id = "smokes"
	products = list(
		/obj/item/storage/box/fancy/cigarettes/rugged = 6,
		/obj/item/storage/box/fancy/cigarettes = 8,
		/obj/item/storage/box/fancy/cigarettes/dromedaryco = 5,
		/obj/item/storage/box/fancy/cigarettes/nicotine = 3,
		/obj/item/storage/box/fancy/cigarettes/pra = 6,
		/obj/item/storage/box/fancy/cigarettes/dpra = 6,
		/obj/item/storage/box/fancy/cigarettes/nka = 6,
		/obj/item/storage/box/fancy/cigarettes/federation = 3,
		/obj/item/storage/box/fancy/cigarettes/dyn = 3,
		/obj/item/storage/box/fancy/cigarettes/oracle = 3,
		/obj/item/storage/chewables/rollable = 8,
		/obj/item/storage/chewables/rollable/unathi = 6,
		/obj/item/storage/chewables/rollable/fine = 5,
		/obj/item/storage/chewables/rollable/nico = 3,
		/obj/item/storage/chewables/rollable/oracle = 5,
		/obj/item/storage/chewables/rollable/vedamor = 3,
		/obj/item/storage/chewables/tobacco/bad = 6,
		/obj/item/storage/chewables/tobacco = 8,
		/obj/item/storage/chewables/tobacco/fine = 5,
		/obj/item/storage/chewables/tobacco/federation = 2,
		/obj/item/storage/chewables/tobacco/dyn = 2,
		/obj/item/storage/chewables/oracle = 4,
		/obj/item/storage/box/fancy/chewables/tobacco/nico = 3,
		/obj/item/storage/cigfilters = 6,
		/obj/item/storage/box/fancy/cigpaper = 6,
		/obj/item/storage/box/fancy/cigpaper/fine = 4,
		/obj/item/storage/box/fancy/matches = 10,
		/obj/item/flame/lighter/random = 4,
		/obj/item/spacecash/ewallet/lotto = 30,
		/obj/item/clothing/mask/smokable/ecig/util = 2,
		/obj/item/clothing/mask/smokable/ecig/simple = 2,
		/obj/item/reagent_containers/ecig_cartridge/med_nicotine = 10,
		/obj/item/reagent_containers/ecig_cartridge/high_nicotine = 10,
		/obj/item/reagent_containers/ecig_cartridge/orange = 10,
		/obj/item/reagent_containers/ecig_cartridge/watermelon = 10,
		/obj/item/reagent_containers/ecig_cartridge/grape = 10
	)
	contraband = list(
		/obj/item/storage/box/fancy/cigarettes/blank = 5,
		/obj/item/storage/box/fancy/cigarettes/acmeco = 5,
		/obj/item/clothing/mask/smokable/cigarette/cigar/sausage = 3
	)
	premium = list(
		/obj/item/flame/lighter/zippo = 4,
		/obj/item/storage/box/fancy/cigarettes/cigar = 5
	)
	prices = list(
		/obj/item/storage/box/fancy/cigarettes/rugged = 67,
		/obj/item/storage/box/fancy/cigarettes = 76,
		/obj/item/storage/box/fancy/cigarettes/dromedaryco = 82,
		/obj/item/storage/box/fancy/cigarettes/nicotine = 89,
		/obj/item/storage/box/fancy/cigarettes/pra = 79,
		/obj/item/storage/box/fancy/cigarettes/dpra = 84,
		/obj/item/storage/box/fancy/cigarettes/nka = 74,
		/obj/item/storage/box/fancy/cigarettes/federation = 93,
		/obj/item/storage/box/fancy/cigarettes/dyn = 84,
		/obj/item/storage/box/fancy/cigarettes/oracle = 84,
		/obj/item/storage/chewables/rollable = 63,
		/obj/item/storage/chewables/rollable/unathi = 65,
		/obj/item/storage/chewables/rollable/fine = 69,
		/obj/item/storage/chewables/rollable/nico = 86,
		/obj/item/storage/chewables/rollable/oracle = 66,
		/obj/item/storage/chewables/rollable/vedamor = 72,
		/obj/item/storage/chewables/tobacco/bad = 55,
		/obj/item/storage/chewables/tobacco = 74,
		/obj/item/storage/chewables/tobacco/fine = 86,
		/obj/item/storage/chewables/tobacco/federation = 88,
		/obj/item/storage/chewables/tobacco/dyn = 85,
		/obj/item/storage/box/fancy/chewables/tobacco/nico = 91,
		/obj/item/storage/chewables/oracle = 76,
		/obj/item/storage/box/fancy/matches = 12,
		/obj/item/flame/lighter/random = 12,
		/obj/item/storage/cigfilters = 28,
		/obj/item/storage/box/fancy/cigpaper = 35,
		/obj/item/storage/box/fancy/cigpaper/fine = 42,
		/obj/item/spacecash/ewallet/lotto = 200,
		/obj/item/clothing/mask/smokable/ecig/simple = 200,
		/obj/item/clothing/mask/smokable/ecig/util = 300,
		/obj/item/reagent_containers/ecig_cartridge/med_nicotine = 34,
		/obj/item/reagent_containers/ecig_cartridge/high_nicotine = 38,
		/obj/item/reagent_containers/ecig_cartridge/orange = 32,
		/obj/item/reagent_containers/ecig_cartridge/watermelon = 30,
		/obj/item/reagent_containers/ecig_cartridge/grape = 33
	)
	light_color = COLOR_BLUE_GRAY

/obj/machinery/vending/cigarette/merchant
	// Mapped in merchant station
	premium = list()
	prices = list()
	products = list(
		/obj/item/storage/box/fancy/cigarettes = 10,
		/obj/item/storage/box/fancy/cigarettes/oracle = 10,
		/obj/item/storage/box/fancy/matches = 10,
		/obj/item/flame/lighter/random = 4,
		/obj/item/storage/box/fancy/cigarettes/cigar = 5,
		/obj/item/storage/box/fancy/cigarettes/acmeco = 5
	)

/obj/machinery/vending/cigarette/hacked
	name = "hacked cigarette machine"
	prices = list()
	products = list(
		/obj/item/storage/box/fancy/cigarettes = 10,
		/obj/item/storage/box/fancy/matches = 10,
		/obj/item/flame/lighter/zippo = 4,
		/obj/item/clothing/mask/smokable/cigarette/cigar/havana = 2
	)

/obj/machinery/vending/medical
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	icon_vend = "med-vend"
	deny_time = 15
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(ACCESS_MEDICAL_EQUIP)
	vend_id = "meds"
	products = list(
		/obj/item/reagent_containers/glass/bottle/antitoxin = 4,
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 4,
		/obj/item/reagent_containers/glass/bottle/perconol = 3,
		/obj/item/reagent_containers/glass/bottle/toxin = 1,
		/obj/item/reagent_containers/glass/bottle/coagzolug = 2,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 2,
		/obj/item/reagent_containers/syringe = 12,
		/obj/item/device/healthanalyzer = 5,
		/obj/item/device/breath_analyzer = 2,
		/obj/item/reagent_containers/glass/beaker = 4,
		/obj/item/reagent_containers/dropper = 2,
		/obj/item/stack/medical/bruise_pack = 5,
		/obj/item/stack/medical/ointment = 5,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 3,
		/obj/item/stack/medical/splint = 2,
		/obj/item/reagent_containers/pill/antitox = 6,
		/obj/item/reagent_containers/pill/cetahydramine = 6,
		/obj/item/reagent_containers/pill/perconol = 6,
		/obj/item/reagent_containers/glass/beaker/medcup = 4,
		/obj/item/storage/pill_bottle = 4,
		/obj/item/reagent_containers/spray/sterilizine = 2
	)
	contraband = list(
		/obj/item/reagent_containers/inhaler/space_drugs = 2,
		/obj/item/reagent_containers/pill/tox = 3,
		/obj/item/reagent_containers/pill/stox = 4
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	random_itemcount = 0
	temperature_setting = -1
	light_color = LIGHT_COLOR_GREEN
	manufacturer = "zenghu"

//This one's from bay12
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
	restock_items = 1
	random_itemcount = 0
	light_color = COLOR_BLUE_GRAY
	manufacturer = "scc"


/obj/machinery/vending/wallmed1
	name = "\improper NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	deny_time = 15
	req_access = list(ACCESS_MEDICAL)
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	vend_id = "meds"
	products = list(
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment = 3,
		/obj/item/reagent_containers/pill/perconol = 4,
		/obj/item/storage/box/fancy/med_pouch/trauma = 1,
		/obj/item/storage/box/fancy/med_pouch/burn = 1,
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 1,
		/obj/item/storage/box/fancy/med_pouch/toxin = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/device/breath_analyzer  = 1
	)
	contraband = list(
		/obj/item/reagent_containers/syringe/dylovene = 4,
		/obj/item/reagent_containers/pill/tox = 1
	)
	premium = list(
		/obj/item/reagent_containers/pill/mortaphenyl = 4
	)
	random_itemcount = 0
	temperature_setting = -1
	light_color = LIGHT_COLOR_GREEN
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	manufacturer = "zenghu"

/obj/machinery/vending/wallmed2
	name = "\improper NanoMed Mini"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	icon_state = "wallmed"
	deny_time = 15
	req_access = list(ACCESS_MEDICAL)
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	vend_id = "meds"
	products = list(
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline = 5,
		/obj/item/stack/medical/bruise_pack = 4,
		/obj/item/stack/medical/ointment = 4,
		/obj/item/storage/box/fancy/med_pouch/trauma = 1,
		/obj/item/storage/box/fancy/med_pouch/burn = 1,
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 1,
		/obj/item/storage/box/fancy/med_pouch/toxin = 1,
		/obj/item/storage/box/fancy/med_pouch/radiation = 1,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/device/breath_analyzer = 1
	)
	contraband = list(
		/obj/item/reagent_containers/pill/tox = 3
	)
	premium = list(
		/obj/item/reagent_containers/pill/mortaphenyl = 4
	)
	random_itemcount = 0
	temperature_setting = -1
	light_color = LIGHT_COLOR_GREEN
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	manufacturer = "zenghu"

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_vend = "sec-vend"
	deny_time = 16
	req_access = list(ACCESS_SECURITY)
	vend_id = "security"
	products = list(
		/obj/item/handcuffs = 8,
		/obj/item/grenade/chem_grenade/teargas = 4,
		/obj/item/device/flash = 5,
		/obj/item/reagent_containers/spray/pepper = 5,
		/obj/item/storage/box/evidence = 6,
		/obj/item/device/holowarrant = 5,
		/obj/item/device/flashlight/maglight = 5,
		/obj/item/device/hailer = 5,
		/obj/item/reagent_containers/food/snacks/donut/normal = 6
	)
	premium = list(
		/obj/item/storage/box/fancy/donut = 2
	)
	contraband = list(
		/obj/item/clothing/glasses/sunglasses = 2,
		/obj/item/grenade/flashbang = 4,
		/obj/item/grenade/stinger = 4
	)
	restock_blocked_items = list(
		/obj/item/storage/box/fancy/donut,
		/obj/item/storage/box/evidence,
		/obj/item/device/flash,
		/obj/item/reagent_containers/spray/pepper
		)
	restock_items = 1
	random_itemcount = 0
	light_color = COLOR_BABY_BLUE
	exclusive_screen = FALSE
	manufacturer = "zavodskoi"

/obj/machinery/vending/hydronutrients
	name = "NutriMax"
	desc = "A plant nutrients vendor."
	product_slogans = "Aren't you glad you don't have to fertilize the natural way?;Now with 50% less stink!;Plants are people too!"
	product_ads = "We like plants!;Don't you want some?;The greenest thumbs ever.;We like big plants.;Soft soil..."
	icon_state = "nutri"
	icon_vend = "nutri-vend"
	deny_time = 6
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
		/obj/item/reagent_containers/glass/bottle/diethylamine = 5
	)
	contraband = list(
		/obj/item/reagent_containers/glass/bottle/mutagen = 2
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	random_itemcount = 0
	light_color = COLOR_BABY_BLUE

/obj/machinery/vending/hydronutrients/xenobotany
	products = list(
		/obj/item/reagent_containers/glass/fertilizer/ez = 6,
		/obj/item/reagent_containers/glass/fertilizer/l4z = 5,
		/obj/item/reagent_containers/glass/fertilizer/rh = 3,
		/obj/item/plantspray/pests = 20,
		/obj/item/reagent_containers/syringe = 5,
		/obj/item/storage/bag/plants = 5,
		/obj/item/reagent_containers/glass/bottle/mutagen = 3
	)

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
		/obj/item/seeds/nifberries = 2,
		/obj/item/seeds/onionseed = 3,
		/obj/item/seeds/oracleseed = 3,
		/obj/item/seeds/orangeseed = 3,
		/obj/item/seeds/peanutseed = 3,
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
		/obj/item/seeds/ambrosiavulgarisseed = 70,
		/obj/item/seeds/appleseed = 50,
		/obj/item/seeds/bananaseed = 60,
		/obj/item/seeds/berryseed = 40,
		/obj/item/seeds/blackraspberryseed = 40,
		/obj/item/seeds/blizzard = 60,
		/obj/item/seeds/blueberryseed = 30,
		/obj/item/seeds/blueraspberryseed = 40,
		/obj/item/seeds/cabbageseed = 40,
		/obj/item/seeds/carrotseed = 20,
		/obj/item/seeds/chantermycelium = 20,
		/obj/item/seeds/cherryseed = 40,
		/obj/item/seeds/chiliseed = 50,
		/obj/item/seeds/cocoapodseed = 50,
		/obj/item/seeds/coffeeseed = 70,
		/obj/item/seeds/cornseed = 30,
		/obj/item/seeds/dynseed = 80,
		/obj/item/seeds/earthenroot = 70,
		/obj/item/seeds/eggplantseed = 30,
		/obj/item/seeds/eki = 90,
		/obj/item/seeds/garlicseed = 30,
		/obj/item/seeds/grapeseed = 40,
		/obj/item/seeds/grassseed = 40,
		/obj/item/seeds/greengrapeseed = 40,
		/obj/item/seeds/guamiseed = 80,
		/obj/item/seeds/harebell = 10,
		/obj/item/seeds/lemonseed = 40,
		/obj/item/seeds/limeseed = 50,
		/obj/item/seeds/mtearseed = 60,
		/obj/item/seeds/mintseed = 70,
		/obj/item/seeds/nifberries = 70,
		/obj/item/seeds/onionseed = 30,
		/obj/item/seeds/oracleseed = 50,
		/obj/item/seeds/orangeseed = 40,
		/obj/item/seeds/peanutseed = 30,
		/obj/item/seeds/peppercornseed = 30,
		/obj/item/seeds/plastiseed = 40,
		/obj/item/seeds/plumpmycelium = 20,
		/obj/item/seeds/poppyseed = 10,
		/obj/item/seeds/potatoseed = 30,
		/obj/item/seeds/pumpkinseed = 40,
		/obj/item/seeds/qlortseed = 70,
		/obj/item/seeds/clam/rasval = 100,
		/obj/item/seeds/raspberryseed = 40,
		/obj/item/seeds/reishimycelium = 30,
		/obj/item/seeds/replicapod = 200,
		/obj/item/seeds/riceseed = 20,
		/obj/item/seeds/richcoffeeseed = 140,
		/obj/item/seeds/shandseed = 60,
		/obj/item/seeds/soyaseed = 40,
		/obj/item/seeds/strawberryseed = 40,
		/obj/item/seeds/sugarcaneseed = 20,
		/obj/item/seeds/sunflowerseed = 20,
		/obj/item/seeds/sugartree = 40,
		/obj/item/seeds/teaseed = 30,
		/obj/item/seeds/tobaccoseed = 40,
		/obj/item/seeds/tomatoseed = 30,
		/obj/item/seeds/towermycelium = 20,
		/obj/item/seeds/vanilla = 30,
		/obj/item/seeds/watermelonseed = 30,
		/obj/item/seeds/wheatseed = 20,
		/obj/item/seeds/whitebeetseed = 20,
		/obj/item/seeds/wulumunushaseed = 90,
		/obj/item/seeds/ylpha = 95
	)
	restock_items = 1
	random_itemcount = 0
	light_color = COLOR_BABY_BLUE

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

/obj/machinery/vending/dinnerware
	name = "Dinnerware"
	desc = "A kitchen and restaurant equipment vendor."
	product_ads = "Mm, food stuffs!;Food and food accessories.;Get your plates!;You like forks?;I like forks.;Woo, utensils.;You don't really need these..."
	icon_state = "dinnerware"
	icon_vend = "dinnerware-vend"
	vend_id = "cutlery"
	products = list(
		/obj/item/material/kitchen/utensil/fork = 12,
		/obj/item/material/kitchen/utensil/knife = 12,
		/obj/item/material/kitchen/utensil/spoon = 12,
		/obj/item/material/kitchen/utensil/fork/chopsticks = 12,
		/obj/item/material/knife = 2,
		/obj/item/material/hatchet/butch = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 3,
		/obj/item/reagent_containers/glass/beaker/pitcher = 3,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 6,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 6,
		/obj/item/clothing/accessory/apron/chef = 2,
		/obj/item/clothing/suit/chef_jacket = 2,
		/obj/item/material/kitchen/rollingpin = 2,
		/obj/item/reagent_containers/cooking_container/oven = 5,
		/obj/item/reagent_containers/cooking_container/fryer = 4,
		/obj/item/reagent_containers/cooking_container/skillet = 4,
		/obj/item/reagent_containers/cooking_container/saucepan = 4,
		/obj/item/reagent_containers/cooking_container/pot = 4,
		/obj/item/reagent_containers/cooking_container/board = 3,
		/obj/item/reagent_containers/cooking_container/board/bowl = 2,
		/obj/item/reagent_containers/ladle = 4,
		/obj/item/storage/toolbox/lunchbox/nt = 6,
		/obj/item/reagent_containers/glass/rag = 8,
		/obj/item/evidencebag/plasticbag = 20,
		/obj/item/tray = 12,
		/obj/item/tray/tea = 2,
		/obj/item/tray/plate = 10,
		/obj/item/reagent_containers/bowl = 10,
		/obj/item/reagent_containers/bowl/plate = 10,
		/obj/item/reagent_containers/glass/bottle/syrup = 4,
	)
	contraband = list(
		/obj/item/storage/toolbox/lunchbox/syndicate = 2
	)
	premium = list(
		/obj/item/storage/toolbox/lunchbox/scc/filled = 2
	)
	restock_items = 1
	random_itemcount = 0
	light_color = COLOR_STEEL

/obj/machinery/vending/dinnerware/plastic
	name = "utensil vendor"
	desc = "A kitchen and restaurant utensil vendor."
	products = list(
		/obj/item/material/kitchen/utensil/fork/plastic = 12,
		/obj/item/material/kitchen/utensil/spoon/plastic = 12,
		/obj/item/material/kitchen/utensil/knife/plastic = 12,
		/obj/item/material/kitchen/utensil/fork/chopsticks/bamboo = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 3,
		/obj/item/reagent_containers/glass/beaker/pitcher = 3,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 6,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 6,
	)

/obj/machinery/vending/dinnerware/bar
	name = "utensil vendor"
	desc = "A bar utensil vendor."
	products = list(
		/obj/item/reagent_containers/food/drinks/drinkingglass = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 3,
		/obj/item/reagent_containers/glass/beaker/pitcher = 3,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 6,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 6,
	)

/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "An old sweet water vending machine, how did this end up here?"
	icon_state = "sovietsoda"
	icon_vend = "sovietsoda-vend"
	vend_id = "cola"
	product_ads = "For Tsar and Country.;Have you fulfilled your nutrition quota today?;Very nice!;We are simple people, for this is all we eat.;If there is a person, there is a problem. If there is no person, then there is no problem."
	products = list(
		/obj/item/reagent_containers/food/drinks/drinkingglass/soda = 30
	)
	//would a soviet vending machine really have a premium item? hmmm.
	premium = list(
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 5
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/drinkingglass/cola = 20
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	random_itemcount = 0
	temperature_setting = -1
	vending_sound = 'sound/machines/vending/vending_cans.ogg'
	light_color = COLOR_RED

/obj/machinery/vending/tool
	name = "YouTool"
	desc = "Tools for tools."
	icon_state = "tool"
	icon_vend = "tool-vend"
	deny_time = 6
	vend_id = "tools"
	//req_access = list(ACCESS_MAINT_TUNNELS) //Maintenance access
	products = list(
		/obj/item/stack/cable_coil/random = 10,
		/obj/item/crowbar = 5,
		/obj/item/weldingtool = 3,
		/obj/item/wirecutters = 5,
		/obj/item/wrench = 5,
		/obj/item/device/analyzer = 5,
		/obj/item/device/t_scanner = 5,
		/obj/item/screwdriver = 5,
		/obj/item/tape_roll = 3,
		/obj/item/hammer = 5
	)
	contraband = list(
		/obj/item/weldingtool/hugetank = 2,
		/obj/item/clothing/gloves/yellow/budget = 2
	)
	premium = list(
		/obj/item/clothing/gloves/yellow = 1
	)
	restock_blocked_items = list(
		/obj/item/stack/cable_coil,
		/obj/item/weldingtool,
		/obj/item/weldingtool/hugetank
	)
	restock_items = 1
	light_color = COLOR_GOLD
	manufacturer = "hephaestus"

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_vend = "engivend-vend"
	deny_time = 6
	req_access = list(ACCESS_ENGINE)
	vend_id = "tools"
	products = list(
		/obj/item/device/multitool = 4,
		/obj/item/powerdrill = 2,
		/obj/item/taperoll/engineering = 4,
		/obj/item/clothing/glasses/safety/goggles = 4,
		/obj/item/airlock_electronics = 20,
		/obj/item/module/power_control = 10,
		/obj/item/airalarm_electronics = 10,
		/obj/item/firealarm_electronics = 10,
		/obj/item/cell/high = 10,
		/obj/item/grenade/chem_grenade/antifuel = 5,
		/obj/item/device/geiger = 5
	)
	contraband = list(
		/obj/item/cell/potato = 3
	)
	premium = list(
		/obj/item/storage/belt/utility = 3
	)
	restock_items = 1
	random_itemcount = 0
	light_color = COLOR_GOLD
	manufacturer = "hephaestus"

/obj/machinery/vending/tacticool //Tried not to go overboard with the amount of fun security has access to.
	name = "Tactical Express"
	desc = "Everything you need to ensure corporate bureaucracy makes it another day."
	icon_state = "tact"
	deny_time = 19
	req_access = list(ACCESS_SECURITY)
	vend_id = "tactical"
	products = list(
		/obj/item/storage/box/shotgunammo = 2,
		/obj/item/storage/box/shotgunshells = 2,
		/obj/item/ammo_magazine/c45m = 6,
		/obj/item/grenade/chem_grenade/teargas = 6,
		/obj/item/ammo_magazine/mc9mmt = 2,
		/obj/item/clothing/mask/gas/tactical = 4,
		/obj/item/handcuffs/ziptie = 3
	)
	contraband = list(
		/obj/item/grenade/flashbang/clusterbang = 1 //this can only go well.
	)
	premium = list(
		/obj/item/grenade/chem_grenade/gas = 2
	)
	random_itemcount = 0
	light_color = COLOR_BROWN
	manufacturer = "zavodskoi"

/obj/machinery/vending/tacticool/ert //Slightly more !FUN!
	name = "Nanosecurity Plus"
	desc = "For when shit really goes down; the private contractor's personal armory."
	req_access = list(ACCESS_SECURITY)
	vend_id = "ert"
	products = list(
		/obj/item/storage/box/shotgunammo = 2,
		/obj/item/storage/box/shotgunshells = 2,
		/obj/item/grenade/chem_grenade/gas = 6,
		/obj/item/clothing/mask/gas/tactical = 8,
		/obj/item/shield/riot/tact = 4,
		/obj/item/handcuffs/ziptie = 6,
		/obj/item/ammo_magazine/mc9mmt = 6,
		/obj/item/ammo_magazine/mc9mmt/rubber = 4,
		/obj/item/gun/projectile/automatic/x9 = 2,
		/obj/item/ammo_magazine/c45m/auto = 6,
		/obj/item/ammo_magazine/a556 = 12,
		/obj/item/ammo_magazine/a556/ap = 4,
		/obj/item/material/knife/tacknife = 4,
		/obj/item/device/firing_pin = 12
	)
	contraband = list(
		/obj/item/gun/bang/deagle = 1
	)
	premium = list(
		/obj/item/shield/riot/tact = 2
	)
	random_itemcount = 0
	manufacturer = "zavodskoi"

//This one's from bay12
/obj/machinery/vending/engineering
	name = "Robco Tool Maker"
	desc = "Everything you need for do-it-yourself station repair."
	icon_state = "engi"
	icon_vend = "engi-vend"
	deny_time = 6
	req_access = list(ACCESS_ENGINE_EQUIP)
	vend_id = "tools"
	products = list(
		/obj/item/clothing/head/hardhat = 4,
		/obj/item/storage/belt/utility = 5,
		/obj/item/clothing/glasses/safety/goggles = 4,
		/obj/item/clothing/gloves/yellow = 4,
		/obj/item/screwdriver = 8,
		/obj/item/crowbar = 8,
		/obj/item/wirecutters = 8,
		/obj/item/device/multitool = 8,
		/obj/item/wrench = 8,
		/obj/item/powerdrill = 4,
		/obj/item/device/t_scanner = 8,
		/obj/item/stack/cable_coil/random = 10,
		/obj/item/cell = 5,
		/obj/item/device/analyzer = 5,
		/obj/item/cell/high = 2,
		/obj/item/weldingtool = 8,
		/obj/item/clothing/head/welding = 8,
		/obj/item/light/tube = 10,
		/obj/item/clothing/head/hardhat/firefighter = 4,
		/obj/item/clothing/suit/fire = 4,
		/obj/item/stock_parts/scanning_module = 5,
		/obj/item/stock_parts/micro_laser = 5,
		/obj/item/stock_parts/matter_bin = 5,
		/obj/item/stock_parts/manipulator = 5,
		/obj/item/stock_parts/console_screen = 5,
		/obj/item/tape_roll = 5
	)

	restock_blocked_items = list(
		/obj/item/stack/cable_coil,
		/obj/item/weldingtool,
		/obj/item/light/tube
	)
	restock_items = 1
	light_color = COLOR_GOLD
	manufacturer = "hephaestus"

//This one's from bay12
/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_vend = "robotics-vend"
	deny_time = 14
	req_access = list(ACCESS_ROBOTICS)
	vend_id = "robo-tools"
	products = list(
		/obj/item/stack/cable_coil = 4,
		/obj/item/device/flash/synthetic = 4,
		/obj/item/cell/high = 12,
		/obj/item/device/assembly/prox_sensor = 3,
		/obj/item/device/assembly/signaler = 3,
		/obj/item/device/healthanalyzer = 3,
		/obj/item/surgery/scalpel = 2,
		/obj/item/surgery/circular_saw = 2,
		/obj/item/screwdriver = 5,
		/obj/item/crowbar = 5
	)
	contraband = list(
		/obj/item/device/flash = 2
	)
	premium = list(
		/obj/item/device/paicard = 2
	)
	//everything after the power cell had no amounts, I improvised.  -Sayu
	restock_blocked_items = list(
		/obj/item/stack/cable_coil,
		/obj/item/device/flash,
		/obj/item/light/tube
	)
	restock_items = 1
	random_itemcount = 0
	light_color = COLOR_BABY_BLUE
	manufacturer = "hephaestus"

/obj/machinery/vending/zora
	name = "Zo'ra Soda"
	desc = "An energy drink vendor provided by the Getmore Corporation in partnership with the brood of Ta'Akaix'Xakt'yagz'isk Zo'ra."
	icon_state = "zoda"
	icon_vend = "zoda-vend"
	product_slogans = "Safe for consumption by all species!;Made by hard-working bound drones!;The most refreshing energy drink around!;A product of two thousand years!"
	product_ads = "Tired? Try some Zo'ra Soda!;Thirsty? Why not Zo'ra Soda?;Bored? Have some Zo'ra Soda!;Zo'ra Soda. Drink up!;ZZZOOO'RRRAAA SSSOOODDDAAA!"
	vend_id = "zora"
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/cherry = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/phoron = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/klax = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/cthur = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/venomgrass = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/kois = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/drone = 5
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/hozm = 5
	)
	premium = list(
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/jelly = 3
	)
	prices = list(
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/cherry = 29,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/phoron = 29,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/klax = 29,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/cthur = 29,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/venomgrass = 29,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/kois = 29,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/drone = 29
	)
	idle_power_usage = 211
	temperature_setting = -1
	light_color = COLOR_CULT_REINFORCED

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
		/obj/item/book/manual/wiki/battlemonsters = 12,
		/obj/item/battle_monsters/wrapped = 100,
		/obj/item/battle_monsters/wrapped/pro = 75,
		/obj/item/battle_monsters/wrapped/species = 50,
		/obj/item/battle_monsters/wrapped/species/lizard = 50,
		/obj/item/battle_monsters/wrapped/species/cat = 50,
		/obj/item/battle_monsters/wrapped/species/ant = 50,
		/obj/item/battle_monsters/wrapped/rare = 100
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

/obj/machinery/vending/casino
	name = "grand romanovich vending machine"
	desc = "A vending machine commonly found in Crevus' casinos."
	icon_state = "casinovend"
	product_slogans = "The House always wins!;Spends your chips right here!;Let Go and Begin Again..."
	product_ads = "Finding it, though, that's not the hard part. It's letting go."
	vend_id = "casino"
	products = list(
		/obj/item/coin/casino = 50
	)
	contraband = list(
		/obj/item/ammo_magazine/boltaction = 2
	)
	premium = list(
		/obj/item/gun/projectile/shotgun/pump/rifle/blank = 3,
		/obj/item/ammo_magazine/boltaction/blank = 10,
		/obj/item/storage/box/fancy/cigarettes/dpra = 5,
		/obj/item/storage/chewables/tobacco/bad = 5,
		/obj/item/reagent_containers/food/drinks/bottle/messa_mead = 5,
		/obj/item/reagent_containers/food/drinks/bottle/victorygin = 5,
		/obj/item/reagent_containers/food/drinks/bottle/pwine = 5,
		/obj/item/reagent_containers/food/snacks/hardbread = 5,
		/obj/item/reagent_containers/food/drinks/cans/adhomai_milk = 5,
		/obj/item/reagent_containers/food/snacks/adhomian_can = 5,
		/obj/item/reagent_containers/food/snacks/clam = 5,
		/obj/item/reagent_containers/food/snacks/tajaran_bread = 5,
		/obj/item/toy/plushie/farwa = 2,
		/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube = 2,
		/obj/item/razor = 2,
		/obj/item/toy/balloon/syndicate = 2,
		/obj/item/grenade/fake = 2,
		/obj/item/eightball/haunted = 5,
		/obj/item/spirit_board = 5,
		/obj/item/device/flashlight/maglight = 5,
		/obj/item/contraband/poster = 5,
		/obj/item/spacecash/ewallet/lotto = 15,
		/obj/item/device/laser_pointer = 5,
		/obj/item/beach_ball = 1,
		/obj/item/material/knife/butterfly/switchblade = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/stimpack = 2,
		/obj/item/clothing/under/tajaran/summer = 2,
		/obj/item/clothing/under/pants/tajaran = 2,
		/obj/item/clothing/under/dress/tajaran =2,
		/obj/item/clothing/under/dress/tajaran/blue = 2,
		/obj/item/clothing/under/dress/tajaran/green = 2,
		/obj/item/clothing/under/dress/tajaran/red = 2,
		/obj/item/clothing/head/tajaran/circlet = 2,
		/obj/item/clothing/head/tajaran/circlet/silver = 2,
		/obj/item/gun/energy/lasertag/red = 2,
		/obj/item/clothing/suit/armor/riot/laser_tag = 2,
		/obj/item/gun/energy/lasertag/blue = 2,
		/obj/item/clothing/suit/armor/riot/laser_tag/blue = 2
		)
	prices = list(
		/obj/item/coin/casino = 500
	)

	restock_items = FALSE
	random_itemcount = FALSE

/obj/machinery/vending/mredispenser
	name = "\improper MRE dispenser"
	desc = "A vending machine filled with MRE's."
	icon_state = "mrevend"
	icon_vend = "mrevend-vend"
	product_slogans = ";FOREIGN LEGION TESTED!, FOREIGN LEGION RECOMMENDED!, FOREIGN LEGION APPROVED!;YOU ARE NOT ALLOWED A JELLY DOUGHNUT!;YOU DON'T WANT TO DIE HUNGRY, SOLDIER!"
	product_ads = "Everything the body needs!;Now trans-fat free!;Vegan options are available.;Safe for all known species!"
	products = list(
		/obj/item/storage/box/fancy/mre = 2,
		/obj/item/storage/box/fancy/mre/menu2 = 2,
		/obj/item/storage/box/fancy/mre/menu3 = 2,
		/obj/item/storage/box/fancy/mre/menu4 = 2,
		/obj/item/storage/box/fancy/mre/menu5 = 2,
		/obj/item/storage/box/fancy/mre/menu6 = 2,
		/obj/item/storage/box/fancy/mre/menu7 = 2,
		/obj/item/storage/box/fancy/mre/menu8 = 2,
		/obj/item/storage/box/fancy/mre/menu9 = 10,
		/obj/item/storage/box/fancy/mre/menu10 = 10
	)
	prices = list(
		/obj/item/storage/box/fancy/mre = 50,
		/obj/item/storage/box/fancy/mre/menu2 = 50,
		/obj/item/storage/box/fancy/mre/menu3 = 50,
		/obj/item/storage/box/fancy/mre/menu4 = 50,
		/obj/item/storage/box/fancy/mre/menu5 = 50,
		/obj/item/storage/box/fancy/mre/menu6 = 50,
		/obj/item/storage/box/fancy/mre/menu7 = 50,
		/obj/item/storage/box/fancy/mre/menu8 = 50,
		/obj/item/storage/box/fancy/mre/menu9 = 50,
		/obj/item/storage/box/fancy/mre/menu10 = 50
	)
	contraband = list(
		/obj/item/storage/box/fancy/mre/menu11 = 5, // memes.
		/obj/item/reagent_containers/food/snacks/liquidfood = 5
	)
	vend_delay = 15
	idle_power_usage = 211 // Cold MREs...

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
		/obj/item/storage/overloader/classic = 200,
		/obj/item/storage/overloader/tranquil = 200,
		/obj/item/storage/overloader/rainbow = 200,
		/obj/item/storage/overloader/screenshaker = 200
	)
	contraband = list(
		/obj/item/storage/overloader/rainbow = 2
	)
	premium = list(
		/obj/item/storage/overloader/jitterbug = 5
	)
	light_color = LIGHT_COLOR_CYAN

/obj/machinery/vending/minimart
	name = "minimart refrigerator"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	//product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	//product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "minimart"
	icon_vend = "minimart"
	vend_id = "snacks"
	density = 0
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 10,
		/obj/item/reagent_containers/food/drinks/cans/diet_cola = 10,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 10,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 10,
		/obj/item/reagent_containers/food/drinks/waterbottle = 10,
		/obj/item/reagent_containers/food/drinks/cans/dyn = 5,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 10,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 10,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 10,
		/obj/item/reagent_containers/food/drinks/cans/peach_soda = 10,
		/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 5,
		/obj/item/reagent_containers/food/drinks/carton/small/milk = 10,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/choco = 10,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/strawberry = 10,
		/obj/item/reagent_containers/food/drinks/cans/melon_soda = 10
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/cans/thirteenloko = 5,
		/obj/item/reagent_containers/food/drinks/cans/koispunch = 3
	)
	premium = list(
		/obj/item/reagent_containers/food/drinks/bottle/cola = 2,
		/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind = 2,
		/obj/item/reagent_containers/food/drinks/bottle/space_up = 2
	)
	prices = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 15,
		/obj/item/reagent_containers/food/drinks/cans/diet_cola = 15,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 11,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 16,
		/obj/item/reagent_containers/food/drinks/cans/root_beer = 13,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 15,
		/obj/item/reagent_containers/food/drinks/waterbottle = 12,
		/obj/item/reagent_containers/food/drinks/cans/dyn = 18,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 15,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 13,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 16,
		/obj/item/reagent_containers/food/drinks/cans/peach_soda = 16,
		/obj/item/reagent_containers/food/drinks/cans/koispunch = 50,
		/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 5,
		/obj/item/reagent_containers/food/drinks/cans/hrozamal_soda = 35,
		/obj/item/reagent_containers/food/drinks/carton/small/milk = 18,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/choco = 18,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/strawberry = 18,
		/obj/item/reagent_containers/food/drinks/cans/melon_soda = 16
	)
	light_color = COLOR_BABY_BLUE

/obj/machinery/vending/minimart/alcohol
	name = "minimart alcohol selection"
	products = list(
		/obj/item/reagent_containers/food/drinks/bottle/makgeolli = 5,
		/obj/item/reagent_containers/food/drinks/bottle/soju = 15,
		/obj/item/reagent_containers/food/drinks/bottle/soju/shochu = 5,
		/obj/item/reagent_containers/food/drinks/bottle/sake = 5,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice = 5,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice/shimauma = 5,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice/moonlabor = 5,
		/obj/item/reagent_containers/food/drinks/cans/beer = 10,
		/obj/item/reagent_containers/food/drinks/bottle/small/beer = 5,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey = 5,
		/obj/item/reagent_containers/food/drinks/bottle/wine = 5,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 3
	)
	prices = list(
		/obj/item/reagent_containers/food/drinks/bottle/makgeolli = 30,
		/obj/item/reagent_containers/food/drinks/bottle/soju = 15,
		/obj/item/reagent_containers/food/drinks/bottle/soju/shochu = 30,
		/obj/item/reagent_containers/food/drinks/bottle/sake = 40,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice = 20,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice/shimauma = 20,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice/moonlabor = 20,
		/obj/item/reagent_containers/food/drinks/cans/beer = 20,
		/obj/item/reagent_containers/food/drinks/bottle/small/beer = 20,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey = 30,
		/obj/item/reagent_containers/food/drinks/bottle/wine = 50,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 100
	)
