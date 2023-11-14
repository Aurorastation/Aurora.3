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
	name = "izu-ixu"
	desc = "A recent trend, created as a collaboration between two friends from Valkyrie - a Human and an Unathi, this dessert mixture of ice cream rolls and xuizi juice is truly a modern symbol of the Valkyrian dream and modern day cultural bonds. It's naturally green but artificially made pink to make it more inviting."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "izuixu"
	trash = /obj/item/trash/icecreamcup
	filling_color = "#be59be"
	center_of_mass = list("x"=15, "y"=4)
	reagents_to_add = list(/singleton/reagent/nutriment = 5 , /singleton/reagent/alcohol/butanol/xuizijuice = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("xuizi ice cream" = 5))

///obj/item/reagent_containers/food/snacks/plafooz
//	name = "palfooz"
//	desc = "Fresh pineapple floats. So to show their ingredients are fresh, many Vyoskan establishments started serving this elaborate, fancy dessert, on a pineapple slice floating in light cherry syrup. It's customary to give it a spin as you serve it to show it's really floating. The dish itself is really just pineapple sorbet and cherry jello, but it's still so FANCY."
//	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
//	icon_state = "izuixu"
//	trash = /obj/item/trash/snack_bowl
//	reagents_to_add = list(/singleton/reagent/nutriment = 5//, /singleton/reagent/nutriment/gelatin = 3//
//	)
//	reagent_data = list(/singleton/reagent/nutriment = list("pineapple sorbet" = 4, "cherry" = 3)//, /singleton/reagent/nutriment/gelatin = list("jello" =3)
//	)
//	bitesize = 2
//	filling_color = "#ffeb94"

///obj/item/reagent_containers/food/snacks/palfooz/update_icon()
//	var/percent_palfooz = round((reagents.total_volume / 8) * 100)
//	switch(percent_palfooz)
//		if(0 to 40)
//			icon_state = "palfoozbitten"
//		if(0 to 98)
//			icon_state= "palfoozstopped"
//		if(99 to INFINITY)
//			icon_state = "palfoozstoppedizui"

/obj/item/reagent_containers/food/snacks/palfooz
	name = "palfooz"
	desc = "Fresh pineapple floats. So to show their ingredients are fresh, many Vyoskan establishments started serving this elaborate, fancy dessert, on a pineapple slice floating in light cherry syrup. It's customary to give it a spin as you serve it to show it's really floating. The dish itself is really just pineapple sorbet and cherry jello, but it's still so FANCY."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "palfooz"
	filling_color = "#ffeb94"
	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("pineapple sorbet" = 4, "cherry" = 3))
	trash = /obj/item/trash/snack_bowl
	bitesize = 2
