/**
 *	MREs
 *		Low Supply
 *	Ramen
 */

/obj/machinery/vending/mredispenser
	name = "MRE dispenser"
	desc = "A vending machine filled with MRE's."
	icon_state = "mrevend"
	icon_deny = "mrevend-deny"
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
		/obj/item/storage/box/fancy/mre/menu12 = 12.00
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

/obj/machinery/vending/ramen
	name = "\improper ramen vendor"
	desc = "A generic brand vending machine capable of cooking tonkotsu ramen at the push of a button. Truly a pinnacle of human engineering!"
	icon_state = "ramen"
	icon_vend = "ramen-vend"
	icon_deny = "ramen-deny"
	product_slogans = "Irasshaimase!"
	vend_id = "ramen"
	products = list(
		/obj/item/reagent_containers/food/snacks/ramenbowl = 15,
		/obj/item/reagent_containers/food/snacks/aoyama_ramen = 15
	)
	prices = list(
		/obj/item/reagent_containers/food/snacks/ramenbowl = 7.00,
		/obj/item/reagent_containers/food/snacks/aoyama_ramen = 8.25
	)
	light_color = COLOR_GUNMETAL
