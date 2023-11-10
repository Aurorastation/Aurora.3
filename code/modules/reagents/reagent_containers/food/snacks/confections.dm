/obj/item/reagent_containers/food/snacks/icecreamsandwich
	name = "ice cream sandwich"
	desc = "Portable ice cream in its own packaging."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "icecreamsandwich"
	filling_color = "#343834"
	center_of_mass = list("x"=15, "y"=4)
	reagents_to_add = list(/singleton/reagent/nutriment = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("ice cream" = 4))

/obj/item/reagent_containers/food/snacks/banana_split
	name = "banana split"
	desc = "A dessert made with icecream and a banana."
	icon_state = "banana_split"
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/drink/banana = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("icecream" = 2))
	bitesize = 2
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F7F786"

/obj/item/reagent_containers/food/snacks/candiedapple
	name = "candied apple"
	desc = "An apple coated in sugary sweetness."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "candiedapple"
	filling_color = "#F21873"
	center_of_mass = list("x"=15, "y"=13)
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("apple" = 3, "caramel" = 3, "sweetness" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/triolade
	name = "triolade mousse"
	desc = "Fluffy white, milk, and dark chocolate stacked upon each other in inviting layers."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "triolade"
	filling_color = "#ad724f"
	reagents_to_add = list(/singleton/reagent/nutriment = 3)
	reagent_data = list(/singleton/reagent/nutriment = list("milk chocolate" = 3, "white chocolate" = 3, "dark chocolate" = 3))
	trash = /obj/item/trash/triolade
	bitesize = 1


/obj/item/reagent_containers/food/snacks/izuixu
	name = "izuixu"
	desc = "A recent trend in recent years, created a collaboration between two friends from Valkyrie - a Human and an Unathi, this dessert mixture of ice cream rolls and xuizi juice is truly a modern symbol of the Valkyrian dream and modern day cultural bonds."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "izuixu"
	trash = /obj/item/trash/icecreamcup
	filling_color = "#be59be"
	center_of_mass = list("x"=15, "y"=4)
	reagents_to_add = list(/singleton/reagent/nutriment = 5 , /singleton/reagent/alcohol/butanol/xuizijuice = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("ice cream" = 4))
