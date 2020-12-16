/obj/machinery/vending/coffee
	name = "Hot Drinks machine"
	desc = "A vending machine which dispenses hot drinks."
	icon_state = "coffee"
	icon_vend = "coffee-vend"
	vend_delay = 34
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/coffee, 25, 20),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/tea, 25, 20),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/greentea, 25, 20),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/chaitea, 25, 25),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/hotcider, 25, 28),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/h_chocolate, 25, 22),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/donut/normal, 20, 6)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/ice, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/soymilk, 2, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/teapot/, 5, FALSE)
		)
	)
	vending_sound = 'sound/machines/vending/vending_coffee.ogg'
	cooling_temperature = T0C + 57 //Optimal coffee temperature
	heating_temperature = T0C + 100 //ULTRA HOT COFFEE
	temperature_setting = -1
	light_color = COLOR_BROWN

/obj/machinery/vending/coffee/free
	name = "Free Hot Drinks machine"
	desc = "A vending machine which dispenses complimentary hot drinks."
	randomize_qty = FALSE
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/coffee, 12, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/tea, 8, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/h_chocolate, 8, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/donut/normal, 6, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/ice, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/soymilk, 2, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/teapot/, 5, FALSE)
		)
	)

/obj/item/vending_refill/coffee
	name = "coffee resupply canister"
	charges = 38
