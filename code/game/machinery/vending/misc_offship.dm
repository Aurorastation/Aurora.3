/**
 *	Grand Romanovich casino vendor
 */

/obj/machinery/vending/casino
	name = "Grand Romanovich vending machine"
	desc = "A vending machine commonly found in Crevus' casinos."
	icon_state = "casinovend"
	product_slogans = "The House always wins!;Spends your chips right here!;Let Go and Begin Again..."
	product_ads = "Finding it, though, that's not the hard part. It's letting go."
	vend_id = "casino"
	products = list(
		/obj/item/coin/casino = 50
	)
	contraband = list(
		/obj/item/ammo_magazine/boltaction = 2
	)
	premium = list(
		/obj/item/gun/projectile/shotgun/pump/rifle/blank = 3,
		/obj/item/ammo_magazine/boltaction/blank = 10,
		/obj/item/storage/box/fancy/cigarettes/dpra = 5,
		/obj/item/storage/chewables/tobacco/bad = 5,
		/obj/item/reagent_containers/food/drinks/bottle/messa_mead = 5,
		/obj/item/reagent_containers/food/drinks/bottle/victorygin = 5,
		/obj/item/reagent_containers/food/drinks/bottle/pwine = 5,
		/obj/item/reagent_containers/food/snacks/hardbread = 5,
		/obj/item/reagent_containers/food/drinks/cans/adhomai_milk = 5,
		/obj/item/reagent_containers/food/snacks/adhomian_can = 5,
		/obj/item/reagent_containers/food/snacks/clam = 5,
		/obj/item/reagent_containers/food/snacks/tajaran_bread = 5,
		/obj/item/toy/plushie/farwa = 2,
		/obj/item/reagent_containers/food/snacks/monkeycube/wrapped/farwacube = 2,
		/obj/item/razor = 2,
		/obj/item/toy/balloon/syndicate = 2,
		/obj/item/grenade/fake = 2,
		/obj/item/eightball/haunted = 5,
		/obj/item/spirit_board = 5,
		/obj/item/device/flashlight/maglight = 5,
		/obj/item/contraband/poster = 5,
		/obj/item/spacecash/ewallet/lotto = 15,
		/obj/item/device/laser_pointer = 5,
		/obj/item/beach_ball = 1,
		/obj/item/material/knife/butterfly/switchblade = 2,
		/obj/item/reagent_containers/hypospray/autoinjector/stimpack = 2,
		/obj/item/clothing/under/tajaran/summer = 2,
		/obj/item/clothing/pants/tajaran = 2,
		/obj/item/clothing/under/dress/tajaran =2,
		/obj/item/clothing/under/dress/tajaran/blue = 2,
		/obj/item/clothing/under/dress/tajaran/green = 2,
		/obj/item/clothing/under/dress/tajaran/red = 2,
		/obj/item/clothing/head/tajaran/circlet = 2,
		/obj/item/clothing/head/tajaran/circlet/silver = 2,
		/obj/item/gun/energy/lasertag/red = 2,
		/obj/item/clothing/suit/armor/riot/laser_tag = 2,
		/obj/item/gun/energy/lasertag/blue = 2,
		/obj/item/clothing/suit/armor/riot/laser_tag/blue = 2
		)
	prices = list(
		/obj/item/coin/casino = 100
	)

	restock_items = FALSE
	random_itemcount = FALSE
