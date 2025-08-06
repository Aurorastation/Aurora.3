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
	name = "Omni-Restocker"
	desc = "The mother of all vendors, from which vending itself comes!"
	icon_state = "engivend"
	icon_vend = "engivend-vend"
	vend_id = "admin"
	req_access = list(ACCESS_JANITOR)
	products = list(
		/obj/item/device/vending_refill/booze = 2,
		/obj/item/device/vending_refill/tools = 2,
		/obj/item/device/vending_refill/coffee = 2,
		/obj/item/device/vending_refill/snack = 2,
		/obj/item/device/vending_refill/cola = 2,
		/obj/item/device/vending_refill/zora = 2,
		/obj/item/device/vending_refill/frontiervend = 2,
		/obj/item/device/vending_refill/smokes = 2,
		/obj/item/device/vending_refill/meds = 2,
		/obj/item/device/vending_refill/robust = 2,
		/obj/item/device/vending_refill/hydro = 2,
		/obj/item/device/vending_refill/cutlery = 2,
		/obj/item/device/vending_refill/robo = 2,
		/obj/item/device/vending_refill/battlemonsters = 2,
		/obj/item/device/vending_refill/encryption = 2
	)
	random_itemcount = 0
	light_color = COLOR_GOLD

/obj/machinery/vending/vendors/low_supply
	products = list(
		/obj/item/device/vending_refill/tools = 1,
		/obj/item/device/vending_refill/coffee = 1,
		/obj/item/device/vending_refill/meds = 1,
		/obj/item/device/vending_refill/robust = 1,
		/obj/item/device/vending_refill/hydro = 1,
		/obj/item/device/vending_refill/cutlery = 1,
		/obj/item/device/vending_refill/robo = 1,
		/obj/item/device/vending_refill/battlemonsters = 1,
		/obj/item/device/vending_refill/encryption = 1
	)

/obj/machinery/vending/boozeomat
	name = "Booze-O-Mat"
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	icon_state = "boozeomat"        //////////////18 drink entities below, plus the glasses, in case someone wants to edit the number of bottles
	icon_vend = "boozeomat-vend"
	light_mask = "boozeomat-lightmask"
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
		/obj/item/reagent_containers/food/drinks/bottle/skrellwineylpha = 2,
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
		/obj/item/reagent_containers/food/drinks/bottle/vodka/mushroom = 1,
		/obj/item/reagent_containers/food/drinks/bottle/pulque = 5,
		/obj/item/reagent_containers/food/drinks/bottle/fireball = 2,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey = 5,
		/obj/item/reagent_containers/food/drinks/bottle/victorygin = 2,
		/obj/item/reagent_containers/food/drinks/bottle/makgeolli = 2,
		/obj/item/reagent_containers/food/drinks/bottle/soju = 2,
		/obj/item/reagent_containers/food/drinks/bottle/sake = 1,
		/obj/item/reagent_containers/food/drinks/bottle/cremewhite = 4,
		/obj/item/reagent_containers/food/drinks/bottle/mintsyrup = 5,
		/obj/item/reagent_containers/food/drinks/bottle/sugartree_liquor = 2,
		/obj/item/reagent_containers/food/drinks/bottle/chartreuseyellow = 5,
		/obj/item/reagent_containers/food/drinks/bottle/messa_mead = 2,
		/obj/item/reagent_containers/food/drinks/bottle/dominian_wine = 1,
		/obj/item/reagent_containers/food/drinks/bottle/assunzione_wine = 1,
		/obj/item/reagent_containers/food/drinks/bottle/algae_wine = 1,
		/obj/item/reagent_containers/food/drinks/bottle/kvass = 1,
		/obj/item/reagent_containers/food/drinks/bottle/tarasun = 1,
		/obj/item/reagent_containers/food/drinks/bottle/valokki_wine = 1,
		/obj/item/reagent_containers/food/drinks/bottle/twentytwoseventyfive = 1,
		/obj/item/reagent_containers/food/drinks/bottle/saintjacques = 1,
		/obj/item/reagent_containers/food/drinks/bottle/hooch = 1,
		/obj/item/reagent_containers/food/drinks/bottle/nemiik = 1,
		/obj/item/reagent_containers/food/drinks/bottle/ogogoro = 2,
		/obj/item/reagent_containers/food/drinks/carton/applejuice = 2,
		/obj/item/reagent_containers/food/drinks/carton/cream = 4,
		/obj/item/reagent_containers/food/drinks/carton/dynjuice = 2,
		/obj/item/reagent_containers/food/drinks/carton/limejuice = 4,
		/obj/item/reagent_containers/food/drinks/carton/lemonjuice = 4,
		/obj/item/reagent_containers/food/drinks/carton/orangejuice = 4,
		/obj/item/reagent_containers/food/drinks/carton/tomatojuice = 2,
		/obj/item/reagent_containers/food/drinks/carton/cranberryjuice = 2,
		/obj/item/reagent_containers/food/drinks/carton/watermelonjuice = 2,
		/obj/item/reagent_containers/food/drinks/carton/bananajuice = 2,
		/obj/item/reagent_containers/food/drinks/carton/fatshouters = 1,
		/obj/item/reagent_containers/food/drinks/carton/mutthir = 1,
		/obj/item/reagent_containers/food/drinks/boba = 2,
		/obj/item/reagent_containers/food/drinks/ice = 9,
		/obj/item/storage/box/fancy/vkrexi_swollen_organ = 1
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
	restock_items = TRUE

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
		/obj/item/reagent_containers/food/drinks/bottle/ogogoro = 1,
		/obj/item/reagent_containers/food/drinks/bottle/small/beer = 2,
		/obj/item/reagent_containers/food/drinks/bottle = 6,
		/obj/random/junk = 7,
		/obj/item/material/shard = 3,
		/obj/item/broken_bottle = 5)
	random_itemcount = 1
	req_access = list()
	restock_items = TRUE
	use_power = 0

