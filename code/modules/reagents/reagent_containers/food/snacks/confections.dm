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

//crepe dishes

/obj/item/reagent_containers/food/snacks/crepe
	name = "crepe"
	desc = "A very thin pancake."
	trash = /obj/item/trash/plate
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	filling_color = "#d4b28b"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/crepe/chocolate
	name = "chocolate crepe"
	desc = "A very thin pancake with some NTella spread in it."
	icon_state = "chocolatecrepe"
	filling_color = "#3d2313"
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/choconutspread = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("dough" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/crepe/chocolatefancy
	name = "fancy chocolate crepe"
	desc = "chocolate crepes, ice cream, blueberries and banana slices. separately they're all cheap snacks from a 10 year old's birthday party snack table. But together they somehow make a really fancy looking dessert."
	icon_state = "chocolatecrepe_fancy"
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/nutriment/choconutspread = 4)
	reagent_data = list(/singleton/reagent/nutriment/choconutspread = list("hazelnutty chocolate" = 10), /singleton/reagent/nutriment = list("banana" = 4, "ice cream" = 4, "dough" = 3))
	filling_color = "#3d2313"
	bitesize = 2

/obj/item/reagent_containers/food/snacks/crepe/whitechocolate
	name = "white chocolate crepe"
	desc = "A very thin pancake with some white chocolate in it."
	icon_state = "whitechocolatecrepe"
	filling_color = "#fffcd3"
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/choconutspread = 4, /singleton/reagent/sugar = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("dough" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/crepe/whitechocolate_fancy
	name = "fancy white chocolate crepe"
	desc = "White chocolate, strawberries and ice cream! Yum yum!"
	icon_state = "whitechocolatecrepe_fancy"
	filling_color = "#fffcd3"
	reagents_to_add = list(/singleton/reagent/nutriment = 6, /singleton/reagent/sugar = 4, /singleton/reagent/nutriment/vanilla = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("white chocolate" = 8, "strawberry" = 5, "dough" = 2))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/crepe/breakfast
	name = "savory breakfast crepe"
	desc = "Cheddar cheese, eggs, crepe."
	icon_state = "savorycrepe"
	filling_color = "#ffe367"
	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("egg" = 6, "cheese" = 7, "chives" = 4))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/crepe/hamcheese
	name = "ham and cheese crepe"
	desc = "For people who look at desserts and think 'this would be better if we took out all the sweet things and replaced them with meat'."
	icon_state = "hamcheesecrepe"
	filling_color = "#e7aac7"
	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("chives" = 2))
	bitesize = 3

/obj/item/reagent_containers/food/snacks/custard
	name = "custard"
	desc = "A lovely dessert that can also be used to make other, much less lazy desserts."
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "custard"
	trash = /obj/item/trash/custard_bowl
	filling_color = "#ebedc2"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/egg = 2, /singleton/reagent/nutriment/glucose = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("custard" = 5))
	bitesize = 2
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'
	is_liquid = TRUE

//Custard + blowtorch = creme brulee
/obj/item/reagent_containers/food/snacks/custard/attackby(obj/item/W, mob/living/user)
	. = ..()
	if(W.iswelder())
		var/obj/item/weldingtool/welder = W
		if(welder.isOn())
			new /obj/item/reagent_containers/food/snacks/creme_brulee(src)
			to_chat(user, "You apply the flame to the sugary custard, caramelizing it.")
			playsound(get_turf(src), 'sound/items/flare.ogg', 100, 1)
			qdel(src)

/obj/item/reagent_containers/food/snacks/creme_brulee
	name = "creme brulee"
	desc = "You know what would makes a nice, sweet dessert better? A BLOWTORCH!"
	icon = 'icons/obj/item/reagent_containers/food/confections.dmi'
	icon_state = "brulee"
	trash = /obj/item/trash/custard_bowl
	filling_color = "#e9c35b"
	reagents_to_add = list(/singleton/reagent/nutriment = 3, /singleton/reagent/nutriment/protein/egg = 1, /singleton/reagent/nutriment/glucose = 2, /singleton/reagent/nutriment/caramel = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("custard" = 5))
	bitesize = 2
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'
