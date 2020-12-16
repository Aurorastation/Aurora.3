/obj/machinery/vending/zora
	name = "Zo'ra Soda"
	desc = "An energy drink vendor provided by the Getmore Corporation in partnership with the brood of Ta'Akaix'Xakt'yagz'isk Zo'ra."
	icon_state = "zoda"
	product_slogans = "Safe for human consumption!;Made by hard-working bound drones!;The most refreshing taste in the sector!;A product of two thousand years!"
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/zorasoda, 5, 30),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/zorakois, 5, 27),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/zoraklax, 4, 30),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/zoraphoron, 5, 30),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/zoravenom, 5, 30),
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/zoradrone, 5, 30),
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/zoracthur, 2, FALSE),
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/reagent_containers/food/drinks/cans/zorajelly, 2, FALSE),
		)
	)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	temperature_setting = -1
	light_color = COLOR_CULT_REINFORCED

/obj/item/vending_refill/zora
	name = "Zo'ra Soda resupply canister"
	charges = 40
