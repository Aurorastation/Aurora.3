/obj/machinery/vending/cigarette
	name = "Cigarette machine" //OCD had to be uppercase to look nice with the new formating
	desc = "If you want to get cancer, might as well do it in style!"
	product_slogans = "Space cigs taste good like a cigarette should.;I'd rather toolbox than switch.;Smoke!;Don't believe the reports - smoke today!"
	vend_delay = 34
	icon_state = "cigs"
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/rugged, 6, 67),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes, 8, 76),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/dromedaryco, 5, 82),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/nicotine, 3, 89),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/pra, 6, 79),
			VENDOR_PRODUCT(/obj/item/storage/chewables/rollable/bad, 6, 56),
			VENDOR_PRODUCT(/obj/item/storage/chewables/rollable, 8, 63),
			VENDOR_PRODUCT(/obj/item/storage/chewables/rollable/fine, 5, 69),
			VENDOR_PRODUCT(/obj/item/storage/chewables/rollable/nico, 3, 86),
			VENDOR_PRODUCT(/obj/item/storage/chewables/tobacco/bad, 6, 55),
			VENDOR_PRODUCT(/obj/item/storage/chewables/tobacco, 8, 74),
			VENDOR_PRODUCT(/obj/item/storage/chewables/tobacco/fine, 5, 86),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/chewables/tobacco/nico, 3, 91),
			VENDOR_PRODUCT(/obj/item/storage/cigfilters, 6, 28),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigpaper, 6, 35),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigpaper/fine, 4, 42),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/matches, 10, 12),
			VENDOR_PRODUCT(/obj/item/flame/lighter/random, 4, 12),
			VENDOR_PRODUCT(/obj/item/spacecash/ewallet/lotto, 30, 200)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/blank, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/acmeco, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/mask/smokable/cigarette/rolled/sausage, 3, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/flame/lighter/zippo, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/cigar, 5, FALSE)
		)
	)
	light_color = COLOR_BLUE_GRAY

/obj/machinery/vending/cigarette/merchant
	// Mapped in merchant station
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/matches, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/flame/lighter/random, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/cigar, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/acmeco, 5, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/blank, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/acmeco, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/mask/smokable/cigarette/rolled/sausage, 3, FALSE)
		),
		CAT_COIN = list()
	)

/obj/machinery/vending/cigarette/hacked
	name = "hacked cigarette machine"
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/matches, 10, FALSE),
			VENDOR_PRODUCT(/obj/item/flame/lighter/zippo, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/mask/smokable/cigarette/cigar/havana, 2, FALSE)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/blank, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/acmeco, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/clothing/mask/smokable/cigarette/rolled/sausage, 3, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/flame/lighter/zippo, 4, FALSE),
			VENDOR_PRODUCT(/obj/item/storage/box/fancy/cigarettes/cigar, 5, FALSE)
		)
	)

/obj/item/vending_refill/smokes
	name = "smokes resupply canister"
	charges = 25
