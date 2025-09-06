/*
 *	Cigarette machine
 *		Low Supply
 *		Merchant Station
 *		Hacked
 */

/obj/machinery/vending/cigarette
	name = "\improper cigarette machine" //OCD had to be uppercase to look nice with the new formating
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
		/obj/item/storage/box/fancy/cigarettes/koko = 3,
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
		/obj/item/storage/box/fancy/cigarettes/koko = 11.50,
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
		/obj/item/spacecash/ewallet/lotto = 10.00,
		/obj/item/clothing/mask/smokable/ecig/simple = 25.00,
		/obj/item/clothing/mask/smokable/ecig/util = 35.00,
		/obj/item/reagent_containers/ecig_cartridge/med_nicotine = 4.50,
		/obj/item/reagent_containers/ecig_cartridge/high_nicotine = 5.25,
		/obj/item/reagent_containers/ecig_cartridge/orange = 4.25,
		/obj/item/reagent_containers/ecig_cartridge/watermelon = 4.00,
		/obj/item/reagent_containers/ecig_cartridge/grape = 4.40
	)
	light_color = COLOR_BLUE_GRAY

/obj/machinery/vending/cigarette/low_supply
	products = list(
		/obj/item/storage/box/fancy/cigarettes/rugged = 4,
		/obj/item/storage/box/fancy/cigarettes = 2,
		/obj/item/storage/box/fancy/cigarettes/dpra = 2,
		/obj/item/storage/box/fancy/cigarettes/federation = 1,
		/obj/item/storage/box/fancy/cigarettes/koko = 1,
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

/obj/item/device/vending_refill/smokes
	name = "smokes resupply canister"
	vend_id = "smokes"
	charges = 25
