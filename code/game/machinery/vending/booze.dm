/**
 *	Booze-O-Mat
 *		Merchant Station
 *		Abandoned
 *		Low Supply
 */

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
		/obj/item/reagent_containers/food/drinks/bottle/limoncello = 2,
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

/obj/item/device/vending_refill/booze
	name = "booze resupply canister"
	vend_id = "booze"
	charges = 100 //holy shit that's a lot of booze

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
		/obj/item/reagent_containers/food/drinks/bottle/limoncello = 1,
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