/obj/machinery/vending/boozeomat/low_supply
	// just badly stocked
	products = list(
		/obj/item/reagent_containers/food/drinks/bottle/applejack = 1,
		/obj/item/reagent_containers/food/drinks/bottle/bitters = 2,
		/obj/item/reagent_containers/food/drinks/bottle/boukha = 1,
		/obj/item/reagent_containers/food/drinks/bottle/grenadine = 2,
		/obj/item/reagent_containers/food/drinks/bottle/tequila = 1,
		/obj/item/reagent_containers/food/drinks/bottle/rum = 1,
		/obj/item/reagent_containers/food/drinks/bottle/fernet = 1,
		/obj/item/reagent_containers/food/drinks/bottle/drambuie = 2,
		/obj/item/reagent_containers/food/drinks/bottle/melonliquor = 1,
		/obj/item/reagent_containers/food/drinks/bottle/chartreusegreen = 2,
		/obj/item/reagent_containers/food/drinks/bottle/absinthe = 1,
		/obj/item/reagent_containers/food/drinks/bottle/kahlua = 1,
		/obj/item/reagent_containers/food/drinks/bottle/triplesec = 1,
		/obj/item/reagent_containers/food/drinks/bottle/sarezhiwine = 1,
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 2,
		/obj/item/reagent_containers/food/drinks/bottle/pulque = 1,
		/obj/item/reagent_containers/food/drinks/bottle/fireball = 2,
		/obj/item/reagent_containers/food/drinks/bottle/cremewhite = 1,
		/obj/item/reagent_containers/food/drinks/bottle/mintsyrup = 2,
		/obj/item/reagent_containers/food/drinks/bottle/chartreuseyellow = 1,
		/obj/item/reagent_containers/food/drinks/bottle/messa_mead = 2,
		/obj/item/reagent_containers/food/drinks/bottle/kvass = 1,
		/obj/item/reagent_containers/food/drinks/bottle/hooch = 4,
		/obj/item/reagent_containers/food/drinks/bottle/nemiik = 1,
		/obj/item/reagent_containers/food/drinks/carton/applejuice = 1,
		/obj/item/reagent_containers/food/drinks/carton/cream = 4,
		/obj/item/reagent_containers/food/drinks/carton/dynjuice = 1,
		/obj/item/reagent_containers/food/drinks/carton/tomatojuice = 1,
		/obj/item/reagent_containers/food/drinks/carton/cranberryjuice = 1,
		/obj/item/reagent_containers/food/drinks/ice = 9
	)

/obj/machinery/vending/assist
	vend_id = "tools"
	icon_state = "generic"
	icon_vend = "generic-vend"
	light_mask = "generic-lightmask"
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
	restock_items = TRUE
	light_color = COLOR_GUNMETAL

/obj/machinery/vending/assist/synd
	name = "Parts vendor"
	desc = "Just a normal vending machine - nothing to see here."
	icon_state = "generic"
	icon_vend = "generic-vend"
	light_mask = "generic-lightmask"
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
	icon_screen = "coffee-screen"
	light_mask = "coffee-lightmask"
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
		/obj/item/reagent_containers/food/drinks/coffee = 2,
		/obj/item/reagent_containers/food/drinks/tea = 2,
		/obj/item/reagent_containers/food/drinks/greentea = 2.25,
		/obj/item/reagent_containers/food/drinks/chaitea = 2.50,
		/obj/item/reagent_containers/food/drinks/hotcider = 2.50,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 2,
		/obj/item/reagent_containers/food/snacks/donut/normal = 2.50,
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

/obj/machinery/vending/coffee/low_supply
	products = list(
		/obj/item/reagent_containers/food/drinks/coffee = 2,
		/obj/item/reagent_containers/food/drinks/tea = 3,
		/obj/item/reagent_containers/food/drinks/greentea = 1,
		/obj/item/reagent_containers/food/drinks/chaitea = 1,
		/obj/item/reagent_containers/food/drinks/hotcider = 1,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 1,
		/obj/item/reagent_containers/food/snacks/donut/normal = 2
	)

/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
	icon_vend = "snack-vend"
	light_mask = "snack-lightmask"
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
		/obj/item/reagent_containers/food/snacks/candy = 1.50,
		/obj/item/reagent_containers/food/drinks/dry_ramen = 2.00,
		/obj/item/reagent_containers/food/snacks/chips = 2.50,
		/obj/item/reagent_containers/food/snacks/sosjerky = 3.50,
		/obj/item/reagent_containers/food/snacks/no_raisin = 2.00,
		/obj/item/reagent_containers/food/snacks/spacetwinkie = 2.00,
		/obj/item/reagent_containers/food/snacks/cheesiehonkers = 2.50,
		/obj/item/reagent_containers/food/snacks/tastybread = 3.50,
		/obj/item/storage/box/pineapple = 5.00,
		/obj/item/reagent_containers/food/snacks/chocolatebar = 2.00,
		/obj/item/reagent_containers/food/snacks/whitechocolate/wrapped = 3.00,
		/obj/item/storage/box/fancy/cookiesnack = 4.00,
		/obj/item/storage/box/fancy/gum = 2.50,
		/obj/item/storage/box/fancy/vkrexitaffy = 3.50,
		/obj/item/clothing/mask/chewable/candy/lolli = 1.00,
		/obj/item/storage/box/fancy/admints = 2.00,
		/obj/item/reagent_containers/food/snacks/skrellsnacks = 1.50,
		/obj/item/reagent_containers/food/snacks/meatsnack = 3.00,
		/obj/item/reagent_containers/food/snacks/maps = 3.25,
		/obj/item/reagent_containers/food/snacks/nathisnack = 2.00,
		/obj/item/reagent_containers/food/snacks/koisbar_clean = 4.25,
		/obj/item/reagent_containers/food/snacks/candy/koko = 3.00,
		/obj/item/reagent_containers/food/snacks/tuna = 2.50,
		/obj/item/reagent_containers/food/snacks/adhomian_can = 2.00,
		/obj/item/reagent_containers/food/snacks/ricetub = 4.50,
		/obj/item/reagent_containers/food/snacks/riceball = 3.00,
		/obj/item/reagent_containers/food/snacks/seaweed = 2.50,
		/obj/item/reagent_containers/food/drinks/jyalra = 1.50,
		/obj/item/reagent_containers/food/drinks/jyalra/cheese = 1.75,
		/obj/item/reagent_containers/food/drinks/jyalra/apple = 1.75,
		/obj/item/reagent_containers/food/drinks/jyalra/cherry = 1.75,
		/obj/item/reagent_containers/food/snacks/syndicake = 3.50,
		/obj/item/reagent_containers/food/snacks/koisbar = 12.00,
	)
	light_color = COLOR_BABY_BLUE
	manufacturer = "nanotrasen"

