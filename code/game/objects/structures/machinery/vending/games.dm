/obj/machinery/vending/games
	name = "\improper Good Clean Fun"
	desc = "Vends things your boss is not going to appreciate you playing with on the job..."
	vend_id = "games"
	icon_state = "games"
	icon_vend = "games-vend"
	icon_deny = "games-deny"
	light_mask = "games-lightmask"
	light_color = COLOR_GUNMETAL
	product_slogans = {"
		Escape to a fantasy world!;\
		Fuel your gambling addiction!;\
		Ruin your friendships!\
	"}
	product_ads = {"\
		Elves and dwarves!;\
		Totally not satanic!;\
		Fun times forever!\
	"}
	products = list(
		/obj/item/toy/blink = 6,
		/obj/item/toy/stressball = 10,
		/obj/item/deck/cards = 6,
		/obj/item/deck/tarot = 6,
		/obj/item/deck/tarot/nralakk = 4,
		/obj/item/deck/tarot/nonnralakk = 4,
		/obj/item/deck/tarot/adhomai = 4,
		/obj/item/pack/cardemon = 6,
		/obj/item/pack/spaceball = 6,
		/obj/item/storage/card = 4,
		/obj/item/storage/pill_bottle/dice = 6,
		/obj/item/storage/pill_bottle/dice/gaming = 6,
		/obj/item/storage/pill_bottle/dice/tajara = 3,
		/obj/item/reagent_containers/spray/waterflower = 3,
		/obj/item/storage/box/unique/snappops = 2
	)
	prices = list(
		/obj/item/toy/blink = 6.99,
		/obj/item/toy/stressball = 4.99,
		/obj/item/deck/cards = 3.99,
		/obj/item/deck/tarot = 4.49,
		/obj/item/deck/tarot/nralakk = 5.99,
		/obj/item/deck/tarot/nonnralakk = 7.49,
		/obj/item/deck/tarot/adhomai = 7.99,
		/obj/item/pack/cardemon = 5.49,
		/obj/item/pack/spaceball = 6.99,
		/obj/item/storage/card = 10.99,
		/obj/item/storage/pill_bottle/dice = 6.99,
		/obj/item/storage/pill_bottle/dice/gaming = 12.49,
		/obj/item/storage/pill_bottle/dice/tajara = 15.99,
		/obj/item/reagent_containers/spray/waterflower = 11.99,
		/obj/item/storage/box/unique/snappops = 15.99,
		/obj/item/toy/crossbow = 20.99,
		/obj/item/toy/ammo/crossbow = 1.49,
		/obj/item/toy/sword = 20.99,
		/obj/item/toy/katana = 15.99,
		/obj/item/gun/projectile/revolver/capgun = 18.99,
		/obj/item/ammo_magazine/caps = 1.99

	)
	contraband = list(
		/obj/item/toy/crossbow = 1,
		/obj/item/toy/ammo/crossbow = 4,
		/obj/item/toy/sword = 3,
		/obj/item/toy/katana = 3,
		/obj/item/gun/projectile/revolver/capgun = 1,
		/obj/item/ammo_magazine/caps = 4
	)
	premium = list(
		/obj/item/spirit_board = 1
	)
