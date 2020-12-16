/obj/machinery/vending/battlemonsters
	name = "\improper Battlemonsters vendor"
	desc = "A good place to dump all your rent money."
	icon_state = "battlemonsters"
	products = list(
		CAT_NORMAL = list(
			VENDOR_PRODUCT(/obj/item/book/manual/wiki/battlemonsters, 10, 12),
			VENDOR_PRODUCT(/obj/item/battle_monsters/wrapped/basic, 5, FALSE),
			VENDOR_PRODUCT(/obj/item/battle_monsters/wrapped, 10, 100),
			VENDOR_PRODUCT(/obj/item/battle_monsters/wrapped/pro, 10, 75),
			VENDOR_PRODUCT(/obj/item/battle_monsters/wrapped/species, 4, 100), //Human monsters
			VENDOR_PRODUCT(/obj/item/battle_monsters/wrapped/species/lizard, 4, 125), //Reptile Monsters
			VENDOR_PRODUCT(/obj/item/battle_monsters/wrapped/species/cat, 4, 125), //Feline Monsters
			VENDOR_PRODUCT(/obj/item/battle_monsters/wrapped/species/ant, 4, 125), //Ant Monsters
			VENDOR_PRODUCT(/obj/item/battle_monsters/wrapped/rare, 4, 200)
		),
		CAT_HIDDEN = list(
			VENDOR_PRODUCT(/obj/item/battle_monsters/wrapped/legendary, 4, FALSE)
		),
		CAT_COIN = list(
			VENDOR_PRODUCT(/obj/item/coin/battlemonsters, 10, FALSE)
		)
	)
	restock_items = FALSE
	light_color = COLOR_BABY_BLUE

/obj/item/vending_refill/battlemonsters
	name = "Battlemonsters resupply canister"
	charges = 40