/obj/machinery/vending/snack/low_supply
	products = list(
		/obj/item/reagent_containers/food/drinks/dry_ramen = 4,
		/obj/item/reagent_containers/food/snacks/chips = 1,
		/obj/item/reagent_containers/food/snacks/sosjerky = 2,
		/obj/item/reagent_containers/food/snacks/no_raisin = 4,
		/obj/item/storage/box/fancy/vkrexitaffy = 3,
		/obj/item/reagent_containers/food/snacks/skrellsnacks = 1,
		/obj/item/reagent_containers/food/snacks/maps = 1,
		/obj/item/reagent_containers/food/snacks/koisbar_clean = 1,
		/obj/item/reagent_containers/food/snacks/adhomian_can = 1,
		/obj/item/reagent_containers/food/drinks/jyalra = 1
	)

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
	icon_deny = "cola_machine-deny"
	icon_screen = "cola_machine-screen"
	light_mask = "cola_machine-lightmask"
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
		/obj/item/reagent_containers/food/drinks/cans/melon_soda = 10,
		/obj/item/reagent_containers/food/drinks/zobo = 10
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
		/obj/item/reagent_containers/food/drinks/cans/cola = 1.50,
		/obj/item/reagent_containers/food/drinks/cans/diet_cola = 1.50,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 1.50,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 1.50,
		/obj/item/reagent_containers/food/drinks/cans/root_beer = 1.50,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 1.50,
		/obj/item/reagent_containers/food/drinks/waterbottle = 1.25,
		/obj/item/reagent_containers/food/drinks/cans/dyn = 1.80,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 1.50,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 1.40,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 1.75,
		/obj/item/reagent_containers/food/drinks/cans/peach_soda = 1.75,
		/obj/item/reagent_containers/food/drinks/cans/koispunch = 5.00,
		/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 2.25,
		/obj/item/reagent_containers/food/drinks/cans/hrozamal_soda = 3.00,
		/obj/item/reagent_containers/food/drinks/carton/small/milk = 1.80,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/choco = 1.80,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/strawberry = 1.80,
		/obj/item/reagent_containers/food/drinks/cans/melon_soda = 1.75,
		/obj/item/reagent_containers/food/drinks/zobo = 1.75,
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vending_sound = 'sound/machines/vending/vending_cans.ogg'
	temperature_setting = -1
	light_color = COLOR_GUNMETAL

/obj/machinery/vending/cola/low_supply
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/diet_cola = 1,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 2,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 1,
		/obj/item/reagent_containers/food/drinks/cans/root_beer = 2,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 1,
		/obj/item/reagent_containers/food/drinks/waterbottle = 4,
		/obj/item/reagent_containers/food/drinks/cans/dyn = 1,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 2,
		/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 8,
		/obj/item/reagent_containers/food/drinks/cans/hrozamal_soda = 2
	)

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
		/obj/item/storage/chewables/tobacco/koko = 2,
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
		/obj/item/storage/box/fancy/cigarettes/rugged = 8.00,
		/obj/item/storage/box/fancy/cigarettes = 9.00,
		/obj/item/storage/box/fancy/cigarettes/dromedaryco = 9.75,
		/obj/item/storage/box/fancy/cigarettes/nicotine = 10.50,
		/obj/item/storage/box/fancy/cigarettes/pra = 9.75,
		/obj/item/storage/box/fancy/cigarettes/dpra = 10.25,
		/obj/item/storage/box/fancy/cigarettes/nka = 9.25,
		/obj/item/storage/box/fancy/cigarettes/federation = 11.50,
		/obj/item/storage/box/fancy/cigarettes/dyn = 10.25,
		/obj/item/storage/box/fancy/cigarettes/oracle = 10.25,
		/obj/item/storage/chewables/rollable = 7.50,
		/obj/item/storage/chewables/rollable/unathi = 7.75,
		/obj/item/storage/chewables/rollable/fine = 8.00,
		/obj/item/storage/chewables/rollable/nico = 10.00,
		/obj/item/storage/chewables/rollable/oracle = 7.75,
		/obj/item/storage/chewables/rollable/vedamor = 8.50,
		/obj/item/storage/chewables/tobacco/bad = 6.50,
		/obj/item/storage/chewables/tobacco = 9.00,
		/obj/item/storage/chewables/tobacco/fine = 10.00,
		/obj/item/storage/chewables/tobacco/federation = 10.25,
		/obj/item/storage/chewables/tobacco/dyn = 9.75,
		/obj/item/storage/box/fancy/chewables/tobacco/nico = 10.75,
		/obj/item/storage/chewables/oracle = 11.50,
		/obj/item/storage/chewables/tobacco/koko = 11.00,
		/obj/item/storage/box/fancy/matches = 1.50,
		/obj/item/flame/lighter/random = 1.50,
		/obj/item/storage/cigfilters = 1.25,
		/obj/item/storage/box/fancy/cigpaper = 2.50,
		/obj/item/storage/box/fancy/cigpaper/fine = 3.50,
		/obj/item/spacecash/ewallet/lotto = 5.00,
		/obj/item/clothing/mask/smokable/ecig/simple = 25.00,
		/obj/item/clothing/mask/smokable/ecig/util = 35.00,
		/obj/item/reagent_containers/ecig_cartridge/med_nicotine = 4.50,
		/obj/item/reagent_containers/ecig_cartridge/high_nicotine = 5.25,
		/obj/item/reagent_containers/ecig_cartridge/orange = 4.25,
		/obj/item/reagent_containers/ecig_cartridge/watermelon = 4.00,
		/obj/item/reagent_containers/ecig_cartridge/grape = 4.40,
	)
	light_color = COLOR_BLUE_GRAY

/obj/machinery/vending/cigarette/low_supply
	products = list(
		/obj/item/storage/box/fancy/cigarettes/rugged = 4,
		/obj/item/storage/box/fancy/cigarettes = 2,
		/obj/item/storage/box/fancy/cigarettes/dpra = 2,
		/obj/item/storage/box/fancy/cigarettes/federation = 1,
		/obj/item/storage/chewables/rollable = 2,
		/obj/item/storage/chewables/rollable/unathi = 1,
		/obj/item/storage/chewables/tobacco/bad = 2,
		/obj/item/storage/chewables/tobacco/koko = 1,
		/obj/item/storage/cigfilters = 1,
		/obj/item/storage/box/fancy/cigpaper = 4,
		/obj/item/storage/box/fancy/matches = 4,
		/obj/item/spacecash/ewallet/lotto = 9,
		/obj/item/clothing/mask/smokable/ecig/util = 1,
		/obj/item/clothing/mask/smokable/ecig/simple = 1,
		/obj/item/reagent_containers/ecig_cartridge/med_nicotine = 2,
		/obj/item/reagent_containers/ecig_cartridge/grape = 1
	)

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

