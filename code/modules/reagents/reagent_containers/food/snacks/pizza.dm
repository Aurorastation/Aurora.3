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

//Deep Dish

ABSTRACT_TYPE(/obj/item/reagent_containers/food/snacks/sliceable/pizza/deepdish/)
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	desc = "If you're seeing this, something has gone wrong."
	slices_num = 6

/obj/item/reagent_containers/food/snacks/sliceable/pizza/deepdish/margherita
	name = "deep dish margherita pizza"
	desc = "Just as New York and Chicago took the concept of pizza from Italy, claimed it as part of their own identity, forever warring about which is better - deep dish or thin crust, so did Biesel, taking the concept of Deep Dish pizza from Chicago and then arguing with the rest of the universe about it."
	icon_state = "deepdish_margherita"
	slice_path = /obj/item/reagent_containers/food/snacks/deepdish/margheritaslice
	filling_color = "#b32b13"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 36, /singleton/reagent/nutriment/protein/cheese = 6, /singleton/reagent/drink/tomatojuice = 9)
	reagent_data = list(/singleton/reagent/nutriment = list("soft dough" = 10, "tomato" = 10, "gooey cheese" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/deepdish/margheritaslice
	name = "deep dish margherita slice"
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	desc = "There are only two places in the spur where you can find an authentic deep dish pizza - Chicago and Biesel."
	icon_state = "deepdish_margherita_slice"
	filling_color = "#b32b13"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/deepdish/mushroom
	name = "deep dish mushroom pizza"
	desc = "Oh boy, it's like a big cake with mushrooms on it! Yummy...?"
	icon_state = "deepdish_mushroom"
	slice_path = /obj/item/reagent_containers/food/snacks/deepdish/mushroom_slice
	filling_color = "#ebd780"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 36, /singleton/reagent/nutriment/protein/cheese = 6, /singleton/reagent/drink/tomatojuice = 9)
	reagent_data = list(/singleton/reagent/nutriment = list("soft dough" = 10, "mushrooms" = 10, "tomato" = 10, "gooey cheese" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/deepdish/mushroom_slice
	name = "deep dish mushroom pizza slice"
	desc = "In a deep dish, there is mushroom for your pizza." //*air horn noise*
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "deepdish_mushroom_slice"
	filling_color = "#ebd780"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/deepdish/pepperoni
	name = "deep dish pepperoni pizza"
	desc = "Wow! Who knew this much cholesterol in one place is legal to sell?"
	icon_state = "deepdish_pepperoni"
	slice_path = /obj/item/reagent_containers/food/snacks/deepdish/pepperoni_slice
	filling_color = "#b32b13"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 30, /singleton/reagent/nutriment/protein= 6, /singleton/reagent/nutriment/protein/cheese = 6, /singleton/reagent/drink/tomatojuice = 9)
	reagent_data = list(/singleton/reagent/nutriment = list("soft dough" = 10, "tomato" = 10, "gooey cheese" = 10), /singleton/reagent/nutriment/protein = list("spicy sausage" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/deepdish/pepperoni_slice
	name = "deep dish pepperoni pizza slice"
	desc = "A thick, cakey slice of pizza with slices of zesty pepperoni on it. Not quite what our Italian ancestors imagined, but delicious nevertheless."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "deepdish_pepperoni_slice"
	filling_color = "#b32b13"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/deepdish/district6
	name = "deep dish district 6 pizza"
	desc = "A dish originating from Mendell's 'Little Adhomai' district. It's a deep dish pizza with slices of earthenroot and roasted dirtberries spread evenly for a bit of extra crunch."
	icon_state = "deepdish_district6"
	slice_path = /obj/item/reagent_containers/food/snacks/deepdish/district6_slice
	filling_color = "#b36813"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 36, /singleton/reagent/nutriment/protein/cheese = 6, /singleton/reagent/drink/tomatojuice = 9)
	reagent_data = list(/singleton/reagent/nutriment = list("soft cheesy dough" = 10, "sweet potato" = 10, "tomato" = 10, "crunchy dirtberries" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/deepdish/district6_slice
	name = "deep dish district 6 pizza slice"
	desc = "A slice of deep dish pizza with earthenroot slices and roast dirtberries on it. A mashup of Tajaran and Human cuisine that could only come from the cultural hub that is Mendell."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "deepdish_district6_slice"
	filling_color = "#b36813"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/deepdish/mendell
	name = "deep dish mendell style pizza"
	desc = "If a pizza place anywhere in the universe has a sign reading 'Mendell style pizza' but the pizza doesn't have bell peppers and anchovies on it, you need to leave."
	icon_state = "deepdish_mendell"
	slice_path = /obj/item/reagent_containers/food/snacks/deepdish/mendell_slice
	filling_color = "#b32b13"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 30, /singleton/reagent/nutriment/protein/cheese = 6, /singleton/reagent/nutriment/protein/seafood = 6, /singleton/reagent/drink/tomatojuice = 9)
	reagent_data = list(/singleton/reagent/nutriment = list("soft cheesy dough" = 10, "tomato" = 10, "peppers" = 8), /singleton/reagent/nutriment/protein/seafood = list("anchovies" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/deepdish/mendell_slice
	name = "deep dish mendell style pizza slice"
	desc = "Anchovies and bell peppers. People from Mendell swear by it. The rest of the universe usually raises an eyebrow and asks for something else."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "deepdish_mendell_slice"
	filling_color = "#b32b13"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)

/obj/item/reagent_containers/food/snacks/sliceable/pizza/deepdish/seafood
	name = "deep dish seafood pizza"
	desc = "A deep dish pizza in the style of Craterview. A mixture of shrimp and onions befitting of only the finest touristy marinas."
	icon_state = "deepdish_seafood"
	slice_path = /obj/item/reagent_containers/food/snacks/deepdish/seafood_slice
	filling_color = "#b32b13"
	center_of_mass = list("x"=16, "y"=11)
	reagents_to_add = list(/singleton/reagent/nutriment = 30, /singleton/reagent/nutriment/protein/cheese = 6, /singleton/reagent/nutriment/protein/seafood = 6, /singleton/reagent/drink/tomatojuice = 9)
	reagent_data = list(/singleton/reagent/nutriment = list("soft cheesy dough" = 10, "tomato" = 10, "onions" = 8), /singleton/reagent/nutriment/protein/seafood = list("shrimp" = 10))
	bitesize = 2

/obj/item/reagent_containers/food/snacks/deepdish/seafood_slice
	name = "deep dish seafood pizza slice"
	desc = "A delicious Craterview-style slice of deep dish pizza for people on a seafood diet. They sea food, they... uh... pizza. Uhm. Yeah, hang on, I need to workshop this one."
	icon = 'icons/obj/item/reagent_containers/food/pizza.dmi'
	icon_state = "deepdish_seafood_slice"
	filling_color = "#b32b13"
	bitesize = 2
	center_of_mass = list("x"=18, "y"=13)
