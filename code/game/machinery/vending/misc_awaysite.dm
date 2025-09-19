/**
 *	Minimart refridgerator
 *	Minimart alcohol selection
 *	Rental Bikes self-service vendor
 */

/obj/machinery/vending/minimart
	name = "\improper minimart refrigerator"
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
		/obj/item/reagent_containers/food/drinks/cans/melon_soda = 1.75
	)
	light_color = COLOR_BABY_BLUE

/obj/machinery/vending/minimart/alcohol
	name = "\improper minimart alcohol selection"
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
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 40.00
	)

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
		/obj/item/key/bike/sport = 50.00
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
