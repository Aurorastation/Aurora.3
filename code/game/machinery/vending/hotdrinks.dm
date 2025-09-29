/**
 *	Hot drinks machine
 *		Low Supply
 *		Free
 */

/obj/machinery/vending/coffee
	name = "\improper Hot Drinks machine"
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
		/obj/item/reagent_containers/food/snacks/donut/normal = 2.50
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
	name = "\improper Free Hot Drinks machine"
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
		/obj/item/reagent_containers/food/drinks/coffee = 4,
		/obj/item/reagent_containers/food/drinks/tea = 6,
		/obj/item/reagent_containers/food/drinks/h_chocolate = 3,
		/obj/item/reagent_containers/food/snacks/donut/normal = 8
	)

/obj/machinery/vending/coffee/Initialize()
	// 30% chance to spawn as a low_supply variant, on the Horizon only. Temporary proc, to be deleted for final merge.
	if(prob(30))
		var/is_station_level = is_station_level(src.z)
		if(is_station_level)
			var/obj/machinery/vending/coffee/low_supply/replacement = new(src.loc)
			qdel(src)
	else
		. = ..()

/obj/item/device/vending_refill/coffee
	name = "coffee resupply canister"
	vend_id = "coffee"
	charges = 38