/obj/machinery/vending/medical/low_supply
	products = list(
		/obj/item/reagent_containers/glass/bottle/inaprovaline = 1,
		/obj/item/reagent_containers/glass/bottle/perconol = 1,
		/obj/item/reagent_containers/glass/bottle/toxin = 1,
		/obj/item/reagent_containers/glass/bottle/thetamycin = 1,
		/obj/item/reagent_containers/syringe = 8,
		/obj/item/device/healthanalyzer = 1,
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/stack/medical/splint = 1,
		/obj/item/reagent_containers/pill/antitox = 2,
		/obj/item/reagent_containers/pill/cetahydramine = 1,
		/obj/item/reagent_containers/pill/perconol = 1,
		/obj/item/reagent_containers/glass/beaker/medcup = 4,
		/obj/item/storage/pill_bottle = 2,
		/obj/item/reagent_containers/spray/sterilizine = 1
	)

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
	restock_items = TRUE
	random_itemcount = 0
	light_color = COLOR_BLUE_GRAY
	manufacturer = "scc"


/obj/machinery/vending/wallmed1
	name = "\improper NanoMed"
	desc = "A wall-mounted version of the NanoMed."
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?"
	icon_state = "wallmed"
	req_access = list(ACCESS_MEDICAL)
	density = FALSE //It is wall-mounted, and thus, not dense. --Superxpdude
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
	random_itemcount = FALSE
	temperature_setting = -1
	light_color = LIGHT_COLOR_GREEN
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	manufacturer = "zenghu"

/obj/machinery/vending/wallmed1/low_supply
	products = list(
		/obj/item/stack/medical/bruise_pack = 1,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/reagent_containers/pill/perconol = 2,
		/obj/item/storage/box/fancy/med_pouch/oxyloss = 1,
		/obj/item/storage/box/fancy/med_pouch/toxin = 1
	)

/obj/machinery/vending/wallmed2
	name = "\improper NanoMed Mini"
	desc = "A wall-mounted version of the NanoMed, containing only vital first aid equipment."
	icon_state = "wallmed"
	req_access = list(ACCESS_MEDICAL)
	density = FALSE //It is wall-mounted, and thus, not dense. --Superxpdude
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
	random_itemcount = FALSE
	temperature_setting = -1
	light_color = LIGHT_COLOR_GREEN
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	manufacturer = "zenghu"

/obj/machinery/vending/wallmed2/low_supply
	products = list(
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline = 1,
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/storage/box/fancy/med_pouch/radiation = 1
	)

/obj/machinery/vending/wallpharm
	name = "\improper NanoPharm Mini"
	desc = "A wall-mounted pharmaceuticals vending machine packed with over-the-counter bottles. For the sick salaried worker in you."
	icon_state = "wallpharm"
	density = FALSE
	products = list(
		/obj/item/stack/medical/bruise_pack = 5,
		/obj/item/stack/medical/ointment = 5,
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline = 2,
		/obj/item/storage/pill_bottle/antidexafen = 4,
		/obj/item/storage/pill_bottle/dexalin = 4,
		/obj/item/storage/pill_bottle/dylovene = 4,
		/obj/item/storage/pill_bottle/vitamin = 5,
		/obj/item/storage/pill_bottle/cetahydramine  = 4,
		/obj/item/storage/pill_bottle/caffeine = 3,
		/obj/item/storage/pill_bottle/nicotine  = 4,
		/obj/item/storage/pill_bottle/rmt = 2
	)
	prices = list(
		/obj/item/storage/pill_bottle/antidexafen = 7.00,
		/obj/item/storage/pill_bottle/dexalin = 25.00,
		/obj/item/storage/pill_bottle/dylovene = 12.00,
		/obj/item/storage/pill_bottle/vitamin = 8.00,
		/obj/item/storage/pill_bottle/cetahydramine = 10.00,
		/obj/item/storage/pill_bottle/caffeine = 9.00,
		/obj/item/storage/pill_bottle/nicotine = 15.00,
		/obj/item/storage/pill_bottle/rmt = 55.00,
	)
	contraband = list(
		/obj/item/reagent_containers/pill/tox = 3,
		/obj/item/storage/pill_bottle/perconol = 3
	)
	random_itemcount = FALSE
	temperature_setting = -1
	light_color = COLOR_GOLD
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED
	manufacturer = "nanotrasen"

/obj/machinery/vending/wallpharm/low_supply
	products = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/storage/pill_bottle/antidexafen = 1,
		/obj/item/storage/pill_bottle/dexalin = 1,
		/obj/item/storage/pill_bottle/dylovene = 2,
		/obj/item/storage/pill_bottle/vitamin = 2,
		/obj/item/storage/pill_bottle/cetahydramine  = 1,
		/obj/item/storage/pill_bottle/rmt = 1
	)

/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor."
	product_ads = "Crack capitalist skulls!;Beat some heads in!;Don't forget - harm is good!;Your weapons are right here.;Handcuffs!;Freeze, scumbag!;Don't tase me bro!;Tase them, bro.;Why not have a donut?"
	icon_state = "sec"
	icon_vend = "sec-vend"
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
	restock_items = TRUE
	random_itemcount = 0
	light_color = COLOR_BABY_BLUE
	manufacturer = "zavodskoi"

/obj/machinery/vending/security/low_supply
	products = list(
		/obj/item/handcuffs = 2,
		/obj/item/grenade/chem_grenade/teargas = 1,
		/obj/item/device/flash = 2,
		/obj/item/reagent_containers/spray/pepper = 2,
		/obj/item/storage/box/evidence = 4,
		/obj/item/device/holowarrant = 3,
		/obj/item/device/flashlight/maglight = 2,
		/obj/item/device/hailer = 1
	)

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
		/obj/item/reagent_containers/spray/plantbgone = 35.00,
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
		/obj/item/seeds/ylpha = 16.00,
	)
	restock_items = TRUE
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
	light_mask = "dinnerware-lightmask"
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
		/obj/item/storage/toolbox/lunchbox/idris = 6,
		/obj/item/reagent_containers/glass/rag = 8,
		/obj/item/evidencebag/plasticbag = 20,
		/obj/item/tray = 12,
		/obj/item/tray/tea = 2,
		/obj/item/tray/plate = 10,
		/obj/item/reagent_containers/bowl = 10,
		/obj/item/reagent_containers/bowl/plate = 10,
		/obj/item/reagent_containers/bowl/gravy_boat = 8,
		/obj/item/reagent_containers/glass/bottle/syrup = 4,
	)
	contraband = list(
		/obj/item/storage/toolbox/lunchbox/syndicate = 2
	)
	premium = list(
		/obj/item/storage/toolbox/lunchbox/scc/filled = 2,
	)
	restock_items = TRUE
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

/obj/machinery/vending/dinnerware/metal
	name = "utensil vendor"
	desc = "An upscale kitchen and restaurant utensil vendor."
	products = list(
		/obj/item/material/kitchen/utensil/fork = 12,
		/obj/item/material/kitchen/utensil/spoon = 12,
		/obj/item/material/kitchen/utensil/knife = 12,
		/obj/item/material/kitchen/utensil/fork/chopsticks = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 3,
		/obj/item/reagent_containers/glass/beaker/pitcher = 3,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 6,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 6,
	)

