/obj/item/clothing/mask/chewable/candy/gum
	name = "chewing gum"
	icon_state = "gum"
	item_state = "gum"
//	brand = "gum"

//the gum
/obj/item/clothing/mask/chewable/candy/gum
	name = "chewing gum"
	desc = "A chewy wad of fine synthetic rubber and artificial flavoring."
	icon_state = "gum"
	item_state = "gum"

// The gum when its on your mouth
/obj/item/clothing/mask/chewable/candy/gum/New()
	..()
	reagents.add_reagent(pick(list(
				/datum/reagent/fuel,
				/datum/reagent/drink/grapejuice,
				/datum/reagent/drink/orangejuice,
				/datum/reagent/drink/lemonjuice,
				/datum/reagent/drink/limejuice,
				/datum/reagent/drink/banana,
				/datum/reagent/drink/berryjuice,
				/datum/reagent/drink/space_cola,
				/datum/reagent/drink/lemon_lime
				/datum/reagent/drink/watermelonjuice)), 3)
	color = reagents.get_color()

// The box for the gum
/obj/item/weapon/storage/chewables/candy/gum
	name = "\improper Rainbo-Gums"
	desc = "A mixed pack of delicious fruit (and trace amounts of fuel) flavored bubble-gums!"
	icon_state = "gumpack"
	max_storage_space = 8
	startswith = list(/obj/item/clothing/mask/chewable/candy/gum = 8)
	make_exact_fit()

// The used hum
/obj/item/weapon/cigbutt/spitgum
	name = "old gum"
	desc = "A disgusting chewed up wad of gum."
	icon_state = "spit-gum"