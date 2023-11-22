/obj/item/reagent_containers/food/drinks/trophy
	name = "pewter cup"
	desc = "Everyone gets a trophy."
	icon = 'icons/obj/item/reagent_containers/food/drinks/bottle.dmi'
	icon_state = "pewter_cup"
	w_class = ITEMSIZE_TINY
	force = 1
	throwforce = 1
	amount_per_transfer_from_this = 5
	matter = list(MATERIAL_IRON = 10)
	possible_transfer_amounts = null
	volume = 5
	flags = CONDUCT | OPENCONTAINER

/obj/item/reagent_containers/food/drinks/trophy/gold_cup
	name = "gold cup"
	desc = "You're winner!"
	icon_state = "golden_cup"
	item_state = "golden_cup"
	w_class = ITEMSIZE_LARGE
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	matter = list(MATERIAL_GOLD = 50)
	volume = 150

/obj/item/reagent_containers/food/drinks/trophy/silver_cup
	name = "silver cup"
	desc = "Best loser!"
	icon_state = "silver_cup"
	w_class = ITEMSIZE_NORMAL
	force = 10
	throwforce = 8
	amount_per_transfer_from_this = 15
	matter = list(MATERIAL_SILVER = 80)
	volume = 100

/obj/item/reagent_containers/food/drinks/trophy/bronze_cup
	name = "bronze cup"
	desc = "At least you ranked!"
	icon_state = "bronze_cup"
	w_class = ITEMSIZE_SMALL
	force = 5
	throwforce = 4
	amount_per_transfer_from_this = 10
	matter = list(MATERIAL_IRON = 40)
	volume = 25