/obj/machinery/vending/dinnerware/bar
	name = "glasses vendor"
	desc = "A bar vendor for dispensing various glasses and cups."
	products = list(
		/obj/item/reagent_containers/glass/beaker/pitcher = 8,
		/obj/item/reagent_containers/food/drinks/drinkingglass = 40,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/carafe = 3,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup = 6,
		/obj/item/reagent_containers/food/drinks/takeaway_cup_idris = 12,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/pint = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/square = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/mug = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shake = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/goblet = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/wine = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/flute = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cognac = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/rocks = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/cocktail = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/shot = 6,
		/obj/item/reagent_containers/food/drinks/drinkingglass/newglass/coffeecup/teacup = 6,
		/obj/item/reagent_containers/food/drinks/flask/barflask = 2,
		/obj/item/reagent_containers/food/drinks/flask/vacuumflask = 2,
		/obj/item/material/kitchen/utensil/fork = 6,
		/obj/item/material/kitchen/utensil/knife = 6,
		/obj/item/material/kitchen/utensil/spoon = 6,
		/obj/item/tray = 12,
		/obj/item/tray/tea = 2,
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
	restock_items = TRUE
	light_color = COLOR_GOLD
	manufacturer = "hephaestus"

/obj/machinery/vending/tool/low_supply
	products = list(
		/obj/item/stack/cable_coil/random = 4,
		/obj/item/crowbar = 3,
		/obj/item/weldingtool = 1,
		/obj/item/wirecutters = 2,
		/obj/item/wrench = 2,
		/obj/item/device/analyzer = 3,
		/obj/item/device/t_scanner = 2,
		/obj/item/screwdriver = 3,
		/obj/item/tape_roll = 1,
		/obj/item/hammer = 1
	)

/obj/machinery/vending/engivend
	name = "Engi-Vend"
	desc = "Spare tool vending. What? Did you expect some witty description?"
	icon_state = "engivend"
	icon_vend = "engivend-vend"
	req_access = list(ACCESS_ENGINE)
	vend_id = "tools"
	products = list(
		/obj/item/device/multitool = 4,
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
	restock_items = TRUE
	random_itemcount = 0
	light_color = COLOR_GOLD
	manufacturer = "hephaestus"

/obj/machinery/vending/engivend/low_supply
	products = list(
		/obj/item/device/multitool = 2,
		/obj/item/taperoll/engineering = 2,
		/obj/item/clothing/glasses/safety/goggles = 3,
		/obj/item/airlock_electronics = 12,
		/obj/item/module/power_control = 7,
		/obj/item/airalarm_electronics = 7,
		/obj/item/firealarm_electronics = 8,
		/obj/item/cell/high = 4,
		/obj/item/grenade/chem_grenade/antifuel = 3,
		/obj/item/device/geiger = 1
	)

/obj/machinery/vending/tacticool //Tried not to go overboard with the amount of fun security has access to.
	name = "Tactical Express"
	desc = "Everything you need to ensure corporate bureaucracy makes it another day."
	icon_state = "tact"
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
	restock_items = TRUE
	light_color = COLOR_GOLD
	manufacturer = "hephaestus"

//This one's from bay12
/obj/machinery/vending/robotics
	name = "Robotech Deluxe"
	desc = "All the tools you need to create your own robot army."
	icon_state = "robotics"
	icon_vend = "robotics-vend"
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
	restock_items = TRUE
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
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/drone = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/mixedberry = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/lemonlime = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/xuizi = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/dyn = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/buzz = 5,
		/obj/item/reagent_containers/food/drinks/waterbottle/sedantis_water = 5
	)
	contraband = list(
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/hozm = 5
	)
	premium = list(
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/jelly = 3
	)
	prices = list(
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/cherry = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/phoron = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/klax = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/cthur = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/venomgrass = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/kois = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/drone = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/mixedberry = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/lemonlime = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/xuizi = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/dyn = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/buzz = 2.50,
		/obj/item/reagent_containers/food/drinks/waterbottle/sedantis_water = 3.50,
	)
	idle_power_usage = 211
	temperature_setting = -1
	light_color = COLOR_CULT_REINFORCED

/obj/machinery/vending/zora/low_supply
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/cherry = 2,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/phoron = 3,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/venomgrass = 2,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/kois = 1,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/drone = 5,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/xuizi = 3,
		/obj/item/reagent_containers/food/drinks/cans/zorasoda/dyn = 1
	)

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
		/obj/item/battle_monsters/wrapped/rare = 35.00,
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
		/obj/item/clothing/pants/tajaran = 2,
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
		/obj/item/coin/casino = 100
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
		/obj/item/storage/box/fancy/mre/menu10 = 10,
		/obj/item/storage/box/fancy/mre/menu12 = 5
	)
	prices = list(
		/obj/item/storage/box/fancy/mre = 12.00,
		/obj/item/storage/box/fancy/mre/menu2 = 12.00,
		/obj/item/storage/box/fancy/mre/menu3 = 12.00,
		/obj/item/storage/box/fancy/mre/menu4 = 12.00,
		/obj/item/storage/box/fancy/mre/menu5 = 12.00,
		/obj/item/storage/box/fancy/mre/menu6 = 12.00,
		/obj/item/storage/box/fancy/mre/menu7 = 12.00,
		/obj/item/storage/box/fancy/mre/menu8 = 12.00,
		/obj/item/storage/box/fancy/mre/menu9 = 12.00,
		/obj/item/storage/box/fancy/mre/menu10 = 12.00,
		/obj/item/storage/box/fancy/mre/menu12 = 12.00,
	)
	contraband = list(
		/obj/item/storage/box/fancy/mre/menu11 = 5, // memes.
		/obj/item/reagent_containers/food/snacks/liquidfood = 5
	)
	vend_delay = 15
	idle_power_usage = 211 // Cold MREs...

