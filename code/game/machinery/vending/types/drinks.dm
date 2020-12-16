/obj/machinery/vending/cola
	name = "Robust Softdrinks"
	desc = "A softdrink vendor provided by Robust Industries, LLC."
	icon_state = "cola_machine"
	product_slogans = "Robust Softdrinks: More robust than a toolbox to the head!"
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/cola, 10, 15),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind, 10, 11),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/dr_gibb, 10, 16),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/root_beer, 10, 13),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/starkist, 10, 15),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/waterbottle, 10, 12),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/dyn, 10, 18),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/space_up, 10, 15),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/iced_tea, 10, 13),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/grape_juice, 10, 16),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/koispunch, 5, 50),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/beetle_milk, 10, 5)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/thirteenloko, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/snacks/liquidfood, 6, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/cola, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/space_mountain_wind, 2, FALSE),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/space_up, 2, FALSE)
		)
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	vending_sound = 'sound/machines/vending/vending_cans.ogg'
	temperature_setting = -1
	light_color = COLOR_GUNMETAL

/obj/machinery/vending/sovietsoda
	name = "BODA"
	desc = "An old sweet water vending machine, how did this end up here?"
	icon_state = "sovietsoda"
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/drinkingglass/soda, 30, FALSE)
		),
		//would a soviet vending machine really have a premium item? hmmm.
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/bottle/vodka, 5, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/drinkingglass/cola, 20, FALSE)
		)
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	randomize_qty = FALSE
	temperature_setting = -1
	vending_sound = 'sound/machines/vending/vending_cans.ogg'
	light_color = COLOR_RED

/obj/item/vending_refill/cola
	name = "cola resupply canister"
	charges = 50
