/**
 *	GetMore Chocolate Corp
 *		Low Supply
 *		Konyang
 *	FrontierVend
 *		Low Supply
 *		Hacked
 */

/obj/machinery/vending/snack
	name = "Getmore Chocolate Corp"
	desc = "A snack machine courtesy of the Getmore Chocolate Corporation, based out of Mars."
	product_slogans = "Try our new nougat bar!;Twice the calories for half the price!"
	product_ads = "The healthiest!;Award-winning chocolate bars!;Mmm! So good!;Oh my god it's so juicy!;Have a snack.;Snacks are good for you!;Have some more Getmore!;Best quality snacks straight from mars.;We love chocolate!;Try our new jerky!"
	icon_state = "snack"
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

/obj/item/device/vending_refill/snack
	name = "snacks resupply canister"
	vend_id = "snacks"
	charges = 38

/obj/machinery/vending/frontiervend
	name = "FrontierVend"
	desc = "A vending machine specialized in snacks from the Coalition of Colonies."
	desc_extended = "Almost rebranded to the 'Coalition of Snackolonies', the FrontierVend brand is owned by a now-subsidiary of Orion Express specialized in food exports. These machines \
	are omnipresent throughout the settled regions of human space, forming a sort of Coalition superculture; it's easier to sympathize with someone if you eat the same snacks."
	icon_state = "frontiervend"
	icon_deny = "frontiervend-deny"
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
		/obj/item/storage/box/fancy/foysnack = 4.00
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
	name = "\improper hacked FrontierVend"
	desc = "A complimentary FrontierVend machine. No money? No worries."
	prices = list()

/obj/item/device/vending_refill/frontiervend
	name = "frontiervend resupply canister"
	vend_id = "frontiervend"
	charges = 220