/obj/machinery/vending/mredispenser/low_supply
	products = list(
		/obj/item/storage/box/fancy/mre = 1,
		/obj/item/storage/box/fancy/mre/menu2 = 1,
		/obj/item/storage/box/fancy/mre/menu4 = 1,
		/obj/item/storage/box/fancy/mre/menu9 = 4,
		/obj/item/storage/box/fancy/mre/menu10 = 5,
		/obj/item/storage/box/fancy/mre/menu12 = 3
	)

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
		/obj/item/storage/overloader/jitterbug = 85.00,
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
		/obj/item/reagent_containers/food/drinks/cans/cola = 1.50,
		/obj/item/reagent_containers/food/drinks/cans/diet_cola = 1.50,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 1.20,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 1.75,
		/obj/item/reagent_containers/food/drinks/cans/root_beer = 1.40,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 1.50,
		/obj/item/reagent_containers/food/drinks/waterbottle = 1.25,
		/obj/item/reagent_containers/food/drinks/cans/dyn = 1.80,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 1.50,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 1.40,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 1.75,
		/obj/item/reagent_containers/food/drinks/cans/peach_soda = 1.75,
		/obj/item/reagent_containers/food/drinks/cans/koispunch = 5.00,
		/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 0.50,
		/obj/item/reagent_containers/food/drinks/cans/hrozamal_soda = 3.50,
		/obj/item/reagent_containers/food/drinks/carton/small/milk = 1.80,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/choco = 1.80,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/strawberry = 1.80,
		/obj/item/reagent_containers/food/drinks/cans/melon_soda = 1.75,
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
		/obj/item/reagent_containers/food/drinks/bottle/makgeolli = 12.00,
		/obj/item/reagent_containers/food/drinks/bottle/soju = 6.00,
		/obj/item/reagent_containers/food/drinks/bottle/soju/shochu = 12.00,
		/obj/item/reagent_containers/food/drinks/bottle/sake = 16.00,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice = 8.00,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice/shimauma = 8.00,
		/obj/item/reagent_containers/food/drinks/cans/beer/rice/moonlabor = 8.00,
		/obj/item/reagent_containers/food/drinks/cans/beer = 8.00,
		/obj/item/reagent_containers/food/drinks/bottle/small/beer = 8.00,
		/obj/item/reagent_containers/food/drinks/bottle/whiskey = 12.00,
		/obj/item/reagent_containers/food/drinks/bottle/wine = 20.00,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 40.00,
	)

/obj/machinery/vending/frontiervend
	name = "\improper FrontierVend"
	desc = "A vending machine specialized in snacks from the Coalition of Colonies."
	desc_extended = "Almost rebranded to the 'Coalition of Snackolonies', the FrontierVend brand is owned by a now-subsidiary of Orion Express specialized in food exports. These machines \
	are omnipresent throughout the settled regions of human space, forming a sort of Coalition superculture; it's easier to sympathize with someone if you eat the same snacks."
	icon_state = "frontiervend"
	icon_vend = "frontiervend-vend"
	product_slogans = "At least 85 billion served!;A new frontier of flavors!;Snacking for a free frontier!;Every purchase made supports the efforts of the Frontier Protection Bureau!"
	product_ads = "Roundhouse kick a Solarian into the concrete.;Slam-dunk Solarians into the trashcan.;Launch Solarians into the sun.;Frost got what he deserved."
	vend_id = "frontiervend"

	products = list(
		/obj/item/reagent_containers/food/drinks/cans/himeokvass = 8,
		/obj/item/reagent_containers/food/drinks/cans/boch = 8,
		/obj/item/reagent_containers/food/drinks/cans/boch/buckthorn = 8,
		/obj/item/reagent_containers/food/drinks/cans/xanuchai = 6,
		/obj/item/reagent_containers/food/drinks/cans/xanuchai/creme = 8,
		/obj/item/reagent_containers/food/drinks/cans/xanuchai/chocolate = 8,
		/obj/item/reagent_containers/food/drinks/cans/xanuchai/neapolitan = 8,
		/obj/item/reagent_containers/food/drinks/cans/galatea = 8,
		/obj/item/reagent_containers/food/drinks/bottle/bestblend = 6,
		/obj/item/reagent_containers/food/snacks/fishjerky = 8,
		/obj/item/reagent_containers/food/snacks/pepperoniroll = 8,
		/obj/item/reagent_containers/food/snacks/salmiak = 6,
		/obj/item/reagent_containers/food/snacks/hakhspam = 6,
		/obj/item/reagent_containers/food/snacks/pemmicanbar = 8,
		/obj/item/reagent_containers/food/snacks/choctruffles = 6,
		/obj/item/reagent_containers/food/snacks/peanutsnack = 8,
		/obj/item/reagent_containers/food/snacks/peanutsnack/pepper = 6,
		/obj/item/reagent_containers/food/snacks/peanutsnack/choc = 6,
		/obj/item/reagent_containers/food/snacks/peanutsnack/masala = 6,
		/obj/item/reagent_containers/food/snacks/chana = 8,
		/obj/item/reagent_containers/food/snacks/chana/wild = 8,
		/obj/item/reagent_containers/food/snacks/papad = 8,
		/obj/item/reagent_containers/food/snacks/papad/garlic = 8,
		/obj/item/reagent_containers/food/snacks/papad/ginger = 8,
		/obj/item/reagent_containers/food/snacks/papad/apple = 8,
		/obj/item/storage/box/fancy/foysnack = 4
	)
	prices = list(
		/obj/item/reagent_containers/food/drinks/cans/himeokvass = 3.50,
		/obj/item/reagent_containers/food/drinks/cans/boch = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/boch/buckthorn = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/xanuchai = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/xanuchai/creme = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/xanuchai/chocolate = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/xanuchai/neapolitan = 2.50,
		/obj/item/reagent_containers/food/drinks/cans/galatea = 4.50,
		/obj/item/reagent_containers/food/drinks/bottle/bestblend = 3.50,
		/obj/item/reagent_containers/food/snacks/fishjerky = 3.50,
		/obj/item/reagent_containers/food/snacks/pepperoniroll = 3.50,
		/obj/item/reagent_containers/food/snacks/salmiak = 3.50,
		/obj/item/reagent_containers/food/snacks/hakhspam = 4.00,
		/obj/item/reagent_containers/food/snacks/pemmicanbar = 2.50,
		/obj/item/reagent_containers/food/snacks/choctruffles = 3.50,
		/obj/item/reagent_containers/food/snacks/peanutsnack = 2.50,
		/obj/item/reagent_containers/food/snacks/peanutsnack/pepper = 2.50,
		/obj/item/reagent_containers/food/snacks/peanutsnack/choc = 2.50,
		/obj/item/reagent_containers/food/snacks/peanutsnack/masala = 2.50,
		/obj/item/reagent_containers/food/snacks/chana = 3.25,
		/obj/item/reagent_containers/food/snacks/chana/wild = 3.25,
		/obj/item/reagent_containers/food/snacks/papad = 2.50,
		/obj/item/reagent_containers/food/snacks/papad/garlic = 2.50,
		/obj/item/reagent_containers/food/snacks/papad/ginger = 2.50,
		/obj/item/reagent_containers/food/snacks/papad/apple = 2.50,
		/obj/item/storage/box/fancy/foysnack = 4.00,
	)
	contraband = list()
	premium = list(
		/obj/item/toy/comic/inspector = 2,
		/obj/item/toy/comic/stormman = 2,
		/obj/item/toy/plushie/greimorian = 2
	)
	random_itemcount = 0
	light_color = COLOR_BABY_BLUE

