/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/reagent_containers/food/snacks/sliceable/pizza
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	slices_num = 6
	filling_color = "#BAA14C"

/obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "margherita"
	desc = "The golden standard of pizzas."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "pizzamargherita"
	slice_path = /obj/item/reagent_containers/food/snacks/margheritaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 35, /singleton/reagent/nutriment/protein/cheese = 5, /singleton/reagent/drink/tomatojuice = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 10, "tomato" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/margheritaslice
	name = "margherita slice"
	desc = "A slice of the classic pizza."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "pizzamargheritaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/margheritaslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/protein/cheese = 1, /singleton/reagent/drink/tomatojuice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 5, "tomato" = 5))

/obj/item/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	name = "meatpizza"
	desc = "A pizza with meat topping."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "meatpizza"
	slice_path = /obj/item/reagent_containers/food/snacks/meatpizzaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 10, /singleton/reagent/nutriment/protein = 44, /singleton/reagent/nutriment/protein/cheese = 10, /singleton/reagent/drink/tomatojuice = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 10, "tomato" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/meatpizzaslice
	name = "meatpizza slice"
	desc = "A slice of a meaty pizza."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "meatpizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/meatpizzaslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein = 7, /singleton/reagent/nutriment/protein/cheese = 2, /singleton/reagent/drink/tomatojuice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 5, "tomato" = 5))

/obj/item/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	name = "mushroompizza"
	desc = "Very special pizza."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "mushroompizza"
	slice_path = /obj/item/reagent_containers/food/snacks/mushroompizzaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 35, /singleton/reagent/nutriment/protein/cheese = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 10, "tomato" = 10, "mushroom" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/mushroompizzaslice
	name = "mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "mushroompizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/mushroompizzaslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/protein/cheese = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 5, "tomato" = 5, "mushroom" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	name = "vegetable pizza"
	desc = "No one of Tomato Sapiens were harmed during making this pizza."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "vegetablepizza"
	slice_path = /obj/item/reagent_containers/food/snacks/vegetablepizzaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 25, /singleton/reagent/drink/tomatojuice = 6, /singleton/reagent/oculine = 12)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 10, "eggplant" = 5, "carrot" = 5, "corn" = 5))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/vegetablepizzaslice
	name = "vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "vegetablepizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/vegetablepizzaslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 4, /singleton/reagent/drink/tomatojuice = 2, /singleton/reagent/oculine = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 5, "eggplant" = 5, "carrot" = 5, "corn" = 5))

/obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch
	name = "pizza crunch"
	desc = "This was once a normal pizza, but it has been coated in batter and deep-fried. Whatever toppings it once had are a mystery, but they're still under there, somewhere..."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "pizzacrunch"
	slice_path = /obj/item/reagent_containers/food/snacks/pizzacrunchslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 25, /singleton/reagent/nutriment/coating/batter = 6, /singleton/reagent/nutriment/triglyceride/oil = 4)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 15))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/sliceable/pizza/crunch/Initialize()
	. = ..()
	coating = /singleton/reagent/nutriment/coating/batter

/obj/item/reagent_containers/food/snacks/pizzacrunchslice
	name = "pizza crunch"
	desc = "A little piece of a heart attack. It's toppings are a mystery, hidden under batter"
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "pizzacrunchslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/coating/batter = 2, /singleton/reagent/nutriment/triglyceride/oil = 1)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 5))
	coating = /singleton/reagent/nutriment/coating/batter

/obj/item/reagent_containers/food/snacks/sliceable/pizza/pineapple
	name = "ham & pineapple pizza"
	desc = "One of the most debated pizzas in existence."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "pineapple_pizza"
	slice_path = /obj/item/reagent_containers/food/snacks/pineappleslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 30, /singleton/reagent/nutriment/protein = 4, /singleton/reagent/nutriment/protein/cheese = 5, /singleton/reagent/drink/tomatojuice = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 10, "tomato" = 10, "ham" = 10))
	bitesize = 2
	filling_color = "#BD8939"

/obj/item/reagent_containers/food/snacks/pineappleslice
	name = "ham & pineapple pizza slice"
	desc = "A slice of contraband."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "pineapple_pizza_slice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/pineappleslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 5, "tomato" = 5))

/obj/item/reagent_containers/food/snacks/sliceable/pizza/pepperoni
	name = "pepperoni pizza"
	desc = "Who doesn't love a good pepperoni pizza after a hard day in the Chainlink?"
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "pepperonipizza"
	slice_path = /obj/item/reagent_containers/food/snacks/pepperonipizzaslice
	slices_num = 6
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 10, /singleton/reagent/nutriment/protein = 44, /singleton/reagent/nutriment/protein/cheese = 10, /singleton/reagent/drink/tomatojuice = 6)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 10, "tomato" = 10, "pepperoni" = 15))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/pepperonipizzaslice
	name = "pepperoni pizza slice"
	desc = "A slice of pepperoni pizza."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "pepperonipizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/pepperonipizzaslice/filled
	reagents_to_add = list(/singleton/reagent/nutriment = 2, /singleton/reagent/nutriment/protein = 7, /singleton/reagent/nutriment/protein/cheese = 2, /singleton/reagent/drink/tomatojuice = 2)
	reagent_data = list(/singleton/reagent/nutriment = list("pizza crust" = 5, "tomato" = 5))

/obj/item/reagent_containers/food/snacks/bacon_flatbread // HUH?????
	name = "bacon cheese flatbread"
	desc = "Not a pizza."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "bacon_pizza"
	reagents_to_add = list(/singleton/reagent/nutriment = 5, /singleton/reagent/nutriment/protein = 5)
	reagent_data = list(/singleton/reagent/nutriment = list("flatbread" = 5))
	filling_color = "#BD8939"
