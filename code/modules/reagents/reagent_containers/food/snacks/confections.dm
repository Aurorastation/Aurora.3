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

/obj/item/reagent_containers/food/snacks/izuixu
	name = "izu-ixu"
	desc = "A recent trend, created as a collaboration between two friends from Valkyrie - a Human and an Unathi, this dessert mixture of ice cream rolls and xuizi juice is truly a modern symbol of the Valkyrian dream and modern day cultural bonds. It's naturally green but artificially made pink to make it more inviting."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "izuixu"
	trash = /obj/item/trash/icecreamcup
	filling_color = "#be59be"
	center_of_mass = list("x"=15, "y"=4)
	reagents_to_add = list(/singleton/reagent/nutriment = 4 , /singleton/reagent/alcohol/butanol/xuizijuice = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("xuizi ice cream" = 5, "strawberries" = 2))

/obj/item/reagent_containers/food/snacks/triolade
	name = "triolade mousse"
	desc = "Fluffy white, milk, and dark chocolate stacked upon each other in inviting layers."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "triolade"
	filling_color = "#ad724f"
	reagents_to_add = list(/singleton/reagent/nutriment = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("milk chocolate" = 6, "white chocolate" = 6, "dark chocolate" = 6))
	trash = /obj/item/trash/triolade
	bitesize = 2

/obj/item/reagent_containers/food/snacks/floatingisland
	name = "floating island"
	desc = "Fresh pineapple floats. So to show their ingredients are fresh, many establishments started serving this dessert on a pineapple slice floating in light cherry syrup. It's customary to give it a spin as you serve it to show it's really floating. The dish itself is really just pineapple sorbet and cherry jello, but it's still so FANCY."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "floatingisland"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ffeb94"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/gelatin = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("pineapple sorbet" = 5, "cherry jello" = 5))
	trash = /obj/item/trash/snack_bowl
	bitesize = 2

/obj/item/reagent_containers/food/snacks/floatingisland/update_icon()
	var/percent_floatingisland = round((reagents.total_volume / 8) * 100)
	switch(percent_floatingisland)
		if(0 to 40)
			icon_state = "floatingislandbitten"
		if(0 to 98)
			icon_state= "floatingislandstopped"
		if(99 to INFINITY)
			icon_state = "floatingisland"

//pralines

/obj/item/reagent_containers/food/snacks/pralines
	name = "chocolate praline"
	desc = "A tiny, delicious piece of milk chocolate with some sort of filling inside of it."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "praline1"
	w_class = ITEMSIZE_TINY
	filling_color = "#4d280f"
	reagents_to_add = list(/singleton/reagent/nutriment = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("milk chocolate and caramel" = 1))

/obj/item/reagent_containers/food/snacks/pralines/praline1 //praline 1's settings are the same as the base
/obj/item/reagent_containers/food/snacks/pralines/praline2
	desc = "A tiny, delicious piece of white chocolate with some sort of filling inside of it."
	icon_state = "praline2"
	filling_color = "#fdf6ba"
	reagent_data = list(/singleton/reagent/nutriment = list("white chocolate and cherries" = 1))

/obj/item/reagent_containers/food/snacks/pralines/praline3
	desc = "A tiny, delicious piece of dark chocolate."
	icon_state = "praline3"
	filling_color = "#241c17"
	reagent_data = list(/singleton/reagent/nutriment = list("rich dark chocolate" = 1))

/obj/item/reagent_containers/food/snacks/pralines/praline4
	icon_state = "praline4"
	reagent_data = list(/singleton/reagent/nutriment = list("milk chocolate and cherries" = 1))

/obj/item/reagent_containers/food/snacks/pralines/praline5
	desc = "A tiny, delicious piece of white chocolate with some sort of filling inside of it."
	icon_state = "praline5"
	filling_color = "#fdf6ba"
	reagent_data = list(/singleton/reagent/nutriment = list("white chocolate with hazelnut cream" = 1))

/obj/item/reagent_containers/food/snacks/pralines/praline6
	desc = "A tiny, delicious piece of dark chocolate with some sort of filling inside of it."
	icon_state = "praline6"
	filling_color = "#241c17"
	reagent_data = list(/singleton/reagent/nutriment = list("rich dark chocolate with milk chocolate ganache" = 1))

/obj/item/reagent_containers/food/snacks/pralines/praline7
	desc = "A tiny, delicious piece of white chocolate with some sort of filling inside of it."
	icon_state = "praline7"
	filling_color = "#fdf6ba"
	reagent_data = list(/singleton/reagent/nutriment = list("white chocolate with milk chocolate ganache" = 1))

/obj/item/reagent_containers/food/snacks/pralines/praline8
	icon_state = "praline8"
	reagent_data = list(/singleton/reagent/nutriment = list("milk chocolate with white chocolate ganache" = 1))

/obj/item/reagent_containers/food/snacks/pralines/praline9
	desc = "A tiny, delicious piece of dark chocolate with some sort of filling inside of it."
	icon_state = "praline9"
	filling_color = "#241c17"
	reagent_data = list(/singleton/reagent/nutriment = list("rich dark chocolate with white chocolate ganache" = 1))

/obj/item/reagent_containers/food/snacks/pralines/praline10
	desc = "A square made of layers of three chocolates."
	icon_state = "praline10"
	reagent_data = list(/singleton/reagent/nutriment = list("milk, white, and dark chocolate" = 1))