/obj/machinery/vending/frontiervend/low_supply
	products = list(
		/obj/item/reagent_containers/food/drinks/cans/himeokvass = 2,
		/obj/item/reagent_containers/food/drinks/cans/boch = 1,
		/obj/item/reagent_containers/food/drinks/cans/boch/buckthorn = 2,
		/obj/item/reagent_containers/food/drinks/cans/xanuchai = 2,
		/obj/item/reagent_containers/food/drinks/cans/xanuchai/creme = 1,
		/obj/item/reagent_containers/food/drinks/cans/galatea = 1,
		/obj/item/reagent_containers/food/drinks/bottle/bestblend = 2,
		/obj/item/reagent_containers/food/snacks/fishjerky = 1,
		/obj/item/reagent_containers/food/snacks/pepperoniroll = 1,
		/obj/item/reagent_containers/food/snacks/salmiak = 1,
		/obj/item/reagent_containers/food/snacks/pemmicanbar = 1,
		/obj/item/reagent_containers/food/snacks/peanutsnack = 2,
		/obj/item/reagent_containers/food/snacks/peanutsnack/pepper = 1,
		/obj/item/reagent_containers/food/snacks/chana = 1,
		/obj/item/reagent_containers/food/snacks/papad = 2,
		/obj/item/storage/box/fancy/foysnack = 1
	)

/obj/machinery/vending/frontiervend/hacked
	name = "hacked FrontierVend"
	desc = "A complimentary FrontierVend machine. No money? No worries."
	prices = list()

/obj/machinery/vending/rental_bikes
	name = "\improper Rental Bikes self-service vendor"
	desc = "Rent-a-bike, for a day!"
	icon_state = "rent-a-bike"
	icon_vend = "rent-a-bike-vend"
	vend_id = "rent-a-bike"
	products = list(
		/obj/item/key/bike/moped = 0, // filled from the key data lists
		/obj/item/key/bike/sport = 0,
	)
	prices = list(
		/obj/item/key/bike/moped = 15.00,
		/obj/item/key/bike/sport = 50.00,
	)
	restock_items = FALSE
	random_itemcount = FALSE
	light_color = COLOR_BABY_BLUE

	/// List of strings.
	/// Vended out keys will be filled with these key data (== bike reg plates) strings.
	/// Also based on this list is filled the products assoc list.
	var/list/key_data_mopeds = list()

	/// Same as the list for mopeds, except for sports bikes.
	var/list/key_data_sports = list()

/obj/machinery/vending/rental_bikes/build_products()
	products[/obj/item/key/bike/moped] = length(key_data_mopeds)
	products[/obj/item/key/bike/sport] = length(key_data_sports)

/obj/machinery/vending/rental_bikes/vended_product_post(var/obj/vended)
	var/obj/item/key/key = vended
	if(!istype(key))
		return

	// expires the next day
	var/rental_expiry = "[GLOB.game_year]-[time2text(world.realtime + 1 DAY, "MM-DD")] [worldtime2text()]"
	key.desc += " Property of Idris Incorporated. Rental expires on [rental_expiry]. Return fully charged."

	if(key_data_mopeds && istype(key, /obj/item/key/bike/moped))
		key.key_data = key_data_mopeds[1]
		key_data_mopeds.Cut(1,2)
	else if(key_data_sports && istype(key, /obj/item/key/bike/sport))
		key.key_data = key_data_sports[1]
		key_data_sports.Cut(1,2)

/obj/machinery/vending/ramen
	name = "ramen vendor"
	desc = "A generic brand vending machine capable of cooking tonkotsu ramen at the push of a button. Truly a pinnacle of human engineering!"
	icon_state = "ramen"
	icon_vend = "ramen-vend"
	product_slogans = "Irasshaimase!"
	vend_id = "ramen"
	products = list(
		/obj/item/reagent_containers/food/snacks/ramenbowl = 15,
		/obj/item/reagent_containers/food/snacks/aoyama_ramen = 15
	)
	prices = list(
		/obj/item/reagent_containers/food/snacks/ramenbowl = 7.00,
		/obj/item/reagent_containers/food/snacks/aoyama_ramen = 8.25,
	)
	light_color = COLOR_GUNMETAL

/obj/machinery/vending/encryption
	name = "SCC Encryption Key Vendor"
	desc = "Communications galore, at the tip of your fingers."
	product_ads = "Stop walkin, get talkin!;Get them keys!;Psst, got a minute?"
	icon_state = "wallencrypt"
	density = 0 //It is wall-mounted.
	req_access = list(ACCESS_HOP)
	vend_id = "encryption"
	products = list(
		/obj/item/device/encryptionkey/heads/captain = 1,
		/obj/item/device/encryptionkey/heads/ce = 1,
		/obj/item/device/encryptionkey/heads/cmo = 1,
		/obj/item/device/encryptionkey/heads/hos = 1,
		/obj/item/device/encryptionkey/heads/rd = 1,
		/obj/item/device/encryptionkey/heads/xo = 1,
		/obj/item/device/encryptionkey/headset_operations_manager = 1,
		/obj/item/device/encryptionkey/headset_com = 5,
		/obj/item/device/encryptionkey/headset_cargo = 5,
		/obj/item/device/encryptionkey/headset_eng = 5,
		/obj/item/device/encryptionkey/headset_med = 5,
		/obj/item/device/encryptionkey/headset_sci = 5,
		/obj/item/device/encryptionkey/headset_sec = 5,
		/obj/item/device/encryptionkey/headset_service = 5,
		/obj/item/device/encryptionkey/headset_warden = 5,
		/obj/item/device/encryptionkey/headset_xenoarch = 5,
	)

/obj/machinery/vending/actor
	name = "Actor Vendor"
	desc = "Has all your odyssey actor items, to let you effectively do your odysseying and actoring."
	vend_id = "actor"
	icon_state = "generic"
	icon_vend = "generic-vend"
	light_mask = "generic-lightmask"
	products = list(
		/obj/item/device/radio/headset/ship/odyssey = 12,
		/obj/item/portable_map_reader/odyssey = 12,
		/obj/item/card/id/syndicate = 12,
		/obj/item/storage/box/syndie_kit/chameleon = 12,
	)
	light_color = COLOR_GUNMETAL
	random_itemcount = FALSE

/*
Generic clothing vendor used in antagonist areas. For now, this almost entirely contains generic items. Prioritises recolourable items.
Intended to take some pressure off admins asked regularly to spawn in clothing by allowing players to spawn and colour their clothes themselves.
Only contains very few origin-specific items, as otherwise the list would get so long it'd be entirely incomprehensible.
If you want to expand this to more than primarily generic items, I recommend designing a UI that supports switching between categories.
*/
/obj/machinery/vending/generic_clothing
	name = "Generic Clothing Vendor"
	desc = "Contains a large number of generic clothing items. Comes with hand-held dyers to dye its contents however the user wishes."
	vend_id = "generic_clothing"
	icon_state = "robotics"
	icon_vend = "robotics-vend"
	light_mask = "robotics-light-mask"
	light_color = COLOR_GREEN
	random_itemcount = FALSE
	products = list (
		// This item allows players to change the colour of recolourable items from this vendor without needing admin intervention.
		/obj/item/device/clothes_dyer = 6,

		// Generic suits.
		/obj/item/clothing/suit/storage/toggle/labcoat = 6,
		/obj/item/clothing/suit/storage/hazardvest/colorable = 6,
		/obj/item/clothing/suit/storage/hooded/wintercoat/colorable = 6,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hoodie = 6,
		/obj/item/clothing/suit/storage/surgical_gown = 6,
		/obj/item/clothing/suit/storage/toggle/suitjacket = 6,
		/obj/item/clothing/suit/storage/toggle/trench/colorable = 6,
		/obj/item/clothing/suit/storage/toggle/bomber = 6,
		/obj/item/clothing/suit/storage/toggle/cardigan = 6,
		/obj/item/clothing/suit/storage/toggle/dominia/bomber = 6,
		/obj/item/clothing/suit/storage/toggle/greatcoat/brown = 6,

		// Generic shirts.
		/obj/item/clothing/under/dressshirt/alt = 6,
		/obj/item/clothing/under/dressshirt/polo = 6,
		/obj/item/clothing/under/dressshirt/silversun= 6,
		/obj/item/clothing/under/dressshirt/tanktop = 6,
		/obj/item/clothing/under/dressshirt/puffyblouse = 6,

		// Generic pants & skirts.
		/obj/item/clothing/pants/shorts/colourable = 6,
		/obj/item/clothing/pants/mustang/colourable = 6,
		/obj/item/clothing/pants/dress = 6,
		/obj/item/clothing/pants/skirt = 6,
		/obj/item/clothing/pants/skirt/high = 6,
		/obj/item/clothing/pants/skirt/pencil = 6,

		// Generic uniforms.
		/obj/item/clothing/under/color/colorable = 6,
		/obj/item/clothing/under/syndicate = 6,
		/obj/item/clothing/under/syndicate/tracksuit = 6,
		/obj/item/clothing/under/dress/colorable/longsleeve = 6,
		/obj/item/clothing/under/dress/colorable/sleeveless = 6,
		/obj/item/clothing/under/librarian = 6,
		/obj/item/clothing/under/rank/medical/generic = 6,
		/obj/item/clothing/under/dominia/imperial_suit = 6,
		/obj/item/clothing/under/suit_jacket = 6,
		/obj/item/clothing/under/tajaran = 6,

		// Generic hats.
		/obj/item/clothing/head/bandana/colorable = 6,
		/obj/item/clothing/head/beanie = 6,
		/obj/item/clothing/head/beret/colorable = 6,
		/obj/item/clothing/head/bucket/boonie = 6,
		/obj/item/clothing/head/cowboy/wide = 6,
		/obj/item/clothing/head/cowboy = 6,
		/obj/item/clothing/head/fedora = 6,
		/obj/item/clothing/head/flatcap/colourable = 6,
		/obj/item/clothing/head/wool = 6,
		/obj/item/clothing/head/sidecap = 6,
		/obj/item/clothing/head/plain_hood = 6,

		// Generic gloves.
		/obj/item/clothing/gloves/black_leather/colour = 6,
		/obj/item/clothing/gloves/fingerless/colour = 6,
		/obj/item/clothing/gloves/evening = 6,

		// Generic accessories.
		/obj/item/clothing/accessory/wcoat_rec = 6,
		/obj/item/clothing/accessory/bandanna/colorable = 6,
		/obj/item/clothing/accessory/apron = 6,
		/obj/item/clothing/accessory/tie/colourable = 6,
		/obj/item/clothing/accessory/tie/ribbon/neck = 6,
		/obj/item/clothing/accessory/poncho/colorable/gradient = 6,
		/obj/item/clothing/accessory/poncho/dominia_cape = 6,
		/obj/item/clothing/accessory/scarf = 6,

		// Bags.
		/obj/item/storage/backpack/duffel/eng = 6,
		/obj/item/storage/backpack/industrial = 6,
		/obj/item/storage/backpack/messenger = 6,
		/obj/item/storage/backpack/satchel = 6,
		/obj/item/storage/backpack/satchel/leather/recolorable = 6,
		/obj/item/storage/backpack/satchel/leather = 6,

		// Sunglasses and other eyewear.
		/obj/item/clothing/glasses/regular = 6,
		/obj/item/clothing/glasses/sunglasses = 6,
		/obj/item/clothing/glasses/sunglasses/blindfold = 6,
		/obj/item/clothing/glasses/monocle = 6,
		/obj/item/clothing/glasses/eyepatch = 6,

		// Shoes and boots.
		/obj/item/clothing/shoes/jackboots = 6,
		/obj/item/clothing/shoes/jackboots/cavalry = 6,
		/obj/item/clothing/shoes/jackboots/toeless = 6,
		/obj/item/clothing/shoes/sneakers/black = 6,
		/obj/item/clothing/shoes/laceup/colourable = 6,
		/obj/item/clothing/shoes/heels = 6,
		/obj/item/clothing/shoes/winter = 6,
	)

/obj/machinery/vending/lavatory
	name = "\improper Lavatory Essentials"
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
		/obj/item/reagent_containers/food/drinks/flask/vacuumflask/mouthwash = 5.00,
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
		/obj/item/grenade/chem_grenade/metalfoam = 0,
	)
	contraband = list(
		/obj/item/inflatable_duck = 1
	)

/obj/machinery/vending/lavatory/low_supply
	prices = list(
		/obj/item/soap = 7,
		/obj/item/mirror = 12,
		/obj/item/haircomb/random = 12,
		/obj/item/towel/random = 14,
		/obj/item/reagent_containers/spray/cleaner/deodorant = 6,
		/obj/item/reagent_containers/toothpaste = 14,
		/obj/item/reagent_containers/toothbrush = 23,
		/obj/item/reagent_containers/food/drinks/flask/vacuumflask/mouthwash = 18
	)
